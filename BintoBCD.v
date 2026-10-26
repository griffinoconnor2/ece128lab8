module BintoBCD(
    input clk, rstn, en, 
    input [11:0] count,
    output reg [15:0] BCD,
    output reg rdy
);

//State encodings
parameter IDLE = 3'b000, SETUP = 3'b001, ADD = 3'b010, SHIFT = 3'b011, DONE = 3'b100; //Ease of reading case statements

reg [2:0] state;
reg [27:0] bcd_data; //16 bits for BCD and 12 for binary
reg [1:0] add_counter; //For each digit
reg  [3:0] sh_counter; //Up to 11
reg busy;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        state <= IDLE;
        busy <= 1'b0;
        bcd_data <= 28'b0;
        add_counter <= 2'b0;
        sh_counter <= 4'b0;
        BCD <= 16'b0;
        rdy <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                busy <= 1'b0;
                rdy <= 1'b0;
                if (en) //Enable start setup phase
                    state <= SETUP;
            end

            SETUP: begin //Setup, initialize everything
                busy <= 1'b1;
                rdy <= 1'b0;
                bcd_data <= {16'b0, count};
                add_counter <= 2'b0;
                sh_counter <= 4'b0;
                state <= ADD;
            end

            ADD: begin
                busy <= 1'b1;
                case (add_counter)
                    2'b00: begin
                        if (bcd_data[15:12] > 4)
                            bcd_data[27:12] <= bcd_data[27:12] + 3;
                        add_counter <= add_counter + 1;
                    end

                    2'b01: begin
                        if (bcd_data[19:16] > 4)
                            bcd_data[27:16] <= bcd_data[27:16] + 3;
                        add_counter <= add_counter + 1;
                    end

                    2'b10: begin
                        if (bcd_data[23:20] > 4)
                            bcd_data[27:20] <= bcd_data[27:20] + 3;
                        add_counter <= add_counter + 1;
                    end

                    2'b11: begin
                        if (bcd_data[27:24] > 4)
                            bcd_data[27:24] <= bcd_data[27:24] + 3;
                        add_counter <= 2'b0;
                        state <= SHIFT;
                    end
                endcase
            end

            SHIFT: begin
                busy <= 1'b1;
                sh_counter <= sh_counter + 1;
                bcd_data <= bcd_data << 1;

                if (sh_counter == 4'b1011) //Done shifting
                    state <= DONE;
                else
                    state <= ADD;
            end

            DONE: begin
                busy <= 1'b1;
                rdy <= 1'b1;
                BCD <= bcd_data[27:12];
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end
end 
endmodule