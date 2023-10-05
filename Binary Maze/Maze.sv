module MazeMemory (
    input clock,reset,write,init,
    input [3:0] row,column,
    output data_out[0:3]
);
    reg [0:15] maze[0:15];

    assign data_out[0] = (row > 0 && !maze[row - 1][column]) ? 1 : 0;
    assign data_out[1] = (column < 15 && !maze[row][column + 1]) ? 1 : 0;
    assign data_out[2] = (column > 0 && !maze[row][column - 1]) ? 1 : 0;
    assign data_out[3] = (row < 15 && !maze[row + 1][column]) ? 1 : 0;

    always @(posedge clock, posedge reset) begin
        if(reset || init)
            $readmemh("maze.txt",maze);
        else if(write)
            maze[row][column] <= 1;
    end

endmodule

