library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitOperatorF_tb is
end entity;

architecture arc of bitOperatorF_tb is
    component bitOperatorF is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    begin
    end arc;