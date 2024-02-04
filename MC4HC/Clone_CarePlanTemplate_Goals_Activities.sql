/* Description:

For use in Microsoft Cloud for Healthcare accelerator
Clones Care Plan Templates and associated Care Plan Goal Templates, as well as associated Care Plan Activity Templates.
*/


-- IMPORTANT : Check the Environment Label Above --

-- define the source record to copy
DECLARE @SourceIDtoCopy AS VARCHAR(100)
SET @SourceIDtoCopy = '{00bb7a26-c441-ee11-bdf4-000d3a79aee0}'
PRINT 'SourceIDtoCopy is ' + @SourceIDtoCopy

-- define the suffix to apply to this record
DECLARE @Suffix AS VARCHAR(10)
SET @Suffix = 'NSW'
PRINT 'Suffix is ' + @Suffix 


----------------------------------------------------------
--  CLONE Care Plan Template
----------------------------------------------------------
/*
-- this is the source record we wish to create
SELECT msemr_problemcategoryvalue,
msemr_templatename + ' (' + @Suffix + ')' AS new_templatename,
msemr_templatestatus,
msemr_careplandescription
FROM msemr_careplantemplate 
WHERE msemr_careplantemplateid = @SourceIDtoCopy
*/

-- perform the creation
INSERT INTO msemr_careplantemplate (
msemr_problemcategoryvalue,
msemr_templatename,
msemr_templatestatus,
msemr_careplandescription)
    SELECT msemr_problemcategoryvalue,
    msemr_templatename + ' (' + @Suffix + ')' AS new_templatename,
    msemr_templatestatus,
    msemr_careplandescription
    FROM msemr_careplantemplate 
    WHERE msemr_careplantemplateid = @SourceIDtoCopy
    

DECLARE @NewCarePlanTemplateID AS VARCHAR(100)
    
SET @NewCarePlanTemplateID = (SELECT TOP 1 msemr_careplantemplateid FROM msemr_careplantemplate ORDER BY createdon DESC)
PRINT 'Created New Care Plan Template of ID ' + @NewCarePlanTemplateID


----------------------------------------------------------
--  CLONE Care Goal Template
----------------------------------------------------------
/*
SELECT 
msemr_careplantemplate, 
msemr_templatename,
msemr_templatedescription,
msemr_goal,
msemr_careplangoalstatus,
msemr_careplangoaldescription
FROM msemr_careplangoaltemplate
WHERE msemr_careplantemplate = @SourceIDtoCopy
*/

-- perform the creation
INSERT INTO msemr_careplangoaltemplate(
msemr_careplantemplate, 
msemr_templatename,
msemr_templatedescription,
msemr_goal,
msemr_careplangoalstatus,
msemr_careplangoaldescription)
    SELECT 
    @NewCarePlanTemplateID, 
    msemr_templatename  + ' (' + @Suffix + ')' AS new_templatename,
    msemr_templatedescription,
    msemr_goal,
    msemr_careplangoalstatus,
    msemr_careplangoaldescription
    FROM msemr_careplangoaltemplate
    WHERE msemr_careplantemplate = @SourceIDtoCopy
        



DECLARE @NewCarePlanGoalTemplateID AS VARCHAR(100)
    
SET @NewCarePlanGoalTemplateID = (SELECT TOP 1 msemr_careplangoaltemplateid FROM msemr_careplangoaltemplate ORDER BY createdon DESC)
PRINT 'Created New Care Plan Goal Template of ID ' + @NewCarePlanGoalTemplateID




----------------------------------------------------------
--  CLONE Care Activity Templates
----------------------------------------------------------

/*
SELECT 
CPAT.msemr_templatename,
CPAT.msemr_templatedescription,
CPAT.msemr_careplangoaltemplateid,
CPAT.msemr_activityname,
CPAT.msemr_activitystatus,
CPAT.msemr_activitydefinition,
CPGT.msemr_careplantemplate 
FROM msemr_careplanactivitytemplate CPAT
INNER JOIN msemr_careplangoaltemplate CPGT
ON CPAT.msemr_careplangoaltemplateid = CPGT.msemr_careplangoaltemplateid
WHERE
CPGT.msemr_careplantemplate = @SourceIDtoCopy
*/

INSERT INTO msemr_careplanactivitytemplate(
msemr_templatename,
msemr_templatedescription,
msemr_careplangoaltemplateid,
msemr_activityname,
msemr_activitystatus,
msemr_activitydefinition)
    SELECT 
    CPAT.msemr_templatename,
    CPAT.msemr_templatedescription,
    @NewCarePlanGoalTemplateID,
    CPAT.msemr_activityname  + ' (' + @Suffix + ')' AS new_activityname,
    CPAT.msemr_activitystatus,
    CPAT.msemr_activitydefinition
    FROM msemr_careplanactivitytemplate CPAT
    INNER JOIN msemr_careplangoaltemplate CPGT
    ON CPAT.msemr_careplangoaltemplateid = CPGT.msemr_careplangoaltemplateid
    WHERE
    CPGT.msemr_careplantemplate = @SourceIDtoCopy



