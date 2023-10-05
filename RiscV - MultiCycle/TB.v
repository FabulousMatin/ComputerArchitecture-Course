`timescale 1ns/1ns

module TB();


    reg clock, reset;
    RISC_V_MultiCycle rvm(clock,reset);

    always begin
        #5 clock = ~clock;
    end

    initial begin
        #10 reset = 0;
        #10 reset = 1;
        #10 reset = 0;
        #10 clock = 0;
        #3500 $stop;
    end
    
endmodule