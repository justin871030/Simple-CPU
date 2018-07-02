module ARM(clk,rst);
	input clk,rst;
	
	reg [3:0]nzcv_out;
	reg [31:0] pc;
	
	wire reg_write,mem_to_reg,mem_write,pc_src,update_nzcv,link,pc_write;
	wire  [1:0] alu_src;
	wire [3:0] alu_op,alu_nzcv,nzcv_in;
	
	wire [31:0] pc_add_4,mem_read_data,out3,sign_extend_out,alu_out,alu_operation_2;
	wire [31:0] read_pc_1,read_pc_2,read_pc_3,rotate_out,unsign_extend_out,shift_out,reg_write_data,pc_next,pc_branch;
	
   assign pc_add_4 = pc+32'd4;
	assign pc_branch = sign_extend_out+ pc_add_4; 
   assign reg_write_data = mem_to_reg ? mem_read_data:alu_out;
	assign pc_next = pc_write? (pc_src ? alu_out:alu_out): (pc_src? pc_branch : pc_add_4);
	assign alu_operation_2 = alu_src[1]?  (alu_src[0]? unsign_extend_out:shift_out): (alu_src[0]? rotate_out:shift_out );
	assign nzcv_in = (update_nzcv==0)? nzcv_out : alu_nzcv;


		controller controller(
				.nzcv(nzcv_out),
				.opfunc(out3[31:20]),
				.reg_write(reg_write),
				.mem_to_reg(mem_to_reg),
				.mem_write(mem_write),
				.pc_src(pc_src),
				.update_nzcv(update_nzcv),
				.link(link),
				.alu_src(alu_src),
				.alu_op(alu_op)
				);
		_data_mem _data_mem(
					.clk(clk),
					.rst(rst),
					.addr(alu_out),
					.write_data(read_pc_3),
					.mem_write(mem_write),
					.read_data(mem_read_data)
					);
		_ins_mem _ins_mem(
				.pc(pc),
				.ins(out3)
				);
		Reg_file Reg_file(.clk(clk),
		         .rst(rst),
				 .reg_write(reg_write),
				 .link(link),
				 .read_addr_1(out3[19:16]),
				 .read_addr_2(out3[3:0]),
				 .read_addr_3(out3[15:12]),
				 .write_addr(out3[15:12]),
				 .write_data(reg_write_data),
				 .pc_content(pc_add_4),
				 .pc_write(pc_write),
				 .read_data_1(read_pc_1),
				 .read_data_2(read_pc_2),
				 .read_data_3(read_pc_3)
				 );
		roratate roratate(
					.immediate_in(out3[11:0]),
					.immediate_out(rotate_out)
					);
		unsign_extend unsign_extend(
						.in(out3[11:0]),
						.out(unsign_extend_out)
						);
		multi_4_and_sign_extend multi_4_and_sign_extend(
								.sign_immediate_in(out3[23:0]),
								.sign_extend_immediate_out(sign_extend_out)
								);
		shift shift(
				.shift_type(out3[6:5]),
				.shift_number(out3[11:7]),
				.reg_data(read_pc_2),
				.shift_out(shift_out)
				);
		alu_32bit alu_32bit(
			.source_1(read_pc_1),
			.source_2(alu_operation_2),
			.alu_op(alu_op),
			.c_in(nzcv_out[0]),
			.nzcv(alu_nzcv),
			.alu_out(alu_out)
			);
		always@(posedge clk,posedge rst)begin
		  if(rst)begin 
		    pc <= 0;
		  end
		  else begin
		    pc <= pc_next;
		  end
		end
		
		always@(posedge clk,posedge rst)begin
		  if(rst) nzcv_out <= 0;
		  else nzcv_out <= nzcv_in;
		end

endmodule 