module Extend (
    input [24:0] data_in,
    input [2:0] select,
    output reg [31:0] data_out
);

    parameter [2:0] I_TYPE = 0, S_TYPE = 1, B_TYPE = 2, U_TYPE = 3, J_TYPE = 4;

    always @(data_in,select) begin
        case (select)
            I_TYPE: data_out = {{20{data_in[24]}},data_in[24:13]};
            S_TYPE: data_out = {{20{data_in[24]}},data_in[24:18],data_in[4:0]};
            B_TYPE: data_out = {{19{data_in[24]}},data_in[24],data_in[0],data_in[23:18],data_in[4:1],1'b0};
            U_TYPE: data_out = {data_in[24:5],{12'b0}};
            J_TYPE: data_out = {{11{data_in[24]}},data_in[24],data_in[12:5],data_in[13],data_in[23:14],1'b0};
            default: data_out = 32'b0;
        endcase
    end
   
endmodule