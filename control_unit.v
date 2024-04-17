module control_unit(
    input clk,
    input reset,
    input dpp_ready_in,
    input nd_ready_in,
    input na_in,
    output reg[1:0] opcode_out
    );
    
    localparam OP_NOP = 2'b00;
    localparam OP_TXE = 2'b01;
    localparam OP_RXA = 2'b10;
    localparam OP_LOG = 2'b11;
    
    always @(*) begin 
        if (reset) begin
            opcode_out <= OP_NOP;
        end else begin
            
            // priority system which prioritizes receiving
            if (na_in && nd_ready_in) begin
                opcode_out <= OP_LOG;      
            end else if (nd_ready_in) begin
                opcode_out <= OP_RXA;
            end else if (dpp_ready_in) begin
                opcode_out <= OP_TXE;
            end else begin
                opcode_out <= OP_NOP;
            end

        end        
    end
    
endmodule
