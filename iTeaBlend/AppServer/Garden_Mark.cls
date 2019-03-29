@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Garden_Mark: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addGardenMark LIKE Garden_Mark.
    DEFINE TEMP-TABLE getGardenMarks LIKE Garden_Mark.
    DEFINE TEMP-TABLE getGardenMark LIKE Garden_Mark.
    DEFINE TEMP-TABLE updateGardenMark LIKE Garden_Mark.
    
    /* Define a dataset for gardenMark to work with update operation */
    DEFINE DATASET gardenMarkSet FOR updateGardenMark.
    
    //CreateGardenMark Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateGardenMark( INPUT Garden_Mark_Code AS CHARACTER, INPUT Description AS CHARACTER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Create the temporary table called addGardenMark
        CREATE addGardenMark.
        
        //Assigning data to Garden_Mark table columns by using parameters passed by the CreateGardenMark Method
        ASSIGN 
            addGardenMark.Garden_Mark_Code = Garden_Mark_Code
            addGardenMark.Description = Description
            addGardenMark.Id = GetNewId(). //Calling the GetNewId function to assign Id to Elevation
        
        //Copy contents of tempory table addGardenMark to Garden_Mark table    
        BUFFER-COPY addGardenMark TO Garden_Mark.
        
        //Defining output parameter values
        error = "".
        successMessage = "Garden_Mark Record Created!".

    END METHOD.

    //DeleteGardenMark Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteGardenMark( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Get Garden_Mark's Id equalent to the Id thst is being passed by the DeleteGardenMark method
        FIND FIRST Garden_Mark WHERE Garden_Mark.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Garden_Mark THEN
        DO:
            DELETE Garden_Mark. //If Garden_Mark availabale Delete that Garden_Mark from the Garden_Mark table
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Garden_Mark Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

    //GetGardenMark Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetGardenMark( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT TABLE getGardenMark, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getGardenMark
        EMPTY TEMP-TABLE getGardenMark.
        
        //Get Elevation's Id equalent to the Id that is being passed by the GetGardenMark method
        FIND FIRST Garden_Mark WHERE Garden_Mark.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE Garden_Mark THEN
        DO:
            CREATE getGardenMark. //If Garden_Mark Available then Create the temporary table called getGardenMark
            BUFFER-COPY Garden_Mark TO getGardenMark. //Copy contents of Elevation table to tempory table getGardenMark  
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for GardenMark Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END. 

    END METHOD.
    
    //GetGardenMarks Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetGardenMarks( OUTPUT error AS CHARACTER, OUTPUT TABLE getGardenMarks, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getGardenMarks
        EMPTY TEMP-TABLE getGardenMarks.
        
        FOR EACH Garden_Mark NO-LOCK: //For Each Garden_Mark
            
            CREATE getGardenMarks. //Create the temporary table called getGardenMarks
            BUFFER-COPY Garden_Mark TO getGardenMarks. //Copy contents of Garden_Mark table to tempory table getGardenMarks
            
            //Defining output parameter values
            error = "".
            successMessage = "Records fetched successfully!".
            
        END.

    END METHOD.

    //GetNewId Method
    METHOD PUBLIC INTEGER GetNewId(  ):
        
        //Definition of Id & initially set It's value to 0
        DEFINE VARIABLE Id AS INTEGER INIT 0.
        
        //Find the Last Garden_Mark
        FIND LAST Garden_Mark NO-LOCK NO-ERROR.
        
        IF AVAILABLE Garden_Mark THEN
        DO:
            Id = Garden_Mark.Id. //If Garden_Mark are available then set the Id value to Last Garden_Mark Id
        END.
        
        REPEAT:
            //Increasing Garden_Mark Id by 1
            FIND FIRST Garden_Mark WHERE Garden_Mark.Id = Id + 1 NO-LOCK NO-ERROR.
            Id = Id + 1.
            
            //If Garden_Marks are not available then leave
            IF NOT AVAILABLE Garden_Mark THEN LEAVE.
        END.
        
        RETURN Id. //Return Id

    END METHOD.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID updateGardenMark( INPUT Id AS INTEGER, INPUT DATASET gardenMarkSet, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Find the first record of the updateGardenMark Temporary table 
        FIND FIRST updateGardenMark.
        
        //Get GardenMark's Id equalent to the Id that is being passed by the updateGardenMark method
        FIND FIRST Garden_Mark WHERE Garden_Mark.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateGardenMark.Id = Id. //Assigning the updateGardenMark Table's Id value to the Id value that is being passed by the updateGardenMark method 
        
        IF AVAILABLE Garden_Mark THEN
        DO:
            BUFFER-COPY updateGardenMark TO Garden_Mark. //If Garden_Mark Available then Copy contents of updateGardenMark Temporary Table to Garden_Mark table
            
            //Defining output parameter values
            error = "".  
            successMessage = "Record Successfully Updated!".
        END.
        ELSE
        DO:
            //Defining output parameter values for GardenMark Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

END CLASS.