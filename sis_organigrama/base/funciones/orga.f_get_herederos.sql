CREATE OR REPLACE FUNCTION orga.f_get_herederos (
  p_id_funcionario integer
)
RETURNS text AS
$body$
DECLARE
	v_consulta    		varchar;
	v_registros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

	v_lista_herederos	text='';

BEGIN
	   v_nombre_funcion = 'orga.f_get_herederos';

     	for v_registros in  select per.nombre_completo2 nombre, her.parentesco, her.edad
        					from orga.therederos her
                            inner join segu.vpersona per on per.id_persona = her.id_persona
                            where her.id_funcionario = p_id_funcionario loop

        v_lista_herederos = v_lista_herederos || '<li>' || v_registros.nombre || '  -  '||coalesce(v_registros.edad::varchar,'(N/E)'::varchar)||' años.</li>';
        end loop;

    	if v_lista_herederos is not null then
    		v_lista_herederos = '<ol>'||v_lista_herederos || '</ol>';
        end if;

    return v_lista_herederos;

EXCEPTION
	WHEN OTHERS THEN
            return SQLERRM;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION orga.f_get_herederos (p_id_funcionario integer) OWNER TO postgres;