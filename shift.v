module shift(shift_type,shift_number,reg_data,shift_out);
	input [1:0] shift_type;
	input [4:0] shift_number;
	input [31:0] reg_data;
	output [31:0] shift_out;

	reg [31:0] product,shift_out ;
	reg tmp;
	integer i;
	
	always@(*) begin
		product = reg_data;
		case(shift_type)
			2'd0 :begin
				for(i=0;i<shift_number;i=i+1)begin
					product[31:1] = product[30:0];
					product[0] = 1'b0;
				end
				shift_out=product;
			end
			2'd1 :begin
				for(i=0;i<shift_number;i=i+1)begin
					product[30:0] = product[31:1];
					product[31] = 1'b0;
				end
				shift_out=product;
			end
			2'd2 :begin
				for(i=0;i<shift_number;i=i+1)begin
					product[30:0] = product[31:1];
					product[31] = product[30];
				end
				shift_out=product;
			end
			2'd3 :begin
				for(i=0;i<shift_number;i=i+1)begin
					tmp = product[0];
					product[30:0] = product[31:1];
					product[31] = tmp;
				end
				shift_out=product;
			end
		
		endcase
	end

endmodule
