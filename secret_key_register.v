module secret_key_register (
    output[15:0] key  // 16-bit registered secret key output
);
    
    assign key = 16'hDEAD;
   
endmodule