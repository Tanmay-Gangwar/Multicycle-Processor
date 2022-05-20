library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- It checks the conditions like EQ, NE, GE, LE, GT, LT etc.
-- It takes input condition field as std_logic_vector(3 downto 0);
-- It takes input all flags namely N, Z, C and V as std_logic;
-- It outputs '1' if condition is true or '0' if condition is false as result as std_logic
entity predicate is
    port(
        cond: in std_logic_vector(3 downto 0);
        Nflag, Zflag, Cflag, Vflag: in std_logic;
        result: out std_logic
    );
end predicate;

architecture arc of predicate is
    begin
        -- sensitive to cond, Nflag, Zflag, Cflad, Vflag
        process (cond, Nflag, Zflag, Cflag, Vflag) is 
            begin
                if (cond = "0000") then result <= Zflag;
                elsif (cond = "0001") then result <= not Zflag;
                elsif (cond = "0010") then result <= Cflag;
                elsif (cond = "0011") then result <= not Cflag;
                elsif (cond = "0100") then result <= Nflag;
                elsif (cond = "0101") then result <= not Nflag;
                elsif (cond = "0110") then result <= Vflag;
                elsif (cond = "0111") then result <= not Vflag;
                elsif (cond = "1000") then result <= Cflag and not Zflag;
                elsif (cond = "1001") then result <= not Cflag or Zflag;
                elsif (cond = "1010") then result <= not (Nflag xor Vflag);
                elsif (cond = "1011") then result <= Nflag xor Vflag;
                elsif (cond = "1100") then result <= not ((Nflag xor Vflag) or Zflag);
                elsif (cond = "1101") then result <= (Nflag xor Vflag) or Zflag;
                elsif (cond = "1110") then result <= '1';
                end if;
            end process;
    end arc;