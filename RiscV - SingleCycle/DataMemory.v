module DataMemory (
    input clock, writeEn, reset,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] data_mem [16383:0];

    integer i;
    initial begin
        $readmemh("DataMemory.txt", data_mem);
    end
    
    assign read_data = data_mem[address >> 2];

    always @(posedge clock, posedge reset) begin
        if(reset) 
            $readmemh("DataMemory.txt", data_mem);
        

        else if(writeEn)
            data_mem[address >> 2] = write_data;
    end


    always @(posedge clock) begin
        if(writeEn)
            $writememh("DataMemory.txt", data_mem);
    end

endmodule