module tag_generation(
    input clk,
    input [31:0] data,
    output reg [7:0] tag,
    output reg [7:0] tag1,
    output reg [7:0] tag2,
    output reg [7:0] tag3

    
);
    localparam [15:0] SECRET_KEY = 16'hDEAD;

    wire [7:0] bf_block[3:0];
    wire [7:0] rls_block[3:0];
    reg [7:0] tag_next;

    // Manually specifying operations for each block

    // Block Flip (BF) and Rotating Left Shift (RLS) for each block
    assign bf_block[0] = (SECRET_KEY[0] == 1'b1) ? ~data[7:0] : data[7:0];
    assign bf_block[1] = (SECRET_KEY[1] == 1'b1) ? ~data[15:8] : data[15:8];
    assign bf_block[2] = (SECRET_KEY[2] == 1'b1) ? ~data[23:16] : data[23:16];
    assign bf_block[3] = (SECRET_KEY[3] == 1'b1) ? ~data[31:24] : data[31:24];

    wire [2:0] shift_amount_0 = SECRET_KEY[3:0];
    wire [2:0] shift_amount_1 = SECRET_KEY[7:4];
    wire [2:0] shift_amount_2 = SECRET_KEY[11:8];
    wire [2:0] shift_amount_3 = SECRET_KEY[15:12];

    assign rls_block[0] = (bf_block[0] << shift_amount_0) | (bf_block[0] >> (8 - shift_amount_0));
    assign rls_block[1] = (bf_block[1] << shift_amount_1) | (bf_block[1] >> (8 - shift_amount_1));
    assign rls_block[2] = (bf_block[2] << shift_amount_2) | (bf_block[2] >> (8 - shift_amount_2));
    assign rls_block[3] = (bf_block[3] << shift_amount_3) | (bf_block[3] >> (8 - shift_amount_3));

    // XOR the results to produce the tag
    always @(*) begin
        tag_next = rls_block[0] ^ rls_block[1] ^ rls_block[2] ^ rls_block[3];
    end

    // Update the tag on the rising edge of the clock
    always @(posedge clk) begin
        tag <= tag_next;
    end
endmodule
