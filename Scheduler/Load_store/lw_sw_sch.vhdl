library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pkg is
	type slv_array_t is array (natural range <>) of std_logic;
	type slv3_array_t is array (natural range <>) of std_logic_vector(2 downto 0);
	type slv4_array_t is array (natural range <>) of std_logic_vector(3 downto 0);
	type slv6_array_t is array (natural range <>) of std_logic_vector(5 downto 0);
	type slv8_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
	type slv16_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
end package ; -- pkg 

package body pkg is
end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.pkg.all;

entity lw_sw_sch is
	port (	clk: in std_logic;
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
end entity ; -- lw_sw_sch

architecture arch of lw_sw_sch is
 

begin

rs_ls_out : process(ls_instr_valid_in,ls_sch_valid_in,ls_stall_in)

begin

	if (ls_stall_in = '1') then
		
		rs_ls_index_out <= std_logic_vector(to_unsigned(0,rs_ls_index_out'length));
		rs_ls_valid_out <= '0';
	
	else
		
		if (ls_instr_valid_in(0) = '1' and ls_sch_valid_in(0) = '1') then

			rs_ls_index_out <= std_logic_vector(to_unsigned(0,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(1) = '1' and ls_sch_valid_in(1) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(1,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(2) = '1' and ls_sch_valid_in(2) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(2,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(3) = '1' and ls_sch_valid_in(3) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(3,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(4) = '1' and ls_sch_valid_in(4) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(4,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(5) = '1' and ls_sch_valid_in(5) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(5,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(6) = '1' and ls_sch_valid_in(6) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(6,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(7) = '1' and ls_sch_valid_in(7) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(7,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(8) = '1' and ls_sch_valid_in(8) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(8,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		elsif (ls_instr_valid_in(9) = '1' and ls_sch_valid_in(9) = '1') then
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(9,rs_ls_index_out'length));
			rs_ls_valid_out <= '1';

		else
			
			rs_ls_index_out <= std_logic_vector(to_unsigned(0,rs_ls_index_out'length));
			rs_ls_valid_out <= '0';

		end if ;

	end if ;
	
end process ; -- rs_ls_out

Scheduler_load_store : process(clk,ls_stall_in,ls_instr_valid_in,ls_op_code_in,ls_original_dest_in,ls_rename_dest_in,ls_operand_1_in,ls_operand_2_in,ls_pc_in,ls_sch_valid_in,ls_btag_in)
	
	variable ls_instr_valid_var: slv_array_t(0 to 9);
	variable ls_op_code_var: slv4_array_t(0 to 9);
	variable ls_original_dest_var: slv3_array_t(0 to 9);
	variable ls_rename_dest_var: slv6_array_t(0 to 9);
	variable ls_operand_1_var: slv16_array_t(0 to 9);
	variable ls_operand_1_valid_var: slv_array_t(0 to 9);

	variable ls_operand_2_var: slv16_array_t(0 to 9);
	variable ls_operand_2_valid_var: slv_array_t(0 to 9);

	variable ls_operand_3_var: slv16_array_t(0 to 9);
	variable ls_operand_3_valid_var: slv_array_t(0 to 9);

	variable ls_pc_var: slv16_array_t(0 to 9);
	variable ls_sch_valid_var: slv_array_t(0 to 9);

	variable ls_btag_var: slv3_array_t(0 to 9);

	variable ls_instr_valid_out_var: std_logic;
	variable ls_op_code_out_var: std_logic_vector(3 downto 0);
	variable ls_original_dest_out_var: std_logic_vector(2 downto 0);
	variable ls_rename_dest_out_var: std_logic_vector(5 downto 0);
	variable ls_operand_1_out_var: std_logic_vector(15 downto 0);
	variable ls_operand_2_out_var: std_logic_vector(15 downto 0);
	variable ls_operand_3_out_var: std_logic_vector(15 downto 0);
	variable ls_pc_out_var: std_logic_vector(15 downto 0);
	variable ls_btag_out_var: std_logic_vector(2 downto 0);
	
begin
	
	if (clk'event and clk = '1') then
		ls_instr_valid_var := ls_instr_valid_in;
		ls_op_code_var:= ls_op_code_in;
		ls_original_dest_var:= ls_original_dest_in;
		ls_rename_dest_var:= ls_rename_dest_in;
		ls_operand_1_var:= ls_operand_1_in;
		ls_operand_1_valid_var:= ls_operand_1_valid_in;
		ls_operand_2_var:= ls_operand_2_in;
		ls_operand_2_valid_var:= ls_operand_2_valid_in;
		ls_operand_3_var:= ls_operand_3_in;
		ls_operand_3_valid_var:= ls_operand_3_valid_in;
		ls_pc_var:= ls_pc_in;
		ls_sch_valid_var:= ls_sch_valid_in;
		ls_btag_var:= ls_btag_in;

		if (ls_stall_in = '1') then
			
			ls_instr_valid_out_var := '0';
		
		else
			
			if (ls_instr_valid_var(0) = '1' and ls_sch_valid_var(0) = '1') then

				ls_instr_valid_out_var := ls_instr_valid_var(0);
				ls_op_code_out_var := ls_op_code_var(0);
				ls_original_dest_out_var := ls_original_dest_var(0);
				ls_rename_dest_out_var := ls_rename_dest_var(0);
				ls_operand_1_out_var := ls_operand_1_var(0);
				ls_operand_2_out_var := ls_operand_2_var(0);
				ls_operand_3_out_var := ls_operand_3_var(0);
				ls_pc_out_var := ls_pc_var(0);
				ls_btag_out_var := ls_btag_var(0);
			
			elsif (ls_instr_valid_var(1) = '1' and ls_sch_valid_var(1) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(1);
				ls_op_code_out_var := ls_op_code_var(1);
				ls_original_dest_out_var := ls_original_dest_var(1);
				ls_rename_dest_out_var := ls_rename_dest_var(1);
				ls_operand_1_out_var := ls_operand_1_var(1);
				ls_operand_2_out_var := ls_operand_2_var(1);
				ls_operand_3_out_var := ls_operand_3_var(1);
				ls_pc_out_var := ls_pc_var(1);
				ls_btag_out_var := ls_btag_var(1);

			elsif (ls_instr_valid_var(2) = '1' and ls_sch_valid_var(2) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(2);
				ls_op_code_out_var := ls_op_code_var(2);
				ls_original_dest_out_var := ls_original_dest_var(2);
				ls_rename_dest_out_var := ls_rename_dest_var(2);
				ls_operand_1_out_var := ls_operand_1_var(2);
				ls_operand_2_out_var := ls_operand_2_var(2);
				ls_operand_3_out_var := ls_operand_3_var(2);
				ls_pc_out_var := ls_pc_var(2);
				ls_btag_out_var := ls_btag_var(2);

			elsif (ls_instr_valid_var(3) = '1' and ls_sch_valid_var(3) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(3);
				ls_op_code_out_var := ls_op_code_var(3);
				ls_original_dest_out_var := ls_original_dest_var(3);
				ls_rename_dest_out_var := ls_rename_dest_var(3);
				ls_operand_1_out_var := ls_operand_1_var(3);
				ls_operand_2_out_var := ls_operand_2_var(3);
				ls_operand_3_out_var := ls_operand_3_var(3);
				ls_pc_out_var := ls_pc_var(3);
				ls_btag_out_var := ls_btag_var(3);

			elsif (ls_instr_valid_var(4) = '1' and ls_sch_valid_var(4) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(4);
				ls_op_code_out_var := ls_op_code_var(4);
				ls_original_dest_out_var := ls_original_dest_var(4);
				ls_rename_dest_out_var := ls_rename_dest_var(4);
				ls_operand_1_out_var := ls_operand_1_var(4);
				ls_operand_2_out_var := ls_operand_2_var(4);
				ls_operand_3_out_var := ls_operand_3_var(4);
				ls_pc_out_var := ls_pc_var(4);
				ls_btag_out_var := ls_btag_var(4);

			elsif (ls_instr_valid_var(5) = '1' and ls_sch_valid_var(5) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(5);
				ls_op_code_out_var := ls_op_code_var(5);
				ls_original_dest_out_var := ls_original_dest_var(5);
				ls_rename_dest_out_var := ls_rename_dest_var(5);
				ls_operand_1_out_var := ls_operand_1_var(5);
				ls_operand_2_out_var := ls_operand_2_var(5);
				ls_operand_3_out_var := ls_operand_3_var(5);
				ls_pc_out_var := ls_pc_var(5);
				ls_btag_out_var := ls_btag_var(5);

			elsif (ls_instr_valid_var(6) = '1' and ls_sch_valid_var(6) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(6);
				ls_op_code_out_var := ls_op_code_var(6);
				ls_original_dest_out_var := ls_original_dest_var(6);
				ls_rename_dest_out_var := ls_rename_dest_var(6);
				ls_operand_1_out_var := ls_operand_1_var(6);
				ls_operand_2_out_var := ls_operand_2_var(6);
				ls_operand_3_out_var := ls_operand_3_var(6);
				ls_pc_out_var := ls_pc_var(6);
				ls_btag_out_var := ls_btag_var(6);

			elsif (ls_instr_valid_var(7) = '1' and ls_sch_valid_var(7) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(7);
				ls_op_code_out_var := ls_op_code_var(7);
				ls_original_dest_out_var := ls_original_dest_var(7);
				ls_rename_dest_out_var := ls_rename_dest_var(7);
				ls_operand_1_out_var := ls_operand_1_var(7);
				ls_operand_2_out_var := ls_operand_2_var(7);
				ls_operand_3_out_var := ls_operand_3_var(7);
				ls_pc_out_var := ls_pc_var(7);
				ls_btag_out_var := ls_btag_var(7);

			elsif (ls_instr_valid_var(8) = '1' and ls_sch_valid_var(8) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(8);
				ls_op_code_out_var := ls_op_code_var(8);
				ls_original_dest_out_var := ls_original_dest_var(8);
				ls_rename_dest_out_var := ls_rename_dest_var(8);
				ls_operand_1_out_var := ls_operand_1_var(8);
				ls_operand_2_out_var := ls_operand_2_var(8);
				ls_operand_3_out_var := ls_operand_3_var(8);
				ls_pc_out_var := ls_pc_var(8);
				ls_btag_out_var := ls_btag_var(8);

			elsif (ls_instr_valid_var(9) = '1' and ls_sch_valid_var(9) = '1') then
				
				ls_instr_valid_out_var := ls_instr_valid_var(9);
				ls_op_code_out_var := ls_op_code_var(9);
				ls_original_dest_out_var := ls_original_dest_var(9);
				ls_rename_dest_out_var := ls_rename_dest_var(9);
				ls_operand_1_out_var := ls_operand_1_var(9);
				ls_operand_2_out_var := ls_operand_2_var(9);
				ls_operand_3_out_var := ls_operand_3_var(9);
				ls_pc_out_var := ls_pc_var(9);
				ls_btag_out_var := ls_btag_var(9);
			else
				ls_instr_valid_out_var := '0';
			end if ;				

		end if ;

 		ls_instr_valid_out <= ls_instr_valid_out_var;
 		ls_op_code_out <= ls_op_code_out_var;
 		ls_original_dest_out <= ls_original_dest_out_var;
 		ls_rename_dest_out <= ls_rename_dest_out_var;
 		ls_operand_1_out <= ls_operand_1_out_var;
 		ls_operand_2_out <= ls_operand_2_out_var;
 		ls_operand_3_out <= ls_operand_3_out_var;
 		ls_pc_out <= ls_pc_out_var;
 		ls_btag_out <= ls_btag_out_var;
	end if ;



end process ; -- Scheduler_load_store

end architecture ; -- arch