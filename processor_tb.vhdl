library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end processor_tb;

architecture arc of processor_tb is
    component processor is
        port (clk: in std_logic);
    end component;

    signal clk: std_logic := '0';
    begin
        processor0: processor port map(clk);
        clk <= not clk after 2 ns;
    
    end arc;
