module unsign_extend(in,out);

input [11:0]in;
output [31:0]out;

assign out = {20'b0000_0000_0000_0000_0000,in};
endmodule
