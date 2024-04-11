module stage_1 #(parameter data_size = 32, parameter tag_size = 8) (
    // CLK/RST Signals
    input clk,
    input reset,

    // Opcodes (2 bits)
    input[1:0] opcode_in,
    output reg[1:0] opcode_out,

    // Data Plus Parity (DPP) (data_size+1 bits)
    input[(data_size):0] dpp_in,
    output reg[(data_size):0] dpp_out,

    // Network Data Plus Tag (NDT) (data_size+tag_size bits)
    input[(data_size+tag_size-1):0] ndt_in,
    output reg[(data_size+tag_size-1):0] ndt_out
);

    // Reset/Update outputs on positive edge of clock
    always @(posedge clk) begin
        if (reset) begin
            opcode_out <= 0;
            dpp_out <= 0;
            ndt_out <= 0;
        end else begin
            opcode_out <= opcode_in;
            dpp_out <= dpp_in;
            ndt_out <= ndt_in;
        end
    end

endmodule