`timescale 1ns / 1ps

//KN = 256
//K = 2
//N = 128

function set_counter(
input index_loc,
input [6:0] N,
input [23:0] cache [57961:0]
);

integer inter_set_cntr;
inter_set_cntr = cache[index_loc][N+1];

    if(inter_set_cntr == N)
        begin
            inter_set_cntr = 1;
        end
    else
        begin
            inter_set_cntr += 1;
        end

endfunction

function set_counter_2(
input index_loc,
input [6:0] N,
input [23:0] cache [58596:0]
);

integer inter_set_cntr;
inter_set_cntr = cache[index_loc][N+1];

    if(inter_set_cntr == N)
        begin
            inter_set_cntr = 1;
        end
    else
        begin
            inter_set_cntr += 1;
        end

endfunction

module cache_main(
input clk,
input reset,
input [6:0] KN,
input [6:0] K,
input [6:0] N,
input [23:0] file1 [57961:0],
input [23:0] file2 [58596:0],
input trace1,
input trace2,
output reg [6:0] pass_1,
output reg [6:0] pass_2
    );
    reg [23:0] data_1 [57961:0];
    reg [23:0] data_2 [58596:0];
    reg [23:0] reordered_data_1 [57961:0];
    reg [23:0] reordered_data_2 [58596:0];
    reg [2:0] bit_part;
    integer hit;
    integer miss;
    integer i;
    integer k;
    integer g;
    integer h;
    integer j;
    integer a;
    integer b;
    integer k_inner;
    integer set_cntr = 1;
    integer hit_flag;
    integer entry;
    integer internal_1 = 0; //MISS
    integer internal_2 = 0; //HIT
    
    always@(*)begin
    for(int q = 0; q < 57961; q = q + 1)
    begin
    data_1[q] = file1[q];
    end
    for(int o = 0; o < 58596; o = o + 1)
    begin
    data_2[o] = file2[o];
    end
    end
 

    always @(trace1) begin
    for(a = 0; a < 57961; a = a + 1)
    begin
   // reordered_data_1[a][23:0] = data_1[a][23:0];
   // reordered_data_1[a][23:0] = data_1[temp][23:0];
   // reordered_data_1[a][23:0] = data_1[a][23:0];
   
    bit_part[0] = (data_1[a] && 'h0000FF) << 16;
    bit_part[1] = ((data_1[a] && 'h00FF00) >> 8) << 8;
    bit_part[2] = (data_1[a] && 'hFF0000) >> 16;
    
    reordered_data_1[a][23:16] = bit_part[2];
    reordered_data_1[a][15:8] = bit_part[1];
    reordered_data_1[a][7:0] = bit_part[0];
    
    end
    
    for(i = 0; i < 57961; i = i + 1)
        begin
            for(h = 0; h < K; h = h + 1)
                begin
                    if(reordered_data_1[h][0] == i[21:20])
                        begin
                            k_inner = 1;
                            hit_flag = 0;
                            for(j = 0; j < N+1; j = j + 1)
                                begin
                                    if(reordered_data_1[h][k] == entry[20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(reordered_data_1[h][set_cntr] == 0)
                                begin
                                    reordered_data_1[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter(h, N, reordered_data_1);
                                    reordered_data_1[h][N+1] = set_cntr;
                                end
                             else if(reordered_data_1[h][set_cntr] != 0 && hit_flag == 1)
                                begin
                                    internal_2 += 1;
                                    set_cntr = set_counter(h, N, reordered_data_1);
                                    reordered_data_1[h][N+1] = set_cntr;
                                end
                             else
                                begin
                                    reordered_data_1[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter(h, N, reordered_data_1);
                                    reordered_data_1[h][N+1] = set_cntr;
                                end   
                        end 
                end
        end
    end
    
    always @(trace2) begin
    for(b = 0; b < 58596; b = b + 1)
    begin
    reordered_data_2 [b] = data_2 [b + 2];
    reordered_data_2 [b + 1] = data_2 [b + 1];
    reordered_data_2 [b + 2] = data_2 [b];
    end
    
        for(k = 0; k < 58596; k = i + 1)
            for(h = 0; h < K; h = h + 1)
                begin
                    if(reordered_data_2[h][0] == entry[21:20])
                        begin
                            k_inner = 1;
                            hit_flag = 0;
                            for(j = 0; j < N+1; j = j + 1)
                                begin
                                    if(reordered_data_2[h][k] == entry[20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(reordered_data_2[h][set_cntr] == 0)
                                begin
                                    reordered_data_2[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter_2(h, N, reordered_data_2);
                                    reordered_data_2[h][N+1] = set_cntr;
                                end
                             else if(reordered_data_2[h][set_cntr] != 0 && hit_flag == 1)
                                begin
                                    internal_2 += 1;
                                    set_cntr = set_counter_2(h, N, reordered_data_2);
                                    reordered_data_2[h][N+1] = set_cntr;
                                end
                             else
                                begin
                                    reordered_data_2[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter_2(h, N, reordered_data_2);
                                    reordered_data_2[h][N+1] = set_cntr;
                                end   
                        end 
                end
     end
     always @(posedge clk)begin
    pass_1 = internal_1;
    pass_2 = internal_2;
    end
endmodule
