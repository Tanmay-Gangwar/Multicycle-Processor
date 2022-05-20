library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUcell_tb is
end ALUcell_tb;

architecture test of ALUcell_tb is
    component ALUcell is
        port(
            Ain, Bin, Cin: in std_logic;
            Inp: in std_logic_vector(2 downto 0);
            Op: in std_logic_vector(1 downto 0);
            S, Cout: out std_logic
        );
        end component;

    signal a, b, cin, s, cout: std_logic;
    signal inp: std_logic_vector(2 downto 0);
    signal op: std_logic_vector(1 downto 0);
begin
    -- As there are only 256 possilbe input choices, we can test all of them
    ALUcell0: ALUcell port map(a, b, cin, inp, op, s, cout);
    process begin
        a <= '0';
        b <= '0';
        cin <= '0';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '0';
        b <= '0';
        cin <= '1';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '0';
        b <= '1';
        cin <= '0';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '0';
        b <= '1';
        cin <= '1';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '1';
        b <= '0';
        cin <= '0';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '1';
        b <= '0';
        cin <= '1';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '1';
        b <= '1';
        cin <= '0';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        a <= '1';
        b <= '1';
        cin <= '1';
        -- All possible combinations for inp and op
        for i in 0 to 7 loop
            for j in 0 to 3 loop
                inp <= std_logic_vector(to_unsigned(i, 3));
                op <= std_logic_vector(to_unsigned(j, 2));
                wait for 1 ns;
            end loop;
        end loop;

        assert false report "Reached end of the test";
        wait;
    end process;
end test;