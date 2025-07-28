`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/21 11:37:56
// Design Name: 
// Module Name: FAST_filter
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


module fast_corner_filter #(
    parameter DATA_WIDTH = 16,
    parameter CONSECUTIVE_P = 12,
    parameter CONSECUTIVE_N = 3,
    parameter THRES_CONTRAST = 500,
    parameter FRAME_HEIGHT = 480,
    parameter LINE_LENGTH = 640,
    parameter EDGE_MARGIN_X = 30,
    parameter EDGE_MARGIN_Y = 30
) (
    input logic [9:0] x_pixel,
    input logic [9:0] y_pixel,
    input logic [DATA_WIDTH-1:0] i_data00,
    input logic [DATA_WIDTH-1:0] i_data01,
    input logic [DATA_WIDTH-1:0] i_data02,
    input logic [DATA_WIDTH-1:0] i_data03,
    input logic [DATA_WIDTH-1:0] i_data04,
    input logic [DATA_WIDTH-1:0] i_data05,
    input logic [DATA_WIDTH-1:0] i_data06,
    input logic [DATA_WIDTH-1:0] i_data07,
    input logic [DATA_WIDTH-1:0] i_data08,
    input logic [DATA_WIDTH-1:0] i_data09,
    input logic [DATA_WIDTH-1:0] i_data10,
    input logic [DATA_WIDTH-1:0] i_data11,
    input logic [DATA_WIDTH-1:0] i_data12,
    input logic [DATA_WIDTH-1:0] i_data13,
    input logic [DATA_WIDTH-1:0] i_data14,
    input logic [DATA_WIDTH-1:0] i_data15,
    input logic [DATA_WIDTH-1:0] i_data16,
    input logic [DATA_WIDTH-1:0] i_data17,
    input logic [DATA_WIDTH-1:0] i_data18,
    input logic [DATA_WIDTH-1:0] i_data19,
    input logic [DATA_WIDTH-1:0] i_data20,
    input logic [DATA_WIDTH-1:0] i_data21,
    input logic [DATA_WIDTH-1:0] i_data22,
    input logic [DATA_WIDTH-1:0] i_data23,
    input logic [DATA_WIDTH-1:0] i_data24,
    input logic [DATA_WIDTH-1:0] i_data25,
    input logic [DATA_WIDTH-1:0] i_data26,
    input logic [DATA_WIDTH-1:0] i_data27,
    input logic [DATA_WIDTH-1:0] i_data28,

    output logic [DATA_WIDTH-1:0] o_data00,
    output logic [DATA_WIDTH-1:0] o_data01,
    output logic [DATA_WIDTH-1:0] o_data02,
    output logic [DATA_WIDTH-1:0] o_data03,
    output logic [DATA_WIDTH-1:0] o_data04,
    output logic [DATA_WIDTH-1:0] o_data05,
    output logic [DATA_WIDTH-1:0] o_data06,
    output logic [DATA_WIDTH-1:0] o_data07,
    output logic [DATA_WIDTH-1:0] o_data08,
    output logic [DATA_WIDTH-1:0] o_data09,
    output logic [DATA_WIDTH-1:0] o_data10,
    output logic [DATA_WIDTH-1:0] o_data11,
    output logic [DATA_WIDTH-1:0] o_data12,
    output logic [DATA_WIDTH-1:0] o_data13,
    output logic [DATA_WIDTH-1:0] o_data14,
    output logic [DATA_WIDTH-1:0] o_data15,
    output logic [DATA_WIDTH-1:0] o_data16,
    output logic [DATA_WIDTH-1:0] o_data17,
    output logic [DATA_WIDTH-1:0] o_data18,
    output logic [DATA_WIDTH-1:0] o_data19,
    output logic [DATA_WIDTH-1:0] o_data20,
    output logic [DATA_WIDTH-1:0] o_data21,
    output logic [DATA_WIDTH-1:0] o_data22,
    output logic [DATA_WIDTH-1:0] o_data23,
    output logic [DATA_WIDTH-1:0] o_data24,
    output logic [DATA_WIDTH-1:0] o_data25,
    output logic [DATA_WIDTH-1:0] o_data26,
    output logic [DATA_WIDTH-1:0] o_data27,
    output logic [DATA_WIDTH-1:0] o_data28,
    output logic [DATA_WIDTH+4-1:0] score,
    output logic is_dark_corner,
    output logic is_bright_corner
);
    assign o_data00 = i_data00;
    assign o_data01 = i_data01;
    assign o_data02 = i_data02;
    assign o_data03 = i_data03;
    assign o_data04 = i_data04;
    assign o_data05 = i_data05;
    assign o_data06 = i_data06;
    assign o_data07 = i_data07;
    assign o_data08 = i_data08;
    assign o_data09 = i_data09;
    assign o_data10 = i_data10;
    assign o_data11 = i_data11;
    assign o_data12 = i_data12;
    assign o_data13 = i_data13;
    assign o_data14 = i_data14;
    assign o_data15 = i_data15;
    assign o_data16 = i_data16;
    assign o_data17 = i_data17;
    assign o_data18 = i_data18;
    assign o_data19 = i_data19;
    assign o_data20 = i_data20;
    assign o_data21 = i_data21;
    assign o_data22 = i_data22;
    assign o_data23 = i_data23;
    assign o_data24 = i_data24;
    assign o_data25 = i_data25;
    assign o_data26 = i_data26;
    assign o_data27 = i_data27;
    assign o_data28 = i_data28;

    logic [DATA_WIDTH-1:0] center;
    assign center = i_data00;
    logic [DATA_WIDTH-1:0] circle[0:15];
    assign circle[0]  = i_data01;
    assign circle[1]  = i_data02;
    assign circle[2]  = i_data03;
    assign circle[3]  = i_data04;
    assign circle[4]  = i_data05;
    assign circle[5]  = i_data06;
    assign circle[6]  = i_data07;
    assign circle[7]  = i_data08;
    assign circle[8]  = i_data09;
    assign circle[9]  = i_data10;
    assign circle[10] = i_data11;
    assign circle[11] = i_data12;
    assign circle[12] = i_data13;
    assign circle[13] = i_data14;
    assign circle[14] = i_data15;
    assign circle[15] = i_data16;

    logic brighter[15:0];
    logic darker  [15:0];
    logic [15:0] brighter_mask, darker_mask;
    logic [31:0] brighter_ext, darker_ext;
    logic [15:0] bright_corner, dark_corner;

    always_comb begin
        for (int i = 0; i < 16; i++) begin
            brighter[i] = (circle[i] > center + THRES_CONTRAST);
            darker[i] = (circle[i] < center - THRES_CONTRAST);
            brighter_mask[i] = brighter[i];
            darker_mask[i] = darker[i];
        end

        brighter_ext = {brighter_mask, brighter_mask};
        darker_ext   = {darker_mask, darker_mask};

        for (int j = 0; j < 16; j++) begin
            bright_corner[j] = (brighter_ext[j +: CONSECUTIVE_P] == {CONSECUTIVE_P{1'b1}}) &&
                           (brighter_ext[j + CONSECUTIVE_P +: CONSECUTIVE_N] == {CONSECUTIVE_N{1'b0}});
            dark_corner[j]   = (darker_ext[j +: CONSECUTIVE_P] == {CONSECUTIVE_P{1'b1}}) &&
                           (darker_ext[j + CONSECUTIVE_P +: CONSECUTIVE_N] == {CONSECUTIVE_N{1'b0}});
        end

        is_bright_corner = 0;
        is_dark_corner = 0;
        score = 0;

        if ((x_pixel < EDGE_MARGIN_X) || (x_pixel > LINE_LENGTH - EDGE_MARGIN_X) ||
        (y_pixel < EDGE_MARGIN_Y) || (y_pixel > FRAME_HEIGHT - EDGE_MARGIN_Y)) begin
            // No corner in margin
            is_bright_corner = 0;
            is_dark_corner = 0;
            score = 0;
        end else begin
            if (|bright_corner || |dark_corner) begin
                logic [DATA_WIDTH+4-1:0] tmp_score;
                tmp_score = 0;
                for (int i = 0; i < 16; i++) begin
                    if (brighter[i]) tmp_score += (circle[i] - center);
                    if (darker[i]) tmp_score += (center - circle[i]);
                end
                score = tmp_score;
                is_bright_corner = |bright_corner;
                is_dark_corner = |dark_corner;
            end
        end
    end
endmodule
