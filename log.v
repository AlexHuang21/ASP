module log #(
    parameter DATA_SIZE = 32,
    parameter TAG_SIZE = 8,
    parameter MEM_DEPTH = 256  // Define the depth of the memory
) (
    input clk,
    input reset,
    input parity_error_in,
    input host_data_ready_in,
    input network_data_ready_in,
    input network_ack_in,
    input [DATA_SIZE-1:0] host_data_in,
    input [DATA_SIZE+TAG_SIZE-1:0] ndt_in,
    output reg [MEM_DEPTH-1:0][75:0] log_memory  // Memory to store log items
);

integer i = 0;  // Memory write pointer

always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            log_memory[i] <= 76'd0;
        end
        i <= 0;
    end else if (i < MEM_DEPTH) begin
        // Condense all inputs into one item and store in memory
        log_memory[i] <= {parity_error_in, host_data_ready_in, network_data_ready_in, network_ack_in, host_data_in, ndt_in};
        i <= i + 1;  // Increment memory pointer
    end
end

endmodule
