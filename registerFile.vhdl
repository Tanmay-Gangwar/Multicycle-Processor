library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It is an ALU cell similar as described in Lecture 8 slide 53.
-- It takes input 2 read address and 1 write address as rdAddr1, rdAddr2 and wrAddr as std_logic_vector(3 downto 0)
-- It takes input a clock as clk as std_logic
-- It takes input whether to write data or to read data as regWrite as std_logic
-- It takes input write data as wrData as std_logic(31 downto 0)
-- It outputs 2 read data as rdData1, rdData2 as std_logic_vector(31 downto 0)
entity registerFile is
    port(
        regWrite: in std_logic;
        rdAddr1, rdAddr2, wrAddr: in std_logic_vector(3 downto 0);
        wrData: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        rdData1, rdData2: out std_logic_vector(31 downto 0)
    );
end registerFile;

architecture arc of registerFile is
    -- grid is defined as array of std_logic
    type grid is array(0 to 15) of std_logic_vector(31 downto 0);
    -- registers are defined as grid
    signal registers: grid;
    -- indexWr, indexRd1, indexRd2 to convert address to integer
    signal indexWr, indexRd1, indexRd2: integer range 0 to 15;
begin
    --Reads data when regWrite = 0
    indexRd1 <= to_integer(unsigned(rdAddr1));
    indexRd2 <= to_integer(unsigned(rdAddr2));
    rdData1 <= registers(indexRd1);
    rdData2 <= registers(indexRd2);
    indexWr <= to_integer(unsigned(wrAddr));

    --Writes data with clock and regWrite = 1
    process (clk) begin
        if (regWrite = '1') then
            registers(indexWr) <= wrData;
        end if;
    end process;
end arc;