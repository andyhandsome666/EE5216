module phase_detector(clk_ref,clk_div,rst_n,clk_dco,lead,lag);

output reg lead,lag;
input clk_ref,clk_div,clk_dco;
input rst_n;
wire ff_rst;

assign ff_rst = ~(lag & lead); 


always @(posedge clk_ref or negedge ff_rst or negedge rst_n)
begin
    if (~rst_n) begin 
        lag<=1'b0;
    end else if (~ff_rst) begin 
        lag <= 1'b0;
    end else begin 
        lag <= 1'b1;
    end
end

always @( posedge clk_div or negedge ff_rst or negedge rst_n )
begin
    if (~rst_n) begin 
        lead<=1'b0;
    end else if (~ff_rst) begin 
        lead <= 1'b0;
    end else begin 
        lead <= 1'b1;
    end
end 

endmodule