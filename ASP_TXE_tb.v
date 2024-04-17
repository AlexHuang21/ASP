`timescale 1ns/1ns

module ASP_TXE_tb();
    parameter DATA_SIZE = 16;
    parameter TAG_SIZE = 4;

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

    ASP #(.data_size(DATA_SIZE), .tag_size(TAG_SIZE)) ASP_inst (
        clk, 
        reset, 
        data_parity_ready_in, 
        data_parity_in, 
        network_data_ready_in, 
        network_ACK_in,
        network_data_tag_in, 
        parity_error_out, 
        host_data_ready_out, 
        host_data_out, 
        network_data_ready_out,
        network_ACK_out, 
        network_data_tag_out
    );

    always #10 clk = ~clk;

    initial begin
        // Initialization
        clk = 0;
        reset = 1;
        data_parity_ready_in = 0;
        data_parity_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        network_data_tag_in = 0;
        #20
        
        reset = 0;
        
        // Test case 1: Single NOP
        data_parity_ready_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = 0;
        #20;
        
        // Test case 2: Single TXE, normal
        /*data_parity_ready_in = 1;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = {32'hA1B2C3D4, 1'b1}; // data plus correct parity bit (1)
        network_data_tag_in = 0;
        #20;*/

        // Test case 3: Single TXE w/ soft error
        /*data_parity_ready_in = 1;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = {32'hA1B2C3D4, 1'b0}; // data plus incorrect parity bit (0) 
        network_data_tag_in = 0;
        #20;*/
        
        // Test case 4: Single RXA w/ correct tag
        /*data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {32'hA1B2C3D4, 8'h07};
        #20;*/
        
        // Test case 5: Single RXA w/ incorrect tag
        /*data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {32'hA1B2C3D4, 8'hBB}; // input data plus incorrect tag
        #20;*/
        
        // Test case 6: TXE and RXA (simultaneous)
        /*data_parity_ready_in = 1;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = {32'hA5A5A5A5, 1'b0};
        network_data_tag_in = {32'hA1B2C3D4, 8'h07}; 
        #20;*/
       
        // Test case 7: Single LOG
        /*data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 1;
        data_parity_in = 0;
        network_data_tag_in = {32'hA1B2C3D4, 8'h07};
        #20;*/
        
        // Test case 8: Testing everything together (32-bit data)
        // TXE (successful)
        /*data_parity_ready_in = 1;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = {32'hA1B2C3D4, 1'b1};
        network_data_tag_in = 0;
        #20;
        // NOP
        data_parity_ready_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = 0;
        #20;
        // LOG
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 1;
        data_parity_in = 0;
        network_data_tag_in = {32'hA1B2C3D4, 8'h07};
        #20;
        // RXA (successful)
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {32'hBE83D8C4, 8'h2D};
        #20;
        // RXA (unsuccessful)
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {32'hA5A5A5A5, 8'h00};
        #20;
        // RXA (successful)
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {32'hA5A5A5A5, 8'hBB};
        #20;*/
        
        // Test case 9: Testing everything together (16-bit data)
        // TXE (successful)
        data_parity_ready_in = 1;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = {16'hABBD, 1'b1}; // data plus correct parity bit (1)
        network_data_tag_in = 0;
        #20;
        #20;
        // NOP
        data_parity_ready_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = 0;
        #20;
        // LOG
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 1;
        data_parity_in = 0;
        network_data_tag_in = {16'hABBD, 4'h8};
        #20;
        // RXA (successful)
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {16'hC129, 4'hA};
        #20;
        // RXA (unsuccessful)
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {16'hBEEF, 4'hA};
        #20;
        // RXA (successful)
        data_parity_ready_in = 0;
        network_data_ready_in = 1;
        network_ACK_in = 0;
        data_parity_in = 0;
        network_data_tag_in = {16'hBEEF, 4'hB};
        #20;
        
        // reset
        data_parity_ready_in = 0;
        data_parity_in = 0;
        network_data_ready_in = 0;
        network_ACK_in = 0;
        network_data_tag_in = 0;
        #20
 
        #20;
        #20;
        #20;
        #20;
        #20;
        #100;
        
        $finish;
	end

endmodule