module tag_generation #(
    parameter DATA_SIZE = 32,  // Parameter for the size of data
    parameter TAG_SIZE = 8    // Parameter for the size of the tag
) (
    input wire clk,                  // Clock signal
    input wire reset,                // Reset signal
    input wire [DATA_SIZE-1:0] data, // Data input
    output reg [TAG_SIZE-1:0] tag    // Tag output
);

// Assume SECRET_KEY is hardcoded.
parameter [15:0] SECRET_KEY = 16'hDEAD; // Secret key

// Internal signal for the combined tag result, declared as a reg for use within always blocks
reg [TAG_SIZE-1:0] xor_result;

// Function for the Rotate Left Shift (RLS) operation
function [TAG_SIZE-1:0] RLS_FUNCTION;
    input [TAG_SIZE-1:0] block;
    input integer bits;
    begin
        RLS_FUNCTION = (block << bits) | (block >> (TAG_SIZE - bits));
    end
endfunction

// Generate block flip (BF) and rotate left shift (RLS) for each block
genvar i;
wire [TAG_SIZE-1:0] block_flipped [0:DATA_SIZE/TAG_SIZE-1];
wire [TAG_SIZE-1:0] rotated_blocks [0:DATA_SIZE/TAG_SIZE-1];
generate
    for (i = 0; i < DATA_SIZE/TAG_SIZE; i = i + 1) begin : gen_bf_rls
        // Calculate the block flip for each segment
        assign block_flipped[i] = (SECRET_KEY[i] ? ~data[i*TAG_SIZE+:TAG_SIZE] : data[i*TAG_SIZE+:TAG_SIZE]);
        // Calculate the RLS for each flipped block
        assign rotated_blocks[i] = RLS_FUNCTION(block_flipped[i], SECRET_KEY[2*i+:2]);
    end
endgenerate

// Compute the tag by XOR'ing all the rotated blocks
integer j;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        xor_result <= 0;
    end else begin
        xor_result <= rotated_blocks[0];
        for (j = 1; j < DATA_SIZE/TAG_SIZE; j = j + 1) begin
            xor_result <= xor_result ^ rotated_blocks[j];
        end
    end
end

// Output the final tag value
always @(posedge clk or posedge reset) begin
    if (reset) begin
        tag <= 0;
    end else begin
        tag <= xor_result;
    end
end

endmodule
