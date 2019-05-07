library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_pc is
  port (
	PC_in: in std_logic_vector(15 downto 0);
	------------------------------------------------------------
	PC_out: out std_logic_vector(15 downto 0)
  ) ;
end entity ; -- add_pc

architecture arch of add_pc is

begin

adder : process(PC_in)
	variable value_2: unsigned(15 downto 0) := "0000000000000010";
	variable pc_out_var:unsigned(15 downto 0) := "0000000000000000";

begin
	pc_out_var := unsigned(PC_in) +  value_2;
	PC_out <= std_logic_vector(pc_out_var);
end process ; -- adder


end architecture ; -- arch