@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.
USING Progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Elevation: 
    
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addElevation LIKE Elevation.
    DEFINE TEMP-TABLE getElevations LIKE Elevation.
    DEFINE TEMP-TABLE getElevation LIKE Elevation.
    DEFINE TEMP-TABLE updateElevation LIKE Elevation.
    
   //Define Temporary Table called res_status
    DEFINE TEMP-TABLE res_status NO-UNDO  
        FIELD status_code AS CHARACTER FORMAT "x(36)" 
        FIELD status_description AS CHARACTER FORMAT "x(100)".
        
    /* Define a dataset for elevation to work with update operation */
    DEFINE DATASET elevationSet FOR updateElevation.
    
    
    //CreateElevation Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateElevation( INPUT Elevation_Code AS CHARACTER, INPUT Description AS CHARACTER, OUTPUT TABLE res_status ):
        //Create the temporary table called addElevation
        CREATE addElevation.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
                
        //Assigning data to Elevation table columns by using parameters passed by the CreateElevation Method
        ASSIGN 
            addElevation.Elevation_Code = Elevation_Code
            addElevation.Description = Description
            addElevation.Id = GetNewId(). //Calling the GetNewId function to assign Id to Elevation
        
        //Copy contents of tempory table addElevation to Elevation table    
        BUFFER-COPY addElevation TO Elevation.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Defining output parameter value
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Elevation Record Created!".

    END METHOD.

    //DeleteElevation method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteElevation( INPUT Id AS INTEGER, OUTPUT TABLE res_status ):
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Elevation's Id equalent to the Id thst is being passed by the DeleteElevation method
        FIND FIRST Elevation WHERE Elevation.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Elevation THEN
        DO:
            DELETE Elevation. //If Elevation availabale Delete that Elevation from the Elevation table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Elevation Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

    //GetElevation method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetElevation( INPUT Id AS INTEGER, OUTPUT TABLE res_status, OUTPUT TABLE getElevation ):
        
        //Empty the Temporary Table called getElevation
        EMPTY TEMP-TABLE getElevation.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Elevation's Id equalent to the Id that is being passed by the GetElevation method
        FIND FIRST Elevation WHERE Elevation.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE Elevation THEN
        DO:
            CREATE getElevation. //If Elevation Available then Create the temporary table called getElevation
            BUFFER-COPY Elevation TO getElevation. //Copy contents of Elevation table to tempory table getElevation  
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Elevation Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END. 

    END METHOD.

    //GetElevations method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetElevations( OUTPUT TABLE res_status, OUTPUT TABLE getElevations ):
        
        //Empty the Temporary Table called getElevations
        EMPTY TEMP-TABLE getElevations.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        FOR EACH Elevation NO-LOCK: //For Each Elevation
            
            CREATE getElevations. //Create the temporary table called getElevations
            BUFFER-COPY Elevation TO getElevations. //Copy contents of Elevation table to tempory table getElevations
                        
        END.
        CREATE res_status.  //Create the temporary table called res_status
        //Defining output parameter values
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = " ".

    END METHOD.

    //GetNewId Method
    METHOD PUBLIC INTEGER GetNewId(  ):
        
        //Definition of Id & initially set It's value to 0
        DEFINE VARIABLE Id AS INTEGER INIT 0.
        
        //Find the Last Elevation
        FIND LAST Elevation NO-LOCK NO-ERROR.
        
        IF AVAILABLE Elevation THEN
        DO:
            Id = Elevation.Id. //If Elevations are available then set the Id value to Last Elevation Id
        END.
        
        REPEAT:
            //Increasing Elevation Id by 1
            FIND FIRST Elevation WHERE Elevation.Id = Id + 1 NO-LOCK NO-ERROR.
            Id = Id + 1.
            
            //If Elevations are not available then leave
            IF NOT AVAILABLE Elevation THEN LEAVE.
        END.
        
        RETURN Id. //Return Id

    END METHOD.

    //UpdateElevation Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateElevation( INPUT Id AS INTEGER, INPUT DATASET elevationSet, OUTPUT TABLE res_status ):
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Find the first record of the updateElevation Temporary table 
        FIND FIRST updateElevation.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Elevation's Id equalent to the Id that is being passed by the UpdateElevation method
        FIND FIRST Elevation WHERE Elevation.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            UpdateElevation.Id = Id. //Assigning the UpdateElevation Table's Id value to the Id value that is being passed by the UpdateElevation method 
        
        IF AVAILABLE Elevation THEN
        DO:
            BUFFER-COPY UpdateElevation TO Elevation. //If Elevation Available then Copy contents of updateElevation Temporary Table to Elevation table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Updated!".  
        END.
        ELSE
        DO:
            //Defining output parameter values for Elevation Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.    

END CLASS.