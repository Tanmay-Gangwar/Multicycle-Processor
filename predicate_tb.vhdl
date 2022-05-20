library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity predicate_tb is
end predicate_tb;

architecture arc of predicate_tb is
    component predicate is
        port(
            cond: in std_logic_vector(3 downto 0);
            Nflag, Zflag, Cflag, Vflag: in std_logic;
            result: out std_logic
        );
    end component;

    signal cond: std_logic_vector(3 downto 0);
    signal Nflag, Zflag, Cflag, Vflag: std_logic;
    signal result: std_logic;
    begin
        predicate0: predicate port map(cond, Nflag, Zflag, Cflag, Vflag, result);
        process begin
            loop0: for i in 0 to 15 loop
                cond <= std_logic_vector(to_unsigned(i, 4));
                Nflag <= '0';
                Zflag <= '0';
                Cflag <= '0';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '0';
                Zflag <= '0';
                Cflag <= '0';
                Vflag <= '1';
                wait for 1 ns;

                Nflag <= '0';
                Zflag <= '0';
                Cflag <= '1';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '0';
                Zflag <= '0';
                Cflag <= '1';
                Vflag <= '1';
                wait for 1 ns;
                
                Nflag <= '0';
                Zflag <= '1';
                Cflag <= '0';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '0';
                Zflag <= '1';
                Cflag <= '0';
                Vflag <= '1';
                wait for 1 ns;

                Nflag <= '0';
                Zflag <= '1';
                Cflag <= '1';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '0';
                Zflag <= '1';
                Cflag <= '1';
                Vflag <= '1';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '0';
                Cflag <= '0';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '0';
                Cflag <= '0';
                Vflag <= '1';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '0';
                Cflag <= '1';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '0';
                Cflag <= '1';
                Vflag <= '1';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '1';
                Cflag <= '0';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '1';
                Cflag <= '0';
                Vflag <= '1';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '1';
                Cflag <= '1';
                Vflag <= '0';
                wait for 1 ns;

                Nflag <= '1';
                Zflag <= '1';
                Cflag <= '1';
                Vflag <= '1';
                wait for 1 ns;
            end loop;

            assert false report "Reached end of the test";
            wait;
        end process;
    end arc;