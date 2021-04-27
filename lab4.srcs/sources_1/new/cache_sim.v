`timescale 1ns / 1ps

//KN = 256
//K = 2
//N = 128

function set_counter(
input index_loc,
input [6:0] N,
input [6:0] cache [6:0]
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
input [6:0] file [0:6],
input trace1,
input trace2,
output reg [6:0] pass_1,
output reg [6:0] pass_2
    );
    reg [6:0] data [0:6];
    reg [6:0] reordered_data [0:6];
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
    
    
    
    

    always @(trace1) begin
    for(a = 0; a < 57961; a = a + 1)
    begin
    reordered_data [a] = data [a + 2];
    reordered_data [a + 1] = data [a + 1];
    reordered_data [a + 2] = data [a];
    end
    
    for(i = 0; i < 57961; i = i + 1)
        begin
            for(h = 0; h < K; h = h + 1)
                begin
                    if(data[h][0] == i[21:20])
                        begin
                            k_inner = 1;
                            hit_flag = 0;
                            for(j = 0; j < N+1; j = j + 1)
                                begin
                                    if(data[h][k] == entry[20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(data[h][set_cntr] == 0)
                                begin
                                    data[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter(h, N, data);
                                    data[h][N+1] = set_cntr;
                                end
                             else if(data[h][set_cntr] != 0 && hit_flag == 1)
                                begin
                                    internal_2 += 1;
                                    set_cntr = set_counter(h, N, data);
                                    data[h][N+1] = set_cntr;
                                end
                             else
                                begin
                                    data[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter(h, N, data);
                                    data[h][N+1] = set_cntr;
                                end   
                        end 
                end
        end
    end
    
    always @(trace2) begin
    for(b = 0; b < 58596; b = b + 1)
    begin
    reordered_data [b] = data [b + 2];
    reordered_data [b + 1] = data [b + 1];
    reordered_data [b + 2] = data [b];
    end
    
        for(k = 0; k < 58596; k = i + 1)
            for(h = 0; h < K; h = h + 1)
                begin
                    if(data[h][0] == entry[21:20])
                        begin
                            k_inner = 1;
                            hit_flag = 0;
                            for(j = 0; j < N+1; j = j + 1)
                                begin
                                    if(data[h][k] == entry[20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(data[h][set_cntr] == 0)
                                begin
                                    data[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter(h, N, data);
                                    data[h][N+1] = set_cntr;
                                end
                             else if(data[h][set_cntr] != 0 && hit_flag == 1)
                                begin
                                    internal_2 += 1;
                                    set_cntr = set_counter(h, N, data);
                                    data[h][N+1] = set_cntr;
                                end
                             else
                                begin
                                    data[h][set_cntr] = entry[20:0];
                                    internal_1 += 1;
                                    set_cntr = set_counter(h, N, data);
                                    data[h][N+1] = set_cntr;
                                end   
                        end 
                end
     end
     always @(posedge clk)begin
    pass_1 = internal_1;
    pass_2 = internal_2;
    end
endmodule
