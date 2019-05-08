library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg is
  type slv8_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
  type slv4_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
  type slv6_array_t is array (natural range <>) of std_logic_vector(5 downto 0);
  type slv16_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
  type slv_array_t is array (natural range <>) of std_logic;
  type slv3_array_t is array (natural range <>) of std_logic_vector(2 downto 0);
  type slv2_array_t is array (natural range <>) of std_logic_vector(1 downto 0);
  type slv6_int_array_t is array (natural range <>) of integer range 0 to 9;
end package;

package body pkg is
end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;




entity top_level is 

port (

   top_clock:in std_logic;
   system_reset:in std_logic;-----------------------------------active high system reset
   r0_out: out std_logic_vector(15 downto 0);
   r1_out: out std_logic_vector(15 downto 0);
   r2_out: out std_logic_vector(15 downto 0);
   r3_out: out std_logic_vector(15 downto 0);
   r4_out: out std_logic_vector(15 downto 0);
   r5_out: out std_logic_vector(15 downto 0);
   r6_out: out std_logic_vector(15 downto 0);
   r7_out: out std_logic_vector(15 downto 0);
   --curr_pc: out std_logic_vector(15 downto 0);
   c_reg_data_out: out std_logic;
   z_reg_data_out: out std_logic
   );

end entity;


architecture struct of top_level is

component memory_code is

port  (clk : in std_logic;  
        we  : in std_logic;   
        a   : in std_logic_vector(15 downto 0);   
        di  : in std_logic_vector(15 downto 0);   
        do  : out std_logic_vector(31 downto 0)); 
 end component memory_code;

component fetch is

port (
	clk: in std_logic;
	Mem_in: in std_logic_vector(31 downto 0);
	PC_in: in std_logic_vector(15 downto 0);

	stall_in: in std_logic;
	instr_invalidate_in: in std_logic;
	------------------------------------------------------------
	inst_1_valid: out std_logic;
	inst_2_valid: out std_logic;
	Instr1: out std_logic_vector(15 downto 0);
	Instr2: out std_logic_vector(15 downto 0);
	PC: out std_logic_vector(15 downto 0)
  ) ;

  end component fetch;

component add_pc is
  	port (
  		PC_in:in std_logic_vector(15 downto 0);
  		PC_out:out std_logic_vector(15 downto 0)
  		
  	);
  end component add_pc;  

  component decode is

   port (
	clk: in std_logic;
	reset:in std_logic;
	inst_1_valid_in: in std_logic;
	inst_2_valid_in: in std_logic;
	Instr1_in: in std_logic_vector(15 downto 0);
	Instr2_in: in std_logic_vector(15 downto 0);
	PC_in: in std_logic_vector(15 downto 0);
	Nxt_PC_in: in std_logic_vector(15 downto 0);


	br_inst_valid_in: in std_logic;
	br_btag_in: in std_logic_vector(2 downto 0);
	br_self_tag_in: in std_logic_vector(2 downto 0);

	stall_in: in std_logic;
	instr_invalidate_in: in std_logic;
	------------------------------------------------------------
	--Instruction 1
	I1_valid: out std_logic;
	I1_op_code: out std_logic_vector(3 downto 0);
	I1_op_cz: out std_logic_vector(1 downto 0);
	I1_dest_code: out std_logic_vector(2 downto 0);
	I1_operand_1_code: out std_logic_vector(2 downto 0);
	I1_operand_2_code: out std_logic_vector(2 downto 0);
	I1_Imm: out std_logic_vector(15 downto 0);
	I1_PC: out std_logic_vector(15 downto 0);
	I1_Nxt_PC: out std_logic_vector(15 downto 0);
	I1_BTAG: out std_logic_vector(2 downto 0);
	I1_self_tag: out std_logic_vector(2 downto 0);

	--Instruction 2
	I2_valid: out std_logic;
	I2_op_code: out std_logic_vector(3 downto 0);
	I2_op_cz: out std_logic_vector(1 downto 0);
	I2_dest_code: out std_logic_vector(2 downto 0);
	I2_operand_1_code: out std_logic_vector(2 downto 0);
	I2_operand_2_code: out std_logic_vector(2 downto 0);
	I2_Imm: out std_logic_vector(15 downto 0);
	I2_PC: out std_logic_vector(15 downto 0);
	I2_Nxt_PC: out std_logic_vector(15 downto 0);
	I2_BTAG: out std_logic_vector(2 downto 0);
	I2_self_tag: out std_logic_vector(2 downto 0);

	-----------------------------------
	stall_out: out std_logic;
  current_BTAG_out: out std_logic_vector(2 downto 0)
  );

   end component decode;


   component bit16_2x1 is 

    port ( c_0 : in  STD_LOGIC;
           d_0   : in  std_logic_vector(15 downto 0);
           d_1   : in  std_logic_vector(15 downto 0);
           o   : out std_logic_vector(15 downto 0));
    end component bit16_2x1;
    

    component bit1_2x1 is 

     port ( c_0 : in  STD_LOGIC;
           d_0   : in  std_logic;
           d_1   : in  std_logic;
           o   : out std_logic);


    end component bit1_2x1;


    component reservation_state is

     port (instr1_valid_in:in std_logic;
 	   op_code1_in:in std_logic_vector(3 downto 0);
 	   op_cz1_in: in std_logic_vector(1 downto 0);
 	   destn_code1_in:in std_logic_vector(2 downto 0);
 	   opr1_code1_in:in std_logic_vector(2 downto 0);
 	   opr2_code1_in:in std_logic_vector(2 downto 0);
		opr3_code1_in:in std_logic_vector(2 downto 0);
 	   curr_pc1_in: in std_logic_vector(15 downto 0);
 	   next_pc1_in:in std_logic_vector(15 downto 0);
 	   imm1_in:in std_logic_vector(15 downto 0);
 	   btag1_in:in std_logic_vector(2 downto 0);
 	   self1_tag_in:in std_logic_vector(2 downto 0);

       instr2_valid_in:in std_logic;
 	   op_code2_in:in std_logic_vector(3 downto 0);
 	   op_cz2_in: in std_logic_vector(1 downto 0);
 	   destn_code2_in:in std_logic_vector(2 downto 0);
 	   opr1_code2_in:in std_logic_vector(2 downto 0);
 	   opr2_code2_in:in std_logic_vector(2 downto 0);
		opr3_code2_in:in std_logic_vector(2 downto 0);
 	   curr_pc2_in: in std_logic_vector(15 downto 0);
 	   next_pc2_in:in std_logic_vector(15 downto 0);
 	   imm2_in:in std_logic_vector(15 downto 0);
 	   btag2_in:in std_logic_vector(2 downto 0);
 	   self2_tag_in:in std_logic_vector(2 downto 0);

       alu_valid_done1_in:in std_logic;
       alu_done_number1:in std_logic_vector(3 downto 0);

       alu_valid_done2_in:in std_logic;
       alu_done_number2:in std_logic_vector(3 downto 0);

       ls_valid_done_in:in std_logic;
       ls_done_number:in std_logic_vector(3 downto 0);

       jmp_valid_done_in:in std_logic;
       jmp_done_number:in std_logic_vector(3 downto 0);

         

 	   reset_system:in std_logic;--to be done at start of cycle general reset which assigns all registers its original values
 	   --reset_system_mapping:in std_logic;--to be used to clear all assigned ARF and RRF's 
       clk_input:in std_logic;
       stall_reservation_update:in std_logic;--no data comes to reservation station if becomes 1


       broadcast1_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast1_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast1_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast1_valid_in: in std_logic;--refers whether broadcasted data is valid or not

       broadcast1_c_flag_in:in std_logic;
       broadcast1_c_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast1_c_flag_valid_in:in std_logic;

       broadcast1_z_flag_in:in std_logic;
       broadcast1_z_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast1_z_flag_valid_in:in std_logic;

       broadcast1_btag_in: in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       


       broadcast2_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast2_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast2_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast2_valid_in: in std_logic;--refers whether broadcasted data is valid or not 
       

       broadcast2_c_flag_in:in std_logic;
       broadcast2_c_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast2_c_flag_valid_in:in std_logic;

       broadcast2_z_flag_in:in std_logic;
       broadcast2_z_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast2_z_flag_valid_in:in std_logic;

       broadcast2_btag_in:in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies


       broadcast3_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast3_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast3_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast3_valid_in: in std_logic;--refers whether broadcasted data is valid or not 
       -- 
       broadcast3_btag_in:in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       
       
       broadcast4_rename_in:in std_logic_vector(5 downto 0);--refers to rename register broadcasted
       broadcast4_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast4_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast4_valid_in: in std_logic;--refers whether broadcasted data is valid or not 
       
       
       broadcast4_c_flag_in:in std_logic;
       broadcast4_c_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast4_c_flag_valid_in:in std_logic;

       broadcast4_z_flag_in:in std_logic;
       broadcast4_z_flag_rename_in:in std_logic_vector(2 downto 0);
       broadcast4_z_flag_valid_in:in std_logic;

       broadcast4_btag_in:in std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies

       branch_mispredict_broadcast_in:in std_logic_vector(1 downto 0); --00 implies no misprediction 01 implies first branch mispredicted 10 implies second branch mispredicted


       broadcast5_rename_in:in std_logic_vector(5 downto 0);
       broadcast5_orig_destn_in:in std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register 
       broadcast5_data_in:in std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
       broadcast5_valid_in: in std_logic;--refers whether broadcasted data is valid or not \
       broadcast5_btag_in:in std_logic_vector(2 downto 0);


		arf_rename_valid_out:out slv_array_t(0 to 7);-- not required if value is valid rename cannot be valid
		--signal arf_reg_name:array(0 to 29) of std_logic_vector(2 downto 0);
		arf_reg_rename_out:out slv6_array_t(0 to 7);
		arf_reg_value_out:out slv16_array_t(0 to 7);--refers to value stored 
		arf_value_valid_out:out slv_array_t(0 to 7);
		free_reg_out: out std_logic_vector (15 downto 0);--denotes which rename registers are free 


		carry_value_valid_out:out std_logic;
		zero_value_valid_out:out std_logic;

		carry_value_out:out std_logic;
		zero_value_out:out std_logic;



		carry_rename_rf_out:out std_logic_vector(2 downto 0);--stores to which rename carry flag is currently renamed
		zero_rename_rf_out: out std_logic_vector(2 downto 0); --stores to which rename zero flag is currently renamed

		free_flag_zero_out:out std_logic;-- whether 2 zero registers are free
		free_flag_carry_out:out std_logic;--whether 2 carry registers are free

		free_rename_carry_out:out std_logic_vector(7 downto 0);--which of 7 rename carry flags are free
		free_rename_zero_out:out std_logic_vector(7 downto 0);--which of 7 rename zero flags are free
       

       --entry in ROB output

       curr_instr1_valid_rob_out:out std_logic;
       curr_pc1_rob_out:out std_logic_vector(15 downto 0);
       destn_code1_rob_out:out std_logic_vector(2 downto 0);
       op_code1_rob_out:out std_logic_vector(3 downto 0);
       destn_rename1_rob_out:out std_logic_vector(5 downto 0);
       destn_rename_c1_rob_out:out std_logic_vector(2 downto 0);
       destn_rename_z1_rob_out:out std_logic_vector(2 downto 0);
       destn_btag1_rob_out:out std_logic_vector(2 downto 0);
       destn_self_tag1_rob_out:out std_logic_vector(2 downto 0);

       
       curr_instr2_valid_rob_out:out std_logic;
       curr_pc2_rob_out:out std_logic_vector(15 downto 0);
       destn_code2_rob_out:out std_logic_vector(2 downto 0);
       op_code2_rob_out:out std_logic_vector(3 downto 0);
       destn_rename2_rob_out:out std_logic_vector(5 downto 0);
       destn_rename_c2_rob_out:out std_logic_vector(2 downto 0);
       destn_rename_z2_rob_out:out std_logic_vector(2 downto 0);
       destn_btag2_rob_out:out std_logic_vector(2 downto 0);
       destn_self_tag2_rob_out:out std_logic_vector(2 downto 0);



       alu_instr_valid_out:out slv_array_t(0 to 9);
       alu_op_code_out:out slv4_array_t(0 to 9);
       alu_op_code_cz_out:out slv2_array_t(0 to 9);
       alu_destn_rename_code_out:out slv6_array_t(0 to 9);
       alu_operand1_out:out slv16_array_t(0 to 9);
       alu_valid1_out:out slv_array_t(0 to 9);

       alu_operand2_out:out slv16_array_t(0 to 9);
       alu_valid2_out:out slv_array_t(0 to 9);

       alu_operand3_out:out slv16_array_t(0 to 9);
       alu_valid3_out:out slv_array_t(0 to 9);

       alu_c_flag_out:out slv_array_t(0 to 9);
       alu_c_flag_rename_out:out slv3_array_t(0 to 9);
       alu_c_flag_valid_out:out slv_array_t(0 to 9);
       alu_c_flag_destn_addr_out:out slv3_array_t(0 to 9);

       alu_z_flag_out:out slv_array_t(0 to 9);
       alu_z_flag_rename_out:out slv3_array_t(0 to 9);
       alu_z_flag_valid_out:out slv_array_t(0 to 9);
       alu_z_flag_destn_addr_out:out slv3_array_t(0 to 9);

       alu_btag_out:out slv3_array_t(0 to 9);

       alu_orign_destn_out:out slv3_array_t(0 to 9);

       alu_curr_pc_out:out slv16_array_t(0 to 9);

       alu_scheduler_valid_out:out slv_array_t(0 to 9);       


       ls_instr_valid_out:out slv_array_t(0 to 9);
       ls_op_code_out:out slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       ls_destn_rename_code_out:out slv6_array_t(0 to 9);
       ls_operand1_out:out slv16_array_t(0 to 9);
       ls_valid1_out:out slv_array_t(0 to 9);

       ls_operand2_out:out slv16_array_t(0 to 9);
       ls_valid2_out:out slv_array_t(0 to 9);


       ls_operand3_out:out slv16_array_t(0 to 9);--denotes which register to load onto or store from
       ls_valid3_out:out slv_array_t(0 to 9);

       
       ls_btag_out:out slv3_array_t(0 to 9);

       ls_orign_destn_out:out slv3_array_t(0 to 9);

       ls_curr_pc_out:out slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


       ls_scheduler_valid_out:out slv_array_t(0 to 9);



       jmp_instr_valid_out:out slv_array_t(0 to 9);
       jmp_op_code_out:out slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       jmp_destn_rename_code_out:out slv6_array_t(0 to 9);
       jmp_operand1_out:out slv16_array_t(0 to 9);
       jmp_valid1_out:out slv_array_t(0 to 9);

       jmp_operand2_out:out slv16_array_t(0 to 9);
       jmp_valid2_out:out slv_array_t(0 to 9);


       jmp_operand3_out:out slv16_array_t(0 to 9);--denotes which register to load onto or store from
       jmp_valid3_out:out slv_array_t(0 to 9);

       
       jmp_btag_out:out slv3_array_t(0 to 9);

       jmp_orign_destn_out:out slv3_array_t(0 to 9);

       jmp_curr_pc_out:out slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


       jmp_scheduler_valid_out:out slv_array_t(0 to 9);
       jmp_next_pc_out:out slv16_array_t(0 to 9);

       jmp_self_tag_out:out slv3_array_t(0 to 9);



       halt_out:out std_logic--instr could not be written onto RS 
       -- 
       );

      end component;

-------------------------------------------------------------------------------------------------------------------------------------------------
component lw_sw_sch is
  port (  clk: in std_logic;
          reset: in std_logic;

          ls_instr_valid_in: in slv_array_t(0 to 9);
          ls_op_code_in: in slv4_array_t(0 to 9);
          ls_original_dest_in: in slv3_array_t(0 to 9);
          ls_rename_dest_in: in slv6_array_t(0 to 9);
          ls_operand_1_in: in slv16_array_t(0 to 9);
          ls_operand_1_valid_in: in slv_array_t(0 to 9);

          ls_operand_2_in: in slv16_array_t(0 to 9);
          ls_operand_2_valid_in: in slv_array_t(0 to 9);

          ls_operand_3_in: in slv16_array_t(0 to 9);
          ls_operand_3_valid_in: in slv_array_t(0 to 9);

          ls_pc_in: in slv16_array_t(0 to 9);
          ls_sch_valid_in: in slv_array_t(0 to 9);

          ls_btag_in: in slv3_array_t(0 to 9);

          ls_stall_in: in std_logic;
          --------------------------------------------------------------------------------
          -- Execute Pipepline output
          ls_instr_valid_out: out std_logic;
          ls_op_code_out: out std_logic_vector(3 downto 0);
          ls_original_dest_out: out std_logic_vector(2 downto 0);
          ls_rename_dest_out: out std_logic_vector(5 downto 0);
          ls_operand_1_out: out std_logic_vector(15 downto 0);
          ls_operand_2_out: out std_logic_vector(15 downto 0);
          ls_operand_3_out: out std_logic_vector(15 downto 0);
          ls_pc_out: out std_logic_vector(15 downto 0);
          ls_btag_out: out std_logic_vector(2 downto 0);

          --------------------------------------------------------------------------------
          -- Data going back to RS
          rs_ls_index_out: out std_logic_vector(3 downto 0);
          rs_ls_valid_out: out std_logic
          );
end component ; -- lw_sw_sch
-------------------------------------------------------------------------------------------------------------------------------------------------

component branch_sch is
  port (
    clk: in std_logic;
    reset: in std_logic;
    br_instr_valid_in: in slv_array_t(0 to 9);
    br_op_code_in: in slv4_array_t(0 to 9);
    br_original_dest_in: in slv3_array_t(0 to 9);
    br_rename_dest_in: in slv6_array_t(0 to 9);
    br_operand_1_in: in slv16_array_t(0 to 9);
    br_operand_1_valid_in: in slv_array_t(0 to 9);

    br_operand_2_in: in slv16_array_t(0 to 9);
    br_operand_2_valid_in: in slv_array_t(0 to 9);

    br_operand_3_in: in slv16_array_t(0 to 9);
    br_operand_3_valid_in: in slv_array_t(0 to 9);

    br_pc_in: in slv16_array_t(0 to 9);
    br_nxt_pc_in: in slv16_array_t(0 to 9);
    br_sch_valid_in: in slv_array_t(0 to 9);

    br_btag_in: in slv3_array_t(0 to 9);
    br_self_tag_in: in slv3_array_t(0 to 9);

    br_stall_in: in std_logic;
    -----------------------------------------------------------------------------------
    --Execute pipeline branch input
    br_instr_valid_out: out std_logic;
    br_op_code_out: out std_logic_vector(3 downto 0);
    br_original_dest_out: out std_logic_vector(2 downto 0);
    br_rename_dest_out: out std_logic_vector(5 downto 0);
    br_operand_1_out: out std_logic_vector(15 downto 0);--refers to Ra
    
    br_operand_2_out: out std_logic_vector(15 downto 0);--refers to Rb
    
    br_operand_3_out: out std_logic_vector(15 downto 0);--refers to immediate
    
    br_pc_out: out std_logic_vector(15 downto 0);
    br_nxt_pc_out: out std_logic_vector(15 downto 0);
    
    br_btag_out: out std_logic_vector(2 downto 0);
    br_self_tag_out: out std_logic_vector(2 downto 0);
    --------------------------------------------------------------------------------
    -- Data going back to RS
    rs_br_index_out: out std_logic_vector(3 downto 0);
    rs_br_valid_out: out std_logic
    );
end component ; -- branch_sch

-------------------------------------------------------------------------------------------------------------------------------------------------

component alu_sch is
  port (
    clk: in std_logic;
    reset: in std_logic;
    alu_instr_valid_in: in slv_array_t(0 to 9);
    alu_op_code_in: in slv4_array_t(0 to 9);
    alu_op_code_cz_in: in slv2_array_t(0 to 9);
    
    alu_original_dest_in: in slv3_array_t(0 to 9);
    alu_rename_dest_in: in slv6_array_t(0 to 9);
    
    alu_operand_1_in: in slv16_array_t(0 to 9);
    alu_operand_1_valid_in: in slv_array_t(0 to 9);

    alu_operand_2_in: in slv16_array_t(0 to 9);
    alu_operand_2_valid_in: in slv_array_t(0 to 9);

    alu_operand_3_in: in slv16_array_t(0 to 9);
    alu_operand_3_valid_in: in slv_array_t(0 to 9);

    alu_c_flag_in: in slv_array_t(0 to 9);
    alu_c_flag_rename_in: in slv3_array_t(0 to 9);

    alu_z_flag_in: in slv_array_t(0 to 9);
    alu_z_flag_rename_in: in slv3_array_t(0 to 9);

    alu_pc_in: in slv16_array_t(0 to 9);
    alu_sch_valid_in: in slv_array_t(0 to 9);

    alu_btag_in: in slv3_array_t(0 to 9);

    alu_stall_in: in std_logic;
    --------------------------------------------------------------------------------
    -- Execute Pipepline output
    alu_instr_valid_out_1: out std_logic;
    alu_op_code_out_1: out std_logic_vector(3 downto 0);
    alu_op_code_cz_out_1: out std_logic_vector(1 downto 0);
    
    alu_original_dest_out_1: out std_logic_vector(2 downto 0);
    alu_rename_dest_out_1: out std_logic_vector(5 downto 0);
    
    alu_operand_1_out_1: out std_logic_vector(15 downto 0);
    
    alu_operand_2_out_1: out std_logic_vector(15 downto 0);
    
    alu_operand_3_out_1: out std_logic_vector(15 downto 0);
    
    alu_c_flag_out_1: out std_logic;
    alu_c_flag_rename_out_1: out std_logic_vector(2 downto 0);

    alu_z_flag_out_1: out std_logic;
    alu_z_flag_rename_out_1: out std_logic_vector(2 downto 0);

    alu_pc_out_1: out std_logic_vector(15 downto 0);
    
    alu_btag_out_1: out std_logic_vector(2 downto 0);
    -------------------------------------------------------------------------------------------
    --2 copies as 2 pipelines
    alu_instr_valid_out_2: out std_logic;
    alu_op_code_out_2: out std_logic_vector(3 downto 0);
    alu_op_code_cz_out_2: out std_logic_vector(1 downto 0);
    
    alu_original_dest_out_2: out std_logic_vector(2 downto 0);
    alu_rename_dest_out_2: out std_logic_vector(5 downto 0);
    
    alu_operand_1_out_2: out std_logic_vector(15 downto 0);
    
    alu_operand_2_out_2: out std_logic_vector(15 downto 0);
    
    alu_operand_3_out_2: out std_logic_vector(15 downto 0);
    
    alu_c_flag_out_2: out std_logic;
    alu_c_flag_rename_out_2: out std_logic_vector(2 downto 0);

    alu_z_flag_out_2: out std_logic;
    alu_z_flag_rename_out_2: out std_logic_vector(2 downto 0);

    alu_pc_out_2: out std_logic_vector(15 downto 0);
    
    alu_btag_out_2: out std_logic_vector(2 downto 0);
    --------------------------------------------------------------------------------
    -- Data going back to RS
    rs_alu_index_1_out: out std_logic_vector(3 downto 0);
    rs_alu_valid_1_out: out std_logic;
    rs_alu_index_2_out: out std_logic_vector(3 downto 0);
    rs_alu_valid_2_out: out std_logic 
  );
end component ; -- alu_sch

-------------------------------------------------------------------------------------------------------------------------------------------------
component alu_pipeline is
port(
	pipeline_valid_in: in std_logic;
	op_code_in: in std_logic_vector(3 downto 0);
	destn_rename_code_in: in std_logic_vector(5 downto 0);
	operand1: in std_logic_vector(15 downto 0);
	operand2:in std_logic_vector(15 downto 0);
	operand3:in std_logic_vector(15 downto 0);
	c_flag_in:in std_logic;
	z_flag_in:in std_logic;
	c_rename_in:in std_logic_vector(2 downto 0);
	z_rename_in: in std_logic_vector(2 downto 0);
	b_tag_in:in std_logic_vector(2 downto 0);
	orig_destn_in:in std_logic_vector(2 downto 0);
	op_code_cz:in std_logic_vector(1 downto 0);
	curr_pc_in:in std_logic_vector(15 downto 0);

	data_out: out std_logic_vector(15 downto 0);
	pipeline_valid_out: out std_logic;
	op_code_out: out std_logic_vector(3 downto 0);
	destn_rename_code_out: out std_logic_vector(5 downto 0);
	c_flag_out:out std_logic;
	z_flag_out:out std_logic;
	c_rename_out:out std_logic_vector(2 downto 0);
	z_rename_out: out std_logic_vector(2 downto 0);
	b_tag_out:out std_logic_vector(2 downto 0);
	orig_destn_out:out std_logic_vector(2 downto 0);
	curr_pc_out:out std_logic_vector(15 downto 0);

	alu_brdcst_rename_out:out std_logic_vector(5 downto 0);
	alu_brdcst_orig_destn_out:out std_logic_vector(2 downto 0);
	alu_brdcst_data_out:out std_logic_vector(15 downto 0);
	alu_brdcst_valid_out: out std_logic;

	alu_brdcst_c_flag_out:out std_logic;
	alu_brdcst_c_flag_rename_out:out std_logic_vector(2 downto 0);
	alu_brdcst_c_flag_valid_out:out std_logic;

	alu_brdcst_z_flag_out:out std_logic;
	alu_brdcst_z_flag_rename_out:out std_logic_vector(2 downto 0);
	alu_brdcst_z_flag_valid_out:out std_logic;

	alu_brdcst_btag_out: out std_logic_vector(2 downto 0)
	);
end component;
-------------------------------------------------------------------------------------------------------------------------------------------------
component lw_sw_pipeline is
  port(pipeline_valid_in: in std_logic;
  		op_code_in: in std_logic_vector(3 downto 0);
  		destn_rename_code_in: in std_logic_vector(5 downto 0);
  		operand1: in std_logic_vector(15 downto 0);--refers to Rb
  		operand2:in std_logic_vector(15 downto 0);--refers to immediate in case of LHI shifted word expected
      operand3:in std_logic_vector(15 downto 0);
		  --c_flag_in:in std_logic;
  		z_flag_in:in std_logic;
  		--c_rename_in:in std_logic_vector(3 downto 0);
  		z_rename_in: in std_logic_vector(2 downto 0);
  		b_tag_in:in std_logic_vector(2 downto 0);
  		orig_destn_in:in std_logic_vector(2 downto 0);
		  curr_pc_in:in std_logic_vector(15 downto 0);
  		--op_code_cz:in std_logic_vector(1 downto 0);
  		addr_out: out std_logic_vector(15 downto 0);
      data_out: out std_logic_vector(15 downto 0);--refers to immediate data in case of LHI
      pipeline_valid_out: out std_logic;
      op_code_out: out std_logic_vector(3 downto 0);
  		destn_rename_code_out: out std_logic_vector(5 downto 0);
   		--c_flag_out:out std_logic;
  		z_flag_out:out std_logic;
  		--c_rename_out:out std_logic_vector(3 downto 0);
  		z_rename_out: out std_logic_vector(2 downto 0);
  		b_tag_out:out std_logic_vector(2 downto 0);
  		orig_destn_out:out std_logic_vector(2 downto 0);
		  curr_pc_out:out std_logic_vector(15 downto 0);

      lw_sw_brdcst_rename_out:out std_logic_vector(5 downto 0);--refers to rename register broadcasted
      lw_sw_brdcst_orig_destn_out:out std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
      lw_sw_brdcst_data_out:out std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
      lw_sw_brdcst_valid_out: out std_logic;--refers whether broadcasted data is valid or not 
         
         
      lw_sw_brdcst_c_flag_out:out std_logic;
      lw_sw_brdcst_c_flag_rename_out:out std_logic_vector(2 downto 0);
      lw_sw_brdcst_c_flag_valid_out:out std_logic;

      lw_sw_brdcst_z_flag_out:out std_logic;
      lw_sw_brdcst_z_flag_rename_out:out std_logic_vector(2 downto 0);
      lw_sw_brdcst_z_flag_valid_out:out std_logic;

      lw_sw_brdcst_btag_out:out std_logic_vector(2 downto 0)--refers to btag of branch signal useful for updating branch copies
      );
end component;
-------------------------------------------------------------------------------------------------------------------------------------------------
component jump_pipeline is
port(
	pipeline_valid_in: in std_logic;
	op_code_in: in std_logic_vector(3 downto 0);
	destn_rename_code_in: in std_logic_vector(5 downto 0);
	operand1: in std_logic_vector(15 downto 0);--refers to Ra
	operand2:in std_logic_vector(15 downto 0);--refers to Rb
	operand3: in std_logic_vector(15 downto 0);--refers to immediate
	--c_flag_in:in std_logic;
	--z_flag_in:in std_logic;
	--c_rename_in:in std_logic_vector(3 downto 0);
	--z_rename_in: in std_logic_vector(3 downto 0);
	b_tag_in:in std_logic_vector(2 downto 0);
	orig_destn_in:in std_logic_vector(2 downto 0);
	--op_code_cz:in std_logic_vector(1 downto 0);
	curr_pc_in:in std_logic_vector(15 downto 0);
	next_pc_in: in std_logic_vector(15 downto 0);
	self_branch_tag_in: in std_logic_vector(2 downto 0);
	data_out: out std_logic_vector(15 downto 0);
	pipeline_valid_out: out std_logic;
	op_code_out: out std_logic_vector(3 downto 0);
	destn_rename_code_out: out std_logic_vector(5 downto 0);
	--c_flag_out:out std_logic;
	--z_flag_out:out std_logic;
	--c_rename_out:out std_logic_vector(3 downto 0);
	--z_rename_out: out std_logic_vector(3 downto 0);
	b_tag_out:out std_logic_vector(2 downto 0);
	orig_destn_out:out std_logic_vector(2 downto 0);
	curr_pc_out:out std_logic_vector(15 downto 0);
	self_branch_tag_out:out std_logic_vector(2 downto 0);
	branch_addr:out std_logic_vector(15 downto 0);
	reg_write:out std_logic;
	correct: out std_logic;

	jump_brdcst_rename_out:out std_logic_vector(5 downto 0);
	jump_brdcst_orig_destn_out:out std_logic_vector(2 downto 0);
	jump_brdcst_data_out:out std_logic_vector(15 downto 0); 
	jump_brdcst_valid_out:out std_logic;

	jump_brdcst_btag_out:out std_logic_vector(2 downto 0);

	jump_branch_mispredictor:out std_logic_vector(1 downto 0) --to be sent to RS for branch misprediction
	);
end component;
-------------------------------------------------------------------------------------------------------------------------------------------------
component rob is
  port (
		clk: in std_logic;
		reset: in std_logic;
		----------------------------------------------------------------
		--Inputs from RS
		rs_1_pc_in: in std_logic_vector(15 downto 0);
		rs_1_original_dest_code_in: in std_logic_vector(2 downto 0);
		rs_1_rename_dest_in: in std_logic_vector(5 downto 0);
		rs_1_rename_c_in: in std_logic_vector(2 downto 0);
		rs_1_rename_z_in: in std_logic_vector(2 downto 0);
		rs_1_btag_in: in std_logic_vector(2 downto 0);
		rs_1_op_code_in: in std_logic_vector(3 downto 0);
		rs_1_inst_valid_in: in std_logic;
		----------------------------------------------------------------
		--Inputs from RS
		rs_2_pc_in: in std_logic_vector(15 downto 0);
		rs_2_original_dest_code_in: in std_logic_vector(2 downto 0);
		rs_2_rename_dest_in: in std_logic_vector(5 downto 0);
		rs_2_rename_c_in: in std_logic_vector(2 downto 0);
		rs_2_rename_z_in: in std_logic_vector(2 downto 0);
		rs_2_btag_in: in std_logic_vector(2 downto 0);
		rs_2_op_code_in: in std_logic_vector(3 downto 0);
		rs_2_inst_valid_in: in std_logic;
		----------------------------------------------------------------
		--Inputs from ALU Pipeline 1
		alu_1_pc_in: in std_logic_vector(15 downto 0);
		alu_1_inst_valid_in: in std_logic;
		alu_1_rf_data_in: in std_logic_vector(15 downto 0);
		alu_1_c_flag_in: in std_logic;
		alu_1_z_flag_in: in std_logic;
		----------------------------------------------------------------
		--Inputs from ALU Pipeline 2
		alu_2_pc_in: in std_logic_vector(15 downto 0);
		alu_2_inst_valid_in: in std_logic;
		alu_2_rf_data_in: in std_logic_vector(15 downto 0);
		alu_2_c_flag_in: in std_logic;
		alu_2_z_flag_in: in std_logic;
		----------------------------------------------------------------
		--Inputs from Load/Store Pipeline
		ls_pc_in: in std_logic_vector(15 downto 0);
		ls_inst_valid_in: in std_logic;
		ls_addr_in: in std_logic_vector(15 downto 0);
		ls_data_in: in std_logic_vector(15 downto 0);
		---------------------------------------------------------------
		--Inputs from Branch Pipeline
		br_pc_in: in std_logic_vector(15 downto 0);
		br_inst_valid_in: in std_logic;
		br_btag_in: in std_logic_vector(2 downto 0);
		br_correct_in: in std_logic;
		br_data_in: in std_logic_vector(15 downto 0);
		br_self_tag_in: in std_logic_vector(2 downto 0);
		----------------------------------------------------------------
		--Output to write to RF/MEM
		--These must be asynchronous
		rf_dest_code_out: out std_logic_vector(2 downto 0);
		rf_data_out: out std_logic_vector(15 downto 0);
		rf_write_en: out std_logic;
		
		c_flag: out std_logic;
		c_flag_valid: out std_logic;

		z_flag: out std_logic;
		z_flag_valid: out std_logic;

		mem_dest_add: out std_logic_vector(15 downto 0);
		mem_dest_data_out: out std_logic_vector(15 downto 0); -- For SW
		mem_write_en: out std_logic;

		mem_data_in: in std_logic_vector(15 downto 0); -- For LHI
		----------------------------------------------------------------
		--Output to Broadcast to RS of LW/SW
		--These must be asynchronous
		broadcast_rename_reg_out: out std_logic_vector(5 downto 0);
		broadcast_original_dest_code: out std_logic_vector(2 downto 0);
		broadcast_data_out: out std_logic_vector(15 downto 0);
		broadcast_valid: out std_logic;
		broadcast_btag: out std_logic_vector(2 downto 0);
		-----------------------------------------------------------------
		--ROB Stall signal
		rob_stall_out: out std_logic
  );
end component ; -- rob
-------------------------------------------------------------------------------------------------------------------------------------------------
component memory_data is 
  port (clk : in std_logic;  
        we  : in std_logic;
        --rd	: in std_logic;   
        a   : in std_logic_vector(15 downto 0);   
        di  : in std_logic_vector(15 downto 0);   
        do  : out std_logic_vector(15 downto 0));   
end component;
-------------------------------------------------------------------------------------------------------------------------------------------------
component RF is
	port(a1, a2, a3:in std_logic_vector(2 downto 0); 
		clk,we_rf,reset:in std_logic;
		d3: in std_logic_vector(15 downto 0); 
		d1, d2, r0, r1, r2, r3, r4, r5, r6, r7:out std_logic_vector(15 downto 0));
end component;
-------------------------------------------------------------------------------------------------------------------------------------------------
component c_reg is
  port 
  (
	clk : in std_logic;
	reset: in std_logic;
	c_data_in: in std_logic;
	c_valid: in std_logic;
	c_data_out: out std_logic
  );
end component ; -- c_reg
-------------------------------------------------------------------------------------------------------------------------------------------------
component z_reg is
  port 
  (
	clk : in std_logic;
	reset: in std_logic;
	z_data_in: in std_logic;
	z_valid: in std_logic;
	z_data_out: out std_logic
  );
end component ; -- z_reg
-------------------------------------------------------------------------------------------------------------------------------------------------
  signal addr_to_mem:std_logic_vector(15 downto 0);
  signal code_mem:std_logic_vector(31 downto 0);
  --signal curr_pc_mem:std_logic_vector(15 downto 0);
  signal fetch_PC_plus_two:std_logic_vector(15 downto 0);--refers to fetch_pc_mem +2
  signal control_to_jmp:std_logic; --tells whether instr is jmp or not
  signal branch_predicted:std_logic_vector(15 downto 0);--tells us predicted branch from fetch
  signal next_pc_fetch_in:std_logic_vector(15 downto 0);--tells us whether to use pc+2 or predicted branch--to be written onto fetch register
  signal next_branch_fetch:std_logic_vector(15 downto 0);--tells us whether to use predicted or pc +2 
  --signal next_pc_mem:std_logic_vector(15 downto 0);--instr feteched next
  signal branch_mis_predicted:std_logic;--tells us to fetch branch instr from exec pipeline
  signal addr_exec:std_logic_vector(15 downto 0); --tells us the addr from exec pipeline

  signal stall_fetch_in:std_logic;--controlling the stopping of writing onto fetch state
  signal invalidate_fetch_in:std_logic;--invalidating the fetch register data
  signal instr1_fetch_valid:std_logic;--output of fetch state 1
  signal instr2_fetch_valid:std_logic;--output of fetch state 2
  signal instr1_fetch_out:std_logic_vector(15 downto 0);--output instr2 from fetch
  signal instr2_fetch_out:std_logic_vector(15 downto 0);--output instr2 from fetch

  signal fetch_pc_out: std_logic_vector(15 downto 0);--output pc from fetch
  

  signal stall_decode_in: std_logic; --stalls the deode stage fetch
  signal decode_current_BTAG: std_logic_vector(2 downto 0);
  --signal
  signal decode_invalidate_in:std_logic;--invalidating all instr in decode state
  signal instr1_decode_valid:std_logic;
  
  signal instr1_decode_op_code:std_logic_vector(3 downto 0);
  signal instr1_decode_op_cz:std_logic_vector(1 downto 0);
  signal instr1_decode_destn_code:std_logic_vector(2 downto 0);
  signal instr1_decode_op1_code:std_logic_vector(2 downto 0);
  signal instr1_decode_op2_code:std_logic_vector(2 downto 0);
  signal instr1_decode_imm:std_logic_vector(15 downto 0);
  signal instr1_decode_PC:std_logic_vector(15 downto 0);
  signal instr1_decode_next_PC:std_logic_vector(15 downto 0);
  signal instr1_decode_btag:std_logic_vector(2 downto 0);
  signal instr1_decode_self_tag:std_logic_vector(2 downto 0);
  
  signal instr1_RS_valid_in:std_logic;


  signal instr2_decode_valid:std_logic;
  
  signal instr2_decode_op_code:std_logic_vector(3 downto 0);
  signal instr2_decode_op_cz:std_logic_vector(1 downto 0);
  signal instr2_decode_destn_code:std_logic_vector(2 downto 0);
  signal instr2_decode_op1_code:std_logic_vector(2 downto 0);
  signal instr2_decode_op2_code:std_logic_vector(2 downto 0);
  signal instr2_decode_imm:std_logic_vector(15 downto 0);
  signal instr2_decode_PC:std_logic_vector(15 downto 0);
  signal instr2_decode_next_PC:std_logic_vector(15 downto 0);
  signal instr2_decode_btag:std_logic_vector(2 downto 0);
  signal instr2_decode_self_tag:std_logic_vector(2 downto 0);
  
  signal instr2_RS_valid_in:std_logic;

  signal decode_stall_out:std_logic;


--  signal broadcast_branch_decode_valid: std_logic; -----------------------------
--
--  signal broadcast_branch_btag_in: std_logic_vector(2 downto 0);
--  signal broadcast_branch_self_tag_in:std_logic_vector(2 downto 0);


--output signals from scheduler
 
  signal alu_valid_done1_RS:std_logic;
  signal alu_done_number1_RS:std_logic_vector(3 downto 0);
  
  signal alu_valid_done2_RS:std_logic;
  signal alu_done_number2_RS:std_logic_vector(3 downto 0);

  signal ls_valid_done_RS:std_logic;
  signal ls_done_number_RS:std_logic_vector(3 downto 0);

  signal jmp_valid_done_RS:std_logic;
  signal jmp_done_number_RS:std_logic_vector(3 downto 0);


  signal stall_reservation_center:std_logic; --signal used to control reservation center update



 --input signals from execution pipeline and after mem state
 
  
  signal broadcast1_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast1_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast1_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast1_valid: std_logic;--refers whether broadcasted data is valid or not

  signal broadcast1_c_flag: std_logic;
  signal broadcast1_c_flag_rename:std_logic_vector(2 downto 0);
  signal broadcast1_c_flag_valid: std_logic;

  signal broadcast1_z_flag: std_logic;
  signal broadcast1_z_flag_rename:std_logic_vector(2 downto 0);
  signal broadcast1_z_flag_valid: std_logic;

  signal broadcast1_btag: std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       


  signal broadcast2_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast2_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast2_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast2_valid: std_logic;--refers whether broadcasted data is valid or not 
       

  signal broadcast2_c_flag:std_logic;
  signal broadcast2_c_flag_rename:std_logic_vector(2 downto 0);
  signal broadcast2_c_flag_valid: std_logic;

  signal broadcast2_z_flag: std_logic;
  signal broadcast2_z_flag_rename: std_logic_vector(2 downto 0);
  signal broadcast2_z_flag_valid: std_logic;

  signal broadcast2_btag: std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies


  signal broadcast3_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast3_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast3_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast3_valid:  std_logic;--refers whether broadcasted data is valid or not 
       -- 
  signal broadcast3_btag: std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies
       
       
  signal broadcast4_rename: std_logic_vector(5 downto 0);--refers to rename register broadcasted
  signal broadcast4_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register
  signal broadcast4_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast4_valid: std_logic;--refers whether broadcasted data is valid or not 
       
       
  signal broadcast4_c_flag: std_logic;
  signal broadcast4_c_flag_rename: std_logic_vector(2 downto 0);
  signal broadcast4_c_flag_valid: std_logic;

  signal broadcast4_z_flag: std_logic;
  signal broadcast4_z_flag_rename: std_logic_vector(2 downto 0);
  signal broadcast4_z_flag_valid: std_logic;

  signal broadcast4_btag:std_logic_vector(2 downto 0);--refers to btag of branch signal useful for updating branch copies

  signal branch_mispredict_broadcast: std_logic_vector(1 downto 0); --00 implies no misprediction 01 implies first branch mispredicted 10 implies second branch mispredicted

  --if 

  signal broadcast5_rename: std_logic_vector(5 downto 0);
  signal broadcast5_orig_destn: std_logic_vector(2 downto 0);--used if a broadcast signal matches with arrival of other instr with same src register 
  signal broadcast5_data: std_logic_vector(15 downto 0); --refers to data of rename register broadcasted
  signal broadcast5_valid: std_logic;--refers whether broadcasted data is valid or not \
  signal broadcast5_btag :std_logic_vector(2 downto 0);


  signal rs_arf_rename_valid_out: slv_array_t(0 to 7);-- not required if value is valid rename cannot be valid
  --signal arf_reg_name:array(0 to 29) of std_logic_vector(2 downto 0);
  signal rs_arf_reg_rename_out: slv6_array_t(0 to 7);
  signal rs_arf_reg_value_out: slv16_array_t(0 to 7);--refers to value stored 
  signal rs_arf_value_valid_out: slv_array_t(0 to 7);
  signal rs_free_reg_out: std_logic_vector (15 downto 0);--denotes which rename registers are free 


  signal rs_carry_value_valid_out: std_logic;
  signal rs_zero_value_valid_out: std_logic;

  signal rs_carry_value_out: std_logic;
  signal rs_zero_value_out: std_logic;



  signal rs_carry_rename_rf_out: std_logic_vector(2 downto 0);--stores to which rename carry flag is currently renamed
  signal rs_zero_rename_rf_out: std_logic_vector(2 downto 0); --stores to which rename zero flag is currently renamed

  signal rs_free_flag_zero_out: std_logic;-- whether 2 zero registers are free
  signal rs_free_flag_carry_out: std_logic;--whether 2 carry registers are free

  signal rs_free_rename_carry_out: std_logic_vector(7 downto 0);--which of 7 rename carry flags are free
  signal rs_free_rename_zero_out: std_logic_vector(7 downto 0);--which of 7 rename zero flags are free
       


  --output signals from Reservation center to ROB
  
  signal curr_instr1_valid_rob: std_logic;
  signal curr_pc1_rob: std_logic_vector(15 downto 0);
  signal destn_code1_rob: std_logic_vector(2 downto 0);
  signal op_code1_rob: std_logic_vector(3 downto 0);
  signal destn_rename1_rob: std_logic_vector(5 downto 0);
  signal destn_rename_c1_rob: std_logic_vector(2 downto 0);
  signal destn_rename_z1_rob: std_logic_vector(2 downto 0);
  signal destn_btag1_rob: std_logic_vector(2 downto 0);
  signal destn_self_tag1_rob: std_logic_vector(2 downto 0);

  signal curr_instr2_valid_rob: std_logic;
  signal curr_pc2_rob: std_logic_vector(15 downto 0);
  signal destn_code2_rob: std_logic_vector(2 downto 0);
  signal op_code2_rob: std_logic_vector(3 downto 0);
  signal destn_rename2_rob: std_logic_vector(5 downto 0);
  signal destn_rename_c2_rob: std_logic_vector(2 downto 0);
  signal destn_rename_z2_rob: std_logic_vector(2 downto 0);
  signal destn_btag2_rob: std_logic_vector(2 downto 0);
  signal destn_self_tag2_rob: std_logic_vector(2 downto 0);

  ---output signals to scheduler



  signal alu_instr_valid: slv_array_t(0 to 9);
  signal alu_op_code: slv4_array_t(0 to 9);
  signal alu_op_code_cz: slv2_array_t(0 to 9);
  signal alu_destn_rename_code: slv6_array_t(0 to 9);
  signal alu_operand1: slv16_array_t(0 to 9);
  signal alu_valid1: slv_array_t(0 to 9);

  signal alu_operand2: slv16_array_t(0 to 9);
  signal alu_valid2: slv_array_t(0 to 9);

  signal alu_operand3: slv16_array_t(0 to 9);
  signal alu_valid3: slv_array_t(0 to 9);

  signal alu_c_flag: slv_array_t(0 to 9);
  signal alu_c_flag_rename: slv3_array_t(0 to 9);
  signal alu_c_flag_valid: slv_array_t(0 to 9);
  signal alu_c_flag_destn_addr: slv3_array_t(0 to 9);

  signal alu_z_flag: slv_array_t(0 to 9);
  signal alu_z_flag_rename: slv3_array_t(0 to 9);
  signal alu_z_flag_valid: slv_array_t(0 to 9);
  signal alu_z_flag_destn_addr: slv3_array_t(0 to 9);

  signal alu_btag: slv3_array_t(0 to 9);

  signal alu_orign_destn: slv3_array_t(0 to 9);

  signal alu_curr_pc: slv16_array_t(0 to 9);

  signal alu_scheduler_valid: slv_array_t(0 to 9);       


  signal ls_instr_valid: slv_array_t(0 to 9);
  signal ls_op_code: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
  signal ls_destn_rename_code: slv6_array_t(0 to 9);
  signal ls_operand1: slv16_array_t(0 to 9);
  signal ls_valid1: slv_array_t(0 to 9);

  signal ls_operand2: slv16_array_t(0 to 9);
  signal ls_valid2: slv_array_t(0 to 9);


  signal ls_operand3: slv16_array_t(0 to 9);--denotes which register to load onto or store from
  signal ls_valid3: slv_array_t(0 to 9);

       
  signal ls_btag: slv3_array_t(0 to 9);

  signal ls_orign_destn: slv3_array_t(0 to 9);

  signal ls_curr_pc: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


  signal ls_scheduler_valid: slv_array_t(0 to 9);


   --instr of jump to jump scheduler
       


   signal jmp_instr_valid: slv_array_t(0 to 9);
   signal jmp_op_code: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
   signal jmp_destn_rename_code: slv6_array_t(0 to 9);
   signal jmp_operand1: slv16_array_t(0 to 9);
   signal jmp_valid1: slv_array_t(0 to 9);

   signal jmp_operand2: slv16_array_t(0 to 9);
   signal jmp_valid2: slv_array_t(0 to 9);


   signal jmp_operand3:slv16_array_t(0 to 9);--denotes which register to load onto or store from
   signal jmp_valid3: slv_array_t(0 to 9);

       
   signal jmp_btag: slv3_array_t(0 to 9);

   signal jmp_orign_destn:slv3_array_t(0 to 9);

   signal jmp_curr_pc: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


   signal jmp_scheduler_valid: slv_array_t(0 to 9);
   signal jmp_next_pc: slv16_array_t(0 to 9);

   signal jmp_self_tag: slv3_array_t(0 to 9);



   signal  halt_out_RS: std_logic;--instr could not be written onto RS


     ----added a reset stage after addr to memory  
--------------------------------------------------------------------------------------------------------------------------------------------
--Scheduler left output signals(RS valid and number is already an=bove not repeated)  
  signal alu_sch_stall_in: std_logic;
  
  signal alu_sch_instr_valid_out_1: std_logic;
  signal alu_sch_op_code_out_1: std_logic_vector(3 downto 0);
  signal alu_sch_op_code_cz_out_1: std_logic_vector(1 downto 0);
  
  signal alu_sch_original_dest_out_1: std_logic_vector(2 downto 0);
  signal alu_sch_rename_dest_out_1: std_logic_vector(5 downto 0);
  
  signal alu_sch_operand_1_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_2_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_3_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_c_flag_out_1: std_logic;
  signal alu_sch_c_flag_rename_out_1: std_logic_vector(2 downto 0);

  signal alu_sch_z_flag_out_1: std_logic;
  signal alu_sch_z_flag_rename_out_1: std_logic_vector(2 downto 0);

  signal alu_sch_pc_out_1: std_logic_vector(15 downto 0);
  
  signal alu_sch_btag_out_1: std_logic_vector(2 downto 0);
  -------------------------------------------------------------------------------------------
  --2 copies as 2 pipelines
  signal alu_sch_instr_valid_out_2: std_logic;
  signal alu_sch_op_code_out_2: std_logic_vector(3 downto 0);
  signal alu_sch_op_code_cz_out_2: std_logic_vector(1 downto 0);
  
  signal alu_sch_original_dest_out_2: std_logic_vector(2 downto 0);
  signal alu_sch_rename_dest_out_2: std_logic_vector(5 downto 0);
  
  signal alu_sch_operand_1_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_2_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_operand_3_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_c_flag_out_2: std_logic;
  signal alu_sch_c_flag_rename_out_2: std_logic_vector(2 downto 0);

  signal alu_sch_z_flag_out_2: std_logic;
  signal alu_sch_z_flag_rename_out_2: std_logic_vector(2 downto 0);

  signal alu_sch_pc_out_2: std_logic_vector(15 downto 0);
  
  signal alu_sch_btag_out_2: std_logic_vector(2 downto 0);
  
  ----------------------------------------------------------------------------------
  signal ls_sch_stall_in: std_logic;

  -- Execute Pipepline output
  signal ls_sch_instr_valid_out: std_logic;
  signal ls_sch_op_code_out: std_logic_vector(3 downto 0);
  signal ls_sch_original_dest_out: std_logic_vector(2 downto 0);
  signal ls_sch_rename_dest_out: std_logic_vector(5 downto 0);
  signal ls_sch_operand_1_out: std_logic_vector(15 downto 0);
  signal ls_sch_operand_2_out: std_logic_vector(15 downto 0);
  signal ls_sch_operand_3_out: std_logic_vector(15 downto 0);
  signal ls_sch_pc_out: std_logic_vector(15 downto 0);
  signal ls_sch_btag_out: std_logic_vector(2 downto 0);
  ----------------------------------------------------------------------------------
  signal br_sch_stall_in: std_logic;

  --Execute pipeline branch input
  signal br_sch_instr_valid_out: std_logic;
  signal br_sch_op_code_out: std_logic_vector(3 downto 0);
  signal br_sch_original_dest_out: std_logic_vector(2 downto 0);
  signal br_sch_rename_dest_out: std_logic_vector(5 downto 0);
  signal br_sch_operand_1_out: std_logic_vector(15 downto 0);
  
  signal br_sch_operand_2_out: std_logic_vector(15 downto 0);
  
  signal br_sch_operand_3_out: std_logic_vector(15 downto 0);
  
  signal br_sch_pc_out: std_logic_vector(15 downto 0);
  signal br_sch_nxt_pc_out: std_logic_vector(15 downto 0);
  
  signal br_sch_btag_out: std_logic_vector(2 downto 0);
  signal br_sch_self_tag_out: std_logic_vector(2 downto 0);
  ------------------------------------------------------------------------------------------------------------------------------------------
  signal ls_sch_z_flag_rename_temp_out: std_logic_vector(2 downto 0);
  signal ls_sch_z_flag_temp_out: std_logic;
  signal lw_c_flag_temp: std_logic;
  signal lw_c_flag_rename_temp: std_logic_vector(2 downto 0);
  signal lw_c_flag_valid_temp: std_logic;
  signal lw_z_flag_temp: std_logic;
  signal lw_z_flag_rename_temp: std_logic_vector(2 downto 0);
  signal lw_z_flag_valid_temp: std_logic;
  -------------------------------------------------------------------------------------------------------------
  signal alu_pip1_data_out: std_logic_vector(15 downto 0);
  signal alu_pip1_valid_out: std_logic;
  signal alu_pip1_op_code_out: std_logic_vector(3 downto 0);
  signal alu_pip1_destn_rename_code_out: std_logic_vector(5 downto 0);
  signal alu_pip1_c_flag_out: std_logic;
  signal alu_pip1_z_flag_out: std_logic;
  signal alu_pip1_c_rename_out: std_logic_vector(2 downto 0);
  signal alu_pip1_z_rename_out: std_logic_vector(2 downto 0);
  signal alu_pip1_btag_out: std_logic_vector(2 downto 0);
  signal alu_pip1_orig_destn_out: std_logic_vector(2 downto 0);
  signal alu_pip1_curr_pc_out: std_logic_vector(15 downto 0);
-------------------------------------------------------------------------------------------------------------
  signal alu_pip2_data_out: std_logic_vector(15 downto 0);
  signal alu_pip2_valid_out: std_logic;
  signal alu_pip2_op_code_out: std_logic_vector(3 downto 0);
  signal alu_pip2_destn_rename_code_out: std_logic_vector(5 downto 0);
  signal alu_pip2_c_flag_out: std_logic;
  signal alu_pip2_z_flag_out: std_logic;
  signal alu_pip2_c_rename_out: std_logic_vector(2 downto 0);
  signal alu_pip2_z_rename_out: std_logic_vector(2 downto 0);
  signal alu_pip2_b_tag_out: std_logic_vector(2 downto 0);
  signal alu_pip2_orig_destn_out: std_logic_vector(2 downto 0);
  signal alu_pip2_curr_pc_out: std_logic_vector(15 downto 0);
-------------------------------------------------------------------------------------------------------------
  signal ls_pip_addr_out: std_logic_vector(15 downto 0);
  signal ls_pip_data_out: std_logic_vector(15 downto 0);--refers to immediate data in case of LHI
  signal ls_pip_valid_out: std_logic; 
  signal ls_pip_op_code_out: std_logic_vector(3 downto 0);
  signal ls_pip_destn_rename_out: std_logic_vector(5 downto 0);
  --c_flag_out:out std_logic;
  signal ls_pip_z_flag_out: std_logic; 
  --c_rename_out:out std_logic_vector(3 downto 0);
  signal ls_pip_z_rename_out: std_logic_vector(2 downto 0);
  signal ls_pip_b_tag_out: std_logic_vector(2 downto 0);
  signal ls_pip_orig_destn_out: std_logic_vector(2 downto 0);
  signal ls_pip_curr_pc_out: std_logic_vector(15 downto 0);
-------------------------------------------------------------------------------------------------------------
  signal br_pip_data_out: std_logic_vector(15 downto 0);
  signal br_pip_valid_out: std_logic;
  signal br_pip_op_code_out: std_logic_vector(3 downto 0);
  signal br_pip_destn_rename_code_out: std_logic_vector(5 downto 0);
  --c_flag_out:out std_logic;
  --z_flag_out:out std_logic;
  --c_rename_out:out std_logic_vector(3 downto 0);
  --z_rename_out: out std_logic_vector(3 downto 0);
  signal br_pip_b_tag_out: std_logic_vector(2 downto 0);
  signal br_pip_orig_destn_out: std_logic_vector(2 downto 0);
  signal br_pip_curr_pc_out: std_logic_vector(15 downto 0);
  signal br_pip_self_branch_tag_out: std_logic_vector(2 downto 0);
  signal br_pip_branch_addr: std_logic_vector(15 downto 0);
  signal br_pip_reg_write: std_logic;
  signal br_pip_correct: std_logic;
-------------------------------------------------------------------------------------------------------------
  signal rob_rf_dest_code_out: std_logic_vector(2 downto 0);
  signal rob_rf_data_out: std_logic_vector(15 downto 0);
  signal rob_rf_write_en: std_logic;
  
  signal rob_c_flag: std_logic;
  signal rob_c_flag_valid: std_logic;

  signal rob_z_flag: std_logic;
  signal rob_z_flag_valid: std_logic;

  signal rob_mem_dest_add: std_logic_vector(15 downto 0);
  signal rob_mem_dest_data_out: std_logic_vector(15 downto 0); -- For SW
  signal rob_mem_write_en: std_logic;

  signal rob_mem_data_in: std_logic_vector(15 downto 0); -- For LHI
  --ROB Stall signal
  signal rob_stall_out: std_logic;
-------------------------------------------------------------------------------------------------------------
  signal rf_a1: std_logic_vector(2 downto 0);
  signal rf_a2: std_logic_vector(2 downto 0);
  signal rf_d1: std_logic_vector(15 downto 0);
  signal rf_d2: std_logic_vector(15 downto 0);
 begin
 
 memory_instance: memory_code port map

                        (
                          clk=>top_clock,
                          we=>'0',
                          a=>addr_to_mem,
                          do=>code_mem,
                          di=>(others=>'0'));

 mux_instance3: bit16_2x1 port map(  --used for reset
              
               c_0=>system_reset,
               d_0=>next_pc_fetch_in,
               d_1=>(others=>'0'),
               o=>addr_to_mem

 	           );


 mux_instance4: bit1_2x1 port map(  --used for invalidating decode
              
               c_0=>decode_invalidate_in,
               d_0=>instr1_decode_valid,
               d_1=>'0',
               o=>instr1_RS_valid_in

 	           );

 mux_instance5: bit1_2x1 port map(  --used for invalidating decode
              
               c_0=>decode_invalidate_in,
               d_0=>instr2_decode_valid,
               d_1=>'0',
               o=>instr2_RS_valid_in

 	           );

                         


 add_instance1:add_pc port map(

 	PC_in=>fetch_pc_out,
 	PC_out=>fetch_PC_plus_two
 	
 );

 mux_instance1: bit16_2x1 port map( --used to choose between predicted reisters and branch address
              
               c_0=>control_to_jmp,
               d_0=>fetch_PC_plus_two,
               d_1=>branch_predicted,
               o=>next_branch_fetch

 	           );

 mux_instance2: bit16_2x1 port map( --used for misprediction correction
              
               c_0=>branch_mis_predicted,
               d_0=>next_branch_fetch,
               d_1=>br_pip_branch_addr,
               o=>next_pc_fetch_in
);

  fetch_instance:fetch port map(
       
    clk=>top_clock,
	Mem_in=>code_mem,
	PC_in=>addr_to_mem,

	stall_in=>stall_fetch_in,
	instr_invalidate_in=> '0',
	------------------------------------------------------------
	inst_1_valid=>instr1_fetch_valid,
	inst_2_valid=>instr2_fetch_valid,
	Instr1=>instr1_fetch_out,
	Instr2=>instr2_fetch_out,
	PC=>fetch_pc_out

 );


  decode_instance:decode port map(
   

	clk=>top_clock,
	reset=>system_reset,
	inst_1_valid_in=>instr1_fetch_valid,
	inst_2_valid_in=>instr2_fetch_valid,
	Instr1_in=>instr1_fetch_out,
	Instr2_in=>instr2_fetch_out,
	PC_in=>fetch_pc_out,
	Nxt_PC_in=> next_pc_fetch_in,

    br_inst_valid_in=>br_pip_valid_out,
	br_btag_in=>br_pip_b_tag_out,
	br_self_tag_in=>br_pip_self_branch_tag_out,


	stall_in=>stall_decode_in,
	instr_invalidate_in=>invalidate_fetch_in, --as invalidation happens of it on next pipeline register
	------------------------------------------------------------
	--Instruction 1
	I1_valid=>instr1_decode_valid,
	I1_op_code=>instr1_decode_op_code,
	I1_op_cz=>instr1_decode_op_cz,
	I1_dest_code=>instr1_decode_destn_code,
	I1_operand_1_code=>instr1_decode_op1_code,
	I1_operand_2_code=>instr1_decode_op2_code,
	I1_Imm=>instr1_decode_imm,
	I1_PC=>instr1_decode_PC,
	I1_Nxt_PC=>instr1_decode_next_PC,
	I1_BTAG=>instr1_decode_btag,
	I1_self_tag=>instr1_decode_self_tag,

	--Instruction 2
	I2_valid=>instr2_decode_valid,
	I2_op_code=>instr2_decode_op_code,
	I2_op_cz=>instr2_decode_op_cz,
	I2_dest_code=>instr2_decode_destn_code,
	I2_operand_1_code=>instr2_decode_op1_code,
	I2_operand_2_code=>instr2_decode_op2_code,
	I2_Imm=>instr2_decode_imm,
	I2_PC=>instr2_decode_PC,
	I2_Nxt_PC=>instr2_decode_next_PC,
	I2_BTAG=>instr2_decode_btag,
	I2_self_tag=>instr2_decode_self_tag,

	-----------------------------------
	stall_out=>decode_stall_out,
  current_BTAG_out=>decode_current_BTAG
  );

  

      RS :reservation_state port map(

       instr1_valid_in=>instr1_RS_valid_in,
 	   op_code1_in=>instr1_decode_op_code,
 	   op_cz1_in=>instr1_decode_op_cz,
 	   destn_code1_in=>instr1_decode_destn_code,
 	   opr1_code1_in=>instr1_decode_op1_code,
 	   opr2_code1_in=>instr1_decode_op2_code,
	   opr3_code1_in=>instr1_decode_destn_code,
 	   curr_pc1_in=>instr1_decode_PC,
 	   next_pc1_in=>instr1_decode_next_PC,
 	   imm1_in=>instr1_decode_imm,
 	   btag1_in=>instr1_decode_btag,
 	   self1_tag_in=>instr1_decode_self_tag,

       instr2_valid_in=>instr2_RS_valid_in,
 	   op_code2_in=>instr2_decode_op_code,
 	   op_cz2_in=>instr2_decode_op_cz,
 	   destn_code2_in=>instr2_decode_destn_code,
 	   opr1_code2_in=>instr2_decode_op1_code,
 	   opr2_code2_in=>instr2_decode_op2_code,
	   opr3_code2_in=>instr2_decode_destn_code,
 	   curr_pc2_in=>instr2_decode_PC,
 	   next_pc2_in=>instr2_decode_next_PC,
 	   imm2_in=>instr2_decode_imm,
 	   btag2_in=>instr2_decode_btag,
 	   self2_tag_in=>instr2_decode_self_tag,

       alu_valid_done1_in=>alu_valid_done1_RS,
       alu_done_number1=>alu_done_number1_RS,

       alu_valid_done2_in=>alu_valid_done2_RS,
       alu_done_number2=>alu_done_number2_RS,

       ls_valid_done_in=>ls_valid_done_RS,
       ls_done_number=>ls_done_number_RS,

       jmp_valid_done_in=>jmp_valid_done_RS,
       jmp_done_number=>jmp_done_number_RS,

         

 	   reset_system=>system_reset,--to be done at start of cycle general reset which assigns all registers its original values
 	   --reset_system_mapping:in std_logic;--to be used to clear all assigned ARF and RRF's 
       clk_input=>top_clock,
       stall_reservation_update=>stall_reservation_center,--no data comes to reservation station if becomes 1


       broadcast1_rename_in=>broadcast1_rename,--refers to rename register broadcasted
       broadcast1_orig_destn_in=>broadcast1_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast1_data_in=>broadcast1_data, --refers to data of rename register broadcasted
       broadcast1_valid_in=>broadcast1_valid,--refers whether broadcasted data is valid or not

       broadcast1_c_flag_in=>broadcast1_c_flag,
       broadcast1_c_flag_rename_in=>broadcast1_c_flag_rename,
       broadcast1_c_flag_valid_in=>broadcast1_c_flag_valid,

       broadcast1_z_flag_in=>broadcast1_z_flag,
       broadcast1_z_flag_rename_in=>broadcast1_z_flag_rename,
       broadcast1_z_flag_valid_in=>broadcast1_z_flag_valid,

       broadcast1_btag_in=>broadcast1_btag, --refers to btag of branch signal useful for updating branch copies
       


       broadcast2_rename_in=>broadcast2_rename,--refers to rename register broadcasted
       broadcast2_orig_destn_in=>broadcast2_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast2_data_in=>broadcast2_data, --refers to data of rename register broadcasted
       broadcast2_valid_in=>broadcast2_valid,--refers whether broadcasted data is valid or not 
       

       broadcast2_c_flag_in=>broadcast2_c_flag,
       broadcast2_c_flag_rename_in=>broadcast2_c_flag_rename,
       broadcast2_c_flag_valid_in=>broadcast2_c_flag_valid,

       broadcast2_z_flag_in=>broadcast2_z_flag,
       broadcast2_z_flag_rename_in=>broadcast2_z_flag_rename,
       broadcast2_z_flag_valid_in=>broadcast2_z_flag_valid,

       broadcast2_btag_in=>broadcast2_btag,--refers to btag of branch signal useful for updating branch copies


       broadcast3_rename_in=>broadcast3_rename,--refers to rename register broadcasted
       broadcast3_orig_destn_in=>broadcast3_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast3_data_in=>broadcast3_data, --refers to data of rename register broadcasted
       broadcast3_valid_in=>broadcast3_valid,--refers whether broadcasted data is valid or not 
       -- 
       broadcast3_btag_in=>broadcast3_btag,--refers to btag of branch signal useful for updating branch copies
       
       
       broadcast4_rename_in=>broadcast4_rename,--refers to rename register broadcasted
       broadcast4_orig_destn_in=>broadcast4_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
       broadcast4_data_in=>broadcast4_data, --refers to data of rename register broadcasted
       broadcast4_valid_in=>broadcast4_valid,--refers whether broadcasted data is valid or not 
       
       
       broadcast4_c_flag_in=>broadcast4_c_flag,
       broadcast4_c_flag_rename_in=>broadcast4_c_flag_rename,
       broadcast4_c_flag_valid_in=>broadcast4_c_flag_valid,

       broadcast4_z_flag_in=>broadcast4_z_flag,
       broadcast4_z_flag_rename_in=>broadcast4_z_flag_rename,
       broadcast4_z_flag_valid_in=>broadcast4_z_flag_valid,

       broadcast4_btag_in=>broadcast4_btag,--refers to btag of branch signal useful for updating branch copies

       branch_mispredict_broadcast_in=>branch_mispredict_broadcast, --00 implies no misprediction 01 implies first branch mispredicted 10 implies second branch mispredicted


       broadcast5_rename_in=>broadcast5_rename,
       broadcast5_orig_destn_in=>broadcast5_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register 
       broadcast5_data_in=>broadcast5_data, --refers to data of rename register broadcasted
       broadcast5_valid_in=>broadcast5_valid,--refers whether broadcasted data is valid or not \
       broadcast5_btag_in=>broadcast5_btag,

       arf_rename_valid_out=> rs_arf_rename_valid_out,-- not required if value is valid rename cannot be valid
       --signal arf_reg_name:array(0 to 29) of std_logic_vector(2 downto 0);
       arf_reg_rename_out=> rs_arf_reg_rename_out,
       arf_reg_value_out=> rs_arf_reg_value_out,--refers to value stored 
       arf_value_valid_out=> rs_arf_value_valid_out,
       free_reg_out=> rs_free_reg_out,--denotes which rename registers are free 


       carry_value_valid_out=> rs_carry_value_valid_out,
       zero_value_valid_out=> rs_zero_value_valid_out,

       carry_value_out=> rs_carry_value_out,
       zero_value_out=> rs_zero_value_out,



       carry_rename_rf_out=> rs_carry_rename_rf_out,--stores to which rename carry flag is currently renamed
       zero_rename_rf_out=> rs_zero_rename_rf_out, --stores to which rename zero flag is currently renamed

       free_flag_zero_out=> rs_free_flag_zero_out,-- whether 2 zero registers are free
       free_flag_carry_out=> rs_free_flag_carry_out,--whether 2 carry registers are free

       free_rename_carry_out=> rs_free_rename_carry_out,--which of 7 rename carry flags are free
       free_rename_zero_out=> rs_free_rename_zero_out,--which of 7 rename zero flags are free
            
       --entry in ROB output

       curr_instr1_valid_rob_out=>curr_instr1_valid_rob,
       curr_pc1_rob_out=>curr_pc1_rob,
       destn_code1_rob_out=>destn_code1_rob,
       op_code1_rob_out=>op_code1_rob,
       destn_rename1_rob_out=>destn_rename1_rob,
       destn_rename_c1_rob_out=>destn_rename_c1_rob,
       destn_rename_z1_rob_out=>destn_rename_z1_rob,
       destn_btag1_rob_out=>destn_btag1_rob,
       destn_self_tag1_rob_out=>destn_self_tag1_rob,

       curr_instr2_valid_rob_out=>curr_instr2_valid_rob,
       curr_pc2_rob_out=>curr_pc2_rob,
       destn_code2_rob_out=>destn_code2_rob,
       op_code2_rob_out=>op_code2_rob,
       destn_rename2_rob_out=>destn_rename2_rob,
       destn_rename_c2_rob_out=>destn_rename_c2_rob,
       destn_rename_z2_rob_out=>destn_rename_z2_rob,
       destn_btag2_rob_out=>destn_btag2_rob,
       destn_self_tag2_rob_out=>destn_self_tag2_rob,



       alu_instr_valid_out=>alu_instr_valid,
       alu_op_code_out=>alu_op_code,
       alu_op_code_cz_out=>alu_op_code_cz,
       alu_destn_rename_code_out=>alu_destn_rename_code,
       alu_operand1_out=>alu_operand1,
       alu_valid1_out=>alu_valid1,

       alu_operand2_out=>alu_operand2,
       alu_valid2_out=>alu_valid2,

       alu_operand3_out=>alu_operand3,
       alu_valid3_out=>alu_valid3,

       alu_c_flag_out=>alu_c_flag,
       alu_c_flag_rename_out=>alu_c_flag_rename,
       alu_c_flag_valid_out=>alu_c_flag_valid,
       alu_c_flag_destn_addr_out=>alu_c_flag_destn_addr,

       alu_z_flag_out=>alu_z_flag,
       alu_z_flag_rename_out=>alu_z_flag_rename,
       alu_z_flag_valid_out=>alu_z_flag_valid,
       alu_z_flag_destn_addr_out=>alu_z_flag_destn_addr,

       alu_btag_out=>alu_btag,

       alu_orign_destn_out=>alu_orign_destn,

       alu_curr_pc_out=>alu_curr_pc,

       alu_scheduler_valid_out=>alu_scheduler_valid,       


       ls_instr_valid_out=>ls_instr_valid,
       ls_op_code_out=>ls_op_code,
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       ls_destn_rename_code_out=>ls_destn_rename_code,
       ls_operand1_out=>ls_operand1,
       ls_valid1_out=>ls_valid1,

       ls_operand2_out=>ls_operand2,
       ls_valid2_out=>ls_valid2,


       ls_operand3_out=>ls_operand3,--denotes which register to load onto or store from
       ls_valid3_out=>ls_valid3,

       
       ls_btag_out=>ls_btag,

       ls_orign_destn_out=>ls_orign_destn,

       ls_curr_pc_out=>ls_curr_pc,
       --ls_imm_out:out slv16_array_t(0 to 9);


       ls_scheduler_valid_out=>ls_scheduler_valid,



       jmp_instr_valid_out=>jmp_instr_valid,
       jmp_op_code_out=>jmp_op_code,
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       jmp_destn_rename_code_out=>jmp_destn_rename_code,
       jmp_operand1_out=>jmp_operand1,
       jmp_valid1_out=>jmp_valid1,

       jmp_operand2_out=>jmp_operand2,
       jmp_valid2_out=>jmp_valid2,


       jmp_operand3_out=>jmp_operand3,--denotes which register to load onto or store from
       jmp_valid3_out=>jmp_valid3,

       
       jmp_btag_out=>jmp_btag,

       jmp_orign_destn_out=>jmp_orign_destn,

       jmp_curr_pc_out=>jmp_curr_pc,
       --ls_imm_out:out slv16_array_t(0 to 9);


       jmp_scheduler_valid_out=>jmp_scheduler_valid,
       jmp_next_pc_out=>jmp_next_pc,

       jmp_self_tag_out=>jmp_self_tag,



       halt_out=>halt_out_RS--instr could not be written onto RS 
       -- 
       );
------------------------------------------------------------------------------------------------------------------------------------------

ALU_SCHEDULER: alu_sch port map (
    clk => top_clock,
    reset => system_reset,

    alu_instr_valid_in => alu_instr_valid,
    alu_op_code_in => alu_op_code,
    alu_op_code_cz_in => alu_op_code_cz,
    
    alu_original_dest_in => alu_orign_destn,
    alu_rename_dest_in => alu_destn_rename_code,
    
    alu_operand_1_in => alu_operand1,
    alu_operand_1_valid_in => alu_valid1,

    alu_operand_2_in => alu_operand2,
    alu_operand_2_valid_in => alu_valid2,

    alu_operand_3_in => alu_operand3,
    alu_operand_3_valid_in => alu_valid3,

    alu_c_flag_in => alu_c_flag,
    alu_c_flag_rename_in => alu_c_flag_destn_addr,

    alu_z_flag_in => alu_z_flag,
    alu_z_flag_rename_in => alu_z_flag_destn_addr,

    alu_pc_in => alu_curr_pc,
    alu_sch_valid_in => alu_scheduler_valid,

    alu_btag_in => alu_btag,

    alu_stall_in => alu_sch_stall_in,
    --------------------------------------------------------------------------------
    -- Execute Pipepline output
    alu_instr_valid_out_1 => alu_sch_instr_valid_out_1,
    alu_op_code_out_1 => alu_sch_op_code_out_1,
    alu_op_code_cz_out_1 => alu_sch_op_code_cz_out_1,
    
    alu_original_dest_out_1 => alu_sch_original_dest_out_1,
    alu_rename_dest_out_1 => alu_sch_rename_dest_out_1,
    
    alu_operand_1_out_1 => alu_sch_operand_1_out_1,
    
    alu_operand_2_out_1 => alu_sch_operand_2_out_1 ,
    
    alu_operand_3_out_1 => alu_sch_operand_3_out_1,
    
    alu_c_flag_out_1 => alu_sch_c_flag_out_1,
    alu_c_flag_rename_out_1 => alu_sch_c_flag_rename_out_1,

    alu_z_flag_out_1 => alu_sch_z_flag_out_1,
    alu_z_flag_rename_out_1 => alu_sch_z_flag_rename_out_1,

    alu_pc_out_1 => alu_sch_pc_out_1,
    
    alu_btag_out_1 => alu_sch_btag_out_1,
    -------------------------------------------------------------------------------------------
    --2 copies as 2 pipelines
    alu_instr_valid_out_2 => alu_sch_instr_valid_out_2,
    alu_op_code_out_2 => alu_sch_op_code_out_2,
    alu_op_code_cz_out_2 => alu_sch_op_code_cz_out_2,
    
    alu_original_dest_out_2 => alu_sch_original_dest_out_2,
    alu_rename_dest_out_2 => alu_sch_rename_dest_out_2,
    
    alu_operand_1_out_2 => alu_sch_operand_1_out_2,
    
    alu_operand_2_out_2 => alu_sch_operand_2_out_2,
    
    alu_operand_3_out_2 => alu_sch_operand_3_out_2,
    
    alu_c_flag_out_2 => alu_sch_c_flag_out_2,
    alu_c_flag_rename_out_2 => alu_sch_c_flag_rename_out_2,

    alu_z_flag_out_2 => alu_sch_z_flag_out_2,
    alu_z_flag_rename_out_2 => alu_sch_z_flag_rename_out_2,

    alu_pc_out_2 => alu_sch_pc_out_2,
    
    alu_btag_out_2 => alu_sch_btag_out_2,
    --------------------------------------------------------------------------------
    -- Data going back to RS
    rs_alu_index_1_out => alu_done_number1_RS,
    rs_alu_valid_1_out => alu_valid_done1_RS,
    rs_alu_index_2_out => alu_done_number2_RS,
    rs_alu_valid_2_out => alu_valid_done2_RS
  );
------------------------------------------------------------------------------------------------------------------------------------------

LS_SCHEDULER:lw_sw_sch port map (  
        clk => top_clock,
        reset => system_reset,

        ls_instr_valid_in => ls_instr_valid,
        ls_op_code_in => ls_op_code,
        ls_original_dest_in => ls_orign_destn,
        ls_rename_dest_in => ls_destn_rename_code,
        ls_operand_1_in => ls_operand1,
        ls_operand_1_valid_in => ls_valid1,

        ls_operand_2_in => ls_operand2,
        ls_operand_2_valid_in => ls_valid2,

        ls_operand_3_in => ls_operand3,
        ls_operand_3_valid_in => ls_valid3,

        ls_pc_in => ls_curr_pc,
        ls_sch_valid_in => ls_scheduler_valid,

        ls_btag_in => ls_btag,

        ls_stall_in => ls_sch_stall_in,
        --------------------------------------------------------------------------------
        -- Execute Pipepline output
        ls_instr_valid_out => ls_sch_instr_valid_out,
        ls_op_code_out => ls_sch_op_code_out,
        ls_original_dest_out => ls_sch_original_dest_out,
        ls_rename_dest_out => ls_sch_rename_dest_out,
        ls_operand_1_out => ls_sch_operand_1_out,
        ls_operand_2_out => ls_sch_operand_2_out,
        ls_operand_3_out => ls_sch_operand_3_out,
        ls_pc_out => ls_sch_pc_out,
        ls_btag_out => ls_sch_btag_out,

        --------------------------------------------------------------------------------
        -- Data going back to RS
        rs_ls_index_out => ls_done_number_RS,
        rs_ls_valid_out => ls_valid_done_RS
        );
------------------------------------------------------------------------------------------------------------------------------------------

BRANCH_SCHEDULER: branch_sch port map (
        clk => top_clock,
        reset => system_reset,

        br_instr_valid_in => jmp_instr_valid,
        br_op_code_in => jmp_op_code,
        br_original_dest_in => jmp_orign_destn,
        br_rename_dest_in => jmp_destn_rename_code,
        br_operand_1_in => jmp_operand1,
        br_operand_1_valid_in => jmp_valid1,

        br_operand_2_in => jmp_operand2,
        br_operand_2_valid_in => jmp_valid2,

        br_operand_3_in => jmp_operand3,
        br_operand_3_valid_in => jmp_valid3,

        br_pc_in => jmp_curr_pc,
        br_nxt_pc_in => jmp_next_pc,
        br_sch_valid_in => jmp_scheduler_valid,

        br_btag_in => jmp_btag,
        br_self_tag_in => jmp_self_tag,

        br_stall_in => br_sch_stall_in,
        -----------------------------------------------------------------------------------
        --Execute pipeline branch input
        br_instr_valid_out => br_sch_instr_valid_out,
        br_op_code_out => br_sch_op_code_out,
        br_original_dest_out => br_sch_original_dest_out,
        br_rename_dest_out => br_sch_rename_dest_out,
        br_operand_1_out => br_sch_operand_1_out,-- to Ra
        
        br_operand_2_out => br_sch_operand_2_out,--refers to Rb
        
        br_operand_3_out => br_sch_operand_3_out,--refers to immediate
        
        br_pc_out => br_sch_pc_out,
        br_nxt_pc_out => br_sch_nxt_pc_out,
        
        br_btag_out => br_sch_btag_out,
        br_self_tag_out => br_sch_self_tag_out,
        --------------------------------------------------------------------------------
        -- Data going back to RS
        rs_br_index_out => jmp_done_number_RS,
        rs_br_valid_out => jmp_valid_done_RS
        );
------------------------------------------------------------------------------------------------------------------------------------------
ALU_PIPELINE_1:alu_pipeline port map
	(
	pipeline_valid_in => alu_sch_instr_valid_out_1 ,
	op_code_in => alu_sch_op_code_out_1,
	destn_rename_code_in => alu_sch_rename_dest_out_1,
	operand1 => alu_sch_operand_1_out_1,
	operand2 => alu_sch_operand_2_out_1,
	operand3 => alu_sch_operand_3_out_1,
	c_flag_in => alu_sch_c_flag_out_1,
	z_flag_in => alu_sch_z_flag_out_1,
	c_rename_in => alu_sch_c_flag_rename_out_1,
	z_rename_in => alu_sch_z_flag_rename_out_1,
	b_tag_in => alu_sch_btag_out_1,
	orig_destn_in => alu_sch_original_dest_out_1,
	op_code_cz => alu_sch_op_code_cz_out_1,
	curr_pc_in => alu_sch_pc_out_1,

	data_out => alu_pip1_data_out,
	pipeline_valid_out => alu_pip1_valid_out,
	op_code_out => alu_pip1_op_code_out,
	destn_rename_code_out => alu_pip1_destn_rename_code_out,
	c_flag_out => alu_pip1_c_flag_out,
	z_flag_out => alu_pip1_z_flag_out,
	c_rename_out => alu_pip1_c_rename_out,
	z_rename_out => alu_pip1_z_rename_out,
	b_tag_out => alu_pip1_btag_out,
	orig_destn_out => alu_pip1_orig_destn_out,
	curr_pc_out => alu_pip1_curr_pc_out,

	alu_brdcst_rename_out => broadcast1_rename ,
	alu_brdcst_orig_destn_out => broadcast1_orig_destn,
	alu_brdcst_data_out => broadcast1_data,
	alu_brdcst_valid_out => broadcast1_valid,

	alu_brdcst_c_flag_out => broadcast1_c_flag,
	alu_brdcst_c_flag_rename_out => broadcast1_c_flag_rename,
	alu_brdcst_c_flag_valid_out => broadcast1_c_flag_valid,

	alu_brdcst_z_flag_out => broadcast1_z_flag,
	alu_brdcst_z_flag_rename_out => broadcast1_z_flag_rename,
	alu_brdcst_z_flag_valid_out => broadcast1_z_flag_valid,

	alu_brdcst_btag_out => broadcast1_btag
	);
------------------------------------------------------------------------------------------------------------------------------------------
ALU_PIPELINE_2:alu_pipeline port map
	(
	pipeline_valid_in => alu_sch_instr_valid_out_2,
	op_code_in => alu_sch_op_code_out_2,
	destn_rename_code_in => alu_sch_rename_dest_out_2,
	operand1 => alu_sch_operand_1_out_2,
	operand2 => alu_sch_operand_2_out_2,
	operand3 => alu_sch_operand_3_out_2,
	c_flag_in => alu_sch_c_flag_out_2,
	z_flag_in => alu_sch_z_flag_out_2,
	c_rename_in => alu_sch_c_flag_rename_out_2,
	z_rename_in => alu_sch_z_flag_rename_out_2,
	b_tag_in => alu_sch_btag_out_2,
	orig_destn_in => alu_sch_original_dest_out_2,
	op_code_cz => alu_sch_op_code_cz_out_2,
	curr_pc_in => alu_sch_pc_out_2,

	data_out => alu_pip2_data_out,
	pipeline_valid_out => alu_pip2_valid_out,
	op_code_out => alu_pip2_op_code_out,
	destn_rename_code_out => alu_pip2_destn_rename_code_out,
	c_flag_out => alu_pip2_c_flag_out,
	z_flag_out => alu_pip2_z_flag_out,
	c_rename_out => alu_pip2_c_rename_out,
	z_rename_out => alu_pip2_z_rename_out,
	b_tag_out => alu_pip2_b_tag_out,
	orig_destn_out => alu_pip2_orig_destn_out,
	curr_pc_out => alu_pip2_curr_pc_out,

	alu_brdcst_rename_out => broadcast2_rename,
	alu_brdcst_orig_destn_out => broadcast2_orig_destn,
	alu_brdcst_data_out => broadcast2_data,
	alu_brdcst_valid_out => broadcast2_valid,

	alu_brdcst_c_flag_out => broadcast2_c_flag,
	alu_brdcst_c_flag_rename_out => broadcast2_c_flag_rename,
	alu_brdcst_c_flag_valid_out => broadcast2_c_flag_valid,

	alu_brdcst_z_flag_out => broadcast2_z_flag,
	alu_brdcst_z_flag_rename_out => broadcast2_z_flag_rename,
	alu_brdcst_z_flag_valid_out => broadcast2_z_flag_valid,

	alu_brdcst_btag_out => broadcast2_btag
	);
------------------------------------------------------------------------------------------------------------------------------------------
LS_PIPELINE:lw_sw_pipeline port map
		(
		pipeline_valid_in => ls_sch_instr_valid_out, 
		op_code_in => ls_sch_op_code_out, 
		destn_rename_code_in => ls_sch_rename_dest_out, 
		operand1 => ls_sch_operand_1_out, --refers to Rb
		operand2 => ls_sch_operand_2_out, --refers to immediate in case of LHI shifted word expected
		operand3 => ls_sch_operand_3_out, 
		--c_flag_in:in std_logic;
		z_flag_in => ls_sch_z_flag_temp_out, 
		--c_rename_in => ,
		z_rename_in => ls_sch_z_flag_rename_temp_out,
		b_tag_in => ls_sch_btag_out,
		orig_destn_in => ls_sch_original_dest_out,
		curr_pc_in => ls_sch_pc_out,
		--op_code_cz:in std_logic_vector(1 downto 0);
		-------------------------------------------------------------------------------------------
		addr_out => ls_pip_addr_out,
		data_out => ls_pip_data_out,--refers to immediate data in case of LHI
		pipeline_valid_out => ls_pip_valid_out, 
		op_code_out => ls_pip_op_code_out,
		destn_rename_code_out => ls_pip_destn_rename_out,
		--c_flag_out:out std_logic;
		z_flag_out => ls_pip_z_flag_out, 
		--c_rename_out:out std_logic_vector(3 downto 0);
		z_rename_out => ls_pip_z_rename_out,
		b_tag_out => ls_pip_b_tag_out,
		orig_destn_out => ls_pip_orig_destn_out,
		curr_pc_out => ls_pip_curr_pc_out,

		lw_sw_brdcst_rename_out => broadcast3_rename,--refers to rename register broadcasted
		lw_sw_brdcst_orig_destn_out => broadcast3_orig_destn,--used if a broadcast signal matches with arrival of other instr with same src register
		lw_sw_brdcst_data_out => broadcast3_data, --refers to data of rename register broadcasted
		lw_sw_brdcst_valid_out => broadcast3_valid,--refers whether broadcasted data is valid or not 


		lw_sw_brdcst_c_flag_out => lw_c_flag_temp, 
		lw_sw_brdcst_c_flag_rename_out => lw_c_flag_rename_temp,
		lw_sw_brdcst_c_flag_valid_out => lw_c_flag_valid_temp, 

		lw_sw_brdcst_z_flag_out => lw_z_flag_temp, 
		lw_sw_brdcst_z_flag_rename_out => lw_z_flag_rename_temp,
		lw_sw_brdcst_z_flag_valid_out => lw_z_flag_valid_temp, 
		
		lw_sw_brdcst_btag_out => broadcast3_btag --refers to btag of branch signal useful for updating branch copies
		); 
------------------------------------------------------------------------------------------------------------------------------------------
BR_PIPELINE: jump_pipeline port map
	(
	pipeline_valid_in => br_sch_instr_valid_out,
	op_code_in => br_sch_op_code_out,
	destn_rename_code_in => br_sch_rename_dest_out,
	operand1 => br_sch_operand_1_out,--refers to Ra
	operand2 => br_sch_operand_2_out,--refers to Rb
	operand3 => br_sch_operand_3_out,--refers to immediate
	--c_flag_in:in std_logic;
	--z_flag_in:in std_logic;
	--c_rename_in:in std_logic_vector(3 downto 0);
	--z_rename_in: in std_logic_vector(3 downto 0);
	b_tag_in => br_sch_btag_out,
	orig_destn_in => br_sch_original_dest_out,
	--op_code_cz:in std_logic_vector(1 downto 0);
	curr_pc_in => br_sch_pc_out,
	next_pc_in => br_sch_nxt_pc_out,
	self_branch_tag_in => br_sch_self_tag_out,
	----------------------------------------------------
	data_out => br_pip_data_out,
	pipeline_valid_out => br_pip_valid_out,
	op_code_out => br_pip_op_code_out,
	destn_rename_code_out => br_pip_destn_rename_code_out,
	--c_flag_out:out std_logic;
	--z_flag_out:out std_logic;
	--c_rename_out:out std_logic_vector(3 downto 0);
	--z_rename_out: out std_logic_vector(3 downto 0);
	b_tag_out => br_pip_b_tag_out,
	orig_destn_out => br_pip_orig_destn_out,
	curr_pc_out => br_pip_curr_pc_out,
	self_branch_tag_out => br_pip_self_branch_tag_out,
	branch_addr => br_pip_branch_addr,
	reg_write => br_pip_reg_write,
	correct => br_pip_correct,

	jump_brdcst_rename_out => broadcast4_rename ,
	jump_brdcst_orig_destn_out => broadcast4_orig_destn,
	jump_brdcst_data_out => broadcast4_data, 
	jump_brdcst_valid_out => broadcast4_valid,

	jump_brdcst_btag_out => broadcast4_btag,

	jump_branch_mispredictor => branch_mispredict_broadcast --to be sent to RS for branch misprediction
	);
------------------------------------------------------------------------------------------------------------------------------------------
ROB_BLOCK:rob port map(
		clk => top_clock,
		reset => system_reset,
		----------------------------------------------------------------
		--Inputs from RS
		rs_1_pc_in => curr_pc1_rob,
		rs_1_original_dest_code_in => destn_code1_rob ,
		rs_1_rename_dest_in => destn_rename1_rob,
		rs_1_rename_c_in => destn_rename_c1_rob,
		rs_1_rename_z_in => destn_rename_z1_rob,
		rs_1_btag_in => destn_btag1_rob,
		rs_1_op_code_in => op_code1_rob,
		rs_1_inst_valid_in => curr_instr1_valid_rob,
		----------------------------------------------------------------
		--Inputs from RS
		rs_2_pc_in => curr_pc2_rob,
		rs_2_original_dest_code_in => destn_code2_rob,
		rs_2_rename_dest_in => destn_rename2_rob,
		rs_2_rename_c_in => destn_rename_c2_rob,
		rs_2_rename_z_in => destn_rename_z2_rob,
		rs_2_btag_in => destn_btag2_rob,
		rs_2_op_code_in => op_code2_rob,
		rs_2_inst_valid_in => curr_instr2_valid_rob,
		----------------------------------------------------------------
		--Inputs from ALU Pipeline 1
		alu_1_pc_in => alu_pip1_curr_pc_out,
		alu_1_inst_valid_in => alu_pip1_valid_out,
		alu_1_rf_data_in => alu_pip1_data_out,
		alu_1_c_flag_in => alu_pip1_c_flag_out,
		alu_1_z_flag_in => alu_pip1_z_flag_out,
		----------------------------------------------------------------
		--Inputs from ALU Pipeline 2
		alu_2_pc_in => alu_pip2_curr_pc_out,
		alu_2_inst_valid_in => alu_pip2_valid_out,
		alu_2_rf_data_in => alu_pip2_data_out,
		alu_2_c_flag_in => alu_pip2_c_flag_out,
		alu_2_z_flag_in => alu_pip2_z_flag_out,
		----------------------------------------------------------------
		--Inputs from Load/Store Pipeline
		ls_pc_in => ls_pip_curr_pc_out,
		ls_inst_valid_in => ls_pip_valid_out,
		ls_addr_in => ls_pip_addr_out,
		ls_data_in => ls_pip_data_out,
		---------------------------------------------------------------
		--Inputs from Branch Pipeline
		br_pc_in => br_pip_curr_pc_out,
		br_inst_valid_in => br_pip_valid_out,
		br_btag_in => br_pip_b_tag_out,
		br_correct_in => br_pip_correct,
		br_data_in => br_pip_data_out,
		br_self_tag_in => br_pip_self_branch_tag_out,
		----------------------------------------------------------------
		--Output to write to RF/MEM
		--These must be asynchronous
		rf_dest_code_out => rob_rf_dest_code_out,
		rf_data_out => rob_rf_data_out,
		rf_write_en => rob_rf_write_en,
		
		c_flag => rob_c_flag,
		c_flag_valid => rob_c_flag_valid,

		z_flag => rob_z_flag,
		z_flag_valid => rob_z_flag_valid,

		mem_dest_add => rob_mem_dest_add,
		mem_dest_data_out => rob_mem_dest_data_out, -- For SW
		mem_write_en => rob_mem_write_en,

		mem_data_in => rob_mem_data_in, -- For LHI
		----------------------------------------------------------------
		--Output to Broadcast to RS of LW/SW
		--These must be asynchronous
		broadcast_rename_reg_out => broadcast5_rename,
		broadcast_original_dest_code => broadcast5_orig_destn,
		broadcast_data_out => broadcast5_data,
		broadcast_valid => broadcast5_valid,
		broadcast_btag => broadcast5_btag,
		-----------------------------------------------------------------
		--ROB Stall signal
		rob_stall_out => rob_stall_out
  );
------------------------------------------------------------------------------------------------------------------------------------------
DATA_MEM: memory_data port map
		(
		clk => top_clock,  
        we => rob_mem_write_en,
        --rd	: in std_logic;   
        a => rob_mem_dest_add,   
        di => rob_mem_dest_data_out,   
        do  => rob_mem_data_in
        );
------------------------------------------------------------------------------------------------------------------------------------------
REGISTER_FILE: RF port map
		(a1 => rf_a1,
		 a2 => rf_a2, 
		 a3 => rob_rf_dest_code_out, 
		 clk => top_clock,
		 we_rf => rob_rf_write_en,
		 reset => system_reset,
		 d3 => rob_rf_data_out, 
		 d1 => rf_d1, 
		 d2 => rf_d2, 
		 r0 => r0_out, 
		 r1 => r1_out,
		 r2 => r2_out, 
		 r3 => r3_out,
		 r4 => r4_out, 
		 r5 => r5_out, 
		 r6 => r6_out, 
		 r7 => r7_out
		);
------------------------------------------------------------------------------------------------------------------------------------------
C_REGISTER:c_reg port map 
  (
	clk => top_clock,
	reset => system_reset,
	c_data_in => rob_c_flag,
	c_valid => rob_c_flag_valid,
	c_data_out =>  c_reg_data_out
  );
------------------------------------------------------------------------------------------------------------------------------------------
Z_REGISTER: z_reg port map 
  (
	clk => top_clock,
	reset => system_reset,
	z_data_in => rob_z_flag,
	z_valid => rob_z_flag_valid,
	z_data_out => z_reg_data_out
  );
------------------------------------------------------------------------------------------------------------------------------------------
  process(decode_stall_out,halt_out_RS,rob_stall_out) --stall for stall_fetch_in --to be increased later

   begin
   if (decode_stall_out='1' or halt_out_RS='1' or rob_stall_out='1') then --in case of reset no stall
     stall_fetch_in<='1';
   else
     stall_fetch_in<='0';
   end if;   

   
  end process;


  --process(decode_stall_out) --stall for stall_decode_in --to be increased later

  -- begin
  -- if (decode_stall_out='1') then
  --   stall_decode_in<='1';
  -- else
  --   stall_decode_in<='0';
  -- end if;   

   
  --end process;

  stall_decode_in<=(decode_stall_out or halt_out_RS or rob_stall_out); --things to be appended later



  --
  --invalidate_fetch_in<='1';
  --decode_invalidate_in<='1';
  
  process(system_reset) --invalidation for decode registers
  
  begin
   if (system_reset='1' or (br_pip_correct = '0'  and br_pip_valid_out = '1')) then
    decode_invalidate_in<='1';
   else
    decode_invalidate_in<='0';
   end if;
  end process;    

  process(system_reset) --invalidation for decode registers
  
  begin
   if (system_reset='1' or (br_pip_correct = '0'  and br_pip_valid_out = '1')) then
    invalidate_fetch_in<='1';
   else
    invalidate_fetch_in<='0';
   end if;
  end process;


	stall_reservation_center<=rob_stall_out;--controlling the reservation center update

	control_to_jmp<='0';--as branch predictor not used

	branch_mis_predicted <= (not br_pip_correct); --to write a separate process here later to control when to use addr exec pipeline and when to do otherwise

	--ls_sch_stall_in <= rob_stall_out;
	--alu_sch_stall_in <= rob_stall_out;
	--br_sch_stall_in <= rob_stall_out;


  process(branch_mispredict_broadcast,rob_stall_out)--ls_sch stall

   begin

    if ((branch_mispredict_broadcast="01" or branch_mispredict_broadcast="10") or rob_stall_out='1') then

     ls_sch_stall_in<='1';
    else
     ls_sch_stall_in<='0';

    end if;  



  end process; 


  process(branch_mispredict_broadcast,rob_stall_out)--alu_sch stall

   begin

    if ((branch_mispredict_broadcast="01" or branch_mispredict_broadcast="10") or rob_stall_out='1') then

     alu_sch_stall_in<='1';
    else
     alu_sch_stall_in<='0';

    end if;  



  end process;


  process(branch_mispredict_broadcast,rob_stall_out)--br_sch stall

   begin

    if (rob_stall_out='1') then

     br_sch_stall_in<='1';
    else
     br_sch_stall_in<='0';

    end if;  



  end process;




	branch_predicted <= (others => '0');
	rf_a1 <= (others => '0');
	rf_a2 <= (others => '0');

  

--temporary mappings done to be mapped to actual objects later




  --broadcast_branch_decode_valid<='0';--logic to be written later

  --broadcast_branch_btag_in<=(others=>'0');--logic to be written later

  --broadcast_branch_self_tag_in<=(others=>'0');--logic to be written later

  --alu_valid_done1_RS<='0';--
  
  
  --alu_valid_done2_RS<='0';

  --ls_valid_done_RS<='0';
  
  --jmp_valid_done_RS<='0';
  


 --broadcast1_valid<='0';
 --broadcast2_valid<='0';
 --broadcast3_valid<='0';
 --broadcast4_valid<='0';
 --broadcast5_valid<='0';

 --broadcast1_z_flag_valid<='0';
 --broadcast1_c_flag_valid<='0';

 --broadcast2_z_flag_valid<='0';
 --broadcast2_c_flag_valid<='0';

 broadcast4_z_flag_valid<='0';
 broadcast4_z_flag <= '0';
 broadcast4_z_flag_rename <= (others => '0');
 
 broadcast4_c_flag_valid<='0';
 broadcast4_c_flag <= '0';
 broadcast4_c_flag_rename <= (others => '0');
 
 --branch_mispredict_broadcast<="00";	

 ls_sch_z_flag_temp_out <= '0';
 ls_sch_z_flag_rename_temp_out <= (others => '0'); 
 
 --lw_c_flag_temp <= '0';
 --lw_c_flag_rename_temp <= (others => '0');
 --lw_c_flag_valid_temp <= '0';
 --lw_z_flag_temp <= '0';
 --lw_z_flag_rename_temp <= (others => '0');
 --lw_z_flag_valid_temp <= '0';	  


end architecture struct;