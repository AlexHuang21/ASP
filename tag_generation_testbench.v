module testbench;
    reg clk, reset;
    reg [31:0] data;
    wire [7:0] tag;

    // Instantiate the tag_generation module
    tag_generation uut (
        .clk(clk),
        .reset(reset),
        .data(data),
        .tag(tag)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test procedure
    initial begin
        reset = 1;  // Apply reset
        #20 reset = 0;  // Release reset
        #20;  // Wait for the system to stabilize

        // Test with expected correct output
        data = 32'h12345678;  // Set data
        #20;  // Wait for processing
        if (tag !== 8'hAB)
            $display("Test failed: Expected tag = 0xAB, Received tag = %h", tag);
        else
            $display("Test passed: Correct tag = %h", tag);

        // Test with expected incorrect output
        data = 32'h87654321;  // Change data
        #20;  // Wait for processing
        if (tag !== 8'h1F)  // Assume 0x1F is the observed incorrect output
            $display("Test unexpected: Expected tag = 0x1F, Received tag = %h", tag);
        else
            $display("Test expected incorrect behavior: Incorrect tag confirmed = %h", tag);

        $finish;  // End simulation
    end
endmodule
