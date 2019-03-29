@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Grade: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addGrade LIKE Grade.
    DEFINE TEMP-TABLE getGrades LIKE Grade.
    DEFINE TEMP-TABLE getGrade LIKE Grade.
    DEFINE TEMP-TABLE updateGrade LIKE Grade.
    
    /* Define a dataset for Grade to work with update operation */
    DEFINE DATASET gradeSet FOR updateGrade.
    
    //CreateGrade Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateGrade( INPUT Grade AS CHARACTER, INPUT Description AS CHARACTER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Create the temporary table called addGrade
        CREATE addGrade.
        
        //Assigning data to Grade table columns by using parameters passed by the CreateGrade Method
        ASSIGN 
            addGrade.Grade = Grade
            addGrade.Description = Description
            addGrade.Id = GetNewId(). //Calling the GetNewId function to assign Id to Grade
        
        //Copy contents of tempory table addGrade to Grade table    
        BUFFER-COPY addGrade TO Grade.
        
        //Defining output parameter values
        error = "".
        successMessage = "Grade Record Created!".

    END METHOD.

    //DeleteGrade Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteGrade( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Get Grade table's Id equalent to the Id thst is being passed by the DeleteGrade method
        FIND FIRST Grade WHERE Grade.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Grade THEN
        DO:
            DELETE Grade. //If Grade availabale Delete that Grade from the Grade table
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Grade Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

    //GetGrade Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetGrade( INPUT Id AS INTEGER, OUTPUT error AS CHARACTER, OUTPUT TABLE getGrade, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getGrade
        EMPTY TEMP-TABLE getGrade.
        
        //Get Grade table's Id equalent to the Id that is being passed by the GetGrade method
        FIND FIRST Grade WHERE Grade.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE Grade THEN
        DO:
            CREATE getGrade. //If Grade Available then Create the temporary table called getGrade
            BUFFER-COPY Grade TO getGrade. //Copy contents of Grade table to tempory table getGrade  
            
            //Defining output parameter values
            error = "".
            successMessage = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Grade Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END. 

    END METHOD.

    //GetGrades Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetGrades( OUTPUT error AS CHARACTER, OUTPUT TABLE getGrades, OUTPUT successMessage AS CHARACTER ):
        
        //Empty the Temporary Table called getGrades
        EMPTY TEMP-TABLE getGrades.
        
        FOR EACH Grade NO-LOCK: //For Each Grade
            
            CREATE getGrades. //Create the temporary table called getGrades
            BUFFER-COPY Grade TO getGrades. //Copy contents of Grade table to tempory table getGrades
            
            //Defining output parameter values
            error = "".
            successMessage = "Records fetched successfully!".
            
        END.

    END METHOD.

    //GetNewId Method
    METHOD PUBLIC INTEGER GetNewId(  ):
        
        //Definition of Id & initially set It's value to 0
        DEFINE VARIABLE Id AS INTEGER INIT 0.
        
        //Find the Last Grade
        FIND LAST Grade NO-LOCK NO-ERROR.
        
        IF AVAILABLE Grade THEN
        DO:
            Id = Grade.Id. //If Grades are available then set the Id value to Last Grade Id
        END.
        
        REPEAT:
            //Increasing Grade Id by 1
            FIND FIRST Grade WHERE Grade.Id = Id + 1 NO-LOCK NO-ERROR.
            Id = Id + 1.
            
            //If Grades are not available then leave
            IF NOT AVAILABLE Grade THEN LEAVE.
        END.
        
        RETURN Id. //Return Id

    END METHOD.

    //UpdateGrade Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateGrade( INPUT Id AS INTEGER, INPUT DATASET gradeSet, OUTPUT error AS CHARACTER, OUTPUT successMessage AS CHARACTER ):
        
        //Find the first record of the updateGrade Temporary table 
        FIND FIRST updateGrade.
        
        //Get Grade table's Id equalent to the Id that is being passed by the UpdateGrade method
        FIND FIRST Grade WHERE Grade.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateGrade.Id = Id. //Assigning the updateGrade Table's Id value to the Id value that is being passed by the UpdateGrade method 
        
        IF AVAILABLE Grade THEN
        DO:
            BUFFER-COPY updateGrade TO Grade. //If Grade Available then Copy contents of updateGrade Temporary Table to Grade table
            
            //Defining output parameter values
            error = "". 
            successMessage = "Record Successfully Updated!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Grade Inavailability
            error = "".
            successMessage = "Record Not Found!".
        END.

    END METHOD.

END CLASS.