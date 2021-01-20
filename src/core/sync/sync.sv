module sync #(WIDTH = 16)
    (
        input wire clk_a,
        input wire clk_b,
        input wire r,       //latches data on positive edge of clk_a

        output reg w = 0,   //pulses high when data is validated

        input wire [WIDTH - 1 : 0] I,
        output reg [WIDTH - 1 : 0] O = '0
    );
    reg [WIDTH - 1 : 0] I_buf = '0;
    reg [WIDTH - 1 : 0] O_buf = '0;

    always @(posedge clk_a) begin
        if(r) begin
            I_buf <= I;
        end
    end

    always @(posedge clk_b) begin
        O_buf <= I_buf;
        if(I_buf == O_buf) begin
            O <= O_buf;
            if(O != O_buf) begin
                w <= 1;
            end
            else begin
                w <= 0;
            end
        end
        else begin
            w <= 0;
        end
    end


endmodule