module single_cycle_riscv_m (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] mem_out,
    output logic [31:0] rs2_data,
    output logic [31:0] alu_out,
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  fn3,
    output logic [6:0]  opcode,
    output logic [31:0] address
);
    logic [31:0] rs1_data_internal;
    logic [31:0] rs2_data_internal;
    logic [31:0] immediate;
    logic [31:0] pc_plus4;
    logic [31:0] pc_target;
    logic [31:0] pc_signed_offset;
    logic [31:0] wb_data;
    logic [4:0] rd;
    logic [6:0] imm11_5;
    logic [6:0] funct7;
    logic [2:0] aluop;
    logic [1:0] memtoreg;
    logic branch;
    logic mem_write_internal;
    logic mem_read_internal;
    logic alu_src;
    logic reg_write;
    logic operand_a_pc;
    logic take_pc;
    logic branch_condition;
    logic [6:0] opcode_internal;

    id_stage_m decode (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .instruction(instruction),
        .wb_data(wb_data),
        .rs1_data(rs1_data_internal),
        .rs2_data(rs2_data_internal),
        .imm_out(immediate),
        .rd(rd),
        .opcode_out(opcode_internal),
        .imm11_5(imm11_5),
        .fn3_out(fn3),
        .funct7(funct7),
        .aluop(aluop),
        .memtoreg(memtoreg),
        .branch(branch),
        .mem_write(mem_write_internal),
        .mem_read(mem_read_internal),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .operand_a_pc(operand_a_pc)
    );

    ex_stage_m execute (
        .rs1_data(rs1_data_internal),
        .rs2_data(rs2_data_internal),
        .imm_out(immediate),
        .address(address),
        .opcode(opcode_internal),
        .fn3(fn3),
        .funct7(funct7),
        .imm11_5(imm11_5),
        .aluop(aluop),
        .alu_src(alu_src),
        .operand_a_pc(operand_a_pc),
        .branch(branch),
        .take_pc(take_pc),
        .zero(branch_condition),
        .alu_out(alu_out),
        .pc_target(pc_target),
        .pc_signed_offset(pc_signed_offset)
    );

    if_stage_m fetch (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .take_pc(take_pc),
        .pc_target(pc_target),
        .address(address),
        .pc_new(pc_plus4)
    );

    wb_stage_m writeback (
        .mem_out(mem_out),
        .alu_out(alu_out),
        .return_addr(pc_plus4),
        .imm_out(immediate),
        .pc_signed_offset(pc_signed_offset),
        .memtoreg(memtoreg),
        .opcode_out_d(opcode_internal),
        .wb_data(wb_data)
    );

    always_comb begin
        rs2_data = rs2_data_internal;
        mem_write = mem_write_internal && !stall;
        mem_read = mem_read_internal && !stall;
        opcode = opcode_internal;
    end
endmodule
