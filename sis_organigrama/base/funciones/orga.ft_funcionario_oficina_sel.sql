CREATE OR REPLACE FUNCTION orga.ft_funcionario_oficina_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_funcionario_oficina_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.tfuncionario_oficina'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        29-03-2021 18:50:34
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-03-2021 18:50:34								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.tfuncionario_oficina'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'orga.ft_funcionario_oficina_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_FUNCOFI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-03-2021 18:50:34
	***********************************/

	if(p_transaccion='OR_FUNCOFI_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						funcofi.id_funcionario_oficina,
						funcofi.estado_reg,
						funcofi.id_funcionario,
						funcofi.id_oficina,
						funcofi.fecha_ini,
			            funcofi.fecha_fin,
						case when funcofi.observaciones = '''' or funcofi.observaciones is null then ''Ninguna'' else funcofi.observaciones end observaciones,
						funcofi.id_usuario_reg,
						funcofi.fecha_reg,
						funcofi.id_usuario_ai,
						funcofi.usuario_ai,
						funcofi.id_usuario_mod,
						funcofi.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        funcofi.id_cargo,
			            ofi.nombre nombre_oficina,
                        vf.desc_funcionario2::varchar funcionario,
                        (lug.nombre||'' (''||lug.codigo||'')'')::varchar lugar
						from orga.tfuncionario_oficina funcofi
			            inner join orga.toficina ofi on ofi.id_oficina = funcofi.id_oficina
			            inner join orga.vfuncionario vf on vf.id_funcionario = funcofi.id_funcionario
			            inner join param.tlugar lug on lug.id_lugar = ofi.id_lugar
						inner join segu.tusuario usu1 on usu1.id_usuario = funcofi.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = funcofi.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'OR_FUNCOFI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-03-2021 18:50:34
	***********************************/

	elsif(p_transaccion='OR_FUNCOFI_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(funcofi.id_funcionario_oficina)
					    from orga.tfuncionario_oficina funcofi
					    inner join orga.toficina ofi on ofi.id_oficina = funcofi.id_oficina
			            inner join orga.vfuncionario vf on vf.id_funcionario = funcofi.id_funcionario
			            inner join param.tlugar lug on lug.id_lugar = ofi.id_lugar
					    inner join segu.tusuario usu1 on usu1.id_usuario = funcofi.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = funcofi.id_usuario_mod
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

ALTER FUNCTION orga.ft_funcionario_oficina_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;