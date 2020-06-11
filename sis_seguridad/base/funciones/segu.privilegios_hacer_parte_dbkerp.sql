CREATE OR REPLACE FUNCTION segu.privilegios_hacer_parte_dbkerp (
)
RETURNS void AS
$body$
DECLARE
   v_user 		record;


BEGIN
--usuarios que no tendrian que formar parte del grupo son postgres, replication, privilegios_objetos_dbkerp, los demas de la lista estaran bajo evaluación
   		FOR v_user IN select *
                      from pg_user
                      where usename not in (
                      'postgres',
                      'privilegios_objetos_dbkerp',
                      'replication'
                      , 'dbkerp_conexion'
                      , 'backup_pg'
                      , 'boadwuser'
                      , 'bucardo'
                      , 'dblink_migra_endesis'
                      , 'develop'
                      , 'dwreplicacion'
                      , 'ende_pxp'
                      , 'ever.arrazola'
                      , 'franklin'
                      , 'gvelasquez'
                      , 'ivaldivia'
                      , 'jhonn.claros'
                      , 'telecom'
                      , 'tesoreria'
                      , 'usr_replica_pxp'
                      , 'usr_wcf'
                      ) LOOP

      		RAISE NOTICE 'Usuario % miembro del grupo privilegios_objetos_dbkerp', v_user.usename;
      		EXECUTE 'GRANT privilegios_objetos_dbkerp TO "'||v_user.usename||'"' ;
        END LOOP;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;