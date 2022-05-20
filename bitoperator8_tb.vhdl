library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitOperator8_tb is
end entity;

architecture arc of bitOperator8_tb is
    component bitOperator8 is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    begin
    end arc;