CREATE OR REPLACE FUNCTION orga.ft_tipo_documento_contrato_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_tipo_documento_contrato_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.ttipo_documento_contrato'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        19-07-2021 16:12:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-07-2021 16:12:10								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.ttipo_documento_contrato'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'orga.ft_tipo_documento_contrato_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_TIP_DC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 16:12:10
	***********************************/

	if(p_transaccion='OR_TIP_DC_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tip_dc.id_tipo_documento_contrato,
						tip_dc.estado_reg,
						tip_dc.tipo,
						tip_dc.tipo_detalle,
						tip_dc.contenido,
						tip_dc.fecha_ini,
						tip_dc.fecha_fin,
						tip_dc.id_usuario_reg,
						tip_dc.fecha_reg,
						tip_dc.id_usuario_ai,
						tip_dc.usuario_ai,
						tip_dc.id_usuario_mod,
						tip_dc.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        ''''::varchar tipo_documento--cat.descripcion tipo_documento
						from orga.ttipo_documento_contrato tip_dc
                        --inner join param.tcatalogo cat on cat.id_catalogo = tip_dc.tipo
						inner join segu.tusuario usu1 on usu1.id_usuario = tip_dc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tip_dc.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'OR_TIP_DC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 16:12:10
	***********************************/

	elsif(p_transaccion='OR_TIP_DC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_documento_contrato)
					    from orga.ttipo_documento_contrato tip_dc
                        --inner join param.tcatalogo cat on cat.id_catalogo = tip_dc.tipo
					    inner join segu.tusuario usu1 on usu1.id_usuario = tip_dc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tip_dc.id_usuario_mod
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