// Immediate Generator
module immediate_generator(
    input  wire [31:0] instruction,
    output reg  [31:0] immediate
);
    // Extract Opcode
    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    // Immediate Generation
    always @(*) begin
        case(opcode)
            //------------------------------------------------
            // I-Type
            // ADDI, ANDI, ORI, XORI
            // LW, LH, LB
            // JALR
            //------------------------------------------------
            7'b0010011,
            7'b0000011,
            7'b1100111:
            begin
                immediate = {{20{instruction[31]}},
                              instruction[31:20]};
            end
            //------------------------------------------------
            // S-Type
            // SW, SH, SB
            //------------------------------------------------
            7'b0100011:
            begin
                immediate = {{20{instruction[31]}},
                              instruction[31:25],
                              instruction[11:7]};
            end
            //------------------------------------------------
            // B-Type
            // BEQ, BNE, BLT
            //------------------------------------------------
            7'b1100011:
            begin
                immediate = {{19{instruction[31]}},
                              instruction[31],
                              instruction[7],
                              instruction[30:25],
                              instruction[11:8],
                              1'b0};
            end
            //------------------------------------------------
            // U-Type
            // LUI
            // AUIPC
            //------------------------------------------------
            7'b0110111,
            7'b0010111:
            begin
                immediate = {instruction[31:12],
                             12'b0};
            end
            //------------------------------------------------
            // J-Type
            // JAL
            //------------------------------------------------
            7'b1101111:
            begin
                immediate = {{11{instruction[31]}},
                              instruction[31],
                              instruction[19:12],
                              instruction[20],
                              instruction[30:21],
                              1'b0};
            end
            //------------------------------------------------
            // Default
            //------------------------------------------------
            default:
            begin
                immediate = 32'd0;
            end
        endcase
    end

endmodule