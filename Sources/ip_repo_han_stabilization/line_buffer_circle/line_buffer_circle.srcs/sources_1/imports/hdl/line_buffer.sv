`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/20 21:03:16
// Design Name: 
// Module Name: line_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module line_buffer_circle #(
    parameter DATA_SIZE = 16,
    parameter LINE_LENGTH = 640,
    parameter int FRAME_HEIGHT = 480
) (
    input logic pclk,
    input logic [9:0] x_pixel,
    input logic [9:0] y_pixel,
    input logic [DATA_SIZE-1:0] data,
    output logic [DATA_SIZE-1:0] data_00,
    output logic [DATA_SIZE-1:0] data_01,
    output logic [DATA_SIZE-1:0] data_02,
    output logic [DATA_SIZE-1:0] data_03,
    output logic [DATA_SIZE-1:0] data_04,
    output logic [DATA_SIZE-1:0] data_05,
    output logic [DATA_SIZE-1:0] data_06,
    output logic [DATA_SIZE-1:0] data_07,
    output logic [DATA_SIZE-1:0] data_08,
    output logic [DATA_SIZE-1:0] data_09,
    output logic [DATA_SIZE-1:0] data_10,
    output logic [DATA_SIZE-1:0] data_11,
    output logic [DATA_SIZE-1:0] data_12,
    output logic [DATA_SIZE-1:0] data_13,
    output logic [DATA_SIZE-1:0] data_14,
    output logic [DATA_SIZE-1:0] data_15,
    output logic [DATA_SIZE-1:0] data_16,
    output logic [DATA_SIZE-1:0] data_17,
    output logic [DATA_SIZE-1:0] data_18,
    output logic [DATA_SIZE-1:0] data_19,
    output logic [DATA_SIZE-1:0] data_20,
    output logic [DATA_SIZE-1:0] data_21,
    output logic [DATA_SIZE-1:0] data_22,
    output logic [DATA_SIZE-1:0] data_23,
    output logic [DATA_SIZE-1:0] data_24,
    output logic [DATA_SIZE-1:0] data_25,
    output logic [DATA_SIZE-1:0] data_26,
    output logic [DATA_SIZE-1:0] data_27,
    output logic [DATA_SIZE-1:0] data_28
);
    // median filter parameters
    reg [DATA_SIZE-1:0] fmem0[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem1[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem2[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem3[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem4[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem5[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem6[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem7[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] temp[2:0];

    logic [8:0] f_x_pixel;
    logic [8:0] f_y_pixel;
    assign f_x_pixel = x_pixel[9:1];
    assign f_y_pixel = y_pixel[9:1];

    always_ff @(posedge pclk) begin
        if (x_pixel < LINE_LENGTH && y_pixel < FRAME_HEIGHT && (~x_pixel[0]) && (~y_pixel[0])) begin
            temp[0] <= temp[1];
            temp[1] <= temp[2];
            temp[2] <= fmem6[f_x_pixel];
            fmem7[f_x_pixel] <= fmem6[f_x_pixel];
            fmem6[f_x_pixel] <= fmem5[f_x_pixel];
            fmem5[f_x_pixel] <= fmem4[f_x_pixel];
            fmem4[f_x_pixel] <= fmem3[f_x_pixel];
            fmem3[f_x_pixel] <= fmem2[f_x_pixel];
            fmem2[f_x_pixel] <= fmem1[f_x_pixel];
            fmem1[f_x_pixel] <= fmem0[f_x_pixel];
            fmem0[f_x_pixel] <= data;
        end
    end

    always_ff @(posedge pclk) begin
        data_00 <= (f_y_pixel >= 3) ? fmem3[f_x_pixel] : 0;
        data_01 <= (f_y_pixel >= 6) ? fmem6[f_x_pixel] : 0;
        data_02 <= (f_y_pixel >= 6 && f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem6[f_x_pixel+1] : 0;
        data_03 <= (f_y_pixel >= 5 && f_x_pixel <= LINE_LENGTH/2-2 -1) ? fmem5[f_x_pixel+2] : 0;
        data_04 <= (f_y_pixel >= 4 && f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem4[f_x_pixel+3] : 0;
        data_05 <= (f_y_pixel >= 3 && f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem3[f_x_pixel+3] : 0;
        data_06 <= (f_y_pixel >= 2 && f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem2[f_x_pixel+3] : 0;
        data_07 <= (f_y_pixel >= 1 && f_x_pixel <= LINE_LENGTH/2-2 -1) ? fmem1[f_x_pixel+2] : 0;
        data_08 <= (f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem0[f_x_pixel+1] : 0;
        data_09 <= fmem0[f_x_pixel];
        data_10 <= (f_y_pixel >= 1 && f_x_pixel >= 1) ? fmem1[f_x_pixel-1] : 0;
        data_11 <= (f_y_pixel >= 2 && f_x_pixel >= 2) ? fmem2[f_x_pixel-2] : 0;
        data_12 <= (f_y_pixel >= 3 && f_x_pixel >= 3) ? fmem3[f_x_pixel-3] : 0;
        data_13 <= (f_y_pixel >= 4 && f_x_pixel >= 3) ? fmem4[f_x_pixel-3] : 0;
        data_14 <= (f_y_pixel >= 5 && f_x_pixel >= 3) ? fmem5[f_x_pixel-3] : 0;
        data_15 <= (f_y_pixel >= 6 && f_x_pixel >= 2) ? fmem5[f_x_pixel-2] : 0;
        data_16 <= temp[2];

        data_17 <= (f_y_pixel >= 6 && f_x_pixel <= LINE_LENGTH/2-2 -1) ? fmem6[f_x_pixel+2] : 0;
        data_18 <= (f_y_pixel >= 6 && f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem6[f_x_pixel+3] : 0;
        data_19 <= (f_y_pixel >= 5 && f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem5[f_x_pixel+3] : 0;
        data_20 <= (f_y_pixel >= 1 && f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem1[f_x_pixel+3] : 0;
        data_21 <= (f_x_pixel <= LINE_LENGTH/2-3 -1) ? fmem0[f_x_pixel+3] : 0;
        data_22 <= (f_x_pixel <= LINE_LENGTH/2-2 -1) ? fmem0[f_x_pixel+2] : 0;
        data_23 <= (f_y_pixel >= 1 && f_x_pixel >= 2) ? fmem1[f_x_pixel-2] : 0;
        data_24 <= (f_y_pixel >= 1 && f_x_pixel >= 3) ? fmem1[f_x_pixel-3] : 0;
        data_25 <= (f_y_pixel >= 2 && f_x_pixel >= 3) ? fmem2[f_x_pixel-3] : 0;
        data_26 <= (f_y_pixel >= 6 && f_x_pixel >= 3) ? fmem6[f_x_pixel-3] : 0;

        data_27 <= temp[0];
        data_28 <= temp[1];

    end
endmodule
