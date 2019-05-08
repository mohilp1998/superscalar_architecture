library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
	port(a1, a2, a3:in std_logic_vector(2 downto 0); 
		clk,we_rf,reset:in std_logic;
		d3: in std_logic_vector(15 downto 0); 
		d1, d2, r0, r1, r2, r3, r4, r5, r6, r7:out std_logic_vector(15 downto 0));
end entity RF;

architecture behave of RF is

type registerfile is array(0 to 7) of std_logic_vector(15 downto 0);

signal rf:registerfile:=(others=>(others=>'0'));

begin
d1 <= rf(to_integer(unsigned(a1)));
d2 <= rf(to_integer(unsigned(a2)));

r0 <= rf(0);
r1 <= rf(1);
r2 <= rf(2);
r3 <= rf(3);
r4 <= rf(4);
r5 <= rf(5);
r6 <= rf(6);
r7 <= rf(7);

RF_write:process(clk,reset)
begin 
	
	if (reset='1') then
	
	 rf(0) <=(others => '0');
	 rf(1) <=(others => '0');
	 rf(2) <=(others =>'0');
	 rf(3) <=(others => '0');
	 rf(4) <= (others => '0');
	 rf(5) <= (others => '0');
	 rf(6) <= (others => '0');
	 rf(7) <= (others => '0');
	
	elsif(clk'event and clk = '1') then
		
		if (we_rf = '1') then
		 	rf(to_integer(unsigned(a3))) <= d3;
		end if ;

	end if;
end process;

end behave;