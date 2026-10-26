module ROM (
    input [2:0] ROM_addr,
    output reg [3:0] ROM_data
);

//ROM assignment
always @(ROM_addr) begin
    case(ROM_addr)
        3'b000: ROM_data = 4'b0000;
        3'b001: ROM_data = 4'b1100;
        3'b010: ROM_data = 4'b0110;
        3'b011: ROM_data = 4'b0111;
        3'b100: ROM_data = 4'b1000;
        3'b101: ROM_data = 4'b0001;
        3'b110: ROM_data = 4'b1101;
        3'b111: ROM_data = 4'b1110;
        default: ROM_data = 4'b0000;
    endcase
end

endmodule