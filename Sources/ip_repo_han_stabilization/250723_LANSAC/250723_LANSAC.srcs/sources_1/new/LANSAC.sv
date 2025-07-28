module LANSAC #(
    parameter X_WIDTH = 10,
    parameter Y_WIDTH = 10,
    parameter ADJUST_AFFINE_DX_THRES = 30,
    parameter ADJUST_AFFINE_DY_THRES = 30,
    parameter MAXIMUM_PAIR_NUM = 100,
    parameter MINIMUM_PAIR_NUM = 6
) (
    input logic clk,
    input logic pclk,
    input logic reset,

    input logic [X_WIDTH-1:0] x_pixel,
    input logic [Y_WIDTH-1:0] y_pixel,
    input logic [X_WIDTH-1:0] current_feature_X,
    input logic [Y_WIDTH-1:0] current_feature_Y,
    input logic [X_WIDTH-1:0] prev_feature_X,
    input logic [Y_WIDTH-1:0] prev_feature_Y,
    input logic pair_valid,
    input logic pair_done,
    output logic signed [17:0] affine_matrix_dx,  // ±1024×DX_THRES
    output logic signed [17:0] affine_matrix_dy,  // ±1024×DY_THRES
    output logic lansac_done
);
    logic [X_WIDTH-1:0] current_feature_X_reg;
    logic [Y_WIDTH-1:0] current_feature_Y_reg;
    logic [X_WIDTH-1:0] prev_feature_X_reg;
    logic [Y_WIDTH-1:0] prev_feature_Y_reg;

    logic [X_WIDTH-1:0] current_feature_X_reg_AFF_reg[0:2];
    logic [X_WIDTH-1:0] current_feature_X_reg_AFF_next[0:2];
    logic [Y_WIDTH-1:0] current_feature_Y_reg_AFF_reg[0:2];
    logic [Y_WIDTH-1:0] current_feature_Y_reg_AFF_next[0:2];
    logic [X_WIDTH-1:0] prev_feature_X_reg_AFF_reg[0:2];
    logic [X_WIDTH-1:0] prev_feature_X_reg_AFF_next[0:2];
    logic [Y_WIDTH-1:0] prev_feature_Y_reg_AFF_reg[0:2];
    logic [Y_WIDTH-1:0] prev_feature_Y_reg_AFF_next[0:2];

    logic [$clog2(MAXIMUM_PAIR_NUM)-1:0] feature_windex_reg, feature_windex_next;
    logic [$clog2(MAXIMUM_PAIR_NUM)-1:0] feature_rindex_reg, feature_rindex_next;

    logic [31:0] random_number[0:2];
    logic [31:0] random_number_reg[0:2];
    logic [31:0] random_number_next[0:2];
    logic [31:0] random_number_in_range_reg[0:2];
    logic [31:0] random_number_in_range_next[0:2];

    logic [$clog2(MAXIMUM_PAIR_NUM)-1:0] counter_reg, counter_next;
    logic ram_en;
    logic en;

    logic signed [17:0] affine_matrix_dx_reg, affine_matrix_dx_next;
    logic signed [17:0] affine_matrix_dy_reg, affine_matrix_dy_next;

    logic signed [17:0] final_affine_matrix_dx_reg, final_affine_matrix_dx_next;
    logic signed [17:0] final_affine_matrix_dy_reg, final_affine_matrix_dy_next;

    assign affine_matrix_dx = final_affine_matrix_dx_reg;
    assign affine_matrix_dy = final_affine_matrix_dy_reg;

    logic signed [24:0] diff_x, diff_y;
    logic [24:0] diff_reg, diff_next;
    logic [24:0] lowest_diff_reg, lowest_diff_next;
    logic lansac_done_reg, lansac_done_next;
    assign lansac_done = lansac_done_reg;
    typedef enum logic [2:0] {
        RECEIVE_PAIR,
        COMPUTE_TRANSLATION,
        COMPUTE_RANDOM,
        DELAY,
        COMPUTE_PENALTY,
        CHECK_TRANSLATION,
        SEND_TRANSLATION
    } e_state;
    e_state state, state_next;

    // 중간 레지스터 추가
    logic [$clog2(MAXIMUM_PAIR_NUM)-1:0] feature_windex_delayed_reg, feature_windex_delayed_next;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= RECEIVE_PAIR;
            feature_windex_reg <= 0;
            feature_rindex_reg <= 0;
            counter_reg <= 0;
            diff_reg <= 0;
            lowest_diff_reg <= 25'h1FFFFFF;  // 25비트 최대값
            final_affine_matrix_dx_reg <= 0;
            final_affine_matrix_dy_reg <= 0;
            lansac_done_reg <= 0;
            feature_windex_delayed_reg <= 0;
            for (int i = 0; i < 3; i = i + 1) begin
                current_feature_X_reg_AFF_reg[i] <= 0;
                current_feature_Y_reg_AFF_reg[i] <= 0;
                prev_feature_X_reg_AFF_reg[i] <= 0;
                prev_feature_Y_reg_AFF_reg[i] <= 0;
                random_number_reg[i] <= 0;
                random_number_in_range_reg[i] <= 0;
            end
            affine_matrix_dx_reg <= 0;
            affine_matrix_dy_reg <= 0;
        end else begin
            state <= state_next;
            feature_windex_reg <= feature_windex_next;
            feature_rindex_reg <= feature_rindex_next;
            counter_reg <= counter_next;
            diff_reg <= diff_next;
            lowest_diff_reg <= lowest_diff_next;
            final_affine_matrix_dx_reg <= final_affine_matrix_dx_next;
            final_affine_matrix_dy_reg <= final_affine_matrix_dy_next;
            lansac_done_reg <= lansac_done_next;
            current_feature_X_reg_AFF_reg <= current_feature_X_reg_AFF_next;
            current_feature_Y_reg_AFF_reg <= current_feature_Y_reg_AFF_next;
            prev_feature_X_reg_AFF_reg <= prev_feature_X_reg_AFF_next;
            prev_feature_Y_reg_AFF_reg <= prev_feature_Y_reg_AFF_next;
            feature_windex_delayed_reg <= feature_windex_delayed_next;
            affine_matrix_dx_reg <= affine_matrix_dx_next;
            affine_matrix_dy_reg <= affine_matrix_dy_next;
            random_number_reg <= random_number_next;
            random_number_in_range_reg <= random_number_in_range_next;
        end
    end

    always_comb begin
        state_next = state;
        feature_windex_next = feature_windex_reg;
        feature_rindex_next = feature_rindex_reg;
        counter_next = counter_reg;
        diff_next = diff_reg;
        final_affine_matrix_dx_next = final_affine_matrix_dx_reg;
        final_affine_matrix_dy_next = final_affine_matrix_dy_reg;
        lowest_diff_next = lowest_diff_reg;
        ram_en = 0;
        en = 1;
        lansac_done_next = 0;
        current_feature_X_reg_AFF_next = current_feature_X_reg_AFF_reg;
        current_feature_Y_reg_AFF_next = current_feature_Y_reg_AFF_reg;
        prev_feature_X_reg_AFF_next = prev_feature_X_reg_AFF_reg;
        prev_feature_Y_reg_AFF_next = prev_feature_Y_reg_AFF_reg;
        feature_windex_delayed_next = feature_windex_reg;  // 지연된 값 저장
        affine_matrix_dx_next = affine_matrix_dx_reg;
        affine_matrix_dy_next = affine_matrix_dy_reg;
        random_number_next = random_number_reg;
        random_number_in_range_next = random_number_in_range_reg;
        case (state)
            RECEIVE_PAIR: begin
                if (pair_valid) begin
                    ram_en = 1;
                    feature_windex_next = feature_windex_reg + 1;
                end
                if (pair_done) begin
                    counter_next = 0;
                    state_next = COMPUTE_RANDOM;
                    random_number_next = random_number;
                    diff_next = 0;
                end
            end
            COMPUTE_RANDOM: begin
                random_number_in_range_next[0] =  random_number_reg[0] % feature_windex_reg;
                random_number_in_range_next[1] =  random_number_reg[1] % feature_windex_reg;
                random_number_in_range_next[2] =  random_number_reg[2] % feature_windex_reg;
                if (counter_reg == 15) begin
                    counter_next = 0;
                    state_next = COMPUTE_TRANSLATION;
                    feature_rindex_next = random_number_in_range_next[0];
                end else begin
                    counter_next = counter_reg + 1;
                end
                if (x_pixel == 0 && y_pixel == 0) begin
                    feature_windex_next = 0;
                    feature_rindex_next = 0;
                    counter_next = 0;
                    diff_next = 0;
                    if(feature_windex_reg < MINIMUM_PAIR_NUM) begin
                        state_next = RECEIVE_PAIR;
                    end else begin
                        state_next = SEND_TRANSLATION;
                    end
                end
            end
            COMPUTE_TRANSLATION: begin
                prev_feature_X_reg_AFF_next[counter_reg] = prev_feature_X_reg;
                prev_feature_Y_reg_AFF_next[counter_reg] = prev_feature_Y_reg;
                current_feature_X_reg_AFF_next[counter_reg] = current_feature_X_reg;
                current_feature_Y_reg_AFF_next[counter_reg] = current_feature_Y_reg;
                // dx, dy 계산 (3개 점의 평균)
                if (counter_reg == 2) begin
                    counter_next = 0;
                    feature_rindex_next = 0;
                    state_next = DELAY;
                end else begin
                    feature_rindex_next = random_number_in_range_next[counter_reg+1]; 
                    counter_next = counter_reg + 1;
                end
                if (x_pixel == 0 && y_pixel == 0) begin
                    feature_windex_next = 0;
                    feature_rindex_next = 0;
                    counter_next = 0;
                    diff_next = 0;
                    if(feature_windex_reg < MINIMUM_PAIR_NUM) begin
                        state_next = RECEIVE_PAIR;
                    end else begin
                        state_next = SEND_TRANSLATION;
                    end
                end
            end
            DELAY: begin
                    affine_matrix_dx_next =( (
                        ($signed(current_feature_X_reg_AFF_reg[0]) - $signed(prev_feature_X_reg_AFF_reg[0])) +
                        ($signed(current_feature_X_reg_AFF_reg[1]) - $signed(prev_feature_X_reg_AFF_reg[1])) +
                        ($signed(current_feature_X_reg_AFF_reg[2]) - $signed(prev_feature_X_reg_AFF_reg[2]))
                    )<<<10) / 3;  // ±1024×DX_THRES 스케일링
                    affine_matrix_dy_next = ((
                        ($signed(current_feature_Y_reg_AFF_reg[0]) - $signed(prev_feature_Y_reg_AFF_reg[0])) +
                        ($signed(current_feature_Y_reg_AFF_reg[1]) - $signed(prev_feature_Y_reg_AFF_reg[1])) +
                        ($signed(current_feature_Y_reg_AFF_reg[2]) - $signed(prev_feature_Y_reg_AFF_reg[2]))
                    )<<<10) / 3;  // ±1024×DY_THRES 스케일링
                if (counter_reg == 15) begin
                    counter_next = 0;
                    state_next = COMPUTE_PENALTY;
                    
                end else begin
                    counter_next = counter_reg + 1;
                end
                if (x_pixel == 0 && y_pixel == 0) begin
                    feature_windex_next = 0;
                    feature_rindex_next = 0;
                    counter_next = 0;
                    diff_next = 0;
                    if(feature_windex_reg < MINIMUM_PAIR_NUM) begin
                        state_next = RECEIVE_PAIR;
                    end else begin
                        state_next = SEND_TRANSLATION;
                    end
                end
            end
            COMPUTE_PENALTY: begin
                diff_x =$signed(current_feature_X_reg<<<10) - ( $signed(prev_feature_X_reg<<<10) + affine_matrix_dx_reg );
                diff_y =$signed(current_feature_Y_reg<<<10) - ( $signed(prev_feature_Y_reg<<<10) + affine_matrix_dy_reg );
                diff_next = diff_reg + ((diff_x < 0) ? -diff_x : diff_x) + ((diff_y < 0) ? -diff_y : diff_y);
                if (feature_rindex_reg == feature_windex_reg - 1) begin
                    feature_rindex_next = 0;
                    state_next = CHECK_TRANSLATION;
                end else begin
                    feature_rindex_next = feature_rindex_reg + 1;
                end
                if (x_pixel == 0 && y_pixel == 0) begin
                    feature_windex_next = 0;
                    feature_rindex_next = 0;
                    counter_next = 0;
                    diff_next = 0;
                    if(feature_windex_reg < MINIMUM_PAIR_NUM) begin
                        state_next = RECEIVE_PAIR;
                    end else begin
                        state_next = SEND_TRANSLATION;
                    end
                end
            end
            CHECK_TRANSLATION: begin
                if (diff_reg <= lowest_diff_reg) begin
                    lowest_diff_next = diff_reg;
                    final_affine_matrix_dx_next = affine_matrix_dx_reg;
                    final_affine_matrix_dy_next = affine_matrix_dy_reg;
                end
                state_next = COMPUTE_RANDOM;
                random_number_next = random_number;
                diff_next = 0;
                if (x_pixel == 0 && y_pixel == 0) begin
                    feature_windex_next = 0;
                    feature_rindex_next = 0;
                    counter_next = 0;
                    diff_next = 0;
                    if(feature_windex_reg < MINIMUM_PAIR_NUM) begin
                        state_next = RECEIVE_PAIR;
                    end else begin
                        state_next = SEND_TRANSLATION;
                    end
                end
            end
            SEND_TRANSLATION: begin
                if ((final_affine_matrix_dx_reg < (-ADJUST_AFFINE_DX_THRES * 1024)) || 
                    (final_affine_matrix_dx_reg > (ADJUST_AFFINE_DX_THRES * 1024)) || 
                    (final_affine_matrix_dy_reg < (-ADJUST_AFFINE_DY_THRES * 1024)) || 
                    (final_affine_matrix_dy_reg > (ADJUST_AFFINE_DY_THRES * 1024))) begin
                    final_affine_matrix_dx_next = 0;
                    final_affine_matrix_dy_next = 0;
                end
                lansac_done_next = 1;
                lowest_diff_next = 25'h1FFFFFF;
                state_next = RECEIVE_PAIR;
            end
        endcase
    end

    pseudo_random0 U_pseudo_random0 (
        .clk(pclk),
        .rst(reset),
        .en (en),
        .q  (random_number[0])
    );
    pseudo_random1 U_pseudo_random1 (
        .clk(pclk),
        .rst(reset),
        .en (en),
        .q  (random_number[1])
    );
    pseudo_random2 U_pseudo_random2 (
        .clk(pclk),
        .rst(reset),
        .en (en),
        .q  (random_number[2])
    );
    ram__ #(
        .RAM_SIZE (MAXIMUM_PAIR_NUM),
        .DATA_SIZE(X_WIDTH)
    ) current_feature_x_ram (
        .clk(clk),
        .i_data(current_feature_X),
        .i_write_addr(feature_windex_reg),
        .i_read_addr(feature_rindex_reg),
        .write_enable(ram_en),
        .o_data(current_feature_X_reg)
    );
    ram__ #(
        .RAM_SIZE (MAXIMUM_PAIR_NUM),
        .DATA_SIZE(X_WIDTH)
    ) prev_feature_x_ram (
        .clk(clk),
        .i_data(prev_feature_X),
        .i_write_addr(feature_windex_reg),
        .i_read_addr(feature_rindex_reg),
        .write_enable(ram_en),
        .o_data(prev_feature_X_reg)
    );
    ram__ #(
        .RAM_SIZE (MAXIMUM_PAIR_NUM),
        .DATA_SIZE(Y_WIDTH)
    ) current_feature_y_ram (
        .clk(clk),
        .i_data(current_feature_Y),
        .i_write_addr(feature_windex_reg),
        .i_read_addr(feature_rindex_reg),
        .write_enable(ram_en),
        .o_data(current_feature_Y_reg)
    );
    ram__ #(
        .RAM_SIZE (MAXIMUM_PAIR_NUM),
        .DATA_SIZE(Y_WIDTH)
    ) prev_feature_y_ram (
        .clk(clk),
        .i_data(prev_feature_Y),
        .i_write_addr(feature_windex_reg),
        .i_read_addr(feature_rindex_reg),
        .write_enable(ram_en),
        .o_data(prev_feature_Y_reg)
    );
endmodule

module pseudo_random0 (
    input logic clk,
    input logic rst,
    input logic en,
    output logic [31:0] q
);
    wire feedback = q[31] ^ q[21] ^ q[1] ^ q[0]; // 다항식: x^32 + x^22 + x^2 + x + 1
    always @(posedge clk or posedge rst)
        if (rst) q <= 32'h5a5a5a5a;
        else if(en) q <= {q[30:0], feedback};
        else q<= q;
endmodule

module pseudo_random1 (
    input logic clk,
    input logic rst,
    input logic en,
    output logic [31:0] q
);
    wire feedback = q[31] ^ q[27] ^ q[26] ^ q[0]; // 다항식: x^32 + x^28 + x^27 + x + 1
    always @(posedge clk or posedge rst)
        if (rst) q <= 32'hc3b2a1d4;
        else if(en) q <= {q[30:0], feedback};  // 방향 통일
        else q<= q;
endmodule

module pseudo_random2 (
    input logic clk,
    input logic rst,
    input logic en,
    output logic [31:0] q
);
    wire feedback = q[31] ^ q[17] ^ q[4] ^ q[1]; // 다항식: x^32 + x^18 + x^5 + x^2 + 1
    always @(posedge clk or posedge rst)
        if (rst) q <= 32'h7e9d1f3b;
        else if(en) q <= {q[30:0], feedback};
        else q<= q;
endmodule

module ram__ #(
    parameter RAM_SIZE  = 100,
    parameter DATA_SIZE = 120
) (
    input logic clk,

    input logic [DATA_SIZE-1:0] i_data,
    input logic [$clog2(RAM_SIZE)-1:0] i_write_addr,
    input logic [$clog2(RAM_SIZE)-1:0] i_read_addr,
    input logic write_enable,

    output logic [DATA_SIZE-1:0] o_data
);

    logic [DATA_SIZE-1:0] mem[RAM_SIZE-1:0];

    always_ff @(posedge clk) begin : WRITE
        if (write_enable) begin
            mem[i_write_addr] <= i_data;
        end
    end

    always_comb begin : READ
        o_data = mem[i_read_addr];
    end

endmodule