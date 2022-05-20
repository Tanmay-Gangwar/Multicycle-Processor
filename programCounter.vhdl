library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It takes input clock as std_logic
-- It takes input offset as std_logic_vector(23 downto 0) which is directly retrieved from instruction of programMemory
-- It return pointer to next program address
-- It maintains current pointer to program address
-- One every clock cycle, it adds offset to current pointer and returns pc
entity programCounter is
    port (
        clk: in std_logic;
        wrSignal: in std_logic;
        newPc: in std_logic_vector(8 downto 0);
        currPc: out std_logic_vector(8 downto 0)
    );
end programCounter;

architecture arc of programCounter is
    signal curr: integer range 0 to 512 := 0;

    begin
        currPc <= std_logic_vector(to_unsigned(curr, 9));
        process (clk) is
            begin
                if (wrSignal = '1') then
                    curr <= to_integer(unsigned(newPc));
                end if;
            end process;
    end arc;