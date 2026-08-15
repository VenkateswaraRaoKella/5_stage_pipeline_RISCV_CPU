module fetch_stage #(
    parameter DATA_WIDTH = 32,
    parameter RESET_PC   = 32'h00000000,
    parameter ADDR_WIDTH = 10,
    parameter MEM_FILE   = "instruction_mem.hex"
)(
    input  wire                     clk,
    input  wire                     rst_n,

    // Pipeline Control
    input  wire                     pc_en,

    // Branch/Jump Control
    input  wire                     pc_src,

    // Branch/Jump Target Address
    input  wire [DATA_WIDTH-1:0]    branch_target,

    // Outputs
    output wire [DATA_WIDTH-1:0]    pc,
    output wire [DATA_WIDTH-1:0]    pc_plus4,
    output wire [DATA_WIDTH-1:0]    instruction
);

    //--------------------------------------------------------
    // Internal Signals
    //--------------------------------------------------------

    wire [DATA_WIDTH-1:0] next_pc;

    //--------------------------------------------------------
    // PC + 4 Logic
    //--------------------------------------------------------

    assign pc_plus4 = pc + 32'd4;

    //--------------------------------------------------------
    // Next PC Selection
    //
    // pc_src = 0 -> Sequential
    // pc_src = 1 -> Branch/Jump
    //--------------------------------------------------------

    assign next_pc = (pc_src) ? branch_target : pc_plus4;

    //--------------------------------------------------------
    // Program Counter
    //--------------------------------------------------------

    program_counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .RESET_PC(RESET_PC)
    ) PC (
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(pc_en),
        .next_pc(next_pc),
        .pc(pc)
    );

    //--------------------------------------------------------
    // Instruction Memory
    //--------------------------------------------------------

    instruction_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEM_FILE(MEM_FILE)
    ) IMEM (
        .pc(pc),
        .instruction(instruction)
    );

endmodule