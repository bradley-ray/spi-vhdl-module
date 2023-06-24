library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
	Port (	clk, en : in std_logic;
			tgt : in std_logic_vector(3 downto 0);
			status : out std_logic
		);
end timer;

-- generates a pulse after 'tgt' clock cycles
architecture Behavorial of timer is	
	signal is_done : std_logic := '0';
	signal count : std_logic_vector(3 downto 0) := "0000";
begin
	process(clk, tgt)
	begin
		if clk = '1' and clk'event then
			if en = '1' then
				if count = "0000" or tgt = "0000" then
					is_done <= '1';
					count <= tgt;
				end if;
			else
				count <= "0000";
				is_done <= '0';
			end if;
		elsif clk='0' and clk'event then
			if en = '1' and count /= "0000" then
				is_done <= '0';
				count <= std_logic_vector(unsigned(count) - 1);
			end if;
		end if;
	end process;

	status <= is_done;
end Behavorial;
