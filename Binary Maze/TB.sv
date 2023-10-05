module tb;
    reg clock,reset,start,run;
    wire fail,done;
    reg [1:0] move;

    RatMaze rm(clock,reset,start,run,fail,done,move);
    initial begin
        run = 1;
        reset = 0;
        start = 1;
        #7930 reset = 1;
        #5 reset = 0;
    end
 
    always begin
        #10 clock = 0;
	    #10 clock = 1;
        

    end

endmodule