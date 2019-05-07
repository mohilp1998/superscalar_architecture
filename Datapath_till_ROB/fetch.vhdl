library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is
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
  );
end entity ; -- fetch

architecture arch of fetch is

begin

Fetch_Register : process(clk,Mem_in,PC_in)

	variable constant_1 : std_logic := '1';

begin

if (clk'event and clk = '1') then
	
	if (stall_in = '1') then
		
		if (instr_invalidate_in = '1') then 
			inst_1_valid <= '0';
			inst_2_valid <= '0';
		else
			
		end if ;
	else
		
		if (instr_invalidate_in = '1') then
			inst_1_valid <= '0';
			inst_2_valid <= '0';   --changed tonight by Sahasrajit
			PC <= PC_in;
			inst_1_valid <= constant_1;
			inst_2_valid <= constant_1;

		else
			Instr1 <= Mem_in(31 downto 16);
			Instr2 <= Mem_in(15 downto 0);
			PC <= PC_in;
			inst_1_valid <= constant_1;
			inst_2_valid <= constant_1;
		end if ;

	end if ;	
end if ;

	
end process ; -- Fetch_Register

end architecture ; -- arch