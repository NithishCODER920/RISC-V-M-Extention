module decoder_m (
    input  logic [31:0] instruction,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3,
    output logic [11:0] imm,
    output logic [19:0] imm_uj,
    output logic [6:0]  funct7
);
    always_comb begin
        rs1 = 5'b0;
        rs2 = 5'b0;
        rd = 5'b0;
        opcode = instruction[6:0];
        imm11_5 = 7'b0;
        fn3 = 3'b0;
        imm = 12'b0;
        imm_uj = 20'b0;
        funct7 = 7'b0;

        case (instruction[6:0])
            7'h33: begin
                rd = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                funct7 = instruction[31:25];
            end
            7'h13: begin
                rd = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
                imm11_5 = instruction[31:25];
            end
            7'h03: begin
                rd = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end
            7'h23: begin
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {instruction[31:25], instruction[11:7]};
            end
            7'h63: begin
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                rs2 = instruction[24:20];
                imm = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
            end
            7'h6f: begin
                rd = instruction[11:7];
                imm_uj = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
            end
            7'h67: begin
                rd = instruction[11:7];
                fn3 = instruction[14:12];
                rs1 = instruction[19:15];
                imm = instruction[31:20];
            end
            7'h37, 7'h17: begin
                rd = instruction[11:7];
                imm_uj = instruction[31:12];
            end
            default: begin
            end
        endcase
    end
endmodule
