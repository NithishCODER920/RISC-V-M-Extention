module id_stage_m (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] wb_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,
    output logic [4:0]  rd,
    output logic [6:0]  opcode_out,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3_out,
    output logic [6:0]  funct7,
    output logic [2:0]  aluop,
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        mem_write,
    output logic        mem_read,
    output logic        alu_src,
    output logic        reg_write,
    output logic        operand_a_pc
);
    logic [4:0] rs1_sel;
    logic [4:0] rs2_sel;
    logic [11:0] imm_fields;
    logic [19:0] imm_uj_fields;
    logic [6:0] decoded_funct7;
    logic [6:0] decoded_imm11_5;
    logic [2:0] decoded_fn3;
    logic [6:0] decoded_opcode;
    logic decoded_reg_write;

    decoder_m decoder (
        .instruction(instruction),
        .rs1(rs1_sel),
        .rs2(rs2_sel),
        .rd(rd),
        .opcode(decoded_opcode),
        .imm11_5(decoded_imm11_5),
        .fn3(decoded_fn3),
        .imm(imm_fields),
        .imm_uj(imm_uj_fields),
        .funct7(decoded_funct7)
    );

    imm_generator_m immediate_generator (
        .imm_input(imm_fields),
        .fn3(decoded_fn3),
        .opcode(decoded_opcode),
        .imm_input_uj(imm_uj_fields),
        .imm_output(imm_out)
    );

    register_file_m registers (
        .rs1_sel(rs1_sel),
        .rs2_sel(rs2_sel),
        .reg_write(decoded_reg_write && !stall),
        .clk(clk),
        .reset(reset),
        .wb_data(wb_data),
        .rd_sel(rd),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    main_control_m main_control (
        .opcode(decoded_opcode),
        .memtoreg(memtoreg),
        .branch(branch),
        .memread(mem_read),
        .memwrite(mem_write),
        .alusrc(alu_src),
        .reg_write(decoded_reg_write),
        .operand_a_pc(operand_a_pc),
        .aluop(aluop)
    );

    always_comb begin
        opcode_out = decoded_opcode;
        imm11_5 = decoded_imm11_5;
        fn3_out = decoded_fn3;
        funct7 = decoded_funct7;
        reg_write = decoded_reg_write && !stall;
    end
endmodule
