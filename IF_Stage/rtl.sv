module if_stage_m (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic        take_pc,
    input  logic [31:0] pc_target,
    output logic [31:0] address,
    output logic [31:0] pc_new
);
    always_comb begin
        pc_new = address + 32'd4;
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            address <= 32'h8000_0000;
        else if (!stall) begin
            if (take_pc)
                address <= pc_target;
            else
                address <= pc_new;
        end
    end
endmodule
