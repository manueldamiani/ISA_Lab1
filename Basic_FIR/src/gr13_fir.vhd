library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity gr13_fir is
	port( b: in std_logic_vector(0 to ((NB*NT)-1));
		  DIN: in std_logic_vector(NB-1 downto 0);
		  VIN: in std_logic;
		  RST_n: in std_logic;
		  CLK: in std_logic;
		  DOUT: out std_logic_vector(NB-1 downto 0);
		  VOUT: out std_logic);
end gr13_fir;

architecture bhv of gr13_fir is

	type regarray is array (0 to NT-1) of std_logic_vector(NB-1 downto 0);
	type mularray is array (0 to NT-1) of std_logic_vector(2*NB-1 downto 0); -- extended to allow for overflow handling

	signal datain: std_logic_vector(NB-1 downto 0);
	signal regs: regarray;
	signal muls: mularray;

begin

	datain <= DIN;

	-- We need to create a pipeline for the incoming data
	-- then each one is multiplied by one of the bi coefficients
	-- and we sum them all

	data_proc: process(CLK, RST_n)
	variable sum: std_logic_vector(2*nb-1 downto 0) := (others => '0'); -- variable to store the sum of the values stored in the muls array
	begin
		if(RST_n = '0') then
			regs <= (others => (others => '0'));
			sum := (others => '0');
			VOUT <= '0';

		elsif(CLK = '1' AND CLK'event) then
			if(VIN = '1') then
				sum := (others => '0'); -- reset the sum
		
				gen_sum: for j in 0 to NT-1 loop
					sum := sum + muls(j); -- sum of the values stored in the muls array
				end loop gen_sum;

				shift_regs: for i in 1 to NT-1 loop -- shift by one position the inputs in the regarray
						regs(i) <= regs(i-1);
				end loop shift_regs;

				regs(0) <= datain; -- introduce the new data input in the regarray

				-- resize on 11 bits, shifting right by NB-1 positions
				DOUT <= sum(2*NB-2 downto NB-1);
				VOUT <= '1';
			end if;
		end if;
	end process data_proc;

	-- Each input data is multiplied by the b coefficient
	-- and the result is stored in the muls array
	gen_mul: for j in 0 to NT-1 generate
		muls(j) <= b(j*11 to (j*11)+10) * regs(j);
	end generate gen_mul;

end architecture bhv;
