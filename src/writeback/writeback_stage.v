// Writeback Stage
module writeback_stage #(
    parameter DATA_WIDTH = 32
)(
    // Inputs
    input wire [DATA_WIDTH-1:0] alu_result,
    input wire [DATA_WIDTH-1:0] mem_data,
    input wire [DATA_WIDTH-1:0] pc_plus4,
    input wire [DATA_WIDTH-1:0] immediate,
    // Writeback Select
    // 00 : ALU Result
    // 01 : Memory Data
    // 10 : PC + 4
    // 11 : Immediate (LUI)
    input wire [1:0] wb_sel,
    // Output
    output reg [DATA_WIDTH-1:0] writeback_data
);
// Writeback Multiplexer
always @(*) begin

    case(wb_sel)

        // ALU Result
        2'b00:
            writeback_data = alu_result;

        // Load Data
        2'b01:
            writeback_data = mem_data;

        // PC + 4 (JAL/JALR)
        2'b10:
            writeback_data = pc_plus4;

        // Immediate (LUI)
        2'b11:
            writeback_data = immediate;

        default:
            writeback_data = {DATA_WIDTH{1'b0}};

    endcase
end

endmodule