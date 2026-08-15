// Branch comparison unit
module comparator #(
    parameter DATA_WIDTH = 32
)
(
    input  wire [DATA_WIDTH-1:0] a,
    input  wire [DATA_WIDTH-1:0] b,
    output wire equal,
    output wire not_equal,
    output wire less_than_signed,
    output wire greater_equal_signed,
    output wire less_than_unsigned,
    output wire greater_equal_unsigned
);

// Equality
assign equal     = (a == b);
assign not_equal = (a != b);

// Signed Comparison
assign less_than_signed = ($signed(a) < $signed(b));
assign greater_equal_signed = ($signed(a) >= $signed(b));

// Unsigned Comparison
assign less_than_unsigned = (a < b);
assign greater_equal_unsigned = (a >= b);

endmodule