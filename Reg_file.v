module Reg_file(clk,rst,reg_write,link,read_addr_1,read_addr_2,read_addr_3,write_addr,write_data,pc_content,pc_write,read_data_1,read_data_2,read_data_3);
 input clk,rst,reg_write,link;
 input [3:0] read_addr_1,read_addr_2,read_addr_3,write_addr; 
 input [31:0] write_data,pc_content;
 reg[31:0] mother [14:0];
 output reg pc_write;
 output reg[31:0]read_data_1,read_data_2,read_data_3;
 integer i;

always@(posedge clk or posedge rst)begin 

   if(rst)begin     
		for(i=0;i<15;i=i+1)	  
 			mother[i]<=32'b0;
	end
   else begin
	if(write_addr != 4'd15 && reg_write == 4'd1)
	
	  mother[write_addr] <= write_data;
   
   if(link==1'd1)
	
     mother[14] <= pc_content;

	end
end
 
always@(*)begin
		  
	if(reg_write==4'd1 && write_addr == 4'd15) 
		pc_write = 1;
		  
	else 
		pc_write = 0;
		  
		  

	if(read_addr_1==4'd15) 
		read_data_1=pc_content;
		  
	else 
		read_data_1=mother[read_addr_1];
		  
	if(read_addr_2==4'd15)
		read_data_2=pc_content;
		  
	else 
		read_data_2=mother[read_addr_2];
		  
	if(read_addr_3==4'd15) 
		read_data_3=pc_content;
		  
	else 
		read_data_3=mother[read_addr_3];

		  
		
end
 
endmodule  