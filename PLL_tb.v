`timescale 1ns/100ps
module PLL_tb();
    reg enable;
    reg rst_n;
    reg [6:0] N;
    reg clk_ref;
    wire clk_dco;
    wire lead_out;
    wire lead,lag;
    wire [3:0] alpha,alpha_next;
    //wire lead,lag;
    wire clk_div;
    

    PLL U0(.clk(clk_ref),
         .N(N),
         .clk_dco(clk_dco),
         .rst_n(rst_n),
         .enable(enable),
         .alpha(alpha),
         .alpha_next(alpha_next),
         .lead_out(lead_out),
	     .clk_div(clk_div),
         .lead(lead),
         .lag(lag));

    initial begin
      clk_ref= 0;
      N      = 92;
      enable = 0;
      rst_n  = 1;
      #5
      rst_n  = 0;
      #550
      rst_n  = 1;
      #40
      enable = 1;
      #2000000
      $finish;
    end

    always #(500) clk_ref = ~clk_ref;
    /*
    initial begin
        #100000;
        $finish;
    end*/

    initial begin
        $sdf_annotate("./PLL_syn.sdf", U0);
        $fsdbDumpfile("../4.Simulation_Result/PLL_syn.fsdb");
        $fsdbDumpvars;
    end
endmodule