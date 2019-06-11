/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		param.f_plantilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tplantilla'
 AUTOR: 		Gonzalo Sarmiento Sejas
 FECHA:	        01-04-2013 21:49:11
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

    v_id_depto_lb		integer;

    v_plantilla			varchar;
    v_cod_inter			varchar[];
    v_cod_inter_v2		varchar;
    v_estacion			varchar;
    v_filtro			varchar;
    v_cod				varchar;

BEGIN

	v_nombre_funcion = 'param.f_plantilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PM_PLT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		01-04-2013 21:49:11
	***********************************/

	if(p_transaccion='PM_PLT_SEL')then

    	begin

			v_consulta:='select
                            plt.id_plantilla,
                            plt.estado_reg,
                            plt.desc_plantilla,
                            plt.sw_tesoro,
                            plt.sw_compro,
                            plt.nro_linea,
                            plt.tipo,
                            plt.fecha_reg,
                            plt.id_usuario_reg,
                            plt.fecha_mod,
                            plt.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            plt.sw_monto_excento,
                            plt.sw_descuento ,
                            plt.sw_autorizacion,
                            plt.sw_codigo_control,
                            plt.tipo_plantilla,
                            plt.sw_ic,
                            plt.sw_nro_dui,
                            plt.tipo_excento,
                            plt.valor_excento,
                            plt.tipo_informe,
                            plt.sw_qr,
                            plt.sw_nit,
                            COALESCE(plt.plantilla_qr,''''),
                            plt.sw_estacion,
                            plt.sw_punto_venta,
                            plt.sw_cod_no_iata,
                            array_to_string(plt.cod_inter,'','',''null'')::varchar as cod_inter

						from param.tplantilla plt
						inner join segu.tusuario usu1 on usu1.id_usuario = plt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plt.id_usuario_mod
				        where plt.estado_reg = ''activo'' and ';


			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PM_PLT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		01-04-2013 21:49:11
	***********************************/

	elsif(p_transaccion='PM_PLT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_plantilla)
					    from param.tplantilla plt
					    inner join segu.tusuario usu1 on usu1.id_usuario = plt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plt.id_usuario_mod
					    where plt.estado_reg = ''activo'' and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;




    /*********************************
 	#TRANSACCION:  'PM_FILPLT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FILPLT_SEL')then

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

			v_consulta:='select
                            plt.id_plantilla,
                            plt.estado_reg,
                            plt.desc_plantilla,
                            plt.sw_tesoro,
                            plt.sw_compro,
                            plt.nro_linea,
                            plt.tipo,
                            plt.fecha_reg,
                            plt.id_usuario_reg,
                            plt.fecha_mod,
                            plt.id_usuario_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            plt.sw_monto_excento,
                            plt.sw_descuento ,
                            plt.sw_autorizacion,
                            plt.sw_codigo_control,
                            plt.tipo_plantilla,
                            plt.sw_ic,
                            plt.sw_nro_dui,
                            plt.tipo_excento,
                            plt.valor_excento,
                            plt.tipo_informe,
                            plt.sw_qr,
                            plt.sw_nit,
                            COALESCE(plt.plantilla_qr,''''),
                            plt.sw_estacion,
                            plt.sw_punto_venta,
                            plt.sw_cod_no_iata

						from param.tplantilla plt
						inner join segu.tusuario usu1 on usu1.id_usuario = plt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plt.id_usuario_mod

				        where  (''' ||v_filtro|| '''=ANY(plt.cod_inter)) and plt.estado_reg = ''activo'' and ';


			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;
        /*********************************
 	#TRANSACCION:  'PM_FILPLT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FILPLT_CONT')then

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
			v_consulta:='select count(id_plantilla)
					    from param.tplantilla plt
					    inner join segu.tusuario usu1 on usu1.id_usuario = plt.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = plt.id_usuario_mod
					    where  (''' ||v_filtro|| '''=ANY(plt.cod_inter)) and plt.estado_reg = ''activo'' and ';

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