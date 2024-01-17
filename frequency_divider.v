module frequency_divider (  clk_out ,  clk_in  ,  rst_n  ,  N);
    reg [6:0]cnt_tmp;
    reg clk_tmp;
    reg [6:0]cnt;
    input [6:0]N;
	input clk_in;
	input rst_n;
	output reg clk_out;

always@*
    if( cnt == N>>1)
        begin
            cnt_tmp = 7'b1;
            clk_tmp = ~clk_out;
        end
    else
        begin
            cnt_tmp = cnt + 1;
            clk_tmp = clk_out;
        end

always@(posedge clk_in or negedge rst_n)
    if(~rst_n)
        begin
            cnt <= 7'b0;
            clk_out <= 1'b0;
        end
    else
        begin
            cnt <= cnt_tmp;
            clk_out <= clk_tmp;
        end

endmodule
