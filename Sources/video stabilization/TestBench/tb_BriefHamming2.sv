`timescale 1ns / 1ps

module tb_hh;

    //================================================================
    // Parameter
    //================================================================
    parameter PATTERN = 30;
    parameter RAM_SIZE = 100;
    parameter VERTICAL = 240;
    parameter HORIZEN = 320;
    parameter MATCH_LIMIT_X = 30;
    parameter MATCH_LIMIT_Y = 30;
    parameter MAX_WEIGHT = 20;
    // PARALLEL_FACTOR, X_WIDTH, Y_WIDTH는 DUT에 없으므로 TB에서 제거
    // 필요한 파라미터는 DUT에서 자동으로 가져옵니다.

    //================================================================
    // DUT IO
    //================================================================
    logic clk;
    logic reset;
    // DUT의 파라미터를 사용하여 IO의 너비를 자동으로 맞춥니다.
    logic [dut.X_WIDTH-1:0] x_coor;
    logic [dut.Y_WIDTH-1:0] y_coor;
    logic [dut.X_WIDTH-1:0] cornerX;
    logic [dut.Y_WIDTH-1:0] cornerY;
    logic [PATTERN-1:0] Brief_Descriptor;
    logic [dut.X_WIDTH-1:0] current_feature_X;
    logic [dut.Y_WIDTH-1:0] current_feature_Y;
    logic [dut.X_WIDTH-1:0] prev_feature_X;
    logic [dut.Y_WIDTH-1:0] prev_feature_Y;
    logic pair_valid;
    logic pair_done;

    typedef enum { IDLE, MATCHING, ARBITRATION, COPY} state_e;
    //================================================================
    // DUT Instance
    //================================================================
    Hamming_Processor #(
        .PATTERN(PATTERN),
        .RAM_SIZE(RAM_SIZE),
        .VERTICAL(VERTICAL),
        .HORIZEN(HORIZEN),
        .MATCH_LIMIT_X(MATCH_LIMIT_X),
        .MATCH_LIMIT_Y(MATCH_LIMIT_Y),
        .MAX_WEIGHT(MAX_WEIGHT)
    ) dut (
        .clk(clk),
        .reset(reset),
        .x_coor(x_coor),
        .y_coor(y_coor),
        .cornerX(cornerX),
        .cornerY(cornerY),
        .Brief_Descriptor(Brief_Descriptor),
        .current_feature_X(current_feature_X),
        .current_feature_Y(current_feature_Y),
        .prev_feature_X(prev_feature_X),
        .prev_feature_Y(prev_feature_Y),
        .pair_valid(pair_valid),
        .pair_done(pair_done)
    );

    //================================================================
    // Clock and Reset Generation (기존과 동일)
    //================================================================
    initial clk = 0;
    always #5 clk = ~clk;  // 100MHz

    initial begin
        reset = 1;
        #20;
        reset = 0;
    end
    
    //================================================================
    // Frame Counter
    //================================================================
    integer frame_count = 0;

    //================================================================
    // Stimulus (가장 중요한 수정 부분)
    //================================================================
    
    // 한 프레임을 스캔하는 태스크
    task scan_one_frame;
        $display("Time: %0t, [Frame %0d] Starting frame scan.", $time, frame_count);
        wait(dut.state == IDLE);
        // x, y 좌표를 0부터 HORIZEN-1, VERTICAL-1까지 스캔
        for (int y = 0; y < VERTICAL; y = y + 1) begin
            for (int x = 0; x < HORIZEN; x = x + 1) begin
                @(posedge clk);
                x_coor <= x;
                y_coor <= y;

                // 매 픽셀을 코너로 가정하고 데이터 생성 (기존 로직 유지)
                // 실제 시나리오에서는 특정 조건에만 코너를 발생시켜야 함
                cornerX <= x;
                cornerY <= y;
                // 프레임마다 다른 디스크립터 값을 생성
                Brief_Descriptor <= (x + y + frame_count) * 37;
            end
        end
        
        // 프레임 스캔 완료 후 입력 신호를 0으로 초기화
        @(posedge clk);
        x_coor <= 0;
        y_coor <= 0;
        cornerX <= 0;
        cornerY <= 0;
        Brief_Descriptor <= 0;
        
        $display("Time: %0t, [Frame %0d] Frame scan finished. Waiting for DUT to complete matching (pair_done)...", $time, frame_count);
    endtask


    initial begin
        // 초기값 설정
        x_coor = 0;
        y_coor = 0;
        cornerX = 0;
        cornerY = 0;
        Brief_Descriptor = 0;

        // 리셋 해제 대기
        @(negedge reset);
        
        // 여러 프레임을 순차적으로 시뮬레이션
        for (int i = 0; i < 5; i = i + 1) begin
            // 1. 현재 프레임 스캔
            scan_one_frame();
            
            // 3. 다음 프레임 시작 전 한 클럭 대기 (안정성 확보)
            @(posedge clk);
            
            // 4. 프레임 카운터 증가
            frame_count = frame_count + 1;
        end
        
        $display("Time: %0t, Finished simulation of %0d frames.", $time, frame_count);
        $finish;
    end

    //================================================================
    // Monitor (디버깅용)
    //================================================================
    initial begin
        $monitor("Time=%0t | Frame=%0d | x_coor=%3d, y_coor=%3d | pair_done=%b | pair_valid=%b | prev(X,Y)=(%3d,%3d) curr(X,Y)=(%3d,%3d)",
                 $time, frame_count, x_coor, y_coor, pair_done, pair_valid, prev_feature_X, prev_feature_Y, current_feature_X, current_feature_Y);
    end

endmodule