module Memory (
    input clock, writeEn, reset,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] mem [16383:0];

    assign read_data = mem[address >> 2];

    initial begin
        $readmemh("Memory.txt", mem);
    end

    always @(posedge clock) begin
        if(reset)
            $readmemh("Memory.txt", mem);
        else if(writeEn) begin
            mem[address >> 2] = write_data;
            $writememh("Memory.txt", mem);
        end
        
end
endmodule