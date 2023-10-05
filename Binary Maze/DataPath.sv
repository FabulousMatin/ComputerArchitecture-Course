module DataPath ( 
    input clock,reset,push,pop,init,load_queue,deq,
    input [1:0] next_move,
    output stack_empty,queue_empty,
    output reg [1:0] move,
    output reg [1:0] prev_move,
    output reg [3:0] row, column
);
    parameter [2:0] UP = 0, RIGHT = 1, LEFT = 2, DOWN = 3;
    integer i;

    wire stack_full,queue_full;     
    reg [1:0] moves[0:255];
    reg [7:0] total_moves;
    Stack s(clock,reset,push,pop,init,next_move,prev_move,moves,total_moves,stack_full,stack_empty);
    Queue q(clock,reset,init,load_queue,deq,total_moves,moves,move,queue_full,queue_empty);

    always @(posedge clock) begin
        if(init) begin
            row = 4'b0;
            column = 4'b0;
        end
    end

    always @(posedge clock) begin
        
        if(next_move == UP) begin
            row <= row - 1;
        end else if(next_move == RIGHT) begin
            column <= column + 1;
        end else if(next_move == LEFT) begin
            column <= column - 1;
        end else if(next_move == DOWN) begin
            row <= row + 1;
        end

    end
endmodule