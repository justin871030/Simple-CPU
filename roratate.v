module roratate(immediate_in,immediate_out);
	input [11:0] immediate_in;
	output [31:0] immediate_out;
	
	reg [31:0]product1,immediate_out;
	reg tmp;
	wire [4:0]s;
	assign s=immediate_in[11:8]*2;
	
	integer i;
	
	always@(*)begin
		product1={{24{1'b0}},immediate_in[7:0]};
		for(i=0;i<s;i=i+1)begin
			tmp = product1[0];
			product1[30:0] = product1[31:1];
			product1 [31] = tmp; 
		end
		immediate_out = product1;
	end

endmodule
