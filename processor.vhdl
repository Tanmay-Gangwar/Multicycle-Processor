library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- It only takes input clock as clk as std logic
-- It assembles all the components required in a processor
entity processor is
    port (clk: in std_logic);
end processor;

architecture arc of processor is
    -- program Counter maintains the instruction which is being executing
    component programCounter is
        port (
            clk: in std_logic;
            wrSignal: in std_logic;
            newPc: in std_logic_vector(8 downto 0);
            currPc: out std_logic_vector(8 downto 0)
        );
    end component;

    -- memory
    component memory is
        port(
            wrSignal: in std_logic;
            addr: in std_logic_vector(8 downto 0);
            byteSig: in std_logic_vector(3 downto 0);
            dataIn: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            dataOut: out std_logic_vector(31 downto 0)
        );
    end component;

    -- data Register to store std_logic_vector
    component dataRegister
        port(
            clk: in std_logic;
            wrSignal: in std_logic;
            newData: in std_logic_vector(31 downto 0);
            currData: out std_logic_vector(31 downto 0)
        );
    end component;

    -- register file is array of 16 std_logic_vectors which acts as registers
    component registerFile is
        port(
            regWrite: in std_logic;
            rdAddr1, rdAddr2, wrAddr: in std_logic_vector(3 downto 0);
            wrData: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            rdData1, rdData2: out std_logic_vector(31 downto 0)
        );
    end component;

    -- Arithmatic and Logical unit
    component ALU is
        port(
            Ain, Bin: in std_logic_vector(31 downto 0);
            inst: in std_logic_vector(3 downto 0);
            Cflag: in std_logic;
            Sout: out std_logic_vector(31 downto 0);
            C31: out std_logic;
            Cout: out std_logic
        );
    end component;

    -- flags maintain flags
    component flags is
        port(
            set: in std_logic;
            s: in std_logic_vector(31 downto 0);
            c31, c32: in std_logic;
            Nflag, Zflag, Cflag, Vflag: out std_logic
        );
    end component;

    -- check is branch condition is valid or not
    component predicate is
        port(
            cond: in std_logic_vector(3 downto 0);
            Nflag, Zflag, Cflag, Vflag: in std_logic;
            result: out std_logic
        );
    end component;

    -- bit Operator performs shift and rotate instructions
    component bitOperator is
        port (
            a: in std_logic_vector(31 downto 0);
            Op: in std_logic_vector(1 downto 0);
            amount: in std_logic_vector(4 downto 0);
            o: out std_logic_vector(31 downto 0);
            cout: out std_logic 
        );
    end component;

    component multiplier is
        port (
            allow: in std_logic;
            a: in std_logic_vector(31 downto 0);
            b: in std_logic_vector(31 downto 0);
            c: in std_logic_vector(63 downto 0);
            sgn: in std_logic;
            acc: in std_logic;
            res: out std_logic_vector(63 downto 0)
        );
        end component;

    -- signals
    signal programCounter_newPc: std_logic_vector(8 downto 0);
    signal programCounter_currPc: std_logic_vector(8 downto 0);
    signal memory_addr: std_logic_vector(8 downto 0);
    signal memory_dataOut: std_logic_vector(31 downto 0);
    signal memory_byteSig: std_logic_vector(3 downto 0);
    signal instructionRegister_currData: std_logic_vector(31 downto 0);
    signal dataRegister_currData: std_logic_vector(31 downto 0);
    signal dataRegister_dataIn: std_logic_vector(31 downto 0);
    signal registerA_currData: std_logic_vector(31 downto 0);
    signal registerB_currData: std_logic_vector(31 downto 0);
    signal registerX_currData: std_logic_vector(31 downto 0);
    signal registerY_dataIn: std_logic_vector(31 downto 0);
    signal registerY_currData: std_logic_vector(31 downto 0);
    signal resultRegister_currData: std_logic_vector(31 downto 0);
    signal registerFile_rdAddr1: std_logic_vector(3 downto 0);
    signal registerFile_rdAddr2: std_logic_vector(3 downto 0);
    signal registerFile_wrAddr: std_logic_vector(3 downto 0);
    signal registerFile_wrData: std_logic_vector(31 downto 0);
    signal registerFile_rdData1, registerFile_rdData2: std_logic_vector(31 downto 0);
    signal alu_Ain, alu_Bin: std_logic_vector(31 downto 0);
    signal alu_Cflag: std_logic;
    signal alu_Sout: std_logic_vector(31 downto 0);
    signal alu_C31: std_logic;
    signal alu_Cout: std_logic;
    signal flags_Nflag, flags_Zflag, flags_Cflag, flags_Vflag: std_logic;
    signal FSM_PW, FSM_MW, FSM_IW, FSM_DW, FSM_XW, FSM_YW, FSM_RW, FSM_AW, FSM_BW, FSM_Fset, FSM_ReW: std_logic;
    signal FSM_OP: std_logic_vector(3 downto 0);
    signal predicate_result: std_logic;
    signal stateCounter: std_logic_vector(3 downto 0) := "1111";
    signal bitOperator_a: std_logic_vector(31 downto 0);
    signal bitOperator_Op: std_logic_vector(1 downto 0);
    signal bitOperator_amount: std_logic_vector(4 downto 0);
    signal bitOperator_o: std_logic_vector(31 downto 0);
    signal bitOperator_cout: std_logic;
    signal multiplier_c, multiplier_res: std_logic_vector(63 downto 0);
    signal multiplier_allow: std_logic := '0';
    begin
        programCounter0: programCounter port map(clk, FSM_PW, programCounter_newPc, programCounter_currPc);
        memory0: memory port map(FSM_MW, memory_addr, memory_byteSig, registerB_currData, clk, memory_dataOut);
        dataRegister0: dataRegister port map(clk, FSM_DW, dataRegister_dataIn, dataRegister_currData);
        instructionRegister0: dataRegister port map(clk, FSM_IW, memory_dataOut, instructionRegister_currData);
        registerA0: dataRegister port map(clk, FSM_AW, registerFile_rdData1, registerA_currData);
        registerB0: dataRegister port map(clk, FSM_BW, registerFile_rdData2, registerB_currData);
        registerX0: dataRegister port map(clk, FSM_XW, registerFile_rdData2, registerX_currData);
        registerY0: dataRegister port map(clk, FSM_YW, registerY_dataIn, registerY_currData);
        resultRegister0: dataRegister port map(clk, FSM_ReW, alu_Sout, resultRegister_currData);
        registerFile0: registerFile port map(FSM_RW, registerFile_rdAddr1, registerFile_rdAddr2, registerFile_wrAddr, registerFile_wrData, clk, registerFile_rdData1, registerFile_rdData2);
        bitOperator0: bitOperator port map(bitOperator_a, bitOperator_Op, bitOperator_amount, bitOperator_o, bitOperator_cout);
        alu0: ALU port map(alu_Ain, alu_Bin, FSM_OP, alu_Cflag, alu_Sout, alu_C31, alu_Cout);
        flags0: flags port map(FSM_Fset, alu_Sout, alu_C31, alu_Cout, flags_Nflag, flags_Zflag, flags_Cflag, flags_Vflag);
        predicate0: predicate port map(instructionRegister_currData(31 downto 28), flags_Nflag, flags_Zflag, flags_Cflag, flags_Vflag, predicate_result);
        multiplier0: multiplier port map(multiplier_allow, registerB_currData, registerX_currData, multiplier_c, instructionRegister_currData(22), instructionRegister_currData(21), multiplier_res);

        -- fsm states from 0 to 10 and state 15 is null state
        process (clk) is
            begin
                if (instructionRegister_currData = X"00000000") then stateCounter <= "1111";
                elsif (stateCounter = "0000") then stateCounter <= "0001";
                elsif (stateCounter = "0001") then
                    if ((instructionRegister_currData(27 downto 22) = "000000" or instructionRegister_currData(27 downto 23) = "00001") and instructionRegister_currData(7 downto 4) = "1001") then stateCounter <= "1011";
                    elsif (instructionRegister_currData(27 downto 26) = "01" or (instructionRegister_currData(27 downto 25) = "000" and instructionRegister_currData(7) = '1' and instructionRegister_currData(4) = '1')) then stateCounter <= "0100";
                    elsif (instructionRegister_currData(27 downto 26) = "00") then stateCounter <= "0011";
                    else stateCounter <= "0010";
                    end if;
                elsif (stateCounter = "0010") then stateCounter <= "0000";
                elsif (stateCounter = "0011") then stateCounter <= "0100";
                elsif (stateCounter = "0100") then 
                    if (instructionRegister_currData(27 downto 26) = "01" or (instructionRegister_currData(27 downto 25) = "000" and instructionRegister_currData(7) = '1' and instructionRegister_currData(4) = '1')) then stateCounter <= "0111";
                    else stateCounter <= "0101";
                    end if;
                elsif (stateCounter = "0101") then stateCounter <= "0110";
                elsif (stateCounter = "0110") then stateCounter <= "0000";
                elsif (stateCounter = "0111") then
                    if (instructionRegister_currData(20) = '0') then stateCounter <= "1000";
                    else stateCounter <= "1001";
                    end if;
                elsif (stateCounter = "1000") then stateCounter <= "0000";
                elsif (stateCounter = "1001") then stateCounter <= "1010";
                elsif (stateCounter = "1010") then stateCounter <= "0000";
                elsif (stateCounter = "1011") then stateCounter <= "1100";
                elsif (stateCounter = "1100") then 
                    if (instructionRegister_currData(27 downto 22) = "000000") then stateCounter <= "1110";
                    else stateCounter <= "1101"; end if;
                elsif (stateCounter = "1101") then stateCounter <= "1110";
                else stateCounter <= "0000";
                end if;
            end process;

            --sets program Counter new Pc
            process (alu_Sout) is
                begin
                    programCounter_newPc(8 downto 2) <= alu_Sout(6 downto 0);
                    programCounter_newPc(1 downto 0) <= "00";
                end process;

            -- assigns memory byteSignal
            process (stateCounter, instructionRegister_currData) is
                begin
                    if (stateCounter = "0000") then memory_byteSig <= "1111";
                    elsif (instructionRegister_currData(27 downto 26) = "01") then
                        if (instructionRegister_currData(22) = '1') then memory_byteSig <= "0001";
                        else memory_byteSig <= "1111";
                        end if;
                    elsif (instructionRegister_currData(27 downto 25) = "000" and instructionRegister_currData(7) = '1' and instructionRegister_currData(4) = '1') then
                        if (instructionRegister_currData(5) = '0') then memory_byteSig <= "0001";
                        else memory_byteSig <= "0011";
                        end if;
                    end if;
                end process;

            -- assigns dataRegister_dataIn
            process (instructionRegister_currData, memory_dataOut) is
                begin
                    if (instructionRegister_currData(27 downto 25) = "000" and instructionRegister_currData(7 downto 4) = "1111") then 
                        dataRegister_dataIn(15 downto 0) <= memory_dataOut(15 downto 0);
                        if (memory_dataOut(15) = '1') then dataRegister_dataIn(31 downto 16) <= X"FFFF";
                        else dataRegister_dataIn(31 downto 16) <= X"0000";
                        end if;
                    elsif (instructionRegister_currData(27 downto 25) = "000" and instructionRegister_currData(7 downto 4) = "1101") then
                        dataRegister_dataIn(7 downto 0) <= memory_dataOut(7 downto 0);
                        if (memory_dataOut(7) = '1') then dataRegister_dataIn(31 downto 8) <= X"FFFFFF";
                        else dataRegister_dataIn(31 downto 8) <= X"000000";
                        end if;
                    else dataRegister_dataIn <= memory_dataOut;
                    end if;
                end process;

            process (stateCounter, instructionRegister_currData) is
                begin
                    if (stateCounter = "1011") then registerFile_rdAddr1 <= instructionRegister_currData(15 downto 12);
                    else registerFile_rdAddr1 <= instructionRegister_currData(19 downto 16); end if;
                end process;
            
            process (stateCounter, registerFile_rdData1, bitOperator_o) is
                begin
                    if (stateCounter = "1011") then registerY_dataIn <= registerFile_rdData1;
                    else registerY_dataIn <= bitOperator_o; end if;
                end process;
            
            process (registerY_currData, registerA_currData) is
                begin
                    multiplier_c(31 downto 0) <= registerY_currData;
                    if (instructionRegister_currData(27 downto 23) = "00001") then multiplier_c(63 downto 32) <= registerA_currData;
                    else multiplier_c(63 downto 32) <= X"00000000"; end if;
                end process;
        
            -- maintains fsm signals according to states
            process (stateCounter, programCounter_currPc, resultRegister_currData, instructionRegister_currData, dataRegister_currData, registerA_currData, registerY_currData, flags_Cflag, predicate_result, flags_Cflag, multiplier_res) is
                begin
                    -- assigns FSM_PW
                    if (instructionRegister_currData = x"00000000") then FSM_PW <= '0';
                    elsif (stateCounter = "0000" or (stateCounter = "0010" and instructionRegister_currData(27 downto 25) = "101"  and predicate_result = '1')) then FSM_PW <= '1';
                    else FSM_PW <= '0'; 
                    end if;

                    -- assigns FSM_MW
                    if (stateCounter = "1000") then FSM_MW <= '1';
                    else FSM_MW <= '0'; end if;

                    -- assigns memory address
                    if (stateCounter = "0000") then memory_addr <= programCounter_currPc;
                    elsif (instructionRegister_currData(24) = '0') then memory_addr <= registerA_currData(8 downto 0);
                    else memory_addr <= resultRegister_currData(8 downto 0); end if;

                    -- assigns FSM_DW
                    if (stateCounter = "1001") then FSM_DW <= '1';
                    else FSM_DW <= '0'; end if;

                    -- assigns FSM_IW
                    if (stateCounter = "0000") then FSM_IW <= '1';
                    else FSM_IW <= '0'; end if;

                    -- assigns FSM_AW
                    if (stateCounter = "0001") then FSM_AW <= '1';
                    else FSM_AW <= '0'; end if;

                    -- assigns FSM_BW
                    if (stateCounter = "0001" or stateCounter = "0111") then FSM_BW <= '1';
                    else FSM_BW <= '0'; end if;

                    -- assigns FSM_XW
                    if (stateCounter = "0011" or stateCounter = "1011") then FSM_XW <= '1';
                    else FSM_XW <= '0'; end if;

                    -- assigns FSM_YW
                    if (stateCounter = "0100" or stateCounter = "1011") then FSM_YW <= '1';
                    else FSM_YW <= '0'; end if;

                    -- assigns FSM_ReW
                    if (stateCounter = "0101" or stateCounter = "0111") then FSM_ReW <= '1';
                    else FSM_ReW <= '0'; end if;

                    -- assigns FSM_RW
                    if ((stateCounter = "0110" and instructionRegister_currData(27 downto 26) = "00" and not (FSM_op(3 downto 2) = "10")) or stateCounter = "1010") then FSM_RW <= '1';
                    elsif ((stateCounter = "1000" or stateCounter = "1001") and (instructionRegister_currData(24) = '0' or instructionRegister_currData(21) = '1')) then FSM_RW <= '1'; 
                    elsif (stateCounter = "1101" or stateCounter = "1110") then FSM_RW <= '1';
                    else FSM_RW <= '0'; end if;

                    -- assigns registerFile address 2
                    if (stateCounter = "0001") then registerFile_rdAddr2 <= instructionRegister_currData(3 downto 0);
                    elsif (stateCounter = "0011" or stateCounter = "1011") then registerFile_rdAddr2 <= instructionRegister_currData(11 downto 8);
                    else registerFile_rdAddr2 <= instructionRegister_currData(15 downto 12); end if;

                    -- assigns registerFile write address
                    if (stateCounter = "0110" or stateCounter = "1010" or stateCounter = "1101") then registerFile_wrAddr <= instructionRegister_currData(15 downto 12);
                    else registerFile_wrAddr <= instructionRegister_currData(19 downto 16); end if;

                    -- assigns registerFile write Data
                    if (stateCounter = "1010") then registerFile_wrData <= dataRegister_currData;
                    elsif (stateCounter = "1101") then registerFile_wrData <= multiplier_res(31 downto 0);
                    elsif (stateCounter = "1110") then
                        if (instructionRegister_currData(27 downto 22) = "000000") then registerFile_wrData <= multiplier_res(31 downto 0);
                        else registerFile_wrData <= multiplier_res(63 downto 32);
                        end if;
                    else registerFile_wrData <= resultRegister_currData; end if;

                    -- assigns alu_Ain
                    if (stateCounter = "0000" or stateCounter = "0010") then
                        alu_Ain(6 downto 0) <= programCounter_currPc(8 downto 2);
                        alu_Ain(31 downto 7) <= "0000000000000000000000000";
                    else alu_Ain <= registerA_currData;
                    end if;

                    -- assigns alu_Bin
                    if (stateCounter = "0000") then alu_Bin <= X"00000001";
                    elsif (stateCounter = "0010") then 
                        alu_Bin <= std_logic_vector(to_signed(to_integer(signed(instructionRegister_currData(23 downto 0))), 32));
                    else alu_Bin <= registerY_currData;
                    end if;
                    
                    -- assigns FSM_OP
                    if (stateCounter = "0000") then FSM_OP <= "0100";
                    elsif (stateCounter = "0111") then
                        if (instructionRegister_currData(23) = '1') then FSM_OP <= "0100";
                        else FSM_OP <= "0010";
                        end if;
                    elsif (stateCounter = "0010") then FSM_OP <= "0101";
                    else FSM_OP <= instructionRegister_currData(24 downto 21);
                    end if;
                    
                    -- assigns alu_Cflag
                    if (stateCounter = "0010") then alu_Cflag <= '1';
                    else alu_Cflag <= flags_Cflag;
                    end if;

                    if (stateCounter = "1100" or stateCounter = "1101" or stateCounter = "1110") then multiplier_allow <= '1';
                    else multiplier_allow <= '0';
                    end if;
                    
                    -- assigns FSM_Fset
                    if ((stateCounter = "0100" or stateCounter ="0101") and instructionRegister_currData(27 downto 26) = "00" and instructionRegister_currData(20) = '1') then FSM_Fset <= '1';
                    else FSM_Fset <= '0';
                    end if;
                end process;

            -- maintains signals for bitOperations for shifting and rotating
            process (stateCounter, instructionRegister_currData, registerB_currData, registerX_currData) is
                begin
                    if (stateCounter = "0100") then
                        if (instructionRegister_currData(27 downto 26) = "01") then
                            if (instructionRegister_currData(25) = '0') then
                                bitOperator_a(11 downto 0) <= instructionRegister_currData(11 downto 0);
                                bitOperator_a(31 downto 12) <= X"00000";
                                bitOperator_Op <= "00";
                                bitOperator_amount <= "00000";
                            else
                                bitOperator_a <= registerB_currData;
                                bitOperator_Op <= instructionRegister_currData(6 downto 5);
                                bitOperator_amount <= instructionRegister_currData(11 downto 7);
                            end if;
                        elsif (instructionRegister_currData(27 downto 25) = "000" and instructionRegister_currData(7) = '1' and instructionRegister_currData(4) = '1') then
                            if (instructionRegister_currData(22) = '0') then
                                bitOperator_a <= registerB_currData;
                                bitOperator_Op <= "00";
                                bitOperator_amount <= "00000";
                            else
                                bitOperator_a(3 downto 0) <= instructionRegister_currData(3 downto 0);
                                bitOperator_a(7 downto 4) <= instructionRegister_currData(11 downto 8);
                                bitOperator_a(31 downto 8) <= X"000000";
                                bitOperator_Op <= "00";
                                bitOperator_amount <= "00000";
                            end if;
                        elsif (instructionRegister_currData(27 downto 25) = "000") then 
                            bitOperator_a <= registerB_currData;
                            bitOperator_Op <= instructionRegister_currData(6 downto 5);
                            if (instructionRegister_currData(4) = '0') then bitOperator_amount <= instructionRegister_currData(11 downto 7);
                            else bitOperator_amount <= registerX_currData(4 downto 0);
                            end if;
                        elsif (instructionRegister_currData(27 downto 25) = "001") then
                            bitOperator_a(7 downto 0) <= instructionRegister_currData(7 downto 0);
                            bitOperator_a(31 downto 8) <= X"000000";
                            bitOperator_Op <= "11";
                            bitOperator_amount(4 downto 1) <= instructionRegister_currData(11 downto 8);
                            bitOperator_amount(0) <= '0';
                        end if;
                    end if;
                end process;
    end arc;