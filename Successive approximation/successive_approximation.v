module functional_unit(
    input[9:0] y_input,
    input clk,
    input start,
    input rst_n,
    output reg [1:0] state,
    output reg [7:0] x_guess,
    output reg done,
    output reg [9:0] func
    );
    reg [1:0] next_state;  
    reg [7:0] lower, upper, mid;
    reg [7:0] next_lower, next_upper;
    reg [7:0] x_guess_next;
    reg [9:0] diff, update_diff, last_comp;

    parameter [1:0] IDLE=0;
    parameter [1:0] CALC=1;
    parameter [1:0] FINISH=2;

    always@(posedge clk) begin
        if (~rst_n) begin
            lower<=8'd0;
            upper<=8'd255;
            state<=IDLE;
            x_guess<=8'd0;
        end else begin
            upper<=next_upper;
            lower<=next_lower;
            state<=next_state;
            x_guess<=x_guess_next;
        end
    end

    always @(*) begin
        done=1'b0;
        next_state=state;
        next_upper=upper;
        next_lower=lower;
        x_guess_next=x_guess;

        case (state) 
            IDLE: begin
                if (start) begin
                    next_state=CALC;
                end
            end


            CALC: begin
                if (lower<upper) begin
                    next_state=CALC;

                    mid=(lower+upper)/2;
                    func=(24*mid+3000)/10;
                    update_diff=(func-y_input)>=0?(func-y_input):(y_input-func);
                    diff=((24*x_guess+3000)/10-y_input)>=0?((24*x_guess+3000)/10-y_input):(y_input-(24*x_guess+3000)/10);

                    if (update_diff<diff) begin
                        x_guess_next=mid;
                    end else begin 
                        x_guess_next=x_guess;
                    end

                    if (func<y_input) begin
                        next_lower=mid+1;
                    end else begin
                        next_upper=mid-1;
                    end
                end

                else if (lower==upper) begin
                    next_state=FINISH;
                    x_guess_next=lower;
                end

                else begin
                    next_state=FINISH;
                    func=(24*x_guess+3000)/10;

                    if (func>y_input) begin
                        last_comp=(24*(x_guess-1)+3000)/10;
                        update_diff=y_input-last_comp;
                        diff=func-y_input;
                        if (update_diff<diff) begin
                            x_guess_next=x_guess-1;
                        end else begin
                            x_guess_next=x_guess;
                        end
                    end

                    else if (func<y_input) begin
                        last_comp=(24*(x_guess+1)+3000)/10;
                        update_diff=last_comp-y_input;
                        diff=y_input-func;
                        if (update_diff<diff) begin
                            x_guess_next=x_guess+1;
                        end else begin
                            x_guess_next=x_guess;
                        end
                    end

                    else begin
                        x_guess_next=x_guess;
                    end
                end
            end

            FINISH: begin
                done=1'b1;
                next_state=IDLE;
                x_guess_next=8'd0;
                next_lower=8'd0;
                next_upper=8'd255;
            end
        
        endcase
    end

endmodule