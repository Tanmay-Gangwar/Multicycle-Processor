library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It is an program Memory same as described in Lecture 9 slide 23.
-- Address is input as addr as std_logic_vector(7 downto 0);
-- Datain and Dataout is std_logic_vector(31 downto 0);
-- Read - Write signal is declared as Signal as std_logic;
-- byteSignal gives the power to read-write at byte level.
-- If byte signal is "1001" then this implies to read/write std_logic_vector(31 downto 24) and std_logic_vector(7 downto 0) only.
-- clock is input as clk as std_logic
entity memory is
    port(
        wrSignal: in std_logic;
        addr: in std_logic_vector(8 downto 0);
        byteSig: in std_logic_vector(3 downto 0);
        dataIn: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        dataOut: out std_logic_vector(31 downto 0)
    );
end memory;

architecture arc of memory is

    -- grid is defined as array of std_logic_vector
    type grid is array(0 to 127) of std_logic_vector(31 downto 0);
    -- memory is defined as grid
    -- PROGRAM 1
    -- signal mem: grid := (
    --     0 => X"E3A00028",               -- mov r0, #40          => r0 = 40
    --     1 => X"E3A01005",               -- mov r1, #5           => r1 = 5
    --     2 => X"E5801000",               -- str r1, [r0]         => mem[40] = 5
    --     3 => X"E2811002",               -- add r1, r1, #2       => r1 = 7
    --     4 => X"E5801004",               -- str r1, [r0, #4]     => mem[44] = 7
    --     5 => X"E5902000",               -- ldr r2, [r0]         => r2 = mem[40] = 5
    --     6 => X"E5903004",               -- ldr r3, [r0, #4]     => r3 = mem[44] = 7
    --     7 => X"E0434002",               -- sub r4, r3, r2       => r4 = 2
    --     others => X"00000000"           -- .end
    -- );

    -- PROGRAM 2
    -- signal mem: grid :=(
    --     0 => X"E3A00000",                   -- mov r0, #0               => r0 = 0
    --     1 => X"E3A01000",                   -- mov r1, #0               => r1 = 0
    --     2 => X"E0800001",                   -- Loop: add r0, r0, r1     => r0 = 0, r0 = 1, r0 = 3, r0 = 6, r0 = 10
    --     3 => X"E2811001",                   -- add r1, r1, #1           => r1 = 1, r1 = 2, r1 = 3, r1 = 4, r1 = 5
    --     4 => X"E3510005",                   -- cmp r1, #5
    --     5 => X"1AFFFFFB",                   -- bne Loop
    --     others => X"00000000"
    -- );

    -- PROGRAM 3
    -- signal mem: grid :=(
    --     0 => X"E3A00000",           -- mov r0, #0               => r0 = 0
    --     1 => X"E3A01001",           -- mov r1, #1               => r1 = 1
    --     2 => X"E3A03001",           -- mov r3, #1               => r3 = 1
    --     3 => X"E0812000",           -- Loop: add r2, r1, r0     => r2 = 1, 2, 3, 5, 8, 13, 21, 34, 55
    --     4 => X"E1A00001",           -- mov r0, r1               => r0 = 1, 1, 2, 3, 5,  8, 13, 21, 34
    --     5 => X"E1A01002",           -- mov r1, r2               => r1 = 1, 2, 3, 5, 8, 13, 21, 34, 21
    --     6 => X"E2833001",           -- add r3, r3, #1           => r3 = 2, 3, 4, 5, 6,  7,  8,  9, 10
    --     7 => X"E353000A",           -- cmp r3, #10              
    --     8 => X"1AFFFFF9",           -- bne Loop
    --     others => X"00000000"      -- .end
    -- );

    -- PROGRAM 4 to check all dp commads
    -- signal mem: grid :=(
    --     0 =>  X"E3A0000F",         --- mov r0, #15
    --     1 =>  X"E3A01009",         --- mov r1, #9
    --     2 =>  X"E0002001",         --- and r2, r0, r1       => r2 = 9
    --     3 =>  X"E2002018",         --- and r2, r0, #24      => r2 = 8
    --     4 =>  X"E0202001",         --- eor r2, r0, r1       => r2 = 6
    --     5 =>  X"E2202018",         --- eor r2, r0, #24      => r2 = 23
    --     6 =>  X"E0402001",         --- sub r2, r0, r1       => r2 = 6
    --     7 =>  X"E2402018",         --- sub r2, r0, #24      => r2 = -9
    --     8 =>  X"E0602001",         --- rsb r2, r0, r1       => r2 = -6
    --     9 =>  X"E2602018",         --- rsb r2, r0, #24      => r2 = 9
    --     10 => X"E0802001",         --- add r2, r0, r1       => r2 = 24
    --     11 => X"E2802018",         --- add r2, r0, #24      => r2 = 39
    --     12 => X"E0A02001",         --- adc r2, r0, r1       => r2 = 24
    --     13 => X"E2A02018",         --- adc r2, r0, #24      => r2 = 39
    --     14 => X"E0C02001",         --- sbc r2, r0, r1       => r2 = 5
    --     15 => X"E2C02018",         --- sbc r2, r0, #24      => r2 = -10
    --     16 => X"E0E02001",         --- rsc r2, r0, r1       => r2 = -7
    --     17 => X"E2E02018",         --- rsc r2, r0, #24      => r2 = 8
    --     18 => X"E1102001",         --- tst r0, r1  
    --     19 => X"E3102018",         --- tst r0, #24 
    --     20 => X"E1302001",         --- teq r0, r1  
    --     21 => X"E3302018",         --- teq r0, #24 
    --     22 => X"E1502001",         --- cmp r0, r1  
    --     23 => X"E3502018",         --- cmp r0, #24 
    --     24 => X"E1702001",         --- cmn r0, r1  
    --     25 => X"E3702018",         --- cmn r0, #24 
    --     26 => X"E1802001",         --- orr r2, r0, r1       => r2 = 15
    --     27 => X"E3802018",         --- orr r2, r0, #24      => r2 = 31
    --     28 => X"E1A02001",         --- mov r2, r1           => r2 = 9
    --     29 => X"E3A02018",         --- mov r2, #24          => r2 = 24
    --     30 => X"E1C02001",         --- bic r2, r0, r1       => r2 = 6
    --     31 => X"E3C02018",         --- bic r2, r0, #24      => r2 = 7
    --     32 => X"E1E02001",         --- mvn r2, r1           => r2 = -10
    --     33 => X"E3E02018",         --- mvn r2, #25          => r2 = -25
    --     others => X"00000000"      --- end
    -- );

    -- PROGRAM 5:
    -- signal mem: grid := (
    --     0 => X"E3A00001",           -- mov r0, #1               => r0 = 1
    --     1 => X"E3A01002",           -- mov r1, #2               => r1 = 2
    --     2 => X"E3A02104",           -- mov r2, #4, #2           => r2 = 1
    --     3 => X"E0823102",           -- add r3, r2, r2, lsl #2   => r3 = 5
    --     4 => X"E08240A3",           -- add r4, r2, r3, lsr #1   => r4 = 3
    --     5 => X"E1845283",           -- orr r5, r4, r3, lsl #5   => r5 = 163
    --     6 => X"E2855001",           -- add r5, r5, #1           => r5 = 164
    --     7 => X"E0056413",           -- and r6, r5, r3, lsl r4   => r6 = 32
    --     8 => X"E5854004",           -- str r4, [r5, #4]         => mem[168] = 3
    --     9 => X"E7957102",           -- ldr r7, [r5, r2, lsl #2] => r7 = mem[168] = 3
    --     10 => X"E0877126",          -- add r7, r7, r6, lsr #2   => r7 = 11
    --     others => X"00000000"       -- .end
    -- );

    -- PROGRAM 6
    -- signal mem: grid := (
    --     0  => X"E3A00000",          -- mov r0, #0               => r0 = 0
    --     1  => X"E2400004",          -- sub r0, r0, #4           => r0 = -4
    --     2  => X"E3A01050",          -- mov r1, #80              => r1 = 80
    --     3  => X"E5810000",          -- str r0, [r1]             => mem[83 downto 80] = X"FFFFFFFC"
    --     4  => X"E2400002",          -- sub r0, r0, #2           => r0 = -6
    --     5  => X"E1E100B4",          -- strh r0, [r1, #4]!       => r1 = 84, mem[85 downto 84] = X"FFFA"
    --     6  => X"E2400002",          -- sub r0, r0, #2           => r0 = -8
    --     7  => X"E2811002",          -- add r1, r1, #2           => r1 = 86
    --     8  => X"E4C10002",          -- strb r0, [r1], #2        => mem[86] = X"F8", r1 = 88
    --     9  => X"E5712002",          -- ldrb r2, [r1, #-2]!      => r1 = 86, r2 = mem[86] => r2 = X"000000F8"
    --     10 => X"E05130D2",          -- ldrsb r3, [r1], #-2      => r2 = mem[86] => r2 = X"FFFFFFF8", r1 = 84
    --     11 => X"E1D140B0",          -- ldrh r4, [r1]            => r4 = mem[85 downto 84] = X"0000FFFA"
    --     12 => X"E05150F4",          -- ldrsh r5, [r1], #-4      => r5 = mem[85 downto 84] = X"FFFFFFFA", r1 = 80
    --     13 => X"E5916000",          -- ldr r6, [r1]             => r6 = mem[83 downto 80] = X"FFFFFFFC"
    --     others => X"00000000"
    -- );

    -- PROGRAM 7
    signal mem: grid := (
        0 => X"E3A00004",               -- mov r0, #4               => r0 = 4
        1 => X"E3A01005",               -- mov r1, #5               => r5 = 5
        2 => X"E0020091",               -- mul r2, r1, r0           => r2 = 4 * 5 = 20
        3 => X"E0230192",               -- mla r3, r2, r1, r0       => r3 = 20 * 5 + 4 = 104
        4 => X"E3A0027B",               -- mov r0, #123, #4         => r0 = X"B0000007"
        5 => X"E3A012E7",               -- mov r1, #231, #4         => r1 = X"7000000E"
        6 => X"E0C32091",               -- smull r2, r3, r1, r0     => r3r2 = signed(r1) * signed(r0) = X"DCFFFFFEB0000062"
        7 => X"E0854091",               -- umull r4, r5, r1, r0     => r5r4 = unsigned(r1) * unsigned(r0) = X"4D00000CB0000062"
        8 => X"E0A54091",               -- umlal r4, r5, r1, r0     => r5r4 = unsigned(r1) * unsigned(r0) + unsigned(r5r4) = X"9A000019600000C4"
        9 => X"E0E32091",               -- smlal r2, r3, r1, r0     => r3r2 = signed(r1) * signed(r0) + signed(r3r2) = X"89FFFFFD600000C4
        others => X"00000000"
    );
begin
    
    -- Process sensititve to wrSignal, addr and byteSig
    process (wrSignal, addr, byteSig) is
        variable index: integer range 0 to 511;
        variable row: integer range 0 to 127;
        variable col: integer range 0 to 3;
    begin
        index:= to_integer(unsigned(addr));
        row := index / 4;
        col := index mod 4;
        if (byteSig(0) = '1') then      -- 4th byte of a word(dataOut)
            if (col = 0) then dataOut(7 downto 0) <= mem(row)(7 downto 0);
            elsif (col = 1) then dataOut(7 downto 0) <= mem(row)(15 downto 8);
            elsif (col = 2) then dataOut(7 downto 0) <= mem(row)(23 downto 16);
            else dataOut(7 downto 0) <= mem(row)(31 downto 24);
            end if;
        else dataOut(7 downto 0) <= "00000000";
        end if;

        if (byteSig(1) = '1') then      --3rd byte of a word(dataOut)
            if (col = 0) then dataOut(15 downto 8) <= mem(row)(15 downto 8);
            elsif (col = 1) then dataOut(15 downto 8) <= mem(row)(23 downto 16);
            elsif (col = 2) then dataOut(15 downto 8) <= mem(row)(31 downto 24);
            -- else dataOut(15 downto 8) <= mem(row + 1)(7 downto 0);
            else dataOut(15 downto 8) <= mem((row + 1) mod 128)(7 downto 0);
            end if;
        else dataOut(15 downto 8) <= "00000000";
        end if;

        if (byteSig(2) = '1') then      --2nd byte of a word(dataOut)
            if (col = 0) then dataOut(23 downto 16) <= mem(row)(23 downto 16);
            elsif (col = 1) then dataOut(23 downto 16) <= mem(row)(31 downto 24);
            elsif (col = 2) then dataOut(23 downto 16) <= mem((row + 1) mod 128)(7 downto 0);
            -- elsif (col = 2) then dataOut(23 downto 16) <= mem(row + 1)(7 downto 0);
            -- else dataOut(23 downto 16) <= mem(row + 1)(15 downto 8);
            else dataOut(23 downto 16) <= mem((row + 1) mod 128)(15 downto 8);
            end if;
        else dataOut(23 downto 16) <= "00000000";
        end if;

        if (byteSig(3) = '1') then      --1st byte of a word(dataOut)
            if (col = 0) then dataOut(31 downto 24) <= mem(row)(31 downto 24);
            elsif (col = 1) then dataOut(31 downto 24) <= mem((row + 1) mod 128)(7 downto 0);
            elsif (col = 2) then dataOut(31 downto 24) <= mem((row + 1) mod 128)(15 downto 8);
            -- elsif (col = 1) then dataOut(31 downto 24) <= mem(row + 1)(7 downto 0);
            -- elsif (col = 2) then dataOut(31 downto 24) <= mem(row + 1)(15 downto 8);
            else dataOut(31 downto 24) <= mem((row + 1) mod 128)(23 downto 16);
            -- else dataOut(31 downto 24) <= mem(row + 1)(23 downto 16);
            end if;
        else dataOut(31 downto 24) <= "00000000";
        end if;
    end process;

    process (clk) is            -- process sensitive only to clock
        variable index: integer range 0 to 511;
        variable row: integer range 0 to 127;
        variable col: integer range 0 to 3;
    begin
        index:= to_integer(unsigned(addr));
        row := index / 4;
        col := index mod 4;
        if (wrSignal = '1') then
            if (byteSig(0) = '1') then      -- Writes 4th byte of word(dataIn).
                if (col = 0) then mem(row)(7 downto 0) <= dataIn(7 downto 0);
                elsif (col = 1) then mem(row)(15 downto 8) <= dataIn(7 downto 0);
                elsif (col = 2) then mem(row)(23 downto 16) <= dataIn(7 downto 0);
                else mem(row)(31 downto 24) <= dataIn(7 downto 0);
                end if;
            end if;

            if (byteSig(1) = '1') then      -- Writes 3rd byte of word(dataIn).
                if (col = 0) then mem(row)(15 downto 8) <= dataIn(15 downto 8);
                elsif (col = 1) then mem(row)(23 downto 16) <= dataIn(15 downto 8);
                elsif (col = 2) then mem(row)(31 downto 24) <= dataIn(15 downto 8);
                else mem(row + 1)(7 downto 0) <= dataIn(15 downto 8);
                end if;
            end if;

            if (byteSig(2) = '1') then      -- Writes 2nd byte of word(dataIn).
                if (col = 0) then mem(row)(23 downto 16) <= dataIn(23 downto 16);
                elsif (col = 1) then mem(row)(31 downto 24) <= dataIn(23 downto 16);
                elsif (col = 2) then mem(row + 1)(7 downto 0) <= dataIn(23 downto 16);
                else mem(row + 1)(15 downto 8) <= dataIn(23 downto 16);
                end if;
            end if;

            if (byteSig(3) = '1') then      -- Writes 1st byte of word(dataIn).
                if (col = 0) then mem(row)(31 downto 24) <= dataIn(31 downto 24);
                elsif (col = 1) then mem(row + 1)(7 downto 0) <= dataIn(31 downto 24);
                elsif (col = 2) then mem(row + 1)(15 downto 8) <= dataIn(31 downto 24);
                else mem(row + 1)(23 downto 16) <= dataIn(31 downto 24);
                end if;
            end if;
        end if;
    end process;
end arc;


