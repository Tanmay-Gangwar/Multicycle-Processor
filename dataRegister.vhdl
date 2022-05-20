library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It is a basic register which takes in clk as std_logic;
-- It takes in write Signal as wrSignal as std_logic;
-- It takes in new Data as std_logic_vector(31 downto 0);
-- It outputs curr Data stored as std_logic_vector(31 downto 0);
entity dataRegister is
    port(
        clk: in std_logic;
        wrSignal: in std_logic;
        newData: in std_logic_vector(31 downto 0);
        currData: out std_logic_vector(31 downto 0)
    );
end dataRegister;

architecture arc of dataRegister is
    signal curr: std_logic_vector(31 downto 0);

    begin
        currData <= curr;
        process (clk) is
            begin
                if (wrSignal = '1') then
                    curr <= newData;
                end if;
            end process;
    end arc;