library ieee;
use ieee.std_logic_1164.all;

-- ALU is designed similar as described in lecture 8 slide 33
-- Only difference is that it takes input dp instruction (std\_logic\_vector(3 downto 0)) instead of inp(std\_logic\_vector(2 downto 0)) and op(std\_logic\_vector(1 downto 0))
-- ALU takes input Ain, Bin as std\_logic\_vector(31 downto 0)
-- It takes DP instructions as inst as std\_logic\_vector(3 downto 0)
-- It takes Cflag input as std\_logic
-- It outputs result Sout as std\_logic\_vector(31 downto 0)
-- It outputs carry 31 as C31 and carry out as std\_logic
entity ALU is
    port(
        Ain, Bin: in std_logic_vector(31 downto 0);
        inst: in std_logic_vector(3 downto 0);
        Cflag: in std_logic;
        Sout: out std_logic_vector(31 downto 0);
        C31: out std_logic;
        Cout: out std_logic
    );
end ALU;

-- It uses ALUcell as its component
architecture arc of ALU is
    component ALUcell is
        port(
            Ain, Bin, Cin: in std_logic;
            Inp: in std_logic_vector(2 downto 0);
            Op: in std_logic_vector(1 downto 0);
            S, Cout: out std_logic
        );
        end component;

    -- C signal denotes carry
    signal C: std_logic_vector(31 downto 0);
    -- inp for ALUcell
    signal inp: std_logic_vector(2 downto 0);
    -- op for ALUcell
    signal op: std_logic_vector(1 downto 0);
begin

    -- ALUCELL0: ALUcell port map(a, b, ci, inp, op, s, co);
    GENERATE0to30: for i in 0 to 30 generate
        ALUCELL0to30: ALUcell port map(Ain(i), Bin(i), C(i), inp, op, Sout(i), C(i + 1));
    end generate;
    ALUCELL31: ALUcell port map(Ain(31), Bin(31), C(31), inp, op, Sout(31), Cout);
    C31 <= C(31);

    process (Ain, Bin, inst, Cflag) begin
        -- setting up inp values and op values for all dp instructions
        if (inst = "0000") then
            inp <= "100";
            op <= "00";
            C(0) <= '0';
        elsif (inst = "0001") then
            inp <= "100";
            op <= "10";
            C(0) <= '0';
        elsif (inst = "0010") then
            inp <= "110";
            op <= "11";
            C(0) <= '1';
        elsif (inst = "0011") then
            inp <= "101";
            op <= "11";
            C(0) <= '1';
        elsif (inst = "0100") then
            inp <= "100";
            op <= "11";
            C(0) <= '0';
        elsif (inst = "0101") then
            inp <= "100";
            op <= "11";
            C(0) <= Cflag;
        elsif (inst = "0110") then
            inp <= "110";
            op <= "11";
            C(0) <= Cflag;
        elsif (inst = "0111") then
            inp <= "101";
            op <= "11";
            C(0) <= Cflag;
        elsif (inst = "1000") then
            inp <= "100";
            op <= "00";
            C(0) <= '0';
        elsif (inst = "1001") then
            inp <= "100";
            op <= "10";
            C(0) <= '0';
        elsif (inst = "1010") then
            inp <= "110";
            op <= "11";
            C(0) <= '1';
        elsif (inst = "1011") then
            inp <= "100";
            op <= "11";
            C(0) <= '0';
        elsif (inst = "1100") then
            inp <= "100";
            op <= "01";
            C(0) <= '0';
        elsif (inst = "1101") then
            inp <= "000";
            op <= "01";
            C(0) <= '0';
        elsif (inst = "1110") then
            inp <= "110";
            op <= "00";
            C(0) <= '0';
        else
            inp <= "010";
            op <= "01";
            C(0) <= '0';
        end if;
    end process;
end arc;