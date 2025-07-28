
module line_buffer_5x5 #(
    parameter DATA_SIZE = 16,
    parameter LINE_LENGTH = 640,
    parameter FRAME_HEIGHT = 480
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
    output logic [DATA_SIZE-1:0] data_10,
    output logic [DATA_SIZE-1:0] data_11,
    output logic [DATA_SIZE-1:0] data_12,
    output logic [DATA_SIZE-1:0] data_13,
    output logic [DATA_SIZE-1:0] data_14,
    output logic [DATA_SIZE-1:0] data_20,
    output logic [DATA_SIZE-1:0] data_21,
    output logic [DATA_SIZE-1:0] data_22,
    output logic [DATA_SIZE-1:0] data_23,
    output logic [DATA_SIZE-1:0] data_24,
    output logic [DATA_SIZE-1:0] data_30,
    output logic [DATA_SIZE-1:0] data_31,
    output logic [DATA_SIZE-1:0] data_32,
    output logic [DATA_SIZE-1:0] data_33,
    output logic [DATA_SIZE-1:0] data_34,
    output logic [DATA_SIZE-1:0] data_40,
    output logic [DATA_SIZE-1:0] data_41,
    output logic [DATA_SIZE-1:0] data_42,
    output logic [DATA_SIZE-1:0] data_43,
    output logic [DATA_SIZE-1:0] data_44
);
    // median filter parameters
    reg [DATA_SIZE-1:0] fmem0[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem1[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem2[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem3[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] fmem4[LINE_LENGTH/2:0];
    reg [DATA_SIZE-1:0] temp[1:0];

    logic [8:0] f_x_pixel;
    logic [8:0] f_y_pixel;
    assign f_x_pixel = x_pixel[9:1];
    assign f_y_pixel = y_pixel[9:1];

    always_ff @(posedge pclk) begin
        if (x_pixel < LINE_LENGTH && y_pixel < FRAME_HEIGHT && (~x_pixel[0])&& (~y_pixel[0])) begin
            temp[0] <= temp[1];
            temp[1] <= fmem4[f_x_pixel];
            fmem4[f_x_pixel] <= fmem3[f_x_pixel];
            fmem3[f_x_pixel] <= fmem2[f_x_pixel];
            fmem2[f_x_pixel] <= fmem1[f_x_pixel];
            fmem1[f_x_pixel] <= fmem0[f_x_pixel];
            fmem0[f_x_pixel] <= data;
        end
    end

    always_ff @(posedge pclk) begin
        data_00 <= temp[0];
        data_01 <= temp[1];
        data_02 <= (f_y_pixel >= 4) ? fmem4[f_x_pixel] : 0;
        data_03 <= (f_y_pixel >= 4 && f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem4[f_x_pixel+1] : 0;
        data_04 <= (f_y_pixel >= 4 && f_x_pixel <= LINE_LENGTH/2-1 -2) ? fmem4[f_x_pixel+2] : 0;

        data_10 <= (f_y_pixel >= 4 && f_x_pixel >= 2) ? fmem4[f_x_pixel+1] : 0;
        data_11 <= (f_y_pixel >= 4 && f_x_pixel >= 1) ? fmem4[f_x_pixel+1] : 0;
        data_12 <= (f_y_pixel >= 3) ? fmem3[f_x_pixel] : 0;
        data_13 <= (f_y_pixel >= 3 && f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem3[f_x_pixel+1] : 0;
        data_14 <= (f_y_pixel >= 3 && f_x_pixel <= LINE_LENGTH/2-1 -2) ? fmem3[f_x_pixel+2] : 0;

        data_20 <= (f_y_pixel >= 3 && f_x_pixel >= 2) ? fmem3[f_x_pixel+1] : 0;
        data_21 <= (f_y_pixel >= 3 && f_x_pixel >= 1) ? fmem3[f_x_pixel+1] : 0;
        data_22 <= (f_y_pixel >= 2) ? fmem2[f_x_pixel] : 0;
        data_23 <= (f_y_pixel >= 2 && f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem2[f_x_pixel+1] : 0;
        data_24 <= (f_y_pixel >= 2 && f_x_pixel <= LINE_LENGTH/2-1 -2) ? fmem2[f_x_pixel+2] : 0;

        data_30 <= (f_y_pixel >= 2 && f_x_pixel >= 2) ? fmem2[f_x_pixel+1] : 0;
        data_31 <= (f_y_pixel >= 2 && f_x_pixel >= 1) ? fmem2[f_x_pixel+1] : 0;
        data_32 <= (f_y_pixel >= 1) ? fmem1[f_x_pixel] : 0;
        data_33 <= (f_y_pixel >= 1 && f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem1[f_x_pixel+1] : 0;
        data_34 <= (f_y_pixel >= 1 && f_x_pixel <= LINE_LENGTH/2-1 -2) ? fmem1[f_x_pixel+2] : 0;

        data_40 <= (f_y_pixel >= 1 && f_x_pixel >= 2) ? fmem1[f_x_pixel+1] : 0;
        data_41 <= (f_y_pixel >= 1 && f_x_pixel >= 1) ? fmem1[f_x_pixel+1] : 0;
        data_42 <= (f_y_pixel >= 0) ? fmem0[f_x_pixel] : 0;
        data_43 <= (f_y_pixel >= 0 && f_x_pixel <= LINE_LENGTH/2-1 -1) ? fmem0[f_x_pixel+1] : 0;
        data_44 <= (f_y_pixel >= 0 && f_x_pixel <= LINE_LENGTH/2-1 -2) ? fmem0[f_x_pixel+2] : 0;
    end
endmodule
