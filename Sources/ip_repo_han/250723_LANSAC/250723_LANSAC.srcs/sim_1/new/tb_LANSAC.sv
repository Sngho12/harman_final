`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/07/24 11:05:41
// Design Name: 
// Module Name: tb_LANSAC
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

`timescale 1ns / 1ps

module tb_LANSAC;

  // Parameters
  parameter X_WIDTH = 10;
  parameter Y_WIDTH = 10;

  // DUT Inputs
  logic clk, reset;
  logic [X_WIDTH-1:0] x_pixel, current_feature_X, prev_feature_X;
  logic [Y_WIDTH-1:0] y_pixel, current_feature_Y, prev_feature_Y;
  logic pair_valid, pair_done;

  // DUT Outputs
  logic signed [11:0] affine_matrix_a11, affine_matrix_a22;
  logic signed [9:0]  affine_matrix_a12, affine_matrix_a21;
  logic signed [15:0] affine_matrix_dx, affine_matrix_dy;
  logic lansac_done;

  // Instantiate DUT
  LANSAC #(
    .X_WIDTH(X_WIDTH),
    .Y_WIDTH(Y_WIDTH),
    .MAXIMUM_PAIR_NUM(100)
  ) dut (
    .clk(clk),
    .reset(reset),
    .x_pixel(x_pixel),
    .y_pixel(y_pixel),
    .current_feature_X(current_feature_X),
    .current_feature_Y(current_feature_Y),
    .prev_feature_X(prev_feature_X),
    .prev_feature_Y(prev_feature_Y),
    .pair_valid(pair_valid),
    .pair_done(pair_done),
    .affine_matrix_a11(affine_matrix_a11),
    .affine_matrix_a12(affine_matrix_a12),
    .affine_matrix_dx (affine_matrix_dx),
    .affine_matrix_a21(affine_matrix_a21),
    .affine_matrix_a22(affine_matrix_a22),
    .affine_matrix_dy (affine_matrix_dy),
    .lansac_done(lansac_done)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test data (5 feature point pairs)
parameter MAX_PAIR = 21;
  logic [X_WIDTH-1:0]  prev_Xs[0:43] = '{
    255, 268, 121,  48, 130, 112, 113, 114, 113, 114, 158, 159, 181, 260, 257, 257,
    244, 244,  36, 137,  66,  66,  66, 180,  94, 126,  31,  32,  33,  32,  31,  57,
     59,  34,  55,  56,  92, 102, 103, 103,  61,  61,  62,  63
  };

  logic [Y_WIDTH-1:0]  prev_Ys[0:43] = '{
     56,  59,  63,  79,  85,  86,  86,  86,  87,  87,  98,  98,  98, 104, 106, 107,
    111, 112, 115, 120, 126, 127, 128, 131, 137, 147, 148, 148, 148, 149, 152, 157,
    158, 174, 175, 175, 179, 179, 179, 180, 199, 200, 200, 200
  };

  logic [X_WIDTH-1:0] current_Xs [0:43] = '{
    254, 267, 121,  47, 129, 111, 112, 113, 112, 113, 158, 158, 180, 259, 256, 256,
    243, 243,  35, 136,  65,  65,  65, 179,  93, 125,  30,  31,  31,  31,  30,  56,
     58,  32,  54,  55,  91, 101, 102, 102,  60,  60,  61,  62
  };

  logic [Y_WIDTH-1:0] current_Ys [0:43] = '{
     56,  59,  63,  78,  85,  86,  86,  86,  87,  87,  98,  98,  98, 104, 106, 107,
    111, 112, 115, 120, 126, 127, 128, 131, 137, 147, 148, 148, 148, 149, 152, 157,
    158, 174, 175, 175, 179, 179, 179, 180, 199, 200, 200, 200
  };



  initial begin
    // Init signals
    clk = 0;
    reset = 0;
    pair_valid = 0;
    pair_done = 0;
    x_pixel = 599;
    y_pixel = 300;
    #10 reset = 1;
    #10 reset = 0;

    // Feed in feature point pairs
    for (int i = 0; i < MAX_PAIR-10; i++) begin
      @(posedge clk);
      current_feature_X <= current_Xs[i];
      current_feature_Y <= current_Ys[i];
      prev_feature_X    <= prev_Xs[i];
      prev_feature_Y    <= prev_Ys[i];
      pair_valid <= 1;
      @(posedge clk);
      pair_valid <= 0;
    end

    // Signal pair input is complete
    @(posedge clk);
    pair_done <= 1;
    @(posedge clk);
    pair_done <= 0;
    #100000;
    x_pixel = 0;
    y_pixel = 0;
    // Wait for LANSAC to finish
    wait (lansac_done == 1);
    x_pixel = 30;
    y_pixel = 100;
    for (int i = MAX_PAIR-10; i < MAX_PAIR; i++) begin
      @(posedge clk);
      current_feature_X <= current_Xs[i];
      current_feature_Y <= current_Ys[i];
      prev_feature_X    <= prev_Xs[i];
      prev_feature_Y    <= prev_Ys[i];
      pair_valid <= 1;
      @(posedge clk);
      pair_valid <= 0;
    end
    @(posedge clk);
    pair_done <= 1;
    @(posedge clk);
    pair_done <= 0;
    #100000;
    x_pixel = 0;
    y_pixel = 0;
    // Wait for LANSAC to finish
    wait (lansac_done == 1);
    $display("=== LANSAC DONE ===");
    $display("A11: %0d", affine_matrix_a11);
    $display("A12: %0d", affine_matrix_a12);
    $display("DX : %0d", affine_matrix_dx);
    $display("A21: %0d", affine_matrix_a21);
    $display("A22: %0d", affine_matrix_a22);
    $display("DY : %0d", affine_matrix_dy);

    $stop;
  end

endmodule