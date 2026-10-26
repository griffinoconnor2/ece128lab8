`timescale 1ns/1ps
module ROM_tb();

//Declare internal signals
reg [2:0] ROM_addr;
wire [3:0] ROM_data;

ROM uut (.ROM_addr(ROM_addr), .ROM_data(ROM_data));

//Perform tests
initial begin
    //Test Case 1: Sequential ROM Access
    ROM_addr = 3'b000; //Expect ROM_data = 4'b0000
    #10 ROM_addr = 3'b001; //Expect ROM_data = 4'b1100
    #10 ROM_addr = 3'b010; //Expect ROM_data = 4'b0110
    #10 ROM_addr = 3'b011; //Expect ROM_data = 4'b0111
    #10 ROM_addr = 3'b100; //Expect ROM_data = 4'b1000
    #10 ROM_addr = 3'b101; //Expect ROM_data = 4'b0001
    #10 ROM_addr = 3'b110; //Expect ROM_data = 4'b1101
    #10 ROM_addr = 3'b111; //Expect ROM_data = 4'b1110
    #10;

    //Test Case 2: Random ROM Access
    #10 ROM_addr = 3'b001; //Expect ROM_data = 4'b1100
    #10 ROM_addr = 3'b100; //Expect ROM_data = 4'b1000
    #10 ROM_addr = 3'b111; //Expect ROM_data = 4'b1110
    #10 ROM_addr = 3'b000; //Expect ROM_data = 4'b0000
    #10 ROM_addr = 3'b010; //Expect ROM_data = 4'b0110
    #10 ROM_addr = 3'b110; //Expect ROM_data = 4'b1101
    #10 ROM_addr = 3'b011; //Expect ROM_data = 4'b0111
    #10 ROM_addr = 3'b101; //Expect ROM_data = 4'b0001
    #10 $finish;
end

endmodule