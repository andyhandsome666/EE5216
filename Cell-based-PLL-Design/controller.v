module controller(lead,lag,alpha,alpha_next,rst_n,clk_ref,clk_dco);

input lead,lag,rst_n,clk_ref,clk_dco;
output reg [3:0] alpha;
output reg [3:0] alpha_next;
reg [5:0] counter,counter_tmp; 
always @(posedge clk_ref or negedge rst_n) begin
        if (~rst_n) begin
            alpha_next = 4'd1; 
        end else if (lead) begin
            if(counter == 63) begin
            alpha_next = alpha + 4'd1;
            end

        end else if (~lead) begin
            if(counter == 63) begin
            if (alpha == 4'd1) begin
                alpha_next = 4'd1;
            end else begin
                alpha_next = alpha - 4'd1;
            end 
            end
        end
    end

    always @(negedge clk_ref or negedge rst_n) begin
        if(~rst_n) begin
            counter <= 6'd0;
        end else
            counter <= counter + 1;
    end
    /*always @* begin
        counter_tmp <= counter+1;
end*/

    always @(negedge clk_dco or negedge rst_n) begin
        if(~rst_n) begin
            alpha <= 4'd1;
        end
        else begin
            alpha <= alpha_next; 
        end
    end


endmodule