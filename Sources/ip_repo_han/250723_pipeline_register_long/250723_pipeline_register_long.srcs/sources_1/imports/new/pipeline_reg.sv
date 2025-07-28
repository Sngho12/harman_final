`timescale 1ns / 1ps

module pipeline_reg_32 #(
    parameter DATA_WIDTHS0 = 8,   parameter DATA_WIDTHS1 = 8,   parameter DATA_WIDTHS2 = 8,   parameter DATA_WIDTHS3 = 8,
    parameter DATA_WIDTHS4 = 8,   parameter DATA_WIDTHS5 = 8,   parameter DATA_WIDTHS6 = 8,   parameter DATA_WIDTHS7 = 8,
    parameter DATA_WIDTHS8 = 8,   parameter DATA_WIDTHS9 = 8,   parameter DATA_WIDTHS10 = 8,  parameter DATA_WIDTHS11 = 8,
    parameter DATA_WIDTHS12 = 8,  parameter DATA_WIDTHS13 = 8,  parameter DATA_WIDTHS14 = 8,  parameter DATA_WIDTHS15 = 8,
    parameter DATA_WIDTHS16 = 8,  parameter DATA_WIDTHS17 = 8,  parameter DATA_WIDTHS18 = 8,  parameter DATA_WIDTHS19 = 8,
    parameter DATA_WIDTHS20 = 8,  parameter DATA_WIDTHS21 = 8,  parameter DATA_WIDTHS22 = 8,  parameter DATA_WIDTHS23 = 8,
    parameter DATA_WIDTHS24 = 8,  parameter DATA_WIDTHS25 = 8,  parameter DATA_WIDTHS26 = 8,  parameter DATA_WIDTHS27 = 8,
    parameter DATA_WIDTHS28 = 8,  parameter DATA_WIDTHS29 = 8,  parameter DATA_WIDTHS30 = 8,  parameter DATA_WIDTHS31 = 8,
    parameter ENABLED = 1
) (
    input logic clk,

    input logic [DATA_WIDTHS0-1:0]  din0,   input logic [DATA_WIDTHS1-1:0]  din1,
    input logic [DATA_WIDTHS2-1:0]  din2,   input logic [DATA_WIDTHS3-1:0]  din3,
    input logic [DATA_WIDTHS4-1:0]  din4,   input logic [DATA_WIDTHS5-1:0]  din5,
    input logic [DATA_WIDTHS6-1:0]  din6,   input logic [DATA_WIDTHS7-1:0]  din7,
    input logic [DATA_WIDTHS8-1:0]  din8,   input logic [DATA_WIDTHS9-1:0]  din9,
    input logic [DATA_WIDTHS10-1:0] din10,  input logic [DATA_WIDTHS11-1:0] din11,
    input logic [DATA_WIDTHS12-1:0] din12,  input logic [DATA_WIDTHS13-1:0] din13,
    input logic [DATA_WIDTHS14-1:0] din14,  input logic [DATA_WIDTHS15-1:0] din15,
    input logic [DATA_WIDTHS16-1:0] din16,  input logic [DATA_WIDTHS17-1:0] din17,
    input logic [DATA_WIDTHS18-1:0] din18,  input logic [DATA_WIDTHS19-1:0] din19,
    input logic [DATA_WIDTHS20-1:0] din20,  input logic [DATA_WIDTHS21-1:0] din21,
    input logic [DATA_WIDTHS22-1:0] din22,  input logic [DATA_WIDTHS23-1:0] din23,
    input logic [DATA_WIDTHS24-1:0] din24,  input logic [DATA_WIDTHS25-1:0] din25,
    input logic [DATA_WIDTHS26-1:0] din26,  input logic [DATA_WIDTHS27-1:0] din27,
    input logic [DATA_WIDTHS28-1:0] din28,  input logic [DATA_WIDTHS29-1:0] din29,
    input logic [DATA_WIDTHS30-1:0] din30,  input logic [DATA_WIDTHS31-1:0] din31,

    output logic [DATA_WIDTHS0-1:0]  dout0,   output logic [DATA_WIDTHS1-1:0]  dout1,
    output logic [DATA_WIDTHS2-1:0]  dout2,   output logic [DATA_WIDTHS3-1:0]  dout3,
    output logic [DATA_WIDTHS4-1:0]  dout4,   output logic [DATA_WIDTHS5-1:0]  dout5,
    output logic [DATA_WIDTHS6-1:0]  dout6,   output logic [DATA_WIDTHS7-1:0]  dout7,
    output logic [DATA_WIDTHS8-1:0]  dout8,   output logic [DATA_WIDTHS9-1:0]  dout9,
    output logic [DATA_WIDTHS10-1:0] dout10,  output logic [DATA_WIDTHS11-1:0] dout11,
    output logic [DATA_WIDTHS12-1:0] dout12,  output logic [DATA_WIDTHS13-1:0] dout13,
    output logic [DATA_WIDTHS14-1:0] dout14,  output logic [DATA_WIDTHS15-1:0] dout15,
    output logic [DATA_WIDTHS16-1:0] dout16,  output logic [DATA_WIDTHS17-1:0] dout17,
    output logic [DATA_WIDTHS18-1:0] dout18,  output logic [DATA_WIDTHS19-1:0] dout19,
    output logic [DATA_WIDTHS20-1:0] dout20,  output logic [DATA_WIDTHS21-1:0] dout21,
    output logic [DATA_WIDTHS22-1:0] dout22,  output logic [DATA_WIDTHS23-1:0] dout23,
    output logic [DATA_WIDTHS24-1:0] dout24,  output logic [DATA_WIDTHS25-1:0] dout25,
    output logic [DATA_WIDTHS26-1:0] dout26,  output logic [DATA_WIDTHS27-1:0] dout27,
    output logic [DATA_WIDTHS28-1:0] dout28,  output logic [DATA_WIDTHS29-1:0] dout29,
    output logic [DATA_WIDTHS30-1:0] dout30,  output logic [DATA_WIDTHS31-1:0] dout31
);

    generate
        if (ENABLED >  0) always_ff @(posedge clk) dout0  <= din0;  else always_comb dout0  = '0;
        if (ENABLED >  1) always_ff @(posedge clk) dout1  <= din1;  else always_comb dout1  = '0;
        if (ENABLED >  2) always_ff @(posedge clk) dout2  <= din2;  else always_comb dout2  = '0;
        if (ENABLED >  3) always_ff @(posedge clk) dout3  <= din3;  else always_comb dout3  = '0;
        if (ENABLED >  4) always_ff @(posedge clk) dout4  <= din4;  else always_comb dout4  = '0;
        if (ENABLED >  5) always_ff @(posedge clk) dout5  <= din5;  else always_comb dout5  = '0;
        if (ENABLED >  6) always_ff @(posedge clk) dout6  <= din6;  else always_comb dout6  = '0;
        if (ENABLED >  7) always_ff @(posedge clk) dout7  <= din7;  else always_comb dout7  = '0;
        if (ENABLED >  8) always_ff @(posedge clk) dout8  <= din8;  else always_comb dout8  = '0;
        if (ENABLED >  9) always_ff @(posedge clk) dout9  <= din9;  else always_comb dout9  = '0;
        if (ENABLED > 10) always_ff @(posedge clk) dout10 <= din10; else always_comb dout10 = '0;
        if (ENABLED > 11) always_ff @(posedge clk) dout11 <= din11; else always_comb dout11 = '0;
        if (ENABLED > 12) always_ff @(posedge clk) dout12 <= din12; else always_comb dout12 = '0;
        if (ENABLED > 13) always_ff @(posedge clk) dout13 <= din13; else always_comb dout13 = '0;
        if (ENABLED > 14) always_ff @(posedge clk) dout14 <= din14; else always_comb dout14 = '0;
        if (ENABLED > 15) always_ff @(posedge clk) dout15 <= din15; else always_comb dout15 = '0;
        if (ENABLED > 16) always_ff @(posedge clk) dout16 <= din16; else always_comb dout16 = '0;
        if (ENABLED > 17) always_ff @(posedge clk) dout17 <= din17; else always_comb dout17 = '0;
        if (ENABLED > 18) always_ff @(posedge clk) dout18 <= din18; else always_comb dout18 = '0;
        if (ENABLED > 19) always_ff @(posedge clk) dout19 <= din19; else always_comb dout19 = '0;
        if (ENABLED > 20) always_ff @(posedge clk) dout20 <= din20; else always_comb dout20 = '0;
        if (ENABLED > 21) always_ff @(posedge clk) dout21 <= din21; else always_comb dout21 = '0;
        if (ENABLED > 22) always_ff @(posedge clk) dout22 <= din22; else always_comb dout22 = '0;
        if (ENABLED > 23) always_ff @(posedge clk) dout23 <= din23; else always_comb dout23 = '0;
        if (ENABLED > 24) always_ff @(posedge clk) dout24 <= din24; else always_comb dout24 = '0;
        if (ENABLED > 25) always_ff @(posedge clk) dout25 <= din25; else always_comb dout25 = '0;
        if (ENABLED > 26) always_ff @(posedge clk) dout26 <= din26; else always_comb dout26 = '0;
        if (ENABLED > 27) always_ff @(posedge clk) dout27 <= din27; else always_comb dout27 = '0;
        if (ENABLED > 28) always_ff @(posedge clk) dout28 <= din28; else always_comb dout28 = '0;
        if (ENABLED > 29) always_ff @(posedge clk) dout29 <= din29; else always_comb dout29 = '0;
        if (ENABLED > 30) always_ff @(posedge clk) dout30 <= din30; else always_comb dout30 = '0;
        if (ENABLED > 31) always_ff @(posedge clk) dout31 <= din31; else always_comb dout31 = '0;
    endgenerate

endmodule
