module output_stage #(parameter data_size = 32, parameter tag_size = 8) (
    input clk,
    input reset,
    input[1:0] opcode_in,
    input soft_error_in,
    input[(data_size-1):0] tx_data_in,
    input[(tag_size-1):0] tx_tag_in,
    input[(data_size+tag_size-1):0] tx_data_plus_tag_in,
    input tag_match_in,
    input[(data_size-1):0] rx_data_in,
    input[(data_size+tag_size-1):0] ndt_in,
    output reg parity_error_out,
    output reg host_data_ready_out,
    output reg network_data_ready_out,
    output reg network_ack_out,
    output reg[(data_size-1):0] host_data_out,
    output reg[(data_size+tag_size-1):0] ndt_out
    );
    
    localparam OP_RXA = 2'b10;
    localparam OP_TXE = 2'b01;
    
    // AND gates ordered from top to bottom in datapath diagram
    assign and_gate_1 = (opcode_in == OP_RXA);
    assign and_gate_2 = (opcode_in == OP_TXE);
    assign and_gate_3 = (~parity_error_out & and_gate_2);
    assign and_gate_4 = (tag_match_in & and_gate_1);
    
    // OR gates ordered from top to bottom in datapath diagram
    assign or_gate_1 = (parity_error_out | and_gate_4);
    assign or_gate_2 = (and_gate_3 | and_gate_4);
    
    // MUX's ordered from top to bottom
    wire [(data_size-1):0] mux_1;
    wire [(data_size+tag_size-1):0] mux_2;
    assign mux_1 = parity_error_out ? tx_data_in : rx_data_in;
    assign mux_2 = (opcode_in == OP_TXE) ? tx_data_plus_tag_in : ndt_in;
    
    always @(*) begin
        if (reset) begin
            parity_error_out <= 0;
            host_data_ready_out <= 0;
            network_data_ready_out <= 0;
            network_ack_out <= 0;
            host_data_out <= 0;
            ndt_out <= 0;
        end else begin
            parity_error_out <= soft_error_in;
            host_data_ready_out <= or_gate_1;
            network_data_ready_out <= or_gate_2;
            network_ack_out <= and_gate_4; 
            host_data_out <= mux_1;
            ndt_out <= mux_2;
        end
    end
    
endmodule
