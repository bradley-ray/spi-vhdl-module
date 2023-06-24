library ieee;
use ieee.std_logic_1164.all;

entity timer_tb is
end timer_tb;

architecture Bench of timer_tb is
	component timer
		Port (	clk, en : in std_logic;
						tgt : std_logic_vector(3 downto 0);
						status : out std_logic
					);
	end component;

	signal clk, en, status_1, status_2, status_3, status_4 : std_logic := '0';
	signal tgt_1 : std_logic_vector(3 downto 0) := "1000";
	signal tgt_2 : std_logic_vector(3 downto 0) := "0100";
	signal tgt_3 : std_logic_vector(3 downto 0) := "0010";
	signal tgt_4 : std_logic_vector(3 downto 0) := "0001";

	constant clk_period : time := 100 ns;

begin
	tim_1: timer port map (clk, en, tgt_1, status_1);
	tim_2: timer port map (clk, en, tgt_2, status_2);
	tim_3: timer port map (clk, en, tgt_3, status_3);
	tim_4: timer port map (clk, en, tgt_4, status_4);

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
		wait;
	end process;
	
end Bench;
