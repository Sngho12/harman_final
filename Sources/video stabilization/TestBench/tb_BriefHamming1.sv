`timescale 1ns / 1ps

module top_tb;

    // Parameters
    parameter X_WIDTH = 10; // 640 < 2^10 = 1024
    parameter Y_WIDTH = 10; // 480 < 2^10 = 1024
    parameter PATTERN = 120;
    parameter IMAGE_BITS = 8;

    // VGA size
    parameter H_RES = 320;
    parameter V_RES = 240;

    // Inputs
    logic clk;
    logic reset;
    logic isCorner;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data1;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data2;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data3;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data4;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data5;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data6;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data7;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data8;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data9;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data10;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data11;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data12;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data13;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data14;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data15;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data16;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data17;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data18;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data19;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data20;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data21;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data22;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data23;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data24;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data25;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data26;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data27;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data28;
    logic [IMAGE_BITS-1:0] F2B_Pixel_Data29;
    logic [X_WIDTH-1:0] x_coor;
    logic [Y_WIDTH-1:0] y_coor;

    // Outputs
    logic pair_valid;
    logic pair_done;
    logic [X_WIDTH-1:0] current_feature_X;
    logic [Y_WIDTH-1:0] current_feature_Y;
    logic [X_WIDTH-1:0] prev_feature_X;
    logic [Y_WIDTH-1:0] prev_feature_Y;

    // Instantiate DUT
    Top #(
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH),
        .PATTERN(PATTERN),
        .IMAGE_BITS(IMAGE_BITS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .pair_valid(pair_valid),
        .pair_done(pair_done),
        .current_feature_X(current_feature_X),
        .current_feature_Y(current_feature_Y),
        .prev_feature_X(prev_feature_X),
        .prev_feature_Y(prev_feature_Y),
        .isCorner(isCorner),
        .F2B_Pixel_Data1(F2B_Pixel_Data1),
        .F2B_Pixel_Data2(F2B_Pixel_Data2),
        .F2B_Pixel_Data3(F2B_Pixel_Data3),
        .F2B_Pixel_Data4(F2B_Pixel_Data4),
        .F2B_Pixel_Data5(F2B_Pixel_Data5),
        .F2B_Pixel_Data6(F2B_Pixel_Data6),
        .F2B_Pixel_Data7(F2B_Pixel_Data7),
        .F2B_Pixel_Data8(F2B_Pixel_Data8),
        .F2B_Pixel_Data9(F2B_Pixel_Data9),
        .F2B_Pixel_Data10(F2B_Pixel_Data10),
        .F2B_Pixel_Data11(F2B_Pixel_Data11),
        .F2B_Pixel_Data12(F2B_Pixel_Data12),
        .F2B_Pixel_Data13(F2B_Pixel_Data13),
        .F2B_Pixel_Data14(F2B_Pixel_Data14),
        .F2B_Pixel_Data15(F2B_Pixel_Data15),
        .F2B_Pixel_Data16(F2B_Pixel_Data16),
        .F2B_Pixel_Data17(F2B_Pixel_Data17),
        .F2B_Pixel_Data18(F2B_Pixel_Data18),
        .F2B_Pixel_Data19(F2B_Pixel_Data19),
        .F2B_Pixel_Data20(F2B_Pixel_Data20),
        .F2B_Pixel_Data21(F2B_Pixel_Data21),
        .F2B_Pixel_Data22(F2B_Pixel_Data22),
        .F2B_Pixel_Data23(F2B_Pixel_Data23),
        .F2B_Pixel_Data24(F2B_Pixel_Data24),
        .F2B_Pixel_Data25(F2B_Pixel_Data25),
        .F2B_Pixel_Data26(F2B_Pixel_Data26),
        .F2B_Pixel_Data27(F2B_Pixel_Data27),
        .F2B_Pixel_Data28(F2B_Pixel_Data28),
        .F2B_Pixel_Data29(F2B_Pixel_Data29),
        .x_coor(x_coor),
        .y_coor(y_coor)
    );

    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // x_coor, y_coor VGA scan simulation
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            x_coor <= 0;
            y_coor <= 0;
            isCorner <= 0;
        end else begin
            if (x_coor < H_RES-1) begin
                x_coor <= x_coor + 1;
                isCorner <= isCorner + 1;
            end else begin
                x_coor <= 0;
                if (y_coor < V_RES-1) begin
                    y_coor <= y_coor + 1;
                end else begin
                    y_coor <= 0;
                end
            end
        end
    end

    // Stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        #20;
        reset = 0;

        repeat(3) begin
        // Simulation run
            repeat (H_RES*V_RES) begin
                @(posedge clk);
                // Generate random pixel data each clock
                F2B_Pixel_Data1 = $urandom_range(0,255);
                F2B_Pixel_Data2 = $urandom_range(0,255);
                F2B_Pixel_Data3 = $urandom_range(0,255);
                F2B_Pixel_Data4 = $urandom_range(0,255);
                F2B_Pixel_Data5 = $urandom_range(0,255);
                F2B_Pixel_Data6 = $urandom_range(0,255);
                F2B_Pixel_Data7 = $urandom_range(0,255);
                F2B_Pixel_Data8 = $urandom_range(0,255);
                F2B_Pixel_Data9 = $urandom_range(0,255);
                F2B_Pixel_Data10 = $urandom_range(0,255);
                F2B_Pixel_Data11 = $urandom_range(0,255);
                F2B_Pixel_Data12 = $urandom_range(0,255);
                F2B_Pixel_Data13 = $urandom_range(0,255);
                F2B_Pixel_Data14 = $urandom_range(0,255);
                F2B_Pixel_Data15 = $urandom_range(0,255);
                F2B_Pixel_Data16 = $urandom_range(0,255);
                F2B_Pixel_Data17 = $urandom_range(0,255);
                F2B_Pixel_Data18 = $urandom_range(0,255);
                F2B_Pixel_Data19 = $urandom_range(0,255);
                F2B_Pixel_Data20 = $urandom_range(0,255);
                F2B_Pixel_Data21 = $urandom_range(0,255);
                F2B_Pixel_Data22 = $urandom_range(0,255);
                F2B_Pixel_Data23 = $urandom_range(0,255);
                F2B_Pixel_Data24 = $urandom_range(0,255);
                F2B_Pixel_Data25 = $urandom_range(0,255);
                F2B_Pixel_Data26 = $urandom_range(0,255);
                F2B_Pixel_Data27 = $urandom_range(0,255);
                F2B_Pixel_Data28 = $urandom_range(0,255);
                F2B_Pixel_Data29 = $urandom_range(0,255);

            end
        end

        repeat(3) begin
        // Simulation run
            repeat (H_RES*V_RES) begin
                @(posedge clk);
                // Generate random pixel data each clock
                F2B_Pixel_Data1 = 225;
                F2B_Pixel_Data2 = 224;
                F2B_Pixel_Data3 = 223;
                F2B_Pixel_Data4 = 222;
                F2B_Pixel_Data5 = 221;
                F2B_Pixel_Data6 = 220;
                F2B_Pixel_Data7 = 229;
                F2B_Pixel_Data8 = 228;
                F2B_Pixel_Data9 = 227;
                F2B_Pixel_Data10 = 226;
                F2B_Pixel_Data11 = 225;
                F2B_Pixel_Data12 = 224;
                F2B_Pixel_Data13 = 223;
                F2B_Pixel_Data14 = 222;
                F2B_Pixel_Data15 = 221;
                F2B_Pixel_Data16 = 220;
                F2B_Pixel_Data17 = 229;
                F2B_Pixel_Data18 = 228;
                F2B_Pixel_Data19 = 227;
                F2B_Pixel_Data20 = 226;
                F2B_Pixel_Data21 = 225;
                F2B_Pixel_Data22 = 224;
                F2B_Pixel_Data23 = 223;
                F2B_Pixel_Data24 = 222;
                F2B_Pixel_Data25 = 221;
                F2B_Pixel_Data26 = 220;
                F2B_Pixel_Data27 = 229;
                F2B_Pixel_Data28 = 228;
                F2B_Pixel_Data29 = 227;

            end
        end

        #100;

        $finish;
    end

    // Monitor output for debugging
    initial begin
        $monitor("Time=%0t | x=%d y=%d | pair_valid=%b pair_done=%b currX=%d currY=%d prevX=%d prevY=%d isCorner=%b",
                 $time, x_coor, y_coor,
                 pair_valid, pair_done,
                 current_feature_X, current_feature_Y,
                 prev_feature_X, prev_feature_Y,
                 isCorner);
    end

endmodule
