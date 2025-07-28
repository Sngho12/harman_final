`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/21 12:41:04
// Design Name: 
// Module Name: grayscale_converter
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


module grayscale_converter #(
    parameter gray_bitwidth = 8  // 출력 비트 수 (예: 8이면 상위 8비트 사용)
) (
    input  logic [4:0] red_port,
    input  logic [5:0] green_port,
    input  logic [4:0] blue_port,
    output logic [gray_bitwidth-1:0] g_port
);
    logic [15:0] red, green, blue;
    logic [13:0] gray_full;  // 최대값 16022 이하 → 14비트면 충분

    always_comb begin
        red   = (red_port << 1) * 77;    // 5bit → 6bit 확장 후 가중치
        green = green_port * 150;        // 그대로
        blue  = (blue_port << 1) * 29;   // 5bit → 6bit 확장 후 가중치

        gray_full = red + green + blue;

        // 상위 gray_bitwidth 비트만 사용
        g_port = gray_full[13 -: gray_bitwidth];
        // 예: gray_bitwidth = 8 → g_port = gray_full[13:6]
    end

endmodule