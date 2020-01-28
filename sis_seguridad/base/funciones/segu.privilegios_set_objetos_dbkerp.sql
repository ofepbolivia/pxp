CREATE OR REPLACE FUNCTION segu.privilegios_set_objetos_dbkerp (
)
RETURNS void AS
$body$
DECLARE
   objeto 		text;
   esquemas 	varchar[];
   esquema		varchar;
   v_usuario	varchar = 'privilegios_objetos_dbkerp';
BEGIN
	esquemas = string_to_array('adq,af,alm,banc,bucardo,cd,cola,conta,cos,cvpn,decr,gecom,gen,informix,
    kaf,leg,log,mat,migra,obingresos,orga,param,plani,pre,public,pxp,rec,segu,sigep,spo,sqlserver,tes,vef,wf', ',');
	FOREACH esquema in ARRAY esquemas LOOP
   		FOR objeto IN
      		SELECT tablename FROM pg_tables WHERE schemaname = esquema
      		UNION
      		SELECT relname FROM pg_statio_all_sequences WHERE schemaname = esquema
      		UNION
      		SELECT viewname FROM pg_views WHERE schemaname = esquema
   		LOOP
      	RAISE NOTICE 'Asignando todos los privilegios a % sobre %.%', v_usuario, esquema, objeto;
      	EXECUTE 'GRANT ALL PRIVILEGES ON "'|| esquema|| '"."' ||objeto||'" TO '||v_usuario ;

        END LOOP;

        EXECUTE 'GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA '||esquema||' TO '||v_usuario ;
    	EXECUTE 'GRANT USAGE ON SCHEMA '||esquema||' TO '|| v_usuario ;
   	END LOOP;


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;