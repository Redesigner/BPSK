module PS_reg #(WIDTH = 32)
    (
        input wire cs,              //on positive edge, performs the action on the rw pin
        input wire rw,              //when brought high, writes
        input bit [WIDTH - 1 : 0] p,//parallel data

        output wire empty,          //high when no data left to send
        output wire s               //serialized data, beginning with LSB
    );
    localparam MAX = WIDTH;
    logic [WIDTH - 1 : 0] p_buf  = '0;
    logic [$clog2(WIDTH) : 0] counter   =  0;

    always @(posedge cs) begin
        if(rw == 0) begin //read
            p_buf <= p_buf << 1;

            //prevent underflow
            if(~empty) begin
                counter <= counter - 1;
            end
        end

        if(rw == 1) begin //write
            p_buf <= p;
            counter <= MAX - 1;
        end
    end

    assign empty = counter == 0;
    assign s = p_buf[MAX - 1];

endmodule