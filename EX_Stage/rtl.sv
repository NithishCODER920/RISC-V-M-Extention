module ex_stage_m (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,
    input  logic [6:0]  opcode,
    input  logic [2:0]  fn3,
    input  logic [6:0]  funct7,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic        alu_src,
    input  logic        operand_a_pc,
    input  logic        branch,
    output logic        take_pc,
    output logic        zero,
    output logic [31:0] alu_out,
    output logic [31:0] pc_target,
    output logic [31:0] pc_signed_offset
);
    logic [31:0] alu_a;
    logic [31:0] alu_b;
    logic [4:0] alu_control;

    alu_control_m control_unit (
        .opcode(opcode),
        .fn3(fn3),
        .funct7(funct7),
        .imm11_5(imm11_5),
        .control_out(alu_control)
    );

    assign alu_a = operand_a_pc ? address : rs1_data;
    assign alu_b = alu_src ? imm_out : rs2_data;

    alu_m arithmetic_logic_unit (
        .alu_control(alu_control),
        .rs1_data(alu_a),
        .rs2_data(alu_b),
        .alu_out(alu_out),
        .zero(zero)
    );

    always_comb begin
        pc_signed_offset = address + imm_out;
        pc_target = pc_signed_offset;
        if (opcode == 7'h67)
            pc_target = {alu_out[31:1], 1'b0};

        take_pc = 1'b0;
        if (branch && zero)
            take_pc = 1'b1;
        if ((opcode == 7'h6f) || (opcode == 7'h67))
            take_pc = 1'b1;
    end
endmodule
