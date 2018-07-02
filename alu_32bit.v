
module alu_32bit(source_1,source_2,alu_op,c_in,nzcv,alu_out);
	input c_in;
	input [3:0] alu_op;
	input [31:0] source_1,source_2;
	output [3:0] nzcv;
	output [31:0] alu_out;
	
	reg [3:0]nzcv;
	reg [31:0] alu_out;

	always@(*)begin
		case(alu_op)
			4'd0 : begin
				alu_out = source_1 & source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd1 : begin
				alu_out = source_1^source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd2 : begin
				{nzcv[1], alu_out} = {1'b0, source_1} + {1'b0, ~source_2} + 1'b1;
				nzcv[0] = nzcv[1] ^ source_1[31] ^ (~source_2[31]) ^ alu_out[31];
			end
			4'd3 : begin
				{nzcv[1], alu_out} = {1'b0, source_2} + {1'b0, ~source_1} + 1'b1;
				nzcv[0] = nzcv[1] ^ (~source_1[31]) ^ source_2[31] ^ alu_out[31];
			end
			4'd4 : begin
				{nzcv[1], alu_out} = {1'b0, source_1} + {1'b0, source_2};
				nzcv[0] = nzcv[1] ^ source_1[31] ^ source_2[31] ^ alu_out[31];
			end
			4'd5 : begin
				{nzcv[1], alu_out} = {1'b0, source_1} + {1'b0, source_2} + c_in;
				nzcv[0] = nzcv[1] ^ source_1[31] ^ source_2[31] ^ alu_out[31];
			end
			4'd6 : begin
				{nzcv[1], alu_out} = {1'b0, source_1} + {1'b0, ~source_2} + c_in;
				nzcv[0] = nzcv[1] ^ source_1[31] ^ (~source_2[31]) ^ alu_out[31];
			end
			4'd7 : begin
				{nzcv[1], alu_out} = {1'b0, source_2} + {1'b0, ~source_1} + c_in;
				nzcv[0] = nzcv[1] ^ (~source_1[31]) ^ source_2[31] ^ alu_out[31];
			end
			4'd8 : begin
				alu_out = source_1&source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd9 : begin
				alu_out= source_1^source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd10 : begin
				{nzcv[1], alu_out} = {1'b0, source_1} + {1'b0, ~source_2} + 1'b1;
				nzcv[0] = nzcv[1] ^ source_1[31] ^ (~source_2[31]) ^ alu_out[31];
			end
			4'd11 : begin
				{nzcv[1], alu_out}= {1'b0, source_1} + {1'b0, source_2};
				nzcv[0] = nzcv[1] ^ source_1[31] ^ source_2[31] ^ alu_out[31];
			end
			4'd12 : begin
				alu_out = source_1|source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd13 : begin
				alu_out = source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd14 : begin
				alu_out = source_1&(~source_2);
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			4'd15 : begin
				alu_out = ~source_2;
				nzcv[0] = 0;
				nzcv[1] = 0;
			end
			
		endcase
		
		if(alu_out == 32'b0)
			nzcv[2] = 1;
		else
			nzcv[2] = 0;
		if(alu_out[31] == 1)
			nzcv[3] = 1;
		else
			nzcv[3] = 0;
	end
endmodule 