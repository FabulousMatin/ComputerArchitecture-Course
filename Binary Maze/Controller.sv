module Controller (
    input clock,reset,start,run,stack_empty,queue_empty,
    input is_allowed[0:3],
    input [3:0] row, column,
    input [1:0] prev_move,
    output reg [1:0] next_move, 
    output reg push,pop,fail,done,load_queue,deq,init,write
);
    parameter [4:0] IDLE = 0, INIT = 1, PUSH = 2, POP = 3, FAIL = 4, DONE = 5, LOAD_ANS = 6, RUN = 7, WRITE = 8;
    parameter [2:0] UP = 0, RIGHT = 1, LEFT = 2, DOWN = 3;
    integer i;

    reg goal;
    assign goal = (row == 4'b1111) & (column == 4'b1111);
    reg [4:0] pstate, nstate;


    always @(pstate,row,column,stack_empty,queue_empty) begin
        $display("%d - %d",row,column);
        $display("%d", pstate);
        {push,pop,fail,done,load_queue,deq,init,write} = 8'b0;
        next_move = 2'bz;

        case (pstate)
            IDLE: begin
                nstate = start ? INIT : IDLE;
            end
            INIT: begin
                nstate = WRITE;
                init = 1;
            end
            WRITE: begin
                nstate = PUSH;
                write = 1;
            end
            PUSH: begin
		    
                if(goal)
                    nstate = DONE;
                else begin

                    if(is_allowed[UP]) begin
                        next_move = UP;
                        nstate = WRITE;
                        push = 1;
                    end 
                    else if(is_allowed[RIGHT]) begin
                        next_move = RIGHT;
                        nstate = WRITE;
                        push = 1;
                    end 
                    else if(is_allowed[LEFT]) begin
                        next_move = LEFT;
                        nstate = WRITE;
                        push = 1;
                    end
                    else if(is_allowed[DOWN]) begin
                        next_move = DOWN;
                        nstate = WRITE;
                        push = 1;
                    end
                    else begin
                        nstate = POP;
                    end 
                end
            end

            POP: begin
                if (stack_empty)
                    nstate = FAIL;
                else begin
                    pop = 1;
                    nstate = PUSH;
                    if(prev_move == UP) begin
                        next_move = DOWN;
                    end else if(prev_move == RIGHT) begin
                        next_move = LEFT;
                    end else if(prev_move == LEFT) begin
                        next_move = RIGHT;
                    end else if(prev_move == DOWN) begin
                        next_move = UP;
                    end 
                end
            end 

            FAIL: begin
                fail = 1;
                nstate = FAIL;
            end

            DONE: begin
                done = 1;
                nstate = run ? LOAD_ANS : DONE;
            end

            LOAD_ANS: begin
                load_queue = 1;
                nstate = RUN;
            end

            RUN: begin
                deq = 1;
                nstate = queue_empty ? DONE : RUN; 
            end

            default: nstate = IDLE;
        endcase
    end  


    always @(posedge clock, posedge reset) begin
        if(reset) 
            pstate <= IDLE;
        else
            pstate <= nstate;
    end
    
    


endmodule