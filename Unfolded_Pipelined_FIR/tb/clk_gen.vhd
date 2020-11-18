library ieee;
use ieee.std_logic_1164.all;

entity clk_gen is
	port( CLK: out std_logic;
		  RST: out std_logic;
		END_SIM : in std_logic);
end clk_gen;

architecture bhv of clk_gen is

	constant Ts: time := 10 ns;
	signal CLK_i: std_logic;

begin
	
	process
	begin
		if(CLK_i = 'U') then
			CLK_i <= '0';
		else
			CLK_i <= not(CLK_i);
		end if;
		wait for Ts/2;
	end process;

	CLK <= CLK_i and not(END_SIM);

	process
	begin
		RST <= '0';
		wait for 3*Ts/2;
		RST <= '1';
		wait for 3*Ts;
		RST <= '0';
		wait for Ts;
		RST <= '1';
		wait;
	end process;

end bhv;
