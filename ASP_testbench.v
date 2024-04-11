`timescale 1ns/1ns

module ASP_testbench();
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

    initial begin
        $dumpfile("dumpfiles/ASP_testbench_out.vcd");
        $dumpvars(0,ASP_testbench);

        clk = 0;
        reset = 0;

        data_parity_ready_in = 0;
        data_parity_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        network_data_tag_in = 0;

        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        reset = 1;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        reset = 0;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        #5;
        clk = ~clk;
        
        
        $finish;
	end
endmodule