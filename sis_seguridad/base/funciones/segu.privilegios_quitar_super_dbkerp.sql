CREATE OR REPLACE FUNCTION segu.privilegios_quitar_super_dbkerp (
)
RETURNS void AS
$body$
DECLARE
   v_user 		record;


BEGIN
		--los usuarios de la lista que seguiran siendo super usuario hasta la evaluacion en desarrollo.
   		FOR v_user IN select *
                      from pg_user
                      where usename not in ('postgres','replication','boadwuser','dblink_migra_endesis',
                      'ende_pxp','naturalgodb_conexion','telecom','tesoreria','usr_replica_pxp','usr_wcf') LOOP

      		RAISE NOTICE 'Usuario % miembro del grupo privilegios_objetos_dbkerp', v_user.usename;
      		EXECUTE 'ALTER ROLE "'||v_user.usename||'" NOSUPERUSER' ;
        END LOOP;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;