module main_control_m (
    input  logic [6:0] opcode,
    output logic [1:0] memtoreg,
    output logic       branch,
    output logic       memread,
    output logic       memwrite,
    output logic       alusrc,
    output logic       reg_write,
    output logic       operand_a_pc,
    output logic [2:0] aluop
);
    always_comb begin
        memtoreg = 2'b00;
        branch = 1'b0;
        memread = 1'b0;
        memwrite = 1'b0;
        alusrc = 1'b0;
        reg_write = 1'b0;
        operand_a_pc = 1'b0;
        aluop = 3'b000;

        case (opcode)
            7'h33: begin
                reg_write = 1'b1;
                aluop = 3'b000;
            end
            7'h13: begin
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b001;
            end
            7'h03: begin
                memtoreg = 2'b01;
                memread = 1'b1;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b010;
            end
            7'h23: begin
                memwrite = 1'b1;
                alusrc = 1'b1;
                aluop = 3'b011;
            end
            7'h63: begin
                branch = 1'b1;
                aluop = 3'b100;
            end
            7'h6f: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b110;
            end
            7'h67: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b001;
            end
            7'h37: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                aluop = 3'b110;
            end
            7'h17: begin
                memtoreg = 2'b10;
                alusrc = 1'b1;
                reg_write = 1'b1;
                operand_a_pc = 1'b1;
                aluop = 3'b000;
            end
            default: begin
            end
        endcase
    end
endmodule
