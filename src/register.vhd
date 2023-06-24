library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	Port (	clk, rst, w : in std_logic;
			data_in : in std_logic_vector(7 downto 0);
			data_ready : out std_logic;
			data_out : out std_logic_vector(7 downto 0)
		);
end reg;

architecture Behavorial of reg is
	signal data : std_logic_vector(7 downto 0) := "00000000";
	signal ready : std_logic := '0';
begin
	process(clk, rst, w, data_in)
	begin
		if clk = '1' and clk'event then
			if rst = '1' then
				data <= "00000000";
				ready <= '0';
			elsif w = '1' then
				data <= data_in;
				ready <= '1';
			end if;
		end if;
	end process;

	data_ready <= ready;
	data_out <= data;
end Behavorial;
