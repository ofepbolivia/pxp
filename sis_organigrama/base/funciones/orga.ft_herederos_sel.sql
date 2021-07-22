CREATE OR REPLACE FUNCTION orga.ft_herederos_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_herederos_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.therederos'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        16-07-2021 14:16:29
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-07-2021 14:16:29								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.therederos'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'orga.ft_herederos_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_HERE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		16-07-2021 14:16:29
	***********************************/

	if(p_transaccion='OR_HERE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						here.id_herederos,
						here.estado_reg,
						here.parentesco,
						here.edad,
						here.id_usuario_reg,
						here.fecha_reg,
						here.id_usuario_ai,
						here.usuario_ai,
						here.id_usuario_mod,
						here.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        here.id_funcionario,
                        vf.desc_funcionario2::varchar benefactor,

                        here.id_persona,
                        person.nombre_completo2::varchar AS desc_person,

                        person.nombre,
                        person.ap_materno,
                        person.ap_paterno,
                        person2.fecha_nacimiento,
                        person2.genero,
                        person2.nacionalidad,
                        person2.id_lugar,
                        person2.id_tipo_doc_identificacion,
                        person.ci,
                        person2.expedicion,
                        person2.estado_civil,
                        person2.discapacitado,
                        person.telefono1,
                        person.celular1,
                        person.correo,
                        person.telefono2,
                        person.celular2,
                        person2.direccion

						from orga.therederos here
                        inner join orga.vfuncionario vf on vf.id_funcionario = here.id_funcionario
                        inner join segu.vpersona person ON person.id_persona=here.id_persona
                        inner join segu.tpersona person2 ON person2.id_persona=here.id_persona
						inner join segu.tusuario usu1 on usu1.id_usuario = here.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = here.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'OR_HERE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		16-07-2021 14:16:29
	***********************************/

	elsif(p_transaccion='OR_HERE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_herederos)
					    from orga.therederos here
                        inner join orga.vfuncionario vf on vf.id_funcionario = here.id_funcionario
                        inner join segu.vpersona person ON person.id_persona=here.id_persona
                        inner join segu.tpersona person2 ON person2.id_persona=here.id_persona
					    inner join segu.tusuario usu1 on usu1.id_usuario = here.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = here.id_usuario_mod
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