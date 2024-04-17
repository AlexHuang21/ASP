module soft_error_detection #(parameter data_size = 32) (
    input clk,
    input reset,
    input[data_size-1:0] data,
    input parity_bit,
    output reg soft_error_flag
    );
    
    // Calculate the parity of the input data (even parity) by using reduction XOR operation
    wire calculated_parity = ^data;
    
    // Check if the calulcated parity matches the recevied parity bit
    always @(*) begin
        if (reset) begin
            soft_error_flag <= 1'b0;
        end else begin    
            if (calculated_parity == parity_bit) begin
                // No soft error detected
                soft_error_flag <= 1'b0;
            end else begin
                // Soft error detected
                soft_error_flag <= 1'b1;
            end
        end   
    end
endmodule

    