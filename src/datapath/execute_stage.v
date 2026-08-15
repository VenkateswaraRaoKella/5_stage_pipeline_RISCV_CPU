// Execute Stage
module execute_stage #(
    parameter DATA_WIDTH = 32
)(
    // Inputs
    input  wire [DATA_WIDTH-1:0] pc,
    input  wire [DATA_WIDTH-1:0] rs1_data,
    input  wire [DATA_WIDTH-1:0] rs2_data,
    input  wire [DATA_WIDTH-1:0] immediate,
    input  wire                  alu_src,
    input  wire                  use_pc_as_operand_a,
    input  wire [3:0]            alu_control,
    // Outputs
    output wire [DATA_WIDTH-1:0] alu_result,
    output wire                  zero,
    output wire                  less,
    output wire                  overflow
);

// ALU Operand Selection
// Operand A
wire [DATA_WIDTH-1:0] operand_a;
// Operand B
wire [DATA_WIDTH-1:0] operand_b;
//------------------------------------------------------------
// Operand A
// 0 -> rs1
// 1 -> PC
//------------------------------------------------------------
assign operand_a = (use_pc_as_operand_a) ? pc : rs1_data;
//------------------------------------------------------------
// Operand B
// 0 -> rs2
// 1 -> Immediate
//------------------------------------------------------------
assign operand_b = (alu_src) ? immediate : rs2_data;
// ALU
alu #(
    .DATA_WIDTH(DATA_WIDTH)
)
ALU
(
    .operand_a   (operand_a),
    .operand_b   (operand_b),
    .alu_control (alu_control),
    .result      (alu_result),
    .zero        (zero),
    .less        (less),
    .overflow    (overflow)
);

endmodule