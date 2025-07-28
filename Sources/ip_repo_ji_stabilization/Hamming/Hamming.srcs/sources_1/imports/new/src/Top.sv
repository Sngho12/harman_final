`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/21 19:10:52
// Design Name: 
// Module Name: Top
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


module Top #(
    parameter X_WIDTH = 9,
    parameter Y_WIDTH = 9,
    parameter PATTERN = 120,
    parameter IMAGE_BITS = 8
)(
    input  logic clk,
    input  logic reset,
    output logic pair_valid,
    output logic pair_done,
    output logic [X_WIDTH:0] current_feature_X,
    output logic [Y_WIDTH:0] current_feature_Y,
    output logic [X_WIDTH:0] prev_feature_X,
    output logic [Y_WIDTH:0] prev_feature_Y,
    input logic isCorner,
    // Pixel data
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data1,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data2,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data3,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data4,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data5,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data6,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data7,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data8,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data9,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data10,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data11,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data12,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data13,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data14,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data15,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data16,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data17,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data18,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data19,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data20,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data21,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data22,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data23,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data24,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data25,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data26,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data27,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data28,
    input logic [IMAGE_BITS-1:0] F2B_Pixel_Data29,
    input logic [X_WIDTH:0] x_coor,
    input logic [Y_WIDTH:0] y_coor
);


    // Current place
    // Brief to Hamming
    logic [X_WIDTH:0] cornerX;
    logic [Y_WIDTH:0] cornerY;
    logic [PATTERN-1:0] Brief_Descriptor;
    // Hamming to RANSAC

    Hamming_Processor #(.X_WIDTH(X_WIDTH), .Y_WIDTH(Y_WIDTH)) U_HAMMING(.*);

    Brief_Filter U_BRIEF (.*);


endmodule
