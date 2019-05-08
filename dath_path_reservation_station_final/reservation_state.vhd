library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--package pkg is
--  type slv8_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
--  type slv4_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
--  type slv6_array_t is array (natural range <>) of std_logic_vector(5 downto 0);
--  type slv16_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
--  type slv_array_t is array (natural range <>) of std_logic;
--  type slv3_array_t is array (natural range <>) of std_logic_vector(2 downto 0);
--  type slv2_array_t is array (natural range <>) of std_logic_vector(1 downto 0);
--  type slv6_int_array_t is array (natural range <>) of integer range 0 to 9;
--end package;

--package body pkg is
--end package body;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;



entity reservation_state is

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
       

       --ARF and zero and carry flags status

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





       );

end entity;


architecture reservation_process of reservation_state is

signal arf_rename_valid:slv_array_t(0 to 7):=(others=>'0');-- not required if value is valid rename cannot be valid
--signal arf_reg_name:array(0 to 29) of std_logic_vector(2 downto 0);
signal arf_reg_rename:slv6_array_t(0 to 7);
signal arf_reg_value:slv16_array_t(0 to 7);--refers to value stored 
signal arf_value_valid:slv_array_t(0 to 7);
signal free_reg: std_logic_vector (15 downto 0);--denotes which rename registers are free 


signal carry_value_valid:std_logic;
signal zero_value_valid:std_logic;

signal carry_value:std_logic;
signal zero_value:std_logic;



signal carry_rename_rf:std_logic_vector(2 downto 0);--stores to which rename carry flag is currently renamed
signal zero_rename_rf: std_logic_vector(2 downto 0); --stores to which rename zero flag is currently renamed

signal free_flag_zero:std_logic;-- whether 2 zero registers are free
signal free_flag_carry:std_logic;--whether 2 carry registers are free

signal free_rename_carry:std_logic_vector(7 downto 0);--which of 7 rename carry flags are free
signal free_rename_zero:std_logic_vector(7 downto 0);--which of 7 rename zero flags are free



signal first_free_rename_carry:slv3_array_t(0 to 1);--which 2 rename carry registers are free
signal first_free_rename_zero:slv3_array_t(0 to 1);--which 2 rename zero registers are free
 

signal first_free_rename:slv6_array_t(0 to 1); --denotes the first and second rename register
signal rename_free:std_logic;--whether rename register is free or not.


signal alu_instr_valid_out_internal:slv_array_t(0 to 9);--refers to the signal which would drive alu_instr_valid
signal alu_comp_valid_out_internal:slv_array_t(0 to 9);
--signal temp:slv_array_t(0 to 9);--used for inversion
signal alu_op_code_out_internal: slv4_array_t(0 to 9);
signal alu_op_code_cz_out_internal: slv2_array_t(0 to 9);
signal alu_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal alu_operand1_out_internal: slv16_array_t(0 to 9);
signal alu_valid1_out_internal: slv_array_t(0 to 9);                     ---all these refer to signals which drive the register

signal alu_operand2_out_internal: slv16_array_t(0 to 9);
signal alu_valid2_out_internal: slv_array_t(0 to 9);

signal alu_operand3_out_internal: slv16_array_t(0 to 9);
signal alu_valid3_out_internal: slv_array_t(0 to 9);

signal alu_c_flag_out_internal: slv_array_t(0 to 9);
signal alu_c_flag_rename_out_internal: slv3_array_t(0 to 9);
signal alu_c_flag_valid_out_internal: slv_array_t(0 to 9);
signal alu_c_flag_destn_addr_out_internal: slv3_array_t(0 to 9);

signal alu_z_flag_out_internal: slv_array_t(0 to 9);
signal alu_z_flag_rename_out_internal: slv3_array_t(0 to 9);
signal alu_z_flag_valid_out_internal: slv_array_t(0 to 9);
signal alu_z_flag_destn_addr_out_internal: slv3_array_t(0 to 9);

signal alu_scheduler_valid_out_internal:slv_array_t(0 to 9);

signal alu_btag_out_internal: slv3_array_t(0 to 9);

signal alu_orign_destn_out_internal: slv3_array_t(0 to 9);

signal alu_curr_pc_out_internal: slv16_array_t(0 to 9);

signal alu_vacant_entry: slv6_int_array_t(0 to 1);
signal alu_entry_free:std_logic;



signal ls_instr_valid_out_internal: slv_array_t(0 to 9);
--signal ls_comp_valid_out_internal:slv_array_t(0 to 9);
signal ls_op_code_out_internal: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
signal ls_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal ls_operand1_out_internal: slv16_array_t(0 to 9);
signal ls_valid1_out_internal: slv_array_t(0 to 9);

signal ls_operand2_out_internal: slv16_array_t(0 to 9);
signal ls_valid2_out_internal: slv_array_t(0 to 9);

signal ls_operand3_out_internal: slv16_array_t(0 to 9);
signal ls_valid3_out_internal: slv_array_t(0 to 9);



       --ls_operand3_out:out slv16_array_t(0 to 9);
       --ls_valid3_out:out slv_array_t(0 to 9);

       --alu_c_flag_out:out slv_array_t(0 to 9);
       --alu_c_flag_rename_out:out slv3_array_t(0 to 9);
       --alu_c_flag_valid_out:out slv_array_t(0 to 9);

       --alu_z_flag_out:out slv_array_t(0 to 9);
       --alu_z_flag_rename_out:out slv3_array_t(0 to 9);
       --alu_z_flag_valid_out:out slv_array_t(0 to 9);

signal ls_scheduler_valid_out_internal:slv_array_t(0 to 9);

signal ls_btag_out_internal:slv3_array_t(0 to 9);

signal ls_orign_destn_out_internal: slv3_array_t(0 to 9);

--signal ls_imm_out_internal:slv16_array_t(0 to 9);
signal ls_curr_pc_out_internal:slv16_array_t(0 to 9);

signal ls_entry_free:std_logic;
signal ls_vacant_entry:slv6_int_array_t(0 to 1);






signal jmp_instr_valid_out_internal:slv_array_t(0 to 9);
--signal jmp_comp_valid_out_internal:slv_array_t(0 to 9);
--signal jmp_instr_valid_out_: slv_array_t(0 to 9);
signal jmp_op_code_out_internal: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
signal jmp_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal jmp_operand1_out_internal: slv16_array_t(0 to 9);
signal  jmp_valid1_out_internal: slv_array_t(0 to 9);

signal  jmp_operand2_out_internal: slv16_array_t(0 to 9);
signal jmp_valid2_out_internal: slv_array_t(0 to 9);


signal jmp_operand3_out_internal: slv16_array_t(0 to 9);--denotes which register to load onto or store from
signal jmp_valid3_out_internal: slv_array_t(0 to 9);

       

signal jmp_btag_out_internal: slv3_array_t(0 to 9);

signal jmp_orign_destn_out_internal: slv3_array_t(0 to 9);

signal jmp_curr_pc_out_internal: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


signal jmp_scheduler_valid_out_internal: slv_array_t(0 to 9);
signal jmp_next_pc_out_internal: slv16_array_t(0 to 9);

signal jmp_self_tag_out_internal: slv3_array_t(0 to 9);

signal jmp_entry_free:std_logic;
signal jmp_vacant_entry:slv6_int_array_t(0 to 1);


signal halt_out_internal:std_logic;


signal operand1_out_internal_instr1:std_logic_vector(15 downto 0);--contains either rename register or required date if available
signal operand1_out_internal_data_valid_instr1:std_logic;--denotes whether data or rename
signal operand2_out_internal_instr1:std_logic_vector(15 downto 0);--contains either rename register or required date if available
signal operand2_out_internal_data_valid_instr1:std_logic;--denotes whether data or rename
signal operand3_out_internal_instr1:std_logic_vector(15 downto 0);--contains either rename register or required date if available
signal operand3_out_internal_data_valid_instr1:std_logic;--denotes whether data or rename

signal operand_carry_rename_internal_instr1:std_logic_vector(2 downto 0);--contains either carry rename register
signal operand_carry_bit_valid_instr1:std_logic;--denotes whether carry bit is valid or rename
signal operand_zero_rename_internal_instr1:std_logic_vector(2 downto 0);--contains either carry rename register
signal operand_zero_bit_valid_instr1:std_logic;--denotes whether zero bit is valid or rename

signal operand_carry_value_internal_instr1:std_logic;--denotes value of bit if valio
signal operand_zero_value_internal_instr1:std_logic;--denotes value of bit if valio

signal operand1_out_internal_instr2:std_logic_vector(15 downto 0);--contains either rename register or required date if available
signal operand1_out_internal_data_valid_instr2:std_logic;--denotes whether data or rename
signal operand2_out_internal_instr2:std_logic_vector(15 downto 0);--contains either rename register or required date if available
signal operand2_out_internal_data_valid_instr2:std_logic;--denotes whether data or rename
signal operand3_out_internal_instr2:std_logic_vector(15 downto 0);--contains either rename register or required date if available
signal operand3_out_internal_data_valid_instr2:std_logic;--denotes whether data or rename

signal operand_carry_rename_internal_instr2:std_logic_vector(2 downto 0);--contains either carry rename register
signal operand_carry_bit_valid_instr2:std_logic;--denotes whether carry bit is valid or rename
signal operand_zero_rename_internal_instr2:std_logic_vector(2 downto 0);--contains either carry rename register
signal operand_zero_bit_valid_instr2:std_logic;--denotes whether zero bit is valid or rename

signal operand_carry_value_internal_instr2:std_logic;--denotes value of bit if valio
signal operand_zero_value_internal_instr2:std_logic;--denotes value of bit if valio


signal branch1_done:std_logic;--goes high just in next clock cycle after branch signal of self id 1 is entered in table
signal branch2_done:std_logic;--goes high just in next clock cycle after branch signal of self id 2 is entered in table
--signal branch3_done:std_logic;--goes high just in next clock cycle after branch signal of self id 3 is entered in table



---copies for branch instruction in 
--branch1 
-- 
-- 
signal br1_arf_rename_valid:slv_array_t(0 to 7):=(others=>'0');-- not required if value is valid rename cannot be valid
signal br1_arf_reg_rename:slv6_array_t(0 to 7);
signal br1_arf_reg_value:slv16_array_t(0 to 7);--refers to value stored 
signal br1_arf_value_valid:slv_array_t(0 to 7);
signal br1_free_reg: std_logic_vector (15 downto 0);--denotes which rename registers are free 

signal br2_arf_rename_valid:slv_array_t(0 to 7):=(others=>'0');-- not required if value is valid rename cannot be valid
signal br2_arf_reg_rename:slv6_array_t(0 to 7);
signal br2_arf_reg_value:slv16_array_t(0 to 7);--refers to value stored 
signal br2_arf_value_valid:slv_array_t(0 to 7);
signal br2_free_reg: std_logic_vector (15 downto 0);--denotes which rename registers are free 


signal br1_carry_value_valid:std_logic;--denotes whether req value is valid or not
signal br1_zero_value_valid:std_logic;
signal br1_carry_value:std_logic; --denotes the required value
signal br1_zero_value:std_logic;
signal br1_carry_rename_rf:std_logic_vector(2 downto 0);--stores to which rename carry flag is currently renamed
signal br1_zero_rename_rf: std_logic_vector(2 downto 0); --stores to which rename zero flag is currently renamed
signal br1_free_rename_carry:std_logic_vector(7 downto 0);--stores which rename carry bits are free
signal br1_free_rename_zero:std_logic_vector(7 downto 0);--stores which rename zero bits are free
 
signal br2_carry_value_valid:std_logic;--denotes whether req value is valid or not
signal br2_zero_value_valid:std_logic;
signal br2_carry_value:std_logic; --denotes the required value
signal br2_zero_value:std_logic;
signal br2_carry_rename_rf:std_logic_vector(2 downto 0);--stores to which rename carry flag is currently renamed
signal br2_zero_rename_rf: std_logic_vector(2 downto 0); --stores to which rename zero flag is currently renamed
signal br2_free_rename_carry:std_logic_vector(7 downto 0);--stores which rename carry bits are free
signal br2_free_rename_zero:std_logic_vector(7 downto 0);--stores which rename zero bits are free





  

 
 
------AL op codes copy for branch 1


signal br1_alu_instr_valid_out_internal:slv_array_t(0 to 9);--refers to the signal which would drive alu_instr_valid
--signal alu_comp_valid_out_internal:slv_array_t(0 to 9);
--signal temp:slv_array_t(0 to 9);--used for inversion
signal br1_alu_op_code_out_internal: slv4_array_t(0 to 9);
signal br1_alu_op_code_cz_out_internal: slv2_array_t(0 to 9);
signal br1_alu_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal br1_alu_operand1_out_internal: slv16_array_t(0 to 9);
signal br1_alu_valid1_out_internal: slv_array_t(0 to 9);                     ---all these refer to signals which drive the register

signal br1_alu_operand2_out_internal: slv16_array_t(0 to 9);
signal br1_alu_valid2_out_internal: slv_array_t(0 to 9);

signal br1_alu_operand3_out_internal: slv16_array_t(0 to 9);
signal br1_alu_valid3_out_internal: slv_array_t(0 to 9);

signal br1_alu_c_flag_out_internal: slv_array_t(0 to 9);
signal br1_alu_c_flag_rename_out_internal: slv3_array_t(0 to 9);
signal br1_alu_c_flag_valid_out_internal: slv_array_t(0 to 9);
signal br1_alu_c_flag_destn_addr_out_internal:slv3_array_t(0 to 9);

signal br1_alu_z_flag_out_internal: slv_array_t(0 to 9);
signal br1_alu_z_flag_rename_out_internal: slv3_array_t(0 to 9);
signal br1_alu_z_flag_valid_out_internal: slv_array_t(0 to 9);
signal br1_alu_z_flag_destn_addr_out_internal:slv3_array_t(0 to 9);

--signal br1_alu_scheduler_valid_out_internal:slv_array_t(0 to 9);

signal br1_alu_btag_out_internal: slv3_array_t(0 to 9);

signal br1_alu_orign_destn_out_internal: slv3_array_t(0 to 9);

signal br1_alu_curr_pc_out_internal: slv16_array_t(0 to 9);


signal br2_alu_instr_valid_out_internal:slv_array_t(0 to 9);--refers to the signal which would drive alu_instr_valid
--signal alu_comp_valid_out_internal:slv_array_t(0 to 9);
--signal temp:slv_array_t(0 to 9);--used for inversion
signal br2_alu_op_code_out_internal: slv4_array_t(0 to 9);
signal br2_alu_op_code_cz_out_internal: slv2_array_t(0 to 9);
signal br2_alu_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal br2_alu_operand1_out_internal: slv16_array_t(0 to 9);
signal br2_alu_valid1_out_internal: slv_array_t(0 to 9);                     ---all these refer to signals which drive the register

signal br2_alu_operand2_out_internal: slv16_array_t(0 to 9);
signal br2_alu_valid2_out_internal: slv_array_t(0 to 9);

signal br2_alu_operand3_out_internal: slv16_array_t(0 to 9);
signal br2_alu_valid3_out_internal: slv_array_t(0 to 9);

signal br2_alu_c_flag_out_internal: slv_array_t(0 to 9);
signal br2_alu_c_flag_rename_out_internal: slv3_array_t(0 to 9);
signal br2_alu_c_flag_valid_out_internal: slv_array_t(0 to 9);
signal br2_alu_c_flag_destn_addr_out_internal:slv3_array_t(0 to 9);

signal br2_alu_z_flag_out_internal: slv_array_t(0 to 9);
signal br2_alu_z_flag_rename_out_internal: slv3_array_t(0 to 9);
signal br2_alu_z_flag_valid_out_internal: slv_array_t(0 to 9);
signal br2_alu_z_flag_destn_addr_out_internal:slv3_array_t(0 to 9);

--signal br2_alu_scheduler_valid_out_internal:slv_array_t(0 to 9);

signal br2_alu_btag_out_internal: slv3_array_t(0 to 9);

signal br2_alu_orign_destn_out_internal: slv3_array_t(0 to 9);

signal br2_alu_curr_pc_out_internal: slv16_array_t(0 to 9);


-------LS instr corresponding to branches

--branch1

signal br1_ls_instr_valid_out_internal: slv_array_t(0 to 9);
--signal br1_ls_comp_valid_out_internal:slv_array_t(0 to 9);
signal br1_ls_op_code_out_internal: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
signal br1_ls_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal br1_ls_operand1_out_internal: slv16_array_t(0 to 9);
signal br1_ls_valid1_out_internal: slv_array_t(0 to 9);

signal br1_ls_operand2_out_internal: slv16_array_t(0 to 9);
signal br1_ls_valid2_out_internal: slv_array_t(0 to 9);

signal br1_ls_operand3_out_internal: slv16_array_t(0 to 9);
signal br1_ls_valid3_out_internal: slv_array_t(0 to 9);



       

--signal br1_ls_scheduler_valid_out_internal:slv_array_t(0 to 9);

signal br1_ls_btag_out_internal:slv3_array_t(0 to 9);

signal br1_ls_orign_destn_out_internal: slv3_array_t(0 to 9);

signal br1_ls_curr_pc_out_internal:slv16_array_t(0 to 9);


------LS instr corr to branch 2


signal br2_ls_instr_valid_out_internal: slv_array_t(0 to 9);
signal br2_ls_comp_valid_out_internal:slv_array_t(0 to 9);
signal br2_ls_op_code_out_internal: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
signal br2_ls_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal br2_ls_operand1_out_internal: slv16_array_t(0 to 9);
signal br2_ls_valid1_out_internal: slv_array_t(0 to 9);

signal br2_ls_operand2_out_internal: slv16_array_t(0 to 9);
signal br2_ls_valid2_out_internal: slv_array_t(0 to 9);

signal br2_ls_operand3_out_internal: slv16_array_t(0 to 9);
signal br2_ls_valid3_out_internal: slv_array_t(0 to 9);


--signal br2_ls_scheduler_valid_out_internal:slv_array_t(0 to 9); -not needed

signal br2_ls_btag_out_internal:slv3_array_t(0 to 9);

signal br2_ls_orign_destn_out_internal: slv3_array_t(0 to 9);

signal br2_ls_curr_pc_out_internal:slv16_array_t(0 to 9);



--JMP instr copy for branches

----branch 1

signal br1_jmp_instr_valid_out_internal:slv_array_t(0 to 9);
--signal jmp_comp_valid_out_internal:slv_array_t(0 to 9);
--signal jmp_instr_valid_out_: slv_array_t(0 to 9);
signal br1_jmp_op_code_out_internal: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
signal br1_jmp_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal br1_jmp_operand1_out_internal: slv16_array_t(0 to 9);
signal br1_jmp_valid1_out_internal: slv_array_t(0 to 9);

signal br1_jmp_operand2_out_internal: slv16_array_t(0 to 9);
signal br1_jmp_valid2_out_internal: slv_array_t(0 to 9);


signal br1_jmp_operand3_out_internal: slv16_array_t(0 to 9);--denotes which register to load onto or store from
signal br1_jmp_valid3_out_internal: slv_array_t(0 to 9);

       

signal br1_jmp_btag_out_internal: slv3_array_t(0 to 9);

signal br1_jmp_orign_destn_out_internal: slv3_array_t(0 to 9);

signal br1_jmp_curr_pc_out_internal: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


----signal jmp_scheduler_valid_out_internal: slv_array_t(0 to 9);
signal br1_jmp_next_pc_out_internal: slv16_array_t(0 to 9);

signal br1_jmp_self_tag_out_internal: slv3_array_t(0 to 9);


--branch2

signal br2_jmp_instr_valid_out_internal:slv_array_t(0 to 9);
--signal jmp_comp_valid_out_internal:slv_array_t(0 to 9);
--signal jmp_instr_valid_out_: slv_array_t(0 to 9);
signal br2_jmp_op_code_out_internal: slv4_array_t(0 to 9);
       --_op_code_cz_out:out slv2_array_t(0 to 9);
signal br2_jmp_destn_rename_code_out_internal: slv6_array_t(0 to 9);
signal br2_jmp_operand1_out_internal: slv16_array_t(0 to 9);
signal br2_jmp_valid1_out_internal: slv_array_t(0 to 9);

signal br2_jmp_operand2_out_internal: slv16_array_t(0 to 9);
signal br2_jmp_valid2_out_internal: slv_array_t(0 to 9);


signal br2_jmp_operand3_out_internal: slv16_array_t(0 to 9);--denotes which register to load onto or store from
signal br2_jmp_valid3_out_internal: slv_array_t(0 to 9);

       

signal br2_jmp_btag_out_internal: slv3_array_t(0 to 9);

signal br2_jmp_orign_destn_out_internal: slv3_array_t(0 to 9);

signal br2_jmp_curr_pc_out_internal: slv16_array_t(0 to 9);
       --ls_imm_out:out slv16_array_t(0 to 9);


----signal jmp_scheduler_valid_out_internal: slv_array_t(0 to 9);
signal br2_jmp_next_pc_out_internal: slv16_array_t(0 to 9);

signal br2_jmp_self_tag_out_internal: slv3_array_t(0 to 9);









begin

--temp<=(others=>'1');

process(free_reg)

 --variable rename_free_var:unsigned: ='0';
 --variable free_reg_repr:integer range 0 to 2**63;
 variable i:integer range 0 to 2**16;
 variable count:integer range 0 to 2;
 variable current_position:integer range 0 to 63;
 variable first_free_rename_var:slv6_array_t(0 to 1); --denotes the first rename register
  begin
   
    
    count:=0;
    i:=to_integer(unsigned(free_reg));
    current_position:=0;
    first_free_rename_var:=(others=>(others=>'0'));
    --for i in 0 to 59 loop
     --for j in 0 to 59 loop
    
     while (i > 0) loop

      if (i mod 2 = 1) then
        first_free_rename_var(count):=std_logic_vector(to_unsigned(current_position,6));
        count:=count+1;
      end if;
      current_position:=current_position+1;

      exit when count=2;

      i:=i/2;
        

      
     	
     end loop;


     if (count=2) then

      rename_free<='1';
      
     else 
      rename_free<='0';

     end if;
     
     
     first_free_rename<=first_free_rename_var; 
         

  end process;



  process(free_rename_carry)

 --variable rename_free_var:unsigned: ='0';
 --variable free_reg_repr:integer range 0 to 2**63;
      variable i:integer range 0 to 2**8;
      variable count:integer range 0 to 2;
      variable current_position:integer range 0 to 63;
      variable first_free_rename_carry_var:slv3_array_t(0 to 1); --denotes the first rename register
  begin
   
    
    count:=0;
    i:=to_integer(unsigned(free_rename_carry));
    current_position:=0;
    first_free_rename_carry_var:=(others=>(others=>'0'));
    --for i in 0 to 59 loop
     --for j in 0 to 59 loop
    
     while (i > 0) loop

      if (i mod 2 = 1) then
        first_free_rename_carry_var(count):=std_logic_vector(to_unsigned(current_position,3));
        count:=count+1;
      end if;
      current_position:=current_position+1;

      exit when count=2;

      i:=i/2;
        

      
     	
     end loop;


     if (count=2) then

      free_flag_carry<='1';
      
     else 
      free_flag_carry<='0';

     end if;
     
     first_free_rename_carry<=first_free_rename_carry_var; 
         

  end process;



   process(free_rename_zero)

 --variable rename_free_var:unsigned: ='0';
 --variable free_reg_repr:integer range 0 to 2**63;
     variable i:integer range 0 to 2**8;
     variable count:integer range 0 to 2;
     variable current_position:integer range 0 to 63;
     variable first_free_rename_zero_var:slv3_array_t(0 to 1); --denotes the first rename register
    begin
   
    
    count:=0;
    i:=to_integer(unsigned(free_rename_zero));
    current_position:=0;
    first_free_rename_zero_var:=(others=>(others=>'0'));
    --for i in 0 to 59 loop
     --for j in 0 to 59 loop
    
     while (i > 0) loop

      if (i mod 2 = 1) then
        first_free_rename_zero_var(count):=std_logic_vector(to_unsigned(current_position,3));
        count:=count+1;
      end if;
      current_position:=current_position+1;

      exit when count=2;

      i:=i/2;
        

      
     	
     end loop;


     if (count=2) then

      free_flag_zero<='1';
      
     else 
      free_flag_zero<='0';

     end if;
     
     first_free_rename_zero<=first_free_rename_zero_var; 
         

  end process;





 
 
process(alu_instr_valid_out_internal)

 --variable rename_free_var:unsigned: ='0';
 --variable free_reg_repr:integer range 0 to 2**63;


 variable i:integer range 0 to 2**10;
 variable count:integer range 0 to 2;
 variable current_position:integer range 0 to 63;
 variable alu_vacant_entry_var:slv6_int_array_t(0 to 1); --denotes the first rename register
  begin
  
   --alu_comp_valid_out_internal<=(alu_instr_valid_out_internal ) ^ temp;
   
    
    count:=0;
    i:=to_integer(unsigned(alu_instr_valid_out_internal));
	 
	 i:=2**10-1-i;
    current_position:=0;
    alu_vacant_entry_var:=(others=>0);
    --for i in 0 to 59 loop
     --for j in 0 to 59 loop
    
     while (i > 0) loop

      if (i mod 2 = 1) then --since bit one denotes occupied
        alu_vacant_entry_var(count):=(9-current_position);--since conversion to integer is happening in opposite way
        count:=count+1;
      end if;
      current_position:=current_position+1;

      exit when count=2;

      i:=i/2;
        

      
     	
     end loop;

     if (count=2) then

      alu_entry_free<='1';
      
     else 
      alu_entry_free<='0';

     end if;


     
     alu_vacant_entry<=alu_vacant_entry_var; 
         
end process;


process(ls_instr_valid_out_internal)

 variable i:integer range 0 to 2**10;
 variable count:integer range 0 to 2;
 variable current_position:integer range 0 to 63;
 variable ls_vacant_entry_var:slv6_int_array_t(0 to 1); --denotes the first rename register
  begin
   
    
    count:=0;
    i:=to_integer(unsigned(ls_instr_valid_out_internal));
	 i:=2**10-1-i;
    current_position:=0;
    ls_vacant_entry_var:=(others=>0);
    --for i in 0 to 59 loop
     --for j in 0 to 59 loop
    
     while (i > 0) loop

      if (i mod 2 = 1) then --since bit 0 denotes free
        ls_vacant_entry_var(count):=(9-current_position);--since conversion to integer is happening in opposite way
        count:=count+1;
      end if;
      current_position:=current_position+1;

      exit when count=2;

      i:=i/2;
        

      
     	
     end loop;

     if (count=2) then

      ls_entry_free<='1';
      
     else 
      ls_entry_free<='0';

     end if;


     
     ls_vacant_entry<=ls_vacant_entry_var; 
         
end process;


process(jmp_instr_valid_out_internal)--finds out first free places in jump of RS

 variable i:integer range 0 to 2**10;
 variable count:integer range 0 to 2;
 variable current_position:integer range 0 to 63;
 variable jmp_vacant_entry_var:slv6_int_array_t(0 to 1); --denotes the first rename register
  begin
   
    
    count:=0;
    i:=to_integer(unsigned(jmp_instr_valid_out_internal));
    current_position:=0;
	 i:=2**10-1-i;
    jmp_vacant_entry_var:=(others=>0);
    --for i in 0 to 59 loop
     --for j in 0 to 59 loop
    
     while (i > 0) loop

      if (i mod 2 = 1) then  --since bit 0 denotes free
        jmp_vacant_entry_var(count):=(9-current_position);--since conversion to integer is happening in opposite way
        count:=count+1;
      end if;
      current_position:=current_position+1;

      exit when count=2;

      i:=i/2;
        

      
     	
     end loop;

     if (count=2) then

      jmp_entry_free<='1';
      
     else 
      jmp_entry_free<='0';

     end if;


     
     jmp_vacant_entry<=jmp_vacant_entry_var; 
         
end process;















process (op_code1_in,op_code2_in,alu_entry_free,ls_entry_free,jmp_entry_free,rename_free,free_flag_zero,free_flag_carry) --decides whether able to make an entry in RS or not

    begin
      if ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010" or op_code1_in="0011" or op_code1_in="0100" or op_code1_in="1000" or op_code1_in="1001") or  
      (op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001")) then--al except BEQ and SW 
        if (rename_free='0' or alu_entry_free='0' or ls_entry_free='0' or jmp_entry_free='0' or free_flag_zero='0' or free_flag_carry='0') then --checks whether rename register is available or not

          halt_out_internal<='1';

        else 
           
           halt_out_internal<='0';

        end if;     


      else --non destination instructions

         if (alu_entry_free='0' or ls_entry_free='0' or jmp_entry_free='0') then

          halt_out_internal<='1';

        else 
           
           halt_out_internal<='0';

        end if;
        
       end if;      


 end process; 



process(arf_value_valid,arf_reg_rename,arf_reg_value,opr1_code1_in,opr2_code1_in,opr3_code1_in,carry_value_valid,carry_value,carry_rename_rf,zero_value_valid,zero_value,zero_rename_rf,
        broadcast1_orig_destn_in,broadcast1_rename_in,broadcast1_valid_in , broadcast2_orig_destn_in,broadcast2_rename_in,broadcast2_valid_in ,broadcast3_orig_destn_in,broadcast3_rename_in,broadcast3_valid_in,
        broadcast4_orig_destn_in,broadcast4_rename_in,broadcast4_valid_in,broadcast5_orig_destn_in,broadcast5_rename_in,broadcast5_valid_in ,broadcast1_c_flag_in,broadcast1_c_flag_rename_in
        ,broadcast1_c_flag_valid_in,broadcast2_c_flag_in,broadcast2_c_flag_rename_in,broadcast2_c_flag_valid_in ,broadcast4_c_flag_in,broadcast4_c_flag_rename_in
        ,broadcast4_c_flag_valid_in,broadcast1_z_flag_in,broadcast1_z_flag_rename_in,broadcast1_z_flag_valid_in,broadcast2_z_flag_in,broadcast2_z_flag_rename_in,broadcast2_z_flag_valid_in 
        ,broadcast4_z_flag_in,broadcast4_z_flag_rename_in,broadcast4_z_flag_valid_in,broadcast1_data_in,broadcast2_data_in,broadcast3_data_in,broadcast4_data_in,broadcast5_data_in )----------------------finding what to write in RS for instr1 includes carry and zero flag as well

   begin


      if( arf_value_valid(to_integer(unsigned(opr1_code1_in))) = '1') then

        operand1_out_internal_instr1<=arf_reg_value(to_integer(unsigned(opr1_code1_in)));
        operand1_out_internal_data_valid_instr1<='1';

      --the following case considee the source and broadcast request appear simultaneously  

      elsif (broadcast1_orig_destn_in=opr1_code1_in and arf_reg_rename(to_integer(unsigned(opr1_code1_in)))=broadcast1_rename_in and broadcast1_valid_in='1') then
       
        operand1_out_internal_instr1<=broadcast1_data_in;
        operand1_out_internal_data_valid_instr1<='1';

      elsif (broadcast2_orig_destn_in=opr1_code1_in and arf_reg_rename(to_integer(unsigned(opr1_code1_in)))=broadcast2_rename_in and broadcast2_valid_in='1') then
       
        operand1_out_internal_instr1<=broadcast2_data_in;
        operand1_out_internal_data_valid_instr1<='1'; 

      elsif (broadcast3_orig_destn_in=opr1_code1_in and arf_reg_rename(to_integer(unsigned(opr1_code1_in)))=broadcast3_rename_in and broadcast3_valid_in='1') then
       
        operand1_out_internal_instr1<=broadcast3_data_in;
        operand1_out_internal_data_valid_instr1<='1';

      elsif (broadcast4_orig_destn_in=opr1_code1_in and arf_reg_rename(to_integer(unsigned(opr1_code1_in)))=broadcast4_rename_in and broadcast4_valid_in='1') then
       
        operand1_out_internal_instr1<=broadcast4_data_in;
        operand1_out_internal_data_valid_instr1<='1';

      elsif (broadcast5_orig_destn_in=opr1_code1_in and arf_reg_rename(to_integer(unsigned(opr1_code1_in)))=broadcast5_rename_in and broadcast5_valid_in='1') then
       
        operand1_out_internal_instr1<=broadcast5_data_in;
        operand1_out_internal_data_valid_instr1<='1';       

         
      

      else
         operand1_out_internal_instr1<= "0000000000" & arf_reg_rename(to_integer(unsigned(opr1_code1_in)));
         operand1_out_internal_data_valid_instr1<='0';  
        


      end if;



      if( arf_value_valid(to_integer(unsigned(opr2_code1_in))) = '1') then

        operand2_out_internal_instr1<=arf_reg_value(to_integer(unsigned(opr2_code1_in)));
        operand2_out_internal_data_valid_instr1<='1';
      --the following case considee the source and broadcast request appear simultaneously 

      elsif (broadcast1_orig_destn_in=opr2_code1_in and arf_reg_rename(to_integer(unsigned(opr2_code1_in)))=broadcast1_rename_in and broadcast1_valid_in='1') then
       
        operand2_out_internal_instr1<=broadcast1_data_in;
        operand2_out_internal_data_valid_instr1<='1';

      elsif (broadcast2_orig_destn_in=opr2_code1_in and arf_reg_rename(to_integer(unsigned(opr2_code1_in)))=broadcast2_rename_in and broadcast2_valid_in='1') then
       
        operand2_out_internal_instr1<=broadcast2_data_in;
        operand2_out_internal_data_valid_instr1<='1'; 

      elsif (broadcast3_orig_destn_in=opr2_code1_in and arf_reg_rename(to_integer(unsigned(opr2_code1_in)))=broadcast3_rename_in and broadcast3_valid_in='1') then
       
        operand2_out_internal_instr1<=broadcast3_data_in;
        operand2_out_internal_data_valid_instr1<='1';

      elsif (broadcast4_orig_destn_in=opr2_code1_in and arf_reg_rename(to_integer(unsigned(opr2_code1_in)))=broadcast4_rename_in and broadcast4_valid_in='1') then
       
        operand2_out_internal_instr1<=broadcast4_data_in;
        operand2_out_internal_data_valid_instr1<='1';

      elsif (broadcast5_orig_destn_in=opr2_code1_in and arf_reg_rename(to_integer(unsigned(opr2_code1_in)))=broadcast5_rename_in and broadcast5_valid_in='1') then
       
        operand2_out_internal_instr1<=broadcast5_data_in;
        operand2_out_internal_data_valid_instr1<='1';   

      else

         operand2_out_internal_instr1<= "0000000000" & arf_reg_rename(to_integer(unsigned(opr2_code1_in)));  
         operand2_out_internal_data_valid_instr1<='0';
        


      end if;



      if( arf_value_valid(to_integer(unsigned(opr3_code1_in))) = '1') then

        operand3_out_internal_instr1<=arf_reg_value(to_integer(unsigned(opr3_code1_in)));
        operand3_out_internal_data_valid_instr1<='1';
      --the following case considee the source and broadcast request appear simultaneously 

       elsif (broadcast1_orig_destn_in=opr3_code1_in and arf_reg_rename(to_integer(unsigned(opr3_code1_in)))=broadcast1_rename_in and broadcast1_valid_in='1') then
       
        operand3_out_internal_instr1<=broadcast1_data_in;
        operand3_out_internal_data_valid_instr1<='1';

      elsif (broadcast2_orig_destn_in=opr3_code1_in and arf_reg_rename(to_integer(unsigned(opr3_code1_in)))=broadcast2_rename_in and broadcast2_valid_in='1') then
       
        operand3_out_internal_instr1<=broadcast2_data_in;
        operand3_out_internal_data_valid_instr1<='1'; 

      elsif (broadcast3_orig_destn_in=opr3_code1_in and arf_reg_rename(to_integer(unsigned(opr3_code1_in)))=broadcast3_rename_in and broadcast3_valid_in='1') then
       
        operand3_out_internal_instr1<=broadcast3_data_in;
        operand3_out_internal_data_valid_instr1<='1';

      elsif (broadcast4_orig_destn_in=opr3_code1_in and arf_reg_rename(to_integer(unsigned(opr3_code1_in)))=broadcast4_rename_in and broadcast4_valid_in='1') then
       
        operand3_out_internal_instr1<=broadcast4_data_in;
        operand3_out_internal_data_valid_instr1<='1';

      elsif (broadcast5_orig_destn_in=opr3_code1_in and arf_reg_rename(to_integer(unsigned(opr3_code1_in)))=broadcast5_rename_in and broadcast5_valid_in='1') then
       
        operand3_out_internal_instr1<=broadcast5_data_in;
        operand3_out_internal_data_valid_instr1<='1';  

      else

         operand3_out_internal_instr1<= "0000000000" & arf_reg_rename(to_integer(unsigned(opr3_code1_in)));
         operand3_out_internal_data_valid_instr1<='0';  
        


      end if;

      if( carry_value_valid = '1') then

        operand_carry_value_internal_instr1<=carry_value;
        operand_carry_rename_internal_instr1<=(others=>'0');
        operand_carry_bit_valid_instr1<='1';


      elsif ( carry_rename_rf =broadcast1_c_flag_rename_in and broadcast1_c_flag_valid_in='1') then
       
        operand_carry_value_internal_instr1<=broadcast1_c_flag_in;
        operand_carry_rename_internal_instr1<=(others=>'0');
        operand_carry_bit_valid_instr1<='1';



      elsif ( carry_rename_rf =broadcast2_c_flag_rename_in and broadcast2_c_flag_valid_in='1') then
       
        operand_carry_value_internal_instr1<=broadcast2_c_flag_in;
        operand_carry_rename_internal_instr1<=(others=>'0');
        operand_carry_bit_valid_instr1<='1';
 

      elsif ( carry_rename_rf =broadcast4_c_flag_rename_in and broadcast4_c_flag_valid_in='1') then
       
        operand_carry_value_internal_instr1<=broadcast4_c_flag_in;
        operand_carry_rename_internal_instr1<=(others=>'0');
        operand_carry_bit_valid_instr1<='1';


      else

        operand_carry_value_internal_instr1<='0';
        operand_carry_rename_internal_instr1<=carry_rename_rf;
        operand_carry_bit_valid_instr1<='0';  
        


      end if;


      if( zero_value_valid = '1') then

        operand_zero_value_internal_instr1<=zero_value;
        operand_zero_rename_internal_instr1<=(others=>'0');
        operand_zero_bit_valid_instr1<='1';

      elsif ( zero_rename_rf =broadcast1_z_flag_rename_in and broadcast1_z_flag_valid_in='1') then
       
        operand_zero_value_internal_instr1<=broadcast1_z_flag_in;
        operand_zero_rename_internal_instr1<=(others=>'0');
        operand_zero_bit_valid_instr1<='1';



      elsif ( zero_rename_rf =broadcast2_z_flag_rename_in and broadcast2_z_flag_valid_in='1') then
       
        operand_zero_value_internal_instr1<=broadcast2_z_flag_in;
        operand_zero_rename_internal_instr1<=(others=>'0');
        operand_zero_bit_valid_instr1<='1';
 

      elsif ( zero_rename_rf =broadcast4_z_flag_rename_in and broadcast4_z_flag_valid_in='1') then
       
        operand_zero_value_internal_instr1<=broadcast4_z_flag_in;
        operand_zero_rename_internal_instr1<=(others=>'0');
        operand_zero_bit_valid_instr1<='1';



      else

        operand_zero_value_internal_instr1<='0';
        operand_zero_rename_internal_instr1<=zero_rename_rf;
        operand_zero_bit_valid_instr1<='0';   
        


      end if;







      


end process;




process(arf_value_valid,arf_reg_rename,arf_reg_value,opr1_code2_in,opr2_code2_in,opr3_code2_in,carry_value_valid,carry_value,carry_rename_rf,zero_value_valid,zero_value,zero_rename_rf,broadcast1_orig_destn_in,broadcast1_rename_in,broadcast1_valid_in , broadcast2_orig_destn_in,broadcast2_rename_in,broadcast2_valid_in ,broadcast3_orig_destn_in,broadcast3_rename_in,broadcast3_valid_in,
        broadcast4_orig_destn_in,broadcast4_rename_in,broadcast4_valid_in,broadcast5_orig_destn_in,broadcast5_rename_in,broadcast5_valid_in ,broadcast1_c_flag_in,broadcast1_c_flag_rename_in
        ,broadcast1_c_flag_valid_in,broadcast2_c_flag_in,broadcast2_c_flag_rename_in,broadcast2_c_flag_valid_in ,broadcast4_c_flag_in,broadcast4_c_flag_rename_in
        ,broadcast4_c_flag_valid_in,broadcast1_z_flag_in,broadcast1_z_flag_rename_in,broadcast1_z_flag_valid_in,broadcast2_z_flag_in,broadcast2_z_flag_rename_in,broadcast2_z_flag_valid_in 
        ,broadcast4_z_flag_in,broadcast4_z_flag_rename_in,broadcast4_z_flag_valid_in,broadcast1_data_in,broadcast2_data_in,broadcast3_data_in,broadcast4_data_in,broadcast5_data_in,destn_code1_in,instr1_valid_in
        ,op_code1_in,first_free_rename,first_free_rename_carry,first_free_rename_zero,instr2_valid_in)----------------------checking what to write in RS for instr2

   begin

      
      if (destn_code1_in=opr1_code2_in and instr1_valid_in='1' and not (op_code1_in="1100" or op_code1_in="0101")) then

        operand1_out_internal_instr2<="0000000000" & first_free_rename(0);
        operand1_out_internal_data_valid_instr2<='0';      


      elsif( arf_value_valid(to_integer(unsigned(opr1_code2_in))) = '1') then

        operand1_out_internal_instr2<=arf_reg_value(to_integer(unsigned(opr1_code2_in)));
        operand1_out_internal_data_valid_instr2<='1';
      
      --the following case considee the source and broadcast request appear simultaneously 
      elsif (broadcast1_orig_destn_in=opr1_code2_in and arf_reg_rename(to_integer(unsigned(opr1_code2_in)))=broadcast1_rename_in and broadcast1_valid_in='1') then
       
        operand1_out_internal_instr2<=broadcast1_data_in;
        operand1_out_internal_data_valid_instr2<='1';

      elsif (broadcast2_orig_destn_in=opr1_code2_in and arf_reg_rename(to_integer(unsigned(opr1_code2_in)))=broadcast2_rename_in and broadcast2_valid_in='1') then
       
        operand1_out_internal_instr2<=broadcast2_data_in;
        operand1_out_internal_data_valid_instr2<='1'; 

      elsif (broadcast3_orig_destn_in=opr1_code2_in and arf_reg_rename(to_integer(unsigned(opr1_code2_in)))=broadcast3_rename_in and broadcast3_valid_in='1') then
       
        operand1_out_internal_instr2<=broadcast3_data_in;
        operand1_out_internal_data_valid_instr2<='1';

      elsif (broadcast4_orig_destn_in=opr1_code2_in and arf_reg_rename(to_integer(unsigned(opr1_code2_in)))=broadcast4_rename_in and broadcast4_valid_in='1') then
       
        operand1_out_internal_instr2<=broadcast4_data_in;
        operand1_out_internal_data_valid_instr2<='1';

      elsif (broadcast5_orig_destn_in=opr1_code2_in and arf_reg_rename(to_integer(unsigned(opr1_code2_in)))=broadcast5_rename_in and broadcast5_valid_in='1') then
       
        operand1_out_internal_instr2<=broadcast5_data_in;
        operand1_out_internal_data_valid_instr2<='1';  



      else

         operand1_out_internal_instr2<= "0000000000" & arf_reg_rename(to_integer(unsigned(opr1_code2_in)));
         operand1_out_internal_data_valid_instr2<='0';  
        


      end if;


      if (destn_code1_in=opr2_code2_in and instr1_valid_in='1' and not (op_code1_in="1100" or op_code1_in="0101")) then

        operand2_out_internal_instr2<="0000000000" & first_free_rename(0);
        operand2_out_internal_data_valid_instr2<='0';  



      elsif( arf_value_valid(to_integer(unsigned(opr2_code2_in))) = '1') then

        operand2_out_internal_instr2<=arf_reg_value(to_integer(unsigned(opr2_code2_in)));
        operand2_out_internal_data_valid_instr2<='1';
      --the following case considee the source and broadcast request appear simultaneously 
      elsif (broadcast1_orig_destn_in=opr2_code2_in and arf_reg_rename(to_integer(unsigned(opr2_code2_in)))=broadcast1_rename_in and broadcast1_valid_in='1') then
       
        operand2_out_internal_instr2<=broadcast1_data_in;
        operand2_out_internal_data_valid_instr2<='1';

      elsif (broadcast2_orig_destn_in=opr2_code2_in and arf_reg_rename(to_integer(unsigned(opr2_code2_in)))=broadcast2_rename_in and broadcast2_valid_in='1') then
       
        operand2_out_internal_instr2<=broadcast2_data_in;
        operand2_out_internal_data_valid_instr2<='1'; 

      elsif (broadcast3_orig_destn_in=opr2_code2_in and arf_reg_rename(to_integer(unsigned(opr2_code2_in)))=broadcast3_rename_in and broadcast3_valid_in='1') then
       
        operand2_out_internal_instr2<=broadcast3_data_in;
        operand2_out_internal_data_valid_instr2<='1';

      elsif (broadcast4_orig_destn_in=opr2_code2_in and arf_reg_rename(to_integer(unsigned(opr2_code2_in)))=broadcast4_rename_in and broadcast4_valid_in='1') then
       
        operand2_out_internal_instr2<=broadcast4_data_in;
        operand2_out_internal_data_valid_instr2<='1';

      elsif (broadcast5_orig_destn_in=opr2_code2_in and arf_reg_rename(to_integer(unsigned(opr2_code2_in)))=broadcast5_rename_in and broadcast5_valid_in='1') then
       
        operand2_out_internal_instr2<=broadcast5_data_in;
        operand2_out_internal_data_valid_instr2<='1';  


      else

         operand2_out_internal_instr2<= "0000000000" & arf_reg_rename(to_integer(unsigned(opr2_code2_in)));
         operand2_out_internal_data_valid_instr2<='0';  
        


      end if;



      if (destn_code1_in=opr3_code2_in and instr1_valid_in='1' and not (op_code1_in="1100" or op_code1_in="0101")) then

        operand3_out_internal_instr2<="0000000000" & first_free_rename(0);
        operand3_out_internal_data_valid_instr2<='0';  




      elsif( arf_value_valid(to_integer(unsigned(opr3_code2_in))) = '1') then

        operand3_out_internal_instr2<=arf_reg_value(to_integer(unsigned(opr3_code2_in)));
        operand3_out_internal_data_valid_instr2<='1';
      --the following case considee the source and broadcast request appear simultaneously  
      elsif (broadcast1_orig_destn_in=opr3_code2_in and arf_reg_rename(to_integer(unsigned(opr3_code2_in)))=broadcast1_rename_in and broadcast1_valid_in='1') then
       
        operand3_out_internal_instr2<=broadcast1_data_in;
        operand3_out_internal_data_valid_instr2<='1';

      elsif (broadcast2_orig_destn_in=opr3_code2_in and arf_reg_rename(to_integer(unsigned(opr3_code2_in)))=broadcast2_rename_in and broadcast2_valid_in='1') then
       
        operand3_out_internal_instr2<=broadcast2_data_in;
        operand3_out_internal_data_valid_instr2<='1'; 

      elsif (broadcast3_orig_destn_in=opr3_code2_in and arf_reg_rename(to_integer(unsigned(opr3_code2_in)))=broadcast3_rename_in and broadcast3_valid_in='1') then
       
        operand3_out_internal_instr2<=broadcast3_data_in;
        operand3_out_internal_data_valid_instr2<='1';

      elsif (broadcast4_orig_destn_in=opr3_code2_in and arf_reg_rename(to_integer(unsigned(opr3_code2_in)))=broadcast4_rename_in and broadcast4_valid_in='1') then
       
        operand3_out_internal_instr2<=broadcast4_data_in;
        operand3_out_internal_data_valid_instr2<='1';

      elsif (broadcast5_orig_destn_in=opr3_code2_in and arf_reg_rename(to_integer(unsigned(opr3_code2_in)))=broadcast5_rename_in and broadcast5_valid_in='1') then
       
        operand3_out_internal_instr2<=broadcast5_data_in;
        operand3_out_internal_data_valid_instr2<='1';  
 




      else

         operand3_out_internal_instr2<= "0000000000" & arf_reg_rename(to_integer(unsigned(opr3_code2_in)));
         operand3_out_internal_data_valid_instr2<='0';  
        


      end if;

      
      if ((op_code1_in="0000" or op_code1_in="0001") and instr1_valid_in='1') then

         operand_carry_value_internal_instr2<='0';
         operand_carry_rename_internal_instr2<=first_free_rename_carry(0);
         operand_carry_bit_valid_instr2<='0';



      elsif( carry_value_valid = '1') then

        operand_carry_value_internal_instr2<=carry_value;
        operand_carry_rename_internal_instr2<=(others=>'0');
        operand_carry_bit_valid_instr2<='1';

      elsif ( carry_rename_rf =broadcast1_c_flag_rename_in and broadcast1_c_flag_valid_in='1') then
       
        operand_carry_value_internal_instr2<=broadcast1_c_flag_in;
        operand_carry_rename_internal_instr2<=(others=>'0');
        operand_carry_bit_valid_instr2<='1';



      elsif ( carry_rename_rf =broadcast2_c_flag_rename_in and broadcast2_c_flag_valid_in='1') then
       
        operand_carry_value_internal_instr2<=broadcast2_c_flag_in;
        operand_carry_rename_internal_instr2<=(others=>'0');
        operand_carry_bit_valid_instr2<='1';
 

      elsif ( carry_rename_rf =broadcast4_c_flag_rename_in and broadcast4_c_flag_valid_in='1') then
       
        operand_carry_value_internal_instr2<=broadcast4_c_flag_in;
        operand_carry_rename_internal_instr2<=(others=>'0');
        operand_carry_bit_valid_instr2<='1';



      else

        operand_carry_value_internal_instr2<='0';
        operand_carry_rename_internal_instr2<=carry_rename_rf;
        operand_carry_bit_valid_instr2<='0';  
        


      end if;


      if ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010") and instr1_valid_in='1') then

         operand_zero_value_internal_instr2<='0';
         operand_zero_rename_internal_instr2<=first_free_rename_zero(0);
         operand_zero_bit_valid_instr2<='0';



      elsif( zero_value_valid = '1') then

        operand_zero_value_internal_instr2<=zero_value;
        operand_zero_rename_internal_instr2<=(others=>'0');
        operand_zero_bit_valid_instr2<='1';
       
       elsif ( zero_rename_rf =broadcast1_z_flag_rename_in and broadcast1_z_flag_valid_in='1') then
       
        operand_zero_value_internal_instr2<=broadcast1_z_flag_in;
        operand_zero_rename_internal_instr2<=(others=>'0');
        operand_zero_bit_valid_instr2<='1';



      elsif ( zero_rename_rf =broadcast2_z_flag_rename_in and broadcast2_z_flag_valid_in='1') then
       
        operand_zero_value_internal_instr2<=broadcast2_c_flag_in;
        operand_zero_rename_internal_instr2<=(others=>'0');
        operand_zero_bit_valid_instr2<='1';
 

      elsif ( zero_rename_rf =broadcast4_z_flag_rename_in and broadcast4_z_flag_valid_in='1') then
       
        operand_zero_value_internal_instr2<=broadcast4_z_flag_in;
        operand_zero_rename_internal_instr2<=(others=>'0');
        operand_zero_bit_valid_instr2<='1';




      else

        operand_zero_value_internal_instr2<='0';
        operand_zero_rename_internal_instr2<=zero_rename_rf;
        operand_zero_bit_valid_instr2<='0';  
        


      end if;




      
      


end process;          
           



--original ARF updating process

process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,first_free_rename,op_code2_in,broadcast1_valid_in,broadcast1_rename_in,broadcast1_data_in,

         broadcast2_valid_in,broadcast2_rename_in,broadcast3_data_in,broadcast3_valid_in,broadcast3_rename_in,broadcast4_valid_in,broadcast4_rename_in,broadcast4_data_in)

                                                                                                                     --only updates the arf table not anything else

  variable i:integer range 0 to 7;

  --variable free_reg_var:
  
  begin 

    --i:=0;

  for i in 0 to 7 loop


     if (reset_system='1') then
         --free_reg<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<='0';
         arf_reg_rename(i)<=(others=>'0');
         arf_reg_value(i)<=(others=>'0');
         arf_value_valid(i)<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --halting won't be guided by internal halt_out signal for broadcast
       
      if (branch_mispredict_broadcast_in="01") then

       arf_reg_rename(i)<=br1_arf_reg_rename(i);
       arf_reg_value(i)<=br1_arf_reg_value(i);
       arf_value_valid(i)<=br1_arf_value_valid(i);

      elsif (branch_mispredict_broadcast_in="10") then

       arf_reg_rename(i)<=br2_arf_reg_rename(i);
       arf_reg_value(i)<=br2_arf_reg_value(i);
       arf_value_valid(i)<=br2_arf_value_valid(i);

      else 

       if (broadcast1_valid_in='1' and arf_reg_rename(i)=broadcast1_rename_in and arf_value_valid(i)='0') then --checking broadcast signals to RRF 

          arf_value_valid(i)<='1';
          arf_reg_value(i)<=broadcast1_data_in;
          --free_reg(to_integer(unsigned(broadcast1_rename_in)))<='1';


       elsif (broadcast2_valid_in='1' and arf_reg_rename(i)=broadcast2_rename_in and arf_value_valid(i)='0') then

          arf_value_valid(i)<='1';
          arf_reg_value(i)<=broadcast2_data_in;
          --free_reg(to_integer(unsigned(broadcast2_rename_in)))<='1';


       elsif (broadcast3_valid_in='1' and arf_reg_rename(i)=broadcast3_rename_in and arf_value_valid(i)='0') then

          arf_value_valid(i)<='1';
          arf_reg_value(i)<=broadcast3_data_in;
          --free_reg(to_integer(unsigned(broadcast3_rename_in)))<='1';


       elsif (broadcast4_valid_in='1' and arf_reg_rename(i)=broadcast4_rename_in and arf_value_valid(i)='0') then

          arf_value_valid(i)<='1';
          arf_reg_value(i)<=broadcast4_data_in;
          --free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';

       elsif (broadcast5_valid_in='1' and arf_reg_rename(i)=broadcast5_rename_in and arf_value_valid(i)='0') then

          arf_value_valid(i)<='1';
          arf_reg_value(i)<=broadcast5_data_in;
        end if;     


     if (halt_out_internal='0') then

      if ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010" or op_code1_in="0011" or op_code1_in="0100" or op_code1_in="1000" or op_code1_in="1001") and instr1_valid_in='1'

           and (op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001") and instr2_valid_in='1') then
                                                                                                                                     --all instructions from both sets which modify registers
                                                                                                                                    --instr added as validity to be checked before renaming register
            if (i=to_integer(unsigned(opr3_code2_in)))  then
               
               arf_reg_rename(i)<=first_free_rename(1);
               arf_value_valid(i)<='0';
               --free_reg(to_integer(unsigned(first_free_rename(0))))<='0';

            elsif (i=to_integer(unsigned(opr3_code1_in))) then
              
                arf_reg_rename(i)<=first_free_rename(0);
                arf_value_valid(i)<='0';
                --free_reg(to_integer(unsigned(first_free_rename(1))))<='0';

            end if;    

       elsif ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010" or op_code1_in="0011" or op_code1_in="0100" or op_code1_in="1000" or op_code1_in="1001") and instr1_valid_in='1'

           and (op_code2_in="0101" or op_code2_in="1100" or instr2_valid_in='0')) then --first set modifies destn --next set doesn't 

           if (i=to_integer(unsigned(opr3_code1_in)))  then
               
               arf_reg_rename(i)<=first_free_rename(0);
               arf_value_valid(i)<='0';
               --free_reg(to_integer(unsigned(first_free_rename(0))))<='0';

            end if;
            

       elsif ((op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001") and instr2_valid_in='1'

           and (op_code1_in="0101" or op_code1_in="1100" or instr1_valid_in='0')) then --opposite of prev case

           if (i=to_integer(unsigned(opr3_code2_in)))  then
               
               arf_reg_rename(i)<=first_free_rename(1);
               arf_value_valid(i)<='0';
               --free_reg(to_integer(unsigned(first_free_rename(1))))<='0';
            end if;
        
        end if;


                    
        
          --free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';

                
         end if;
     end if;    


     end if;


   end loop;
    
 end process;


 -----updating branch 1 arf 
 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,first_free_rename,op_code2_in,broadcast1_valid_in,broadcast1_rename_in,broadcast1_data_in,

         broadcast2_valid_in,broadcast2_rename_in,broadcast3_data_in,broadcast3_valid_in,broadcast3_rename_in,broadcast4_valid_in,broadcast4_rename_in,broadcast4_data_in,branch1_done)

                                                                                                                     --only updates the arf table not anything else

  variable i:integer range 0 to 7;

  --variable free_reg_var:
  
  begin 

    --i:=0;

  for i in 0 to 7 loop


     if (reset_system='1') then
         --free_reg<=(others=>'1');--at start all RRF's are free
         --br1_arf_rename_valid(i)<=arf_rename_valid(i);
         br1_arf_reg_rename(i)<=(others=>'0');
         br1_arf_reg_value(i)<=(others=>'0');
         br1_arf_value_valid(i)<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0') then --broadcast updates happen even for internal hault

        if (branch1_done='1') then
         --free_reg<=(others=>'1');--at start all RRF's are free
         --br1_arf_rename_valid(i)<=arf_rename_valid(i);
         br1_arf_reg_rename(i)<=arf_reg_rename(i);
         br1_arf_reg_value(i)<=arf_reg_value(i);
         br1_arf_value_valid(i)<=arf_value_valid(i);
       
      

        elsif (broadcast1_valid_in='1' and br1_arf_reg_rename(i)=broadcast1_rename_in and br1_arf_value_valid(i)='0' and broadcast1_btag_in="000") then --checking broadcast signals to RRF 

          br1_arf_value_valid(i)<='1';
          br1_arf_reg_value(i)<=broadcast1_data_in;
          --free_reg(to_integer(unsigned(broadcast1_rename_in)))<='1';


         elsif (broadcast2_valid_in='1' and br1_arf_reg_rename(i)=broadcast2_rename_in and br1_arf_value_valid(i)='0' and broadcast2_btag_in="000") then

          br1_arf_value_valid(i)<='1';
          br1_arf_reg_value(i)<=broadcast2_data_in;
          --free_reg(to_integer(unsigned(broadcast2_rename_in)))<='1';


         elsif (broadcast3_valid_in='1' and br1_arf_reg_rename(i)=broadcast3_rename_in and br1_arf_value_valid(i)='0' and broadcast3_btag_in="000") then

          br1_arf_value_valid(i)<='1';
          br1_arf_reg_value(i)<=broadcast3_data_in;
          --free_reg(to_integer(unsigned(broadcast3_rename_in)))<='1';


         elsif (broadcast4_valid_in='1' and br1_arf_reg_rename(i)=broadcast4_rename_in and br1_arf_value_valid(i)='0' and broadcast4_btag_in="000") then

          br1_arf_value_valid(i)<='1';
          br1_arf_reg_value(i)<=broadcast4_data_in;
          --free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';

         elsif (broadcast5_valid_in='1' and br1_arf_reg_rename(i)=broadcast5_rename_in and br1_arf_value_valid(i)='0' and broadcast5_btag_in="000") then

          br1_arf_value_valid(i)<='1';
          br1_arf_reg_value(i)<=broadcast5_data_in; 


                
         end if;


     end if;


   end loop;
    
 end process;


 ---branch 2 arf


 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,first_free_rename,op_code2_in,broadcast1_valid_in,broadcast1_rename_in,broadcast1_data_in,

         broadcast2_valid_in,broadcast2_rename_in,broadcast3_data_in,broadcast3_valid_in,broadcast3_rename_in,broadcast4_valid_in,broadcast4_rename_in,broadcast4_data_in,branch2_done)

                                                                                                                     --only updates the arf table not anything else

  variable i:integer range 0 to 7;

  --variable free_reg_var:
  
  begin 

    --i:=0;

  for i in 0 to 7 loop


     if (reset_system='1') then
         --free_reg<=(others=>'1');--at start all RRF's are free
         --br1_arf_rename_valid(i)<=arf_rename_valid(i);
         br2_arf_reg_rename(i)<=(others=>'0');
         br2_arf_reg_value(i)<=(others=>'0');
         br2_arf_value_valid(i)<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0') then --broadcast signals happen here
       
        if (branch2_done='1') then
         --free_reg<=(others=>'1');--at start all RRF's are free
         --br2_arf_rename_valid(i)<=arf_rename_valid(i);
         br2_arf_reg_rename(i)<=arf_reg_rename(i);
         br2_arf_reg_value(i)<=arf_reg_value(i);
         br2_arf_value_valid(i)<=arf_value_valid(i); 


        elsif (broadcast1_valid_in='1' and br2_arf_reg_rename(i)=broadcast1_rename_in and br2_arf_value_valid(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --checking broadcast signals to RRF 

          br2_arf_value_valid(i)<='1';
          br2_arf_reg_value(i)<=broadcast1_data_in;
          --free_reg(to_integer(unsigned(broadcast1_rename_in)))<='1';


         elsif (broadcast2_valid_in='1' and br2_arf_reg_rename(i)=broadcast2_rename_in and br2_arf_value_valid(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then

          br2_arf_value_valid(i)<='1';
          br2_arf_reg_value(i)<=broadcast2_data_in;
          --free_reg(to_integer(unsigned(broadcast2_rename_in)))<='1';


         elsif (broadcast3_valid_in='1' and br2_arf_reg_rename(i)=broadcast3_rename_in and br2_arf_value_valid(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then

          br2_arf_value_valid(i)<='1';
          br2_arf_reg_value(i)<=broadcast3_data_in;
          --free_reg(to_integer(unsigned(broadcast3_rename_in)))<='1';


         elsif (broadcast4_valid_in='1' and br2_arf_reg_rename(i)=broadcast4_rename_in and br2_arf_value_valid(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then

          br2_arf_value_valid(i)<='1';
          br2_arf_reg_value(i)<=broadcast4_data_in;
          --free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';
         elsif (broadcast5_valid_in='1' and br2_arf_reg_rename(i)=broadcast5_rename_in and br2_arf_value_valid(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then

          br2_arf_value_valid(i)<='1';
          br2_arf_reg_value(i)<=broadcast4_data_in; 


                
         end if;


     end if;


   end loop;
    
 end process;



 
 
--original free register table updating proccess

 
 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,first_free_rename,op_code2_in,broadcast1_valid_in,broadcast1_rename_in,broadcast1_data_in,

         broadcast2_valid_in,broadcast2_rename_in,broadcast3_data_in,broadcast3_valid_in,broadcast3_rename_in,broadcast4_data_in,broadcast4_valid_in,broadcast4_rename_in)

                                                                    	                                                 --only updates the free register table not anything else

  --variable i:integer range 0 to 7;

  --variable free_reg_var:
  
  begin 

    --i:=0;

  --for i in 1 to 7 loop


     if (reset_system='1') then
         free_reg<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<='0';
         --arf_reg_rename(i)<=(others=>'0');
         --arf_reg_value(i)<=(others=>'0');
         --arf_value_valid(i)<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults

      if (branch_mispredict_broadcast_in="01") then
       free_reg<=br1_free_reg;
      elsif (branch_mispredict_broadcast_in="10") then
        free_Reg<=br2_free_reg;

      else         --Changed on 6 early morning to make condition mutually exclusive --done on similar condition Also changed position of broadcast from bottom to top


        if (broadcast1_valid_in='1' ) then --checking broadcast signals to RRF 

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast1_data_in;
          free_reg(to_integer(unsigned(broadcast1_rename_in)))<='1';
        end if;  


        if (broadcast2_valid_in='1') then  

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast2_data_in;
          free_reg(to_integer(unsigned(broadcast2_rename_in)))<='1';

        end if;  


        if (broadcast3_valid_in='1') then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast3_data_in;
          free_reg(to_integer(unsigned(broadcast3_rename_in)))<='1';
        
        end if;

        if (broadcast4_valid_in='1' ) then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast4_data_in;
          free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';

        end if;  

        if (broadcast5_valid_in='1' ) then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast4_data_in;
          free_reg(to_integer(unsigned(broadcast5_rename_in)))<='1'; 
         
        end if;

       
    if (halt_out_internal='0') then
      if ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010" or op_code1_in="0011" or op_code1_in="0100" or op_code1_in="1000" or op_code1_in="1001") and instr1_valid_in='1'

           and (op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001") and instr2_valid_in='1') then
                                                                                                                                     --all instructions from both sets which modify registers

            --if (i=to_integer(unsigned(opr3_code1_in)))  then                                                                       --free register to be updated only if instr is valid
               
               --arf_reg_rename(i)<=first_free_rename(0);
               --arf_value_valid(i)<='0';
               free_reg(to_integer(unsigned(first_free_rename(0))))<='0';

            --elsif (i=to_integer(unsigned(opr3_code2_in))) then
              
                --arf_reg_rename(i)<=first_free_rename(1);
                --arf_value_valid(i)<='0';
                free_reg(to_integer(unsigned(first_free_rename(1))))<='0';

            --end if;    

       elsif ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010" or op_code1_in="0011" or op_code1_in="0100" or op_code1_in="1000" or op_code1_in="1001") and instr1_valid_in='1'

           and (op_code2_in="0101" or op_code2_in="1100" or instr2_valid_in='0')) then --first set modifies destn --next set doesn't 

           --if (i=to_integer(unsigned(opr3_code1_in)))  then
               
               --arf_reg_rename(i)<=first_free_rename(0);
               --arf_value_valid(i)<='0';
               free_reg(to_integer(unsigned(first_free_rename(0))))<='0';

            --end if;
            

       elsif ((op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001") and instr2_valid_in='1'

           and (op_code1_in="0101" or op_code1_in="1100" or instr1_valid_in='0')) then --opposite of prev case

           --if (i=to_integer(unsigned(opr3_code2_in)))  then
               
               --arf_reg_rename(i)<=first_free_rename(1);
               --arf_value_valid(i)<='0';
               free_reg(to_integer(unsigned(first_free_rename(1))))<='0';
           --end if;
        
        end if;


       end if; 


      end if;     

        


     end if;


   --end loop;
    
 end process;


 --br1 free reg update

 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,first_free_rename,op_code2_in,broadcast1_valid_in,broadcast1_rename_in,broadcast1_data_in,

         broadcast2_valid_in,broadcast2_rename_in,broadcast3_data_in,broadcast3_valid_in,broadcast3_rename_in,broadcast4_data_in,broadcast4_valid_in,broadcast4_rename_in,branch1_done)

                                                                    	                                                 --only updates the free register table not anything else

  --variable i:integer range 0 to 7;

  --variable free_reg_var:
  
  begin 

    --i:=0;

  --for i in 1 to 7 loop


     if (reset_system='1') then
        br1_free_reg<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<='0';
         --arf_reg_rename(i)<=(others=>'0');
         --arf_reg_value(i)<=(others=>'0');
         --arf_value_valid(i)<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults

       if (branch1_done='1') then
         br1_free_reg<=free_reg;--at start all RRF's are free
       
       elsif (broadcast1_valid_in='1' and broadcast1_btag_in="000") then --checking broadcast signals to RRF 

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast1_data_in;
          br1_free_reg(to_integer(unsigned(broadcast1_rename_in)))<='1';
        end if;  


        if (broadcast2_valid_in='1' and broadcast2_btag_in="000") then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast2_data_in;
          br1_free_reg(to_integer(unsigned(broadcast2_rename_in)))<='1';
        end if;  


        if (broadcast3_valid_in='1' and broadcast3_btag_in="000") then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast3_data_in;
          br1_free_reg(to_integer(unsigned(broadcast3_rename_in)))<='1';
        end if;  


        if (broadcast4_valid_in='1' and broadcast4_btag_in="000") then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast4_data_in;
          br1_free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';
        end if;  

        if (broadcast5_valid_in='1' and broadcast5_btag_in="000") then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast4_data_in;
          br1_free_reg(to_integer(unsigned(broadcast5_rename_in)))<='1'; 
        end if;


     end if;


   --end loop;
    
 end process;

 --br2 update


 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,first_free_rename,op_code2_in,broadcast1_valid_in,broadcast1_rename_in,broadcast1_data_in,

         broadcast2_valid_in,broadcast2_rename_in,broadcast3_data_in,broadcast3_valid_in,broadcast3_rename_in,broadcast4_data_in,broadcast4_valid_in,broadcast4_rename_in,branch2_done)

                                                                    	                                                 --only updates the free register table not anything else

  --variable i:integer range 0 to 7;

  --variable free_reg_var:
  
  begin 

    --i:=0;

  --for i in 1 to 7 loop


     if (reset_system='1') then
        br2_free_reg<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<='0';
         --arf_reg_rename(i)<=(others=>'0');
         --arf_reg_value(i)<=(others=>'0');
         --arf_value_valid(i)<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0') then --broadcasting takes place even in internal haults
       
        if (branch2_done='1') then
         br2_free_reg<=free_reg;--at start all RRF's are free


                    
        elsif (broadcast1_valid_in='1' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --checking broadcast signals to RRF 

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast1_data_in;
          br2_free_reg(to_integer(unsigned(broadcast1_rename_in)))<='1';
        end if;  


        if (broadcast2_valid_in='1' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast2_data_in;
          br2_free_reg(to_integer(unsigned(broadcast2_rename_in)))<='1';
        end if;  


        if (broadcast3_valid_in='1' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast3_data_in;
          br2_free_reg(to_integer(unsigned(broadcast3_rename_in)))<='1';
        end if;  


        if (broadcast4_valid_in='1' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast4_data_in;
          br2_free_reg(to_integer(unsigned(broadcast4_rename_in)))<='1';
        end if;  

        if (broadcast5_valid_in='1' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then

          --arf_value_valid(i)<='1';
          --arf_reg_value(i)<=broadcast4_data_in;
          br2_free_reg(to_integer(unsigned(broadcast5_rename_in)))<='1';
        end if;   


                
         


     end if;


   --end loop;
    
 end process;



--original carry flag update table

process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,op_code2_in,first_free_rename_carry,broadcast1_c_flag_rename_in,broadcast1_c_flag_in,broadcast1_c_flag_valid_in,

         broadcast2_c_flag_valid_in,broadcast2_c_flag_rename_in,broadcast2_c_flag_in,broadcast4_c_flag_in,broadcast4_c_flag_valid_in,broadcast4_c_flag_rename_in) ---only updates the carry flag table not anything else

  --variable i:integer range 0 to 7;
  
  begin 

    --i:=0;

  --for i in 1 to 7 repetition : loop


     if (reset_system='1') then
         free_rename_carry<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         carry_rename_rf<=(others=>'0');
         carry_value<='0';
         carry_value_valid<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults
       
      if (branch_mispredict_broadcast_in="01") then
       free_rename_carry<=br1_free_rename_carry;
       carry_rename_rf<=br1_carry_rename_rf;
       carry_value<=br1_carry_value;
       carry_value_valid<=br1_carry_value_valid;

      elsif (branch_mispredict_broadcast_in="10") then
       
       free_rename_carry<=br2_free_rename_carry;
       carry_rename_rf<=br2_carry_rename_rf;
       carry_value<=br2_carry_value;
       carry_value_valid<=br2_carry_value_valid;

       -------------------------------------------------------------------------broadcast shifted from bottom to top
      else
       

      if (broadcast1_c_flag_valid_in='1' and carry_rename_rf=broadcast1_c_flag_rename_in and carry_value_valid='0') then --checking broadcast signals to RRF 

          carry_value_valid<='1';
          carry_value<=broadcast1_c_flag_in;
          --free_rename_carry(to_integer(unsigned(broadcast1_c_flag_rename_in)))<='1';


       elsif (broadcast2_c_flag_valid_in='1' and carry_rename_rf=broadcast2_c_flag_rename_in and carry_value_valid='0') then

          carry_value_valid<='1';
          carry_value<=broadcast2_c_flag_in;
          --free_rename_carry(to_integer(unsigned(broadcast2_c_flag_rename_in)))<='1';



       elsif (broadcast4_c_flag_valid_in='1' and carry_rename_rf=broadcast4_c_flag_rename_in and carry_value_valid='0') then

          carry_value_valid<='1';
          carry_value<=broadcast4_c_flag_in;
          --free_rename_carry(to_integer(unsigned(broadcast4_c_flag_rename_in)))<='1';

       end if;


       if (broadcast1_c_flag_valid_in='1') then
         
         free_rename_carry(to_integer(unsigned(broadcast1_c_flag_rename_in)))<='1';

       end if;  

       if (broadcast2_c_flag_valid_in='1') then

         free_rename_carry(to_integer(unsigned(broadcast2_c_flag_rename_in)))<='1';

       end if;


       if (broadcast4_c_flag_valid_in='1') then

         free_rename_carry(to_integer(unsigned(broadcast4_c_flag_rename_in)))<='1';

       end if;
       




    if(halt_out_internal='0') then       


      if ((op_code1_in="0000" or op_code1_in="0001" ) and instr1_valid_in='1'

           and (op_code2_in="0000" or op_code2_in="0001") and instr2_valid_in='1') then --or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001") ) then
                                                                                                                                     --all instructions from both sets which modify carry flags

            --if (i=to_integer(unsigned(opr3_code1_in)))  then--never occur as we won't give 2 consecutive instr which modify carry flag
               
               carry_rename_rf<=first_free_rename_carry(1);
               carry_value_valid<='0';
               free_rename_carry(to_integer(unsigned(first_free_rename_carry(1))))<='0';

            --elsif (i=to_integer(unsigned(opr3_code2_in))) then
              
                carry_rename_rf<=first_free_rename_carry(1);
                carry_value_valid<='0';
                free_rename_carry(to_integer(unsigned(first_free_rename_carry(0))))<='0';

            --end if;    

       elsif ( (op_code1_in="0000" or op_code1_in="0001" ) and instr1_valid_in='1'
           and not ((op_code2_in="0000" or op_code2_in="0001") and instr2_valid_in='1')) then --first set modifies destn --next set doesn't 

           --if (i=to_integer(unsigned(opr3_code1_in)))  then
               
               carry_rename_rf<=first_free_rename_carry(0);
               carry_value_valid<='0';
               free_rename_carry(to_integer(unsigned(first_free_rename_carry(0))))<='0';

            --end if;
            

       elsif (not ((op_code1_in="0000" or op_code1_in="0001" ) and instr1_valid_in='1')
           and (op_code2_in="0000" or op_code2_in="0001" ) and instr2_valid_in='1') then --opposite of prev case

           --if (i=to_integer(unsigned(opr3_code2_in)))  then
               
               carry_rename_rf<=first_free_rename_carry(1);
               carry_value_valid<='0';
               free_rename_carry(to_integer(unsigned(first_free_rename_carry(1))))<='0';
       end if;        
           -- end if;

     end if;      
        


                    
        




         
                
       end if;


     end if;


   --end loop repetition;
    
 end process;

 --br1 carry flag update


 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,broadcast1_c_flag_rename_in,broadcast1_c_flag_in,broadcast1_c_flag_valid_in,

         broadcast2_c_flag_valid_in,broadcast2_c_flag_rename_in,broadcast2_c_flag_in,broadcast4_c_flag_in,broadcast4_c_flag_valid_in,broadcast4_c_flag_rename_in,branch1_done) ---only updates the carry flag table not anything else

  --variable i:integer range 0 to 7;
  
  begin 

    --i:=0;

  --for i in 1 to 7 repetition : loop


     
      --alu_instr_valid_out_internal<=(others=>'0');

    if (reset_system='1') then
         br1_free_rename_carry<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br1_carry_rename_rf<=(others=>'0');
         br1_carry_value<='0';
         br1_carry_value_valid<='1';  



    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0') then
       
       if (branch1_done='1') then
         br1_free_rename_carry<=free_rename_carry;--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br1_carry_rename_rf<=carry_rename_rf;
         br1_carry_value<=carry_value;
         br1_carry_value_valid<=carry_value_valid;
        


                    
        else

        if (broadcast1_c_flag_valid_in='1' and br1_carry_rename_rf=broadcast1_c_flag_rename_in and br1_carry_value_valid='0' and broadcast1_btag_in="000") then --checking broadcast signals to RRF 

          br1_carry_value_valid<='1';
          br1_carry_value<=broadcast1_c_flag_in;
          --br1_free_rename_carry(to_integer(unsigned(broadcast1_c_flag_rename_in)))<='1';


         elsif (broadcast2_c_flag_valid_in='1' and br1_carry_rename_rf=broadcast2_c_flag_rename_in and br1_carry_value_valid='0' and broadcast2_btag_in="000") then

          br1_carry_value_valid<='1';
          br1_carry_value<=broadcast2_c_flag_in;
          --br1_free_rename_carry(to_integer(unsigned(broadcast2_c_flag_rename_in)))<='1';



         elsif (broadcast4_c_flag_valid_in='1' and br1_carry_rename_rf=broadcast4_c_flag_rename_in and br1_carry_value_valid='0' and broadcast4_btag_in="000") then

          br1_carry_value_valid<='1';
          br1_carry_value<=broadcast4_c_flag_in;
          --br1_free_rename_carry(to_integer(unsigned(broadcast4_c_flag_rename_in)))<='1';




         
                
         end if;


       if (broadcast1_c_flag_valid_in='1' and broadcast1_btag_in="000") then
         
         br1_free_rename_carry(to_integer(unsigned(broadcast1_c_flag_rename_in)))<='1';

       end if;  

       if (broadcast2_c_flag_valid_in='1' and broadcast2_btag_in="000") then

         br1_free_rename_carry(to_integer(unsigned(broadcast2_c_flag_rename_in)))<='1';

       end if;


       if (broadcast4_c_flag_valid_in='1' and broadcast4_btag_in="000") then

         br1_free_rename_carry(to_integer(unsigned(broadcast4_c_flag_rename_in)))<='1';

       end if;




     end if;

     end if;


   --end loop repetition;
    
 end process;

--branch 2 carry rename update

process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,broadcast1_c_flag_rename_in,broadcast1_c_flag_in,broadcast1_c_flag_valid_in,

         broadcast2_c_flag_valid_in,broadcast2_c_flag_rename_in,broadcast2_c_flag_in,broadcast4_c_flag_in,broadcast4_c_flag_valid_in,broadcast4_c_flag_rename_in,branch2_done) ---only updates the carry flag table not anything else

  --variable i:integer range 0 to 7;
  
  begin 

    --i:=0;

  --for i in 1 to 7 repetition : loop


    if (reset_system='1') then
         br2_free_rename_carry<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br2_carry_rename_rf<=(others=>'0');
         br2_carry_value<='0';
         br2_carry_value_valid<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then
       
        if (branch2_done='1') then
         br2_free_rename_carry<=free_rename_carry;--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br2_carry_rename_rf<=carry_rename_rf;
         br2_carry_value<=carry_value;
         br2_carry_value_valid<=carry_value_valid;

      
        else

        if (broadcast1_c_flag_valid_in='1' and br2_carry_rename_rf=broadcast1_c_flag_rename_in and br2_carry_value_valid='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --checking broadcast signals to RRF 

          br2_carry_value_valid<='1';
          br2_carry_value<=broadcast1_c_flag_in;
          --br2_free_rename_carry(to_integer(unsigned(broadcast1_c_flag_rename_in)))<='1';


         elsif (broadcast2_c_flag_valid_in='1' and br2_carry_rename_rf=broadcast2_c_flag_rename_in and br2_carry_value_valid='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then

          br2_carry_value_valid<='1';
          br2_carry_value<=broadcast2_c_flag_in;
          --br2_free_rename_carry(to_integer(unsigned(broadcast2_c_flag_rename_in)))<='1';



         elsif (broadcast4_c_flag_valid_in='1' and br2_carry_rename_rf=broadcast4_c_flag_rename_in and br2_carry_value_valid='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then

          br2_carry_value_valid<='1';
          br2_carry_value<=broadcast4_c_flag_in;
          --br2_free_rename_carry(to_integer(unsigned(broadcast4_c_flag_rename_in)))<='1';

          end if;


       if (broadcast1_c_flag_valid_in='1' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then
         
         br2_free_rename_carry(to_integer(unsigned(broadcast1_c_flag_rename_in)))<='1';

       end if;  

       if (broadcast2_c_flag_valid_in='1' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then

         br2_free_rename_carry(to_integer(unsigned(broadcast2_c_flag_rename_in)))<='1';

       end if;


       if (broadcast4_c_flag_valid_in='1' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then

         br2_free_rename_carry(to_integer(unsigned(broadcast4_c_flag_rename_in)))<='1';

       end if;



     end if;
     end if;


   --end loop repetition;
    
 end process;



 
--zero flag updating process


 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,op_code2_in,first_free_rename_carry,broadcast1_z_flag_rename_in,broadcast1_z_flag_in,broadcast1_z_flag_valid_in,

         broadcast2_z_flag_valid_in,broadcast2_z_flag_rename_in,broadcast2_z_flag_in,broadcast4_z_flag_valid_in,broadcast4_z_flag_rename_in,broadcast4_z_flag_in) ----------------------------------------------------------------------only updates the carry flag table not anything else
----------------------------------------------only updates the zero flag table not anything else

  --variable i:integer range 0 to 7;
  
  begin 

   -- i:=0;

  --for i in 1 to 7 repetition : loop


     if (reset_system='1') then
         free_rename_zero<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         zero_rename_rf<=(others=>'0');
         zero_value<='0';
         zero_value_valid<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then
      if (branch_mispredict_broadcast_in="01") then
       free_rename_zero<=br1_free_rename_zero;
       zero_rename_rf<=br1_zero_rename_rf;
       zero_value<=br1_zero_value;
       zero_value_valid<=br1_zero_value_valid;

      elsif (branch_mispredict_broadcast_in="10") then
       
       free_rename_zero<=br2_free_rename_zero;
       zero_rename_rf<=br2_zero_rename_rf;
       zero_value<=br2_zero_value;
       zero_value_valid<=br2_zero_value_valid;

       else 

        if (broadcast1_z_flag_valid_in='1' and zero_rename_rf=broadcast1_z_flag_rename_in and zero_value_valid='0') then --checking broadcast signals to RRF 

          zero_value_valid<='1';
          zero_value<=broadcast1_z_flag_in;
          --free_rename_zero(to_integer(unsigned(broadcast1_z_flag_rename_in)))<='1';


         elsif (broadcast2_z_flag_valid_in='1' and zero_rename_rf=broadcast2_z_flag_rename_in and zero_value_valid='0') then

          zero_value_valid<='1';
          zero_value<=broadcast2_z_flag_in;
          --free_rename_zero(to_integer(unsigned(broadcast2_z_flag_rename_in)))<='1';


          elsif (broadcast4_z_flag_valid_in='1' and zero_rename_rf=broadcast4_z_flag_rename_in and zero_value_valid='0') then

          zero_value_valid<='1';
          zero_value<=broadcast4_z_flag_in;
          --free_rename_zero(to_integer(unsigned(broadcast4_z_flag_rename_in)))<='1';
          end if; 


       if (broadcast1_z_flag_valid_in='1') then
         
         free_rename_zero(to_integer(unsigned(broadcast1_z_flag_rename_in)))<='1';

       end if;  

       if (broadcast2_c_flag_valid_in='1') then

         free_rename_zero(to_integer(unsigned(broadcast2_z_flag_rename_in)))<='1';

       end if;


       if (broadcast4_c_flag_valid_in='1') then

         free_rename_zero(to_integer(unsigned(broadcast4_z_flag_rename_in)))<='1';

       end if;

      end if; 



 
    if (halt_out_internal='0') then
       
      if ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010") and instr1_valid_in='1'--LW removed from set as it won't modify zero flag

           and (op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010") and instr2_valid_in='1') then --or op_code2_in="0010" or op_code2_in="0011" or op_code2_in="0100" or op_code2_in="1000" or op_code2_in="1001") ) then
                                                                                                                                     --all instructions from both sets which modify zero flags

            --if (i=to_integer(unsigned(opr3_code1_in)))  then -----------------This case won't occur as there won't be 2 consecutive instr modifying zero flag
               
               zero_rename_rf<=first_free_rename_zero(1);
               zero_value_valid<='0';
               free_rename_zero(to_integer(unsigned(first_free_rename_zero(0))))<='0';


            --elsif (i=to_integer(unsigned(opr3_code2_in))) then
              
                zero_rename_rf<=first_free_rename_zero(1);
                zero_value_valid<='0';
                free_rename_zero(to_integer(unsigned(first_free_rename_zero(1))))<='0';


            --end if;    

       elsif ( (op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010") and instr1_valid_in='1'
           and not ((op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010") and instr2_valid_in='1')) then --first set modifies destn --next set doesn't 

           --if (i=to_integer(unsigned(opr3_code1_in)))  then
               
               zero_rename_rf<=first_free_rename_zero(0);
               zero_value_valid<='0';
               free_rename_zero(to_integer(unsigned(first_free_rename_zero(0))))<='0';



            --end if;
            

       elsif (not ((op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010") and instr1_valid_in='1')
           and (op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010") and instr2_valid_in='1') then --opposite of prev case

           --if (i=to_integer(unsigned(opr3_code2_in)))  then
               
               zero_rename_rf<=first_free_rename_zero(1);
               zero_value_valid<='0';
               free_rename_zero(to_integer(unsigned(first_free_rename_zero(1))))<='0';

        end if;       

            --end if;

      end if;      
        


                    
        



         
                
   end if;


     


   --end loop repetition;
    
 end process;


 --br1 zero reg copy update
 
 process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,op_code2_in,broadcast1_z_flag_rename_in,broadcast1_z_flag_in,broadcast1_z_flag_valid_in,

         broadcast2_z_flag_valid_in,broadcast2_z_flag_rename_in,broadcast2_z_flag_in,broadcast4_z_flag_valid_in,broadcast4_z_flag_rename_in,broadcast4_z_flag_in) ----------------------------------------------------------------------only updates the carry flag table not anything else
----------------------------------------------only updates the zero flag table not anything else

  --variable i:integer range 0 to 7;
  
  begin 

    --i:=0;

  --for i in 1 to 7 repetition : loop


     if (reset_system='1') then
         br1_free_rename_zero<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br1_zero_rename_rf<=(others=>'0');
         br1_zero_value<='0';
         br1_zero_value_valid<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0'  ) then
       
       if (branch1_done='1') then
         br1_free_rename_zero<=free_rename_zero;--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br1_zero_rename_rf<=zero_rename_rf;
         br1_zero_value<=zero_value;
         br1_zero_value_valid<='1';
        
        else

        if (broadcast1_z_flag_valid_in='1' and zero_rename_rf=broadcast1_z_flag_rename_in and zero_value_valid='0' and broadcast1_btag_in="000") then --checking broadcast signals to RRF 

          br1_zero_value_valid<='1';
          br1_zero_value<=broadcast1_z_flag_in;
          --br1_free_rename_zero(to_integer(unsigned(broadcast1_z_flag_rename_in)))<='1';


        elsif (broadcast2_z_flag_valid_in='1' and zero_rename_rf=broadcast2_z_flag_rename_in and zero_value_valid='0' and broadcast2_btag_in="000") then

          br1_zero_value_valid<='1';
          br1_zero_value<=broadcast2_z_flag_in;
          --br1_free_rename_zero(to_integer(unsigned(broadcast2_z_flag_rename_in)))<='1';


        elsif (broadcast4_z_flag_valid_in='1' and zero_rename_rf=broadcast4_z_flag_rename_in and zero_value_valid='0' and broadcast4_btag_in="000") then

          br1_zero_value_valid<='1';
          br1_zero_value<=broadcast4_z_flag_in;
          --br1_free_rename_zero(to_integer(unsigned(broadcast4_z_flag_rename_in)))<='1';

        end if;


       

       if (broadcast1_c_flag_valid_in='1' and broadcast1_btag_in="000") then
         
         br1_free_rename_zero(to_integer(unsigned(broadcast1_z_flag_rename_in)))<='1';

       end if;  
       if (broadcast2_c_flag_valid_in='1' and broadcast2_btag_in="000") then

         br1_free_rename_zero(to_integer(unsigned(broadcast2_z_flag_rename_in)))<='1';

       end if;


       if (broadcast4_c_flag_valid_in='1' and broadcast4_btag_in="000") then

         br1_free_rename_zero(to_integer(unsigned(broadcast4_z_flag_rename_in)))<='1';

       end if;

       end if;


       



     end if;


   --end loop repetition;
    
 end process;

--br2 zero flag copy update

process(reset_system,clk_input,stall_reservation_update,halt_out_internal,op_code1_in,opr3_code1_in,opr3_code2_in,op_code2_in,broadcast1_z_flag_rename_in,broadcast1_z_flag_in,broadcast1_z_flag_valid_in,

         broadcast2_z_flag_valid_in,broadcast2_z_flag_rename_in,broadcast2_z_flag_in,broadcast4_z_flag_valid_in,broadcast4_z_flag_rename_in,broadcast4_z_flag_in) ----------------------------------------------------------------------only updates the carry flag table not anything else
----------------------------------------------only updates the zero flag table not anything else

  --variable i:integer range 0 to 7;
  
  begin 

    --i:=0;

  --for i in 1 to 7 repetition : loop


     if (reset_system='1') then
         br2_free_rename_zero<=(others=>'1');--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br2_zero_rename_rf<=(others=>'0');
         br2_zero_value<='0';
         br2_zero_value_valid<='1';
      --alu_instr_valid_out_internal<=(others=>'0');


    elsif (clk_input'event and clk_input='1' and stall_reservation_update='0') then
       
       if (branch2_done='1') then
         br2_free_rename_zero<=free_rename_zero;--at start all RRF's are free
         --arf_rename_valid(i)<=(others=>'0');
         br2_zero_rename_rf<=zero_rename_rf;
         br2_zero_value<=zero_value;
         br2_zero_value_valid<='1';
        
        else

        if (broadcast1_z_flag_valid_in='1' and zero_rename_rf=broadcast1_z_flag_rename_in and zero_value_valid='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --checking broadcast signals to RRF 

          br2_zero_value_valid<='1';
          br2_zero_value<=broadcast1_z_flag_in;
          --br2_free_rename_zero(to_integer(unsigned(broadcast1_z_flag_rename_in)))<='1';


        elsif (broadcast2_z_flag_valid_in='1' and zero_rename_rf=broadcast2_z_flag_rename_in and zero_value_valid='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then

          br2_zero_value_valid<='1';
          br2_zero_value<=broadcast2_z_flag_in;
          --br2_free_rename_zero(to_integer(unsigned(broadcast2_z_flag_rename_in)))<='1';


        elsif (broadcast4_z_flag_valid_in='1' and zero_rename_rf=broadcast4_z_flag_rename_in and zero_value_valid='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then

          br2_zero_value_valid<='1';
          br2_zero_value<=broadcast4_z_flag_in;
          --br2_free_rename_zero(to_integer(unsigned(broadcast4_z_flag_rename_in)))<='1';

        end if;


     


     if (broadcast1_z_flag_valid_in='1' and (broadcast1_btag_in="000"or broadcast1_btag_in="001")) then
         
         br2_free_rename_zero(to_integer(unsigned(broadcast1_z_flag_rename_in)))<='1';

       end if;  

       if (broadcast2_c_flag_valid_in='1' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then

         br2_free_rename_zero(to_integer(unsigned(broadcast2_z_flag_rename_in)))<='1';

       end if;


       if (broadcast4_c_flag_valid_in='1' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then

         br2_free_rename_zero(to_integer(unsigned(broadcast4_z_flag_rename_in)))<='1';

       end if;

     end if;

     end if;  


   --end loop repetition;
    
 end process;






process(reset_system,clk_input,stall_reservation_update,halt_out_internal)--updateds AL entries in reservation station
                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    alu_instr_valid_out_internal(i)<='0';
    alu_op_code_out_internal(i)<=(others=>'0');
    alu_op_code_cz_out_internal(i)<=(others=>'0');
    alu_operand1_out_internal(i)<=(others=>'0');
    alu_valid1_out_internal(i)<='0';
    
    alu_operand2_out_internal(i)<=(others=>'0');
    alu_valid2_out_internal(i)<='0';

    alu_operand3_out_internal(i)<=(others=>'0');
    alu_valid3_out_internal(i)<='0';


     alu_c_flag_out_internal(i)<='0';
     alu_c_flag_rename_out_internal(i)<=(others=>'0');
     alu_c_flag_valid_out_internal(i)<='0';
     alu_c_flag_destn_addr_out_internal(i)<=(others=>'0');

     alu_z_flag_out_internal(i)<='0';
     alu_z_flag_rename_out_internal(i)<=(others=>'0');
     alu_z_flag_valid_out_internal(i)<='0';
     alu_z_flag_destn_addr_out_internal(i)<= (others=>'0');


     alu_destn_rename_code_out_internal(i)<=(others=>'0');
     alu_orign_destn_out_internal(i)<=(others=>'0');

     alu_btag_out_internal(i)<=(others=>'0');
     alu_curr_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults

   if (branch_mispredict_broadcast_in="01") then
    alu_instr_valid_out_internal(i)<=br1_alu_instr_valid_out_internal(i);
    alu_op_code_out_internal(i)<=br1_alu_op_code_out_internal(i);
    alu_op_code_cz_out_internal(i)<=br1_alu_op_code_cz_out_internal(i);
    alu_operand1_out_internal(i)<=br1_alu_operand1_out_internal(i);
    alu_valid1_out_internal(i)<=br1_alu_valid1_out_internal(i);
    
    alu_operand2_out_internal(i)<=br1_alu_operand2_out_internal(i);
    alu_valid2_out_internal(i)<=br1_alu_valid2_out_internal(i);

    alu_operand3_out_internal(i)<=br1_alu_operand3_out_internal(i);
    alu_valid3_out_internal(i)<=br1_alu_valid3_out_internal(i);


     alu_c_flag_out_internal(i)<=br1_alu_c_flag_out_internal(i);
     alu_c_flag_rename_out_internal(i)<= br1_alu_c_flag_rename_out_internal(i);
     alu_c_flag_valid_out_internal(i)<=br1_alu_c_flag_valid_out_internal(i);
     alu_c_flag_destn_addr_out_internal(i)<=br1_alu_c_flag_destn_addr_out_internal(i);

     alu_z_flag_out_internal(i)<=br1_alu_z_flag_out_internal(i);
     alu_z_flag_rename_out_internal(i)<=br1_alu_z_flag_rename_out_internal(i);
     alu_z_flag_valid_out_internal(i)<=br1_alu_z_flag_valid_out_internal(i);
     alu_z_flag_destn_addr_out_internal(i)<=br1_alu_z_flag_destn_addr_out_internal(i);

     alu_destn_rename_code_out_internal(i)<=br1_alu_destn_rename_code_out_internal(i);
     alu_orign_destn_out_internal(i)<=br1_alu_orign_destn_out_internal(i);

     alu_btag_out_internal(i)<=br1_alu_btag_out_internal(i);
     alu_curr_pc_out_internal(i)<=br1_alu_curr_pc_out_internal(i);

   elsif (branch_mispredict_broadcast_in="10") then
    alu_instr_valid_out_internal(i)<=br2_alu_instr_valid_out_internal(i);
    alu_op_code_out_internal(i)<=br2_alu_op_code_out_internal(i);
    alu_op_code_cz_out_internal(i)<=br2_alu_op_code_cz_out_internal(i);
    alu_operand1_out_internal(i)<=br2_alu_operand1_out_internal(i);
    alu_valid1_out_internal(i)<=br2_alu_valid1_out_internal(i);
    
    alu_operand2_out_internal(i)<=br2_alu_operand2_out_internal(i);
    alu_valid2_out_internal(i)<=br2_alu_valid2_out_internal(i);

    alu_operand3_out_internal(i)<=br2_alu_operand3_out_internal(i);
    alu_valid3_out_internal(i)<=br2_alu_valid3_out_internal(i);


     alu_c_flag_out_internal(i)<=br2_alu_c_flag_out_internal(i);
     alu_c_flag_rename_out_internal(i)<= br2_alu_c_flag_rename_out_internal(i);
     alu_c_flag_valid_out_internal(i)<=br2_alu_c_flag_valid_out_internal(i);
     alu_c_flag_destn_addr_out_internal(i)<=br2_alu_c_flag_destn_addr_out_internal(i);

     alu_z_flag_out_internal(i)<=br2_alu_z_flag_out_internal(i);
     alu_z_flag_rename_out_internal(i)<=br2_alu_z_flag_rename_out_internal(i);
     alu_z_flag_valid_out_internal(i)<=br2_alu_z_flag_valid_out_internal(i);
     alu_z_flag_destn_addr_out_internal(i)<=br2_alu_z_flag_destn_addr_out_internal(i);


     alu_destn_rename_code_out_internal(i)<=br2_alu_destn_rename_code_out_internal(i);
     alu_orign_destn_out_internal(i)<=br2_alu_orign_destn_out_internal(i);

     alu_btag_out_internal(i)<=br2_alu_btag_out_internal(i);
     alu_curr_pc_out_internal(i)<=br2_alu_curr_pc_out_internal(i); 




   elsif (alu_instr_valid_out_internal(i)='1' and alu_scheduler_valid_out_internal(i)='1') then

    if(i=to_integer(unsigned(alu_done_number1)) and alu_valid_done1_in='1' ) then

     alu_instr_valid_out_internal(i)<='0';

    elsif (i=to_integer(unsigned(alu_done_number2)) and alu_valid_done2_in='1') then
  
      alu_instr_valid_out_internal(i)<='0';

    end if;


   elsif (alu_instr_valid_out_internal(i)='1' and alu_scheduler_valid_out_internal(i)='0') then

    if (alu_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and alu_valid1_out_internal(i)='0') then --refers to the case when operand 1 has no data

        alu_operand1_out_internal(i)<=broadcast1_data_in;
        alu_valid1_out_internal(i)<='1';

    elsif(alu_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and alu_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        alu_operand1_out_internal(i)<=broadcast2_data_in;
        alu_valid1_out_internal(i)<='1';
    
    elsif(alu_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and alu_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        alu_operand1_out_internal(i)<=broadcast3_data_in;
        alu_valid1_out_internal(i)<='1';
    
    elsif(alu_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and alu_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        alu_operand1_out_internal(i)<=broadcast4_data_in;
        alu_valid1_out_internal(i)<='1';

    elsif(alu_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and alu_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        alu_operand1_out_internal(i)<=broadcast5_data_in;
        alu_valid1_out_internal(i)<='1';    

    end if;

    if (alu_operand2_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and alu_valid2_out_internal(i)='0') then --refers to the case when operand 2 has no data

        alu_operand2_out_internal(i)<=broadcast1_data_in;
        alu_valid2_out_internal(i)<='1';

    elsif(alu_operand2_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and alu_valid2_out_internal(i)='0') then --refers to case when operand 2 has no data
        
        alu_operand2_out_internal(i)<=broadcast2_data_in;
        alu_valid2_out_internal(i)<='1';
    
    elsif(alu_operand2_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and alu_valid2_out_internal(i)='0') then --refers to case when operand 2 has no data
        
        alu_operand2_out_internal(i)<=broadcast3_data_in;
        alu_valid2_out_internal(i)<='1';

    elsif(alu_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and alu_valid2_out_internal(i)='0') then --refers to case when operand 2 has no data
        
        alu_operand2_out_internal(i)<=broadcast4_data_in;
        alu_valid2_out_internal(i)<='1';
    
    elsif(alu_operand2_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and alu_valid2_out_internal(i)='0') then --refers to case when operand 2 has no data
        
        alu_operand2_out_internal(i)<=broadcast5_data_in;
        alu_valid2_out_internal(i)<='1';        
    

    end if;



    if (alu_operand3_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and alu_valid3_out_internal(i)='0') then --refers to the case when operand 3 has no data

        alu_operand3_out_internal(i)<=broadcast1_data_in;
        alu_valid3_out_internal(i)<='1';

    elsif(alu_operand3_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and alu_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_operand3_out_internal(i)<=broadcast2_data_in;
        alu_valid3_out_internal(i)<='1';
    
    elsif(alu_operand3_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and alu_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_operand3_out_internal(i)<=broadcast3_data_in;
        alu_valid3_out_internal(i)<='1';

    elsif(alu_operand3_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and alu_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_operand3_out_internal(i)<=broadcast4_data_in;
        alu_valid3_out_internal(i)<='1';

    elsif(alu_operand3_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and alu_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_operand3_out_internal(i)<=broadcast5_data_in;
        alu_valid3_out_internal(i)<='1';    
    

    end if;

    ---------refers to c flag validity

   if (alu_c_flag_rename_out_internal(i)=broadcast1_c_flag_rename_in and broadcast1_c_flag_valid_in='1' and alu_c_flag_valid_out_internal(i)='0') then --refers to the case when operand 3 has no data

        alu_c_flag_out_internal(i)<=broadcast1_c_flag_in;
        alu_c_flag_valid_out_internal(i)<='1';

    elsif(alu_c_flag_rename_out_internal(i)=broadcast2_c_flag_rename_in and broadcast2_c_flag_valid_in='1' and alu_c_flag_valid_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_c_flag_out_internal(i)<=broadcast2_c_flag_in;
        alu_c_flag_valid_out_internal(i)<='1';
    
    elsif(alu_c_flag_rename_out_internal(i)=broadcast4_c_flag_rename_in and broadcast4_c_flag_valid_in='1' and alu_c_flag_valid_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_c_flag_out_internal(i)<=broadcast4_c_flag_in;
        alu_c_flag_valid_out_internal(i)<='1';

    
    end if; 

    --refers to revalidation of z flag


    if (alu_z_flag_rename_out_internal(i)=broadcast1_z_flag_rename_in and broadcast1_z_flag_valid_in='1' and alu_z_flag_valid_out_internal(i)='0') then --refers to the case when operand 3 has no data

        alu_z_flag_out_internal(i)<=broadcast1_z_flag_in;
        alu_z_flag_valid_out_internal(i)<='1';

    elsif(alu_z_flag_rename_out_internal(i)=broadcast2_z_flag_rename_in and broadcast2_z_flag_valid_in='1' and alu_z_flag_valid_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_z_flag_out_internal(i)<=broadcast2_z_flag_in;
        alu_z_flag_valid_out_internal(i)<='1';
    
    elsif(alu_z_flag_rename_out_internal(i)=broadcast4_z_flag_rename_in and broadcast4_z_flag_valid_in='1' and alu_z_flag_valid_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        alu_z_flag_out_internal(i)<=broadcast4_z_flag_in;
        alu_z_flag_valid_out_internal(i)<='1';

    
    end if;


    


   elsif (alu_instr_valid_out_internal(i)='0') then

    
    if (halt_out_internal='0') then

     if (op_code1_in="0000" or op_code1_in="0001" or op_code1_in="0010")  then --instructions write on AL

       if (i=alu_vacant_entry(0)) then
         alu_instr_valid_out_internal(i)<=instr1_valid_in; --changed from 1 as instruction may not be valid
         alu_op_code_out_internal(i)<=op_code1_in;
         alu_op_code_cz_out_internal(i)<=op_cz1_in;
         alu_destn_rename_code_out_internal(i)<=first_free_rename(0);

         alu_operand1_out_internal(i)<=operand1_out_internal_instr1;
         alu_valid1_out_internal(i)<=operand1_out_internal_data_valid_instr1;

        
        if (op_code1_in="0001") then---refers to ADI instruction
         alu_operand2_out_internal(i)<=imm1_in;
         alu_valid2_out_internal(i)<='1';

        else
          alu_operand2_out_internal(i)<=operand2_out_internal_instr1;
          alu_valid2_out_internal(i)<=operand2_out_internal_data_valid_instr1;
        end if;  
          
         alu_operand3_out_internal(i)<=operand3_out_internal_instr1;
         alu_valid3_out_internal(i)<=operand3_out_internal_data_valid_instr1;


         alu_c_flag_out_internal(i)<=operand_carry_value_internal_instr1;
         alu_c_flag_rename_out_internal(i)<=operand_carry_rename_internal_instr1;
         alu_c_flag_valid_out_internal(i)<=operand_carry_bit_valid_instr1;
         alu_c_flag_destn_addr_out_internal(i)<=first_free_rename_carry(0);
         
         alu_z_flag_out_internal(i)<=operand_zero_value_internal_instr1;
         alu_z_flag_rename_out_internal(i)<=operand_zero_rename_internal_instr1;
         alu_z_flag_valid_out_internal(i)<=operand_zero_bit_valid_instr1;
         alu_z_flag_destn_addr_out_internal(i)<=first_free_rename_zero(0);

         alu_btag_out_internal(i)<=btag1_in;

         alu_orign_destn_out_internal(i)<=opr3_code1_in;

         alu_curr_pc_out_internal(i)<=curr_pc1_in;

        end if;
      end if;   


      if (op_code2_in="0000" or op_code2_in="0001" or op_code2_in="0010") then   


        if (i=alu_vacant_entry(1)) then
          
         alu_instr_valid_out_internal(i)<=instr2_valid_in;--changed from 1 for same reason
         alu_op_code_out_internal(i)<=op_code2_in;
         alu_op_code_cz_out_internal(i)<=op_cz2_in;
         alu_destn_rename_code_out_internal(i)<=first_free_rename(1);
         alu_operand1_out_internal(i)<=operand1_out_internal_instr2;
         alu_valid1_out_internal(i)<=operand1_out_internal_data_valid_instr2;


        
        if (op_code2_in="0001") then---refers to ADI instruction
         alu_operand2_out_internal(i)<=imm2_in;
         alu_valid2_out_internal(i)<='1';

        else
          alu_operand2_out_internal(i)<=operand2_out_internal_instr2;
          alu_valid2_out_internal(i)<=operand2_out_internal_data_valid_instr2;
        end if;

         alu_operand3_out_internal(i)<=operand3_out_internal_instr2;
         alu_valid3_out_internal(i)<=operand3_out_internal_data_valid_instr2;


         alu_c_flag_out_internal(i)<=operand_carry_value_internal_instr2;
         alu_c_flag_rename_out_internal(i)<=operand_carry_rename_internal_instr2;
         alu_c_flag_valid_out_internal(i)<=operand_carry_bit_valid_instr2;
         alu_c_flag_destn_addr_out_internal(i)<=first_free_rename_carry(1);
         
         alu_z_flag_out_internal(i)<=operand_zero_value_internal_instr2;
         alu_z_flag_rename_out_internal(i)<=operand_zero_rename_internal_instr2;
         alu_z_flag_valid_out_internal(i)<=operand_zero_bit_valid_instr2;
         alu_z_flag_destn_addr_out_internal(i)<=first_free_rename_zero(1);

         alu_btag_out_internal(i)<=btag2_in;

         alu_orign_destn_out_internal(i)<=opr3_code2_in;

         alu_curr_pc_out_internal(i)<=curr_pc2_in;

        end if; 


       end if; 


      

       end if;


    end if;


  end if;   




end loop;  

     



end process;


--branch 1 copy of RS 
 
process(reset_system,clk_input,stall_reservation_update,halt_out_internal,branch1_done)--updateds AL entries in reservation station
                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    br1_alu_instr_valid_out_internal(i)<='0';
    br1_alu_op_code_out_internal(i)<=(others=>'0');
    br1_alu_op_code_cz_out_internal(i)<=(others=>'0');
    br1_alu_operand1_out_internal(i)<=(others=>'0');
    br1_alu_valid1_out_internal(i)<='0';
    
    br1_alu_operand2_out_internal(i)<=(others=>'0');
    br1_alu_valid2_out_internal(i)<='0';

    br1_alu_operand3_out_internal(i)<=(others=>'0');
    br1_alu_valid3_out_internal(i)<='0';


    br1_alu_c_flag_out_internal(i)<='0';
    br1_alu_c_flag_rename_out_internal(i)<=(others=>'0');
    br1_alu_c_flag_valid_out_internal(i)<='0';
    br1_alu_c_flag_destn_addr_out_internal(i)<=(others => '0');

    br1_alu_z_flag_out_internal(i)<='0';
    br1_alu_z_flag_rename_out_internal(i)<=(others=>'0');
    br1_alu_z_flag_valid_out_internal(i)<='0';
    br1_alu_z_flag_destn_addr_out_internal(i)<=(others => '0');


    br1_alu_destn_rename_code_out_internal(i)<=(others=>'0');
    br1_alu_orign_destn_out_internal(i)<=(others=>'0');

    br1_alu_btag_out_internal(i)<=(others=>'0');
    br1_alu_curr_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then 

   if (branch1_done='1') then

    br1_alu_instr_valid_out_internal(i)<=alu_instr_valid_out_internal(i);
    br1_alu_op_code_out_internal(i)<=alu_op_code_out_internal(i);
    br1_alu_op_code_cz_out_internal(i)<=alu_op_code_cz_out_internal(i);
    br1_alu_operand1_out_internal(i)<=alu_operand1_out_internal(i);
    br1_alu_valid1_out_internal(i)<=alu_valid1_out_internal(i);
    
    br1_alu_operand2_out_internal(i)<=alu_operand2_out_internal(i);
    br1_alu_valid2_out_internal(i)<=alu_valid2_out_internal(i);

    br1_alu_operand3_out_internal(i)<=alu_operand3_out_internal(i);
    br1_alu_valid3_out_internal(i)<=alu_valid3_out_internal(i);


    br1_alu_c_flag_out_internal(i)<=alu_c_flag_out_internal(i);
    br1_alu_c_flag_rename_out_internal(i)<=alu_c_flag_rename_out_internal(i);
    br1_alu_c_flag_valid_out_internal(i)<=alu_c_flag_valid_out_internal(i);
    br1_alu_c_flag_destn_addr_out_internal(i)<=alu_c_flag_destn_addr_out_internal(i);

    br1_alu_z_flag_out_internal(i)<=alu_z_flag_out_internal(i);
    br1_alu_z_flag_rename_out_internal(i)<=alu_z_flag_rename_out_internal(i);
    br1_alu_z_flag_valid_out_internal(i)<=alu_z_flag_valid_out_internal(i);
    br1_alu_z_flag_destn_addr_out_internal(i)<=alu_z_flag_destn_addr_out_internal(i);



    br1_alu_destn_rename_code_out_internal(i)<=alu_destn_rename_code_out_internal(i);
    br1_alu_orign_destn_out_internal(i)<=alu_orign_destn_out_internal(i);

    br1_alu_btag_out_internal(i)<=alu_btag_out_internal(i);
    br1_alu_curr_pc_out_internal(i)<=alu_curr_pc_out_internal(i);



   elsif (br1_alu_instr_valid_out_internal(i)='1') then --scheduler removes since it has to be zero if valid 1 is zero

    if (br1_alu_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_alu_valid1_out_internal(i)='0' and broadcast1_btag_in="000") then --refers to the case when operand 1 has no data

        br1_alu_operand1_out_internal(i)<=broadcast1_data_in;
        br1_alu_valid1_out_internal(i)<='1';

    elsif(br1_alu_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_alu_valid1_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_alu_operand1_out_internal(i)<=broadcast2_data_in;
        br1_alu_valid1_out_internal(i)<='1';
    
    elsif(br1_alu_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_alu_valid1_out_internal(i)='0' and broadcast3_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_alu_operand1_out_internal(i)<=broadcast3_data_in;
        br1_alu_valid1_out_internal(i)<='1';
    
    elsif(br1_alu_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_alu_valid1_out_internal(i)='0' and broadcast4_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_alu_operand1_out_internal(i)<=broadcast4_data_in;
        br1_alu_valid1_out_internal(i)<='1';

    elsif(br1_alu_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br1_alu_valid1_out_internal(i)='0' and broadcast5_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_alu_operand1_out_internal(i)<=broadcast5_data_in;
        br1_alu_valid1_out_internal(i)<='1';    

    end if;

    if (br1_alu_operand2_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_alu_valid2_out_internal(i)='0' and  broadcast1_btag_in="000") then --refers to the case when operand 2 has no data

        br1_alu_operand2_out_internal(i)<=broadcast1_data_in;
        br1_alu_valid2_out_internal(i)<='1';

    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_alu_valid2_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 2 has no data
        
        br1_alu_operand2_out_internal(i)<=broadcast2_data_in;
        br1_alu_valid2_out_internal(i)<='1';
    
    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_alu_valid2_out_internal(i)='0' and broadcast3_btag_in="000") then --refers to case when operand 2 has no data
        
        br1_alu_operand2_out_internal(i)<=broadcast3_data_in;
        br1_alu_valid2_out_internal(i)<='1';

    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_alu_valid2_out_internal(i)='0' and broadcast4_btag_in="000") then --refers to case when operand 2 has no data
        
        br1_alu_operand2_out_internal(i)<=broadcast4_data_in;
        br1_alu_valid2_out_internal(i)<='1';

    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br1_alu_valid1_out_internal(i)='0' and broadcast5_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_alu_operand1_out_internal(i)<=broadcast5_data_in;
        br1_alu_valid1_out_internal(i)<='1';    
    

    end if;



    if (br1_alu_operand3_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_alu_valid3_out_internal(i)='0' and  broadcast1_btag_in="000") then --refers to the case when operand 3 has no data

        br1_alu_operand3_out_internal(i)<=broadcast1_data_in;
        br1_alu_valid3_out_internal(i)<='1';

    elsif(br1_alu_operand3_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_alu_valid3_out_internal(i)='0' and  broadcast2_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_operand3_out_internal(i)<=broadcast2_data_in;
        br1_alu_valid3_out_internal(i)<='1';
    
    elsif(br1_alu_operand3_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_alu_valid3_out_internal(i)='0' and  broadcast3_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_operand3_out_internal(i)<=broadcast3_data_in;
        br1_alu_valid3_out_internal(i)<='1';

    elsif(br1_alu_operand3_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_alu_valid3_out_internal(i)='0' and  broadcast4_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_operand3_out_internal(i)<=broadcast4_data_in;
        br1_alu_valid3_out_internal(i)<='1';

    elsif(br1_alu_operand3_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br1_alu_valid3_out_internal(i)='0' and  broadcast5_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_operand3_out_internal(i)<=broadcast5_data_in;
        br1_alu_valid3_out_internal(i)<='1';    
    

    end if;

    ---------refers to c flag validity

   if (br1_alu_c_flag_rename_out_internal(i)=broadcast1_c_flag_rename_in and broadcast1_c_flag_valid_in='1' and br1_alu_c_flag_valid_out_internal(i)='0' and  broadcast1_btag_in="000") then --refers to the case when operand 3 has no data

        br1_alu_c_flag_out_internal(i)<=broadcast1_c_flag_in;
        br1_alu_c_flag_valid_out_internal(i)<='1';

    elsif(br1_alu_c_flag_rename_out_internal(i)=broadcast2_c_flag_rename_in and broadcast2_c_flag_valid_in='1' and br1_alu_c_flag_valid_out_internal(i)='0' and  broadcast2_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_c_flag_out_internal(i)<=broadcast2_c_flag_in;
        br1_alu_c_flag_valid_out_internal(i)<='1';
    
    elsif(br1_alu_c_flag_rename_out_internal(i)=broadcast4_c_flag_rename_in and broadcast4_c_flag_valid_in='1' and br1_alu_c_flag_valid_out_internal(i)='0' and  broadcast4_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_c_flag_out_internal(i)<=broadcast4_c_flag_in;
        br1_alu_c_flag_valid_out_internal(i)<='1';

    
    end if; 

    --refers to revalidation of z flag


    if (br1_alu_z_flag_rename_out_internal(i)=broadcast1_z_flag_rename_in and broadcast1_z_flag_valid_in='1' and br1_alu_z_flag_valid_out_internal(i)='0' and broadcast1_btag_in="000") then --refers to the case when operand 3 has no data

        br1_alu_z_flag_out_internal(i)<=broadcast1_z_flag_in;
        br1_alu_z_flag_valid_out_internal(i)<='1';

    elsif(br1_alu_z_flag_rename_out_internal(i)=broadcast2_z_flag_rename_in and broadcast2_z_flag_valid_in='1' and br1_alu_z_flag_valid_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_z_flag_out_internal(i)<=broadcast2_z_flag_in;
        br1_alu_z_flag_valid_out_internal(i)<='1';
    
    elsif(br1_alu_z_flag_rename_out_internal(i)=broadcast4_z_flag_rename_in and broadcast4_z_flag_valid_in='1' and br1_alu_z_flag_valid_out_internal(i)='0' and broadcast4_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_alu_z_flag_out_internal(i)<=broadcast4_z_flag_in;
        br1_alu_z_flag_valid_out_internal(i)<='1';

    
    end if;


    


   

    end if;


  end if;   




end loop;  

     



end process; 


--br2 copy of al entry

process(reset_system,clk_input,stall_reservation_update,halt_out_internal,branch2_done)--updateds AL entries in reservation station
                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    br2_alu_instr_valid_out_internal(i)<='0';
    br2_alu_op_code_out_internal(i)<=(others=>'0');
    br2_alu_op_code_cz_out_internal(i)<=(others=>'0');
    br2_alu_operand1_out_internal(i)<=(others=>'0');
    br2_alu_valid1_out_internal(i)<='0';
    
    br2_alu_operand2_out_internal(i)<=(others=>'0');
    br2_alu_valid2_out_internal(i)<='0';

    br2_alu_operand3_out_internal(i)<=(others=>'0');
    br2_alu_valid3_out_internal(i)<='0';


    br2_alu_c_flag_out_internal(i)<='0';
    br2_alu_c_flag_rename_out_internal(i)<=(others=>'0');
    br2_alu_c_flag_valid_out_internal(i)<='0';
    br2_alu_c_flag_destn_addr_out_internal(i)<=(others =>'0');

    br2_alu_z_flag_out_internal(i)<='0';
    br2_alu_z_flag_rename_out_internal(i)<=(others=>'0');
    br2_alu_z_flag_valid_out_internal(i)<='0';
    br2_alu_z_flag_destn_addr_out_internal(i)<=(others =>'0');


    br2_alu_destn_rename_code_out_internal(i)<=(others=>'0');
    br2_alu_orign_destn_out_internal(i)<=(others=>'0');

    br2_alu_btag_out_internal(i)<=(others=>'0');
    br2_alu_curr_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then

   if (branch2_done='1') then

    br2_alu_instr_valid_out_internal(i)<=alu_instr_valid_out_internal(i);
    br2_alu_op_code_out_internal(i)<=alu_op_code_out_internal(i);
    br2_alu_op_code_cz_out_internal(i)<=alu_op_code_cz_out_internal(i);
    br2_alu_operand1_out_internal(i)<=alu_operand1_out_internal(i);
    br2_alu_valid1_out_internal(i)<=alu_valid1_out_internal(i);
    
    br2_alu_operand2_out_internal(i)<=alu_operand2_out_internal(i);
    br2_alu_valid2_out_internal(i)<=alu_valid2_out_internal(i);

    br2_alu_operand3_out_internal(i)<=alu_operand3_out_internal(i);
    br2_alu_valid3_out_internal(i)<=alu_valid3_out_internal(i);


    br2_alu_c_flag_out_internal(i)<=alu_c_flag_out_internal(i);
    br2_alu_c_flag_rename_out_internal(i)<=alu_c_flag_rename_out_internal(i);
    br2_alu_c_flag_valid_out_internal(i)<=alu_c_flag_valid_out_internal(i);
    br2_alu_c_flag_destn_addr_out_internal(i)<=alu_c_flag_destn_addr_out_internal(i);

    br2_alu_z_flag_out_internal(i)<=alu_z_flag_out_internal(i);
    br2_alu_z_flag_rename_out_internal(i)<=alu_z_flag_rename_out_internal(i);
    br2_alu_z_flag_valid_out_internal(i)<=alu_z_flag_valid_out_internal(i);
    br2_alu_z_flag_destn_addr_out_internal(i)<=alu_z_flag_destn_addr_out_internal(i);


    br2_alu_destn_rename_code_out_internal(i)<=alu_destn_rename_code_out_internal(i);
    br2_alu_orign_destn_out_internal(i)<=alu_orign_destn_out_internal(i);

    br2_alu_btag_out_internal(i)<=alu_btag_out_internal(i);
    br2_alu_curr_pc_out_internal(i)<=alu_curr_pc_out_internal(i);



   elsif (br2_alu_instr_valid_out_internal(i)='1') then --scheduler removes since it has to be zero if valid 1 is zero

    if (br2_alu_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_alu_valid1_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 1 has no data

        br2_alu_operand1_out_internal(i)<=broadcast1_data_in;
        br2_alu_valid1_out_internal(i)<='1';

    elsif(br2_alu_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_alu_valid1_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_alu_operand1_out_internal(i)<=broadcast2_data_in;
        br2_alu_valid1_out_internal(i)<='1';
    
    elsif(br2_alu_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_alu_valid1_out_internal(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_alu_operand1_out_internal(i)<=broadcast3_data_in;
        br2_alu_valid1_out_internal(i)<='1';
    
    elsif(br2_alu_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_alu_valid1_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_alu_operand1_out_internal(i)<=broadcast4_data_in;
        br2_alu_valid1_out_internal(i)<='1';

    elsif(br2_alu_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast4_valid_in='1' and br2_alu_valid1_out_internal(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_alu_operand1_out_internal(i)<=broadcast5_data_in;
        br2_alu_valid1_out_internal(i)<='1';    

    end if;

    if (br2_alu_operand2_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_alu_valid2_out_internal(i)='0' and  (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 2 has no data

        br2_alu_operand2_out_internal(i)<=broadcast1_data_in;
        br2_alu_valid2_out_internal(i)<='1';

    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_alu_valid2_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 2 has no data
        
        br2_alu_operand2_out_internal(i)<=broadcast2_data_in;
        br2_alu_valid2_out_internal(i)<='1';
    
    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_alu_valid2_out_internal(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 2 has no data
        
        br2_alu_operand2_out_internal(i)<=broadcast3_data_in;
        br2_alu_valid2_out_internal(i)<='1';

    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_alu_valid2_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 2 has no data
        
        br2_alu_operand2_out_internal(i)<=broadcast4_data_in;
        br2_alu_valid2_out_internal(i)<='1';
    
    elsif(br1_alu_operand2_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br2_alu_valid2_out_internal(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 2 has no data
        
        br2_alu_operand2_out_internal(i)<=broadcast5_data_in;
        br2_alu_valid2_out_internal(i)<='1';


    

    end if;



    if (br2_alu_operand3_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_alu_valid3_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 3 has no data

        br2_alu_operand3_out_internal(i)<=broadcast1_data_in;
        br2_alu_valid3_out_internal(i)<='1';

    elsif(br2_alu_operand3_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_alu_valid3_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_operand3_out_internal(i)<=broadcast2_data_in;
        br2_alu_valid3_out_internal(i)<='1';
    
    elsif(br2_alu_operand3_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_alu_valid3_out_internal(i)='0' and  (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_operand3_out_internal(i)<=broadcast3_data_in;
        br2_alu_valid3_out_internal(i)<='1';

    elsif(br2_alu_operand3_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_alu_valid3_out_internal(i)='0' and  (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_operand3_out_internal(i)<=broadcast4_data_in;
        br2_alu_valid3_out_internal(i)<='1';

    elsif(br2_alu_operand3_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br2_alu_valid3_out_internal(i)='0' and  (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_operand3_out_internal(i)<=broadcast5_data_in;
        br2_alu_valid3_out_internal(i)<='1';
        
    

    end if;

    ---------refers to c flag validity

   if (br2_alu_c_flag_rename_out_internal(i)=broadcast1_c_flag_rename_in and broadcast1_c_flag_valid_in='1' and br2_alu_c_flag_valid_out_internal(i)='0' and  (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 3 has no data

        br2_alu_c_flag_out_internal(i)<=broadcast1_c_flag_in;
        br2_alu_c_flag_valid_out_internal(i)<='1';

    elsif(br2_alu_c_flag_rename_out_internal(i)=broadcast2_c_flag_rename_in and broadcast2_c_flag_valid_in='1' and br2_alu_c_flag_valid_out_internal(i)='0' and  (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_c_flag_out_internal(i)<=broadcast2_c_flag_in;
        br2_alu_c_flag_valid_out_internal(i)<='1';
    
    elsif(br2_alu_c_flag_rename_out_internal(i)=broadcast4_c_flag_rename_in and broadcast4_c_flag_valid_in='1' and br2_alu_c_flag_valid_out_internal(i)='0' and  (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_c_flag_out_internal(i)<=broadcast4_c_flag_in;
        br2_alu_c_flag_valid_out_internal(i)<='1';

    
    end if; 

    --refers to revalidation of z flag


    if (br2_alu_z_flag_rename_out_internal(i)=broadcast1_z_flag_rename_in and broadcast1_z_flag_valid_in='1' and br2_alu_z_flag_valid_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 3 has no data

        br2_alu_z_flag_out_internal(i)<=broadcast1_z_flag_in;
        br2_alu_z_flag_valid_out_internal(i)<='1';

    elsif(br1_alu_z_flag_rename_out_internal(i)=broadcast2_z_flag_rename_in and broadcast2_z_flag_valid_in='1' and br2_alu_z_flag_valid_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_z_flag_out_internal(i)<=broadcast2_z_flag_in;
        br2_alu_z_flag_valid_out_internal(i)<='1';
    
    elsif(br1_alu_z_flag_rename_out_internal(i)=broadcast4_z_flag_rename_in and broadcast4_z_flag_valid_in='1' and br2_alu_z_flag_valid_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_alu_z_flag_out_internal(i)<=broadcast4_z_flag_in;
        br2_alu_z_flag_valid_out_internal(i)<='1';

    
    end if;


    


   

    end if;


  end if;   




end loop;  

     



end process; 




process(reset_system,clk_input,stall_reservation_update,halt_out_internal)--ls part in RS
                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    ls_instr_valid_out_internal(i)<='0';
    ls_op_code_out_internal(i)<=(others=>'0');
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    ls_operand1_out_internal(i)<=(others=>'0');
    ls_valid1_out_internal(i)<='0';
    
    ls_operand2_out_internal(i)<=(others=>'0');
    ls_valid2_out_internal(i)<='0';
    
    ls_operand3_out_internal(i)<=(others=>'0');
    ls_valid3_out_internal(i)<='0';



    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';


     


     ls_destn_rename_code_out_internal(i)<=(others=>'0');
     ls_orign_destn_out_internal(i)<=(others=>'0');

     ls_btag_out_internal(i)<=(others=>'0');
     ls_curr_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults

   if (branch_mispredict_broadcast_in="01") then
    ls_instr_valid_out_internal(i)<=br1_ls_instr_valid_out_internal(i);
    ls_op_code_out_internal(i)<=br1_ls_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    ls_operand1_out_internal(i)<=br1_ls_operand1_out_internal(i);
    ls_valid1_out_internal(i)<=br1_ls_valid1_out_internal(i);
    
    ls_operand2_out_internal(i)<=br1_ls_operand2_out_internal(i);
    ls_valid2_out_internal(i)<=br1_ls_valid2_out_internal(i);
    
    ls_operand3_out_internal(i)<=br1_ls_operand3_out_internal(i);
    ls_valid3_out_internal(i)<=br1_ls_valid3_out_internal(i);





     ls_destn_rename_code_out_internal(i)<=br1_ls_destn_rename_code_out_internal(i);
     ls_orign_destn_out_internal(i)<=br1_ls_orign_destn_out_internal(i);

     ls_btag_out_internal(i)<=br1_ls_btag_out_internal(i);
     ls_curr_pc_out_internal(i)<=br1_ls_curr_pc_out_internal(i);

   elsif (branch_mispredict_broadcast_in="10") then

    ls_instr_valid_out_internal(i)<=br2_ls_instr_valid_out_internal(i);
    ls_op_code_out_internal(i)<=br2_ls_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    ls_operand1_out_internal(i)<=br2_ls_operand1_out_internal(i);
    ls_valid1_out_internal(i)<=br2_ls_valid1_out_internal(i);
    
    ls_operand2_out_internal(i)<=br2_ls_operand2_out_internal(i);
    ls_valid2_out_internal(i)<=br2_ls_valid2_out_internal(i);
    
    ls_operand3_out_internal(i)<=br2_ls_operand3_out_internal(i);
    ls_valid3_out_internal(i)<=br2_ls_valid3_out_internal(i);



     ls_destn_rename_code_out_internal(i)<=br2_ls_destn_rename_code_out_internal(i);
     ls_orign_destn_out_internal(i)<=br2_ls_orign_destn_out_internal(i);

     ls_btag_out_internal(i)<=br2_ls_btag_out_internal(i);
     ls_curr_pc_out_internal(i)<=br2_ls_curr_pc_out_internal(i);

  


   elsif (ls_instr_valid_out_internal(i)='1' and ls_scheduler_valid_out_internal(i)='1') then

    if(i=to_integer(unsigned(ls_done_number)) and ls_valid_done_in='1' ) then

     ls_instr_valid_out_internal(i)<='0';

    end if;


   elsif (ls_instr_valid_out_internal(i)='1' and ls_scheduler_valid_out_internal(i)='0') then

    if (ls_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and ls_valid1_out_internal(i)='0') then --refers to the case when operand 1 has no data

        ls_operand1_out_internal(i)<=broadcast1_data_in;
        ls_valid1_out_internal(i)<='1';

    elsif(ls_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and ls_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        ls_operand1_out_internal(i)<=broadcast2_data_in;
        ls_valid1_out_internal(i)<='1';
    
    elsif(ls_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and ls_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        ls_operand1_out_internal(i)<=broadcast3_data_in;
        ls_valid1_out_internal(i)<='1';
    
    elsif(alu_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and ls_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        ls_operand1_out_internal(i)<=broadcast4_data_in;
        ls_valid1_out_internal(i)<='1';

    elsif(alu_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and ls_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        ls_operand1_out_internal(i)<=broadcast5_data_in;
        ls_valid1_out_internal(i)<='1';    

    end if;

    if (ls_operand3_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and ls_valid3_out_internal(i)='0') then --refers to the case when operand 3 has no data

        ls_operand3_out_internal(i)<=broadcast1_data_in;
        ls_valid3_out_internal(i)<='1';

    elsif(ls_operand3_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and ls_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        ls_operand3_out_internal(i)<=broadcast2_data_in;
        ls_valid3_out_internal(i)<='1';
    
    elsif(ls_operand3_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and ls_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        ls_operand3_out_internal(i)<=broadcast3_data_in;
        ls_valid3_out_internal(i)<='1';

    elsif(ls_operand3_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and ls_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        ls_operand3_out_internal(i)<=broadcast4_data_in;
        ls_valid3_out_internal(i)<='1';
    
    elsif(ls_operand3_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and ls_valid3_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        ls_operand3_out_internal(i)<=broadcast5_data_in;
        ls_valid3_out_internal(i)<='1';
    

    end if;
    


   elsif (ls_instr_valid_out_internal(i)='0') then

   
   if (halt_out_internal='0') then
 
     if (op_code1_in="0100" or op_code1_in="0011" or op_code1_in="0101")  then --instructions related to load/store

       if (i=ls_vacant_entry(0)) then
         ls_instr_valid_out_internal(i)<=instr1_valid_in;
         ls_op_code_out_internal(i)<=op_code1_in;
         --ls_op_code_cz_out_internal(i)<=op_cz1_in;
         ls_destn_rename_code_out_internal(i)<=first_free_rename(0);
         ls_operand1_out_internal(i)<=operand1_out_internal_instr1;
         ls_valid1_out_internal(i)<=operand1_out_internal_data_valid_instr1;


         ls_operand2_out_internal(i)<=imm1_in; --since we get immediate data from operand 2  
         ls_valid2_out_internal(i)<='1';

         ls_operand3_out_internal(i)<=operand3_out_internal_instr1;
         ls_valid3_out_internal(i)<=operand3_out_internal_data_valid_instr1;


         
         ls_btag_out_internal(i)<=btag1_in;

         ls_orign_destn_out_internal(i)<=opr3_code1_in;

         ls_curr_pc_out_internal(i)<=curr_pc1_in;

        end if;
      end if;   


      if (op_code2_in="0100" or op_code2_in="0011" or op_code2_in="0101") then --instructions related to load/store  


        if (i=ls_vacant_entry(1)) then
          
         ls_instr_valid_out_internal(i)<=instr2_valid_in;
         ls_op_code_out_internal(i)<=op_code2_in;
         --ls_op_code_cz_out_internal(i)<=op_cz1_in;
         ls_destn_rename_code_out_internal(i)<=first_free_rename(1);
         ls_operand1_out_internal(i)<=operand1_out_internal_instr2;
         ls_valid1_out_internal(i)<=operand1_out_internal_data_valid_instr2;


         ls_operand2_out_internal(i)<=imm2_in; --since we get immediate data from operand 2 
         ls_valid2_out_internal(i)<='1';

         ls_operand3_out_internal(i)<=operand3_out_internal_instr2;
         ls_valid3_out_internal(i)<=operand3_out_internal_data_valid_instr2;


         
         ls_btag_out_internal(i)<=btag2_in;

         ls_orign_destn_out_internal(i)<=opr3_code2_in;

         ls_curr_pc_out_internal(i)<=curr_pc2_in; 


      

         end if;


      end if;

     end if; 


    end if;   

end if;



end loop;  

     



end process;


--branch 1 copy of ls entry

process(reset_system,clk_input,stall_reservation_update,halt_out_internal)--ls part in RS
                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    br1_ls_instr_valid_out_internal(i)<='0';
    br1_ls_op_code_out_internal(i)<=(others=>'0');
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br1_ls_operand1_out_internal(i)<=(others=>'0');
    br1_ls_valid1_out_internal(i)<='0';
    
    br1_ls_operand2_out_internal(i)<=(others=>'0');
    br1_ls_valid2_out_internal(i)<='0';
    
    br1_ls_operand3_out_internal(i)<=(others=>'0');
    br1_ls_valid3_out_internal(i)<='0';



    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';


     


     br1_ls_destn_rename_code_out_internal(i)<=(others=>'0');
     br1_ls_orign_destn_out_internal(i)<=(others=>'0');

     br1_ls_btag_out_internal(i)<=(others=>'0');
     br1_ls_curr_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults

   if (branch1_done='1') then

    br1_ls_instr_valid_out_internal(i)<=ls_instr_valid_out_internal(i);
    br1_ls_op_code_out_internal(i)<=ls_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br1_ls_operand1_out_internal(i)<=ls_operand1_out_internal(i);
    br1_ls_valid1_out_internal(i)<=ls_valid1_out_internal(i);
    
    br1_ls_operand2_out_internal(i)<=ls_operand2_out_internal(i);
    br1_ls_valid2_out_internal(i)<=ls_valid2_out_internal(i);
    
    br1_ls_operand3_out_internal(i)<=ls_operand3_out_internal(i);
    br1_ls_valid3_out_internal(i)<=ls_valid3_out_internal(i);


     br1_ls_destn_rename_code_out_internal(i)<=ls_destn_rename_code_out_internal(i);
     br1_ls_orign_destn_out_internal(i)<=ls_orign_destn_out_internal(i);

     br1_ls_btag_out_internal(i)<=ls_btag_out_internal(i);
     br1_ls_curr_pc_out_internal(i)<=ls_curr_pc_out_internal(i);



   
   elsif (br1_ls_instr_valid_out_internal(i)='1') then

    if (br1_ls_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_ls_valid1_out_internal(i)='0' and broadcast1_btag_in="000") then --refers to the case when operand 1 has no data

        br1_ls_operand1_out_internal(i)<=broadcast1_data_in;
        br1_ls_valid1_out_internal(i)<='1';

    elsif(br1_ls_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_ls_valid1_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_ls_operand1_out_internal(i)<=broadcast2_data_in;
        br1_ls_valid1_out_internal(i)<='1';
    
    elsif(br1_ls_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_ls_valid1_out_internal(i)='0' and broadcast3_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_ls_operand1_out_internal(i)<=broadcast3_data_in;
        br1_ls_valid1_out_internal(i)<='1';
    
    elsif(br1_alu_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_ls_valid1_out_internal(i)='0' and broadcast4_btag_in="000" ) then --refers to case when operand 1 has no data
        
        br1_ls_operand1_out_internal(i)<=broadcast4_data_in;
        br1_ls_valid1_out_internal(i)<='1';

    elsif(br1_alu_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br1_ls_valid1_out_internal(i)='0' and broadcast5_btag_in="000" ) then --refers to case when operand 1 has no data
        
        br1_ls_operand1_out_internal(i)<=broadcast5_data_in;
        br1_ls_valid1_out_internal(i)<='1';    

    end if;

    if (br1_ls_operand3_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_ls_valid3_out_internal(i)='0' and broadcast1_btag_in="000") then --refers to the case when operand 3 has no data

        br1_ls_operand3_out_internal(i)<=broadcast1_data_in;
        br1_ls_valid3_out_internal(i)<='1';

    elsif(br1_ls_operand3_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_ls_valid3_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_ls_operand3_out_internal(i)<=broadcast2_data_in;
        br1_ls_valid3_out_internal(i)<='1';
    
    elsif(br1_ls_operand3_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_ls_valid3_out_internal(i)='0' and broadcast3_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_ls_operand3_out_internal(i)<=broadcast3_data_in;
        br1_ls_valid3_out_internal(i)<='1';

    elsif(br1_ls_operand3_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_ls_valid3_out_internal(i)='0' and broadcast4_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_ls_operand3_out_internal(i)<=broadcast4_data_in;
        br1_ls_valid3_out_internal(i)<='1';

    elsif(br1_ls_operand3_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br1_ls_valid3_out_internal(i)='0' and broadcast5_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_ls_operand3_out_internal(i)<=broadcast5_data_in;
        br1_ls_valid3_out_internal(i)<='1';
        
    

    end if;
    




    end if;   

  end if;



 end loop;  

end process;

--branch 2 copy of ls


process(reset_system,clk_input,stall_reservation_update,halt_out_internal)--ls part in RS
                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    br2_ls_instr_valid_out_internal(i)<='0';
    br2_ls_op_code_out_internal(i)<=(others=>'0');
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br2_ls_operand1_out_internal(i)<=(others=>'0');
    br2_ls_valid1_out_internal(i)<='0';
    
    br2_ls_operand2_out_internal(i)<=(others=>'0');
    br2_ls_valid2_out_internal(i)<='0';
    
    br2_ls_operand3_out_internal(i)<=(others=>'0');
    br2_ls_valid3_out_internal(i)<='0';



    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';


     br2_ls_destn_rename_code_out_internal(i)<=(others=>'0');
     br2_ls_orign_destn_out_internal(i)<=(others=>'0');

     br2_ls_btag_out_internal(i)<=(others=>'0');
     br2_ls_curr_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then  --broadcasting takes place even in internal haults

   if (branch2_done='1') then

    br2_ls_instr_valid_out_internal(i)<=ls_instr_valid_out_internal(i);
    br2_ls_op_code_out_internal(i)<=ls_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br2_ls_operand1_out_internal(i)<=ls_operand1_out_internal(i);
    br2_ls_valid1_out_internal(i)<=ls_valid1_out_internal(i);
    
    br2_ls_operand2_out_internal(i)<=ls_operand2_out_internal(i);
    br2_ls_valid2_out_internal(i)<=ls_valid2_out_internal(i);
    
    br2_ls_operand3_out_internal(i)<=ls_operand3_out_internal(i);
    br2_ls_valid3_out_internal(i)<=ls_valid3_out_internal(i);



    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';


     


     br2_ls_destn_rename_code_out_internal(i)<=ls_destn_rename_code_out_internal(i);
     br2_ls_orign_destn_out_internal(i)<=ls_orign_destn_out_internal(i);

     br2_ls_btag_out_internal(i)<=ls_btag_out_internal(i);
     br2_ls_curr_pc_out_internal(i)<=ls_curr_pc_out_internal(i);



   
   elsif (br2_ls_instr_valid_out_internal(i)='1') then

    if (br2_ls_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_ls_valid1_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 1 has no data

        br2_ls_operand1_out_internal(i)<=broadcast1_data_in;
        br2_ls_valid1_out_internal(i)<='1';

    elsif(br2_ls_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_ls_valid1_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_ls_operand1_out_internal(i)<=broadcast2_data_in;
        br2_ls_valid1_out_internal(i)<='1';
    
    elsif(br2_ls_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_ls_valid1_out_internal(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_ls_operand1_out_internal(i)<=broadcast3_data_in;
        br2_ls_valid1_out_internal(i)<='1';
    
    elsif(br2_alu_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_ls_valid1_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_ls_operand1_out_internal(i)<=broadcast4_data_in;
        br2_ls_valid1_out_internal(i)<='1';

    elsif(br2_alu_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br2_ls_valid1_out_internal(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_ls_operand1_out_internal(i)<=broadcast5_data_in;
        br2_ls_valid1_out_internal(i)<='1';    

    end if;

    if (br2_ls_operand3_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_ls_valid3_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 3 has no data

        br2_ls_operand3_out_internal(i)<=broadcast1_data_in;
        br2_ls_valid3_out_internal(i)<='1';

    elsif(br2_ls_operand3_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_ls_valid3_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_ls_operand3_out_internal(i)<=broadcast2_data_in;
        br2_ls_valid3_out_internal(i)<='1';
    
    elsif(br2_ls_operand3_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_ls_valid3_out_internal(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_ls_operand3_out_internal(i)<=broadcast3_data_in;
        br2_ls_valid3_out_internal(i)<='1';

    elsif(br2_ls_operand3_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_ls_valid3_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_ls_operand3_out_internal(i)<=broadcast4_data_in;
        br2_ls_valid3_out_internal(i)<='1';

    elsif(br2_ls_operand3_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br2_ls_valid3_out_internal(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_ls_operand3_out_internal(i)<=broadcast5_data_in;
        br2_ls_valid3_out_internal(i)<='1';    

        
    

    end if;
    




    end if;   

  end if;



 end loop;  

end process;






process(reset_system,clk_input,stall_reservation_update,halt_out_internal )  --- jmp part in RS--

                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    jmp_instr_valid_out_internal(i)<='0';
    jmp_op_code_out_internal(i)<=(others=>'0');
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    jmp_operand1_out_internal(i)<=(others=>'0');
    jmp_valid1_out_internal(i)<='0';
    
    jmp_operand2_out_internal(i)<=(others=>'0');
    jmp_valid2_out_internal(i)<='0';

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

    jmp_operand3_out_internal(i)<=(others=>'0');
    jmp_valid3_out_internal(i)<='0';


     


     jmp_destn_rename_code_out_internal(i)<=(others=>'0');
     jmp_orign_destn_out_internal(i)<=(others=>'0');

     jmp_btag_out_internal(i)<=(others=>'0');
     jmp_curr_pc_out_internal(i)<=(others=>'0');

     jmp_self_tag_out_internal(i)<=(others=>'0');
     jmp_next_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then  --broadcasting takes place even in internal haults

   if (branch_mispredict_broadcast_in="01") then


    jmp_instr_valid_out_internal(i)<=br1_jmp_instr_valid_out_internal(i);
    jmp_op_code_out_internal(i)<=br1_jmp_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    jmp_operand1_out_internal(i)<=br1_jmp_operand1_out_internal(i);
    jmp_valid1_out_internal(i)<=br1_jmp_valid1_out_internal(i);
    
    jmp_operand2_out_internal(i)<=br1_jmp_operand2_out_internal(i);
    jmp_valid2_out_internal(i)<=br1_jmp_valid2_out_internal(i);

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

    jmp_operand3_out_internal(i)<=br1_jmp_operand3_out_internal(i);
    jmp_valid3_out_internal(i)<=br1_jmp_valid3_out_internal(i);


     


     jmp_destn_rename_code_out_internal(i)<=br1_jmp_destn_rename_code_out_internal(i);
     jmp_orign_destn_out_internal(i)<=br1_jmp_orign_destn_out_internal(i);

     jmp_btag_out_internal(i)<=br1_jmp_btag_out_internal(i);
     jmp_curr_pc_out_internal(i)<=br1_jmp_curr_pc_out_internal(i);

     jmp_self_tag_out_internal(i)<=br1_jmp_self_tag_out_internal(i);
     jmp_next_pc_out_internal(i)<=br1_jmp_next_pc_out_internal(i);

   elsif (branch_mispredict_broadcast_in="10") then  
     
     jmp_instr_valid_out_internal(i)<=br2_jmp_instr_valid_out_internal(i);
     jmp_op_code_out_internal(i)<=br2_jmp_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
     jmp_operand1_out_internal(i)<=br2_jmp_operand1_out_internal(i);
     jmp_valid1_out_internal(i)<=br2_jmp_valid1_out_internal(i);
    
     jmp_operand2_out_internal(i)<=br2_jmp_operand2_out_internal(i);
     jmp_valid2_out_internal(i)<=br2_jmp_valid2_out_internal(i);

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

     jmp_operand3_out_internal(i)<=br2_jmp_operand3_out_internal(i);
     jmp_valid3_out_internal(i)<=br2_jmp_valid3_out_internal(i);


     jmp_destn_rename_code_out_internal(i)<=br2_jmp_destn_rename_code_out_internal(i);
     jmp_orign_destn_out_internal(i)<=br2_jmp_orign_destn_out_internal(i);

     jmp_btag_out_internal(i)<=br2_jmp_btag_out_internal(i);
     jmp_curr_pc_out_internal(i)<=br2_jmp_curr_pc_out_internal(i);

     jmp_self_tag_out_internal(i)<=br2_jmp_self_tag_out_internal(i);
     jmp_next_pc_out_internal(i)<=br2_jmp_next_pc_out_internal(i); 




   elsif (jmp_instr_valid_out_internal(i)='1' and jmp_scheduler_valid_out_internal(i)='1') then

    if(i=to_integer(unsigned(jmp_done_number)) and jmp_valid_done_in='1' ) then

     jmp_instr_valid_out_internal(i)<='0';

    end if;


   elsif (jmp_instr_valid_out_internal(i)='1' and jmp_scheduler_valid_out_internal(i)='0') then

    if (jmp_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and jmp_valid1_out_internal(i)='0') then --refers to the case when operand 1 has no data

        jmp_operand1_out_internal(i)<=broadcast1_data_in;
        jmp_valid1_out_internal(i)<='1';

    elsif(jmp_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and jmp_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        jmp_operand1_out_internal(i)<=broadcast2_data_in;
        jmp_valid1_out_internal(i)<='1';
    
    elsif(jmp_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and jmp_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        jmp_operand1_out_internal(i)<=broadcast3_data_in;
        jmp_valid1_out_internal(i)<='1';
    
    elsif(jmp_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and jmp_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        jmp_operand1_out_internal(i)<=broadcast4_data_in;
        jmp_valid1_out_internal(i)<='1';

    elsif(jmp_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and jmp_valid1_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        jmp_operand1_out_internal(i)<=broadcast5_data_in;
        jmp_valid1_out_internal(i)<='1';
    

    end if;


    ----Note here there can be two operands waiting Ra and Rb in case of BEQ, given in operand1 and operand 2 or operand1 in case of JLR/JAL

    if (jmp_operand2_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and jmp_valid2_out_internal(i)='0') then --refers to the case when operand 3 has no data

        jmp_operand2_out_internal(i)<=broadcast1_data_in;
        jmp_valid2_out_internal(i)<='1';

    elsif(jmp_operand2_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and jmp_valid2_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        jmp_operand2_out_internal(i)<=broadcast2_data_in;
        jmp_valid2_out_internal(i)<='1';
    
    elsif(jmp_operand2_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and jmp_valid2_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        jmp_operand2_out_internal(i)<=broadcast3_data_in;
        jmp_valid2_out_internal(i)<='1';

    elsif(jmp_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and jmp_valid2_out_internal(i)='0') then --refers to case when operand 3 has no data
        
        jmp_operand2_out_internal(i)<=broadcast4_data_in;
        jmp_valid2_out_internal(i)<='1';

    elsif(jmp_operand2_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and jmp_valid2_out_internal(i)='0') then --refers to case when operand 1 has no data
        
        jmp_operand2_out_internal(i)<=broadcast5_data_in;
        jmp_valid2_out_internal(i)<='1';
    
    

    end if;
    


   elsif (jmp_instr_valid_out_internal(i)='0') then
 
    if (halt_out_internal='0') then

     if (op_code1_in="1100" or op_code1_in="1000" or op_code1_in="1001")  then --instructions related to BEQ/JAL/JLR

       if (i=jmp_vacant_entry(0)) then
         jmp_instr_valid_out_internal(i)<=instr1_valid_in;
         jmp_op_code_out_internal(i)<=op_code1_in;
         --ls_op_code_cz_out_internal(i)<=op_cz1_in;
         jmp_destn_rename_code_out_internal(i)<=first_free_rename(0);
         jmp_operand1_out_internal(i)<=operand1_out_internal_instr1;
         jmp_valid1_out_internal(i)<=operand1_out_internal_data_valid_instr1;


         
        if (op_code1_in="1100") then --assumes BEQ has operand 1 and 2 as Ra and Rb
         jmp_operand2_out_internal(i)<=operand2_out_internal_instr1;
         jmp_valid2_out_internal(i)<=operand2_out_internal_data_valid_instr1;

        else --assumes 
         jmp_operand2_out_internal(i)<=imm1_in;
         jmp_valid2_out_internal(i)<='1';
        end if; 


        if (not(op_code1_in="1100")) then --assumes BEQ has operand 1 and 2 as Ra and Rb and operand 3 as destn
        
         jmp_operand3_out_internal(i)<=operand2_out_internal_instr1;
         jmp_valid3_out_internal(i)<=operand2_out_internal_data_valid_instr1;

        else --assumes 
         jmp_operand3_out_internal(i)<=imm1_in;
         jmp_valid3_out_internal(i)<='1';
        end if;

         
         jmp_btag_out_internal(i)<=btag1_in;

         jmp_orign_destn_out_internal(i)<=opr3_code1_in;

         jmp_curr_pc_out_internal(i)<=curr_pc1_in;

         jmp_next_pc_out_internal(i)<=next_pc1_in;

         jmp_self_tag_out_internal(i)<=self1_tag_in;

        end if;
      end if;   


      if (op_code2_in="1100" or op_code2_in="1000" or op_code2_in="1001") then --instructions related to BEQ/JAL/JLR


        if (i=jmp_vacant_entry(1)) then
          
         jmp_instr_valid_out_internal(i)<=instr2_valid_in;
         jmp_op_code_out_internal(i)<=op_code2_in;
         --ls_op_code_cz_out_internal(i)<=op_cz1_in;
         jmp_destn_rename_code_out_internal(i)<=first_free_rename(1);
         
         jmp_operand1_out_internal(i)<=operand1_out_internal_instr2;
         jmp_valid1_out_internal(i)<=operand1_out_internal_data_valid_instr2;


         
        if (op_code2_in="1100") then --assumes BEQ has operand 1 and 2 as Ra and Rb
        
         jmp_operand2_out_internal(i)<=operand2_out_internal_instr2;
         jmp_valid2_out_internal(i)<=operand2_out_internal_data_valid_instr2;

        else --assumes 
         jmp_operand2_out_internal(i)<=imm2_in;
         jmp_valid2_out_internal(i)<='1';
        end if; 


        if (not(op_code2_in="1100")) then --assumes BEQ has operand 1 and 2 as Ra and Rb
        
         jmp_operand3_out_internal(i)<=operand2_out_internal_instr2;
         jmp_valid3_out_internal(i)<=operand2_out_internal_data_valid_instr2;

        else --assumes 
         jmp_operand3_out_internal(i)<=imm2_in;
         jmp_valid3_out_internal(i)<='1';
        end if;


         
         jmp_btag_out_internal(i)<=btag2_in;

         jmp_orign_destn_out_internal(i)<=opr3_code2_in;

         jmp_curr_pc_out_internal(i)<=curr_pc2_in;

         jmp_next_pc_out_internal(i)<=next_pc2_in;

         jmp_self_tag_out_internal(i)<=self2_tag_in;


      

         end if;


      end if;

     end if; 


    end if;   

end if;



end loop;  

     



end process;

--br1 copy of jump instr


process(reset_system,clk_input,stall_reservation_update,halt_out_internal )  --- jmp part in RS--

                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    br1_jmp_instr_valid_out_internal(i)<='0';
    br1_jmp_op_code_out_internal(i)<=(others=>'0');
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br1_jmp_operand1_out_internal(i)<=(others=>'0');
    br1_jmp_valid1_out_internal(i)<='0';
    
    br1_jmp_operand2_out_internal(i)<=(others=>'0');
    br1_jmp_valid2_out_internal(i)<='0';

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

    br1_jmp_operand3_out_internal(i)<=(others=>'0');
    br1_jmp_valid3_out_internal(i)<='0';


     


     br1_jmp_destn_rename_code_out_internal(i)<=(others=>'0');
     br1_jmp_orign_destn_out_internal(i)<=(others=>'0');

     br1_jmp_btag_out_internal(i)<=(others=>'0');
     br1_jmp_curr_pc_out_internal(i)<=(others=>'0');

     br1_jmp_self_tag_out_internal(i)<=(others=>'0');
     br1_jmp_next_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then --broadcasting takes place even in internal haults

   if (branch1_done='1') then
    br1_jmp_instr_valid_out_internal(i)<=jmp_instr_valid_out_internal(i);
    br1_jmp_op_code_out_internal(i)<=jmp_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br1_jmp_operand1_out_internal(i)<=jmp_operand1_out_internal(i);
    br1_jmp_valid1_out_internal(i)<=jmp_valid1_out_internal(i);
    
    br1_jmp_operand2_out_internal(i)<=jmp_operand2_out_internal(i);
    br1_jmp_valid2_out_internal(i)<=jmp_valid2_out_internal(i);

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

    br1_jmp_operand3_out_internal(i)<=jmp_operand3_out_internal(i);
    br1_jmp_valid3_out_internal(i)<=jmp_valid3_out_internal(i);


     


     br1_jmp_destn_rename_code_out_internal(i)<=jmp_destn_rename_code_out_internal(i);
     br1_jmp_orign_destn_out_internal(i)<=jmp_orign_destn_out_internal(i);

     br1_jmp_btag_out_internal(i)<=jmp_btag_out_internal(i);
     br1_jmp_curr_pc_out_internal(i)<=jmp_curr_pc_out_internal(i);

     br1_jmp_self_tag_out_internal(i)<=jmp_self_tag_out_internal(i);
     br1_jmp_next_pc_out_internal(i)<=jmp_next_pc_out_internal(i);



   elsif (br1_jmp_instr_valid_out_internal(i)='1') then

    if (br1_jmp_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_jmp_valid1_out_internal(i)='0' and broadcast1_btag_in="000") then --refers to the case when operand 1 has no data

        br1_jmp_operand1_out_internal(i)<=broadcast1_data_in;
        br1_jmp_valid1_out_internal(i)<='1';

    elsif(br1_jmp_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_jmp_valid1_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_jmp_operand1_out_internal(i)<=broadcast2_data_in;
        br1_jmp_valid1_out_internal(i)<='1';
    
    elsif(br1_jmp_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_jmp_valid1_out_internal(i)='0' and broadcast3_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_jmp_operand1_out_internal(i)<=broadcast3_data_in;
        br1_jmp_valid1_out_internal(i)<='1';
    
    elsif(br1_jmp_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_jmp_valid1_out_internal(i)='0' and broadcast4_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_jmp_operand1_out_internal(i)<=broadcast4_data_in;
        br1_jmp_valid1_out_internal(i)<='1';

    elsif(br1_jmp_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br1_jmp_valid1_out_internal(i)='0' and broadcast5_btag_in="000") then --refers to case when operand 1 has no data
        
        br1_jmp_operand1_out_internal(i)<=broadcast5_data_in;
        br1_jmp_valid1_out_internal(i)<='1';    

    end if;


    ----Note here there can be two operands waiting Ra and Rb in case of BEQ, given in operand1 and operand 2 or operand1 in case of JLR/JAL

    if (br1_jmp_operand2_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br1_jmp_valid2_out_internal(i)='0' and broadcast1_btag_in="000") then --refers to the case when operand 3 has no data

        br1_jmp_operand2_out_internal(i)<=broadcast1_data_in;
        br1_jmp_valid2_out_internal(i)<='1';

    elsif(br1_jmp_operand2_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br1_jmp_valid2_out_internal(i)='0' and broadcast2_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_jmp_operand2_out_internal(i)<=broadcast2_data_in;
        br1_jmp_valid2_out_internal(i)<='1';
    
    elsif(br1_jmp_operand2_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br1_jmp_valid2_out_internal(i)='0' and broadcast3_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_jmp_operand2_out_internal(i)<=broadcast3_data_in;
        br1_jmp_valid2_out_internal(i)<='1';

    elsif(br1_jmp_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br1_jmp_valid2_out_internal(i)='0' and broadcast4_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_jmp_operand2_out_internal(i)<=broadcast4_data_in;
        br1_jmp_valid2_out_internal(i)<='1';

    elsif(br1_jmp_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast5_valid_in='1' and br1_jmp_valid2_out_internal(i)='0' and broadcast5_btag_in="000") then --refers to case when operand 3 has no data
        
        br1_jmp_operand2_out_internal(i)<=broadcast4_data_in;
        br1_jmp_valid2_out_internal(i)<='1';    
    

    end if;
    

 end if;
          

end if;



end loop;  

     



end process;


--branch 2 copy of jump instr

process(reset_system,clk_input,stall_reservation_update,halt_out_internal )  --- jmp part in RS--

                       -------This checks each entry in RS and tries to update each entry in case of broadcast or during entry from decode state
 variable i:integer range 0 to 9;
 begin

 for i in 0 to 9 loop

  if (reset_system='1') then

    br2_jmp_instr_valid_out_internal(i)<='0';
    br2_jmp_op_code_out_internal(i)<=(others=>'0');
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br2_jmp_operand1_out_internal(i)<=(others=>'0');
    br2_jmp_valid1_out_internal(i)<='0';
    
    br2_jmp_operand2_out_internal(i)<=(others=>'0');
    br2_jmp_valid2_out_internal(i)<='0';

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

    br2_jmp_operand3_out_internal(i)<=(others=>'0');
    br2_jmp_valid3_out_internal(i)<='0';


     


     br2_jmp_destn_rename_code_out_internal(i)<=(others=>'0');
     br2_jmp_orign_destn_out_internal(i)<=(others=>'0');

     br2_jmp_btag_out_internal(i)<=(others=>'0');
     br2_jmp_curr_pc_out_internal(i)<=(others=>'0');

     br2_jmp_self_tag_out_internal(i)<=(others=>'0');
     br2_jmp_next_pc_out_internal(i)<=(others=>'0');



  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' ) then

   if (branch2_done='1') then
    br2_jmp_instr_valid_out_internal(i)<=jmp_instr_valid_out_internal(i);
    br2_jmp_op_code_out_internal(i)<=jmp_op_code_out_internal(i);
    --alu_op_code_cz_out_internal(i)<=(others=>'0');
    br2_jmp_operand1_out_internal(i)<=jmp_operand1_out_internal(i);
    br2_jmp_valid1_out_internal(i)<=jmp_valid1_out_internal(i);
    
    br2_jmp_operand2_out_internal(i)<=jmp_operand2_out_internal(i);
    br2_jmp_valid2_out_internal(i)<=jmp_valid2_out_internal(i);

    --alu_operand3_out_internal(i)<=(others=>'0');
    --alu_valid3_out_internal(i)<='0';

    br2_jmp_operand3_out_internal(i)<=jmp_operand3_out_internal(i);
    br2_jmp_valid3_out_internal(i)<=jmp_valid3_out_internal(i);


     


     br2_jmp_destn_rename_code_out_internal(i)<=jmp_destn_rename_code_out_internal(i);
     br2_jmp_orign_destn_out_internal(i)<=jmp_orign_destn_out_internal(i);

     br2_jmp_btag_out_internal(i)<=jmp_btag_out_internal(i);
     br2_jmp_curr_pc_out_internal(i)<=jmp_curr_pc_out_internal(i);

     br2_jmp_self_tag_out_internal(i)<=jmp_self_tag_out_internal(i);
     br2_jmp_next_pc_out_internal(i)<=jmp_next_pc_out_internal(i);


   elsif (br2_jmp_instr_valid_out_internal(i)='1') then

    if (br2_jmp_operand1_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_jmp_valid1_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 1 has no data

        br2_jmp_operand1_out_internal(i)<=broadcast1_data_in;
        br2_jmp_valid1_out_internal(i)<='1';

    elsif(br1_jmp_operand1_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_jmp_valid1_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_jmp_operand1_out_internal(i)<=broadcast2_data_in;
        br2_jmp_valid1_out_internal(i)<='1';
    
    elsif(br2_jmp_operand1_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_jmp_valid1_out_internal(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_jmp_operand1_out_internal(i)<=broadcast3_data_in;
        br2_jmp_valid1_out_internal(i)<='1';
    
    elsif(br2_jmp_operand1_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_jmp_valid1_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_jmp_operand1_out_internal(i)<=broadcast4_data_in;
        br2_jmp_valid1_out_internal(i)<='1';

    elsif(br2_jmp_operand1_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br2_jmp_valid1_out_internal(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 1 has no data
        
        br2_jmp_operand1_out_internal(i)<=broadcast5_data_in;
        br2_jmp_valid1_out_internal(i)<='1';    

    end if;


    ----Note here there can be two operands waiting Ra and Rb in case of BEQ, given in operand1 and operand 2 or operand1 in case of JLR/JAL

    if (br2_jmp_operand2_out_internal(i)="0000000000" & broadcast1_rename_in and broadcast1_valid_in='1' and br2_jmp_valid2_out_internal(i)='0' and (broadcast1_btag_in="000" or broadcast1_btag_in="001")) then --refers to the case when operand 3 has no data

        br2_jmp_operand2_out_internal(i)<=broadcast1_data_in;
        br2_jmp_valid2_out_internal(i)<='1';

    elsif(br2_jmp_operand2_out_internal(i)="0000000000" & broadcast2_rename_in and broadcast2_valid_in='1' and br2_jmp_valid2_out_internal(i)='0' and (broadcast2_btag_in="000" or broadcast2_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_jmp_operand2_out_internal(i)<=broadcast2_data_in;
        br2_jmp_valid2_out_internal(i)<='1';
    
    elsif(br2_jmp_operand2_out_internal(i)="0000000000" & broadcast3_rename_in and broadcast3_valid_in='1' and br2_jmp_valid2_out_internal(i)='0' and (broadcast3_btag_in="000" or broadcast3_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_jmp_operand2_out_internal(i)<=broadcast3_data_in;
        br2_jmp_valid2_out_internal(i)<='1';

    elsif(br2_jmp_operand2_out_internal(i)="0000000000" & broadcast4_rename_in and broadcast4_valid_in='1' and br2_jmp_valid2_out_internal(i)='0' and (broadcast4_btag_in="000" or broadcast4_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_jmp_operand2_out_internal(i)<=broadcast4_data_in;
        br2_jmp_valid2_out_internal(i)<='1';

    elsif(br2_jmp_operand2_out_internal(i)="0000000000" & broadcast5_rename_in and broadcast5_valid_in='1' and br2_jmp_valid2_out_internal(i)='0' and (broadcast5_btag_in="000" or broadcast5_btag_in="001")) then --refers to case when operand 3 has no data
        
        br2_jmp_operand2_out_internal(i)<=broadcast4_data_in;
        br2_jmp_valid2_out_internal(i)<='1';    
    

    end if;
    


  end if;        

end if;



end loop;  

     



end process;









process(alu_instr_valid_out_internal,alu_op_code_out_internal,alu_valid1_out_internal,alu_valid2_out_internal,alu_valid3_out_internal,alu_op_code_cz_out_internal,alu_c_flag_valid_out_internal
         ,alu_z_flag_valid_out_internal ) --to drive alu_scheduler_valid_out

 variable i: integer range 0 to 9;
 
 begin



  for i in 0 to 9 loop

   if (alu_instr_valid_out_internal(i)='1') then

    if( ((alu_op_code_out_internal(i)="0000" or alu_op_code_out_internal(i)="0010")  and alu_op_code_cz_out_internal(i)="00") or alu_op_code_out_internal(i)="0001") then

     if (alu_valid1_out_internal(i)='1' and alu_valid2_out_internal(i)='1') then
      alu_scheduler_valid_out_internal(i)<='1';

     else
      alu_scheduler_valid_out_internal(i)<='0';
     end if;
     
    elsif ((alu_op_code_out_internal(i)="0000" or alu_op_code_out_internal(i)="0010") and alu_op_code_cz_out_internal(i)="10") then

     if (alu_valid1_out_internal(i)='1' and alu_valid2_out_internal(i)='1' and alu_valid3_out_internal(i)='1' and alu_c_flag_valid_out_internal(i)='1') then 

      alu_scheduler_valid_out_internal(i)<='1';
     else
      alu_scheduler_valid_out_internal(i)<='0';
     end if;
     
    elsif ((alu_op_code_out_internal(i)="0000" or alu_op_code_out_internal(i)="0010") and alu_op_code_cz_out_internal(i)="01") then

     if (alu_valid1_out_internal(i)='1' and alu_valid2_out_internal(i)='1' and alu_valid3_out_internal(i)='1' and alu_z_flag_valid_out_internal(i)='1') then 

      alu_scheduler_valid_out_internal(i)<='1';
     else
      alu_scheduler_valid_out_internal(i)<='0';
     
     end if;

    else ---This would never occur
    
     alu_scheduler_valid_out_internal(i)<='0';
    end if;

   else
   
    alu_scheduler_valid_out_internal(i)<='0';
   end if;     


  end loop;

end process;








process (ls_instr_valid_out_internal,ls_op_code_out_internal,ls_valid1_out_internal,ls_valid2_out_internal,ls_valid3_out_internal)

variable i: integer range 0 to 9;
 
 
 begin



for i in 0 to 9 loop


 if (ls_instr_valid_out_internal(i)='1') then 
  if (ls_op_code_out_internal(i)="0101") then --store word instruction all 3 operands

   if (ls_valid1_out_internal(i)='1' and ls_valid2_out_internal(i)='1' and ls_valid3_out_internal(i)='1') then

     ls_scheduler_valid_out_internal(i)<='1';
   else
     ls_scheduler_valid_out_internal(i)<='0';

   end if;

  else  
   
   if (ls_valid1_out_internal(i)='1' and ls_valid2_out_internal(i)='1') then

     ls_scheduler_valid_out_internal(i)<='1';
   else
     ls_scheduler_valid_out_internal(i)<='0';

   end if;

  end if;  

 else

  ls_scheduler_valid_out_internal(i)<='0';
 end if;

end loop;  



end process;

process (jmp_instr_valid_out_internal,jmp_op_code_out_internal,jmp_valid1_out_internal,jmp_valid2_out_internal,jmp_valid3_out_internal)--controls validity of jmp instructions

variable i: integer range 0 to 9;

 begin



for i in 0 to 9 loop


 if (jmp_instr_valid_out_internal(i)='1') then 
  if (jmp_op_code_out_internal(i)="1000") then --JAL instruction

   if (jmp_valid2_out_internal(i)='1') then

     jmp_scheduler_valid_out_internal(i)<='1';
   else
     jmp_scheduler_valid_out_internal(i)<='0';

   end if;

  else  
   
   if (jmp_valid1_out_internal(i)='1' and jmp_valid2_out_internal(i)='1') then--BEQ and JLR instr

     jmp_scheduler_valid_out_internal(i)<='1';
   else
     jmp_scheduler_valid_out_internal(i)<='0';

   end if;

  end if;  

 else

  jmp_scheduler_valid_out_internal(i)<='0';
 end if;

end loop;  



end process;



process (reset_system,clk_input,stall_reservation_update,halt_out_internal,self2_tag_in) --used to drive branch1_done,branch2_done and branch3_done


 
 begin

  if (reset_system='1') then

   branch1_done<='0';
   branch2_done<='0';
   --branch3_done<='0';

  elsif (clk_input'event and clk_input='1' and stall_reservation_update='0' and halt_out_internal='0') then
  
   if (op_code2_in="1100" or op_code2_in="1000" or op_code2_in="1001") then

    if (self2_tag_in="001") then
     branch1_done<='1';
     branch2_done<='0';
     --branch3_done<='0';
    elsif (self2_tag_in="010") then
     branch1_done<='0';
     branch2_done<='1';
     --branch3_done<='0';
    elsif (self2_tag_in="100") then
     branch1_done<='0';
     branch2_done<='0';
     --branch3_done<='1'; 

    else
     branch1_done<='0';
     branch2_done<='0';
     --branch3_done<='0';
    end if;
    
   else
    branch1_done<='0';
    branch2_done<='0';
    --branch3_done<='0';
   end if;
  end if;     



end process;




       jmp_instr_valid_out<=jmp_instr_valid_out_internal;
       jmp_op_code_out<=jmp_op_code_out_internal;
       --_op_code_cz_out:out slv2_array_t(0 to 9);
       jmp_destn_rename_code_out<=jmp_destn_rename_code_out_internal;
       jmp_operand1_out<=jmp_operand1_out_internal;
       jmp_valid1_out<=jmp_valid1_out_internal;

       jmp_operand2_out<=jmp_operand2_out_internal;
       jmp_valid2_out<=jmp_valid2_out_internal;


       jmp_operand3_out<=jmp_operand3_out_internal;
       jmp_valid3_out<=jmp_valid3_out_internal;

       --ls_operand3_out:out slv16_array_t(0 to 9);
       --ls_valid3_out:out slv_array_t(0 to 9);

       --alu_c_flag_out:out slv_array_t(0 to 9);
       --alu_c_flag_rename_out:out slv3_array_t(0 to 9);
       --alu_c_flag_valid_out:out slv_array_t(0 to 9);

       --alu_z_flag_out:out slv_array_t(0 to 9);
       --alu_z_flag_rename_out:out slv3_array_t(0 to 9);
       --alu_z_flag_valid_out:out slv_array_t(0 to 9);

       --ls_scheduler_valid_out:out slv_array_t(0 to 9);

       jmp_btag_out<=jmp_btag_out_internal;

       jmp_orign_destn_out<=jmp_orign_destn_out_internal;

       jmp_curr_pc_out<=jmp_curr_pc_out_internal;
       --ls_imm_out:out slv16_array_t(0 to 9);


       jmp_scheduler_valid_out<=jmp_scheduler_valid_out_internal;
       jmp_next_pc_out<=jmp_next_pc_out_internal;

       jmp_self_tag_out<=jmp_self_tag_out_internal;
 





 ls_instr_valid_out<=ls_instr_valid_out_internal;
 ls_op_code_out<=ls_op_code_out_internal;
       --_op_code_cz_out:out slv2_array_t(0 to 9);
 ls_destn_rename_code_out<=ls_destn_rename_code_out_internal;
 ls_operand1_out<=ls_operand1_out_internal;
 ls_valid1_out<=ls_valid1_out_internal;

 ls_operand2_out<=ls_operand2_out_internal;
 ls_valid2_out<= ls_valid2_out_internal;

 ls_operand3_out<=ls_operand3_out_internal;
 ls_valid3_out<= ls_valid3_out_internal; 

       
 ls_scheduler_valid_out<= ls_scheduler_valid_out_internal;

 ls_btag_out<=ls_btag_out_internal;

 ls_orign_destn_out<=ls_orign_destn_out_internal;

 --ls_imm_out<ls_imm_out_internal;
 ls_curr_pc_out<=ls_curr_pc_out_internal;



curr_instr1_valid_rob_out<=instr1_valid_in;
curr_pc1_rob_out<=curr_pc1_in;
destn_code1_rob_out<=opr3_code1_in;
op_code1_rob_out<=op_code1_in;
destn_rename1_rob_out<=first_free_rename(0);
destn_rename_c1_rob_out<=first_free_rename_carry(0);
destn_rename_z1_rob_out<=first_free_rename_zero(0);
destn_btag1_rob_out<=btag1_in;
destn_self_tag1_rob_out<=self1_tag_in;



curr_instr2_valid_rob_out<=instr2_valid_in;
curr_pc2_rob_out<=curr_pc2_in;
destn_code2_rob_out<=opr3_code2_in;
op_code2_rob_out<=op_code2_in;
destn_rename2_rob_out<=first_free_rename(1);
destn_rename_c2_rob_out<=first_free_rename_carry(1);
destn_rename_z2_rob_out<=first_free_rename_zero(1);
destn_btag2_rob_out<=btag2_in;
destn_self_tag2_rob_out<=self2_tag_in;




 






 


alu_instr_valid_out<=alu_instr_valid_out_internal;--drives the valid bit of RS entry for alu

--alu_instr_valid_out<=alu_instr_valid_out_internal
alu_op_code_out<=alu_op_code_out_internal;
alu_op_code_cz_out<=alu_op_code_cz_out_internal;
alu_destn_rename_code_out<=alu_destn_rename_code_out_internal;
alu_operand1_out<=alu_operand1_out_internal;
alu_valid1_out<=alu_valid1_out_internal;                   ---all these refer to signals which drive the register

alu_operand2_out<=alu_operand2_out_internal;
alu_valid2_out<=alu_valid2_out_internal;

alu_operand3_out<=alu_operand3_out_internal;
alu_valid3_out<=alu_valid3_out_internal;

alu_c_flag_out<=alu_c_flag_out_internal;
alu_c_flag_rename_out<=alu_c_flag_rename_out_internal;
alu_c_flag_valid_out<=alu_c_flag_valid_out_internal;
alu_c_flag_destn_addr_out<=alu_c_flag_destn_addr_out_internal;

alu_z_flag_out<=alu_z_flag_out_internal;
alu_z_flag_rename_out<=alu_z_flag_rename_out_internal;
alu_z_flag_valid_out<=alu_z_flag_valid_out_internal;
alu_z_flag_destn_addr_out<=alu_z_flag_destn_addr_out_internal;

alu_scheduler_valid_out<=alu_scheduler_valid_out_internal;

alu_btag_out<=alu_btag_out_internal;

alu_orign_destn_out<=alu_orign_destn_out_internal;

alu_curr_pc_out<=alu_curr_pc_out_internal;



-----RRF and zero flag and carry modification


arf_rename_valid_out <= arf_rename_valid;-- not required if value is valid rename cannot be valid
--signal arf_reg_name:array(0 to 29) of std_logic_vector(2 downto 0);
arf_reg_rename_out <= arf_reg_rename;
arf_reg_value_out <= arf_reg_value;--refers to value stored 
arf_value_valid_out <= arf_value_valid;
free_reg_out <= free_reg;--denotes which rename registers are free 


carry_value_valid_out <= carry_value_valid;
zero_value_valid_out <= zero_value_valid;

carry_value_out <= carry_value;
zero_value_out <= zero_value;



carry_rename_rf_out <= carry_rename_rf;--stores to which rename carry flag is currently renamed
zero_rename_rf_out <= zero_rename_rf; --stores to which rename zero flag is currently renamed

free_flag_zero_out <= free_flag_zero;-- whether 2 zero registers are free
free_flag_carry_out <= free_flag_carry;--whether 2 carry registers are free

free_rename_carry_out <= free_rename_carry;--which of 7 rename carry flags are free
free_rename_zero_out <= free_rename_zero;--which of 7 rename zero flags are free












 

halt_out<=halt_out_internal;
   

	
end architecture reservation_process;