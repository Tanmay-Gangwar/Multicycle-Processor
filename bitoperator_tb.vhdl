library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitoperator_tb is
end entity;

architecture arc of bitoperator_tb is
    component bitoperator is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            amount: in std_logic_vector(4 downto 0);
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;
    signal a: std_logic_vector(31 downto 0);
    signal Op: std_logic_vector(1 downto 0);
    signal amount: std_logic_vector(4 downto 0);
    signal o: std_logic_vector(31 downto 0);
    signal cout: std_logic;
    begin
        comp: bitoperator port map(a, Op, amount, o, cout);
        process begin
            a <= "10101010001010111001010111010110";
            Op <= "00";
            amount <= "01101";
            wait for 1 ns;

            Op <= "01";
            wait for 1 ns;

            Op <= "10";
            wait for 1 ns;

            Op <= "11";
            wait for 1 ns;

            a <= "00101100010101010101000100001100";
            Op <= "00";
            amount <= "00110";
            wait for 1 ns;

            Op <= "01";
            wait for 1 ns;

            Op <= "10";
            wait for 1 ns;

            Op <= "11";
            wait for 1 ns;
            wait;
        end process;
end arc;