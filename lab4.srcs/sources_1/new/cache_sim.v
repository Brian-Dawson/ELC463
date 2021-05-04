`timescale 1ns / 1ps

//KN = 256
//K = 2
//N = 128


module cache_main(
input clk,
input reset,
input [8:0] KN,
input [7:0] K,
input [7:0] N,
input [23:0] file1 [57961:0],
input [23:0] file2 [58596:0],
output reg [31:0] pass_1,
output reg [31:0] pass_2,
output reg [31:0] pass_3, 
output reg [31:0] pass_4
    );
    reg [23:0] data_1 [57961:0];
    reg [23:0] data_2 [58596:0];
    reg [23:0] cache[128:0][1:0];
    reg [23:0] cache_2[128:0][1:0];
    reg [23:0] cache_write;
    reg [23:0] cache_write2;
    integer i = 0;
    integer k = 0; 
    integer g = 0;
    integer h = 0;
    integer j = 0;
    integer a = 0;
    integer z = 0;
    reg [7:0] set_cntr = 0;
    reg [7:0] set_cntr2 = 0;
    integer hit_flag = 0;
    integer hit_flag_2 = 0;
    integer temp = 0;
    integer temp_2 = 0;
    
    reg [31:0] internal_1 = 0; //MISS TRACE 1
    reg [31:0] internal_2 = 0; //HIT TRACE 1
    reg [31:0] internal_3 = 0;
    reg [31:0] internal_4 = 0;
    
    
    always @(posedge reset) begin
    for(int q = 0; q < (57962); q = q + 1)
    begin
    data_1[q] = file1[q];
    end
    for(int o = 0; o < (58597); o = o + 1)
    begin
    data_2[o] = file2[o];
    end
    for(i = 0; i < 129; i = i + 1) //pre-populating cache with 0s
    begin
        for(z = 0; z < 2; z = z + 1)
        begin
            cache[i][z] = 0;
            cache_2[i][z] = 0;
        end
    
    end
    
    end

 
    always @(posedge clk)begin
    
    if(i < 57961)
        begin
            h = 0;
            while(h < 2)
                begin
                    if((cache[0][h][3] == data_1[i][3]) && temp < 57961) //if idx of trace data == index of cache
                        begin
                            hit_flag = 0;
                            for(j = 0; j < N; j = j + 1)//setting hit flag
                                begin
                                    if(cache[j][h][20:0] == data_1[i][20:0])
                                        begin
                                            hit_flag = 1;
                                        end
                                end
                            if(cache[set_cntr][h] == 0) //if space is empty
                                begin
                                    cache[set_cntr][h][20:0] = data_1[i][20:0]; //fill empty space with tag
                                    internal_1 += 1; //miss 
                                    cache_write = cache[set_cntr][h];
                                    set_cntr = cache[N][h]; 
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr = 0;
                                            end
                                        else
                                            begin
                                                set_cntr += 1;
                                            end
                                    
                                    cache[N][h] = set_cntr;
                                end
                             else if((cache[set_cntr][h] != 0) && (hit_flag == 1))//not empty and tag is same
                                begin
                                    internal_2 += 1; //hit
                                    cache_write = cache[set_cntr][h];
                                    set_cntr = cache[N][h];
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr = 0;
                                            end
                                        else
                                            begin
                                                set_cntr += 1;
                                            end
                                    cache[N][h] = set_cntr;
                                end
                             else //not empty and not same tag
                                begin
                                    cache[set_cntr][h][20:0] = data_1[i][20:0];
                                    internal_1 += 1; //miss
                                     cache_write = cache[set_cntr][h];
                                    set_cntr = cache[N][h];
                                        if(set_cntr == N-1)
                                            begin
                                                set_cntr = 0;
                                            end
                                        else
                                            begin
                                                set_cntr += 1;
                                            end
                                    cache[N][h] = set_cntr;
                                end   
                                temp = temp + 1;
                        end 
                  h = h + 1;       
            end
    end

    i = i + 1;
    
    if(a < 58597)
        begin
            k = 0;
            while(k < 2)
                begin
                    if((cache_2[0][k][3] == data_2[a][3]) && temp_2 < 58597) //if idx of trace data == index of cache
                        begin
                            hit_flag_2 = 0;
                            for(g = 0; g < N; g = g + 1)//setting hit flag
                                begin
                                    if(cache_2[g][k][20:0] == data_2[a][20:0])
                                        begin
                                            hit_flag_2 = 1;
                                        end
                                end
                            if(cache_2[set_cntr2][k] == 0) //if space is empty
                                begin
                                    cache_2[set_cntr2][k][20:0] = data_2[a][20:0]; //fill empty space with tag
                                    internal_3 += 1; //miss 
                                    cache_write2 = cache_2[set_cntr2][k];
                                    set_cntr2 = cache_2[N][k]; 
                                        if(set_cntr2 == N-1)
                                            begin
                                                set_cntr2 = 0;
                                            end
                                        else
                                            begin
                                                set_cntr2 += 1;
                                            end
                                    
                                    cache_2[N][k] = set_cntr2;
                                end
                             else if((cache_2[set_cntr2][k] != 0) && (hit_flag_2 == 1))//not empty and tag is same
                                begin
                                    internal_4 += 1; //hit
                                    cache_write2 = cache_2[set_cntr2][k];
                                    set_cntr2 = cache_2[N][k];
                                        if(set_cntr2 == N-1)
                                            begin
                                                set_cntr2 = 0;
                                            end
                                        else
                                            begin
                                                set_cntr2 += 1;
                                            end
                                    cache_2[N][k] = set_cntr2;
                                end
                             else //not empty and not same tag
                                begin
                                    cache_2[set_cntr2][k][20:0] = data_2[a][20:0];
                                    internal_3 += 1; //miss
                                     cache_write2 = cache_2[set_cntr2][k];
                                    set_cntr2 = cache_2[N][k];
                                        if(set_cntr2 == N-1)
                                            begin
                                                set_cntr2 = 0;
                                            end
                                        else
                                            begin
                                                set_cntr2 += 1;
                                            end
                                    cache_2[N][k] = set_cntr2;
                                end   
                                temp_2 = temp_2 + 1;
                        end 
                  k = k + 1;       
            end
    end

    a = a + 1;
    
    end

     always @(posedge clk)begin
    pass_1 = internal_1;
    pass_2 = internal_2;
    pass_3 = internal_3;
    pass_4 = internal_4;
    end
endmodule
