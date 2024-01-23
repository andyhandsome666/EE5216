module SAR(
    input [9:0] y_input,
    input clk,
    input start,
    input rst_n,
    output reg [1:0] state,
    output reg [7:0] x_guess,
    output reg done
    );
    reg [1:0] next_state; 
    reg [2:0] bit; 
    reg [7:0] x_guess_next;
    reg [9:0] y_guess, y_guess_last, diff, diff_next;
    reg update;

    parameter [1:0] IDLE = 0;
    parameter [1:0] READ = 1;
    parameter [1:0] CALC = 2;
    parameter [1:0] FINISH = 3;

    always@(posedge clk) begin
        if (~rst_n) begin
            state <= IDLE;
            x_guess <= 8'd128;
            y_guess <= (24*128+3000)/10;
            bit <= 3'd7;
        end else begin
            state <= next_state;
            x_guess <= x_guess_next;
        end
    end

    always @(*) begin
        done = 0;
        next_state = state;
        x_guess_next = x_guess;
        y_guess = (24*x_guess+3000)/10;
        case (state) 
            IDLE: begin
                if (start) begin
                    next_state = READ;
                end else begin
                    next_state = IDLE;
                end
            end

            READ: begin
                next_state = CALC;
            end

            CALC: begin
                if (bit!=0) begin
                    if (y_guess < y_input) begin
                        next_state = CALC;
                        x_guess_next[bit-1] = 1;
                    end else if (y_guess == y_input) begin
                        next_state=FINISH;
                    end else if (y_guess > y_input) begin
                        next_state=CALC;
                        x_guess_next[bit] = 0;
                        x_guess_next[bit-1] = 1;
                    end
                    bit = bit - 1'd1;
                end else begin
                    next_state = FINISH;
                    if (y_guess > y_input) begin
                        y_guess_last = (24*(x_guess-1)+3000)/10;
                        diff_next = y_input-y_guess_last;
                        diff = y_guess-y_input;
                        if (diff_next < diff) begin
                            x_guess_next = x_guess-1;
                        end
                    end else if (y_guess < y_input) begin
                        y_guess_last = (24*(x_guess+1)+3000)/10;
                        diff_next = y_guess_last-y_input;
                        diff = y_input-y_guess;
                        if (diff_next < diff) begin
                            x_guess_next = x_guess+1;
                        end
                    end
                end
            end

            FINISH: begin
                done = 1'b1;
                next_state = IDLE;
                x_guess_next = 8'd128;
                bit = 3'd7;
            end
        
        endcase
    end

endmodule
