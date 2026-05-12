module snn_output_layer_top #(
    parameter INPUTS  = 256,
    parameter NEURONS = 10,
    parameter W       = 8,
    parameter CNT_W   = 16,
    parameter FIFO_DEPTH = 1024
)(
    input wire clk,
    input wire rst,

    
    input wire [W-1:0] delta_in,
    input wire [$clog2(INPUTS)-1:0] index_in,
    input wire spike_valid,
    input wire layer3_done,

    
    output wire [$clog2(NEURONS)-1:0] predicted_digit
);



wire fifo_full;
wire fifo_empty;
wire fifo_rd_en;

 wire [W-1:0] fifo_delta_out;
 wire [$clog2(INPUTS)-1:0] fifo_index_out;

spike_fifo_output fifo (

    .clk(clk),
    .rst(rst),

    .wr_en(spike_valid),
    .delta_in(delta_in),
    .index_in(index_in),
    .full(fifo_full),

    .rd_en(fifo_rd_en),
    .delta_out(fifo_delta_out),
    .index_out(fifo_index_out),
    .empty(fifo_empty),

    .count()
);



 wire load_dt;
 wire hold_dt;
 wire decay_enable;
 wire accumulate_enable;
 wire fire_enable;

layer_control_correct_output controller (

    .clk(clk),
    .rst(rst),

    .delta_time_in(fifo_delta_out),
    .spike_valid_in(!fifo_empty),
    .layer3_done(layer3_done),

    .load_dt(load_dt),
    .hold_dt(hold_dt),

    .decay_enable(decay_enable),
    .accumulate_enable(accumulate_enable),
    .fire_enable(fire_enable),

    .layer_active(),
    .layer_done(),
    .event_done()
);

assign fifo_rd_en = load_dt & !fifo_empty;


wire [NEURONS*W-1:0] weights_to_neurons;

weights_memory_output weight_mem (

    .clk(clk),
    .rst(rst),

    .read_en(load_dt),
    .delta_time(fifo_delta_out),
    .synapse_idx(fifo_index_out),

    .weights_out(weights_to_neurons)
);



wire [NEURONS-1:0] fire_vector;

genvar i;

generate
for(i=0;i<NEURONS;i=i+1)
begin : OUTPUT_NEURONS

    
    neuron_core_output neuron (

        .clk(clk),
        .reset(rst),

        .decay_enable(decay_enable),
        .accumulate_enable(accumulate_enable),
        .fire_enable(fire_enable),

        .w(weights_to_neurons[i*W +: W]),
        .theta(8'sd10),

        .fire(fire_vector[i])
    );

end
endgenerate


wire [NEURONS*CNT_W-1:0] spike_count_bus;

spike_counter counter (

    .clk(clk),
    .rst(rst),

    .fire_enable(fire_enable),
    .fire_vector(fire_vector),

    .layer_reset(layer3_done),

    .spike_count_bus(spike_count_bus)
);


argmax classifier (

    .clk(clk),
    .start(layer3_done),

    .spike_count_bus(spike_count_bus),

    .predicted_digit(predicted_digit)
);

endmodule