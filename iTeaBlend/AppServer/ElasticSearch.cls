@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").
USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ElasticSearch: 
    //Define Temporary Tables to work with CRUD Operations
    DEFINE TEMP-TABLE addItem LIKE Items.
    DEFINE TEMP-TABLE getElasticSearches LIKE ElasticSearch.
    DEFINE TEMP-TABLE getItem LIKE Items.
    DEFINE TEMP-TABLE updateItem LIKE Items.
    DEFINE TEMP-TABLE addElasticSearch LIKE ElasticSearch.
    
    //Define Temporary Table called res_status
    DEFINE TEMP-TABLE res_status NO-UNDO  
        FIELD status_code AS CHARACTER FORMAT "x(36)" 
        FIELD status_description AS CHARACTER FORMAT "x(100)".
    
    /* Define a dataset for Grade to work with update operation */
    DEFINE DATASET ItemSet FOR updateItem.

    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    METHOD PUBLIC VOID GetElasticSearches( OUTPUT TABLE res_status, OUTPUT TABLE getElasticSearches ):
        
        //Empty the Temporary Table called getElasticSearches
        EMPTY TEMP-TABLE getElasticSearches.
        
        //Empty the Temporary Table called res_status
        EMPTY TEMP-TABLE res_status.
        
        FOR EACH ElasticSearch NO-LOCK: //For Each Items
            
            CREATE getElasticSearches. //Create the temporary table called getElasticSearches
            BUFFER-COPY ElasticSearch TO getElasticSearches. //Copy contents of ElasticSearch table to tempory table getElasticSearches
            
        END.
        
        CREATE res_status.  //Create the temporary table called res_status
        //Defining output parameter values
        ASSIGN 
                res_status.status_code = " "
                res_status.status_description = " ".

    END METHOD.

END CLASS.