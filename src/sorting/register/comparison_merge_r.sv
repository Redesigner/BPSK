`include "../../build/core_params.svh"
`include "../../build/network_params.svh"

module comparison_merge_r #(parameter SIZE = 4, UP = 1)
    (
        input wire clk,
        input wire reset,
        input wire ready,
        input wire [SIZE-1:0][NETWORK_WIDTH-1:0] data_in,
        input wire [SIZE-1:0][INDEX_WIDTH-1:0] index_in,

        output reg [SIZE-1:0][NETWORK_WIDTH-1:0] data_out = '0,
        output reg [SIZE-1:0][INDEX_WIDTH-1:0] index_out = '0,
        output reg done = 0
    );
    genvar i;
    generate
        if(SIZE != 2) begin
            reg sorter_ready = 0;
            reg [SIZE - 1:0][NETWORK_WIDTH-1:0] data_in_buffer = '0;
            reg [SIZE - 1:0][INDEX_WIDTH-1:0] index_in_buffer = '0;

            wire sort_top_done, sort_bottom_done;
            reg sort_done = 0;
            wire [SIZE - 1:0][NETWORK_WIDTH-1:0] sort_data_out;
            reg [SIZE - 1:0][NETWORK_WIDTH-1:0] sort_data_buffer = '0;
            wire [SIZE - 1:0][INDEX_WIDTH-1:0] sort_index_out;
            reg [SIZE - 1:0][INDEX_WIDTH-1:0] sort_index_buffer = '0;
            comparison_merge_r #(SIZE / 2, UP) sort_top
            (
                .clk(clk),
                .reset(reset),
                .ready(sorter_ready),
                .data_in(data_in_buffer[SIZE-1:SIZE/2]),
                .index_in(index_in_buffer[SIZE-1:SIZE/2]),
                .data_out(sort_data_out[SIZE-1:SIZE/2]),
                .index_out(sort_index_out[SIZE-1:SIZE/2]),
                .done(sort_top_done)
            );
            comparison_merge_r #(SIZE / 2, ~UP) sort_bottom
            (
                clk,
                reset,
                sorter_ready,
                data_in_buffer[SIZE/2-1:0],
                index_in_buffer[SIZE/2-1:0],
                sort_data_out[SIZE/2-1:0],
                sort_index_out[SIZE/2-1:0],
                sort_bottom_done
            );

            //Merge every pair of wires in the same direction
            wire [(SIZE / 2) - 1:0] merge_surface_done_i;
            reg merge_surface_done = 0;
            wire [SIZE - 1:0][NETWORK_WIDTH-1:0] surface_data_out;
            reg [SIZE - 1:0][NETWORK_WIDTH-1:0] surface_data_buffer = '0;
            wire [SIZE - 1:0][INDEX_WIDTH-1:0] surface_index_out;
            reg [SIZE - 1:0][INDEX_WIDTH-1:0] surface_index_buffer = '0;
            for(i = 0; i < SIZE / 2; i++) begin
                comparison_base_r #(UP) merge_surface_i
                (
                    clk,
                    reset,
                    sort_done, //Only execute this step once the initial sort is done
                    sort_data_buffer[i], sort_data_buffer[i + (SIZE / 2)],
                    sort_index_buffer[i], sort_index_buffer[i + (SIZE / 2)],
                    surface_data_out[i], surface_data_out[i + (SIZE / 2)],
                    surface_index_out[i], surface_index_out[i + (SIZE / 2)],
                    merge_surface_done_i[i]
                );
            end

            //Merge each half, recursively
            wire merge_top_done, merge_bottom_done;
            wire [SIZE - 1:0][NETWORK_WIDTH-1:0] merge_data_out;
            wire [SIZE - 1:0][INDEX_WIDTH-1:0] merge_index_out;
            comparison_merge_r #(SIZE / 2, UP) merge_top
            (
                clk,
                reset,
                merge_surface_done,
                surface_data_buffer[SIZE-1:SIZE/2],
                surface_index_buffer[SIZE-1:SIZE/2],
                merge_data_out[SIZE-1:SIZE/2],
                merge_index_out[SIZE-1:SIZE/2],
                merge_top_done
            );
            comparison_merge_r #(SIZE / 2, UP) merge_bottom
            (
                clk,
                reset,
                merge_surface_done,
                surface_data_buffer[SIZE/2-1:0],
                surface_index_buffer[SIZE/2-1:0],
                merge_data_out[SIZE/2-1:0],
                merge_index_out[SIZE/2-1:0],
                merge_bottom_done
            );

            //ONLY UPDATE ON CLOCK
            always @(posedge clk) begin
                if(reset) begin
                    sorter_ready <= 0;

                    sort_done <= 0;

                    merge_surface_done <= 0;


                    done <= '0;

                    index_out <= '0;
                    data_out <= '0;
                end

                else begin
                    if(ready) begin
                        sorter_ready <= 1;
                        data_in_buffer <= data_in;
                        index_in_buffer <= index_in;
                    end
                    if(sort_top_done && sort_bottom_done) begin
                        sort_done <= 1;
                        sort_data_buffer <=  sort_data_out;
                        sort_index_buffer <= sort_index_out;
                    end
                    if(&merge_surface_done_i) begin
                        merge_surface_done <= 1;
                        surface_data_buffer <= surface_data_out;
                        surface_index_buffer <= surface_index_out;
                    end
                    if(merge_top_done && merge_bottom_done) begin
                        done <= 1;
                        data_out <= merge_data_out;
                        index_out <= merge_index_out;
                    end
                end
            end

        end

        //BASE CASE -- essentially a wrapper for a comparator
        else begin
            comparison_base_r#(UP) comparator_base 
            (
                clk,
                reset,
                ready,
                data_in[0], data_in[1],
                index_in[0], index_in[1],
                data_out[0], data_out[1],
                index_out[0], index_out[1],
                done
            );
        end
    endgenerate
endmodule