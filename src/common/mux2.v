module mux2 #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] input0,
    input  wire [WIDTH-1:0] input1,
    input  wire             sel,

    output wire [WIDTH-1:0] out
);
assign out = (sel) ? input1 : input0;

endmodule