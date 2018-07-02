module controller(nzcv,opfunc,reg_write,mem_to_reg,mem_write,pc_src,update_nzcv,link,alu_src,alu_op);
	input [3:0] nzcv;
	input [11:0] opfunc;
	output reg_write,mem_to_reg,mem_write,pc_src,update_nzcv,link;   
	output [1:0] alu_src;
	output [3:0] alu_op;

	reg reg_write,mem_to_reg,mem_write,pc_src,update_nzcv,link;
	reg [1:0] alu_src;
	reg [3:0] alu_op;

	reg success;

	always@(*)begin
		case(opfunc[11:8])
			4'b0000: success = nzcv[2];
			4'b0001: success = ~nzcv[2];
			4'b0010: success = nzcv[1];
			4'b0011: success = ~nzcv[1];
			4'b0100: success = nzcv[3];
			4'b0101: success = ~nzcv[3];
			4'b0110: success = nzcv[0];
			4'b0111: success = ~nzcv[0];
			4'b1000: success = (nzcv[1]==1 && nzcv[2]==0);
			4'b1001: success = (nzcv[1]==0 || nzcv[2]==1);
			4'b1010: success = (nzcv[3]==nzcv[0]);
			4'b1011: success = (nzcv[3]!=nzcv[0]);
			4'b1100: success = (nzcv[2]==0 && nzcv[3]==nzcv[0]);
			4'b1101: success = (nzcv[2]==1 && nzcv[3]!=nzcv[0]);
			4'b1110: success = 1'b1;
			4'b1111: success = 1'b0;
			default: success = 1'b0;
		endcase
	end
   
	always@(*)begin
		if(success == 0)begin
			reg_write = 1'b0 ;
			alu_src = 2'b00 ; 
			alu_op = 4'b0000 ;
			mem_to_reg= 1'b0 ;
			mem_write = 1'b0 ;
			pc_src = 1'b0 ;
			update_nzcv = 1'b0 ;
			link = 0;
		end
		
		else if(success == 1)begin
			if(opfunc[7:5]==3'b101)begin
				reg_write = 1'b0 ; 
				alu_src = 2'b00 ; 
				alu_op = 4'b0000 ;
				mem_to_reg = 1'b0 ; 
				mem_write = 1'b0 ;
				pc_src = 1'b1 ;
				update_nzcv = 1'b0 ; 
				link = opfunc[4];
			end
			else if(opfunc[7:6]==2'b00)begin
				reg_write = (opfunc[4:3]==2'b10)? 1'b0 : 1'b1;
				alu_src = (opfunc[5])?2'b01:2'b00;
				alu_op = opfunc[4:1] ; 
				mem_to_reg = 1'b0 ;
				mem_write = 1'b0 ;
				pc_src=1'b0 ;
				update_nzcv =opfunc[0];
				link = 1'b0;
			end
			else if(opfunc[7:6]==2'b01)begin
				reg_write = opfunc[0] ;
				if(opfunc[5] == 1'b1)	alu_src = 2'b10;
				if(opfunc[5] == 1'b0)	alu_src = 2'b11;
				if(opfunc[3] == 1'b1)	alu_op =4'b0100;
				if(opfunc[3] == 1'b0)	alu_op =4'b0010;
				mem_to_reg = 1'b1;
				mem_write = ~opfunc[0] ;
				pc_src = 1'b0 ; 
				update_nzcv = 1'b0 ;
				link = 1'b0;
			end
	
		else begin
			reg_write = 1'bx ; 
			alu_src = 2'bx ; 
			alu_op = 4'bx ;
			mem_to_reg = 1'bx ; 
			mem_write = 1'bx ; 
			pc_src = 1'bx ;
			update_nzcv = 1'bx ; 
			link = 1'bx;
	end

end


end

endmodule 