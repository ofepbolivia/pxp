CREATE OR REPLACE FUNCTION param.ft_get_variables_globales_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema Parametros Generales
 FUNCION: 		param.ft_get_variables_globales_sel
 DESCRIPCION:   Funcion para recuperar las variables globales
 AUTOR: 		 Ismael Valdivia
 FECHA:	        30-04-2020 14:38:58
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN
	v_nombre_funcion = 'param.ft_get_variables_globales_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PARAM_GET_VG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		30-04-2020 14:38:58
	***********************************/
        if(p_transaccion='PARAM_GET_VG_SEL')then
            begin

                v_consulta = 'select
                			  pxp.f_get_variable_global('''||v_parametros.variable_global||''')::varchar as variable_obtenida
                					 ';
                raise notice '%', v_consulta;
                return v_consulta;
            end;

else

		raise exception 'Transaccion inexistente';

	end if;

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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;