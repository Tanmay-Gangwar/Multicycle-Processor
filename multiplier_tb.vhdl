library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_tb is
end entity;

architecture arc of multiplier_tb is
    component multiplier is
        port (
            allow: in std_logic;
            a: in std_logic_vector(31 downto 0);
            b: in std_logic_vector(31 downto 0);
            c: in std_logic_vector(63 downto 0);
            sgn: in std_logic;
            acc: in std_logic;
            res: out std_logic_vector(63 downto 0)
        );
        end component;
    
        signal a, b: std_logic_vector(31 downto 0);
        signal sgn, acc: std_logic;
        signal c, res: std_logic_vector(63 downto 0);

        begin
            multiplier0: multiplier port map('1', a, b, c, sgn, acc, res);
            process begin
                a <= X"69F9A799";
                b <= X"790B86C9";
                C <= X"73E599D98A918340";
                sgn <= '0';
                acc <= '0';
                wait for 1 ns;

                acc <= '1';
                wait for 1 ns;

                sgn <= '1';
                acc <= '0';
                wait for 1 ns;

                acc <= '1';
                wait for 1 ns;

                a <= X"F8701358";
                b <= X"F0901348";
                c <= X"F9098B08C8D00798";
                sgn <= '0';
                acc <= '0';
                wait for 1 ns;

                acc <= '1';
                wait for 1 ns;

                sgn <= '1';
                acc <= '0';
                wait for 1 ns;

                acc <= '1';
                wait for 1 ns;

                wait;
            end process;
        end arc;