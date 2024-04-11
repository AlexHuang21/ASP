module stage_2 #(parameter data_size = 32, parameter tag_size = 8) (
    // CLK/RST Signals
    input clk,
    input reset,

    // Opcodes (2 bits)
    input[1:0] opcode_in,
    output reg[1:0] opcode_out,

    // Soft Error Flag
    input soft_error_in,
    output reg soft_error_out,

    // Data Plus Parity (DPP) (data_size+1 bits)
    input[(data_size):0] dpp_in,
    output reg[(data_size):0] dpp_out,

    // Network Data Plus Tag (NDT) (data_size+tag_size bits)
    input[(data_size+tag_size-1):0] ndt_in,
    output reg[(data_size+tag_size-1):0] ndt_out,

    // RX/TX Signals for MUX
    output[(data_size-1):0] rx_data, 
    output[(data_size-1):0] tx_data,
    output[(tag_size-1):0] rx_tag
);

    // Data from the host that has been parity checked (DPP)
    assign tx_data = dpp_out[(data_size):1];

    // From the network to be tag checked (NDT)
    // Note that the tag is the last (tag_size) bits of NDT
    assign rx_data = ndt_out[(data_size+tag_size-1):tag_size];
    assign rx_tag = ndt_out[(tag_size-1):0];

    // Reset/Update outputs on positive edge of clock
    always @(posedge clk) begin
        if (reset) begin
            opcode_out <= 0;
            soft_error_out <= 0;
            dpp_out <= 0;
            ndt_out <= 0;
        end else begin
            opcode_out <= opcode_in;
            soft_error_out <= soft_error_in;
            dpp_out <= dpp_in;
            ndt_out <= ndt_in;
        end
    end

endmodule