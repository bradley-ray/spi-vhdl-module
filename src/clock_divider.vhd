library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_divider is
		Port (	clk, en : in std_logic;
				div : in std_logic_vector(3 downto 0);
				clk_out : out std_logic
			);
end clock_divider;

-- generate output clock with period = clk_period / div
architecture Behavorial of clock_divider is
	component timer
		Port (	clk, en : in std_logic;
				tgt : in std_logic_vector(3 downto 0);
				status : out std_logic
			);
	end component;

	signal o_clk, ready : std_logic := '0';
	signal tgt : std_logic_vector(3 downto 0); 
begin
	clk_timer: timer port map(clk, en, tgt, ready);

	process (en, ready)
	begin
		if en = '1' then
			if ready = '1' and ready'event then
				o_clk <= not o_clk;
			end if;
		else
			o_clk <= '0';
		end if;
	end process;

	-- divide clock divisor by 2 to use for timer
	tgt <= '0' & div(3 downto 1);
	clk_out <= o_clk;
end Behavorial;
