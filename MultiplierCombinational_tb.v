`timescale 1ns/1ps
module MultiplierCombinational_tb();

//Declare internal signals
reg [3:0] A, B;
wire [7:0] product;

multiplierCombinational uut(.a(A), .b(B), .p(product));

//Perform various tests (Need 10 cycles for each multiplication 1 idle, 4 update, 4 multiply, 1 done)
initial begin
    //Test Case 0: 0 * 0 = 0
    A = 4'b0000; B = 4'b0000;

    //Test Case 1: 1 * 1 = 1 
    #10 A = 4'b0001; B = 4'b0001; //Expect product = 8'b00000001

    //Test Case 2: 3 * 5 = 15
    #10 A = 4'b0011; B = 4'b0101; //Expect product = 8'b00001111

    //Test Case 3: 15 * 0 = 0 (Multiple by 0)
    #10 A = 4'b1111; B = 4'b0000; //Expect product = 8'b00000000

    //Test Case 4: 15 * 15 = 225 (Max value multiplication)
    #10 A = 4'b1111; B = 4'b1111; //Expect product = 8'11100001

    #10 $finish;

end

endmodule