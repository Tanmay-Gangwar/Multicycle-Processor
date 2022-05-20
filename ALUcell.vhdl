library ieee;
use ieee.std_logic_1164.all;

-- It is an ALU cell similar as described in Lecture 8 slide 22.
-- It takes input $A_i$, $B_i$, $C_i$ as Ain, Bin and Cin
-- It takes input control as std\_logic\_vector(2 downto 0)
-- It take operation as logic\_vector(1 downto 0);
-- It outputs $C_{i+1}$ as Cout and $S_{i}$ as S
entity ALUcell is
port(
    Ain, Bin, Cin: in std_logic;    
    Inp: in std_logic_vector(2 downto 0);
    Op: in std_logic_vector(1 downto 0);
    S, Cout: out std_logic
);
end ALUcell;
    
architecture arc of ALUcell is
    signal a, b: std_logic;
begin
    -- Effective a to take part in operations
    a <= (Ain and Inp(2)) xor Inp(0);
    -- Effective b to take part in operations
    b <= Bin xor Inp(1);
    Cout <= (a and b) or (b and Cin) or (Cin and a);
    process(a, b, Cin, Op) begin
        if (Op = "00") then     -- op = 0 => AND
            S <= a and b;
        elsif (Op = "01") then  -- op = 1 => OR
            S <= a or b;
        elsif (Op = "10") then  -- op = 2 => XOR
            S <= a xor b;
        else                    -- op = 3 => ADD
            S <= a xor b xor Cin;
        end if;
    end process;
end arc;