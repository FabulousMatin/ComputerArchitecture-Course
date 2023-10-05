module RatMaze (
    input clock,reset,start,run,
    output reg 	fail,done,
    output reg [1:0] move
);
    
    
    reg [3:0] row = 4'b0, column = 4'b0;
    reg [1:0] next_move, prev_move;
    reg allowed_moves[0:3];
    reg init,push,pop,load_queue,deq,stack_empty,queue_empty,write;

    MazeMemory mm(clock,reset,write,init,row,column,allowed_moves);
    DataPath dp(clock,reset,push,pop,init,load_queue,deq,next_move,stack_empty,queue_empty,move,prev_move,row,column);
    Controller ctrl(clock,reset,start,run,stack_empty,queue_empty,allowed_moves,row,column,prev_move,next_move,push,pop,fail,done,load_queue,deq,init,write);

    
endmodule