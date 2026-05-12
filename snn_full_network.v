module snn_full_network #(    

    parameter IMG_N      = 784,
    parameter H1_N       = 800,
    parameter H2_N       = 512,
    parameter H3_N       = 256,
    parameter OUT_N      = 10,

    parameter W          = 8,
    parameter NUM_IMAGES = 1,
    parameter FIFO_DEPTH = 1024

)(
    input clk,
    input rst,

    input load_new_image,
    input start_sorting,
    input [(NUM_IMAGES>1 ? $clog2(NUM_IMAGES):1)-1:0] img_idx,

    output [$clog2(OUT_N)-1:0] predicted_digit
);



(* keep_hierarchy = "yes" *)
snn_system_top_3 #(
    .N(IMG_N),
    .W(W),
    .NUM_IMAGES(NUM_IMAGES),
    .FIFO_DEPTH(FIFO_DEPTH),
    .NEURONS(H1_N)
) layer1 (
    .clk(clk),
    .rst(rst),
    .load_new_image(load_new_image),
    .start_sorting(start_sorting),
    .img_idx(img_idx),

    .dout_delta(),
    .load_dt(),
    .hold_dt(),
    .decay_enable(),
    .accumulate_enable(),
    .fire_enable(),

    .lopd_index(),
    .lopd_valid(),
    .layer_active(),
    .layer_done(),
    .fifo_empty(),
    .fifo_full(),
    .fifo_count()
);

(* keep_hierarchy = "yes" *)
snn_hidden_layer2_top #(
    .INPUTS(H1_N),
    .NEURONS(H2_N),
    .W(W),
    .FIFO_DEPTH(FIFO_DEPTH)
) layer2 (
    .clk(clk),
    .rst(rst),
    .delta_in(0),
    .index_in(0),
    .spike_valid(0),
    .layer1_done(0),
    .dout_delta(),
    .lopd_index(),
    .lopd_valid(),
    .layer_active(),
    .layer_done()
);

(* keep_hierarchy = "yes" *)
snn_hidden_layer3_top #(
    .INPUTS(H2_N),
    .NEURONS(H3_N),
    .W(W),
    .FIFO_DEPTH(FIFO_DEPTH)
) layer3 (
    .clk(clk),
    .rst(rst),
    .delta_in(0),
    .index_in(0),
    .spike_valid(0),
    .layer2_done(0),
    .dout_delta(),
    .lopd_index(),
    .lopd_valid(),
    .layer_active(),
    .layer_done()
);

(* keep_hierarchy = "yes" *)
snn_output_layer_top #(
    .INPUTS(H3_N),
    .NEURONS(OUT_N),
    .W(W),
    .FIFO_DEPTH(FIFO_DEPTH)
) output_layer (
    .clk(clk),
    .rst(rst),
    .delta_in(0),
    .index_in(0),
    .spike_valid(0),
    .layer3_done(0),
    .predicted_digit(predicted_digit)
);

endmodule