module Queue(
  input clock, reset, init,
  input load_queue,
  input deq,
  input [7:0] back,
  input [1:0] data_in[0:255],
  output reg [1:0] data_out,
  output full,empty
);

  parameter QUEUE_SIZE = 256;
  integer i;

  reg [1:0] queue [0:QUEUE_SIZE-1];
  reg [7:0] front;
  
  assign full = ((back + 2) == front);
  assign empty = ((back + 1) == front);

  always @(posedge clock, posedge reset) begin
    if (reset || init) begin
      front <= 0;
      for(i = 0; i < QUEUE_SIZE; i = i + 1)
        queue[i] <= 2'bz;
    end 

    else if (load_queue && !full) begin
      front <= 0;
      for(i = 0; i < QUEUE_SIZE; i = i + 1)
          queue[i] <= data_in[i];   
    end

    else if (deq && !empty) begin
        data_out <= queue[front];
        front <= front + 1;
    end  
  end

endmodule
