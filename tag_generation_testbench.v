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
        if (tag !== 8'hDE)
            $display("Test failed: Expected tag = 0xDE, Received tag = %h", tag);
        else
            $display("Test passed: Correct tag = %h", tag);

        $finish;  // End simulation
    end
endmodule
