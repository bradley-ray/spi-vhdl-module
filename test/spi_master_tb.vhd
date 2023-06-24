library ieee;
use ieee.std_logic_1164.all;

entity spi_master_tb is
end spi_master_tb;

architecture Bench of spi_master_tb is
    component spi_master is
        Port (  clk, en, cpol, cpha, miso : in std_logic;
                div : in std_logic_vector(3 downto 0);
                tx_val : in std_logic_vector(7 downto 0);
                rx_val : out std_logic_vector(7 downto 0);
                sck, mosi : out std_logic
            );
    end component;

    signal clk, en, cpol, cpha, miso : std_logic := '0';
    signal div : std_logic_vector(3 downto 0) := "0000";
    signal tx_val, rx_val : std_logic_vector(7 downto 0) := "00000000";
    signal sck, mosi : std_logic := '0';


    constant clk_period : time := 100 ns;

begin
    master: spi_master port map (clk, en, cpol, cpha, miso, div, tx_val, rx_val, sck, mosi);

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
        div <= "0010";
        tx_val <= "01101111";
        cpol <= '1';
        cpha <= '1';
        wait for clk_period*5;
        en <= '1';
        wait;
    end process;


end Bench;