module log #(
    parameter DATA_SIZE = 32,
    parameter TAG_SIZE = 8,
    parameter MEM_DEPTH = 256  // Define the depth of the memory
) (
    input clk,
    input reset,
    input [1:0] opcode,
    input tag_match,
    input parity_error_in,
    input host_data_ready_in,
    input network_data_ready_in,
    input network_ack_in,
    input [DATA_SIZE-1:0] host_data_in,
    input [DATA_SIZE+TAG_SIZE-1:0] ndt_in,
    output reg[75:0] log_item
);

reg[MEM_DEPTH-1:0] log_memory[75:0];

integer i = 0;  // Memory write pointer

wire[75:0] log_item_wire = {parity_error_in, host_data_ready_in, network_data_ready_in, network_ack_in, host_data_in, ndt_in};
wire should_log;
localparam OP_RXA = 2'b10;
localparam OP_LOG = 2'b11;
assign should_log = (opcode == OP_LOG || (opcode == OP_RXA && tag_match == 0));

always @(*) begin
    if (reset) begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            log_memory[i] <= 76'd0;
        end
        log_item <= 0;
        i <= 0;
    end else if (i < MEM_DEPTH && should_log) begin
        // Condense all inputs into one item and store in memory
        log_memory[i] <= log_item_wire;
        log_item <= log_item_wire;
        i <= i + 1;  // Increment memory pointer
    end else begin
        log_item <= 0;   
    end
end

endmodule
