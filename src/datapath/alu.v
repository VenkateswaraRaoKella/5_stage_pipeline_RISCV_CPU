// ALU
module alu #(
    parameter DATA_WIDTH = 32
)(
    input  wire [DATA_WIDTH-1:0] operand_a,
    input  wire [DATA_WIDTH-1:0] operand_b,
    input  wire [3:0]            alu_control,
    output reg  [DATA_WIDTH-1:0] result,
    output wire                  zero,
    output wire                  less,
    output reg                   overflow
);

always @(*) begin
    overflow = 1'b0;
    case (alu_control)

        // ADD
        4'b0000:
        begin
            result = operand_a + operand_b;
            overflow =
                (~operand_a[31] & ~operand_b[31] & result[31]) |
                ( operand_a[31] &  operand_b[31] & ~result[31]);
        end

        // SUB
        4'b0001:
        begin
            result = operand_a - operand_b;
            overflow =
            (~operand_a[31] & operand_b[31] & result[31]) |                    ( operand_a[31] & ~operand_b[31] & ~result[31]);
        end

        // AND
        4'b0010:
            result = operand_a & operand_b;

        // OR
        4'b0011:
            result = operand_a | operand_b;

        // XOR
        4'b0100:
            result = operand_a ^ operand_b;

        // Shift Left Logical
        4'b0101:
            result = operand_a << operand_b[4:0];

        // Shift Right Logical
        4'b0110:
            result = operand_a >> operand_b[4:0];

        // Shift Right Arithmetic
        4'b0111:
            result = $signed(operand_a) >>> operand_b[4:0];

        // Set Less Than (Signed)
        4'b1000:
            result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;

        // Set Less Than (Unsigned)
        4'b1001:
            result = (operand_a < operand_b ? 32'd1 : 32'd0);

        // Default
        default:
            result = {DATA_WIDTH{1'b0}};

    endcase
end

// Status Flags
assign zero = (result == {DATA_WIDTH{1'b0}});
assign less = ($signed(operand_a) < $signed(operand_b));

endmodule