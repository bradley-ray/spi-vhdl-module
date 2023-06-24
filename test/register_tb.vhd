library ieee;
use ieee.std_logic_1164.all;

entity reg_tb is
end reg_tb;


architecture Bench of reg_tb is
	component reg is
		Port (	clk, rst, w : in std_logic;
				data_in : in std_logic_vector(7 downto 0);
				data_ready : out std_logic;
				data_out : out std_logic_vector(7 downto 0)
			);
	end component;

	signal clk, rst, w, data_ready : std_logic := '0';
	signal data_in, data_out : std_logic_vector(7 downto 0) := "00000000";

	constant clk_period : time := 100 ns;

begin
	reg_1: reg port map (clk, rst, w, data_in, data_ready, data_out);

	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	process
	begin
		rst <= '1';
		wait for clk_period*2;
		rst <= '0';
		data_in <= "01101011";
		w <= '1';
		wait for clk_period;
		rst <= '1';
		wait;
	end process;
end Bench;
