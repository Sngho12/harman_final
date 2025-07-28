`timescale 1ns / 1ps

module OV7670_VGA_Driver #(
    parameter v_counter_preload = 0,
    parameter mode = "NORMAL"
) (
    input  logic       clk,
    input  logic       reset,
    output logic       ov7670_xclk,
    input  logic       ov7670_pclk,
    input  logic       ov7670_href,
    input  logic       ov7670_v_sync,
    input  logic [7:0] ov7670_data,

    output logic       h_sync,
    output logic       v_sync,
    output logic       DE,
    output logic [9:0] x_pixel,
    output logic [9:0] y_pixel,
    output logic [4:0] red_port,
    output logic [5:0] green_port,
    output logic [4:0] blue_port,

    output logic sda,
    output logic scl,

    output pclk
);
    logic we, w_rclk, oe, rclk;
    logic [15:0] wData, rData;
    logic [16:0] wAddr, rAddr;
    logic frame_stop;
    //// s0
    logic [9:0] x_pixel_s0, y_pixel_s0;
    logic DE_s0;
    logic h_sync_s0, v_sync_s0;
    /// s1
    logic [4:0] r_s1;
    logic [5:0] g_s1;
    logic [4:0] b_s1;
    logic [9:0] x_pixel_s1, y_pixel_s1;
    logic DE_s1;
    logic h_sync_s1, v_sync_s1;

    assign h_sync = h_sync_s1;
    assign v_sync = v_sync_s1;
    assign DE = DE_s1;
    assign x_pixel = x_pixel_s1;
    assign y_pixel = y_pixel_s1;
    assign red_port = DE_s1 ? r_s1 : 0;
    assign green_port = DE_s1 ? g_s1 : 0;
    assign blue_port = DE_s1 ? b_s1 : 0;

    SCCB_Master #(
        .mode(mode)
    ) U_SCCB_Master (
        .clk  (clk),
        .reset(reset),
        .sda  (sda),
        .scl  (scl)
    );

    pixel_clk_gen U_OV7670_Clk_Gen (
        .clk  (clk),
        .reset(reset),
        .pclk (ov7670_xclk)
    );

    VGA_Controller #(
        .v_counter_preload(v_counter_preload)
    ) U_VGA_Controller (
        .clk    (clk),
        .reset  (reset),
        .rclk   (w_rclk),      // = clk
        .h_sync (h_sync_s0),
        .v_sync (v_sync_s0),
        .DE     (DE_s0),
        .x_pixel(x_pixel_s0),
        .y_pixel(y_pixel_s0),
        .pclk   (pclk)
    );

    QVGA_Memcontroller U_QVGA_Memcontroller (
        .clk       (w_rclk),
        .x_pixel   (x_pixel_s0),
        .y_pixel   (y_pixel_s0),
        .DE        (DE_s0),
        .rclk      (rclk),        // = clk
        .d_en      (oe),
        .rAddr     (rAddr),
        .rData     (rData),
        .red_port  (r_s1),
        .green_port(g_s1),
        .blue_port (b_s1)
    );

    frame_buffer U_frame_buffer (
        .wclk      (ov7670_pclk),
        .we        (we),
        .frame_stop(0),
        .wAddr     (wAddr),
        .wData     (wData),
        .rclk      (rclk),
        .oe        (oe),
        .rAddr     (rAddr),
        .rData     (rData)
    );

    OV7670_MemController U_OV7670_MemController (
        .pclk       (ov7670_pclk),
        .reset      (reset),
        .href       (ov7670_href),
        .v_sync     (ov7670_v_sync),
        .ov7670_data(ov7670_data),
        .we         (we),
        .wAddr      (wAddr),
        .wData      (wData)
    );

    pipeline_register_s0_s1 U_pipeline_register_s0_s1 (
        .pclk      (pclk),
        .DE_s0     (DE_s0),
        .v_sync_s0 (v_sync_s0),
        .h_sync_s0 (h_sync_s0),
        .x_pixel_s0(x_pixel_s0),
        .y_pixel_s0(y_pixel_s0),
        .DE_s1     (DE_s1),
        .v_sync_s1 (v_sync_s1),
        .h_sync_s1 (h_sync_s1),
        .x_pixel_s1(x_pixel_s1),
        .y_pixel_s1(y_pixel_s1)
    );
endmodule
