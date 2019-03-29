@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Broker_Locations: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addBrokerLocation LIKE BrokerLocations.
    DEFINE TEMP-TABLE getBrokerLocations LIKE BrokerLocations.
    DEFINE TEMP-TABLE getBrokerLocation LIKE BrokerLocations.
    DEFINE TEMP-TABLE updateBrokerLocation LIKE BrokerLocations.
    
    //Define Temporary Table called res_status
    DEFINE TEMP-TABLE res_status NO-UNDO  
        FIELD status_code AS CHARACTER FORMAT "x(36)" 
        FIELD status_description AS CHARACTER FORMAT "x(100)".
    
    /* Define a dataset for Grade to work with update operation */
    DEFINE DATASET BrokerLocationsSet FOR updateBrokerLocation.

    //CreateBrokerLocation Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateBrokerLocation( INPUT Broker AS CHARACTER, INPUT Broker_Location_Code AS CHARACTER, INPUT Location AS CHARACTER, OUTPUT TABLE res_status ):
        
        //Create the temporary table called addBrokerLocation
        CREATE addBrokerLocation.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Assigning data to addBrokerLocation table columns by using parameters passed by the CreateBrokerLocation Method
        ASSIGN 
            addBrokerLocation.Broker = Broker
            addBrokerLocation.Broker_Location_Code = Broker_Location_Code
            addBrokerLocation.Location = Location
            addBrokerLocation.Id = BASE64-ENCODE(GENERATE-UUID). //Calling the GENERATE-UUID function to assign Id to BrokerLocation
        
        //Copy contents of tempory table addBrokerLocation to BrokerLocations table    
        BUFFER-COPY addBrokerLocation TO BrokerLocations.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Defining output parameter value
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Broker Location Record Created!".

    END METHOD.

    //DeleteBrokerLocation Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteBrokerLocation( INPUT Id AS CHARACTER, OUTPUT TABLE res_status ):
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get BrokerLocations table's Id equalent to the Id thst is being passed by the DeleteBrokerLocation method
        FIND FIRST BrokerLocations WHERE BrokerLocations.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE BrokerLocations THEN
        DO:
            DELETE BrokerLocations. //If BrokerLocations availabale Delete that BrokerLocation from the BrokerLocations table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for BrokerLocations Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.
    END METHOD.

    //GetBrokerLocation Method
    METHOD PUBLIC VOID GetBrokerLocation( INPUT Id AS CHARACTER, OUTPUT TABLE res_status, OUTPUT TABLE getBrokerLocation ):
        
        //Empty the Temporary Table called getBrokerLocation
        EMPTY TEMP-TABLE getBrokerLocation.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get BrokerLocations table's Id equalent to the Id that is being passed by the GetBrokerLocation method
        FIND FIRST BrokerLocations WHERE BrokerLocations.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE BrokerLocations THEN
        DO:
            CREATE getBrokerLocation. //If BrokerLocations Available then Create the temporary table called getBrokerLocation
            
            BUFFER-COPY BrokerLocations TO getBrokerLocation. //Copy contents of BrokerLocations table to tempory table getBrokerLocation  
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for BrokerLocations Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

    //GetBrokerLocations Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetBrokerLocations( OUTPUT TABLE res_status, OUTPUT TABLE getBrokerLocations ):
        
        //Empty the Temporary Table called getBrokerLocations
        EMPTY TEMP-TABLE getBrokerLocations.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        FOR EACH BrokerLocations NO-LOCK: //For Each BrokerLocations
            
            CREATE getBrokerLocations. //Create the temporary table called getBrokerLocations
            BUFFER-COPY BrokerLocations TO getBrokerLocations. //Copy contents of BrokerLocations table to tempory table getBrokerLocations
            
        END.
        
        CREATE res_status.  //Create the temporary table called res_status
        //Defining output parameter values
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = " ".

    END METHOD.

    //UpdateBrokerLocations Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateBrokerLocations( INPUT Id AS CHARACTER, INPUT DATASET BrokerLocationsSet, OUTPUT TABLE res_status ):
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Find the first record of the updateBrokerLocation Temporary table 
        FIND FIRST updateBrokerLocation.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get BrokerLocations table's Id equalent to the Id that is being passed by the UpdateBrokerLocations method
        FIND FIRST BrokerLocations WHERE BrokerLocations.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateBrokerLocation.Id = Id. //Assigning the updateBrokerLocation Table's Id value to the Id value that is being passed by the UpdateBrokerLocations method 
        
        IF AVAILABLE BrokerLocations THEN
        DO:
            BUFFER-COPY updateBrokerLocation TO BrokerLocations. //If BrokerLocations Available then Copy contents of updateBrokerLocation Temporary Table to BrokerLocations table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Updated!".  
        END.
        ELSE
        DO:
            //Defining output parameter values for BrokerLocations Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

END CLASS.