module stage_3 #(parameter data_size = 32, parameter tag_size = 8) (
    // CLK/RST Signals
    input clk,
    input reset,

    // Opcodes (2 bits)
    input[1:0] opcode_in,
    output reg[1:0] opcode_out,

    // Soft Error Flag
    input soft_error_in,
    output reg soft_error_out,

    // TX Data and its computed tag (data_size bits, tag_size bits)
    input[(data_size-1):0] tx_data_in,
    input[(tag_size-1):0] tx_tag_in,
    output reg[(data_size-1):0] tx_data_out,
    output reg[(tag_size-1):0] tx_tag_out,

    // RX Tag Match Flag
    input tag_match_in,
    output reg tag_match_out,

    // Network Data Plus Tag (NDT) (data_size+tag_size bits)
    input[(data_size+tag_size-1):0] ndt_in,
    output reg[(data_size+tag_size-1):0] ndt_out,

    // RX/TX Signals (More to come)
    output[(data_size-1):0] rx_data, 
    output[(data_size-1):0] tx_data, 
    output[(data_size+tag_size-1):0] tx_data_plus_tag
);
    // Data from the network
    // Note that the tag is the last (tag_size) bits of NDT
    assign rx_data = ndt_out[(data_size+tag_size-1):tag_size];

    // Data from the host that has been parity checked (DPP). Should be sent back to host in case of soft error detection.
    assign tx_data = tx_data_out[(data_size-1):0];
    // Data from the host with its computed tag to be sent over the network if there is no soft error
    assign tx_data_plus_tag = {tx_data_out,tx_tag_out};

    // Reset/Update outputs on positive edge of clock
    always @(posedge clk) begin
        if (reset) begin
            opcode_out <= 0;
            soft_error_out <= 0;
            tx_data_out <= 0;
            tx_tag_out <= 0;
            tag_match_out <= 0;
            ndt_out <= 0;
        end else begin
            opcode_out <= opcode_in;
            soft_error_out <= soft_error_in;
            tx_data_out <= tx_data_in;
            tx_tag_out <= tx_tag_in;
            tag_match_out <= tag_match_in;
            ndt_out <= ndt_in;
        end
    end

endmodule