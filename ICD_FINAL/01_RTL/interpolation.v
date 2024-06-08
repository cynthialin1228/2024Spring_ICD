module interpolation (
    input           clk,
    input           RST,
    input           START,
    input   [5:0]   H0,
    input   [5:0]   V0,
    input   [3:0]   SW,
    input   [3:0]   SH,
    output          REN,
    input   [7:0]   R_DATA,
    output  [11:0]  ADDR,
    output  [7:0]   O_DATA,
    output          O_VALID
);

reg REN_reg, REN_wire, REN_reg_delay1;
reg [11:0] ADDR_reg, ADDR_wire, ADDR_reg_delay1;
reg [7:0] O_DATA_reg, O_DATA_wire;
reg O_VALID_reg, O_VALID_wire;
reg [7:0] img_original [15:0][15:0];
reg [5:0] H0_reg, V0_reg;
reg [3:0] SW_reg, SH_reg;
reg [9:0] count_wire, count_reg;

assign REN = REN_reg;
assign ADDR = ADDR_reg;
assign O_DATA = O_DATA_reg;
assign O_VALID = O_VALID_reg;

integer i;
integer j;
reg [7:0] p_x, p_y;
reg [3:0] x, y, a, b, a1, b1, r1, r2;
reg [7:0] k_a, k_a1;

always @(*) begin
    O_DATA_wire = O_DATA_reg;
    O_VALID_wire = O_VALID_reg;
    count_wire = count_reg;

    if (START) begin
        count_wire = 0;
        H0_reg = H0;
        V0_reg = V0;
        SW_reg = SW;
        SH_reg = SH;
        ADDR_wire = {V0, H0};
        // ADDR_wire[5:0] = H0;
        // ADDR_wire[11:6] = V0;
        REN_wire = 0;
        count_wire = 0;
        O_DATA_wire = 0;
    end
    else if(count_reg == 0) begin
        count_wire = 1;
        REN_wire = 0;
        ADDR_wire[5:0] = H0_reg + 1;
        ADDR_wire[11:6] = V0_reg;
    end
    else if (count_reg < 291) begin
        count_wire = count_reg + 1;
        
        if (!REN_reg_delay1) begin
            a1 = (ADDR_reg_delay1[5:0] - H0_reg);
            b1 = (ADDR_reg_delay1[11:6] - V0_reg);
            img_original[b1][a1] = R_DATA;
        end

        i = (count_reg-1) % 17;
        j = (count_reg-1) / 17;
        p_x = SW_reg * i;
        p_y = SH_reg * j;
        x = p_x[3:0];
        y = p_y[3:0];
        a = p_x[7:4];
        b = p_y[7:4];

        if(i < SW_reg - 1) begin
            if(j<=SH_reg) begin
                ADDR_wire[5:0] = H0_reg + i + 2;
                ADDR_wire[11:6] = V0_reg + j;
                REN_wire = 0;
            end
        end
        else if (i == SW_reg-1) begin
            if(j < SH_reg) begin
                ADDR_wire[5:0] = H0_reg;
                ADDR_wire[11:6] = V0_reg + j + 1;
                REN_wire = 0;
            end
        end
        else if (i == SW_reg) begin
            if(j < SH_reg) begin
                ADDR_wire[5:0] = H0_reg + 1;
                ADDR_wire[11:6] = V0_reg + j + 1;
                REN_wire = 0;
            end
        end
        else begin
            REN_wire = 1;
        end

        if (y != 0) begin
            k_a = (img_original[b][a] * (16 - y) + img_original[b + 1][a] * y) >> 4;
            if (x != 0) begin
                k_a1 = (img_original[b][a + 1] * (16 - y) + img_original[b + 1][a + 1] * y) >> 4;
                k_a = (k_a * (16 - x) + k_a1 * x) >> 4;
            end
        end
        else if (x != 0) begin
            k_a = (img_original[b][a] * (16 - x) + img_original[b][a + 1] * x) >> 4;
        end
        else begin
            k_a = img_original[b][a];
        end
        O_DATA_wire = k_a;
        if(count_reg == 0) begin
            O_VALID_wire = 0;
        end
        else begin
            O_VALID_wire = 1;
        end
    end
    else begin
        O_VALID_wire = 0;
        REN_wire = 1;
    end
end

always @(posedge clk or posedge RST) begin
    if (RST) begin
        O_DATA_reg <= 0;
        O_VALID_reg <= 0;
        count_reg <= 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                img_original[i][j] <= 0;
            end
        end
    end
    else begin
        REN_reg <= REN_wire;
        ADDR_reg <= ADDR_wire;
        ADDR_reg_delay1 <= ADDR_reg;
        REN_reg_delay1 <= REN_reg;
        O_DATA_reg <= O_DATA_wire;
        O_VALID_reg <= O_VALID_wire;
        count_reg <= count_wire;
    end
end

endmodule