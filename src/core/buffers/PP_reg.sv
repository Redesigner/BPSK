module PP_reg #(WIDTH_I = 16, WIDTH_O = 4)
/**
* A register that takes a parallel input and splits it into chunks, output one at a time
* alternatively, will store parallel inputs in a larger buffer, if the output width is larger than the input
*
* synchronized with clk
*
* on either 'cs' edge (sync'd with clk) executes read or write
*
* rw selects function: on 0, sets 'write' mode
* on 1, sets 'read' mode
**/
    (
        input wire clk,
        input wire cs,
        input wire rw,
        input wire [WIDTH_I - 1: 0] p_i,

        output wire flow, //flips high if the large buffer needs new data
        output wire [WIDTH_O - 1:0] p_o
    );
    generate;
        if(WIDTH_I > WIDTH_O) begin
            localparam MAX = WIDTH_I / WIDTH_O;
            logic [WIDTH_I - 1 : 0] p_buf  = '0;
            logic [$clog2(MAX) : 0] counter   =  0;
            reg cs_b = cs;
            wire cs_edge;

            always @(posedge clk) begin
                cs_b <= cs;

                if(cs_edge) begin
                    if(rw == 0) begin //read
                        p_buf <= p_buf << WIDTH_O;
                        
                        //prevent underflow
                        if(~flow) begin
                            counter <= counter - 1;
                        end
                    end
                    
                    if(rw == 1) begin //write
                        p_buf <= p_i;
                        counter <= MAX - 1;
                    end
                end
            end
            assign flow = counter == 0;
            assign p_o[WIDTH_O - 1 : 0] = p_buf[WIDTH_I - 1 : WIDTH_I - WIDTH_O];
            assign cs_edge = (~cs_b) & cs;
        end

        if(WIDTH_O > WIDTH_I) begin
            localparam MAX = WIDTH_O / WIDTH_I;
            logic [WIDTH_O - 1 : 0] p_buf  = '0;
            reg [WIDTH_O - 1 : 0] p_o_buf = '0;
            logic [$clog2(MAX) : 0] counter   =  0;
            reg cs_b = cs;
            wire cs_edge;

            always@(posedge clk) begin
                cs_b <= cs;
                
                if(cs_edge) begin
                    p_buf <= {p_buf[WIDTH_O - WIDTH_I : 0], p_i};
                    if(rw == 0) begin //read
                        p_o_buf <= p_buf;
                        counter <= 0;
                    end
                    if(rw == 1) begin //write, latch our input to the register
                        if(~flow) begin
                            counter <= counter + 1;
                        end
                    end
                end
            end
            assign flow = counter == MAX - 1;
            assign p_o = p_o_buf;
            assign cs_edge = (~cs_b) & cs;
        end

    endgenerate
   
endmodule