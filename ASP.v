module ASP #(parameter data_size = 32, parameter tag_size = 8, parameter mem_depth = 256) (
    // Control Inputs
    input clk,
    input reset,

    // Data from Host & controls
    input data_parity_ready_in,
    input[(data_size):0] data_parity_in,

    // Data from Network & controls
    input network_data_ready_in,
    input network_ACK_in,
    input[(data_size+tag_size-1):0] network_data_tag_in,

    // Data to Host & controls
    output parity_error_out,
    output host_data_ready_out,
    output[(data_size-1):0] host_data_out,

    // Data to Network & controls
    output network_data_ready_out,
    output network_ACK_out,
    output[(data_size+tag_size-1):0] network_data_tag_out
);

    // ======== Instruction Decode ===========
    
    // Internal Signals
    wire[1:0] ID_opcode;

    // Control Unit
    control_unit control_unit_inst(clk, reset, data_parity_ready_in, network_data_ready_in, network_ACK_in, ID_opcode);

    // == ID/L1 Pipeline Register ==
    stage_1 #(.data_size(data_size), .tag_size(tag_size)) id_l1_pipeline_reg(clk, reset, ID_opcode, layer1_opcode, data_parity_in, layer1_dpp, network_data_tag_in, layer1_ndt);

    // =============== Layer 1 ===============

    // Pipeline Register Signals
    wire[1:0] layer1_opcode;
    wire[(data_size):0] layer1_dpp;
    wire[(data_size+tag_size-1):0] layer1_ndt;
    wire layer1_error_detected;

    // Soft Error Detector
    soft_error_detection #(.data_size(data_size)) SED_inst(clk, reset, layer1_dpp[data_size:1], layer1_dpp[0], layer1_error_detected);
    
    // == L1/L2 Pipeline Register ==
    stage_2 #(.data_size(data_size), .tag_size(tag_size)) l1_l2_pipeline_reg(clk, reset, layer1_opcode, layer2_opcode, layer1_error_detected, layer2_error_detected, layer1_dpp, layer2_dpp, layer1_ndt, layer2_ndt, layer2_rx_data, layer2_tx_data, layer2_rx_tag);

    // =============== Layer 2 ===============

    // Pipeline Register Signals
    wire[1:0] layer2_opcode;
    wire[(data_size):0] layer2_dpp;
    wire[(data_size-1):0] layer2_tx_data;
    wire[(data_size-1):0] layer2_rx_data;
    wire[(tag_size-1):0] layer2_rx_tag;
    wire[(tag_size-1):0] layer2_computed_tag;
    wire layer2_tag_match;
    wire[(data_size+tag_size-1):0] layer2_ndt;
    wire layer2_error_detected;

    // Internal Signals
    wire[(data_size-1):0] layer2_TGEN_data_in;
    wire[15:0] secret_key;

    // Multiplexer
    // Will assign layer2_TGEN_data_in to either layer2_tx_data or layer2_rx_data depending on the opcode.

    // Tag Generator
    tag_generation #(.DATA_SIZE(data_size), .TAG_SIZE(tag_size)) tag_gen_inst(clk, reset, layer2_TGEN_data_in, layer2_computed_tag);

    // Comparator
    assign layer2_tag_match = (layer2_computed_tag == layer2_rx_tag);

    // == L2/OL Pipeline Register ==
    stage_3 #(.data_size(data_size), .tag_size(tag_size)) l2_ol_pipeline_reg(clk, reset, layer2_opcode, OL_opcode, layer2_error_detected, OL_error_detected, layer2_tx_data, layer2_computed_tag, OL_tx_data, OL_tx_tag, layer2_tag_match, OL_tag_match, layer2_ndt, OL_ndt, OL_rx_data, OL_tx_data_tagged);

    // ============ Output Layer =============

    // Pipeline Register Signals
    wire[1:0] OL_opcode;
    wire[(data_size-1):0] OL_tx_data;
    wire[(data_size+tag_size-1):0] OL_tx_data_tagged;
    wire[(tag_size-1):0] OL_tx_tag;
    wire OL_tag_match;
    wire[(data_size-1):0] OL_rx_data;
    wire[(data_size+tag_size-1):0] OL_ndt;
    wire OL_error_detected;

    // Output Stage Module
    output_stage output_stage_inst(clk, reset, OL_opcode, OL_error_detected, OL_tx_data, OL_tx_tag, OL_tx_data_tagged, OL_tag_match, OL_rx_data, OL_ndt, parity_error_out, host_data_ready_out, network_data_ready_out, network_ACK_out, host_data_out, network_data_tag_out);

    // Logging Module
    wire[mem_depth-1:0][75:0] log_memory;
    log #(.DATA_SIZE(data_size), .TAG_SIZE(tag_size), .MEM_DEPTH(mem_depth)) log_inst(clk, reset, OL_error_detected, host_data_ready_out, network_data_ready_out, network_ACK_out, OL_tx_data, OL_ndt, log_memory);
endmodule