@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ItemTypes: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addItemType LIKE ItemTypes.
    DEFINE TEMP-TABLE getItemTypes LIKE ItemTypes.
    DEFINE TEMP-TABLE getItemType LIKE ItemTypes.
    DEFINE TEMP-TABLE updateItemType LIKE ItemTypes.
    
    //Define Temporary Table called res_status
    DEFINE TEMP-TABLE res_status NO-UNDO  
        FIELD status_code AS CHARACTER FORMAT "x(36)" 
        FIELD status_description AS CHARACTER FORMAT "x(100)".
    
    /* Define a dataset for Grade to work with update operation */
    DEFINE DATASET ItemTypeSet FOR updateItemType.

    //CreateItemType Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateItemType( INPUT ItemType_Code AS CHARACTER, INPUT ItemType_Label AS CHARACTER, OUTPUT TABLE res_status ):
        
        //Create the temporary table called addItemType
        CREATE addItemType.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Assigning data to ItemTypes table columns by using parameters passed by the CreateItemType Method
        ASSIGN 
            addItemType.ItemType_Code = ItemType_Code
            addItemType.ItemType_Label = ItemType_Label
            addItemType.Id = BASE64-ENCODE(GENERATE-UUID). //Calling the GENERATE-UUID function to assign Id to ItemTypes
        
        //Copy contents of tempory table addItemType to ItemTypes table    
        BUFFER-COPY addItemType TO ItemTypes.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Defining output parameter value
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Elevation Record Created!".


    END METHOD.

    //DeleteItemType Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteItemType( INPUT Id AS CHARACTER, OUTPUT TABLE res_status ):
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get ItemTypes table's Id equalent to the Id thst is being passed by the DeleteItemType method
        FIND FIRST ItemTypes WHERE ItemTypes.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE ItemTypes THEN
        DO:
            DELETE ItemTypes. //If ItemTypes availabale Delete that ItemType from the ItemTypes table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for ItemTypes Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

    //GetItemType Method    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetItemType( INPUT Id AS CHARACTER, OUTPUT TABLE res_status, OUTPUT TABLE getItemType ):
        
        //Empty the Temporary Table called getItemType
        EMPTY TEMP-TABLE getItemType.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get ItemTypes table's Id equalent to the Id that is being passed by the GetItemType method
        FIND FIRST ItemTypes WHERE ItemTypes.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE ItemTypes THEN
        DO:
            CREATE getItemType. //If ItemTypes Available then Create the temporary table called getItemType
            
            BUFFER-COPY ItemTypes TO getItemType. //Copy contents of ItemTypes table to tempory table getItemType  
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for ItemTypes Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

    //GetItemTypes Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetItemTypes( OUTPUT TABLE res_status, OUTPUT TABLE getItemTypes ):
        
        //Empty the Temporary Table called getItemTypes
        EMPTY TEMP-TABLE getItemTypes.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        FOR EACH ItemTypes NO-LOCK: //For Each ItemTypes
            
            CREATE getItemTypes. //Create the temporary table called getItemTypes
            BUFFER-COPY ItemTypes TO getItemTypes. //Copy contents of ItemTypes table to tempory table getItemTypes
            
        END.
        
        CREATE res_status.  //Create the temporary table called res_status
        //Defining output parameter values
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = " ".

    END METHOD.

    //UpdateItemTypes Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateItemTypes( INPUT Id AS CHARACTER, INPUT DATASET ItemTypeSet, OUTPUT TABLE res_status ):
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Find the first record of the updateItemType Temporary table 
        FIND FIRST updateItemType.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Items table's Id equalent to the Id that is being passed by the UpdateItemTypes method
        FIND FIRST ItemTypes WHERE ItemTypes.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateItemType.Id = Id. //Assigning the updateItemType Table's Id value to the Id value that is being passed by the UpdateItemTypes method 
        
        IF AVAILABLE ItemTypes THEN
        DO:
            BUFFER-COPY updateItemType TO ItemTypes. //If ItemTypes Available then Copy contents of updateItemType Temporary Table to ItemTypes table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Updated!". 
        END.
        ELSE
        DO:
            //Defining output parameter values for ItemTypes Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

END CLASS.