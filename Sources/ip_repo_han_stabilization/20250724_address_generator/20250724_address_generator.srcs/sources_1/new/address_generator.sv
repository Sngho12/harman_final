`timescale 1ns / 1ps

module affine_address_modifier #(
    parameter LINE_LENGHT = 640,
    parameter FRAME_HEIGHT = 480,
    parameter ADDRESS_SIZE_X = 10,
    parameter ADDRESS_SIZE_Y = 10,
    parameter ACCUMUL_AFFINE_ROTATE_THRES = 300,
    parameter ACCUMUL_AFFINE_X_THRES = 100,
    parameter ACCUMUL_AFFINE_Y_THRES = 100,
    parameter ROTATION_RESILIENCE = 3,
    parameter TRANSLATION_X_RESILIENCE = 1,
    parameter TRANSLATION_Y_RESILIENCE = 1
) (
    input logic clk,
    input logic reset,
    input logic [ADDRESS_SIZE_X - 1:0] x_pixel,
    input logic [ADDRESS_SIZE_Y - 1:0] y_pixel,

    // input logic signed [11:0] affine_matrix_a11,  // 1024±ROTATE_THRES
    // input logic signed [11:0] affine_matrix_a12,  // ±ROTATE_THRES
    input logic signed [17:0] affine_matrix_dx,  // ±1024×DX_THRES
    // input logic signed [11:0] affine_matrix_a21,  // ±ROTATE_THRES
    // input logic signed [11:0] affine_matrix_a22,  // 1024±ROTATE_THRES
    input logic signed [17:0] affine_matrix_dy,  // ±1024×DY_THRES
    input logic lansac_done,

    output logic [ADDRESS_SIZE_X - 1:0] modified_x_pixel,
    output logic [ADDRESS_SIZE_Y - 1:0] modified_y_pixel
);
    logic signed [11:0] acc_affine_matrix_a11_reg, acc_affine_matrix_a11_next;
    logic signed [11:0] acc_affine_matrix_a12_reg, acc_affine_matrix_a12_next;
    logic signed [17:0] acc_affine_matrix_dx_reg, acc_affine_matrix_dx_next;
    logic signed [11:0] acc_affine_matrix_a21_reg, acc_affine_matrix_a21_next;
    logic signed [11:0] acc_affine_matrix_a22_reg, acc_affine_matrix_a22_next;
    logic signed [17:0] acc_affine_matrix_dy_reg, acc_affine_matrix_dy_next;

    logic signed [23:0] pre_acc_affine_matrix_a11_reg;
    logic signed [23:0] pre_acc_affine_matrix_a12_reg;
    logic signed [35:0] pre_acc_affine_matrix_dx_reg;
    logic signed [23:0] pre_acc_affine_matrix_a21_reg;
    logic signed [23:0] pre_acc_affine_matrix_a22_reg;
    logic signed [35:0] pre_acc_affine_matrix_dy_reg;

    logic signed [ADDRESS_SIZE_X*2:0] s_x_pixel;
    logic signed [ADDRESS_SIZE_Y*2:0] s_y_pixel;
    logic signed [ADDRESS_SIZE_X*2:0] compute_x_pixel;
    logic signed [ADDRESS_SIZE_Y*2:0] compute_y_pixel;

    logic signed [11:0] inv_a11;
    logic signed [11:0] inv_a12;
    logic signed [11:0] inv_a21;
    logic signed [11:0] inv_a22;
    logic signed [23:0] det;

    assign s_x_pixel = x_pixel;
    assign s_y_pixel = y_pixel;

    always_ff @(posedge clk or posedge reset) begin : update_affine
        if (reset) begin
            acc_affine_matrix_a11_reg <= 1024;
            acc_affine_matrix_a12_reg <= 0;
            acc_affine_matrix_dx_reg  <= 0;
            acc_affine_matrix_a21_reg <= 0;
            acc_affine_matrix_a22_reg <= 1024;
            acc_affine_matrix_dy_reg  <= 0;
        end else begin
            acc_affine_matrix_a11_reg <= acc_affine_matrix_a11_next;
            acc_affine_matrix_a12_reg <= acc_affine_matrix_a12_next;
            acc_affine_matrix_dx_reg  <= acc_affine_matrix_dx_next;
            acc_affine_matrix_a21_reg <= acc_affine_matrix_a21_next;
            acc_affine_matrix_a22_reg <= acc_affine_matrix_a22_next;
            acc_affine_matrix_dy_reg  <= acc_affine_matrix_dy_next;
        end
    end

    always_comb begin : modify_xy
        acc_affine_matrix_a11_next = acc_affine_matrix_a11_reg;
        acc_affine_matrix_a12_next = acc_affine_matrix_a12_reg;
        acc_affine_matrix_dx_next = acc_affine_matrix_dx_reg;
        acc_affine_matrix_a21_next = acc_affine_matrix_a21_reg;
        acc_affine_matrix_a22_next = acc_affine_matrix_a22_reg;
        acc_affine_matrix_dy_next = acc_affine_matrix_dy_reg;

        // // 역행렬 계산 (Python과 동일)
        // det = (acc_affine_matrix_a11_reg * acc_affine_matrix_a22_reg - acc_affine_matrix_a12_reg * acc_affine_matrix_a21_reg) >>> 10; // 1024^2 스케일

        // if (det < 1 && det > -1) begin
        //     inv_a11 = 1024;  // 단위 행렬
        //     inv_a12 = 0;
        //     inv_a21 = 0;
        //     inv_a22 = 1024;
        // end else begin
        //     // scale = 1024 * 1024 / det (고정 소수점 나눗셈 근사)
        //     inv_a11 = ((acc_affine_matrix_a22_reg <<<10) / det); // 스케일 보상
        //     inv_a12 = ((-acc_affine_matrix_a12_reg <<< 10) / det);
        //     inv_a21 = ((-acc_affine_matrix_a21_reg <<< 10) / det);
        //     inv_a22 = ((acc_affine_matrix_a11_reg <<< 10) / det);
        // end
        inv_a11 = 1024;  // 단위 행렬
        inv_a12 = 0;
        inv_a21 = 0;
        inv_a22 = 1024;
        // 역변환
        // compute_x_pixel= ((inv_a11 * (x_pixel * 1024 - (acc_affine_matrix_dx_reg >>> 10))) + (inv_a12 * (y_pixel * 1024 - (acc_affine_matrix_dy_reg >>> 10))) )>>>20;
        // compute_y_pixel= ((inv_a21 * (x_pixel * 1024 - (acc_affine_matrix_dx_reg >>> 10))) + (inv_a22 * (y_pixel * 1024 - (acc_affine_matrix_dy_reg >>> 10))) )>>>20;
        compute_x_pixel= ((s_x_pixel<<<10) + acc_affine_matrix_dx_reg)>>>10;
        compute_y_pixel= ((s_y_pixel<<<10) + acc_affine_matrix_dy_reg)>>>10;
        if(  (compute_x_pixel > LINE_LENGHT-1) | (compute_x_pixel < 0) |(compute_y_pixel > FRAME_HEIGHT-1) |(compute_y_pixel < 0)) begin
            modified_x_pixel = 0;
            modified_y_pixel = 0;
        end else begin
            modified_x_pixel = compute_x_pixel;
            modified_y_pixel = compute_y_pixel;
        end
        // pre_acc_affine_matrix_a11_reg= ((affine_matrix_a11 * acc_affine_matrix_a11_reg) + (affine_matrix_a12 * acc_affine_matrix_a21_reg))>>>10;
        // pre_acc_affine_matrix_a12_reg = ((affine_matrix_a11 * acc_affine_matrix_a12_reg) + (affine_matrix_a12 * acc_affine_matrix_a22_reg))>>>10;
        // pre_acc_affine_matrix_dx_reg = ((affine_matrix_a11 * acc_affine_matrix_dx_reg) + (affine_matrix_a12 * acc_affine_matrix_dy_reg))>>>10  +  affine_matrix_dx;
        // pre_acc_affine_matrix_a21_reg = ((affine_matrix_a21 * acc_affine_matrix_a11_reg) + (affine_matrix_a22 * acc_affine_matrix_a21_reg))>>>10;
        // pre_acc_affine_matrix_a22_reg = ((affine_matrix_a21 * acc_affine_matrix_a12_reg) + (affine_matrix_a22 * acc_affine_matrix_a22_reg))>>>10;
        // pre_acc_affine_matrix_dy_reg = ((affine_matrix_a21 * acc_affine_matrix_dx_reg) + (affine_matrix_a22 * acc_affine_matrix_dy_reg))>>>10  +  affine_matrix_dy;
        pre_acc_affine_matrix_dx_reg = acc_affine_matrix_dx_reg + affine_matrix_dx;
        pre_acc_affine_matrix_dy_reg = acc_affine_matrix_dy_reg + affine_matrix_dy;
        if (lansac_done) begin
            // if(  pre_acc_affine_matrix_a11_reg < (1024 - ACCUMUL_AFFINE_ROTATE_THRES)) begin
            //     acc_affine_matrix_a11_next = 1024 - ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a11_reg > (1024 + ACCUMUL_AFFINE_ROTATE_THRES))begin
            //     acc_affine_matrix_a11_next = 1024 + ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a11_reg < 1024) begin
            //     acc_affine_matrix_a11_next = pre_acc_affine_matrix_a11_reg + ((1024-pre_acc_affine_matrix_a11_reg + (1<<(10-ROTATION_RESILIENCE)) )>>(10-ROTATION_RESILIENCE));
            // end else begin
            //     acc_affine_matrix_a11_next = pre_acc_affine_matrix_a11_reg - ((pre_acc_affine_matrix_a11_reg-1024 + (1<<(10-ROTATION_RESILIENCE)) )>>(10-ROTATION_RESILIENCE));
            // end
            acc_affine_matrix_a11_next = 1024;
            // if  (pre_acc_affine_matrix_a12_reg <(- ACCUMUL_AFFINE_ROTATE_THRES)) begin
            //     acc_affine_matrix_a12_next = -ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a12_reg > (ACCUMUL_AFFINE_ROTATE_THRES)) begin
            //     acc_affine_matrix_a12_next = ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a12_reg < 0) begin
            //     acc_affine_matrix_a12_next = pre_acc_affine_matrix_a12_reg + ((-pre_acc_affine_matrix_a12_reg + (1<<(10-ROTATION_RESILIENCE)))>>>(10-ROTATION_RESILIENCE));
            // end else begin
            //     acc_affine_matrix_a12_next = pre_acc_affine_matrix_a12_reg - ((pre_acc_affine_matrix_a12_reg + (1<<(10-ROTATION_RESILIENCE)))>>>(10-ROTATION_RESILIENCE));
            // end
            acc_affine_matrix_a12_next = 0;
            // if  (pre_acc_affine_matrix_a21_reg <(- ACCUMUL_AFFINE_ROTATE_THRES)) begin
            //     acc_affine_matrix_a21_next = -ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a21_reg > (ACCUMUL_AFFINE_ROTATE_THRES)) begin
            //     acc_affine_matrix_a21_next = ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a21_reg < 0) begin
            //     acc_affine_matrix_a21_next = pre_acc_affine_matrix_a21_reg + ((-pre_acc_affine_matrix_a21_reg + (1<<(10-ROTATION_RESILIENCE)))>>>(10-ROTATION_RESILIENCE));
            // end else begin
            //     acc_affine_matrix_a21_next = pre_acc_affine_matrix_a21_reg - ((pre_acc_affine_matrix_a21_reg + (1<<(10-ROTATION_RESILIENCE)))>>>(10-ROTATION_RESILIENCE));
            // end
            acc_affine_matrix_a21_next = 0;
            // if(  pre_acc_affine_matrix_a22_reg < (1024 - ACCUMUL_AFFINE_ROTATE_THRES)) begin
            //     acc_affine_matrix_a22_next = 1024 - ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a22_reg > (1024 + ACCUMUL_AFFINE_ROTATE_THRES))begin
            //     acc_affine_matrix_a22_next = 1024 + ACCUMUL_AFFINE_ROTATE_THRES;
            // end else if (pre_acc_affine_matrix_a22_reg < 1024) begin
            //     acc_affine_matrix_a22_next = pre_acc_affine_matrix_a22_reg + ((1024-pre_acc_affine_matrix_a22_reg + (1<<(10-ROTATION_RESILIENCE)) )>>>(10-ROTATION_RESILIENCE));
            // end else begin
            //     acc_affine_matrix_a22_next = pre_acc_affine_matrix_a22_reg - ((pre_acc_affine_matrix_a22_reg-1024 + (1<<(10-ROTATION_RESILIENCE)) )>>>(10-ROTATION_RESILIENCE));
            // end
            acc_affine_matrix_a22_next = 1024;
            if (pre_acc_affine_matrix_dx_reg < (-1024*ACCUMUL_AFFINE_X_THRES)) begin
                acc_affine_matrix_dx_next = -ACCUMUL_AFFINE_X_THRES;
            end else if (pre_acc_affine_matrix_dx_reg > (1024*ACCUMUL_AFFINE_X_THRES)) begin
                acc_affine_matrix_dx_next = 1024 * ACCUMUL_AFFINE_X_THRES;
            end else if (pre_acc_affine_matrix_dx_reg < 0) begin
                acc_affine_matrix_dx_next = pre_acc_affine_matrix_dx_reg+ ((-pre_acc_affine_matrix_dx_reg + (1<<(10-TRANSLATION_X_RESILIENCE)))>>>(10-TRANSLATION_X_RESILIENCE));
            end else begin
                acc_affine_matrix_dx_next = pre_acc_affine_matrix_dx_reg- ((pre_acc_affine_matrix_dx_reg + (1<<(10-TRANSLATION_X_RESILIENCE)))>>>(10-TRANSLATION_X_RESILIENCE));
            end

            if (pre_acc_affine_matrix_dy_reg < (-1024*ACCUMUL_AFFINE_Y_THRES)) begin
                acc_affine_matrix_dy_next = -1024 * ACCUMUL_AFFINE_Y_THRES;
            end else if (pre_acc_affine_matrix_dy_reg > (1024*ACCUMUL_AFFINE_Y_THRES)) begin
                acc_affine_matrix_dy_next = 1024 * ACCUMUL_AFFINE_Y_THRES;
            end else if (pre_acc_affine_matrix_dy_reg < 0) begin
                acc_affine_matrix_dy_next = pre_acc_affine_matrix_dy_reg + ((-pre_acc_affine_matrix_dy_reg + (1<<(10-TRANSLATION_Y_RESILIENCE)))>>>(10-TRANSLATION_Y_RESILIENCE));
            end else begin
                acc_affine_matrix_dy_next = pre_acc_affine_matrix_dy_reg - ((pre_acc_affine_matrix_dy_reg + (1<<(10-TRANSLATION_Y_RESILIENCE)))>>>(10-TRANSLATION_Y_RESILIENCE));
            end
        end
    end
endmodule
