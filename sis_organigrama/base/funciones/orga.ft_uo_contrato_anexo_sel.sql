CREATE OR REPLACE FUNCTION orga.ft_uo_contrato_anexo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_uo_contrato_anexo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.tuo_contrato_anexo'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        19-07-2021 13:16:48
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-07-2021 13:16:48								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.tuo_contrato_anexo'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'orga.ft_uo_contrato_anexo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_UO_CA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 13:16:48
	***********************************/

	if(p_transaccion='OR_UO_CA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						uo_ca.id_uo_contrato_anexo,
						uo_ca.estado_reg,
						uo_ca.id_uo,
						uo_ca.id_tipo_documento_contrato,
						uo_ca.id_tipo_contrato,
						uo_ca.id_usuario_reg,
						uo_ca.fecha_reg,
						uo_ca.id_usuario_ai,
						uo_ca.usuario_ai,
						uo_ca.id_usuario_mod,
						uo_ca.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cat.tipo_detalle anexo,
                        con.nombre contrato,
                        uo.nombre_unidad
						from orga.tuo_contrato_anexo uo_ca
                        inner join orga.ttipo_documento_contrato cat on cat.id_tipo_documento_contrato = uo_ca.id_tipo_documento_contrato
                        inner join orga.ttipo_contrato con on con.id_tipo_contrato = uo_ca.id_tipo_contrato
                        inner join orga.tuo uo on uo.id_uo = uo_ca.id_uo
						inner join segu.tusuario usu1 on usu1.id_usuario = uo_ca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uo_ca.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'OR_UO_CA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 13:16:48
	***********************************/

	elsif(p_transaccion='OR_UO_CA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_uo_contrato_anexo)
					    from orga.tuo_contrato_anexo uo_ca
                        inner join orga.ttipo_documento_contrato cat on cat.id_tipo_documento_contrato = uo_ca.id_tipo_documento_contrato
                        inner join orga.ttipo_contrato con on con.id_tipo_contrato = uo_ca.id_tipo_contrato
                        inner join orga.tuo uo on uo.id_uo = uo_ca.id_uo
					    inner join segu.tusuario usu1 on usu1.id_usuario = uo_ca.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uo_ca.id_usuario_mod
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;