library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end ALU_tb;

architecture test of ALU_tb is
    component ALU is
        port(
            Ain, Bin: in std_logic_vector(31 downto 0);
            inst: in std_logic_vector(3 downto 0);
            Cflag: in std_logic;
            Sout: out std_logic_vector(31 downto 0);
            C31: out std_logic;
            Cout: out std_logic
        );
    end component;

    signal a, b, s: std_logic_vector(31 downto 0);
    signal inst: std_logic_vector(3 downto 0);
    signal c31, cflag, cout: std_logic;
begin
    ALU1: ALU port map(a, b, inst, cflag, s, c31, cout);
    
    process begin
        -- assigning definite value to a and b
        a <= "11010111101011100011101011011011";
        b <= "11010111000110110001110101001010";
        -- carrying out all possible dp instructions
        for i in 0 to 15 loop
            inst <= std_logic_vector(to_unsigned(i, 4));
            cflag <= '0';
            wait for 3 ns;

            cflag <= '1';
            wait for 3 ns;
        end loop;

        -- assigning a not fixed value to a and b
        a <= "00011010111010101010100101110101";
        b <= "00011101110111000010100010110000";
        -- carrying out all possible dp instructions
        for i in 0 to 15 loop
            inst <= std_logic_vector(to_unsigned(i, 4));
            cflag <= '0';
            wait for 3 ns;

            cflag <= '1';
            wait for 3 ns;
        end loop;

        assert false report "Reached end of the test";
        wait;
    end process;
end test;