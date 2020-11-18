//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_i;
   wire [10:0] DIN0_i;
   wire [10:0] DIN1_i;
   wire [10:0] DIN2_i;
   wire VIN_i;
   wire [0:120] b_i;
   wire [10:0] DOUT0_i;
   wire [10:0] DOUT1_i;
   wire [10:0] DOUT2_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.CLK(CLK_i),
	      .RST(RST_i),
		.END_SIM(END_SIM_i));

   data_gen SM(.CLK(CLK_i),
	     .RST_n(RST_i),
		 .b(b_i),
		 .VOUT(VIN_i),
		 .DOUT0(DIN0_i),
		.DOUT1(DIN1_i),
		.DOUT2(DIN2_i),
		.END_SIM(END_SIM_i));

   gr13_fir UUT(.b(b_i),
		 .DIN0(DIN0_i),
		.DIN1(DIN1_i),
		.DIN2(DIN2_i),
         	.VIN(VIN_i),
	     	.RST_n(RST_i),
	     	.CLK(CLK_i),
         	.DOUT0(DOUT0_i),
		.DOUT1(DOUT1_i),
		.DOUT2(DOUT2_i),
         	.VOUT(VOUT_i));

   data_save DS(.CLK(CLK_i),
		.RST(RST_i),
		.VIN(VOUT_i),
		.DIN0(DOUT0_i),
		.DIN1(DOUT1_i),
		.DIN2(DOUT2_i));   

endmodule

		   
