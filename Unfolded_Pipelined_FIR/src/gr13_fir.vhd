library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use WORK.constants.all;

entity gr13_fir is
	port( b: in std_logic_vector(0 to ((NB*NT)-1));
		  DIN0: in std_logic_vector(NB-1 downto 0);
		  DIN1: in std_logic_vector(NB-1 downto 0);
		  DIN2: in std_logic_vector(NB-1 downto 0);
		  VIN: in std_logic;
		  RST_n: in std_logic;
		  CLK: in std_logic;
		  DOUT0: out std_logic_vector(NB-1 downto 0);
		  DOUT1: out std_logic_vector(NB-1 downto 0);
		  DOUT2: out std_logic_vector(NB-1 downto 0);
		  VOUT: out std_logic);
end gr13_fir;

architecture bhv of gr13_fir is

	component regn
	port( D: in std_logic_vector(2*NB-1 downto 0);
	      CLK: in std_logic;
	      RST: in std_logic;
	      Q: out std_logic_vector(2*NB-1 downto 0));
	end component;

	type regarray2 is array (0 to L+1) of std_logic_vector(NB-1 downto 0);
	type regarray is array (0 to L) of std_logic_vector(NB-1 downto 0);
	type mularray is array (0 to NT-1) of std_logic_vector(2*NB-1 downto 0); -- extended to allow for overflow handling

	signal regs0: regarray;
	signal regs1: regarray;
	signal regs2: regarray2;

	signal muls0: mularray;
	signal muls1: mularray;
	signal muls2: mularray;

	signal mulregout0 : mularray;
	signal mulregout1 : mularray;
	signal mulregout2 : mularray;

begin

	muls0(0) <= b(0 to 10)*regs0(0); r00:regn port map(D =>muls0(0),CLK=>CLK,RST=>RST_n,Q=>mulregout0(0));
	
	muls1(0) <= b(0 to 10)*regs1(0); r10:regn port map(D =>muls1(0),CLK=>CLK,RST=>RST_n,Q=>mulregout1(0));
	muls1(1) <= b(11 to 21)*regs0(0); r11:regn port map(D =>muls1(1),CLK=>CLK,RST=>RST_n,Q=>mulregout1(1));
	
	muls2(0) <= b(0 to 10)*regs2(0); r20:regn port map(D =>muls2(0),CLK=>CLK,RST=>RST_n,Q=>mulregout2(0));
	muls2(1) <= b(11 to 21)*regs1(0); r21:regn port map(D =>muls2(1),CLK=>CLK,RST=>RST_n,Q=>mulregout2(1));
	muls2(2) <= b(22 to 32)*regs0(0); r22:regn port map(D =>muls2(2),CLK=>CLK,RST=>RST_n,Q=>mulregout2(2));	

	MULGEN : FOR j IN 0 to L GENERATE

		muls0(L*j+1) <= b((L*j+1)*11 to ((L*j+1)*11)+10)*regs2(j+1); r01:regn port map(D =>muls0(L*j+1),CLK=>CLK,RST=>RST_n,Q=>mulregout0(L*j+1));
		J1COND : IF (L*j+2 <= NT-1) GENERATE
	
			muls1(L*j+2) <= b((L*j+2)*11 to ((L*j+2)*11)+10)*regs2(j+1); r12:regn port map(D =>muls1(L*j+2),CLK=>CLK,RST=>RST_n,Q=>mulregout1(L*j+2));
			muls0(L*j+2) <= b((L*j+2)*11 to ((L*j+2)*11)+10)*regs1(j+1); r02:regn port map(D =>muls0(L*j+2),CLK=>CLK,RST=>RST_n,Q=>mulregout0(L*j+2));
			
			muls2(L*j+3) <= b((L*j+3)*11 to ((L*j+3)*11)+10)*regs2(j+1); r23:regn port map(D =>muls2(L*j+3),CLK=>CLK,RST=>RST_n,Q=>mulregout2(L*j+3));
			muls1(L*j+3) <= b((L*j+3)*11 to ((L*j+3)*11)+10)*regs1(j+1); r13:regn port map(D =>muls1(L*j+3),CLK=>CLK,RST=>RST_n,Q=>mulregout1(L*j+3));
			muls0(L*j+3) <= b((L*j+3)*11 to ((L*j+3)*11)+10)*regs0(j+1); r03:regn port map(D =>muls0(L*j+3),CLK=>CLK,RST=>RST_n,Q=>mulregout0(L*j+3)); 
				
			muls2(L*j+4) <= b((L*j+4)*11 to ((L*j+4)*11)+10)*regs1(j+1); r24:regn port map(D =>muls2(L*j+4),CLK=>CLK,RST=>RST_n,Q=>mulregout2(L*j+4));
			muls1(L*j+4) <= b((L*j+4)*11 to ((L*j+4)*11)+10)*regs0(j+1); r14:regn port map(D =>muls1(L*j+4),CLK=>CLK,RST=>RST_n,Q=>mulregout1(L*j+4));	
			J4COND : IF (L*j+5 <= NT-1) GENERATE
				muls2(L*j+5) <= b((L*j+5)*11 to ((L*j+5)*11)+10)*regs0(j+1); r25:regn port map(D =>muls2(L*j+5),CLK=>CLK,RST=>RST_n,Q=>mulregout2(L*j+5));	
			END GENERATE J4COND;
		END GENERATE J1COND;						
	END GENERATE MULGEN;

	
data_proc: process(CLK, RST_n)
	variable sum0: std_logic_vector(2*nb-1 downto 0) := (others => '0'); -- variable to store the sum of the values stored in the muls array
	variable sum1: std_logic_vector(2*nb-1 downto 0) := (others => '0'); -- variable to store the sum of the values stored in the muls array
	variable sum2: std_logic_vector(2*nb-1 downto 0) := (others => '0'); -- variable to store the sum of the values stored in the muls array
	
	
	begin
		if(RST_n = '0') then
			regs0 <= (others => (others => '0'));
			regs1 <= (others => (others => '0'));
			regs2 <= (others => (others => '0'));
			sum0 := (others => '0');
			sum1 := (others => '0');
			sum2 := (others => '0');
					
			VOUT <= '0';

		elsif(CLK = '1' AND CLK'event) then
			if(VIN = '1') then
				sum0 := (others => '0');
				sum1 := (others => '0');
				sum2 := (others => '0'); -- reset the sum
				
				gen_sum: for k in 0 to NT-1 loop
					sum0 := sum0 + mulregout0(k); -- sum of the values stored in the muls array
					sum1 := sum1 + mulregout1(k); -- sum of the values stored in the muls array
					sum2 := sum2 + mulregout2(k); -- sum of the values stored in the muls array
				end loop gen_sum;

				shift_regs: for l in 1 to L loop -- shift by one position the inputs in the regarray
					regs0(l) <= regs0(l-1);
					regs1(l) <= regs1(l-1);
				end loop shift_regs;

				shift_regs2: for l in 1 to L+1 loop -- shift by one position the inputs in the regarray
					regs2(l) <= regs2(l-1);
				end loop shift_regs2;

				regs0(0) <= DIN0; -- introduce the new data input in the regarray
				regs1(0) <= DIN1; -- introduce the new data input in the regarray
				regs2(0) <= DIN2; -- introduce the new data input in the regarray

				-- resize on 11 bits, shifting right by NB-1 positions
				DOUT0 <= sum0(2*NB-2 downto NB-1);
				DOUT1 <= sum1(2*NB-2 downto NB-1);
				DOUT2 <= sum2(2*NB-2 downto NB-1);
				VOUT <= '1';
			end if;
		end if;
	end process data_proc;
end architecture bhv;
