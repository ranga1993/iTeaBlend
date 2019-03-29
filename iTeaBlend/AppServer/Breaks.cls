@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Breaks: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addBreak LIKE Breaks.
    DEFINE TEMP-TABLE getBreaks LIKE Breaks.
    DEFINE TEMP-TABLE getBreak LIKE Breaks.
    DEFINE TEMP-TABLE updateBreak LIKE Breaks.
    
    /* Define a dataset for Breaks to work with update operation */
    DEFINE DATASET breakSet FOR updateBreak.

    //CreateBreak Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateBreak( INPUT Break_Code AS CHARACTER, INPUT Description AS CHARACTER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Create the temporary table called addBreak
        CREATE addBreak.
        
        //Assigning data to Breaks table columns by using parameters passed by the CreateBreak Method
        ASSIGN 
            addBreak.Break_Code = Break_Code
            addBreak.Description = Description
            addBreak.Id = GetNewId(). //Calling the GetNewId function to assign Id to Breaks
        
        //Copy contents of tempory table addBreak to Breaks table    
        BUFFER-COPY addBreak TO Breaks.
        
        //Defining output parameter values
        error = "".
        successMessage = "Breaks Record Created!".

    END METHOD.

    //DeleteBreaks Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteBreaks( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Get Break table's Id equalent to the Id thst is being passed by the DeleteBreaks method
        FIND FIRST Breaks WHERE Breaks.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Breaks THEN
        DO:
            DELETE Breaks. //If Breaks availabale Delete that Breaks from the Breaks table
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Breaks Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

    //GetBreak Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetBreak( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT TABLE getBreak, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getBreak
        EMPTY TEMP-TABLE getBreak.
        
        //Get Breaks table's Id equalent to the Id that is being passed by the GetBreak method
        FIND FIRST Breaks WHERE Breaks.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE Breaks THEN
        DO:
            CREATE getBreak. //If Breaks Available then Create the temporary table called getBreak
            BUFFER-COPY Breaks TO getBreak. //Copy contents of Breaks table to tempory table getBreak  
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Breaks Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END. 

    END METHOD.

    //GetBreaks Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetBreaks( OUTPUT error AS CHARACTER, OUTPUT TABLE getBreaks, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getBreaks
        EMPTY TEMP-TABLE getBreaks.
        
        FOR EACH Breaks NO-LOCK: //For Each Breaks
            
            CREATE getBreaks. //Create the temporary table called getBreaks
            BUFFER-COPY Breaks TO getBreaks. //Copy contents of Breaks table to tempory table getBreaks
            
            //Defining output parameter values
            error = "".
            successMessage = "Records fetched successfully!".
            
        END.

    END METHOD.

    //GetNewId Method
    METHOD PUBLIC INTEGER GetNewId(  ):
        
        //Definition of Id & initially set It's value to 0
        DEFINE VARIABLE Id AS INTEGER INIT 0.
        
        //Find the Last Breaks
        FIND LAST Breaks NO-LOCK NO-ERROR.
        
        IF AVAILABLE Breaks THEN
        DO:
            Id = Breaks.Id. //If Breaks are available then set the Id value to Last Breaks Id
        END.
        
        REPEAT:
            //Increasing Breaks Id by 1
            FIND FIRST Breaks WHERE Breaks.Id = Id + 1 NO-LOCK NO-ERROR.
            Id = Id + 1.
            
            //If Breaks are not available then leave
            IF NOT AVAILABLE Breaks THEN LEAVE.
        END.
        
        RETURN Id. //Return Id

    END METHOD.    

    //UpdateBreaks Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateBreaks( INPUT Id AS INTEGER, INPUT DATASET breakSet, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Find the first record of the updateBreak Temporary table 
        FIND FIRST updateBreak.
        
        //Get Breaks table's Id equalent to the Id that is being passed by the UpdateBreaks method
        FIND FIRST Breaks WHERE Breaks.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateBreak.Id = Id. //Assigning the updateBreak Table's Id value to the Id value that is being passed by the UpdateBreaks method 
        
        IF AVAILABLE Breaks THEN
        DO:
            BUFFER-COPY updateBreak TO Breaks. //If Breaks Available then Copy contents of updateBreak Temporary Table to Breaks table
            
            //Defining output parameter values
            error = "".  
            successMessage = "Record Successfully Updated!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Breaks Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.    

END CLASS.