`timescale 1ns / 1ps

module NMS #(
    parameter DATA_SIZE = 14,
    parameter LINE_LENGTH = 640,
    parameter FRAME_HEIGHT = 480,
    parameter INNER_SIZE_X = 320,
    parameter INNER_SIZE_Y = 240,
    parameter INNER_DETECT_NUM_LIMIT = 70,
    parameter OUTER_DETECT_NUM_LIMIT = 30
) (
    input logic pclk,
    input logic reset,
    input logic [9:0] x_pixel,
    input logic [9:0] y_pixel,
    input logic [DATA_SIZE-1:0] data_00,
    data_01,
    data_02,
    data_03,
    data_04,
    input logic [DATA_SIZE-1:0] data_10,
    data_11,
    data_12,
    data_13,
    data_14,
    input logic [DATA_SIZE-1:0] data_20,
    data_21,
    data_22,
    data_23,
    data_24,
    input logic [DATA_SIZE-1:0] data_30,
    data_31,
    data_32,
    data_33,
    data_34,
    input logic [DATA_SIZE-1:0] data_40,
    data_41,
    data_42,
    data_43,
    data_44,
    output logic is_corner
);
    logic [DATA_SIZE-3:0] center_score;
    logic [DATA_SIZE-3:0] comp_score[0:24];
    logic comp_valid[0:24];

    logic [$clog2(INNER_DETECT_NUM_LIMIT)-1:0]
        inner_detect_num_reg, inner_detect_num_next;
    logic [$clog2(OUTER_DETECT_NUM_LIMIT)-1:0]
        outer_detect_num_reg, outer_detect_num_next;
    logic is_inner;
    logic corner_detected;
    logic is_corner_reg, is_corner_next;
    assign is_corner = is_corner_reg;
    assign is_inner = ( (x_pixel > ( (LINE_LENGTH/2)- (INNER_SIZE_X/2)) ) &&  (x_pixel < ( (LINE_LENGTH/2) + (INNER_SIZE_X/2))) &&  (y_pixel > ( (FRAME_HEIGHT/2) - (INNER_SIZE_Y/2))) &&  (y_pixel < ( (FRAME_HEIGHT/2) + (INNER_SIZE_Y/2))) );
    always_ff @(posedge pclk or posedge reset) begin
        if (reset) begin
            inner_detect_num_reg <= 0;
            outer_detect_num_reg <= 0;
            is_corner_reg <= 0;
        end else begin
            inner_detect_num_reg <= inner_detect_num_next;
            outer_detect_num_reg <= outer_detect_num_next;
            is_corner_reg <= is_corner_next;
        end
    end

    always_comb begin
        inner_detect_num_next = inner_detect_num_reg;
        outer_detect_num_next = outer_detect_num_reg;
        is_corner_next = 0;
        corner_detected = 0;
        center_score = data_22[DATA_SIZE-1:2];

        // 점수만 추출
        comp_score[0] = data_00[DATA_SIZE-1:2];
        comp_score[1] = data_01[DATA_SIZE-1:2];
        comp_score[2] = data_02[DATA_SIZE-1:2];
        comp_score[3] = data_03[DATA_SIZE-1:2];
        comp_score[4] = data_04[DATA_SIZE-1:2];
        comp_score[5] = data_10[DATA_SIZE-1:2];
        comp_score[6] = data_11[DATA_SIZE-1:2];
        comp_score[7] = data_12[DATA_SIZE-1:2];
        comp_score[8] = data_13[DATA_SIZE-1:2];
        comp_score[9] = data_14[DATA_SIZE-1:2];
        comp_score[10] = data_20[DATA_SIZE-1:2];
        comp_score[11] = data_21[DATA_SIZE-1:2];
        comp_score[12] = data_23[DATA_SIZE-1:2];
        comp_score[13] = data_24[DATA_SIZE-1:2];
        comp_score[14] = data_30[DATA_SIZE-1:2];
        comp_score[15] = data_31[DATA_SIZE-1:2];
        comp_score[16] = data_32[DATA_SIZE-1:2];
        comp_score[17] = data_33[DATA_SIZE-1:2];
        comp_score[18] = data_34[DATA_SIZE-1:2];
        comp_score[19] = data_40[DATA_SIZE-1:2];
        comp_score[20] = data_41[DATA_SIZE-1:2];
        comp_score[21] = data_42[DATA_SIZE-1:2];
        comp_score[22] = data_43[DATA_SIZE-1:2];
        comp_score[23] = data_44[DATA_SIZE-1:2];

        // 초기 유효 비트 false
        for (int i = 0; i < 24; i++) comp_valid[i] = 0;

        // 조건 만족할 때만 비교 시작
        if (~x_pixel[0] && ~y_pixel[0] && x_pixel < LINE_LENGTH && y_pixel < FRAME_HEIGHT) begin
            if (data_22[0] || data_22[1]) begin
                corner_detected = 1;

                if (data_22[0]) begin  // bright corner
                    comp_valid[0]  = data_00[0];
                    comp_valid[1]  = data_01[0];
                    comp_valid[2]  = data_02[0];
                    comp_valid[3]  = data_03[0];
                    comp_valid[4]  = data_04[0];
                    comp_valid[5]  = data_10[0];
                    comp_valid[6]  = data_11[0];
                    comp_valid[7]  = data_12[0];
                    comp_valid[8]  = data_13[0];
                    comp_valid[9]  = data_14[0];
                    comp_valid[10] = data_20[0];
                    comp_valid[11] = data_21[0];
                    comp_valid[12] = data_23[0];
                    comp_valid[13] = data_24[0];
                    comp_valid[14] = data_30[0];
                    comp_valid[15] = data_31[0];
                    comp_valid[16] = data_32[0];
                    comp_valid[17] = data_33[0];
                    comp_valid[18] = data_34[0];
                    comp_valid[19] = data_40[0];
                    comp_valid[20] = data_41[0];
                    comp_valid[21] = data_42[0];
                    comp_valid[22] = data_43[0];
                    comp_valid[23] = data_44[0];
                end else if (data_22[1]) begin  // dark corner
                    comp_valid[0]  = data_00[1];
                    comp_valid[1]  = data_01[1];
                    comp_valid[2]  = data_02[1];
                    comp_valid[3]  = data_03[1];
                    comp_valid[4]  = data_04[1];
                    comp_valid[5]  = data_10[1];
                    comp_valid[6]  = data_11[1];
                    comp_valid[7]  = data_12[1];
                    comp_valid[8]  = data_13[1];
                    comp_valid[9]  = data_14[1];
                    comp_valid[10] = data_20[1];
                    comp_valid[11] = data_21[1];
                    comp_valid[12] = data_23[1];
                    comp_valid[13] = data_24[1];
                    comp_valid[14] = data_30[1];
                    comp_valid[15] = data_31[1];
                    comp_valid[16] = data_32[1];
                    comp_valid[17] = data_33[1];
                    comp_valid[18] = data_34[1];
                    comp_valid[19] = data_40[1];
                    comp_valid[20] = data_41[1];
                    comp_valid[21] = data_42[1];
                    comp_valid[22] = data_43[1];
                    comp_valid[23] = data_44[1];
                end

                // 비교: 유효한 주변 중 하나라도 점수가 더 크면 탈락
                for (int i = 0; i < 24; i++) begin
                    if (comp_valid[i] && center_score < comp_score[i]) begin
                        corner_detected = 0;
                    end
                end
            end
        end
        if (corner_detected) begin
            if (is_inner) begin
                if (inner_detect_num_reg == INNER_DETECT_NUM_LIMIT) begin
                    is_corner_next = 0;
                    inner_detect_num_next = inner_detect_num_reg;
                end else begin
                    is_corner_next = 1;
                    inner_detect_num_next = inner_detect_num_reg + 1;
                end
            end else begin
                if (outer_detect_num_reg == OUTER_DETECT_NUM_LIMIT) begin
                    is_corner_next = 0;
                    outer_detect_num_next = outer_detect_num_reg;
                end else begin
                    is_corner_next = 1;
                    outer_detect_num_next = outer_detect_num_reg + 1;
                end
            end
        end
        if (x_pixel == 0 && y_pixel == 0) begin
            inner_detect_num_next = 0;
            outer_detect_num_next = 0;
        end
    end
endmodule
