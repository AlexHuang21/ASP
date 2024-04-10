module TGEN(
    input wire [3:0] D0, // 4-bit data input segment 0
    input wire [3:0] D1, // 4-bit data input segment 1
    input wire [3:0] D2, // 4-bit data input segment 2
    input wire [3:0] D3, // 4-bit data input segment 3
    output wire [3:0] tag // 4-bit tag output
);

// Secret key bits for block flip (BF)
parameter [3:0] BF = 4'b1101; // bit pattern

// Secret key bits for rotate-left-shift (RLS)
parameter r0 = 2; // rotate amount for segment 0
parameter r1 = 5; // rotate amount for segment 1
parameter r2 = 8; // rotate amount for segment 2
parameter r3 = 11; // rotate amount for segment 3

// Intermediate signals
wire [3:0] A0, A1, A2, A3;
wire [3:0] B0, B1, B2, B3;

// Block flip operation
assign A0 = (BF[0]) ? ~D0 : D0;
assign A1 = (BF[1]) ? ~D1 : D1;
assign A2 = (BF[2]) ? ~D2 : D2;
assign A3 = (BF[3]) ? ~D3 : D3;

// Rotate-left-shift operation
assign B0 = (A0 << r0) | (A0 >> (4-r0));
assign B1 = (A1 << r1) | (A1 >> (4-r1));
assign B2 = (A2 << r2) | (A2 >> (4-r2));
assign B3 = (A3 << r3) | (A3 >> (4-r3));

// XOR operation to generate the tag
assign tag = B0 ^ B1 ^ B2 ^ B3;

endmodule
