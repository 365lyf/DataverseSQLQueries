/* Description:

Clones Field Service Incident Type, along with associated Service Tasks, Services, and Products.
*/


-- define the source record to copy
DECLARE @SourceIDtoCopy AS VARCHAR(100)
SET @SourceIDtoCopy = '{43d3c460-b641-ee11-bdf4-000d3a7a0291}' -- replace with ID to clone
PRINT 'SourceIDtoCopy is ' + @SourceIDtoCopy

-- define the suffix to apply to this cloned record
DECLARE @Suffix AS VARCHAR(10)
SET @Suffix = 'SA'
PRINT 'Suffix is ' + @Suffix 


----------------------------------------------------------
--  CLONE INCIDENT TYPE (WITH SUFFIX)
----------------------------------------------------------
/*
SELECT msdyn_name,
msdyn_defaultworkordertype,
msdyn_description,
msdyn_estimatedduration,
msdyn_lastcalculatedtime
FROM msdyn_incidenttype
WHERE 
msdyn_incidenttypeid = @SourceIDtoCopy
*/

INSERT INTO msdyn_incidenttype 
(
msdyn_name,
msdyn_defaultworkordertype,
msdyn_description,
msdyn_estimatedduration)
    SELECT msdyn_name  + ' (' + @Suffix + ')' AS new_appointtypename,
    msdyn_defaultworkordertype,    
    msdyn_description,
    msdyn_estimatedduration
    FROM msdyn_incidenttype
    WHERE 
    msdyn_incidenttypeid = @SourceIDtoCopy
    
    
    
DECLARE @NewIncidentTypeID AS VARCHAR(100)
    
SET @NewIncidentTypeID = (SELECT TOP 1 msdyn_incidenttypeid FROM msdyn_incidenttype ORDER BY createdon DESC)
PRINT 'Created New Appointment Type of ID ' + @NewIncidentTypeID



----------------------------------------------------------
--  CLONE INCIDENT TYPE SERVICE TASK (same tasks)
----------------------------------------------------------
/*
SELECT msdyn_tasktypename,
amp_funder,
msdyn_estimatedduration,
msdyn_lineorder,
msdyn_description,
msdyn_tasktype,
msdyn_incidenttype
 FROM
msdyn_incidenttypeservicetask
WHERE
msdyn_incidenttype = '{74aec25c-b641-ee11-bdf3-6045bd3d71df}'
*/


INSERT INTO msdyn_incidenttypeservicetask
(
msdyn_name,
msdyn_estimatedduration,
msdyn_lineorder,
msdyn_description,
msdyn_tasktype,
msdyn_incidenttype)
    SELECT 
    msdyn_name,
    msdyn_estimatedduration,
    msdyn_lineorder,
    msdyn_description,
    msdyn_tasktype,
    @NewIncidentTypeID  
     FROM
    msdyn_incidenttypeservicetask
    WHERE
    msdyn_incidenttype = @SourceIDtoCopy
  
  
 
----------------------------------------------------------
--  CLONE INCIDENT TYPE PRODUCTS (as is)
----------------------------------------------------------
/*
SELECT 
msdyn_name,
msdyn_unit,
msdyn_quantity,
msdyn_description,
msdyn_lineorder,
msdyn_product,
msdyn_incidenttype,
msdyn_internaldescription
 FROM
msdyn_incidenttypeproduct
WHERE msdyn_incidenttype = '{74aec25c-b641-ee11-bdf3-6045bd3d71df}'
*/

INSERT INTO msdyn_incidenttypeproduct
(msdyn_name,
msdyn_unit,
msdyn_quantity,
msdyn_description,
msdyn_lineorder,
msdyn_product,
msdyn_incidenttype,
msdyn_internaldescription)
    SELECT 
    msdyn_name,
    msdyn_unit,
    msdyn_quantity,
    msdyn_description,
    msdyn_lineorder,
    msdyn_product,
    @NewIncidentTypeID,
    msdyn_internaldescription
     FROM
    msdyn_incidenttypeproduct
    WHERE msdyn_incidenttype = @SourceIDtoCopy
    
 
----------------------------------------------------------
--  CLONE INCIDENT TYPE SERVICES(as is)
----------------------------------------------------------
/*
SELECT 
msdyn_name,
msdyn_unit,
msdyn_duration,
msdyn_description,
msdyn_lineorder,
msdyn_service,
msdyn_incidenttype,
msdyn_internaldescription
 FROM
msdyn_incidenttypeservice
WHERE msdyn_incidenttype = '{74aec25c-b641-ee11-bdf3-6045bd3d71df}'
*/  
    

INSERT INTO msdyn_incidenttypeservice
(msdyn_name,
msdyn_unit,
msdyn_duration,
msdyn_description,
msdyn_lineorder,
msdyn_service,
msdyn_incidenttype,
msdyn_internaldescription)
    SELECT 
    msdyn_name,
    msdyn_unit,
    msdyn_duration,
    msdyn_description,
    msdyn_lineorder,
    msdyn_service,
    @NewIncidentTypeID,
    msdyn_internaldescription
     FROM
    msdyn_incidenttypeservice
    WHERE msdyn_incidenttype = @SourceIDtoCopy