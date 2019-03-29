@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Traders: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addTrader LIKE Traders.
    DEFINE TEMP-TABLE getTraders LIKE Traders.
    DEFINE TEMP-TABLE getTrader LIKE Traders.
    DEFINE TEMP-TABLE updateTrader LIKE Traders.
    
    /* Define a dataset for Grade to work with update operation */
    DEFINE DATASET traderSet FOR updateTrader.
    
    //CreateTrader Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateTrader( INPUT Trader_Code AS CHARACTER, INPUT Trader_Name AS CHARACTER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Create the temporary table called addTrader
        CREATE addTrader.
        
        //Assigning data to Traders table columns by using parameters passed by the CreateTrader Method
        ASSIGN 
            addTrader.Trader_Code = Trader_Code
            addTrader.Trader_Name = Trader_Name
            addTrader.Id = GetNewId(). //Calling the GetNewId function to assign Id to Traders
        
        //Copy contents of tempory table addTrader to Traders table    
        BUFFER-COPY addTrader TO Traders.
        
        //Defining output parameter values
        error = "".
        successMessage = "Trader Record Created!".

    END METHOD.
    
    //DeleteTrader Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteTrader( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Get Traders table's Id equalent to the Id thst is being passed by the DeleteTrader method
        FIND FIRST Traders WHERE Traders.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Traders THEN
        DO:
            DELETE Traders. //If Traders availabale Delete that Trader from the Traders table
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Traders Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

    //GetNewId Method
    METHOD PUBLIC INTEGER GetNewId(  ):
        
        //Definition of Id & initially set It's value to 0
        DEFINE VARIABLE Id AS INTEGER INIT 0.
        
        //Find the Last Trader
        FIND LAST Traders NO-LOCK NO-ERROR.
        
        IF AVAILABLE Traders THEN
        DO:
            Id = Traders.Id. //If Traders are available then set the Id value to Last Trader Id
        END.
        
        REPEAT:
            //Increasing Traders Id by 1
            FIND FIRST Traders WHERE Traders.Id = Id + 1 NO-LOCK NO-ERROR.
            Id = Id + 1.
            
            //If Traders are not available then leave
            IF NOT AVAILABLE Traders THEN LEAVE.
        END.
        
        RETURN Id. //Return Id

    END METHOD.

    //GetTrader Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetTrader( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT TABLE getTrader, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getTrader
        EMPTY TEMP-TABLE getTrader.
        
        //Get Traders table's Id equalent to the Id that is being passed by the GetTrader method
        FIND FIRST Traders WHERE Traders.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE Traders THEN
        DO:
            CREATE getTrader. //If Traders Available then Create the temporary table called getTrader
            BUFFER-COPY Traders TO getTrader. //Copy contents of Traders table to tempory table getTrader  
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Traders Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

    //GetTraders Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetTraders( OUTPUT error AS CHARACTER, OUTPUT TABLE getTraders, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getTraders
        EMPTY TEMP-TABLE getTraders.
        
        FOR EACH Traders NO-LOCK: //For Each Traders
            
            CREATE getTraders. //Create the temporary table called getTraders
            BUFFER-COPY Traders TO getTraders. //Copy contents of Traders table to tempory table getTraders
            
            //Defining output parameter values
            error = "".
            successMessage = "Records fetched successfully!".
            
        END.

    END METHOD.

    //UpdateTrader Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateTrader( INPUT Id AS INTEGER, INPUT DATASET traderSet, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Find the first record of the updateTrader Temporary table 
        FIND FIRST updateTrader.
        
        //Get Traders table's Id equalent to the Id that is being passed by the UpdateTrader method
        FIND FIRST Traders WHERE Traders.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateTrader.Id = Id. //Assigning the updateTrader Table's Id value to the Id value that is being passed by the UpdateTrader method 
        
        IF AVAILABLE Traders THEN
        DO:
            BUFFER-COPY updateTrader TO Traders. //If Traders Available then Copy contents of updateTrader Temporary Table to Traders table
            
            //Defining output parameter values
            error = "".  
            successMessage = "Record Successfully Updated!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Traders Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

END CLASS.