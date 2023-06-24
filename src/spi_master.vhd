library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
    Port (  clk, en, cpol, cpha, miso : in std_logic;
            div : in std_logic_vector(3 downto 0);
            tx_val : in std_logic_vector(7 downto 0);
            rx_val : out std_logic_vector(7 downto 0);
            sck, mosi : out std_logic
        );
end entity;

architecture RTL of spi_master is
    component shift_reg_out is
        Port (  load, shift : in std_logic;
                in_val : in std_logic_vector(7 downto 0);
                out_val : out std_logic
            );
    end component;

    component shift_reg_in is
        Port (  load, shift, in_val : in std_logic;
                out_val : out std_logic_vector(7 downto 0)
            );
    end component;

    component reg is
        Port (	clk, rst, w : in std_logic;
                data_in : in std_logic_vector(7 downto 0);
                data_ready : out std_logic;
                data_out : out std_logic_vector(7 downto 0)
            );
    end component;

    component sck_controller is
        Port (  clk, en, cpol, cpha, start : in std_logic;
                div : in std_logic_vector(3 downto 0);
                sck_main : out std_logic;
                sck_shift_reg, rx_ready : out std_logic
            );
    end component;

    signal sck_main, shift_reg_clk : std_logic;

    signal tx_reg_rst, tx_reg_w, tx_ready : std_logic := '0';
    signal tx_reg_in, tx_reg_out : std_logic_vector(7 downto 0) := "00000000";

    signal rx_reg_rst, rx_reg_w, rx_ready : std_logic := '0';
    signal rx_reg_in, rx_reg_out : std_logic_vector(7 downto 0) := "00000000";

    signal rx_shift_ready : std_logic := '0';

    signal sreg_shift, tx_sreg_load, rx_sreg_load : std_logic := '0';
    signal rx_sreg_in : std_logic := '0';
    signal tx_sreg_out : std_logic_vector(7 downto 0) := "00000000";
begin
    tx_reg: reg port map(clk, tx_reg_rst, tx_reg_w, tx_reg_in, tx_ready, tx_reg_out);
    tx_sreg: shift_reg_out port map(tx_sreg_load, sreg_shift, tx_reg_out, mosi);

    rx_reg: reg port map(clk, rx_reg_rst, rx_reg_w, rx_reg_in, rx_ready, rx_reg_out);
    rx_sreg: shift_reg_in port map(rx_sreg_load, sreg_shift, rx_sreg_in, rx_reg_in);

    sck_ctrl: sck_controller port map(clk, en, cpol, cpha, tx_ready, div, sck_main, sreg_shift, rx_shift_ready);

    process (en, tx_val)
    begin
        if en = '0' then
            tx_reg_w <= '1';
            tx_reg_in <= tx_val;
        else
            tx_reg_w <= '0';
        end if;
    end process;

    process (tx_ready, rx_shift_ready)
    begin
        -- if tx_ready, load to shift reg and rst
        if tx_ready = '1' and tx_ready'event then
            tx_sreg_load <= '1';
            tx_reg_rst <= '1';
        else
            tx_sreg_load <= '0';
            tx_reg_rst <= '0';
        end if;
        -- if rx_shift_ready, load from shift reg
        if rx_shift_ready = '1' and rx_shift_ready'event then
            rx_reg_rst <= '0';
            rx_reg_w <= '1';
            rx_sreg_load <= '1';
        else
            rx_reg_rst <= '1';
            rx_reg_w <= '0';
            rx_sreg_load <= '0';
        end if;
    end process;

    sck <= sck_main;
    rx_sreg_in <= miso;
end RTL;