@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Items: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addItem LIKE Items.
    DEFINE TEMP-TABLE getItems LIKE Items.
    DEFINE TEMP-TABLE getItem LIKE Items.
    DEFINE TEMP-TABLE updateItem LIKE Items.
    DEFINE TEMP-TABLE addElasticSearch LIKE ElasticSearch.
    
    //Define Temporary Table called res_status
    DEFINE TEMP-TABLE res_status NO-UNDO  
        FIELD status_code AS CHARACTER FORMAT "x(36)" 
        FIELD status_description AS CHARACTER FORMAT "x(100)".
        
/*    DEFINE TEMP-TABLE search_result NO-UNDO            */
/*        FIELD Id AS CHARACTER FORMAT "x(100)"          */
/*        FIELD Item_Code AS CHARACTER FORMAT "x(100)"   */
/*        FIELD Description AS CHARACTER FORMAT "x(100)".*/
    
    /* Define a dataset for Grade to work with update operation */
    DEFINE DATASET ItemSet FOR updateItem.
    

    //CreateItem Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID CreateItem( INPUT Item_Code AS CHARACTER, INPUT Description AS CHARACTER, OUTPUT TABLE res_status ):
        
        //Create the temporary table called addItem
        CREATE addItem.
        
        //Create the temporary table called addElasticSearch
        CREATE addElasticSearch.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Assigning data to Items table columns by using parameters passed by the CreateItem Method
        ASSIGN 
            addItem.Item_Code = Item_Code
            addItem.Description = Description
            addItem.Id = GUID(GENERATE-UUID) //Calling the GENERATE-UUID function to assign Id to Items
/*            search_result.Id = addItem.Id          */
/*            search_result.Item_Code = Item_Code    */
/*            search_result.Description = Description*/
            addElasticSearch.GUID = addItem.Id
            addElasticSearch.APP = "iTeaBlend"
            addElasticSearch.TYPE = "Items"
            addElasticSearch.JSON = STRING(addItem.Id) + ',' + STRING(addItem.Item_Code) + ',' + STRING(addItem.Description).
/*            addElasticSearch.JSON = addElasticSearch.JSON:WRITE-JSON (addItem.Id, Item_Code, Description).*/
/*            addElasticSearch.JSON = STRING(addItem.Id) + ',' + STRING(addItem.Item_Code) + ',' + STRING(addItem.Description).*/
            
        //Copy contents of tempory table addItem to Items table    
        BUFFER-COPY addItem TO Items.
            
        BUFFER-COPY addElasticSearch TO ElasticSearch.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Defining output parameter value
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Elevation Record Created!".

    END METHOD.

    //DeleteItem Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID DeleteItem( INPUT Id AS CHARACTER, OUTPUT TABLE res_status ):
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Items table's Id equalent to the Id thst is being passed by the DeleteItem method
        FIND FIRST Items WHERE Items.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        IF AVAILABLE Items THEN
        DO:
            DELETE Items. //If Items availabale Delete that Item from the Items table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Removed!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Items Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

    //GetItem Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetItem( INPUT Id AS CHARACTER, OUTPUT TABLE res_status, OUTPUT TABLE getItem ):
        
        //Empty the Temporary Table called getItem
        EMPTY TEMP-TABLE getItem.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Items table's Id equalent to the Id that is being passed by the GetItem method
        FIND FIRST Items WHERE Items.Id EQ Id NO-LOCK NO-ERROR.
        
        IF AVAILABLE Items THEN
        DO:
            CREATE getItem. //If Items Available then Create the temporary table called getItem
            
            BUFFER-COPY Items TO getItem. //Copy contents of Items table to tempory table getItem  
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Found!".
        END.
        ELSE
        DO:
            //Defining output parameter values for Items Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

    //GetItems Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetItems( OUTPUT TABLE res_status, OUTPUT TABLE getItems ):
        
        //Empty the Temporary Table called getItems
        EMPTY TEMP-TABLE getItems.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        FOR EACH Items NO-LOCK: //For Each Items
            
            CREATE getItems. //Create the temporary table called getItems
            BUFFER-COPY Items TO getItems. //Copy contents of Items table to tempory table getItems
            
        END.
        
        CREATE res_status.  //Create the temporary table called res_status
        //Defining output parameter values
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = " ".
        

    END METHOD.

    //UpdateItem Method
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID UpdateItem( INPUT Id AS CHARACTER, INPUT DATASET ItemSet, OUTPUT TABLE res_status ):
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        //Find the first record of the updateItem Temporary table 
        FIND FIRST updateItem.
        
        CREATE res_status. //Create the temporary table called res_status
        
        //Get Items table's Id equalent to the Id that is being passed by the UpdateItem method
        FIND FIRST Items WHERE Items.Id EQ Id EXCLUSIVE-LOCK NO-ERROR.
        
        ASSIGN
            updateItem.Id = Id. //Assigning the updateItem Table's Id value to the Id value that is being passed by the UpdateItem method 
        
        IF AVAILABLE Items THEN
        DO:
            BUFFER-COPY updateItem TO Items. //If Items Available then Copy contents of updateItem Temporary Table to Items table
            
            //Defining output parameter values
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Successfully Updated!".  
        END.
        ELSE
        DO:
            //Defining output parameter values for Items Inavailability
            ASSIGN 
                res_status.status_code = " "
                res_status.status_description = "Record Not Found!".
        END.

    END METHOD.

END CLASS.