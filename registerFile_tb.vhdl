library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile_tb is
end registerFile_tb;

architecture test of registerFile_tb is
    component registerFile is
        port(
            regWrite: in std_logic;
            rdAddr1, rdAddr2, wrAddr: in std_logic_vector(3 downto 0);
            wrData: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            rdData1, rdData2: out std_logic_vector(31 downto 0)
        );
    end component;

    signal regWrite: std_logic := '0';
    signal rdAddr1, rdAddr2, wrAddr: std_logic_vector(3 downto 0) := "0000";
    signal wrData, rdData1, rdData2: std_logic_vector(31 downto 0);
    signal clk: std_logic := '0';
begin
    RF0: registerFile port map(regWrite, rdAddr1, rdAddr2, wrAddr, wrData, clk, rdData1, rdData2);
    clk <= not clk after 2 ns;
    process begin
        -- write at register 2
        wrData <= "01011101010100110001100010110100";
        wrAddr <= "0010";
        regWrite <= '1';
        wait for 3 ns;

        -- write at register 1
        wrData <= "01011101010101010111010101010100";
        wrAddr <= "0101";
        regWrite <= '1';
        wait for 3 ns;

        --write at register 6
        wrData <= "11010111000101101001010101000011";
        wrAddr <= "0110";
        regWrite <= '1';
        wait for 3 ns;

        --write at register 13
        wrData <= "00110011100111010001111110000001";
        wrAddr <= "1101";
        regWrite <= '1';
        wait for 3 ns;

        --read from register 2 and 13
        regWrite <= '0';
        rdAddr1 <= "0010";
        wait for 1 ns;
        rdAddr2 <= "1101";
        wait for 3 ns;

        --read from register 6
        rdAddr1 <= "0110";
        wait for 1 ns;

        -- modify content of register 13
        wrAddr <= "1101";
        wrData <= "11011110101011111100001100010110";
        regWrite <= '1';
        wait for 3 ns;

        --read from register 2 and 13
        regWrite <= '0';
        rdAddr1 <= "0010";
        wait for 1 ns;
        rdAddr2 <= "1101";
        wait for 3 ns;

        assert false report "End of the test";
        wait;
        
    end process;
end test;