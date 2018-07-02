module multi_4_and_sign_extend(sign_immediate_in,sign_extend_immediate_out);
   input[23:0] sign_immediate_in;
   output[31:0] sign_extend_immediate_out;
   assign sign_extend_immediate_out[23:0]=sign_immediate_in<<2;
   assign sign_extend_immediate_out[31:24]=sign_immediate_in[23]?(8'b11111111):(8'b00000000);
 
endmodule 