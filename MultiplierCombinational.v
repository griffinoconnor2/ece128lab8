//Note that the format for this module is based on the in-class slides
module multiplierCombinational(
    input [3:0] a, b,
    output [7:0] p
);

    //Partial product wires
    wire [3:0] m0;
    wire [4:0] m1;
    wire [5:0] m2;
    wire [6:0] m3;

    //Wires for adding all of the partial products 
    wire [7:0] s1, s2, s3;

    assign m0 = a & {4{b[0]}}; //a anded with b[0] replicated over 4 bits
    assign m1 = {a & {4{b[1]}}, 1'b0}; //Adding a zero to the end to shift the bits by one
    assign m2 = {a & {4{b[2]}}, 2'b00};
    assign m3 = {a & {4{b[3]}}, 3'b000};

    assign s1 = m1 + m0;
    assign s2 = s1 + m2;
    assign s3 = s2 + m3;
    assign p = s3;


endmodule 