module snn_system_top_3 #(
    parameter N = 784,
    parameter W = 8,
    parameter NUM_IMAGES = 1,
    parameter FIFO_DEPTH = 800,
    parameter NEURONS = 800
)(
    input clk,
    input rst,

    input load_new_image,
    input start_sorting,
    input [(NUM_IMAGES>1 ? $clog2(NUM_IMAGES):1)-1:0] img_idx,

    output [W-1:0] dout_delta,
    output load_dt,
    output hold_dt,
    output decay_enable,
    output accumulate_enable,
    output fire_enable,

    output [$clog2(NEURONS)-1:0] lopd_index,
    output lopd_valid,

    output layer_active,
    output layer_done,
    output fifo_empty,
    output fifo_full,
    output [$clog2(FIFO_DEPTH):0] fifo_count
);



wire [N*W-1:0] bus_in_times;

mnist_latency_memory #(
    .N(N),
    .W(W),
    .NUM_IMAGES(NUM_IMAGES)
) image_mem (
    .clk(clk),
    .load_image(load_new_image),
    .image_index(img_idx),
    .in_times(bus_in_times)
);



wire [W-1:0] sorter_delta_t;
wire [$clog2(N)-1:0] sorter_spike_index;
wire sorter_valid;
wire sorter_done;

reg load_d;

always @(posedge clk or posedge rst)
    if(rst) load_d <= 0;
    else load_d <= load_new_image;

spike_sorter_paper #(
    .N(N),
    .W(W),
    .GROUP_SIZE(28)
) sorter (
    .clk(clk),
    .rst(rst),
    .load(load_d),
    .start_sort(start_sorting),
    .in_times(bus_in_times),
    .delta_time_out(sorter_delta_t),
    .spike_index(sorter_spike_index),
    .spike_valid(sorter_valid),
    .done(sorter_done)
);



wire fifo_rd_en;
wire fifo_wr_en = sorter_valid & !fifo_full & !sorter_done;

wire [W-1:0] fifo_delta_out;
wire [$clog2(N)-1:0] fifo_index_out;

spike_fifo #(
    .DT_WIDTH(W),
    .INPUTS(N),
    .DEPTH(FIFO_DEPTH)
) event_fifo (
    .clk(clk),
    .rst(rst),
    .wr_en(fifo_wr_en),
    .delta_in(sorter_delta_t),
    .index_in(sorter_spike_index),
    .full(fifo_full),
    .rd_en(fifo_rd_en),
    .delta_out(fifo_delta_out),
    .index_out(fifo_index_out),
    .empty(fifo_empty),
    .count(fifo_count)
);



wire event_done;

layer_control_correct #(
    .DT_WIDTH(W)
) control_unit (
    .clk(clk),
    .rst(rst),
    .delta_time_in(fifo_delta_out),
    .spike_valid_in(!fifo_empty),
    .sorter_done(sorter_done & fifo_empty),
    .load_dt(load_dt),
    .hold_dt(hold_dt),
    .decay_enable(decay_enable),
    .accumulate_enable(accumulate_enable),
    .fire_enable(fire_enable),
    .layer_active(layer_active),
    .layer_done(layer_done),
    .event_done(event_done)
);

assign fifo_rd_en = load_dt & !fifo_empty;



wire [NEURONS*W-1:0] weights_to_neurons;

weights_memory_snn #(
    .INPUTS(N),
    .NEURONS(NEURONS),
    .W(W),
    .PACK(8),
    .DT_W(W)
) weight_mem (
    .clk(clk),
    .rst(rst),
    .read_en(load_dt),
    .delta_time(fifo_delta_out),
    .synapse_idx(fifo_index_out),
    .weights_out(weights_to_neurons),
    .valid_out()
);



delay_block #(.DT_WIDTH(W)) delay_unit (
    .clk(clk),
    .rst(rst),
    .load_dt(load_dt),
    .hold_dt(hold_dt),
    .delta_time_in(fifo_delta_out),
    .delta_time_out(dout_delta)
);



wire [NEURONS-1:0] fire_vector;

genvar i;
generate
for(i=0;i<NEURONS;i=i+1) begin : NEURON_ARRAY

    neuron_core neuron_inst (
        .clk(clk),
        .reset(rst),
        .decay_enable(decay_enable),
        .accumulate_enable(accumulate_enable),
        .fire_enable(fire_enable),
        .w(weights_to_neurons[i*W +: W]),
        .theta(8'sd6),
        .fire(fire_vector[i])
    );

end
endgenerate



wire [NEURONS-1:0] lopd_fifo_dout;
wire lopd_fifo_valid;
wire lopd_done;

reg fire_enable_d;
always @(posedge clk or posedge rst)
    if(rst) fire_enable_d <= 0;
    else fire_enable_d <= fire_enable;

wire fire_vector_wr_en = fire_enable & ~fire_enable_d;

lopd_fifo #(
    .DATA_WIDTH(NEURONS),
    .DEPTH(FIFO_DEPTH)
) fire_event_fifo (
    .clk(clk),
    .rst(rst),
    .wr_en(fire_vector_wr_en),
    .din(fire_vector),
    .full(),
    .rd_en(lopd_done),
    .dout(lopd_fifo_dout),
    .empty(),
    .valid_out(lopd_fifo_valid),
    .count(),
    .wr_ptr(),
    .rd_ptr()
);

lopd_index_generator #(
    .N(NEURONS),
    .IDX_W($clog2(NEURONS)),
    .GROUP(16)
) lopd_unit (
    .clk(clk),
    .rst(rst),
    .load(lopd_fifo_valid),
    .spike_in(lopd_fifo_dout),
    .synapse_idx(lopd_index),
    .valid(lopd_valid),
    .done(lopd_done)
);

endmodule

