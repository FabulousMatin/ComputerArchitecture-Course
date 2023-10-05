module Stack(
  input clock, reset, push, pop, init,
  input [1:0] data_in,
  output [1:0] data_out,
  output reg [1:0] stack [0:255],
  output reg [7:0] top,
  output full, empty
);
  integer i;
  parameter STACK_SIZE = 256; 

  


  assign full = (top == 255);
  assign empty = (top == 0);
  assign data_out = stack[top - 1];

  always @(posedge clock, posedge reset) begin
    if (reset || init) begin
      top <= 8'b0;
      for(i = 0; i < STACK_SIZE; i = i + 1)
        stack[i] <= 2'bz;
    end 
    else if (push && !full) begin
      stack[top] <= data_in;
      top <= top + 1;
    end 
    else if (pop && !empty) begin
      stack[top - 1] <= 2'bz;
      top <= top - 1;
    end
  end

  
endmodule