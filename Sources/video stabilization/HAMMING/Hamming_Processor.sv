`timescale 1ns / 1ps

module Hamming_Processor #(
    parameter PATTERN = 120,
    parameter RAM_SIZE = 100,
    parameter VERTICAL = 480,
    parameter HORIZEN = 640,
    parameter MATCH_LIMIT_X = 30,
    parameter MATCH_LIMIT_Y = 30,
    parameter MAX_WEIGHT = 50,
    parameter X_WIDTH = 10,
    parameter Y_WIDTH = 10
) (
    input logic clk,
    input logic reset,
    // Current place
    input logic [X_WIDTH-1:0] x_coor,
    input logic [Y_WIDTH-1:0] y_coor,
    // Brief to Hamming
    input logic [X_WIDTH-1:0] cornerX,
    input logic [Y_WIDTH-1:0] cornerY,
    input logic [PATTERN-1:0] Brief_Descriptor,
    // Hamming to RANSAC
    output logic [X_WIDTH-1:0] current_feature_X,
    output logic [Y_WIDTH-1:0] current_feature_Y,
    output logic [X_WIDTH-1:0] prev_feature_X,
    output logic [Y_WIDTH-1:0] prev_feature_Y,
    output logic pair_valid,
    output logic pair_done
);

    //================================================================
    // parameter
    //================================================================ 
    localparam PARALLEL_FACTOR = 5;

    //================================================================
    // Trigger
    //================================================================
    logic exist_flag, next_exist_flag;
    logic no_storage, next_no_storage;
    logic forward_stop, next_forward_stop;
    logic inner_forward_stop;
    logic backward_stop, next_backward_stop;
    logic inner_backward_stop;
    logic next_pair_valid;
    logic next_pair_done;
    logic LUT_current_reg_wen;
    logic prev_ram_wen;
    //================================================================
    // Register
    //================================================================
    logic [X_WIDTH-1:0] next_current_feature_X;
    logic [Y_WIDTH-1:0] next_current_feature_Y;
    logic [X_WIDTH-1:0] next_prev_feature_X;
    logic [Y_WIDTH-1:0] next_prev_feature_Y;
    logic [X_WIDTH-1:0] prev_cornerX, next_prev_cornerX;
    logic [$clog2(RAM_SIZE)-1:0] index_count, prev_index_count, storage_count, fwd_idx, bwd_idx, current_i, current_f, current_b;
    logic [$clog2(RAM_SIZE)-1:0] next_index_count, next_prev_index_count, next_storage_count, next_fwd_idx, next_bwd_idx;
    logic [$clog2(PATTERN+1)-1:0] fmatching_weight [PARALLEL_FACTOR-1:0];
    logic [$clog2(PATTERN+1)-1:0] bmatching_weight [PARALLEL_FACTOR-1:0];
    logic [X_WIDTH-1:0] fx_diff, bx_diff;
    logic [Y_WIDTH-1:0] fy_diff, by_diff;
    logic [X_WIDTH-1:0] lfx_diff, lbx_diff;
    logic [Y_WIDTH-1:0] lfy_diff, lby_diff;
    logic [X_WIDTH-1:0] lfx_diff2, lbx_diff2;
    logic [Y_WIDTH-1:0] lfy_diff2, lby_diff2;
    logic [X_WIDTH-1:0] mfx_diff, mbx_diff;
    logic [Y_WIDTH-1:0] mfy_diff, mby_diff;
    logic [X_WIDTH-1:0] mfx, mbx;
    logic [Y_WIDTH-1:0] mfy, mby;
    logic [$clog2(RAM_SIZE)-1:0] prev_single_read_addr;

    //================================================================
    // instance, typedef
    //================================================================
    typedef enum { IDLE, MATCHING, ARBITRATION, COPY} state_e;
    state_e state, next_state;

    typedef struct packed {
        logic [$clog2(RAM_SIZE)-1:0] match_addr;
        logic [$clog2(PATTERN+1)-1:0] weight;
    } MatchInfo_t;

    MatchInfo_t forward_matching_reg [RAM_SIZE-1:0];
    MatchInfo_t backward_matching_reg [RAM_SIZE-1:0];
    MatchInfo_t next_forward_matching_reg [RAM_SIZE-1:0];
    MatchInfo_t next_backward_matching_reg [RAM_SIZE-1:0];
    MatchInfo_t local_forward_matching_reg;
    MatchInfo_t local_backward_matching_reg;

    typedef struct packed {
        logic [X_WIDTH-1:0] x_reg;
        logic [Y_WIDTH-1:0] y_reg;
        logic [PATTERN-1:0] desc_reg;
    } RegInfo_t;

    RegInfo_t LUT_current_reg [PARALLEL_FACTOR-1:0];
    RegInfo_t LUT_prev_reg [PARALLEL_FACTOR-1:0];
    RegInfo_t current_wire;
    RegInfo_t prev_wire;

    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg0 (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr(bwd_idx),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(LUT_current_reg[0].x_reg),
        .o_y_data(LUT_current_reg[0].y_reg),
        .o_desc_data(LUT_current_reg[0].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg1 (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr((bwd_idx+1)),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(LUT_current_reg[1].x_reg),
        .o_y_data(LUT_current_reg[1].y_reg),
        .o_desc_data(LUT_current_reg[1].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg2 (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr((bwd_idx+2)),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(LUT_current_reg[2].x_reg),
        .o_y_data(LUT_current_reg[2].y_reg),
        .o_desc_data(LUT_current_reg[2].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg3 (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr((bwd_idx+3)),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(LUT_current_reg[3].x_reg),
        .o_y_data(LUT_current_reg[3].y_reg),
        .o_desc_data(LUT_current_reg[3].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg4 (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr((bwd_idx+(PARALLEL_FACTOR-1))),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(LUT_current_reg[PARALLEL_FACTOR-1].x_reg),
        .o_y_data(LUT_current_reg[PARALLEL_FACTOR-1].y_reg),
        .o_desc_data(LUT_current_reg[PARALLEL_FACTOR-1].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg_single (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr(storage_count),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(current_wire.x_reg),
        .o_y_data(current_wire.y_reg),
        .o_desc_data(current_wire.desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) LUT_current_reg_single2 (
        .clk(clk),
        .i_x_data(cornerX),
        .i_y_data(cornerY),
        .i_desc_data(Brief_Descriptor),
        .i_write_addr(index_count),
        .i_read_addr(forward_matching_reg[storage_count].match_addr),
        .write_enable(LUT_current_reg_wen),
        .o_x_data(mfx),
        .o_y_data(mfy),
        .o_desc_data()
    );


    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_ram0 (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr(fwd_idx),
        .write_enable(prev_ram_wen),
        .o_x_data(LUT_prev_reg[0].x_reg),
        .o_y_data(LUT_prev_reg[0].y_reg),
        .o_desc_data(LUT_prev_reg[0].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_ram1 (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr((fwd_idx+1)),
        .write_enable(prev_ram_wen),
        .o_x_data(LUT_prev_reg[1].x_reg),
        .o_y_data(LUT_prev_reg[1].y_reg),
        .o_desc_data(LUT_prev_reg[1].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_ram2 (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr((fwd_idx+2)),
        .write_enable(prev_ram_wen),
        .o_x_data(LUT_prev_reg[2].x_reg),
        .o_y_data(LUT_prev_reg[2].y_reg),
        .o_desc_data(LUT_prev_reg[2].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_ram3 (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr((fwd_idx+3)),
        .write_enable(prev_ram_wen),
        .o_x_data(LUT_prev_reg[3].x_reg),
        .o_y_data(LUT_prev_reg[3].y_reg),
        .o_desc_data(LUT_prev_reg[3].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_ram4 (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr((fwd_idx+(PARALLEL_FACTOR-1))),
        .write_enable(prev_ram_wen),
        .o_x_data(LUT_prev_reg[PARALLEL_FACTOR-1].x_reg),
        .o_y_data(LUT_prev_reg[PARALLEL_FACTOR-1].y_reg),
        .o_desc_data(LUT_prev_reg[PARALLEL_FACTOR-1].desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_single (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr(prev_single_read_addr),
        .write_enable(prev_ram_wen),
        .o_x_data(prev_wire.x_reg),
        .o_y_data(prev_wire.y_reg),
        .o_desc_data(prev_wire.desc_reg)
    );
    features_ram #(
        .RAM_SIZE(RAM_SIZE),
        .PATTERN(PATTERN),
        .X_WIDTH(X_WIDTH),
        .Y_WIDTH(Y_WIDTH)
    ) prev_single2 (
        .clk(clk),
        .i_x_data(current_wire.x_reg),
        .i_y_data(current_wire.y_reg),
        .i_desc_data(current_wire.desc_reg),
        .i_write_addr(prev_index_count),
        .i_read_addr(backward_matching_reg[storage_count].match_addr),
        .write_enable(prev_ram_wen),
        .o_x_data(mbx),
        .o_y_data(mby),
        .o_desc_data()
    );


    //================================================================
    // Function
    //================================================================
    function automatic logic [$clog2(PATTERN+1)-1:0] count_ones(input logic [PATTERN-1:0] data);
        logic [$clog2(PATTERN+1)-1:0] sum = '0;
        for (int i = 0; i < PATTERN; i = i + 1) begin
            sum = sum + data[i];
        end
        return sum;
    endfunction

    //================================================================
    // assign
    //================================================================
    assign prev_single_read_addr = (state == ARBITRATION) ? forward_matching_reg[storage_count].match_addr : storage_count;
    
    //================================================================
    // FSM
    //================================================================
    always_ff @( posedge clk ) begin : FSM_INIT
        if (reset) begin
            state <= IDLE;
            index_count <= 0;
            prev_cornerX <= 0;
            prev_index_count <= 0;
            storage_count <= 0;
            exist_flag <= 0;
            no_storage <= 0;
            current_feature_X <= 0;
            current_feature_Y <= 0;
            prev_feature_X <= 0;
            prev_feature_Y <= 0;
            forward_stop <= 0;
            backward_stop <= 0;
            fwd_idx <= 0;
            bwd_idx <= 0;
            pair_valid <= 0;
            for (int i = 0; i < RAM_SIZE; i = i + 1) begin
                forward_matching_reg[i].match_addr = RAM_SIZE-1;
                forward_matching_reg[i].weight = '1;
                backward_matching_reg[i].match_addr = RAM_SIZE-1;
                backward_matching_reg[i].weight = '1;
            end
            pair_done <= 0;
        end
        else begin
            state <= next_state;
            prev_cornerX <= next_prev_cornerX;
            index_count <= next_index_count;
            prev_index_count <= next_prev_index_count;
            storage_count <= next_storage_count;
            exist_flag <= next_exist_flag;
            no_storage <= next_no_storage;
            current_feature_X <= next_current_feature_X;
            current_feature_Y <= next_current_feature_Y;
            prev_feature_X <= next_prev_feature_X;
            prev_feature_Y <= next_prev_feature_Y;
            forward_matching_reg <= next_forward_matching_reg;
            backward_matching_reg <= next_backward_matching_reg;
            forward_stop <= next_forward_stop;
            backward_stop <= next_backward_stop;
            fwd_idx <= next_fwd_idx;
            bwd_idx <= next_bwd_idx;
            pair_valid <= next_pair_valid;
            pair_done <= next_pair_done;
        end
    end

    always_comb begin : FSM_BEHAVIOR
        next_state = state;
        LUT_current_reg_wen = 0;
        prev_ram_wen = 0;

        // State IDLE
        next_exist_flag = exist_flag;
        next_no_storage = no_storage;
        next_index_count = index_count;
        next_prev_cornerX = prev_cornerX;

        // State MATCHING
        current_f = 0;
        current_b = 0;
        fx_diff = 0;
        fy_diff = 0;
        bx_diff = 0;
        by_diff = 0;
        lfx_diff = 0;
        lbx_diff = 0;
        lfy_diff = 0;
        lby_diff = 0;
        lfx_diff2 = 0;
        lbx_diff2 = 0;
        lfy_diff2 = 0;
        lby_diff2 = 0;
        mfx_diff = 0;
        mbx_diff = 0;
        mfy_diff = 0;
        mby_diff = 0;
        
        for (int i = 0; i < PARALLEL_FACTOR; i = i + 1) begin
            fmatching_weight[i] = 0;
            bmatching_weight[i] = 0;
        end
        next_fwd_idx = fwd_idx;
        next_bwd_idx = bwd_idx;
        next_forward_stop = forward_stop;
        next_backward_stop = backward_stop;
        next_forward_matching_reg = forward_matching_reg;
        next_backward_matching_reg = backward_matching_reg;

        local_forward_matching_reg.match_addr = '0;
        local_forward_matching_reg.weight = '1;
        local_backward_matching_reg.match_addr = '0;
        local_backward_matching_reg.weight = '1;
        // State ARBITRATION
        next_pair_valid = pair_valid;
        next_current_feature_X = current_feature_X;
        next_current_feature_Y = current_feature_Y;
        next_prev_feature_X = prev_feature_X;
        next_prev_feature_Y = prev_feature_Y;

        // State COPY
        next_pair_done = 0;
        current_i = 0;
        next_prev_index_count = prev_index_count;
        next_storage_count = storage_count;
        inner_forward_stop = (fwd_idx + PARALLEL_FACTOR >= index_count);
        inner_backward_stop = (bwd_idx + PARALLEL_FACTOR >= prev_index_count);

        case (state)
            IDLE: begin
                next_prev_cornerX = cornerX;             
                if ((prev_cornerX != cornerX) && (no_storage == 0)) begin
                    LUT_current_reg_wen = 1;
                    if (index_count == RAM_SIZE - 1) begin
                        next_no_storage = 1;
                    end
                    else begin
                        next_index_count = index_count + 1;
                    end
                end

                if (x_coor == HORIZEN - 2 && y_coor == VERTICAL - 1) begin
                    if (exist_flag) begin
                        next_state = MATCHING;
                        next_no_storage = 0;
                    end
                    else begin
                        next_state = COPY;
                        next_exist_flag = 1;
                        next_no_storage = 0;
                    end
                end
            end
            MATCHING: begin
                if (storage_count >= index_count) begin
                    next_forward_stop = 1;
                end
                if (storage_count >= prev_index_count) begin
                    next_backward_stop = 1;
                end

                // forward
                if (!forward_stop) begin
                    for (int i = 0; i < PARALLEL_FACTOR; i = i + 1) begin
                        current_f = fwd_idx + i;

                        if (current_f <= index_count) begin
                            fmatching_weight[i] = count_ones(current_wire.desc_reg ^ LUT_prev_reg[i].desc_reg);
                        end
                        else begin
                            fmatching_weight[i] = '1;
                        end
                    end
                    fx_diff = (current_wire.x_reg < LUT_prev_reg[0].x_reg) ? LUT_prev_reg[0].x_reg - current_wire.x_reg : current_wire.x_reg - LUT_prev_reg[0].x_reg;
                    fy_diff = (current_wire.y_reg < LUT_prev_reg[0].y_reg) ? LUT_prev_reg[0].y_reg - current_wire.y_reg : current_wire.y_reg - LUT_prev_reg[0].y_reg;
                    if ((fx_diff < MATCH_LIMIT_X) && (fy_diff < MATCH_LIMIT_Y)) begin
                        local_forward_matching_reg.match_addr = 0;
                        local_forward_matching_reg.weight = fmatching_weight[0];
                    end
                    else begin
                        local_forward_matching_reg.match_addr = 0;
                        local_forward_matching_reg.weight = '1;
                    end

                    for (int i = 1; i < PARALLEL_FACTOR; i = i + 1) begin
                        fx_diff = (current_wire.x_reg < LUT_prev_reg[i].x_reg) ? LUT_prev_reg[i].x_reg - current_wire.x_reg : current_wire.x_reg - LUT_prev_reg[i].x_reg;
                        fy_diff = (current_wire.y_reg < LUT_prev_reg[i].y_reg) ? LUT_prev_reg[i].y_reg - current_wire.y_reg : current_wire.y_reg - LUT_prev_reg[i].y_reg;
                        lfx_diff = (current_wire.x_reg < LUT_prev_reg[local_forward_matching_reg.match_addr].x_reg) ? LUT_prev_reg[local_forward_matching_reg.match_addr].x_reg - current_wire.x_reg : current_wire.x_reg - LUT_prev_reg[local_forward_matching_reg.match_addr].x_reg;
                        lfy_diff = (current_wire.y_reg < LUT_prev_reg[local_forward_matching_reg.match_addr].y_reg) ? LUT_prev_reg[local_forward_matching_reg.match_addr].y_reg - current_wire.y_reg : current_wire.y_reg - LUT_prev_reg[local_forward_matching_reg.match_addr].y_reg;
                        
                        
                        if ( (fmatching_weight[i] < MAX_WEIGHT) &&
                            (fx_diff < MATCH_LIMIT_X) &&
                            (fy_diff < MATCH_LIMIT_Y)) begin
                            if((fmatching_weight[i] < local_forward_matching_reg.weight)) begin
                                local_forward_matching_reg.weight = fmatching_weight[i];
                                local_forward_matching_reg.match_addr = i;
                            end
                            else if((fmatching_weight[i] == local_forward_matching_reg.weight) && ((fx_diff <= lfx_diff) && (fy_diff <= lfy_diff))) begin
                                local_forward_matching_reg.weight = fmatching_weight[i];
                                local_forward_matching_reg.match_addr = i;
                            end
                            
                        end
                    end
                    lfx_diff2 = (current_wire.x_reg < LUT_prev_reg[local_forward_matching_reg.match_addr].x_reg) ? LUT_prev_reg[local_forward_matching_reg.match_addr].x_reg - current_wire.x_reg : current_wire.x_reg - LUT_prev_reg[local_forward_matching_reg.match_addr].x_reg;
                    lfy_diff2 = (current_wire.y_reg < LUT_prev_reg[local_forward_matching_reg.match_addr].y_reg) ? LUT_prev_reg[local_forward_matching_reg.match_addr].y_reg - current_wire.y_reg : current_wire.y_reg - LUT_prev_reg[local_forward_matching_reg.match_addr].y_reg;
                    // 얘가 값이 좀 이상함
                    mfx_diff = (current_wire.x_reg < mfx) ? mfx - current_wire.x_reg : current_wire.x_reg - mfx;
                    mfy_diff = (current_wire.y_reg < mfy) ? mfy - current_wire.y_reg : current_wire.y_reg - mfy;
                    if (local_forward_matching_reg.weight < forward_matching_reg[storage_count].weight) begin
                        next_forward_matching_reg[storage_count].weight = local_forward_matching_reg.weight;
                        next_forward_matching_reg[storage_count].match_addr = local_forward_matching_reg.match_addr + fwd_idx;
                    end
                    else if ((local_forward_matching_reg.weight == forward_matching_reg[storage_count].weight) && ((lfx_diff2 <= mfx_diff) && (lfy_diff2 <= mfy_diff))) begin
                        next_forward_matching_reg[storage_count].weight = local_forward_matching_reg.weight;
                        next_forward_matching_reg[storage_count].match_addr = local_forward_matching_reg.match_addr + fwd_idx;
                    end
  
                end

                // backward
                if (!backward_stop) begin
                    for (int i = 0; i < PARALLEL_FACTOR; i = i + 1) begin
                        current_b = bwd_idx + i;

                        if (current_b <= prev_index_count) begin
                            bmatching_weight[i] = count_ones(prev_wire.desc_reg ^ LUT_current_reg[i].desc_reg);
                        end
                        else begin
                            bmatching_weight[i] = '1;
                        end
                    end
                    bx_diff = (LUT_current_reg[0].x_reg < prev_wire.x_reg) ? prev_wire.x_reg - LUT_current_reg[0].x_reg : LUT_current_reg[0].x_reg - prev_wire.x_reg;
                    by_diff = (LUT_current_reg[0].y_reg < prev_wire.y_reg) ? prev_wire.y_reg - LUT_current_reg[0].y_reg : LUT_current_reg[0].y_reg - prev_wire.y_reg;
                    if ((bx_diff < MATCH_LIMIT_X) && (by_diff < MATCH_LIMIT_Y)) begin    
                        local_backward_matching_reg.match_addr = 0;
                        local_backward_matching_reg.weight = bmatching_weight[0];
                    end
                    else begin
                        local_backward_matching_reg.match_addr = 0;
                        local_backward_matching_reg.weight = '1;
                    end

                    for (int i = 1; i < PARALLEL_FACTOR; i = i + 1) begin
                        bx_diff = (LUT_current_reg[i].x_reg < prev_wire.x_reg) ? prev_wire.x_reg - LUT_current_reg[i].x_reg : LUT_current_reg[i].x_reg - prev_wire.x_reg;
                        by_diff = (LUT_current_reg[i].y_reg < prev_wire.y_reg) ? prev_wire.y_reg - LUT_current_reg[i].y_reg : LUT_current_reg[i].y_reg - prev_wire.y_reg;
                        lbx_diff = (LUT_current_reg[local_backward_matching_reg.match_addr].x_reg < prev_wire.x_reg) ? prev_wire.x_reg - LUT_current_reg[local_backward_matching_reg.match_addr].x_reg : LUT_current_reg[local_backward_matching_reg.match_addr].x_reg - prev_wire.x_reg;
                        lby_diff = (LUT_current_reg[local_backward_matching_reg.match_addr].y_reg < prev_wire.y_reg) ? prev_wire.y_reg - LUT_current_reg[local_backward_matching_reg.match_addr].y_reg : LUT_current_reg[local_backward_matching_reg.match_addr].y_reg - prev_wire.y_reg;
                        
                        if ((bmatching_weight[i] < MAX_WEIGHT) &&
                            (bx_diff < MATCH_LIMIT_X) &&
                            (by_diff < MATCH_LIMIT_Y)) begin

                            if (bmatching_weight[i] < local_backward_matching_reg.weight) begin
                                local_backward_matching_reg.weight = bmatching_weight[i];
                                local_backward_matching_reg.match_addr = i;
                            end
                            if ((bmatching_weight[i] == local_backward_matching_reg.weight) && ((bx_diff <= lbx_diff) && (by_diff <= lby_diff))) begin 
                                local_backward_matching_reg.weight = bmatching_weight[i];
                                local_backward_matching_reg.match_addr = i;
                            end
                        end
                    end
                    lbx_diff2 = (LUT_current_reg[local_backward_matching_reg.match_addr].x_reg < prev_wire.x_reg) ? prev_wire.x_reg - LUT_current_reg[local_backward_matching_reg.match_addr].x_reg : LUT_current_reg[local_backward_matching_reg.match_addr].x_reg - prev_wire.x_reg;
                    lby_diff2 = (LUT_current_reg[local_backward_matching_reg.match_addr].y_reg < prev_wire.y_reg) ? prev_wire.y_reg - LUT_current_reg[local_backward_matching_reg.match_addr].y_reg : LUT_current_reg[local_backward_matching_reg.match_addr].y_reg - prev_wire.y_reg;
                    mbx_diff = (mbx < prev_wire.x_reg) ? prev_wire.x_reg - mbx : mbx - prev_wire.x_reg;
                    mby_diff = (mby < prev_wire.y_reg) ? prev_wire.y_reg - mby : mby - prev_wire.y_reg;
                    
                    if (local_backward_matching_reg.weight < backward_matching_reg[storage_count].weight) begin
                        next_backward_matching_reg[storage_count].weight = local_backward_matching_reg.weight;
                        next_backward_matching_reg[storage_count].match_addr = local_backward_matching_reg.match_addr + bwd_idx;
                    end
                    else if ((local_backward_matching_reg.weight == backward_matching_reg[storage_count].weight) && ((lbx_diff2 <= mbx_diff) && (lby_diff2 <= mby_diff))) begin
                        next_backward_matching_reg[storage_count].weight = local_backward_matching_reg.weight;
                        next_backward_matching_reg[storage_count].match_addr = local_backward_matching_reg.match_addr + bwd_idx;
                    end
                        
                end

                if (inner_forward_stop == 1 && inner_backward_stop == 1) begin
                    next_storage_count = storage_count + 1;
                    next_fwd_idx = 0;
                    next_bwd_idx = 0;
                end
                else if (inner_forward_stop == 1) begin 
                    next_bwd_idx = bwd_idx + PARALLEL_FACTOR;                    
                end
                else if (inner_backward_stop == 1) begin
                    next_fwd_idx = fwd_idx + PARALLEL_FACTOR;
                end
                else begin
                    next_fwd_idx = fwd_idx + PARALLEL_FACTOR;
                    next_bwd_idx = bwd_idx + PARALLEL_FACTOR;                    
                end

                if (forward_stop == 1 && backward_stop == 1) begin
                    next_state = ARBITRATION;
                    next_storage_count = 0;
                    next_fwd_idx = 0;
                    next_bwd_idx = 0;
                    next_forward_stop = 0;
                    next_backward_stop = 0;
                end
            end
            ARBITRATION: begin
                next_pair_valid = 0;
                if (storage_count == index_count) begin
                    next_state = COPY;
                    next_storage_count = 0;
                    next_prev_index_count = 0;
                end
                else begin
                    next_storage_count = storage_count + 1;
                end

                if( (storage_count == backward_matching_reg[forward_matching_reg[storage_count].match_addr].match_addr)) begin
                    next_current_feature_X = current_wire.x_reg;
                    next_current_feature_Y = current_wire.y_reg;
                    next_prev_feature_X = prev_wire.x_reg;
                    next_prev_feature_Y = prev_wire.y_reg;
                    next_pair_valid = 1;
                end
                else begin    
                    next_current_feature_X = current_wire.x_reg;
                    next_current_feature_Y = current_wire.y_reg;
                    next_prev_feature_X = current_wire.x_reg;
                    next_prev_feature_Y = current_wire.y_reg;
                end
            end
            COPY: begin
                next_current_feature_X = 0;
                next_current_feature_Y = 0;
                next_prev_feature_X = 0;
                next_prev_feature_Y = 0;
                next_pair_done = 1'b1;
                next_pair_valid = 1'b0;
                prev_ram_wen = 1;
                if (prev_index_count < index_count) begin
                    next_prev_index_count = prev_index_count + 1;
                    next_storage_count = storage_count + 1;
                    
                end
                else begin
                    next_state = IDLE;
                    for (int i = 0; i < RAM_SIZE; i = i + 1) begin
                        next_forward_matching_reg[i].match_addr = RAM_SIZE-1;
                        next_forward_matching_reg[i].weight = '1;
                        next_backward_matching_reg[i].match_addr = RAM_SIZE-1;
                        next_backward_matching_reg[i].weight = '1;
                    end
                    next_index_count = 0;
                    next_storage_count = 0;
                end
            end
        endcase
    end

endmodule

module features_ram #(
    parameter RAM_SIZE = 100,
    parameter PATTERN = 120,
    parameter X_WIDTH = 10,
    parameter Y_WIDTH = 10
) (
    input logic clk,

    input logic [X_WIDTH-1:0] i_x_data,
    input logic [Y_WIDTH-1:0] i_y_data,
    input logic [PATTERN-1:0] i_desc_data,
    input logic [$clog2(RAM_SIZE)-1:0] i_write_addr,
    input logic [$clog2(RAM_SIZE)-1:0] i_read_addr,
    input logic write_enable,

    output logic [X_WIDTH-1:0] o_x_data,
    output logic [Y_WIDTH-1:0] o_y_data,
    output logic [PATTERN-1:0] o_desc_data
);

    ram #(.RAM_SIZE(RAM_SIZE), .DATA_SIZE(X_WIDTH)) x_ram(
        .clk(clk),
        .i_data(i_x_data),
        .i_write_addr(i_write_addr),
        .write_enable(write_enable),
        .o_data(o_x_data),
        .i_read_addr(i_read_addr)
    );
    ram #(.RAM_SIZE(RAM_SIZE), .DATA_SIZE(Y_WIDTH)) y_ram(
        .clk(clk),
        .i_data(i_y_data),
        .i_write_addr(i_write_addr),
        .write_enable(write_enable),
        .o_data(o_y_data),
        .i_read_addr(i_read_addr)
    );
    ram #(.RAM_SIZE(RAM_SIZE), .DATA_SIZE(PATTERN)) desc_ram(
        .clk(clk),
        .i_data(i_desc_data),
        .i_write_addr(i_write_addr),
        .write_enable(write_enable),
        .o_data(o_desc_data),
        .i_read_addr(i_read_addr)
    );
    
endmodule

module ram #(
    parameter RAM_SIZE = 100,
    parameter DATA_SIZE = 120
) (
    input logic clk,

    input logic [DATA_SIZE-1:0] i_data,
    input logic [$clog2(RAM_SIZE)-1:0] i_write_addr,
    input logic [$clog2(RAM_SIZE)-1:0] i_read_addr,
    input logic write_enable,

    output logic [DATA_SIZE-1:0] o_data
);

    logic [DATA_SIZE-1:0] mem [RAM_SIZE-1:0];

    always_ff @(posedge clk) begin : WRITE
        if (write_enable) begin
            mem[i_write_addr] <= i_data;
        end
    end

    always_comb begin : READ
        o_data = mem[i_read_addr];
    end
    
endmodule