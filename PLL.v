`include "phase_detector.v"
`include "DCO.v"
`include "controller.v"
`include "frequency_divider.v"
module PLL (clk,N,clk_dco,rst_n,enable,clk_div,lead,lag,alpha_next,alpha);
    input rst_n;
    input clk;
    input [6:0] N;
    input enable;
    output lead;
    output [3:0] alpha;
    output clk_dco;
    output clk_div;
    output lag;
    output [3:0]alpha_next;


    phase_detector  U0(  .clk_ref(clk)  ,
                         .clk_div(clk_div)  ,
                         .lead(lead),
                         .rst_n(rst_n)  ,
                         .clk_dco(clk_dco) ,
                         .lag(lag));
                         
    frequency_divider  U1(  .clk_out(clk_div)  ,  
                            .clk_in(clk_dco)  ,  
                            .rst_n(rst_n) ,
                            .N(N));

    controller      U2(  .lead(lead),  
                         .lag(lag),  
                         .alpha(alpha),  
                         .alpha_next(alpha_next),  
                         .rst_n(rst_n), 
                         .clk_ref(clk),
                         .clk_dco(clk_dco));

    DCO             U3(  .enable(enable)  ,
                         .clk_dco(clk_dco) ,
                         .rst_n(rst_n),
                         .alpha_next(alpha_next),
                         .alpha(alpha));
endmodule
