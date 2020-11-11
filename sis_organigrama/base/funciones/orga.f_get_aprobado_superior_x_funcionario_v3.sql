CREATE OR REPLACE FUNCTION orga.f_get_aprobado_superior_x_funcionario_v3 (
  par_fecha date
)
RETURNS integer AS
$body$
/*

AUTOR: maylee.perez
FECHA  10/11/2020
Descripcion filtra para todos el inmediato superior por funcionario segun organigrama

parametros
   par_id_funcionario        funcionario sobre el que se busca
   par_filtro_presupuesto    si, no o todos


*/


DECLARE
  	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    --v_consulta				text;
    v_consulta				integer;
    v_id_funcionario		integer;
    v_filtro_pre			varchar;
    v_filtro_gerencia       varchar;
    v_lista_blanca          varchar;
    v_lista_negra           varchar;
    v_count_funcionario_ope	integer;

    par_filtro_gerencia  varchar;
    par_lista_blanca_nivel	varchar;
    par_lista_negra_nivel	varchar;

    v_funcionario			integer;
    v_desc_funcionario		varchar;
    v_numero_nivel			numeric;
    v_nivel 				text;

BEGIN




  	v_nombre_funcion = 'orga.f_get_aprobado_superior_x_funcionario_v3';


    --raise exception 'ssss';

     	  SELECT fc.id_funcionario
          INTO v_funcionario
          FROM orga.vfuncionario_cargo fc
          join orga.tuo uo on uo.id_uo = fc.id_uo
          join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional

          WHERE  fc.fecha_asignacion <=  par_fecha and (fc.fecha_finalizacion is null or fc.fecha_finalizacion >=  par_fecha )
          and no.numero_nivel = 2 ; --nivel 2 para gerencia general






        raise notice '%',v_funcionario;
        --return query execute (v_consulta);
        return v_funcionario;



EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;