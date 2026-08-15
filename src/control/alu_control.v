//ALU Control Unit
module alu_control(
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] alu_control
);

always @(*) begin
    // Default
    alu_control = 4'b0000;
    case (alu_op)

        // Load / Store
        2'b00:
            alu_control = 4'b0000;      // ADD

        // Branch
        2'b01:
            alu_control = 4'b0001;      // SUB

        // R-Type / I-Type Arithmetic
        2'b10:
        begin

            case (funct3)

                // ADD / SUB / ADDI
                3'b000:
                begin

                    if (funct7 == 7'b0100000)
                        alu_control = 4'b0001;      // SUB
                    else
                        alu_control = 4'b0000;      // ADD

                end
                
                // SLL
                3'b001:
                    alu_control = 4'b0101;

                // SLT
                3'b010:
                    alu_control = 4'b1000;

                // SLTU
                3'b011:
                    alu_control = 4'b1001;

                // XOR
                3'b100:
                    alu_control = 4'b0100;

                // SRL / SRA
                3'b101:
                begin

                    if (funct7 == 7'b0100000)
                        alu_control = 4'b0111;      // SRA
                    else
                        alu_control = 4'b0110;      // SRL

                end

                // OR
                3'b110:
                    alu_control = 4'b0011;

                // AND
                3'b111:
                    alu_control = 4'b0010;

                //default
                default:
                    alu_control = 4'b0000;

            endcase

        end

        // Reserved
        default:
            alu_control = 4'b0000;

    endcase

end

endmodule