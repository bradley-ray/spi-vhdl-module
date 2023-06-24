library ieee;
use ieee.std_logic_1164.all;

entity clock_divider_tb is
end clock_divider_tb;


architecture Bench of clock_divider_tb is
	component clock_divider
		Port (	clk, en : in std_logic;
				div : in std_logic_vector(3 downto 0);
				clk_out : out std_logic
			);
	end component;

	signal clk, en, clk_1_out, clk_2_out, clk_3_out, clk_4_out : std_logic := '0';

	constant clk_period : time := 100 ns;

begin
	tim_1: clock_divider port map (clk, en, "1000", clk_1_out);
	tim_2: clock_divider port map (clk, en, "0100", clk_2_out);
	tim_3: clock_divider port map (clk, en, "0010", clk_3_out);
	tim_4: clock_divider port map (clk, en, "0001", clk_4_out);

	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	process
	begin
		en <= '0';
		wait for clk_period*5;
		en <= '1';
		wait for clk_period*20;
		en <= '0';
		wait for clk_period*10;
		en <= '1';
		wait;
	end process;
end Bench;
