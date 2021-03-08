`timescale 1ns / 1ps

module testbench(
    );
    
    // Inputs
    reg clk;
    reg reset;
    reg [31:0] instruction_from_testbench;
    reg [63:0] datamemreaddata_to_mux3;
    reg [63:0] pc_to_readaddress;
    reg [63:0] mainalu_to_datamemreaddata_transfer;
    reg [63:0] readdata2_to_datamemwritedata_transfer;
    reg memread_transfer;
    reg memwrite_transfer;
    wire [63:0] pcoutput_from_cpu;
    wire memread;
    wire memwrite;
    wire [63:0] mainalu_to_datamemreaddata;
    wire [63:0] readdata2_to_datamemwritedata;
    wire [31:0] instruction_from_testbench_transfer;
    wire [63:0]datamemreaddata_to_mux3_transfer;
  
    CPU CPU_Inst(
    .clk(clk),
    .reset(reset),
    .instruction_from_testbench(instruction_from_testbench),
    .datamemreaddata_to_mux3(datamemreaddata_to_mux3),
    .pcoutput_to_testbench(pcoutput_from_cpu),
    .mainalu_to_datamemreaddata(mainalu_to_datamemreaddata),
    .readdata2_to_datamemwritedata(readdata2_to_datamemwritedata),
    .memwrite(memwrite),
    .memread(memread)
    );
    initial begin
    clk = 0;
    reset = 1;
    instruction_from_testbench = 0;
  
    
    end
    always@(*)begin
    mainalu_to_datamemreaddata_transfer = mainalu_to_datamemreaddata;
    readdata2_to_datamemwritedata_transfer=readdata2_to_datamemwritedata;
    memwrite_transfer= memwrite;
    memread_transfer=memread;
    end
    
    datamemory datamem_inst
    (.clk(clk), .main_aluresult(mainalu_to_datamemreaddata_transfer),.datamem_writedata(readdata2_to_datamemwritedata_transfer),.memwrite(memwrite_transfer),.memread(memread_transfer),.datamem_readdata(datamemreaddata_to_mux3_transfer));
    always@(posedge clk)begin
    datamemreaddata_to_mux3 = datamemreaddata_to_mux3_transfer;
    end
    always@(*)begin
    pc_to_readaddress=pcoutput_from_cpu;
    end
  
    instructionmemory
    Instrucmem_inst (.clk(clk), .pc(pc_to_readaddress),.instruction31_0(instruction_from_testbench_transfer));
    always@(posedge clk)begin
    instruction_from_testbench=instruction_from_testbench_transfer;
    
    end
    always @ (clk) begin
    #1;
    clk <= ~clk;
    reset = 1'b0;
    end
    endmodule