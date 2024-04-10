module AUTH(
    input wire [31:0] data, // 32-bit data input
    input wire [7:0] tag,   // 8-bit tag input
    output wire [31:0] output_data // 32-bit output data
);

// Internal wire for the generated tag
wire [7:0] generated_tag;

// Instantiate the tag generator (TGEN)
TGEN tag_generator(
    .data(data), // Connect the 32-bit data input
    .tag(generated_tag) // Connect the generated tag
);

// Perform 8-bit XNOR operation
wire tag_match = &(~(tag ^ generated_tag));

// Extend the single-bit result to 32 bits
wire [31:0] extended_tag_match = {32{tag_match}};

// Perform 32-bit AND operation
assign output_data = data & extended_tag_match;

endmodule
