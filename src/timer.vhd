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
    type state_type is (S0, S1);
	signal ready, is_done : std_logic := '0';
	signal count : std_logic_vector(3 downto 0) := "0000";
	signal state : state_type := S0;
begin
	process(clk, en, tgt)
	begin
		if en = '1' then
			if clk = '1' and clk'event then
				case state is
					when S0 =>
								count <= tgt;
								is_done <= '0';
								state <= S1;
					when S1 =>
								if count = "0000" or tgt = "0000" then
									count <= tgt;
									is_done <= '1';
								end if;
				end case;
			elsif clk='0' and clk'event then
				if count /= "0000" then
					is_done <= '0';
					count <= std_logic_vector(unsigned(count) - 1);
				end if;
			end if;
		else
			state <= S0;
			is_done <= '0';
		end if;
	end process;

	status <= is_done;
end Behavorial;
