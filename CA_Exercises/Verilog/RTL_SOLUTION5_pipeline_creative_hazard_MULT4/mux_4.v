module mux_4 
  #(
   parameter integer DATA_W = 16
   )(
      input  wire [DATA_W-1:0] input_a,
      input  wire [DATA_W-1:0] input_b,
      input  wire [DATA_W-1:0] input_c,
      input  wire [DATA_W-1:0] input_d,
      input  wire [1:0]        select_a,
      output reg  [DATA_W-1:0] mux_out
   );
   wire[DATA_W:0] temp_a, temp_b;

   mux_2 #(.DATA_W(DATA_W)) A(input_b, input_a, select_a[0], temp_a);
   mux_2 #(.DATA_W(DATA_W)) B(input_d, input_c, select_a[0], temp_b);
   mux_2 #(.DATA_W(DATA_W)) C(temp_b, temp_a, select_a[1], mux_out);
endmodule

