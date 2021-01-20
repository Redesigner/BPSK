module CRC_8#(INPUT_WIDTH = 16)
    (
    input wire clk,
    input wire [INPUT_WIDTH - 1:0] data_in,
    output wire [7:0] data_out,
    output wire done
    );
    localparam generator_polynomial = 8'b00000111;
    
    reg [INPUT_WIDTH - 1:0] data_in_old = '0;
    reg [INPUT_WIDTH - 1:0] CRC;
    
    reg [$clog2(INPUT_WIDTH - 1):0] shift_counter = 0;
    reg start_flag = 0;
    
    always @(posedge clk) begin
        data_in_old <= data_in;
        if(data_in_old != data_in) begin
            shift_counter <= 0;
            start_flag <= 1;
            CRC <= data_in;
        end
        
        if(start_flag == 1) begin  
            if(CRC[INPUT_WIDTH - 1] == 1) begin //if MSB is 1, we need to XOR
                CRC <= {(CRC[INPUT_WIDTH - 2 : INPUT_WIDTH - 9] ^ generator_polynomial), //XOR the 2nd MSB with the polynomial
                CRC[INPUT_WIDTH - 10:0], 1'b0}; //copy the rest of the CRC, making sure to define the new LSB
            end
            else begin
                CRC <= CRC << 1; //simple left shift
            end
            
            if(shift_counter + 1 <= INPUT_WIDTH - 1) begin
                shift_counter <= shift_counter + 1;
            end
            else begin
                start_flag <= 0;
            end
        end
    end
    assign done = (start_flag == 0) && (shift_counter == INPUT_WIDTH - 1);
    assign data_out = CRC[INPUT_WIDTH - 1 : INPUT_WIDTH - 8];

    wire[7:0] debug1;
    wire[INPUT_WIDTH - 8: 0] debug2;
    assign debug1 = CRC[INPUT_WIDTH - 2 : INPUT_WIDTH - 9] ^ generator_polynomial;
    assign debug2 = CRC[INPUT_WIDTH - 10:0];
endmodule