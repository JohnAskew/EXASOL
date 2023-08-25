--/
--========================================================================
CREATE OR REPLACE LUA SCRIPT RETAIL.TABLE_CLEANUP(IN_SCHEMA, MODE)  AS 
--========================================================================
if MODE == null then
   MODE = 'DEBUG'
end
summary = {}
local suc, ddl = pquery([[select 'DROP TABLE ' || TABLE_SCHEMA || '.' ||TABLE_NAME || ' CASCADE;' as my_line from EXA_DBA_TABLES where TABLE_SCHEMA =:sch and TABLE_COMMENT IS NULL]],{sch=IN_SCHEMA})
print("Found "..tostring(#ddl).. " tables to be dropped for missing COMMENTS in " .." Parameter MODE: "..MODE)
if (suc) then
  for i=1,#ddl do
      x = ddl[i][1]
      print(x)
      if string.upper(MODE) == 'EXECUTE' then
          query(ddl[i][1])
       end
   end
end
/
EXECUTE SCRIPT RETAIL.TABLE_CLEANUP( 'RETAIL_MINI', 'DEBUG) WITH OUTPUT;