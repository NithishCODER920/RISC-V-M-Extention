module alu_m (
    input  logic [4:0]  alu_control,
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    output logic [31:0] alu_out,
    output logic        zero
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

    logic signed [63:0] product_ss;
    logic signed [63:0] product_su;
    logic        [63:0] product_uu;

    always_comb begin
        product_ss = $signed({{32{rs1_data[31]}}, rs1_data}) *
                     $signed({{32{rs2_data[31]}}, rs2_data});
        product_su = $signed({{32{rs1_data[31]}}, rs1_data}) *
                     $signed({32'b0, rs2_data});
        product_uu = {32'b0, rs1_data} * {32'b0, rs2_data};

        alu_out = 32'b0;
        zero = 1'b0;

        case (alu_control)
            ALU_ADD:    alu_out = rs1_data + rs2_data;
            ALU_SUB:    alu_out = rs1_data - rs2_data;
            ALU_XOR:    alu_out = rs1_data ^ rs2_data;
            ALU_OR:     alu_out = rs1_data | rs2_data;
            ALU_AND:    alu_out = rs1_data & rs2_data;
            ALU_SLL:    alu_out = rs1_data << rs2_data[4:0];
            ALU_SRL:    alu_out = rs1_data >> rs2_data[4:0];
            ALU_SRA:    alu_out = $signed(rs1_data) >>> rs2_data[4:0];
            ALU_SLT:    alu_out = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0;
            ALU_SLTU:   alu_out = (rs1_data < rs2_data) ? 32'd1 : 32'd0;

            ALU_BEQ:    zero = (rs1_data == rs2_data);
            ALU_BNE:    zero = (rs1_data != rs2_data);
            ALU_BLT:    zero = ($signed(rs1_data) < $signed(rs2_data));
            ALU_BGE:    zero = ($signed(rs1_data) >= $signed(rs2_data));
            ALU_BLTU:   zero = (rs1_data < rs2_data);
            ALU_BGEU:   zero = (rs1_data >= rs2_data);

            ALU_MUL:    alu_out = product_uu[31:0];
            ALU_MULH:   alu_out = product_ss[63:32];
            ALU_MULHSU: alu_out = product_su[63:32];
            ALU_MULHU:  alu_out = product_uu[63:32];

            ALU_DIV: begin
                if (rs2_data == 32'b0)
                    alu_out = 32'hffff_ffff;
                else if ((rs1_data == 32'h8000_0000) && (rs2_data == 32'hffff_ffff))
                    alu_out = 32'h8000_0000;
                else
                    alu_out = $signed(rs1_data) / $signed(rs2_data);
            end
            ALU_DIVU: begin
                if (rs2_data == 32'b0)
                    alu_out = 32'hffff_ffff;
                else
                    alu_out = rs1_data / rs2_data;
            end
            ALU_REM: begin
                if (rs2_data == 32'b0)
                    alu_out = rs1_data;
                else if ((rs1_data == 32'h8000_0000) && (rs2_data == 32'hffff_ffff))
                    alu_out = 32'b0;
                else
                    alu_out = $signed(rs1_data) % $signed(rs2_data);
            end
            ALU_REMU: begin
                if (rs2_data == 32'b0)
                    alu_out = rs1_data;
                else
                    alu_out = rs1_data % rs2_data;
            end
            default: begin
                alu_out = 32'b0;
                zero = 1'b0;
            end
        endcase
    end
endmodule
