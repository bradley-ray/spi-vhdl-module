library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg_in is
    Port (  load, shift, in_val : in std_logic;
            out_val : out std_logic_vector(7 downto 0)
        );
end shift_reg_in;

architecture Behavorial of shift_reg_in is
    signal val : std_logic_vector(7 downto 0) := "00000000";
begin
    process (shift)
    begin
        if shift = '1' and shift'event then
            val <= val(6 downto 0) & in_val;
        end if;
    end process;

    process (load)
    begin
        if load = '1' and load'event then
            out_val <= val;
        end if;
    end process;
end Behavorial;