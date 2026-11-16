module alu_control_m (
    input  logic [6:0] opcode,
    input  logic [2:0] fn3,
    input  logic [6:0] funct7,
    input  logic [6:0] imm11_5,
    output logic [4:0] control_out
);
    localparam logic [4:0] ALU_ADD    = 5'b00000;
    localparam logic [4:0] ALU_SUB    = 5'b00001;
    localparam logic [4:0] ALU_XOR    = 5'b00010;
    localparam logic [4:0] ALU_OR     = 5'b00011;
    localparam logic [4:0] ALU_AND    = 5'b00100;
    localparam logic [4:0] ALU_SLL    = 5'b00101;
    localparam logic [4:0] ALU_SRL    = 5'b00110;
    localparam logic [4:0] ALU_SRA    = 5'b00111;
    localparam logic [4:0] ALU_SLT    = 5'b01000;
    localparam logic [4:0] ALU_SLTU   = 5'b01001;
    localparam logic [4:0] ALU_BEQ    = 5'b01010;
    localparam logic [4:0] ALU_BNE    = 5'b01011;
    localparam logic [4:0] ALU_BLT    = 5'b01100;
    localparam logic [4:0] ALU_BGE    = 5'b01101;
    localparam logic [4:0] ALU_BLTU   = 5'b01110;
    localparam logic [4:0] ALU_BGEU   = 5'b01111;
    localparam logic [4:0] ALU_MUL    = 5'b10000;
    localparam logic [4:0] ALU_MULH   = 5'b10001;
    localparam logic [4:0] ALU_MULHSU = 5'b10010;
    localparam logic [4:0] ALU_MULHU  = 5'b10011;
    localparam logic [4:0] ALU_DIV    = 5'b10100;
    localparam logic [4:0] ALU_DIVU   = 5'b10101;
    localparam logic [4:0] ALU_REM    = 5'b10110;
    localparam logic [4:0] ALU_REMU   = 5'b10111;

    always_comb begin
        control_out = ALU_ADD;

        case (opcode)
            7'h33: begin
                if (funct7 == 7'b0000001) begin
                    case (fn3)
                        3'b000: control_out = ALU_MUL;
                        3'b001: control_out = ALU_MULH;
                        3'b010: control_out = ALU_MULHSU;
                        3'b011: control_out = ALU_MULHU;
                        3'b100: control_out = ALU_DIV;
                        3'b101: control_out = ALU_DIVU;
                        3'b110: control_out = ALU_REM;
                        3'b111: control_out = ALU_REMU;
                        default: control_out = ALU_ADD;
                    endcase
                end else begin
                    case (fn3)
                        3'b000: control_out = (funct7 == 7'b0100000) ? ALU_SUB : ALU_ADD;
                        3'b001: control_out = ALU_SLL;
                        3'b010: control_out = ALU_SLT;
                        3'b011: control_out = ALU_SLTU;
                        3'b100: control_out = ALU_XOR;
                        3'b101: control_out = (funct7 == 7'b0100000) ? ALU_SRA : ALU_SRL;
                        3'b110: control_out = ALU_OR;
                        3'b111: control_out = ALU_AND;
                        default: control_out = ALU_ADD;
                    endcase
                end
            end
            7'h13: begin
                case (fn3)
                    3'b000: control_out = ALU_ADD;
                    3'b001: control_out = ALU_SLL;
                    3'b010: control_out = ALU_SLT;
                    3'b011: control_out = ALU_SLTU;
                    3'b100: control_out = ALU_XOR;
                    3'b101: control_out = (imm11_5 == 7'h20) ? ALU_SRA : ALU_SRL;
                    3'b110: control_out = ALU_OR;
                    3'b111: control_out = ALU_AND;
                    default: control_out = ALU_ADD;
                endcase
            end
            7'h63: begin
                case (fn3)
                    3'b000: control_out = ALU_BEQ;
                    3'b001: control_out = ALU_BNE;
                    3'b100: control_out = ALU_BLT;
                    3'b101: control_out = ALU_BGE;
                    3'b110: control_out = ALU_BLTU;
                    3'b111: control_out = ALU_BGEU;
                    default: control_out = ALU_ADD;
                endcase
            end
            default: control_out = ALU_ADD;
        endcase
    end
endmodule
