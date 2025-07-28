`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/16 11:08:14
// Design Name: 
// Module Name: Brief_Filter
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


module Brief_Filter #(
    parameter IMAGE_WIDTH = 640,
    parameter IMAGE_LENGTH = 480,
    parameter IMAGE_BITS = 4,
    parameter PATTERN = 120,
    parameter X_WIDTH = 9,
    parameter Y_WIDTH = 9
) (
    input logic clk,
    input logic reset,

    // Fast to Brief
    input logic [X_WIDTH:0] x_coor,
    input logic [Y_WIDTH:0] y_coor,
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

    // Brief to Hamming
    output logic [X_WIDTH:0] cornerX,
    output logic [Y_WIDTH:0] cornerY,
    output logic [PATTERN-1:0] Brief_Descriptor
);
    // patch
    logic [IMAGE_BITS-1:0] Brief_Patch [28:0];

    logic [X_WIDTH:0] next_cornerX;
    logic [Y_WIDTH:0] next_cornerY;
    logic [PATTERN-1:0] next_Brief_Descriptor;

    // corner X,Y
    always_ff @( posedge clk ) begin : blockName
        if (reset) begin
            cornerX <= 0;
            cornerY <= 0;
            Brief_Descriptor <= '0;
        end
        else begin
            cornerX <= next_cornerX;
            cornerY <= next_cornerY;
            Brief_Descriptor <= next_Brief_Descriptor;
        end
    end
    



    // if Corner -> connect wire
    always_comb begin
        Brief_Patch[0]  = F2B_Pixel_Data1;
        Brief_Patch[1]  = F2B_Pixel_Data2;
        Brief_Patch[2]  = F2B_Pixel_Data3;
        Brief_Patch[3]  = F2B_Pixel_Data4;
        Brief_Patch[4]  = F2B_Pixel_Data5;
        Brief_Patch[5]  = F2B_Pixel_Data6;
        Brief_Patch[6]  = F2B_Pixel_Data7;
        Brief_Patch[7]  = F2B_Pixel_Data8;
        Brief_Patch[8]  = F2B_Pixel_Data9;
        Brief_Patch[9]  = F2B_Pixel_Data10;
        Brief_Patch[10] = F2B_Pixel_Data11;
        Brief_Patch[11] = F2B_Pixel_Data12;
        Brief_Patch[12] = F2B_Pixel_Data13;
        Brief_Patch[13] = F2B_Pixel_Data14;
        Brief_Patch[14] = F2B_Pixel_Data15;
        Brief_Patch[15] = F2B_Pixel_Data16;
        Brief_Patch[16] = F2B_Pixel_Data17;
        Brief_Patch[17] = F2B_Pixel_Data18;
        Brief_Patch[18] = F2B_Pixel_Data19;
        Brief_Patch[19] = F2B_Pixel_Data20;
        Brief_Patch[20] = F2B_Pixel_Data21;
        Brief_Patch[21] = F2B_Pixel_Data22;
        Brief_Patch[22] = F2B_Pixel_Data23;
        Brief_Patch[23] = F2B_Pixel_Data24;
        Brief_Patch[24] = F2B_Pixel_Data25;
        Brief_Patch[25] = F2B_Pixel_Data26;
        Brief_Patch[26] = F2B_Pixel_Data27;
        Brief_Patch[27] = F2B_Pixel_Data28;
        Brief_Patch[28] = F2B_Pixel_Data29;
    end

    always_comb begin : BRIEF_COMPARE        
        next_cornerX = cornerX;
        next_cornerY = cornerY;
        next_Brief_Descriptor = Brief_Descriptor;
        if (isCorner) begin
            // Hardcoded comparison pairs (p(A) > p(B))
            next_Brief_Descriptor[0]   = (Brief_Patch[15] > Brief_Patch[21]); // Pair 0: (15, 21)
            next_Brief_Descriptor[1]   = (Brief_Patch[5] > Brief_Patch[10]);  // Pair 1: (5, 10)
            next_Brief_Descriptor[2]   = (Brief_Patch[2] > Brief_Patch[25]);  // Pair 2: (2, 25)
            next_Brief_Descriptor[3]   = (Brief_Patch[18] > Brief_Patch[1]);   // Pair 3: (18, 1)
            next_Brief_Descriptor[4]   = (Brief_Patch[27] > Brief_Patch[0]);   // Pair 4: (27, 0)
            next_Brief_Descriptor[5]   = (Brief_Patch[16] > Brief_Patch[7]);   // Pair 5: (16, 7)
            next_Brief_Descriptor[6]   = (Brief_Patch[22] > Brief_Patch[13]); // Pair 6: (22, 13)
            next_Brief_Descriptor[7]   = (Brief_Patch[4] > Brief_Patch[19]);  // Pair 7: (4, 19)
            next_Brief_Descriptor[8]   = (Brief_Patch[9] > Brief_Patch[26]);  // Pair 8: (9, 26)
            next_Brief_Descriptor[9]   = (Brief_Patch[11] > Brief_Patch[3]);   // Pair 9: (11, 3)
            next_Brief_Descriptor[10]  = (Brief_Patch[20] > Brief_Patch[8]);  // Pair 10: (20, 8)
            next_Brief_Descriptor[11]  = (Brief_Patch[6] > Brief_Patch[14]);  // Pair 11: (6, 14)
            next_Brief_Descriptor[12]  = (Brief_Patch[23] > Brief_Patch[17]); // Pair 12: (23, 17)
            next_Brief_Descriptor[13]  = (Brief_Patch[12] > Brief_Patch[24]); // Pair 13: (12, 24)
            next_Brief_Descriptor[14]  = (Brief_Patch[20] > Brief_Patch[5]);  // Pair 14: (20, 5)
            next_Brief_Descriptor[15]  = (Brief_Patch[3] > Brief_Patch[18]);  // Pair 15: (3, 18)
            next_Brief_Descriptor[16]  = (Brief_Patch[10] > Brief_Patch[27]); // Pair 16: (10, 27)
            next_Brief_Descriptor[17]  = (Brief_Patch[22] > Brief_Patch[1]);   // Pair 17: (22, 1)
            next_Brief_Descriptor[18]  = (Brief_Patch[7] > Brief_Patch[15]);  // Pair 18: (7, 15)
            next_Brief_Descriptor[19]  = (Brief_Patch[25] > Brief_Patch[9]);  // Pair 19: (25, 9)
            next_Brief_Descriptor[20]  = (Brief_Patch[13] > Brief_Patch[2]);   // Pair 20: (13, 2)
            next_Brief_Descriptor[21]  = (Brief_Patch[19] > Brief_Patch[11]); // Pair 21: (19, 11)
            next_Brief_Descriptor[22]  = (Brief_Patch[0] > Brief_Patch[23]);  // Pair 22: (0, 23)
            next_Brief_Descriptor[23]  = (Brief_Patch[8] > Brief_Patch[16]);  // Pair 23: (8, 16)
            next_Brief_Descriptor[24]  = (Brief_Patch[14] > Brief_Patch[4]);  // Pair 24: (14, 4)
            next_Brief_Descriptor[25]  = (Brief_Patch[28] > Brief_Patch[6]);  // Pair 25: (26, 6)
            next_Brief_Descriptor[26]  = (Brief_Patch[21] > Brief_Patch[12]); // Pair 26: (21, 12)
            next_Brief_Descriptor[27]  = (Brief_Patch[1] > Brief_Patch[24]);  // Pair 27: (1, 24)
            next_Brief_Descriptor[28]  = (Brief_Patch[9] > Brief_Patch[17]);  // Pair 28: (9, 17)
            next_Brief_Descriptor[29]  = (Brief_Patch[4] > Brief_Patch[22]);  // Pair 29: (4, 22)
            next_Brief_Descriptor[30]  = (Brief_Patch[12] > Brief_Patch[20]); // Pair 30: (12, 20)
            next_Brief_Descriptor[31]  = (Brief_Patch[6] > Brief_Patch[2]);   // Pair 31: (6, 2)
            next_Brief_Descriptor[32]  = (Brief_Patch[15] > Brief_Patch[10]); // Pair 32: (15, 10)
            next_Brief_Descriptor[33]  = (Brief_Patch[24] > Brief_Patch[5]);  // Pair 33: (24, 5)
            next_Brief_Descriptor[34]  = (Brief_Patch[18] > Brief_Patch[8]);  // Pair 34: (18, 8)
            next_Brief_Descriptor[35]  = (Brief_Patch[3] > Brief_Patch[26]);  // Pair 35: (3, 26)
            next_Brief_Descriptor[36]  = (Brief_Patch[11] > Brief_Patch[0]);  // Pair 36: (11, 0)
            next_Brief_Descriptor[37]  = (Brief_Patch[21] > Brief_Patch[7]);  // Pair 37: (21, 7)
            next_Brief_Descriptor[38]  = (Brief_Patch[14] > Brief_Patch[23]); // Pair 38: (14, 23)
            next_Brief_Descriptor[39]  = (Brief_Patch[25] > Brief_Patch[1]);   // Pair 39: (25, 1)
            next_Brief_Descriptor[40]  = (Brief_Patch[17] > Brief_Patch[13]); // Pair 40: (17, 13)
            next_Brief_Descriptor[41]  = (Brief_Patch[2] > Brief_Patch[19]);  // Pair 41: (2, 19)
            next_Brief_Descriptor[42]  = (Brief_Patch[27] > Brief_Patch[6]);  // Pair 42: (27, 6)
            next_Brief_Descriptor[43]  = (Brief_Patch[9] > Brief_Patch[20]);  // Pair 43: (9, 20)
            next_Brief_Descriptor[44]  = (Brief_Patch[5] > Brief_Patch[16]);  // Pair 44: (5, 16)
            next_Brief_Descriptor[45]  = (Brief_Patch[13] > Brief_Patch[22]); // Pair 45: (13, 22)
            next_Brief_Descriptor[46]  = (Brief_Patch[1] > Brief_Patch[8]);   // Pair 46: (1, 8)
            next_Brief_Descriptor[47]  = (Brief_Patch[18] > Brief_Patch[25]); // Pair 47: (18, 25)
            next_Brief_Descriptor[48]  = (Brief_Patch[7] > Brief_Patch[14]);  // Pair 48: (7, 14)
            next_Brief_Descriptor[49]  = (Brief_Patch[23] > Brief_Patch[4]);  // Pair 49: (23, 4)
            next_Brief_Descriptor[50]  = (Brief_Patch[16] > Brief_Patch[27]); // Pair 50: (16, 27)
            next_Brief_Descriptor[51]  = (Brief_Patch[11] > Brief_Patch[6]);  // Pair 51: (11, 6)
            next_Brief_Descriptor[52]  = (Brief_Patch[20] > Brief_Patch[3]);  // Pair 52: (20, 3)
            next_Brief_Descriptor[53]  = (Brief_Patch[0] > Brief_Patch[10]);  // Pair 53: (0, 10)
            next_Brief_Descriptor[54]  = (Brief_Patch[12] > Brief_Patch[21]); // Pair 54: (12, 21)
            next_Brief_Descriptor[55]  = (Brief_Patch[28] > Brief_Patch[15]); // Pair 55: (24, 15)
            next_Brief_Descriptor[56]  = (Brief_Patch[19] > Brief_Patch[9]);  // Pair 56: (19, 9)
            next_Brief_Descriptor[57]  = (Brief_Patch[26] > Brief_Patch[17]); // Pair 57: (26, 17)
            next_Brief_Descriptor[58]  = (Brief_Patch[8] > Brief_Patch[5]);   // Pair 58: (8, 5)
            next_Brief_Descriptor[59]  = (Brief_Patch[22] > Brief_Patch[14]); // Pair 59: (22, 14)
            next_Brief_Descriptor[60]  = (Brief_Patch[3] > Brief_Patch[11]);  // Pair 60: (3, 11)
            next_Brief_Descriptor[61]  = (Brief_Patch[17] > Brief_Patch[20]); // Pair 61: (17, 20)
            next_Brief_Descriptor[62]  = (Brief_Patch[6] > Brief_Patch[25]);  // Pair 62: (6, 25)
            next_Brief_Descriptor[63]  = (Brief_Patch[10] > Brief_Patch[1]);   // Pair 63: (10, 1)
            next_Brief_Descriptor[64]  = (Brief_Patch[21] > Brief_Patch[18]); // Pair 64: (21, 18)
            next_Brief_Descriptor[65]  = (Brief_Patch[5] > Brief_Patch[13]);  // Pair 65: (5, 13)
            next_Brief_Descriptor[66]  = (Brief_Patch[15] > Brief_Patch[0]);  // Pair 66: (15, 0)
            next_Brief_Descriptor[67]  = (Brief_Patch[24] > Brief_Patch[9]);  // Pair 67: (24, 9)
            next_Brief_Descriptor[68]  = (Brief_Patch[7] > Brief_Patch[27]);  // Pair 68: (7, 27)
            next_Brief_Descriptor[69]  = (Brief_Patch[2] > Brief_Patch[16]);  // Pair 69: (2, 16)
            next_Brief_Descriptor[70]  = (Brief_Patch[14] > Brief_Patch[19]); // Pair 70: (14, 19)
            next_Brief_Descriptor[71]  = (Brief_Patch[28] > Brief_Patch[8]);  // Pair 71: (23, 8)
            next_Brief_Descriptor[72]  = (Brief_Patch[12] > Brief_Patch[4]);  // Pair 72: (12, 4)
            next_Brief_Descriptor[73]  = (Brief_Patch[20] > Brief_Patch[26]); // Pair 73: (20, 26)
            next_Brief_Descriptor[74]  = (Brief_Patch[1] > Brief_Patch[22]);  // Pair 74: (1, 22)
            next_Brief_Descriptor[75]  = (Brief_Patch[11] > Brief_Patch[7]);  // Pair 75: (11, 7)
            next_Brief_Descriptor[76]  = (Brief_Patch[18] > Brief_Patch[3]);  // Pair 76: (18, 3)
            next_Brief_Descriptor[77]  = (Brief_Patch[27] > Brief_Patch[12]); // Pair 77: (27, 12)
            next_Brief_Descriptor[78]  = (Brief_Patch[6] > Brief_Patch[15]);  // Pair 78: (6, 15)
            next_Brief_Descriptor[79]  = (Brief_Patch[13] > Brief_Patch[24]); // Pair 79: (13, 24)
            next_Brief_Descriptor[80]  = (Brief_Patch[0] > Brief_Patch[21]);  // Pair 80: (0, 21)
            next_Brief_Descriptor[81]  = (Brief_Patch[10] > Brief_Patch[19]); // Pair 81: (10, 19)
            next_Brief_Descriptor[82]  = (Brief_Patch[17] > Brief_Patch[5]);  // Pair 82: (17, 5)
            next_Brief_Descriptor[83]  = (Brief_Patch[25] > Brief_Patch[14]); // Pair 83: (25, 14)
            next_Brief_Descriptor[84]  = (Brief_Patch[9] > Brief_Patch[2]);   // Pair 84: (9, 2)
            next_Brief_Descriptor[85]  = (Brief_Patch[16] > Brief_Patch[23]); // Pair 85: (16, 23)
            next_Brief_Descriptor[86]  = (Brief_Patch[4] > Brief_Patch[20]);  // Pair 86: (4, 20)
            next_Brief_Descriptor[87]  = (Brief_Patch[22] > Brief_Patch[11]); // Pair 87: (22, 11)
            next_Brief_Descriptor[88]  = (Brief_Patch[8] > Brief_Patch[1]);   // Pair 88: (8, 1)
            next_Brief_Descriptor[89]  = (Brief_Patch[28] > Brief_Patch[18]); // Pair 89: (26, 18)
            next_Brief_Descriptor[90]  = (Brief_Patch[3] > Brief_Patch[10]);  // Pair 90: (3, 10)
            next_Brief_Descriptor[91]  = (Brief_Patch[14] > Brief_Patch[6]);  // Pair 91: (14, 6)
            next_Brief_Descriptor[92]  = (Brief_Patch[21] > Brief_Patch[13]); // Pair 92: (21, 13)
            next_Brief_Descriptor[93]  = (Brief_Patch[2] > Brief_Patch[27]);  // Pair 93: (2, 27)
            next_Brief_Descriptor[94]  = (Brief_Patch[19] > Brief_Patch[8]);  // Pair 94: (19, 8)
            next_Brief_Descriptor[95]  = (Brief_Patch[7] > Brief_Patch[24]);  // Pair 95: (7, 24)
            next_Brief_Descriptor[96]  = (Brief_Patch[12] > Brief_Patch[17]); // Pair 96: (12, 17)
            next_Brief_Descriptor[97]  = (Brief_Patch[23] > Brief_Patch[5]);  // Pair 97: (23, 5)
            next_Brief_Descriptor[98]  = (Brief_Patch[15] > Brief_Patch[26]); // Pair 98: (15, 26)
            next_Brief_Descriptor[99]  = (Brief_Patch[1] > Brief_Patch[20]);  // Pair 99: (1, 20)
            next_Brief_Descriptor[100] = (Brief_Patch[11] > Brief_Patch[9]);  // Pair 100: (11, 9)
            next_Brief_Descriptor[101] = (Brief_Patch[18] > Brief_Patch[4]);  // Pair 101: (18, 4)
            next_Brief_Descriptor[102] = (Brief_Patch[25] > Brief_Patch[0]);  // Pair 102: (25, 0)
            next_Brief_Descriptor[103] = (Brief_Patch[10] > Brief_Patch[22]); // Pair 103: (10, 22)
            next_Brief_Descriptor[104] = (Brief_Patch[0] > Brief_Patch[28]);  // Pair 104: (0, 13)
            next_Brief_Descriptor[105] = (Brief_Patch[8] > Brief_Patch[26]);  // Pair 105: (8, 26)
            next_Brief_Descriptor[106] = (Brief_Patch[17] > Brief_Patch[3]);  // Pair 106: (17, 3)
            next_Brief_Descriptor[107] = (Brief_Patch[24] > Brief_Patch[11]); // Pair 107: (24, 11)
            next_Brief_Descriptor[108] = (Brief_Patch[5] > Brief_Patch[21]);  // Pair 108: (5, 21)
            next_Brief_Descriptor[109] = (Brief_Patch[14] > Brief_Patch[2]);  // Pair 109: (14, 2)
            next_Brief_Descriptor[110] = (Brief_Patch[20] > Brief_Patch[15]); // Pair 110: (20, 15)
            next_Brief_Descriptor[111] = (Brief_Patch[7] > Brief_Patch[23]);  // Pair 111: (7, 23)
            next_Brief_Descriptor[112] = (Brief_Patch[27] > Brief_Patch[18]); // Pair 112: (27, 18)
            next_Brief_Descriptor[113] = (Brief_Patch[13] > Brief_Patch[9]);  // Pair 113: (13, 9)
            next_Brief_Descriptor[114] = (Brief_Patch[6] > Brief_Patch[19]);  // Pair 114: (6, 19)
            next_Brief_Descriptor[115] = (Brief_Patch[22] > Brief_Patch[1]);  // Pair 115: (22, 1)
            next_Brief_Descriptor[116] = (Brief_Patch[16] > Brief_Patch[12]); // Pair 116: (16, 12)
            next_Brief_Descriptor[117] = (Brief_Patch[3] > Brief_Patch[25]);  // Pair 117: (3, 25)
            next_Brief_Descriptor[118] = (Brief_Patch[19] > Brief_Patch[4]);  // Pair 118: (19, 4)
            next_Brief_Descriptor[119] = (Brief_Patch[1] > Brief_Patch[9]);   // Pair 119: (1, 9)

            next_cornerX = x_coor;
            next_cornerY = y_coor;
        end
    end

endmodule
