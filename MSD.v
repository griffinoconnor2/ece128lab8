module MSD (
    input [15:0] bcd,
    input clk, rstn,
    output [6:0] cat,
    output [3:0] an
);

//Declare intermediate signals
wire [1:0] ancounter; //To be used as selector for both mux and decoder (numerical digit and place value respectively)
wire [3:0] digit; //To be used to forward selected numerica digit to BCDto7SD

//Instantiate misc. modules to generate anode and cathode signals 
AnodeCounter uut0(.clk(clk), .rstn(rstn), .sel(ancounter));

Mux4to1 uut1(.bcd(bcd), .S(ancounter), .digit(digit));

Decoder2to4 uut2(.S(ancounter), .an(an));

BCDto7SD uut3(.in(digit), .Seg(cat));

endmodule

module BCDto7SD (
    input [3:0] in,
    output reg [6:0] Seg
);

always @(*) begin
    case(in)
        //Input cases 0-9, assign corresponding 7SD output (represented a-g)
        4'b0000: Seg = 7'b0000001; //0
        4'b0001: Seg = 7'b1001111; //1
        4'b0010: Seg = 7'b0010010; //2
        4'b0011: Seg = 7'b0000110; //3
        4'b0100: Seg = 7'b1001100; //4
        4'b0101: Seg = 7'b0100100; //5
        4'b0110: Seg = 7'b0100000; //6
        4'b0111: Seg = 7'b0001111; //7
        4'b1000: Seg = 7'b0000000; //8
        4'b1001: Seg = 7'b0000100; //9
        default: Seg = 7'b1111111; //off

    endcase
end

endmodule

module Mux4to1 (
    input [15:0] bcd, //From BintoBCD
    input [1:0] S, //From anode counter
    output reg [3:0] digit
);

//Selection logic for numerical digit (S = 0, pick ones, S = 1, pick tens, S = 2, pick hundreds, S = 3, pick thousands)
always @(*) begin
    case (S)
        2'b00: digit = bcd[3:0];
        2'b01: digit = bcd[7:4];
        2'b10: digit = bcd[11:8];
        2'b11: digit = bcd[15:12];
        default: digit = 4'b0000;
    endcase
end

endmodule

module Decoder2to4(
    input [1:0] S, //from an counter
    output reg [3:0] an
);

//Selection logic for anode/digit displayed (S = 0, pick ones, S = 1, pick tens, S = 2, pick hundreds, S = 3, pick thousands)
always @(*) begin
    case(S)
        2'b00: an = 4'b1110;
        2'b01: an = 4'b1101;
        2'b10: an = 4'b1011;
        2'b11: an = 4'b0111;
        default: an = 4'b1111;
    endcase

end

endmodule

module AnodeCounter(
    input clk, rstn,
    output reg [1:0] sel
);

//Anode Counting logic (cycle 0-3 quickly to display each digit simultaneously (to human eye))
always @(posedge clk or negedge rstn)
    begin
        if (!rstn)
            sel <= 2'b00;
        else
            sel <= sel + 2'b01;
    end

endmodule