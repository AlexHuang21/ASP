module SecretKeyRegister(
    input wire clk,           // Clock signal
    input wire reset,         // Asynchronous reset signal
    input wire load,          // Load signal to update the key
    input wire [15:0] key_in, // 16-bit input for the new key
    output reg [15:0] key     // 16-bit registered secret key output
);

// On the rising edge of the clock or on reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Clear the key register on reset
        key <= 16'b0;
    end
    else if (load) begin
        // Load the new key value when the load signal is asserted
        key <= key_in;
    end
end

endmodule
