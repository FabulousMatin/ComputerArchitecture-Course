`timescale 1ns/1ns

module TB();


    reg clock, reset;
    RISC_V_SingleCycle rvs(clock,reset);

    always begin
        #5 clock = ~clock;
    end

    initial begin
        #10 reset = 0;
        #10 reset = 1;
        #10 reset = 0;
        #10 clock = 0;
        #1500 $stop;
    end
    
endmodule