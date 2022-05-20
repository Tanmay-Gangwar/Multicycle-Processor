library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

    -- It shifts/rotate input by given amount according to the given operation
    -- takes input a as std logic vector(31 downto 0);
    -- it takes operation as op as std logic vector(1 downto 0);
    -- op = "00" => LSL
    -- op = "01" => LSR
    -- op = "10" => ASR
    -- op = "11" => ROR
    -- shift = 1 => we have to return shifted output
    -- shift = 0 => we have to return output same as input
    -- It output cout as std logic
entity bitOperator is
    port (
        a: in std_logic_vector(31 downto 0);
        Op: in std_logic_vector(1 downto 0);
        amount: in std_logic_vector(4 downto 0);
        o: out std_logic_vector(31 downto 0);
        cout: out std_logic 
    );
end entity;

architecture arc of bitOperator is
    component bitoperator1 is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            shift: in std_logic;
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    component bitoperator2 is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            shift: in std_logic;
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    component bitoperator4 is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            shift: in std_logic;
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    component bitoperator8 is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            shift: in std_logic;
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    component bitoperatorF is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            shift: in std_logic;
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    -- temporary out signals for bitoperator1, 2, 4 and 8
    -- temporary carry signals for bitoperator1, 2, 4, 8 and 16
    signal o1, o2, o4, o8: std_logic_vector(31 downto 0);
    signal c1, c2, c4, c8, c16: std_logic;
    begin
        bit1: bitoperator1 port map(a, Op, amount(0), o1, c1);
        bit2: bitoperator2 port map(o1, Op, amount(1), o2, c2);
        bit4: bitoperator4 port map(o2, Op, amount(2), o4, c4);
        bit8: bitoperator8 port map(o4, Op, amount(3), o8, c8);
        bit16: bitoperatorF port map(o8, Op, amount(4), o, c16);
        process (amount, c1, c2, c4, c8, c16) is 
            begin
                if (amount(4) = '1') then cout <= c16;
                elsif (amount(3) = '1') then cout <= c8;
                elsif (amount(2) = '1') then cout <= c4;
                elsif (amount(1) = '1') then cout <= c2;
                elsif (amount(0) = '1') then cout <= c1;
                else cout <= '0';
                end if;
            end process;
    end arc;