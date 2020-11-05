CREATE OR REPLACE FUNCTION "pxp"."ft_variable_global_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		FRAMEWORK ORIGINAL
 FUNCION: 		pxp.ft_variable_global_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pxp.variable_global'
 AUTOR: 		 (admin)
 FECHA:	        28-01-2020 15:30:09
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				28-01-2020 15:30:09								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pxp.variable_global'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pxp.ft_variable_global_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PXP_varg_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		24-01-2020 19:50:15
	***********************************/

	if(p_transaccion='PXP_varg_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            varg.id_variable_global,
                            varg.variable,
                            varg.valor,
                            varg.descripcion
						from pxp.variable_global varg
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PXP_varg_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		24-01-2020 19:50:15
	***********************************/

	elsif(p_transaccion='PXP_varg_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_variable_global)
					    from pxp.variable_global varg
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pxp"."ft_variable_global_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
