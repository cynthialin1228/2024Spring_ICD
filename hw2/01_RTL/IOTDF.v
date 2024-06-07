`timescale 1ns/10ps
module IOTDF( clk, rst, in_en, iot_in, fn_sel, busy, valid, iot_out);
input          clk;
input          rst;
input          in_en;
input  [7:0]   iot_in;
input  [2:0]   fn_sel;
output         busy;
output         valid;
output [127:0] iot_out;

reg busy_reg, busy_wire;
reg valid_reg, valid_wire;
reg [127:0] output_reg, output_wire;
reg [7:0] input_buff_reg, input_buff_wire;
reg [3:0] count_wire, count_reg;
reg [7:0] x_reg, x_wire;

assign busy = busy_reg;
assign valid = valid_reg;
assign iot_out = output_reg;

integer i;
integer j;
reg [15:0] y_temp;
always @(*) begin
    output_wire = output_reg;
    count_wire = count_reg;
    busy_wire = busy_reg;
    valid_wire = valid_reg;
    input_buff_wire = iot_in;
    x_wire = input_buff_reg;

    if (fn_sel == 3'b001) begin
        if(count_reg == 0) begin
            output_wire[127] = input_buff_wire[7];
            for (i=6; i>=0; i=i-1) begin
                output_wire[i+120] = output_wire[i+121] ^ input_buff_wire[i];
            end
        end 
        else begin
            j = 120-(count_reg<<3);
            for(i = 7; i >= 0; i = i-1) begin
                output_wire[j+i] = output_wire[j+i+1] ^ input_buff_wire[i];
            end
        end
    end
    else begin
        y_temp = (input_buff_wire << 6) + (input_buff_wire << 4);
        if (count_reg > 0) begin
            y_temp = y_temp + (x_wire << 7) + (x_wire << 4);
        end
        if (count_reg > 1) begin
            y_temp = y_temp + (x_reg << 5);
        end
        output_wire[127-8*count_reg -: 8] = (y_temp >> 8) + y_temp[7];
    end
    
    if(in_en) begin
        count_wire = count_reg + 1;
        valid_wire = 0;
        if(count_reg == 14) begin
            busy_wire = 1;
        end
        else if (count_reg == 15) begin
            busy_wire = 0;
            valid_wire = 1;
        end
    end
    else valid_wire = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count_reg <= 0;
        busy_reg <= 0;
        valid_reg <= 0;
        output_reg <= 0;
        x_reg <= 0;
    end
    else begin
        count_reg <= count_wire;
        busy_reg <= busy_wire;
        valid_reg <= valid_wire;
        output_reg <= output_wire;
        input_buff_reg <= input_buff_wire;
        x_reg <= x_wire;
    end 
end 

endmodule 