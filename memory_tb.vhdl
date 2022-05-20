library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end memory_tb;

architecture arc of memory_tb is
    component memory is
        port(
            wrSignal: in std_logic;
            addr: in std_logic_vector(8 downto 0);
            byteSig: in std_logic_vector(3 downto 0);
            dataIn: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            dataOut: out std_logic_vector(31 downto 0)
        );
    end component;

    signal wrSignal: std_logic;
    signal addr: std_logic_vector(8 downto 0);
    signal byteSig: std_logic_vector(3 downto 0);
    signal dataIn: std_logic_vector(31 downto 0);
    signal clk: std_logic := '0';
    signal dataOut:std_logic_vector(31 downto 0);

begin
    MEM: memory port map(wrSignal, addr, byteSig, dataIn, clk, dataOut);
    clk <= not clk after 2 ns;
    process begin
        wrSignal <= '1';
        addr <= "110100100";
        dataIn <= "00101011000101010111110101100110";
        byteSig <= "1111";
        wait for 3 ns;

        wrSignal <= '1';
        addr <= "110110000";
        dataIn <= "00101001001010100000010101010011";
        byteSig <= "1111";
        wait for 3 ns;

        wrSignal <= '0';
        addr <= "110100100";
        byteSig <= "1111";
        wait for 3 ns;

        wrSignal <= '1';
        addr <= "001100000";
        dataIn <= "00000000000000000000000011010101";
        byteSig <= "0001";
        wait for 3 ns;

        wrSignal <= '1';
        addr <= "001100001";
        dataIn <= "00000000000000000101110111011001";
        byteSig <= "0011";
        wait for 3 ns;

        wrSignal <= '0';
        addr <= "001100000";
        byteSig <= "1111";
        wait for 3 ns;

        wrSignal <= '0';
        addr <= "001100000";
        byteSig <= "0001";
        wait for 3 ns;

        assert false report "End of the test";
        wait;
    end process;
end arc;