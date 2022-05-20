library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Takes input result of ALU as S as std_logic_vector(31 downto 0);
-- Takes input Last two carry values C31 and C32 as std_logic
-- Output updated flags N, Z, C and V as std_logic
entity flags is
    port(
        set: in std_logic;
        s: in std_logic_vector(31 downto 0);
        c31, c32: in std_logic;
        Nflag, Zflag, Cflag, Vflag: out std_logic
    );
end flags;

architecture arc of flags is
    signal curr_Nflag, curr_Zflag, curr_Cflag, curr_Vflag: std_logic := '0';
    begin
        -- sensitive to c31, c32 and s
        Nflag <= curr_Nflag;
        Zflag <= curr_Zflag;
        Cflag <= curr_Cflag;
        Vflag <= curr_Vflag;
        process (c31, c32, s, set) is
            begin
                if (set = '1') then
                    -- condition for Z = 1
                    if (s = x"00000000") then curr_Zflag <= '1';
                    else curr_Zflag <= '0';
                    end if;

                    -- condition for N = 1
                    if (s(31) = '1') then curr_Nflag <= '1';
                    else curr_Nflag <= '0';
                    end if;
                    
                    -- condition for C and V flags
                    curr_Cflag <= c32;
                    curr_Vflag <= c31 xor c32;
                end if;
            end process;
    end arc;