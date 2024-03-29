CREATE OR REPLACE FUNCTION orga.ft_representante_legal_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_representante_legal_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.trepresentate_legal'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        19-07-2021 12:11:06
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-07-2021 12:11:06								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.trepresentate_legal'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'orga.ft_representante_legal_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_REP_LEG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 12:11:06
	***********************************/

	if(p_transaccion='OR_REP_LEG_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rep_leg.id_representante_legal,
						rep_leg.estado_reg,
						rep_leg.id_funcionario,
						rep_leg.nro_resolucion,
						rep_leg.fecha_resolucion,
						rep_leg.fecha_ini,
						rep_leg.fecha_fin,
						rep_leg.id_usuario_reg,
						rep_leg.fecha_reg,
						rep_leg.id_usuario_ai,
						rep_leg.usuario_ai,
						rep_leg.id_usuario_mod,
						rep_leg.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        vf.desc_funcionario2::varchar desc_representante
						from orga.trepresentante_legal rep_leg
                        inner join orga.vfuncionario vf on vf.id_funcionario = rep_leg.id_funcionario
						inner join segu.tusuario usu1 on usu1.id_usuario = rep_leg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rep_leg.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'OR_REP_LEG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 12:11:06
	***********************************/

	elsif(p_transaccion='OR_REP_LEG_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_representante_legal)
					    from orga.trepresentante_legal rep_leg
					    inner join segu.tusuario usu1 on usu1.id_usuario = rep_leg.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rep_leg.id_usuario_mod
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