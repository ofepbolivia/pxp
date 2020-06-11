CREATE OR REPLACE FUNCTION param.ft_forma_pago_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Parametros
 FUNCION: 		param.ft_forma_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tforma_pago'
 AUTOR: 		Maylee Perez Pastor
 FECHA:	        11-06-2019 21:49:11
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

    v_estacion			varchar;
    v_filtro			varchar;

BEGIN

	v_nombre_funcion = 'param.ft_forma_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	 /*********************************
 	#TRANSACCION:  'PM_FORDEPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	if(p_transaccion='PM_FORDEPA_SEL')then

    	begin

			v_consulta:='select   fp.id_forma_pago,
                                  fp.desc_forma_pago::varchar,
                                  fp.observaciones::varchar,
                                  array_to_string(fp.cod_inter,'','',''null'')::varchar as cod_inter,
                                  fp.estado_reg::varchar,
                                  fp.fecha_reg,
                                  fp.fecha_mod,
                                  fp.id_usuario_reg::integer,
                                  usu1.cuenta::varchar as usr_reg,
                                  usu2.cuenta::varchar as usr_mod,
                                  fp.id_usuario_mod::integer,
                                  fp.tipo,
                                  fp.orden,
                                  fp.codigo
                          from param.tforma_pago fp
                          inner join segu.tusuario usu1 on usu1.id_usuario = fp.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = fp.id_usuario_mod
                          where fp.estado_reg = ''activo''
                          and ';


			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
        /*********************************
 	#TRANSACCION:  'PM_FORDEPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FORDEPA_CONT')then

		begin

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(fp.id_forma_pago)
					    from param.tforma_pago fp
                          inner join segu.tusuario usu1 on usu1.id_usuario = fp.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = fp.id_usuario_mod
                          where fp.estado_reg = ''activo''
                          and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'PM_FORDEPAFI_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FORDEPAFI_SEL')then

    	begin
		--listado para obligaciones de pago , tipo=Gasto
        	v_estacion = pxp.f_get_variable_global('ESTACION_inicio');

            IF v_estacion = 'BOL' THEN
    		  v_filtro =  'BOL';
            ELSIF v_estacion = 'BUE' THEN
    		  v_filtro =  'BUE';
            ELSIF v_estacion = 'MIA' THEN
    		  v_filtro =  'MIA';
            ELSIF v_estacion = 'SAO' THEN
    		  v_filtro =  'SAO';
            ELSIF v_estacion = 'MAD' THEN
    		  v_filtro =  'MAD';
            END IF;

			v_consulta:='select   fp.id_forma_pago,
                                  fp.desc_forma_pago::varchar,
                                  fp.observaciones::varchar,
                                  array_to_string(fp.cod_inter,'','',''null'')::varchar as cod_inter,
                                  fp.estado_reg::varchar,
                                  fp.fecha_reg,
                                  fp.fecha_mod,
                                  fp.id_usuario_reg::integer,
                                  usu1.cuenta::varchar as usr_reg,
                                  usu2.cuenta::varchar as usr_mod,
                                  fp.id_usuario_mod::integer,
                                  fp.orden,
                                  fp.codigo
                          from param.tforma_pago fp
                          inner join segu.tusuario usu1 on usu1.id_usuario = fp.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = fp.id_usuario_mod
                          where  (''' ||v_filtro|| '''=ANY(fp.cod_inter)) and fp.tipo = ''Gasto'' and fp.estado_reg = ''activo''
                          and ';


			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;

		end;
        /*********************************
 	#TRANSACCION:  'PM_FORDEPAFI_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FORDEPAFI_CONT')then

		begin
        	v_estacion = pxp.f_get_variable_global('ESTACION_inicio');

            IF v_estacion = 'BOL' THEN
    		  v_filtro =  'BOL';
            ELSIF v_estacion = 'BUE' THEN
    		  v_filtro =  'BUE';
            ELSIF v_estacion = 'MIA' THEN
    		  v_filtro =  'MIA';
            ELSIF v_estacion = 'SAO' THEN
    		  v_filtro =  'SAO';
            ELSIF v_estacion = 'MAD' THEN
    		  v_filtro =  'MAD';
            END IF;

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(fp.id_forma_pago)
					    from param.tforma_pago fp
                          inner join segu.tusuario usu1 on usu1.id_usuario = fp.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = fp.id_usuario_mod
                          where  (''' ||v_filtro|| '''=ANY(fp.cod_inter)) and fp.tipo = ''Gasto'' and fp.estado_reg = ''activo''
                          and ';

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
