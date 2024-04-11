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
    
    always @(posedge clk) begin 
        if (reset) begin
            opcode_out <= 2'b00;
        end else begin    
            case ({dpp_ready_in, nd_ready_in, na_in}) 
                default: opcode_out <= OP_NOP;
                3'b100: opcode_out <= OP_TXE;
                3'b010: opcode_out <= OP_RXA;
                3'b001: opcode_out <= OP_LOG;
             endcase 
        end        
    end
    
endmodule
