CREATE OR REPLACE FUNCTION orga.ft_permiso_gerencias_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Organigrama
 FUNCION: 		orga.ft_permiso_gerencias_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'vef.tdosificacion'
 AUTOR: 		 (Ismael Valdivia)
 FECHA:	        26-08-2020 10:30:00
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
    v_id_funcionario	integer;
    v_id_uo				integer;
    v_id_uo_gerencia	integer;
    v_existen_gerencias integer;
    v_existe_permiso	integer;

BEGIN

	v_nombre_funcion = 'orga.ft_permiso_gerencias_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
 	#TRANSACCION:  'ORGA_LIST_SEL'
 	#DESCRIPCION:	Listado de los permisos asignados a los funcionarios
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		26-08-2020 10:30:56
	***********************************/

	if(p_transaccion='ORGA_LIST_SEL')then

    	begin

    		--Sentencia de la consulta
			v_consulta:='select
            					geren.id_autorizacion,
            					geren.id_funcionario,
                                array_to_string(geren.id_gerencia,'','')::varchar as id_gerencia,
                                geren.estado_reg,
                                geren.id_usuario_ai,
                                geren.fecha_reg,
                                geren.usuario_ai,
                                geren.id_usuario_reg,
                                geren.fecha_mod,
                                geren.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,

                                (select pxp.list(uo.nombre_cargo) from orga.tuo uo where uo.id_uo =ANY(geren.id_gerencia))::varchar as nombres_gerencias,
                                fun.desc_funcionario1::varchar,
                                fun.nombre_cargo

						from orga.tpermiso_gerencias geren
						inner join segu.tusuario usu1 on usu1.id_usuario = geren.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = geren.id_usuario_mod
                        inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = geren.id_funcionario
                        where ';

			--Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ORGA_LIST_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:			Ismale Valdivia
 	#FECHA:
	***********************************/

	elsif(p_transaccion='ORGA_LIST_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(geren.id_autorizacion)
					    from orga.tpermiso_gerencias geren
						inner join segu.tusuario usu1 on usu1.id_usuario = geren.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = geren.id_usuario_mod
                        inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = geren.id_funcionario
                        where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ORGA_LIS_GEREN_SEL'
 	#DESCRIPCION:	Listado de las gerencias
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		26-08-2020 10:30:56
	***********************************/

	elsif(p_transaccion='ORGA_LIS_GEREN_SEL')then

    	begin

    		--Sentencia de la consulta
			v_consulta:='select uo.id_uo,
                                uo.nombre_unidad
                          from orga.tuo uo
                          where uo.estado_reg = ''activo'' and uo.gerencia = ''si'' and ';

			--Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ORGA_LIS_GEREN_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:			Ismale Valdivia
 	#FECHA:
	***********************************/

	elsif(p_transaccion='ORGA_LIS_GEREN_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(uo.id_uo)
                          from orga.tuo uo
                          where uo.estado_reg = ''activo'' and uo.gerencia = ''si'' and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;

		end;


    /*********************************
 	#TRANSACCION:  'ORGA_LIS_PERGERE_SEL'
 	#DESCRIPCION:	Listado de las gerencias
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		26-08-2020 10:30:56
	***********************************/

	elsif(p_transaccion='ORGA_LIS_PERGERE_SEL')then

    	begin
        	/*Recuperamos el Id Funcionario del Usuario*/
        	select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
            from segu.tusuario usu
            inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
            inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
            where usu.id_usuario = p_id_usuario;
            /*****************************************/

            /*Recuperamos la gerencia por defecto del funcionario*/
            v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);
            /*****************************************************/

            /*Verificamos si el funcionario tiene permisos Asignados*/
             SELECT count (gere.id_gerencia) into v_existen_gerencias
             from orga.tpermiso_gerencias gere
             where gere.id_funcionario = v_id_funcionario and (array_to_string(gere.id_gerencia,'','')::varchar != '');
            /********************************************************/


            IF (v_existen_gerencias = 0 )then
            	v_consulta:=' select uo.id_uo,
                                     uo.descripcion,
                                     uo.codigo,
                                     '||v_id_funcionario||'::integer as id_funcionario,
                                     ''si''::varchar as defecto,
                                     uo.nombre_unidad
                          from orga.tuo uo
                          where uo.id_uo = '||v_id_uo_gerencia||' and';
            else

            	v_consulta:=' select uo.id_uo,
                                     uo.descripcion,
                                     uo.codigo,
                                     (case when (uo.id_uo =ANY (SELECT unnest (gere.id_gerencia)
                                                                from orga.tpermiso_gerencias gere
                                                                where gere.id_funcionario = '||v_id_funcionario||')) then
                                      null
                                      else
                                      '||v_id_funcionario||'
                                      end::integer) as id_funcionario,
                                     (case when (uo.id_uo = '||v_id_uo_gerencia||') then
                                              ''si''
                                             else
                                              ''no''
                                      end::varchar) as defecto,
                                      uo.nombre_unidad
                          from orga.tuo uo
                          where (uo.id_uo = '||v_id_uo_gerencia||' or(uo.id_uo =ANY (SELECT unnest (gere.id_gerencia)
                                                                           from orga.tpermiso_gerencias gere
                                                                           where gere.id_funcionario = '||v_id_funcionario||'))) and';

            end if;


			--Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ORGA_LIS_PERGERE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:			Ismale Valdivia
 	#FECHA:
	***********************************/

	elsif(p_transaccion='ORGA_LIS_PERGERE_CONT')then

		begin
        	select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
            from segu.tusuario usu
            inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
            inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
            where usu.id_usuario = p_id_usuario;

            v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);


			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(uo.id_uo)
                          from orga.tuo uo
                          where (uo.id_uo = '||v_id_uo_gerencia||' or(uo.id_uo =ANY (SELECT unnest (gere.id_gerencia)
                                                                           from orga.tpermiso_gerencias gere
                                                                           where gere.id_funcionario = '||v_id_funcionario||'))) and';

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

ALTER FUNCTION orga.ft_permiso_gerencias_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;
