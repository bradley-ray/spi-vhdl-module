library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg_out is
    Port (  load, shift : in std_logic;
            in_val : in std_logic_vector(7 downto 0);
            out_val : out std_logic
        );
end shift_reg_out;

architecture Behavorial of shift_reg_out is
    signal val : std_logic_vector(7 downto 0) := "00000000";
    signal outp : std_logic := '0';
begin
    process (load, shift)
    begin
        if load = '1' and load'event then
            val <= in_val;
        end if;
        if shift = '1' and shift'event then
            outp <= val(7);
            val <= val(6 downto 0) & '0';
        end if;
    end process;

    out_val <= outp;
end Behavorial;