-- SPI Mode 2 works ok :)
--

architecture CtrlRx2 of TestCtrl is

    signal TestDone   : integer_barrier := 1;
    signal TestActive : boolean         := TRUE;
    signal TbID       : AlertLogIDType;

begin

    ------------------------------------------------------------
    -- Bench Environment Init
    ------------------------------------------------------------
    ControlProc : process
    begin
        -- Initialization of test
        SetTestName("TbSpi_CtrlRx2");
        SetLogEnable(PASSED, TRUE);
        TbID <= GetAlertLogID("TB");

        -- Wait for testbench initialization
        wait for 0 ns; wait for 0 ns;
        TranscriptOpen(OSVVM_RESULTS_DIR & "TbSpi_CtrlRx2.txt");
        SetTranscriptMirror(TRUE) ;

        -- Wait for Design Reset
        wait until n_Reset = '1';
        ClearAlerts;

        -- Wait for test to finish
        WaitForBarrier(TestDone, 50 ms);
        AlertIf(now >= 50 ms, "Test finished due to timeout");
        AlertIf(GetAffirmCount < 1, "Test is not Self-Checking");

        TranscriptClose;

        EndOfTestReports;
        std.env.stop;
        wait;
    end process ControlProc;

    ------------------------------------------------------------
    -- SPI Controller RX Test: Controller Process
    ------------------------------------------------------------
    SpiControllerTest : process
        variable SpiControllerID    : AlertLogIDType;
        variable Received, Expected : std_logic_vector (7 downto 0);
        variable TransactionCount   : integer := 0;

    begin
        -- Enable logging for SPI Controller and Peripheral
        GetAlertLogID(SpiControllerRec, SpiControllerID);
        SetLogEnable(SpiControllerID, INFO, TRUE);
        WaitForClock(SpiControllerRec, 3);

        -- Test Begins
        SetSpiMode(SpiControllerRec, 2);
        for idx in 21 downto 0 loop
            SendAsync(SpiControllerRec, X"0");
        end loop;
        -- Receive sequence 1
        for i in 1 to 5 loop
            case i is
            when 1 =>  Expected := (X"50");
            when 2 =>  Expected := (X"51");
            when 3 =>  Expected := (X"52");
            when 4 =>  Expected := (X"53");
            when 5 =>  Expected := (X"54");
            end case ;
            Get(SpiControllerRec, Received);
            AffirmIfEqual(SpiControllerID, Received, Expected);
        end loop;

        -- Receive sequence 2
        for i in 1 to 5 loop
            case i is
            when 1 =>  Expected := (X"60");
            when 2 =>  Expected := (X"61");
            when 3 =>  Expected := (X"62");
            when 4 =>  Expected := (X"63");
            when 5 =>  Expected := (X"64");
            end case ;
        Get(SpiControllerRec, Received);
        AffirmIfEqual(SpiControllerID, Received, Expected);
        end loop;

        -- Receive sequence 3
        for i in 1 to 5 loop
            case i is
            when 1 =>  Expected := (X"70");
            when 2 =>  Expected := (X"71");
            when 3 =>  Expected := (X"72");
            when 4 =>  Expected := (X"73");
            when 5 =>  Expected := (X"74");
            end case ;
        Get(SpiControllerRec, Received);
        AffirmIfEqual(SpiControllerID, Received, Expected);
        end loop;

        -- Receive sequence 4
        for i in 1 to 5 loop
            case i is
            when 1 =>  Expected := (X"80");
            when 2 =>  Expected := (X"81");
            when 3 =>  Expected := (X"82");
            when 4 =>  Expected := (X"83");
            when 5 =>  Expected := (X"84");
            end case ;
        Get(SpiControllerRec, Received);
        AffirmIfEqual(SpiControllerID, Received, Expected);
        end loop;

        -- Test ends
        TestActive <= FALSE;
        WaitForBarrier(TestDone);
        wait;
    end process SpiControllerTest;

    ------------------------------------------------------------
    -- SPI Controller RX Test: Peripheral Process
    ------------------------------------------------------------
    SpiPeripheralTest : process
        variable SpiPeripheralId    : AlertLogIDType;
        variable TransactionCount   : integer := 0;

    begin

    GetAlertLogID(SpiPeripheralRec,  SpiPeripheralId);
    SetLogEnable(SpiPeripheralID, INFO, TRUE);
    WaitForClock(SpiPeripheralRec, 2);

    -- Test Begins

    --SendAsync sequence 1
    SendAsync(SpiPeripheralRec, X"50");
    SendAsync(SpiPeripheralRec, X"51");
    SendAsync(SpiPeripheralRec, X"52");
    SendAsync(SpiPeripheralRec, X"53");
    SendAsync(SpiPeripheralRec, X"54");

    --SendAsync sequence 2
    SendAsync(SpiPeripheralRec, X"60");
    SendAsync(SpiPeripheralRec, X"61");
    SendAsync(SpiPeripheralRec, X"62");
    SendAsync(SpiPeripheralRec, X"63");
    SendAsync(SpiPeripheralRec, X"64");

    --SendAsync sequence 3
    SendAsync(SpiPeripheralRec, X"70");
    SendAsync(SpiPeripheralRec, X"71");
    SendAsync(SpiPeripheralRec, X"72");
    SendAsync(SpiPeripheralRec, X"73");
    SendAsync(SpiPeripheralRec, X"74");

    --SendAsync sequence 4
    SendAsync(SpiPeripheralRec, X"80");
    SendAsync(SpiPeripheralRec, X"81");
    SendAsync(SpiPeripheralRec, X"82");
    SendAsync(SpiPeripheralRec, X"83");
    SendAsync(SpiPeripheralRec, X"84");

    -- Test Done
    WaitForBarrier(TestDone);
    wait;
    end process SpiPeripheralTest;
end CtrlRx2;

configuration TbSpi_CtrlRx2 of TbSpi is
    for TestHarness
        for TestCtrl_1 : TestCtrl
            use entity work.TestCtrl(CtrlRx2);
        end for;
    end for;
end TbSpi_CtrlRx2;
