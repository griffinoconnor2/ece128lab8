module topCombinational(
    input clk, rstn,
    input [3:0] A, B,
    output wire [3:0] an,
    output wire [6:0] cat,
    output wire rdy
);

//Declare internal wires
wire clk1KHz;
wire[7:0] productin;
wire [15:0] BCD;

//instantiate submodules
multiplierCombinational mult(.a(A), .b(B), .p(productin));

ClockDivider clockdiv(.clkin(clk), .rstn(rstn), .clkout1KHz(clk1KHz));

//Must 0 extend 12 bit BCD from product
BintoBCD btb(.clk(clk), .rstn(rstn), .en(1'b1), .count({4'b0000, productin}), .BCD(BCD), .rdy(rdy));

MSD msd(.bcd(BCD), .clk(clk1KHz), .rstn(rstn), .cat(cat), .an(an));

endmodule