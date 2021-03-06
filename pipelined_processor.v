
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2021 02:26:38 PM
// Design Name: 
// Module Name: pipelined_processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


    module CPU(
            input clk,
            input reset,
            input [31:0] instruction_from_testbench,
            input [63:0] datamemreaddata_to_mux3,
            output reg [63:0] pcoutput_to_testbench,
            output reg [63:0] mainalu_to_datamemreaddata,
            output reg [63:0] readdata2_to_datamemwritedata,
            output reg memwrite,memread
                );
            
/*            reg [10:0] instruction31_21_to_control;
            reg [10:0] instruction31_21_to_alu;
            reg [31:0] instruction31_0_to_signextend;
            reg [4:0] instruction20_16_to_mux1;
            reg [4:0] instruction9_5_to_readregaddr1;
            reg [4:0] instruction4_0_to_mux1;
            reg [4:0] instruction4_0_to_writeregaddr;*/
            
            //Control lines from beginning to IFID and inbetween stuff
            reg[31:0] ins_mem_31_to_0_from_ins_to_IFID;
            wire [63:0] pc_from_pc_to_IFID;
            wire [63:0] mux4_to_pcinput;
            
            //Control lines from IFID to IDEX and inbetween stuff
            
            wire [63:0] pc_from_IFID_to_IDEX;
            wire [31:0] ins_mem_31_to_0_from_IFID_to_all_things;
            wire [1:0] control_ALU_op_from_IFID;
            wire control_ALU_src_from_IFID;
            wire control_Branch_zero_from_IFID;
            wire control_Memwrite_from_IFID;
            wire control_Memread__from_IFID;
            wire control_MemToReg_from_IFID;
            wire control_RegWrite_from_IFID;
            wire [4:0] mux1_to_read_reg_2;
            wire [63:0] mux3_to_write_data;
            wire [63:0] signextend_to_IDEX;
            wire [63:0] reg_out_1_to_IDEX;
            wire [63:0] reg_out_2_to_IDEX;
            
            //Control lines from IDEX to EXMEM and inbetween stuff
            wire [1:0] control_ALU_op_from_IDEX;
            wire control_ALU_src_from_IDEX;
            wire control_Branch_zero_from_IDEX;
            wire control_Memwrite_from_IDEX;
            wire control_Memread__from_IDEX;
            wire control_MemToReg_from_IDEX;
            wire control_RegWrite_from_IDEX;
            wire [3:0] alu_control_to_alu;
            wire [63:0] pc_from_IDEX_to_add;
            wire [63:0] reg_out_1_from_IDEX_to_alu;
            wire [63:0] reg_out_2_from_IDEX_to_mux2_and_EXMEM;
            wire [63:0] signextend_from_IDEX_to_add_and_mux2;
            wire [63:0] mux2_to_alu;
            wire [63:0] add_to_EXMEM;
            wire [63:0] alu_to_EXMEM;
            wire [63:0] write_reg_IDEX_to_EXMEM;
            wire ALUZero_to_EXMEM;
            wire [31:0] IDEX_to_ALUControl;
            wire [31:0] IDEX_to_EXMEM;
            
            //Control lines from EXMEM to MEMWB and inbetween stuff
            wire [63:0] add_from_EXMEM_to_mux4;
            wire [63:0] alu_result_to_data_mem_and_MEMWB;
            wire [63:0] reg_2_from_EXMEM_to_datamem;
            wire [63:0] data_mem_to_MEMWB;
            wire [63:0] ins_from_EXMEM_to_MEMWB;
            wire control_Memwrite_from_EXMEM;
            wire control_Memread_from_EXMEM;
            wire control_branch_zero_from_EXMEM;
            wire ALUZero_from_EXMEM_to_branch;
            
            wire PCSrc;
            assign PCSrc = (ALUZero_from_EXMEM_to_branch & control_branch_zero_from_EXMEM);
            
            wire control_MemToReg_from_EXMEM_to_MEMWB;
            wire control_RegWrite_from_EXMEM_to_MEMWB;
            
            //Control lines from MEMWB to beginning
            wire control_MemToReg_from_MEMWB_to_mux3;
            wire control_RegWrite_from_MEMWB_to_registers;
            wire [63:0] MEMWB_to_write_reg;
            wire [63:0] alu_result_from_MEMWB_to_mux3;
            wire [63:0] datamem_from_MEMWB_to_mux3;
            wire [63:0] mux3_to_write_data;
            
            //Control lines
/*            wire reg2loc_to_mux1;
            wire [1:0] aluop_to_alucontrol;
            wire memtoreg_to_mux3;
            wire alusrc_to_mux2;
            wire regwrite_to_regfile;
            wire memread_to_datamem;
            wire memwrite_to_datamem;*/
            
            // Mux 4 wires
           /* wire [63:0] mux4_to_pcinput;
            wire [63:0] pcalu_to_mux4;
            wire [63:0] pcoutput_to_shiftalu;
            wire shiftalu_to_mux4;
            wire cbz_to_mux4;
            wire [63:0] signextended_to_shiftalu;
            wire branch_to_cbz;
            wire andout;
            wire mainaluzero_to_cbz;
            wire [63:0] mainalu_result;
            wire [4:0] mux1_to_readregaddr2;
            wire [63:0] readdata1_to_mainalu;
            wire [63:0] readdata2_to_mux2;
            wire [63:0] signextended_to_mux2;
            wire [63:0] mux2_to_mainalu;
            wire [3:0] alu_to_mainalu;
            wire [63:0] mainalu_to_mux3;
            wire [63:0] mux3_to_writedata;*/
            
            //Branch AND
            
//            assign andout = (branch_to_cbz & mainaluzero_to_cbz);
            
            //Testbench to instruction
            
/*            always @ (posedge clk) begin
            instruction31_21_to_control = instruction_from_testbench[31:21];
            instruction31_21_to_alu = instruction_from_testbench[31:21];
            instruction31_0_to_signextend = instruction_from_testbench;
            instruction20_16_to_mux1 = instruction_from_testbench[20:16];
            instruction9_5_to_readregaddr1 = instruction_from_testbench[9:5];
            instruction4_0_to_mux1 = instruction_from_testbench[4:0];
            instruction4_0_to_writeregaddr = instruction_from_testbench[4:0];
            end*/

              always @ (posedge clk) begin
              ins_mem_31_to_0_from_ins_to_IFID = instruction_from_testbench;
              end
            
            //Add Instantiation
            add add_inst(.clk(clk), .signextend_in(signextend_from_IDEX_to_add_and_mux2), .pc_in(pc_from_IDEX_to_add), .add_out(add_to_EXMEM));
            //IFID Instantiation
            IFID IFID_inst(.clk(clk), .instruction31_0_in(ins_mem_31_to_0_from_ins_to_IFID), .pc_in(pc_from_pc_to_IFID), .instruction31_0_out(ins_mem_31_to_0_from_IFID_to_all_things), .pc_out(pc_from_IFID_to_IDEX));
            
            //IDEX Instantiation
            IDEX IDEX_inst(.clk(clk), .pc_in(pc_from_IFID_to_IDEX), .read_data_1_in(reg_out_1_to_IDEX), .read_data_2_in(reg_out_2_to_IDEX), .sign_extend_in(signextend_to_IDEX), 
            .instruction_31_to_21_in(ins_mem_31_to_0_from_IFID_to_all_things[31:21]), .instruction_4_to_0_in(ins_mem_31_to_0_from_IFID_to_all_things[4:0]), .alu_op_in(control_ALU_op_from_IFID),
             .ALUSrc_in(control_ALU_src_from_IFID), .Branch_zero_in(control_Branch_zero_from_IFID), .Memwrite_in(control_Memwrite_from_IFID),
              .Memread_in(control_Memread__from_IFID), .MemToReg_in(control_MemToReg_from_IFID), .RegWrite_in(control_RegWrite_from_IFID), .pc_out(pc_from_IDEX_to_add), .read_data_1_out(reg_out_1_from_IDEX_to_alu),
              .read_data_2_out(reg_out_2_from_IDEX_to_mux2_and_EXMEM), .sign_extend_out(signextend_from_IDEX_to_add_and_mux2), .instruction_31_to_21_out(IDEX_to_ALUControl[31:21]), 
              .instruction_4_to_0_out(IDEX_to_EXMEM[4:0]), .alu_op_out(control_ALU_op_from_IDEX), .ALUSrc_out(control_ALU_src_from_IDEX), .Branch_zero_out(control_Branch_zero_from_IDEX),
               .Memwrite_out(control_Memwrite_from_IDEX), .Memread_out(control_Memread__from_IDEX), .MemToReg_out(control_MemToReg_from_IDEX), .RegWrite_out(control_RegWrite_from_IDEX));
           
            //EXMEM Instantiation
            
            EXMEM EXMEM_inst(.clk(clk), .add_result_in(add_to_EXMEM), .read_data_2_in(reg_out_2_from_IDEX_to_mux2_and_EXMEM),
             .instruction_4_to_0_in(IDEX_to_EXMEM[4:0]), .ALU_result_in(alu_to_EXMEM), .ALU_zero_in(ALUZero_to_EXMEM),
            .Branch_zero_in(control_Branch_zero_from_IDEX), .Memwrite_in(control_Memwrite_from_IDEX), .Memread_in(control_Memread__from_IDEX),
            .MemToReg_in(control_MemToReg_from_IDEX), .RegWrite_in(control_RegWrite_from_IDEX), .add_result_out(add_from_EXMEM_to_mux4),
            .read_data_2_out(reg_2_from_EXMEM_to_datamem), .instruction_4_to_0_out(ins_from_EXMEM_to_MEMWB[4:0]), .ALU_result_out(alu_result_to_data_mem_and_MEMWB),
            .ALU_zero_out(ALUZero_from_EXMEM_to_branch), .Branch_zero_out(control_branch_zero_from_EXMEM), .Memwrite_out(control_Memwrite_from_EXMEM),
            .Memread_out(control_Memread_from_EXMEM), .MemToReg_out(control_MemToReg_from_EXMEM_to_MEMWB), .RegWrite_out(control_RegWrite_from_EXMEM_to_MEMWB));
            
            //MEMWB Instantiation
            
            MEMWB MEMWB_inst(.clk(clk), .RegWrite_in(control_RegWrite_from_EXMEM_to_MEMWB), .MemToReg_in(control_MemToReg_from_EXMEM_to_MEMWB),
            .data_memory_in(data_mem_to_MEMWB), .alu_result_in(alu_result_to_data_mem_and_MEMWB), .instruction_4_to_0_in(ins_from_EXMEM_to_MEMWB[4:0]),
            .RegWrite_out(control_RegWrite_from_MEMWB_to_registers), .MemToReg_out(control_MemToReg_from_MEMWB_to_mux3), .data_memory_out(datamem_from_MEMWB_to_mux3),
            .alu_result_out(alu_result_from_MEMWB_to_mux3), .instruction_4_to_0_out(MEMWB_to_write_reg));
            
            
            //ALU Instantiation
            Alu alu_inst (.clk(clk), .readdata1(reg_out_1_from_IDEX_to_alu), .main_aluinput2(mux2_to_alu), .ALU(alu_control_to_alu), .y(alu_to_EXMEM), .z(ALUZero_to_EXMEM));
            
            always @ (posedge clk) begin
            mainalu_to_datamemreaddata = alu_result_to_data_mem_and_MEMWB;
            readdata2_to_datamemwritedata = reg_2_from_EXMEM_to_datamem;
            memwrite = control_Memwrite_from_EXMEM;
            memread = control_Memread_from_EXMEM;
            end
            
            //Control instantiation 
            Control control_inst
            (.clk(clk), .opcode(ins_mem_31_to_0_from_IFID_to_all_things[31:21]), .branch(control_Branch_zero_from_IFID), .memread( control_Memread__from_IFID), .memtoreg(control_MemToReg_from_IFID),
            .aluop(control_ALU_op_from_IFID), .memwrite(control_Memwrite_from_IFID), .alusrc(control_ALU_src_from_IFID), .regwrite(control_RegWrite_from_IFID));
           
           //Mux1 instantiation 
            mux1 mux1_inst
            (.clk(clk), .instruction20_16(ins_mem_31_to_0_from_IFID_to_all_things[20:16]),.instruction4_0(ins_mem_31_to_0_from_IFID_to_all_things[4:0]),.reg2loc(ins_mem_31_to_0_from_IFID_to_all_things[28]),.readregaddr2(mux1_to_read_reg_2));
            
            //Mux2 instantiation 
            mux2 mux2_inst
            (.clk(clk), .readdata2(reg_out_2_from_IDEX_to_mux2_and_EXMEM), .extended(signextend_from_IDEX_to_add_and_mux2), .alusrc(control_ALU_src_from_IDEX), .main_aluinput2(mux2_to_alu));
            
            //Mux3 instantiation 
            mux3 mux3_inst
            (.clk(clk), .datamem_readdata(datamem_from_MEMWB_to_mux3), .y(alu_result_from_MEMWB_to_mux3), .memtoreg(control_MemToReg_from_MEMWB_to_mux3), .writedata(mux3_to_write_data));
            
            //Mux4 instantiation 
            mux4 mux4_inst
            (.clk(clk), .pc_output(pc_from_pc_to_IFID),.extended(add_from_EXMEM_to_mux4),.cbz(PCSrc),.pc(mux4_to_pcinput));
           
           //Program counter instantiation 
            always@(posedge clk)begin
            pcoutput_to_testbench=mux4_to_pcinput;
            end
            
            //Program counter instantiation 
            pc pc_inst (.clk(clk), .pc_input(mux4_to_pcinput),.pc_output(pc_from_pc_to_IFID));
            
            //Register instantiation 
            registerfile reg_inst
            (.readregaddr1(ins_mem_31_to_0_from_IFID_to_all_things[9:5]),.readregaddr2(mux1_to_read_reg_2),.writeregaddr(MEMWB_to_write_reg[4:0]),
            .writedata(mux3_to_write_data),.readdata1(reg_out_1_to_IDEX),.readdata2(reg_out_2_to_IDEX),.reset(reset),.clk(clk),.regwrite(control_RegWrite_from_MEMWB_to_registers));
            
            //Signextend instantiation 
            signextend extend_inst (.clk(clk), .unextended(ins_mem_31_to_0_from_IFID_to_all_things), .extended(signextend_from_IDEX_to_add_and_mux2));
            
            //ALU control instantiation 
            alu_control alucontrol_inst (.clk(clk), .aluop(control_ALU_op_from_IDEX), .instruction31_21(IDEX_to_ALUControl), .alu_controlline(alu_control_to_alu));
        
    endmodule
    
    
    module IFID(
        input clk, 
        input [31:0] instruction31_0_in, //Coming from Instruction memory
        input [63:0] pc_in, //Program counter
        output reg [31:0] instruction31_0_out, 
        output reg [63:0] pc_out
    );
    
    always@(posedge clk) begin
    instruction31_0_out <= instruction31_0_in;
    pc_out <= pc_in;
    end
    
    endmodule
    
    module IDEX(
        input clk,
        input [63:0] pc_in,
        input [63:0] read_data_1_in,
        input [63:0] read_data_2_in,
        input [63:0] sign_extend_in,
        input [10:0] instruction_31_to_21_in,
        input [4:0] instruction_4_to_0_in,
        input [1:0] alu_op_in,
        input ALUSrc_in,
        input Branch_zero_in,
        input Memwrite_in,
        input Memread_in,
        input MemToReg_in,
        input RegWrite_in,
        output reg [63:0] pc_out,
        output reg [63:0] read_data_1_out,
        output reg [63:0] read_data_2_out,
        output reg [63:0] sign_extend_out,
        output reg [10:0] instruction_31_to_21_out,
        output reg [4:0] instruction_4_to_0_out,
        output reg [1:0] alu_op_out,
        output reg ALUSrc_out,
        output reg Branch_zero_out,
        output reg Memwrite_out,
        output reg Memread_out,
        output reg MemToReg_out,
        output reg RegWrite_out
    );
    
    always@(posedge clk) begin
    //Control Parts for between ID/EX and EX/MEM
    alu_op_out <= alu_op_in;
    ALUSrc_out <= ALUSrc_in;
    //Control Parts for between EX/MEM and MEM/WB
    Branch_zero_out <= Branch_zero_in;
    Memwrite_out <= Memwrite_in;
    Memread_out <= Memread_in;
    //Control Parts for between MEM/WB and end
    MemToReg_out <= MemToReg_in;
    RegWrite_out <= RegWrite_in;
    //Other parts
    pc_out <= pc_in;
    read_data_1_out <= read_data_1_in;
    read_data_2_out <= read_data_2_in;
    sign_extend_out <= sign_extend_in;
    instruction_31_to_21_out <= instruction_31_to_21_in;
    instruction_4_to_0_out <= instruction_4_to_0_in;
    
    
    end
    endmodule
    
    module EXMEM(
    input clk,
    input [63:0] add_result_in,
    input [63:0] read_data_2_in,
    input [4:0] instruction_4_to_0_in,
    input [63:0] ALU_result_in,
    input ALU_zero_in,
    input Branch_zero_in,
    input Memwrite_in,
    input Memread_in,
    input MemToReg_in,
    input RegWrite_in,
    output reg [63:0] add_result_out,
    output reg [63:0] read_data_2_out,
    output reg [4:0] instruction_4_to_0_out,
    output reg [63:0] ALU_result_out,
    output reg ALU_zero_out,
    output reg Branch_zero_out,
    output reg Memwrite_out,
    output reg Memread_out,
    output reg MemToReg_out,
    output reg RegWrite_out
    );
    
    always@(posedge clk) begin
    //Control Parts for between EX/MEM and MEM/WB
    Branch_zero_out <= Branch_zero_in;
    Memwrite_out <= Memwrite_in;
    Memread_out <= Memread_in;
    //Control Parts for between MEM/WB and end
    MemToReg_out <= MemToReg_in;
    RegWrite_out <= RegWrite_in;
    //Other parts
    add_result_out <= add_result_in;
    read_data_2_out <= read_data_2_in;
    instruction_4_to_0_out <= instruction_4_to_0_in;
    ALU_result_out <= ALU_result_in;
    ALU_zero_out <= ALU_zero_in;
    
    end
    
    endmodule
    
    module MEMWB(
    input clk,
    input RegWrite_in,
    input MemToReg_in,
    input [63:0] data_memory_in,
    input [63:0] alu_result_in,
    input [4:0] instruction_4_to_0_in,
    output reg RegWrite_out,
    output reg MemToReg_out,
    output reg [63:0] data_memory_out,
    output reg [63:0] alu_result_out,
    output reg [4:0] instruction_4_to_0_out
    );
    
    always@(posedge clk) begin
    //Control Parts
    RegWrite_out <= RegWrite_in;
    MemToReg_out <= MemToReg_in;
    //Other parts
    data_memory_out <= data_memory_in;
    alu_result_out <= alu_result_in;
    instruction_4_to_0_out <= instruction_4_to_0_in;
    end
    
    endmodule
    
    module Alu(
            input clk,
            input [63:0] readdata1,
            input [63:0] main_aluinput2,
            input [3:0] ALU,
            output reg [63:0] y,
            output reg z
            );
                always@(posedge clk)
                begin
                    case(ALU)
                    4'b0000: assign y = readdata1 & main_aluinput2;
                    4'b0001: assign y = readdata1 | main_aluinput2;
                    4'b0010: assign y = readdata1 + main_aluinput2;
                    4'b0110: assign y = readdata1 - main_aluinput2;
                    4'b0111: assign y = main_aluinput2 ;
                    4'b1100: assign y = ~(readdata1 | main_aluinput2);
                    endcase
                    
                if (y == 0)
                    begin
                     z = 1;
                     end
                     
                else
                
                    begin
                     z = 0;
                    end
                end
    endmodule
    
    
    module Control(
        input clk,
        input [10:0] opcode,
        output reg [1:0] aluop,
        output reg alusrc,
        output reg memtoreg,
        output reg regwrite,
        output reg memread,
        output reg memwrite,
        output reg branch
                    );
                        always@(posedge clk) begin
                        if (opcode[10:3]==8'b10110100) begin
                        alusrc=1'b0;
                        regwrite=1'b0;
                        memread=1'b0;
                        memwrite=1'b0;
                        branch=1'b1;
                        aluop=2'b01;
                        
                        end
        
                        else
                            case(opcode)
                            
                            11'b10001011000: begin //ADD
                            alusrc=1'b0;
                            memtoreg=1'b0;
                            regwrite=1'b1;
                            memread=1'b0;
                            memwrite=1'b0;
                            branch=1'b0;
                            aluop=2'b10;
                            end
                        
                            11'b11001011000: begin //SUB
                            alusrc=1'b0;
                            memtoreg=1'b0;
                            regwrite=1'b1;
                            memread=1'b0;
                            memwrite=1'b0;
                            branch=1'b0;
                            aluop=2'b10;
                            end
                        
                            11'b10001010000: begin//AND
                            alusrc=1'b0;
                            memtoreg=1'b0;
                            regwrite=1'b1;
                            memread=1'b0;
                            memwrite=1'b0;
                            branch=1'b0;
                            aluop=2'b10;
                            end
                        
                            11'b10101010000: begin //ORR
                            alusrc=1'b0;
                            memtoreg=1'b0;
                            regwrite=1'b1;
                            memread=1'b0;
                            memwrite=1'b0;
                            branch=1'b0;
                            aluop=2'b10;
                            end
                        
                            11'b11111000010: begin //LDUR
                            alusrc=1'b1;
                            memtoreg=1'b1;
                            regwrite=1'b1;
                            memread=1'b1;
                            memwrite=1'b0;
                            branch=1'b0;
                            aluop=2'b00;
                            end
                        
                            11'b11111000000:begin //STUR
                            alusrc=1'b1;
                            regwrite=1'b0;
                            memread=1'b0;
                            memwrite=1'b1;
                            branch=1'b0;
                            aluop=2'b00;
                            end
                        endcase
                    end
    endmodule
    
    module mux1(
        input clk,
        input [4:0] instruction20_16,
        input [4:0] instruction4_0,
        input reg2loc, //In this its instruction[28]
        output reg [4:0] readregaddr2
        );
        always @(posedge clk) begin
                case(reg2loc)
                    1'b0:readregaddr2=instruction20_16;
                    1'b1:readregaddr2=instruction4_0;
                endcase
        end
    endmodule
    
    module mux2(
        input clk,
        input [63:0] readdata2,
        input [63:0] extended,
        input alusrc,
        output reg [63:0] main_aluinput2
        );
            always @(posedge clk) begin
                case(alusrc)
                    1'b0:main_aluinput2=readdata2;
                    1'b1:main_aluinput2=extended;
                endcase
            end
    endmodule
    
    module mux3(
        input clk,
        input memtoreg,
        input [63:0] y,
        input [63:0] datamem_readdata,
        output reg [63:0] writedata
                );
        always @(posedge clk) begin
            case(memtoreg)
                1'b1: writedata=datamem_readdata;
                1'b0: writedata=y;
            endcase
        end
    endmodule
    
    module mux4(
        input clk,
        input reset,
        input cbz,
        input [63:0] pc_output,
        input [63:0] extended,
        output reg [63:0] pc
            );
            always @(posedge reset) begin
            pc=0;
            end
            
            always @(posedge clk) begin
                case(cbz)
                    1'b1: pc = (extended<<2)+pc_output;
                    1'b0: pc = pc_output;
            endcase
            
        end
    endmodule

    
    module add(
    input clk,
    input [63:0] signextend_in,
    input [63:0] pc_in,
    output reg [63:0] add_out
    );
    
     always @(posedge clk) begin
        add_out = (signextend_in<<2) + pc_in;
    end
    
    endmodule
    

    
module pc(
            input clk,
            input reset,
            input [63:0] pc_input,
            output reg [63:0] pc_output
                );
                
                always @(posedge reset)begin
                    pc_output <= 0;
                end
                
                always @(posedge clk)begin
                    pc_output=pc_input+4;
                end
        endmodule
        
module registerfile (
            input reset,
            input clk,
            input regwrite,
            input [4:0] readregaddr1,readregaddr2,
            input [63:0] writedata,
            input [4:0] writeregaddr,
            output reg [63:0] readdata1,readdata2
                            );
                reg [63:0] regs[31:0];//Creates the 32,64-bit registers
                integer i;
        
        initial begin
            for(i=0;i<64;i=i+1) begin
            regs[i] <= i;
        end
    end
        always@(posedge clk) begin //for read
            readdata1= regs[readregaddr1];
            readdata2= regs[readregaddr2];
        end
    always@(posedge clk)begin
        if(regwrite == 1'b1)begin
             case(writeregaddr) // Decoder for part b. of register file
                   5'b00000: regs[0] = writedata;
                   5'b00001: regs[1] = writedata;
                   5'b00010: regs[2] = writedata;
                   5'b00011: regs[3] = writedata;
                   5'b00100: regs[4] = writedata;
                   5'b00101: regs[5] = writedata;
                   5'b00110: regs[6] = writedata;
                   5'b00111: regs[7] = writedata;
                   5'b01000: regs[8] = writedata;
                   5'b01001: regs[9] = writedata;
                   5'b01010: regs[10] = writedata;
                   5'b01011: regs[11] = writedata;
                   5'b01100: regs[12] = writedata;
                   5'b01101: regs[13] = writedata;
                   5'b01110: regs[14] = writedata;
                   5'b01111: regs[15] = writedata;
                   5'b10000: regs[16] = writedata;
                   5'b10001: regs[17] = writedata;
                   5'b10010: regs[18] = writedata;
                   5'b10011: regs[19] = writedata;
                   5'b10100: regs[20] = writedata;
                   5'b10101: regs[21] = writedata;
                   5'b10110: regs[22] = writedata;
                   5'b10111: regs[23] = writedata;
                   5'b11000: regs[24] = writedata;
                   5'b11001: regs[25] = writedata;
                   5'b11010: regs[26] = writedata;
                   5'b11011: regs[27] = writedata;
                   5'b11100: regs[28] = writedata;
                   5'b11101: regs[29] = writedata;
                   5'b11110: regs[30] = writedata;
                   5'b11111: regs[31] = writedata;
                endcase
            end
        end
    endmodule
    
    module signextend(
        input clk,
        input [31:0] unextended,
        output reg [63:0] extended
                    );
                    reg signed [51:0] temp;
            always@(posedge clk) begin
                if (unextended[31:24]==8'b10110100) begin
                        extended [63:19]= {45{unextended[23]}};
                        extended [18:0]= unextended[23:5];
                        
                        end
                                      
                else begin
                
                        extended[63:9]={55{unextended[20]}};
                        extended[8:0]=unextended[20:12];
                        
                    end
                end
            endmodule
            
    module alu_control(
            input clk,
            input[1:0] aluop,
            input [10:0] instruction31_21,
            output reg [3:0] alu_controlline
                        );
                        
            always@(posedge clk)begin
                case(aluop)
                    2'b00 : alu_controlline=4'b0010;
                    2'b01 : alu_controlline=4'b0111;
                    2'b10 : begin
                        if(instruction31_21==11'b10001011000)
                                alu_controlline=4'b0010;
                        else if(instruction31_21==11'b11001011000)
                                alu_controlline=4'b0110;
                        else if(instruction31_21==11'b10001010000)
                                alu_controlline=4'b0000;
                        else if(instruction31_21==11'b10101010000)
                                alu_controlline=4'b0001;
                        end
                endcase
            end
    endmodule
    
    module datamemory(
        input clk,
        input [63:0] main_aluresult,
        input [63:0] datamem_writedata,
        input memwrite,
        input memread,
        output reg [63:0] datamem_readdata
                    );
                    
        integer i=0;
        reg [63:0] storage[31:0];
        
            initial begin
                for(i=0;i<64;i=i+1) begin
                    storage[i]<=2*i;
            end
        end
        
        always@(posedge clk) begin
            if(memwrite==1'b1)begin
                storage[main_aluresult]=datamem_writedata;
            end
            
            if(memread==1'b1) begin
                datamem_readdata= storage[main_aluresult];
            end
        end
        
endmodule

module instructionmemory(
    input clk,
    input [63:0] pc,
    output reg [31:0] instruction31_0
    );
    reg [31:0] instructions[63:0];
    always@(posedge clk) begin
    //Instructions
      instructions[0]  = 32'b00000000000000000000000000000000;
      instructions[4]  = 32'b10001011000001000000000010100011; // ADD      x3, x5, x4
      instructions[8]  = 32'b11001011000001100000000000100001; // SUB       x1, x1, x6
      instructions[12] = 32'b10001010000001000000000001100111; // AND      x7, x3, x4
      instructions[16] = 32'b10101010000001100000000010101000; // ORR      x8, x5, x6
      instructions[20] = 32'b11111000010000000100000100001010; // LDUR   x10, [x8, #4]
      instructions[24] = 32'b11111000000000001000000101101100; // STUR    x12, [ x16, #8]
      instructions[28] = 32'b10110100000000000000000000000000; // CBZ      x0, #0
        end
            always@(posedge clk) begin
                instruction31_0 = instructions[pc];
            end
endmodule
