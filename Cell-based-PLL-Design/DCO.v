module DCO(enable, clk_dco , rst_n ,alpha_next,alpha);
    input enable;
    input rst_n;
    input [3:0] alpha;
    input [3:0] alpha_next;
    reg [14:0] lambda;
    wire [14:0] w;
    wire t;
    wire clk_tmp;
    output wire clk_dco;

    parameter buffer = 10'd14;
    parameter delay_group = 10'd82;
    wire [delay_group:0] d;

    always @(posedge clk_dco or negedge rst_n) begin
        if (!rst_n) begin
            lambda=15'b000000000000001;
        end
        else if (alpha == alpha_next) begin
            case (alpha)
                4'd1: lambda=15'b000000000000001;
                4'd2: lambda=15'b000000000000010;
                4'd3: lambda=15'b000000000000100;
                4'd4: lambda=15'b000000000001000;
                4'd5: lambda=15'b000000000010000;
                4'd6: lambda=15'b000000000100000;
                4'd7: lambda=15'b000000001000000;
                4'd8: lambda=15'b000000010000000;
                4'd9: lambda=15'b000000100000000;
                4'd10: lambda=15'b000001000000000;
                4'd11: lambda=15'b000010000000000;
                4'd12: lambda=15'b000100000000000;
                4'd13: lambda=15'b001000000000000;
                4'd14: lambda=15'b010000000000000;
                4'd15: lambda=15'b100000000000000;
                default : lambda=15'b000000000000001;
            endcase
        end 
    end

    

    NAND2X2 F0( .A(enable) ,.B(t) ,.Y(d[0]));
    BUFX3 A0( .A (d[delay_group]), .Y (w[0]) );

    genvar i;    
    generate
        for (i = 0; i < buffer; i = i + 1) begin:loop1
            CLKBUFX20 A1( .A (w[i]), .Y (w[i+1]) );
            TBUFX20 D0( .A (w[i]), .Y (t) , .OE(lambda[i]) );
        end
	TBUFX20 D1( .A (w[buffer]), .Y (t) , .OE(lambda[buffer]) );
    endgenerate

    generate
        for (i = 0; i < delay_group; i = i + 1) begin:loop3
            CLKBUFX4 C1(.A(d[i]), .Y(d[i+1]));
        end
    endgenerate
    assign clk_tmp = ~t;
    assign clk_dco = ~t || clk_tmp ;

endmodule