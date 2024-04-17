module tag_generation #(parameter DATA_SIZE = 32, parameter BLOCK_SIZE = DATA_SIZE /4) (
    input clk,
    input reset,
    input [DATA_SIZE-1:0] data,
    output reg [BLOCK_SIZE-1:0] tag
);

    localparam [15:0] SECRET_KEY = 16'hDEAD;

    wire [BLOCK_SIZE-1:0] bf_block[3:0];
    wire [BLOCK_SIZE-1:0] rls_block[3:0];
    wire [BLOCK_SIZE-1:0] tag_next;

    // Block Flip (BF) and Rotating Left Shift (RLS) for each block
    assign bf_block[0] = (SECRET_KEY[0] == 1'b1) ? ~data[BLOCK_SIZE-1:0] : data[BLOCK_SIZE-1:0];
    assign bf_block[1] = (SECRET_KEY[1] == 1'b1) ? ~data[2*BLOCK_SIZE-1:BLOCK_SIZE] : data[2*BLOCK_SIZE-1:BLOCK_SIZE];
    assign bf_block[2] = (SECRET_KEY[2] == 1'b1) ? ~data[3*BLOCK_SIZE-1:2*BLOCK_SIZE] : data[3*BLOCK_SIZE-1:2*BLOCK_SIZE];
    assign bf_block[3] = (SECRET_KEY[3] == 1'b1) ? ~data[4*BLOCK_SIZE-1:3*BLOCK_SIZE] : data[4*BLOCK_SIZE-1:3*BLOCK_SIZE];

    wire [2:0] shift_amount_0 = SECRET_KEY[2:0] % BLOCK_SIZE;
    wire [2:0] shift_amount_1 = SECRET_KEY[5:3] % BLOCK_SIZE;
    wire [2:0] shift_amount_2 = SECRET_KEY[8:6] % BLOCK_SIZE;
    wire [2:0] shift_amount_3 = SECRET_KEY[11:9] % BLOCK_SIZE;

    assign rls_block[0] = (bf_block[0] << shift_amount_0) | (bf_block[0] >> (BLOCK_SIZE - shift_amount_0));
    assign rls_block[1] = (bf_block[1] << shift_amount_1) | (bf_block[1] >> (BLOCK_SIZE - shift_amount_1));
    assign rls_block[2] = (bf_block[2] << shift_amount_2) | (bf_block[2] >> (BLOCK_SIZE - shift_amount_2));
    assign rls_block[3] = (bf_block[3] << shift_amount_3) | (bf_block[3] >> (BLOCK_SIZE - shift_amount_3));
    
    assign tag_next = rls_block[0] ^ rls_block[1] ^ rls_block[2] ^ rls_block[3];
    
    always @(*) begin
        if (reset) begin
            tag <= 8'hff;
        end else begin    
            tag <= tag_next;
        end
    end
        
endmodule