`timescale 1ns / 1ps

module tb_total;

    // 파라미터 및 신호 선언
    localparam CLK_PERIOD = 10; // 10ns -> 100MHz clock

    logic clk;
    logic rst;
    logic [7:0] pixel;
    logic out_pixel;

    // DUT (Device Under Test) 인스턴스화
    total_background dut (
        .clk(clk),
        .rst(rst),
        .pixel(pixel),
        .out_pixel(out_pixel)
    );

    // 클럭 생성
    always #(CLK_PERIOD / 2) clk = ~clk;

    // 테스트 시나리오를 위한 태스크
    task apply_pixel(input [7:0] val, input int cycles);
        repeat (cycles) begin
            pixel <= val;
            @(posedge clk);
        end
    endtask

    // 시뮬레이션 시나리오
    initial begin
        // 1. 초기화 및 리셋
        $display("========================================");
        $display("[%0t] Simulation Start: Initializing...", $time);
        clk = 0;
        rst = 1;
        pixel = 0;
        #10; // 리셋을 몇 클럭 유지
        rst = 0;
        $display("[%0t] Reset is released. Starting main sequence.", $time);
        
        // 2. 배경 학습 단계 (예: 회색 배경)
        $display("========================================");
        $display("[%0t] Phase 1: Learning static background (pixel=100) for 200 cycles.", $time);
        apply_pixel(8'd100, 200);
        $display("[%0t] Background learning phase finished. Output should be stable now.", $time);
        
        // 3. 전경 객체 등장 (예: 밝은 물체)
        $display("========================================");
        $display("[%0t] Phase 2: Foreground object appears (pixel=220) for 50 cycles.", $time);
        $display("         >> Expect 'out_pixel' to become 0 (Foreground)");
        apply_pixel(8'd220, 50);
        
        // 4. 다시 배경으로 복귀
        $display("========================================");
        $display("[%0t] Phase 3: Foreground object disappears. Background (pixel=100) returns for 50 cycles.", $time);
        $display("         >> Expect 'out_pixel' to return to 1 (Background)");
        apply_pixel(8'd100, 50);
        
        // 5. 다른 전경 객체 등장 (예: 어두운 물체)
        $display("========================================");
        $display("[%0t] Phase 4: Another foreground object appears (pixel=30) for 50 cycles.", $time);
        $display("         >> Expect 'out_pixel' to become 0 (Foreground)");
        apply_pixel(8'd30, 50);

        // 시뮬레이션 종료
        $display("========================================");
        $display("[%0t] Simulation Finished.", $time);
        $finish;
    end

    // 출력 모니터링
    always @(posedge clk) begin
        if (!rst) begin
            // $time, pixel 값, out_pixel 값을 출력하여 변화를 관찰
            // 너무 많은 출력을 피하기 위해 특정 시점에만 display 하거나,
            // 변화가 있을 때만 출력하는 로직을 추가할 수 있습니다.
            // 예: if ($time > 4000)
            // $display("[%0t] Input Pixel: %d, Output Class: %b (0=FG, 1=BG)", $time, pixel, out_pixel);
        end
    end

endmodule