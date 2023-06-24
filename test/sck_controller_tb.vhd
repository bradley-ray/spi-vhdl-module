library ieee;
use ieee.std_logic_1164.all;

entity sck_controller_tb is
end sck_controller_tb;

architecture Bench of sck_controller_tb is
    component sck_controller is
        Port (  clk, en, cpol, cpha, start : in std_logic;
                div : in std_logic_vector(3 downto 0);
                sck_main : inout std_logic;
                sck_shift_reg, rx_ready : out std_logic
            );
    end component;

    signal clk, en : std_logic := '0';
    signal cpol_1, cpha_1, start_1, sck_main_1, sck_shift_reg_1, rx_ready_1 : std_logic := '0';
    signal cpol_2, cpha_2, start_2, sck_main_2, sck_shift_reg_2, rx_ready_2 : std_logic := '0';
    signal cpol_3, cpha_3, start_3, sck_main_3, sck_shift_reg_3, rx_ready_3 : std_logic := '0';
    signal cpol_4, cpha_4, start_4, sck_main_4, sck_shift_reg_4, rx_ready_4 : std_logic := '0';

    signal div_1 : std_logic_vector(3 downto 0) := "0010";
    signal div_2 : std_logic_vector(3 downto 0) := "0010";
    signal div_3 : std_logic_vector(3 downto 0) := "0010";
    signal div_4 : std_logic_vector(3 downto 0) := "0010";

    constant clk_period : time := 100 ns;
begin
    sck_control_1: sck_controller port map (clk, en, cpol_1, cpha_1, start_1, div_1, sck_main_1, sck_shift_reg_1, rx_ready_1);
    sck_control_2: sck_controller port map (clk, en, cpol_2, cpha_2, start_2, div_2, sck_main_2, sck_shift_reg_2, rx_ready_2);
    sck_control_3: sck_controller port map (clk, en, cpol_3, cpha_3, start_3, div_3, sck_main_3, sck_shift_reg_3, rx_ready_3);
    sck_control_4: sck_controller port map (clk, en, cpol_4, cpha_4, start_4, div_4, sck_main_4, sck_shift_reg_4, rx_ready_4);

    process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    process
    begin
        wait for clk_period*5;
        en <= '1';
        cpol_1 <= '0';
        cpha_1 <= '0';
        cpol_2 <= '0';
        cpha_2 <= '1';
        cpol_3 <= '1';
        cpha_3 <= '0';
        cpol_4 <= '1';
        cpha_4 <= '1';
        wait for clk_period*5;
        start_1 <= '1';
        start_2 <= '1';
        start_3 <= '1';
        start_4 <= '1';
        wait for clk_period*5;
        start_1 <= '0';
        start_2 <= '0';
        start_3 <= '0';
        start_4 <= '0';
        wait for clk_period*40;
        start_1 <= '1';
        start_2 <= '1';
        start_3 <= '1';
        start_4 <= '1';
        wait for clk_period*5;
        wait;
    end process;
end Bench;