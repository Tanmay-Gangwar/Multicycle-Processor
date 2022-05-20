library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataRegister_tb is
end dataRegister_tb;

architecture arc of dataRegister_tb is

    component dataRegister
        port(
            clk: in std_logic;
            wrSignal: in std_logic;
            newData: in std_logic_vector(31 downto 0);
            currData: out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal clk, wrSignal: std_logic := '0';
    signal newData, currData: std_logic_vector(31 downto 0);
    begin
        instReg0: dataRegister port map(clk, wrSignal, newData, currData);
        clk <= not clk after 2 ns;
        process is
            begin
                wrSignal <= '1';
                newData <= X"12345678";

                wait for 2 ns;
                wrSignal <= '0';

                wait for 2 ns;
                wrSignal <= '1';
                newData <= X"7A90B0F3";
                
                wait for 2 ns;
                wrSignal <= '0';

                wait for 5 ns;
                wrSignal <= '1';
                newData <= X"9E8B6C95";

                wait for 2 ns;
                wrSignal <= '0';

                wait for 2 ns;
                assert false report "Reached end of the test";
                wait;
            end process;
    end arc;