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

reg busy_reg;
reg valid_reg;
reg [127:0] output_reg;
reg last=0;

reg [4:0] cycle_count = 0; 
reg [6:0] data_count = 0;
reg [127:0] data_buffer = 0;
reg [127:0] whole_output_reg [0:59];
assign busy = busy_reg;
assign valid = valid_reg;
assign iot_out = output_reg;


always @(posedge clk or posedge rst) begin

    if (rst) begin
        cycle_count <= 0;
        data_count <= 0;
        data_buffer <= 0;
        busy_reg <= 0;
        valid_reg <= 0;
        output_reg <= 0;
    end
    else begin
        if(last) begin
            data_count <= data_count + 1;
            busy_reg <= 1;
            cycle_count <= 0;
            data_buffer <= (data_buffer << 8) | iot_in;
            if (fn_sel == 3'b001) begin
                whole_output_reg[data_count] <= gray_to_bin((data_buffer << 8) | iot_in);
            end 
            else begin
                whole_output_reg[data_count] <= filt((data_buffer << 8) | iot_in);
            end
            last <= 0;
        end
        else if (!busy && in_en) begin
                cycle_count <= cycle_count + 1;
                data_buffer <= (data_buffer << 8) | iot_in;
                if (cycle_count == 0) begin
                end
                if (cycle_count == 14) begin
                    last <= 1;
                    busy_reg <= 1;
                end
        end

        else if (data_count >= 60 && data_count < 120) begin
            valid_reg <= 1;
            data_count <= data_count + 1;
            output_reg <= whole_output_reg[data_count-60];
        end
        else begin
            busy_reg <= 0;
        end
    end
end 

    function [127:0] gray_to_bin(input [127:0] gray);
        integer i;
        begin
            gray_to_bin[127] = gray[127];
            for (i = 126; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray_to_bin[i + 1] ^ gray[i];
            end
        end
    endfunction

    function [127:0] filt(input [127:0] sig);
        integer n;
        reg [15:0] x[0:15];
        reg [15:0] y_temp;
        reg [7:0] y[0:15];
        begin
            for (n = 0; n < 16; n = n + 1) begin
                x[n] = sig[127-8*n -: 8] << 8;
            end
            for (n = 0; n < 16; n = n + 1) begin
                y_temp = 0;  
                y_temp = y_temp + (x[n] >> 2) + (x[n] >> 4);

                if (n > 0) begin
                    y_temp = y_temp + (x[n-1] >> 1) + (x[n-1] >> 4);
                end

                if (n > 1) begin
                    y_temp = y_temp + (x[n-2] >> 3);
                end

                if (y_temp[7] == 1) begin
                    y[n] = (y_temp >> 8) + 1;
                end else begin
                    y[n] = y_temp >> 8;
                end
            end

            filt = 0;
            for (n = 0; n < 16; n = n + 1) begin
                filt = filt | (y[15-n] << (8 * n));
            end
        end
    endfunction

endmodule 

