module MultiplierSequential(
    input clk, rst,
    input [3:0] A, B,
    output reg [7:0] product
);

//Define States and Present/Next State variables
parameter S0_idle = 0, S1_multiply = 1, S2_update_result = 2, S3_done = 3;
reg [2:0] PS, NS;

//Define internal registers
reg [7:0] partial_product;
reg [2:0] shift_count;
reg [7:0] multiplicand;
reg [3:0] operand_bb;

//NS combinational logic
always @(*) begin
    case (PS)
        S0_idle: NS = S1_multiply;
        S1_multiply: NS = S2_update_result;
        S2_update_result: begin
            if (shift_count == 3'b100) //If on 4th shift, multiplication complete
                NS = S3_done;
            else
                NS = S1_multiply; //Otherwise, repeat multiplication steps
        end
        S3_done: NS = S0_idle;
        default: NS = S0_idle;
    endcase
end

//State sequential logic
always @(posedge clk) begin
    //Reset enabled
    if (rst == 1'b1) begin
        PS <= S0_idle;
        partial_product <= 8'b0;
        shift_count <= 3'b0;
        multiplicand <= 8'b0;
        operand_bb <= 4'b0;
        product <= 8'b0;
    end
    //Reset disabled
    else begin
        case (PS)
            S0_idle: begin
                partial_product <= 8'b0;
                shift_count <= 3'b0;
                multiplicand <= {4'b0000, A};
                operand_bb <= B;
            end
            S1_multiply: begin
                if ((operand_bb[0] == 0 &&  shift_count < 4)) begin
                    partial_product <= partial_product;
                    shift_count <= shift_count + 1;
                    multiplicand <= {multiplicand[6:0], 1'b0};
                    operand_bb <= {1'b0, operand_bb[3:1]};
                end
                else if ((operand_bb[0] == 1 &&  shift_count < 4)) begin
                    partial_product <= partial_product + multiplicand;
                    shift_count <= shift_count + 1;
                    multiplicand <= {multiplicand[6:0], 1'b0};
                    operand_bb <= {1'b0, operand_bb[3:1]};
                end
            end
            S2_update_result: begin
                if (shift_count == 4) begin
                    product <= partial_product;
                end
            end
            S3_done: begin
                product <= product;
            end
        endcase
        //State transition
        PS <= NS;
    end
end

endmodule