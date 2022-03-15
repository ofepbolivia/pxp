CREATE OR REPLACE FUNCTION param.ft_archivo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Parametros Generales
 FUNCION: 		param.ft_archivo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tarchivo'
 AUTOR: 		 (favio.figueroa)
 FECHA:	        05-12-2016 15:04:48
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

	v_record_tipo_archivo record;
	v_record_campos record;
	v_record_join record;

	v_registros_json_join RECORD;
	v_join VARCHAR;

BEGIN

	v_nombre_funcion = 'param.ft_archivo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PM_ARCH_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	if(p_transaccion='PM_ARCH_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						arch.id_archivo,
						arch.estado_reg,
						arch.folder,
						arch.extension,
						arch.id_tabla,
						arch.nombre_archivo,
						arch.id_tipo_archivo,
						arch.fecha_reg,
						arch.usuario_ai,
						arch.id_usuario_reg,
						arch.id_usuario_ai,
						arch.id_usuario_mod,
						arch.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from param.tarchivo arch
						inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PM_ARCH_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARCH_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_archivo)
					    from param.tarchivo arch
					    inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PM_ARCOD_SEL'
 	#DESCRIPCION:	lista de registros
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARCOD_SEL')then

		begin
			v_consulta:='select
						arch.id_archivo,
						arch.estado_reg,
						arch.folder,
						arch.extension,
						arch.id_tabla,
						arch.nombre_archivo,
						tipar.id_tipo_archivo,
						arch.fecha_reg,
						arch.usuario_ai,
						arch.id_usuario_reg,
						arch.id_usuario_ai,
						arch.id_usuario_mod,
						arch.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tipar.tabla,
						tipar.nombre,
						tipar.codigo,
            tipar.multiple,
            arch.nombre_descriptivo,
            tipar.obligatorio
						from param.ttipo_archivo tipar
  left join param.tarchivo arch on arch.id_tipo_archivo = tipar.id_tipo_archivo and arch.id_tabla = '||v_parametros.id_tabla||'

  left join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
  left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
where
			 CASE WHEN tipar.multiple = ''si''  THEN (arch.extension is not null ) ELSE 0=0  END   AND       ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;
		end;
	/*********************************
 	#TRANSACCION:  'PM_ARCOD_CONT'
 	#DESCRIPCION:	conteo de registros
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARCOD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(tipar.id_tipo_archivo)
					    from param.ttipo_archivo tipar
  left join param.tarchivo arch on arch.id_tipo_archivo = tipar.id_tipo_archivo and arch.id_tabla = '||v_parametros.id_tabla||'

  left join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
  left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
/*********************************
 	#TRANSACCION:  'PM_ARVER_SEL'
 	#DESCRIPCION:	conteo de registros
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARVER_SEL')then

		begin


			--Sentencia de la consulta de conteo de registros
			v_consulta:='WITH RECURSIVE t(version,id_archivo_fk, id_archivo) AS (
										SELECT
											2 AS version,
											arch.id_archivo_fk,
											arch.id_archivo,
											arch.extension,
											arch.nombre_archivo,
											arch.id_tipo_archivo
										FROM param.tarchivo arch
										WHERE arch.id_archivo_fk = '||v_parametros.id_archivo||'

										UNION ALL
										SELECT
											version - 1,
											arch.id_archivo_fk,
											arch.id_archivo,
											arch.extension,
											arch.nombre_archivo,
											arch.id_tipo_archivo
										FROM param.tarchivo arch
											INNER JOIN t t ON t.id_archivo = arch.id_archivo_fk
									)
									--nuevo requerimiento 12 abril 2019
									SELECT
									arch.id_archivo,
									arch.estado_reg,
									arch.folder,
									arch.extension,
									arch.id_tabla,
									arch.nombre_archivo,
									arch.id_tipo_archivo,
									arch.fecha_reg,
									arch.usuario_ai,
									arch.id_usuario_reg,
									arch.id_usuario_ai,
									arch.id_usuario_mod,
									arch.fecha_mod,
									usu1.cuenta as usr_reg,
									usu2.cuenta as usr_mod,
									tipar.codigo,
									tipar.nombre,
									''-1''::varchar
								from param.tarchivo arch
									inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
									left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
									INNER JOIN param.ttipo_archivo tipar on tipar.id_tipo_archivo = arch.id_tipo_archivo
									WHERE arch.id_archivo = '||v_parametros.id_archivo||' and arch.estado_reg = ''inactivo''
									UNION ALL -- fin requerimieno 12 abril 2019

									SELECT
										arch.id_archivo,
										arch.estado_reg,
										arch.folder,
										arch.extension,
										arch.id_tabla,
										arch.nombre_archivo,
										arch.id_tipo_archivo,
										arch.fecha_reg,
										arch.usuario_ai,
										arch.id_usuario_reg,
										arch.id_usuario_ai,
										arch.id_usuario_mod,
										arch.fecha_mod,
										usu1.cuenta as usr_reg,
										usu2.cuenta as usr_mod,
										tipar.codigo,
										tipar.nombre,
										recursivo.version::varchar
									from t recursivo
										inner join param.tarchivo arch on arch.id_archivo = recursivo.id_archivo
										inner join segu.tusuario usu1 on usu1.id_usuario = arch.id_usuario_reg
										left join segu.tusuario usu2 on usu2.id_usuario = arch.id_usuario_mod
									INNER JOIN param.ttipo_archivo tipar on tipar.id_tipo_archivo = arch.id_tipo_archivo
									WHERE ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

/*********************************
 	#TRANSACCION:  'PM_ARTABLA_SEL'
 	#DESCRIPCION:	consulta con la tabla incluida
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARTABLA_SEL')then

		begin





			--obtenemos el tipo de archivo
			SELECT
				tipar.tabla,
				tipar.nombre_id,
				tipar.id_tipo_archivo
			INTO v_record_tipo_archivo
			FROM param.ttipo_archivo tipar
			WHERE codigo = v_parametros.tipo_archivo;



			--obtenemos join


			v_join = ' ';


			FOR v_registros_json_join IN (SELECT *
																		FROM param.ttipo_archivo_join tjoin
																		WHERE id_tipo_archivo = v_record_tipo_archivo.id_tipo_archivo) LOOP

				v_join = v_join || ' ' || v_registros_json_join.tipo || ' join ' || v_registros_json_join.tabla || ' ' ||v_registros_json_join.alias || ' on ' ||v_registros_json_join.condicion || ' ';

			END LOOP;





			v_consulta = 'select
			              '''||v_parametros.tipo_archivo||'''::varchar as tipo_archivo,
                    archivo.extension,
                    archivo.nombre_archivo,
                    archivo.folder,
                    archivo.nombre_descriptivo,
                    '||v_parametros.campos|| '
       from ' || v_record_tipo_archivo.tabla || ' tabla
      inner join param.tarchivo archivo on archivo.id_tabla = tabla.' || v_record_tipo_archivo.nombre_id || ' and archivo.id_archivo_fk is NULL
      '|| v_join ||'
      where

      archivo.id_tipo_archivo = ' || v_record_tipo_archivo.id_tipo_archivo || ' and ';





			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;



			--Devuelve la respuesta
			return v_consulta;

		end;

		/*********************************
 	#TRANSACCION:  'PM_ARTABLA_CONT'
 	#DESCRIPCION:	conteo de registros
 	#AUTOR:		favio.figueroa
 	#FECHA:		05-12-2016 15:04:48
	***********************************/

	elsif(p_transaccion='PM_ARTABLA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros





			SELECT
				tipar.tabla,
				tipar.nombre_id,
				tipar.id_tipo_archivo
			INTO v_record_tipo_archivo
			FROM param.ttipo_archivo tipar
			WHERE codigo = v_parametros.tipo_archivo;


			v_join = ' ';


			FOR v_registros_json_join IN (SELECT *
																		FROM param.ttipo_archivo_join tjoin
																		WHERE id_tipo_archivo = v_record_tipo_archivo.id_tipo_archivo) LOOP

				v_join = v_join || ' ' || v_registros_json_join.tipo || ' join ' || v_registros_json_join.tabla || ' ' ||v_registros_json_join.alias || ' on ' ||v_registros_json_join.condicion || ' ';

			END LOOP;


			v_consulta = 'select count(archivo.id_archivo)
       from ' || v_record_tipo_archivo.tabla || ' tabla
      inner join param.tarchivo archivo on archivo.id_tabla = tabla.' || v_record_tipo_archivo.nombre_id || ' and archivo.id_archivo_fk is NULL
       '|| v_join ||'
      where archivo.id_tipo_archivo = ' || v_record_tipo_archivo.id_tipo_archivo || ' and ';


			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
            RETURN v_consulta;

        END;

        /*********************************
        #TRANSACCION:  'PM_TYPEFILE_SEL'
        #DESCRIPCION: query for get type file and files
        #AUTOR:		favio.figueroa
        #FECHA:		25-05-2020 15:04:48
        ***********************************/

    ELSIF (p_transaccion = 'PM_TYPEFILE_SEL') THEN

        BEGIN

            v_consulta := 'SELECT * FROM (SELECT
                            tipar.id_tipo_archivo,
                            tipar.tabla,
                            tipar.nombre,
                            tipar.codigo,
                            tipar.extensiones_permitidas,
                            tipar.multiple,
                            tipar.obligatorio,
                            tipar.tipo_archivo,
                            tipar.orden,
                            arch.nombre_descriptivo,
                            arch.id_archivo,
                            arch.estado_reg,
                            arch.folder,
                            arch.extension,
                            arch.id_tabla,
                            arch.nombre_archivo,
                          (
                                SELECT TO_JSON(ROW_TO_JSON(jsonData) :: TEXT) #>> ''{}'' as json
                                from (
                                         SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(json_rol)))
                                         FROM (
                                                  select fta.id_field_tipo_archivo,
                                                         fva.id_field_valor_archivo,
                                                         fta.nombre,
                                                         fta.tipo,
                                                         fva.valor,
                                                         fta.descripcion
                                                  from param.tfield_tipo_archivo fta
                                                           left join param.tfield_valor_archivo fva
                                                                     on fva.id_field_tipo_archivo = fta.id_field_tipo_archivo and
                                                                        fva.id_archivo = arch.id_archivo
                                                           left join param.tarchivo a on a.id_archivo = fva.id_archivo
                                                  where fta.id_tipo_archivo = tipar.id_tipo_archivo
                                                    and (a.estado_reg != ''inactivo'' or a.estado_reg is NULL)
                                              ) json_rol
                                     ) as jsonData
                             ) AS field_type_value
                        FROM param.ttipo_archivo tipar
                                 LEFT JOIN param.tarchivo arch ON arch.id_tipo_archivo = tipar.id_tipo_archivo
                                                                      AND arch.id_tabla = ' || v_parametros.id_tabla || '
                        WHERE
                        tipar.codigo not in (''VER_TIT'',''Resp_Ver_Tit'',''VER_LIBR'',''RESP_VER_LIBR'') and
                        tipar.tabla = ''' || v_parametros.tabla || '''
                        AND arch.id_archivo_fk IS NULL
                        AND (arch.id_tabla =  ' || v_parametros.id_tabla || ' OR arch.id_tabla IS NULL)
                        AND tipar.multiple = ''no''
                        UNION ALL
                        SELECT
                            tipar.id_tipo_archivo,
                            tipar.tabla,
                            tipar.nombre,
                            tipar.codigo,
                            tipar.extensiones_permitidas,
                            tipar.multiple,
                            tipar.obligatorio,
                            tipar.tipo_archivo,
                            tipar.orden,
                            NULL as nombre_descriptivo,
                            NULL as id_archivo,
                            NULL as estado_reg,
                            NULL as folder,
                            NULL as extension,
                            NULL as id_tabla,
                            NULL as nombre_archivo,
                            NULL as field_type_value
                        FROM param.ttipo_archivo tipar
                        WHERE
                        tipar.codigo not in (''VER_TIT'',''Resp_Ver_Tit'',''VER_LIBR'',''RESP_VER_LIBR'') and
                        tipar.tabla = ''' || v_parametros.tabla || '''
                          AND tipar.multiple = ''si'') t
                          ORDER BY t.orden ASC
                        ' ;

            v_consulta := v_consulta || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            RETURN v_consulta;

        END;


    /*********************************
    #TRANSACCION:  'PM_FILES_SEL'
    #DESCRIPCION:	get file
    #AUTOR:		favio.figueroa
    #FECHA:		25-05-2020 15:04:48
    ***********************************/

    ELSIF (p_transaccion = 'PM_FILES_SEL') THEN

        BEGIN
            v_consulta := 'SELECT a.id_archivo,
                                   a.folder,
                                   a.extension,
                                   a.nombre_archivo
                            FROM param.tarchivo a
                            INNER JOIN param.ttipo_archivo ta on ta.id_tipo_archivo = a.id_tipo_archivo
                            WHERE a.estado_reg != ''inactivo'' and ta.id_tipo_archivo = '||v_parametros.id_tipo_archivo||' AND a.id_tabla = '||v_parametros.id_tabla||' AND ';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            RETURN v_consulta;
        END;
    /*********************************
     #TRANSACCION:  'PM_FILES_CONT'
     #DESCRIPCION:	conteo de registros
     #AUTOR:		favio.figueroa
     #FECHA:		05-12-2016 15:04:48
    ***********************************/

    ELSIF (p_transaccion = 'PM_FILES_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta := 'SELECT COUNT(*)
                            FROM param.tarchivo a
                            INNER JOIN param.ttipo_archivo ta on ta.id_tipo_archivo = a.id_tipo_archivo
                            WHERE ta.id_tipo_archivo = '||v_parametros.id_tipo_archivo||' AND a.id_tabla = '||v_parametros.id_tabla||' AND ';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

    ELSE

        RAISE EXCEPTION 'Transaccion inexistente';

    END IF;

EXCEPTION

	WHEN OTHERS THEN
			v_resp='';
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
			v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
			v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION param.ft_archivo_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;