module lopd_fifo #(
    parameter DATA_WIDTH = 800,
    parameter DEPTH      = 1024,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                   clk,
    input  wire                   rst,

    
    input  wire                   wr_en,
    input  wire [DATA_WIDTH-1:0]  din,
    output wire                   full,

   
    input  wire                   rd_en,
    output reg  [DATA_WIDTH-1:0]  dout,
    output wire                   empty,
    output reg                    valid_out,   

    
    output reg [ADDR_WIDTH:0]     count,
    output reg [ADDR_WIDTH-1:0]   wr_ptr,
    output reg [ADDR_WIDTH-1:0]   rd_ptr
);

    
    (* ram_style = "block" *)
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    
    assign empty = (count == 0);
    assign full  = (count == DEPTH);

   
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
        end 
        else if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr    <= 0;
            dout      <= 0;
            valid_out <= 1'b0;
        end 
        else begin
            valid_out <= 1'b0;  

            
            if (rd_en && !empty) begin
                dout      <= mem[rd_ptr];  
                rd_ptr    <= rd_ptr + 1'b1; 
                valid_out <= 1'b1;         
            end
        end
    end

   
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end 
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1'b1; 
                2'b01: count <= count - 1'b1; 
                2'b11: count <= count;        
                default: count <= count;
            endcase
        end
    end

endmodule