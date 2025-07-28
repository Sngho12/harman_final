`timescale 1ns / 1ps

module tb_fast_corner_filter;

    localparam DATA_WIDTH = 16;

    logic [9:0] x_pixel;
    logic [DATA_WIDTH-1:0] i_data00;
    logic [DATA_WIDTH-1:0] i_data01;
    logic [DATA_WIDTH-1:0] i_data02;
    logic [DATA_WIDTH-1:0] i_data03;
    logic [DATA_WIDTH-1:0] i_data04;
    logic [DATA_WIDTH-1:0] i_data05;
    logic [DATA_WIDTH-1:0] i_data06;
    logic [DATA_WIDTH-1:0] i_data07;
    logic [DATA_WIDTH-1:0] i_data08;
    logic [DATA_WIDTH-1:0] i_data09;
    logic [DATA_WIDTH-1:0] i_data10;
    logic [DATA_WIDTH-1:0] i_data11;
    logic [DATA_WIDTH-1:0] i_data12;
    logic [DATA_WIDTH-1:0] i_data13;
    logic [DATA_WIDTH-1:0] i_data14;
    logic [DATA_WIDTH-1:0] i_data15;
    logic [DATA_WIDTH-1:0] i_data16;
    logic [DATA_WIDTH-1:0] i_data17;
    logic [DATA_WIDTH-1:0] i_data18;
    logic [DATA_WIDTH-1:0] i_data19;
    logic [DATA_WIDTH-1:0] i_data20;
    logic [DATA_WIDTH-1:0] i_data21;
    logic [DATA_WIDTH-1:0] i_data22;
    logic [DATA_WIDTH-1:0] i_data23;
    logic [DATA_WIDTH-1:0] i_data24;
    logic [DATA_WIDTH-1:0] i_data25;
    logic [DATA_WIDTH-1:0] i_data26;
    logic [DATA_WIDTH-1:0] i_data27;
    logic [DATA_WIDTH-1:0] i_data28;

    logic [DATA_WIDTH-1:0] o_data00, o_data01, o_data02, o_data03, o_data04, o_data05, o_data06, o_data07, o_data08;
    logic [DATA_WIDTH-1:0] o_data09, o_data10, o_data11, o_data12, o_data13, o_data14, o_data15, o_data16, o_data17;
    logic [DATA_WIDTH-1:0] o_data18, o_data19, o_data20, o_data21, o_data22, o_data23, o_data24, o_data25, o_data26;
    logic [DATA_WIDTH-1:0] o_data27, o_data28;

    logic is_corner;

    // DUT 연결
    fast_corner_filter #(
        .DATA_WIDTH(DATA_WIDTH),
        .CONSECUTIVE(12),
        .THRESH(20)
    ) dut (
        .x_pixel(x_pixel),
        .i_data00(i_data00), .i_data01(i_data01), .i_data02(i_data02), .i_data03(i_data03), .i_data04(i_data04),
        .i_data05(i_data05), .i_data06(i_data06), .i_data07(i_data07), .i_data08(i_data08), .i_data09(i_data09),
        .i_data10(i_data10), .i_data11(i_data11), .i_data12(i_data12), .i_data13(i_data13), .i_data14(i_data14),
        .i_data15(i_data15), .i_data16(i_data16), .i_data17(i_data17), .i_data18(i_data18), .i_data19(i_data19),
        .i_data20(i_data20), .i_data21(i_data21), .i_data22(i_data22), .i_data23(i_data23), .i_data24(i_data24),
        .i_data25(i_data25), .i_data26(i_data26), .i_data27(i_data27), .i_data28(i_data28),

        .o_data00(o_data00), .o_data01(o_data01), .o_data02(o_data02), .o_data03(o_data03), .o_data04(o_data04),
        .o_data05(o_data05), .o_data06(o_data06), .o_data07(o_data07), .o_data08(o_data08), .o_data09(o_data09),
        .o_data10(o_data10), .o_data11(o_data11), .o_data12(o_data12), .o_data13(o_data13), .o_data14(o_data14),
        .o_data15(o_data15), .o_data16(o_data16), .o_data17(o_data17), .o_data18(o_data18), .o_data19(o_data19),
        .o_data20(o_data20), .o_data21(o_data21), .o_data22(o_data22), .o_data23(o_data23), .o_data24(o_data24),
        .o_data25(o_data25), .o_data26(o_data26), .o_data27(o_data27), .o_data28(o_data28),
        .is_corner(is_corner)
    );

    initial begin
        x_pixel = 10'd2;
        i_data00 = 16'd100; // center pixel

        i_data01 = 16'd130; i_data02 = 16'd135; i_data03 = 16'd140; i_data04 = 16'd138;
        i_data05 = 16'd137; i_data06 = 16'd139; i_data07 = 16'd141; i_data08 = 16'd136;
        i_data09 = 16'd133; i_data10 = 16'd134; i_data11 = 16'd136; i_data12 = 16'd137;
        i_data13 = 16'd140; i_data14 = 16'd142; i_data15 = 16'd143; i_data16 = 16'd145;

        // 나머지는 아무 값이나 채움
        i_data17 = 16'd0;  i_data18 = 16'd0;  i_data19 = 16'd0;  i_data20 = 16'd0;
        i_data21 = 16'd0;  i_data22 = 16'd0;  i_data23 = 16'd0;  i_data24 = 16'd0;
        i_data25 = 16'd0;  i_data26 = 16'd0;  i_data27 = 16'd0;  i_data28 = 16'd0;

        #10;
        $display("is_corner = %b", is_corner);
        $finish;
    end

endmodule
