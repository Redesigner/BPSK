module SP_reg #(WIDTH = 4)
    (
        input wire clk,
        input wire cs,
        input wire s,
        input wire clr, //force the register to empty

        output reg full = 0,
        output reg [WIDTH - 1:0] p = '0
    );
    bit [WIDTH - 1 : 0] p_buf  = '0; //this is where our actual data is stored
    bit [$clog2(WIDTH) : 0] counter   =  0;
    reg cs_b = cs;
    wire cs_edge;

    always @(posedge clk) begin
        cs_b <= cs;

        if(cs_edge) begin
            p_buf <= {p_buf[WIDTH - 2 : 0], s};
            full <= of;
            if(of) begin
                p <= {p_buf[WIDTH - 2 : 0], s};
                counter <= 0;
            end
            else if(~of) begin
                counter <= counter + 1;
            end
        end
    end
    /*
    always @(negedge cs) begin
        if(clr) begin
            counter <= 0;
            //p_buf <= '0;
        end
    end
    */

    assign of = counter >= WIDTH - 1;
    assign cs_edge = (~cs_b) & cs;

endmodule