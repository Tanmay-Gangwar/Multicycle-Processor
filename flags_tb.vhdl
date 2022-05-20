library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flags_tb is
end flags_tb;

architecture arc of flags_tb is
    component flags is
        port(
            set: in std_logic;
            s: in std_logic_vector(31 downto 0);
            c31, c32: in std_logic;
            Nflag, Zflag, Cflag, Vflag: out std_logic
        );
    end component;

    signal set: std_logic;
    signal c31, c32: std_logic;
    signal Nflag, Zflag, Cflag, Vflag: std_logic;
    signal s: std_logic_vector(31 downto 0);

    begin
        flags0: flags port map(set, s, c31, c32, Nflag, Zflag, Cflag, Vflag);
        process begin
            s <= x"7a0b9f87";

            set <= '1';
            s(31) <= '0';
            c31 <= '0';
            c32 <= '0';
            wait for 1 ns;
            
            s(31) <= '0';
            c31 <= '0';
            c32 <= '1';
            wait for 1 ns;
            
            s(31) <= '0';
            c31 <= '1';
            c32 <= '0';
            wait for 1 ns;

            s(31) <= '0';
            c31 <= '1';
            c32 <= '1';
            wait for 1 ns;

            s(31) <= '1';
            c31 <= '0';
            c32 <= '0';
            wait for 1 ns;
            
            s(31) <= '1';
            c31 <= '0';
            c32 <= '1';
            wait for 1 ns;

            s(31) <= '1';
            c31 <= '1';
            c32 <= '0';
            wait for 1 ns;

            s(31) <= '1';
            c31 <= '1';
            c32 <= '1';
            wait for 1 ns;

            s <= x"00000000";
            wait for 1 ns;
        
            assert false report "reached end of the test";
            wait;
        end process;
end arc;