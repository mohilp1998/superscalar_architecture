library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity c_reg is
  port 
  (
	clk : in std_logic;
	reset: in std_logic;
	c_data_in: in std_logic;
	c_valid: in std_logic;
	c_data_out: out std_logic
  );
end entity ; -- c_reg

architecture arch of c_reg is
	signal c_data_signal: std_logic;
begin

C_reg : process(clk,c_data_in,c_valid,reset)

begin
	if (clk'event and clk = '1') then
		if (reset = '1') then
			c_data_signal <= '0';
		else
			if (c_valid = '1') then
				c_data_signal <= c_data_in;
			end if ;
		end if ;
	end if ;
end process ; -- C_reg
c_data_out <= c_data_signal;

end architecture ; -- arch