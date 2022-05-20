library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It shifts/rotate input by 4 unit
-- takes input a as std logic vector(31 downto 0);
-- it takes operation as op as std logic vector(1 downto 0);
-- op = "00" => LSL
-- op = "01" => LSR
-- op = "10" => ASR
-- op = "11" => ROR
-- It takes input shift as std logic
-- shift = 1 => we have to return shifted output
-- shift = 0 => we have to return output same as input
-- It output cout as std logic
entity bitOperator4 is
    port (
        a: in std_logic_vector(31 downto 0);
        Op: in std_logic_vector(1 downto 0);
        shift: in std_logic;
        o: out std_logic_vector(31 downto 0);
        cout: out std_logic 
    );
end entity;

architecture arc of bitOperator4 is
    begin
        process (a, Op, shift) is
            begin
                if (shift = '1') then
                    if (Op = "00") then
                        o(31 downto 4) <= a(27 downto 0);
                        o(3 downto 0) <= X"0";
                        cout <= a(28);
                    elsif (Op = "01") then
                        o(27 downto 0) <= a(31 downto 4);
                        o(31 downto 28) <= X"0";
                        cout <= a(3);
                    elsif (Op = "10") then
                        o(27 downto 0) <= a(31 downto 4);
                        if (a(31) = '0') then o(31 downto 28) <= X"0";
                        else o(31 downto 28) <= X"F";
                        end if;
                        cout <= a(3);
                    else
                        o(27 downto 0) <= a(31 downto 4);
                        o(31 downto 28) <= a(3 downto 0);
                        cout <= a(3);
                    end if;
                else
                    o <= a;
                    cout <= '0';
                end if;
        end process;
end arc;