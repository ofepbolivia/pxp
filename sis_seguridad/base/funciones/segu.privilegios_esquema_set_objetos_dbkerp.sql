CREATE OR REPLACE FUNCTION segu.privilegios_esquema_set_objetos_dbkerp (
  p_user text,
  p_schema text
)
RETURNS void AS
$body$
DECLARE
   objeto 		text;

BEGIN
   		FOR objeto IN
      		SELECT tablename FROM pg_tables WHERE schemaname = p_schema
      		UNION
      		SELECT relname FROM pg_statio_all_sequences WHERE schemaname = p_schema
      		UNION
      		SELECT viewname FROM pg_views WHERE schemaname = p_schema LOOP

          RAISE NOTICE 'Asignando todos los privilegios a % sobre %.%', p_user, p_schema, objeto;
          EXECUTE 'GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES,TRIGGER ON "' || p_schema || '"."' || objeto || '" TO ' || p_user ;

        END LOOP;

        EXECUTE 'GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA '||p_schema||' TO '|| p_user ;
    	EXECUTE 'GRANT USAGE ON SCHEMA '||p_schema||' TO '|| p_user ;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;