`timescale 1ns/1ns

module ASP_TXE_tb();
    parameter DATA_SIZE = 32;
    parameter TAG_SIZE = 8;

    reg clk;
    reg reset;

    reg data_parity_ready_in;
    reg[(DATA_SIZE):0] data_parity_in;

    reg network_data_ready_in;
    reg network_ACK_in;
    reg[(DATA_SIZE+TAG_SIZE-1):0] network_data_tag_in;

    wire parity_error_out;
    wire host_data_ready_out;
    wire[(DATA_SIZE-1):0] host_data_out;

    wire network_data_ready_out;
    wire network_ACK_out;
    wire[(DATA_SIZE+TAG_SIZE-1):0] network_data_tag_out;

    ASP #(.data_size(DATA_SIZE), .tag_size(TAG_SIZE)) ASP_inst(clk, reset, data_parity_ready_in, data_parity_in, network_data_ready_in, network_ACK_in, network_data_tag_in, parity_error_out, host_data_ready_out, host_data_out, network_data_ready_out, network_ACK_out, network_data_tag_out);

    always #10 clk = ~clk;

    initial begin
        $dumpfile("dumpfiles/ASP_TXE_tb.vcd");
        $dumpvars(0,ASP_TXE_tb);

        // Initialization
        clk = 0;
        reset = 0;
        data_parity_ready_in = 0;
        data_parity_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        network_data_tag_in = 0;
        #10

        // Test case 1: Data transmission with no soft error
        data_parity_ready_in = 1;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = 33'b101001011010010110100101101001010; // data plus correct parity bit (0)
        network_data_tag_in = 0;
        #20;

        // Test case 2: Data transmission with soft error
        data_parity_ready_in = 1;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = 33'b101001011010010110100101101001011; // data plus incorrect parity bit (1)
        network_data_tag_in = 0;
        #20;
        
        $finish;
	end

endmodule