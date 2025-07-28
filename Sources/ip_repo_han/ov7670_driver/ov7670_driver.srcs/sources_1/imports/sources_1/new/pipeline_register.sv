`timescale 1ns / 1ps

module pipeline_register_s0_s1 (
    input  logic       pclk,
    input  logic       DE_s0,
    input  logic       v_sync_s0,
    input  logic       h_sync_s0,
    input  logic [9:0] x_pixel_s0,
    input  logic [9:0] y_pixel_s0,
    output logic       DE_s1,
    output logic       v_sync_s1,
    output logic       h_sync_s1,
    output logic [9:0] x_pixel_s1,
    output logic [9:0] y_pixel_s1
);
    always_ff @(posedge pclk) begin
        DE_s1      <= DE_s0;
        v_sync_s1  <= v_sync_s0;
        h_sync_s1  <= h_sync_s0;
        x_pixel_s1 <= x_pixel_s0;
        y_pixel_s1 <= y_pixel_s0;
    end
endmodule