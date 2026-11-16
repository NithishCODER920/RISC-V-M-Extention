module register_file_m (
    input  logic [4:0]  rs1_sel,
    input  logic [4:0]  rs2_sel,
    input  logic        reg_write,
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] wb_data,
    input  logic [4:0]  rd_sel,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);
    logic [31:0] registers [0:31];
    integer index;

    always_comb begin
        rs1_data = (rs1_sel == 5'd0) ? 32'b0 : registers[rs1_sel];
        rs2_data = (rs2_sel == 5'd0) ? 32'b0 : registers[rs2_sel];
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (index = 0; index < 32; index = index + 1)
                registers[index] <= 32'b0;
        end else if (reg_write && (rd_sel != 5'd0)) begin
            registers[rd_sel] <= wb_data;
        end
    end
endmodule
