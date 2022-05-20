library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It shifts/rotate input by 8 unit
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
entity bitOperator8 is
    port (
        a: in std_logic_vector(31 downto 0);
        Op: in std_logic_vector(1 downto 0);
        shift: in std_logic;
        o: out std_logic_vector(31 downto 0);
        cout: out std_logic 
    );
end entity;

architecture arc of bitOperator8 is
    begin
        process (a, Op, shift) is
            begin
                if (shift = '1') then
                    if (Op = "00") then
                        o(31 downto 8) <= a(23 downto 0);
                        o(7 downto 0) <= X"00";
                        cout <= a(24);
                    elsif (Op = "01") then
                        o(23 downto 0) <= a(31 downto 8);
                        o(31 downto 24) <= X"00";
                        cout <= a(7);
                    elsif (Op = "10") then
                        o(23 downto 0) <= a(31 downto 8);
                        if (a(31) = '0') then o(31 downto 24) <= X"00";
                        else o(31 downto 24) <= X"FF";
                        end if;
                        cout <= a(7);
                    else
                        o(23 downto 0) <= a(31 downto 8);
                        o(31 downto 24) <= a(7 downto 0);
                        cout <= a(7);
                    end if;
                else
                    o <= a;
                    cout <= '0';
                end if;
        end process;
end arc;