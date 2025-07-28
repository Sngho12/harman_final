`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/25 10:44:58
// Design Name: 
// Module Name: xy_frame_buffer
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


module xy_frame_buffer (
    input logic wclk,
    input logic we,
    input logic [9:0] x_pixel,
    input logic [9:0] y_pixel,
    input logic [9:0] modified_x_pixel,
    input logic [9:0] modified_y_pixel,
    input logic [15:0] wData,

    input logic rclk,
    input logic oe,
    output logic [15:0] rData
);
    logic [15:0] mem[0:(320*240) - 1];
    logic [16:0] wAddr;
    logic [16:0] rAddr;
    assign wAddr = ((x_pixel>0) && (x_pixel<640) && (y_pixel >0) && (y_pixel<480)) ? x_pixel[9:1] + 320 * y_pixel[9:1] : 0;
    assign rAddr = ((modified_x_pixel>0) && (modified_x_pixel<640) && (modified_y_pixel >0) && (modified_y_pixel<480)) ? modified_x_pixel[9:1] + 320 * modified_y_pixel[9:1]: 0;
    always_ff @(posedge wclk) begin : write
        if (we) begin
            mem[wAddr] <= wData;
        end else begin
            mem[wAddr] <= mem[wAddr];
        end
    end

    always_ff @(posedge rclk) begin : read
        if (oe) begin
            if (rAddr == 0) begin
                rData = 0;
            end else begin
                rData = mem[rAddr];
            end
        end else begin
            rData = 0;
        end
    end

endmodule
