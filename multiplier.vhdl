library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It takes a, b, as std_logic_vector(31 downto 0),
-- It takes c as std_logic_vector(63 downto 0)
-- It also takes allow, sgn and acc input as signed
-- It outputs result as res as std_logic_vector(63 downto 0)
-- It multiplies only when allow is '1'. This is done to prevent any kind of undefined signal as it can lead to errors
-- If sgn = '1' and acc = '0' then res <= signed(a) * signed(b)
-- If sgn = '0' and acc = '0' then res <= unsigned(a) * unsigned(b)
-- If sgn = '1' and acc = '1' then res <= signed(a) * signed(b) + signed(c)
-- If sgn = '0' and acc = '1' then res <= unsigned(a) * unsigned(b) + unsigned(c)
entity multiplier is
    port (
        allow: in std_logic;
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        c: in std_logic_vector(63 downto 0);
        sgn: in std_logic;
        acc: in std_logic;
        res: out std_logic_vector(63 downto 0)
    );
    end entity;

architecture arc of multiplier is
    begin
        process (a, b, c, sgn, acc, allow) is
            begin
                if (allow = '1') then
                    if (sgn = '1') then
                        if (acc = '1') then res <= std_logic_vector(signed(a) * signed(b) + signed(c));
                        else res <= std_logic_vector(signed(a) * signed(b));
                        end if;
                    else
                        if (acc = '1') then res <= std_logic_vector(unsigned(a) * unsigned(b) + unsigned(c));
                        else res <= std_logic_vector(unsigned(a) * unsigned(b));
                        end if;
                    end if;
                else res <= X"0000000000000000";
                end if;
        end process;
    end arc;

