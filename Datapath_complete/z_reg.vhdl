library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity z_reg is
  port 
  (
	clk : in std_logic;
	reset: in std_logic;
	z_data_in: in std_logic;
	z_valid: in std_logic;
	z_data_out: out std_logic
  );
end entity ; -- z_reg

architecture arch of z_reg is
	signal z_data_signal: std_logic;
begin

Z_REG : process(clk,z_data_in,z_valid,reset)

begin
	if (clk'event and clk = '1') then
		if (reset = '1') then
			z_data_signal <= '0';
		else
			if (z_valid = '1') then
				z_data_signal <= z_data_in;
			end if ;
		end if ;
	end if ;
end process ; -- z_reg
z_data_out <= z_data_signal;

end architecture ; -- arch