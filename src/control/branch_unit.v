`timescale 1ns / 1ps
// Branch Decision Unit
module branch_unit(
    input  wire        branch,
    input  wire [2:0]  funct3,
    // Comparator Results
    input  wire        equal,
    input  wire        not_equal,
    input  wire        less_than_signed,
    input  wire        greater_equal_signed,
    input  wire        less_than_unsigned,
    input  wire        greater_equal_unsigned,
    output reg         branch_taken
);

always @(*) begin
    // Default
    branch_taken = 1'b0;
    if (branch) begin
        case (funct3)

            3'b000: branch_taken = equal;                    // BEQ

            3'b001: branch_taken = not_equal;                // BNE

            3'b100: branch_taken = less_than_signed;         // BLT

            3'b101: branch_taken = greater_equal_signed;     // BGE

            3'b110: branch_taken = less_than_unsigned;       // BLTU

            3'b111: branch_taken = greater_equal_unsigned;   // BGEU

            default: branch_taken = 1'b0;
            
        endcase
    end
end

endmodule