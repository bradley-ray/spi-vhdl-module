library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sck_controller is
    Port (  clk, en, cpol, cpha, start : in std_logic;
            div : in std_logic_vector(3 downto 0);
            sck_main : out std_logic;
            sck_shift_reg, rx_ready : out std_logic
        );
end sck_controller;

architecture Behavorial of sck_controller is
    type state_type is (S0, S1, S2, S3);

    component timer is
        Port (	clk, en : in std_logic;
                tgt : in std_logic_vector(3 downto 0);
                status : out std_logic
            );
    end component;

    component clock_divider is
            Port (	clk, en : in std_logic;
                    div : in std_logic_vector(3 downto 0);
                    clk_out : out std_logic
                );
    end component;

    signal div_clk : std_logic := '0';
    signal bit_tim_en, bit_tim_clk, bit_tim_done : std_logic := '0';
    signal shift_reg_clk, shift_en : std_logic := '0';
    signal sck_clk : std_logic := cpol;

    -- TODO: this is for debugging, remember to remove
    signal num : std_logic_vector(3 downto 0) := "0010";
    signal num_2 : std_logic_vector(3 downto 0) := "0010";

    signal state : state_type := S2;

begin
    clk_divider: clock_divider port map (clk, en, div, div_clk);
    bit_timer: timer port map (bit_tim_clk, bit_tim_en, "0111", bit_tim_done);

    process(start, bit_tim_done, div_clk)
    begin
        if start = '1' and start'event then
            num_2 <= "0100";
            state <= S0;
        elsif bit_tim_done <= '1' and bit_tim_done'event then
            num_2 <= "0101";
            state <= S2;
        end if;

        case state is
            when S0 => -- init
                        num <= "0000";
                        if div_clk = '0' and div_clk'event then
                            if cpha = '0' then
                                state <= S3;
                            else
                                state <= S1;
                            end if;
                        end if;
            when S1 => -- in progress
                        num <= "0001";
                        bit_tim_en <= '1';
                        if div_clk'event then
                            sck_clk <= not sck_clk;
                        
                            if cpha = '1' then
                                shift_reg_clk <= div_clk;
                                bit_tim_clk <= div_clk;
                            else
                                shift_reg_clk <= not shift_reg_clk;
                                bit_tim_clk <= not div_clk;
                            end if;
                        end if;
            when S2 => -- end
                        num <= "0010";
                        bit_tim_en <= '0';
                        shift_reg_clk <= '0';
                        bit_tim_clk <= '0';
                        sck_clk <= cpol;
            when S3 => -- shift 1st bit when cpha='0'
                        num <= "0011";
                        if div_clk = '1' and div_clk'event then
                            shift_reg_clk <= '1';
                            state <= S1;
                        end if;
        end case;
    end process;

    sck_shift_reg <= shift_reg_clk;
    sck_main <= sck_clk;
    rx_ready <= bit_tim_done;
end Behavorial;