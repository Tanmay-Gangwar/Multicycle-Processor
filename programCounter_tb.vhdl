library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programCounter_tb is
end programCounter_tb;

architecture arc of programCounter_tb is
    component programCounter is
        port (
            clk: in std_logic;
            wrSignal: in std_logic;
            newPc: in std_logic_vector(8 downto 0);
            currPc: out std_logic_vector(8 downto 0)
        );
    end component;

    signal clk: std_logic := '0';
    signal wrSignal: std_logic;
    signal newPc: std_logic_vector(8 downto 0);
    signal currPc: std_logic_vector(8 downto 0);

    begin
        MyPc: programCounter port map(clk, wrSignal, newPc, currPc);
        clk <= not clk after 2 ns;
        process begin
            wrSignal <= '0';
            wait for 1 ns;
            wrSignal <= '1';
            newPc <= "000000100";

            wait for 2 ns;
            wrSignal <= '1';
            newPc <= "000001100";

            wait for 2 ns;
            wrSignal <= '0';

            wait for 2 ns;
            wrSignal <= '1';
            newPc <= "000010000";

            wait for 2 ns;
            assert false report "Reached end of the test";
            wait;
    end process;
end arc;