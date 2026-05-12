module neuron_core (
    input  wire clk,
    input  wire reset,

    
    input  wire decay_enable,
    input  wire accumulate_enable,
    input  wire fire_enable,

    input  wire signed [7:0] w,
    input  wire signed [7:0] theta,

    output reg  fire
);

    
    reg signed [7:0] P;
    reg signed [7:0] next_P;

    
    wire signed [7:0] decay_val;
    wire signed [7:0] accum_val;
    wire signed [7:0] sub_val;

    assign decay_val = P >>> 1;
    assign accum_val = P + w;
    assign sub_val   = P - theta;

    always @(*) begin
        
        next_P = P;
        fire   = 1'b0;

        
        if (decay_enable) begin
            if (decay_val < 0)
                next_P = 8'sd0;
            else
                next_P = decay_val;
        end

       
        else if (accumulate_enable) begin
            if (accum_val < 0)
                next_P = 8'sd0;
            else
                next_P = accum_val;
        end

        
        else if (fire_enable) begin
            if (P >= theta) begin
                fire = 1'b1;

                if (sub_val < 0)
                    next_P = 8'sd0;
                else
                    next_P = sub_val;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            P <= 8'sd0;
        else
            P <= next_P;
    end

endmodule