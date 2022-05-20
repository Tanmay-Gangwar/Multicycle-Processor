library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It shifts/rotate input by 2 units
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
entity bitOperator2 is
    port (
        a: in std_logic_vector(31 downto 0);
        Op: in std_logic_vector(1 downto 0);
        shift: in std_logic;
        o: out std_logic_vector(31 downto 0);
        cout: out std_logic 
    );
end entity;

architecture arc of bitOperator2 is
    begin
        process (a, Op, shift) is
            begin
                if (shift = '1') then
                    if (Op = "00") then
                        o(31 downto 2) <= a(29 downto 0);
                        o(1 downto 0) <= "00";
                        cout <= a(30);
                    elsif (Op = "01") then
                        o(29 downto 0) <= a(31 downto 2);
                        o(31 downto 30) <= "00";
                        cout <= a(1);
                    elsif (Op = "10") then
                        o(29 downto 0) <= a(31 downto 2);
                        if (a(31) = '0') then o(31 downto 30) <= "00";
                        else o(31 downto 30) <= "11";
                        end if;
                        cout <= a(1);
                    else
                        o(29 downto 0) <= a(31 downto 2);
                        o(31 downto 30) <= a(1 downto 0);
                        cout <= a(1);
                    end if;
                else
                    o <= a;
                    cout <= '0';
            end if;
        end process;
end arc;