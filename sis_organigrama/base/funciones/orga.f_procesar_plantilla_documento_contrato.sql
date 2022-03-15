CREATE OR REPLACE FUNCTION orga.f_procesar_plantilla_documento_contrato (
  p_id_uo_funcionario integer,
  p_id_funcionario integer,
  p_id_uo integer,
  p_id_cargo integer,
  p_tipo varchar
)
RETURNS text AS
$body$
DECLARE

v_tmp_plantilla      text;
v_prefijo            varchar;
v_columna            varchar;
v_columnas_consulta  varchar;
v_columna_nueva      varchar[];
v_registros			 record;

v_sw_busqueda  boolean;
v_tabla					record;
v_tabla_hstore          hstore;
v_nombre_funcion  varchar;
v_resp  varchar;
v_i     integer;

v_template_evaluado    varchar;
v_validar_nulo boolean;



v_cargo 		record;
v_documento		record;
v_funcionario	record;

v_id_documento  integer;
BEGIN


                --obtenemos datos basicos
                select car.codigo, tip.id_tipo_contrato
                into v_cargo
                from orga.tcargo car
                inner join orga.ttipo_contrato tip on tip.id_tipo_contrato = car.id_tipo_contrato
                where car.id_cargo = p_id_cargo;

                select vf.desc_funcionario2 nombre
                into v_funcionario
                from orga.vfuncionario vf
                where vf.id_funcionario = p_id_funcionario;


                select tuca.id_tipo_documento_contrato
                into v_id_documento
                from orga.tuo_contrato_anexo tuca
                where tuca.id_uo = p_id_uo and tuca.id_tipo_contrato = v_cargo.id_tipo_contrato;


				--raise 'a: %, b: %, c: %, d: %',v_cargo, v_funcionario,v_id_documento, p_id_uo;
                if v_cargo.codigo != '0' and p_tipo = 'contrato' then
                  select doc.contenido, doc.tabla
                  into v_documento
                  from orga.ttipo_documento_contrato doc
                  where doc.id_tipo_contrato = v_cargo.id_tipo_contrato;

                elsif v_cargo.codigo = '0' and p_tipo = 'contrato' then
                  select doc.contenido, doc.tabla
                  into v_documento
                  from orga.ttipo_documento_contrato doc
                  where doc.id_tipo_contrato = v_cargo.id_tipo_contrato;

                elsif v_id_documento is not null and p_tipo = 'anexo' then
                    select doc.contenido, doc.tabla
                    into v_documento
                    from orga.ttipo_documento_contrato doc
                    where doc.id_tipo_documento_contrato = v_id_documento;

                elsif v_cargo.codigo = '0' and p_tipo = 'anexo' then
                    select doc.contenido, doc.tabla
                    into v_documento
                    from orga.ttipo_documento_contrato doc
                    where doc.id_tipo_documento_contrato = 4;

                elsif v_cargo.codigo != '0' and p_tipo = 'anexo' then
                    select doc.contenido, doc.tabla
                    into v_documento
                    from orga.ttipo_documento_contrato doc
                    where doc.id_tipo_documento_contrato = 3;

                end if;

                v_prefijo = 'tabla';
                v_tmp_plantilla = v_documento.contenido;
                v_template_evaluado = v_documento.contenido;
                v_nombre_funcion = 'orga.f_procesar_plantilla_documento_contrato';
                v_validar_nulo = TRUE;
                 ------------------------------------------------------------------------
                 --  RECUPERAMOS LOS NOMBRES DE LAS PALABRAS CLAVE DE LA PLANTILLA QUE
                 --  HACEN REFERENCIA A LA TABLA DE TIPO PROCESO
                 -------------------------------------------------------------------------
                 IF  v_documento.tabla != '' and v_documento.tabla is not null THEN
                      LOOP
                            --resetemaos el sw de busquedas
                            v_sw_busqueda = FALSE;

                             -- buscar palabras clave en la plantilla

                            v_columna  =  substring(v_tmp_plantilla from '%#"#{$'||v_prefijo||'.%#}#"%' for '#');

                            --limpia la cadena original para no repetir la bsuqueda
                            v_tmp_plantilla = replace( v_tmp_plantilla, v_columna, '----');

                            --deja solo el nombre de la variable
                            v_columna= split_part(v_columna,'{$'||v_prefijo||'.',2);
                            v_columna= split_part( v_columna,'}',1);

                            IF(v_columna != '' and v_columna is not null )  THEN

                               v_columna_nueva = array_append(v_columna_nueva,v_columna);
                               --marcamos la bancera para seguir buscando
                               v_sw_busqueda = TRUE;

                            END IF;
                            --si no se agrego nada mas tenemos la busqueda
                            IF not v_sw_busqueda THEN

                                exit;
                           END IF;
                      END LOOP;
                 END IF;
                 ----------------------------------------------------------------------------
                 --  Obtener valores de las palabras clave que hacen referencia a latabla
                 ---------------------------------------------------------------------------
                  v_columnas_consulta=v_columna_nueva::varchar;
                  v_columnas_consulta=replace(v_columnas_consulta,'{','');
                  v_columnas_consulta=replace(v_columnas_consulta,'}','');

                --  solo si existe tabla de referencia
                IF  v_documento.tabla != '' and v_documento.tabla is not null and v_columnas_consulta != '' and v_columnas_consulta is not null THEN

                      execute  'select '||v_columnas_consulta ||
                                 ' from '||v_documento.tabla|| ' where '
                                ||v_documento.tabla||'.id_uo_funcionario='|| p_id_uo_funcionario ||'' into v_tabla;

                       --------------------------------------------------
                       --  REMPLAZAR valores obtenidos en la plantilla
                       --------------------------------------------------
                       v_i = 1;
                       v_tabla_hstore =  hstore(v_tabla);

                       IF v_tabla is null  THEN
                         v_validar_nulo = FALSE;
                       END IF;

                       --subsituye los nombre de variable encontradas en la plantilla por los valores obtenidos de la tabla
                       WHILE (v_i <= array_length(v_columna_nueva, 1)) LOOP --raise 'adentro';
                            --sin espacios
                            v_template_evaluado = replace(v_template_evaluado, '{$tabla.'||v_columna_nueva[v_i]||'}',replace(( v_tabla_hstore->v_columna_nueva[v_i]), '"', '')::varchar);
                            v_i = v_i +1;
                       END LOOP;

                END IF;

                IF v_validar_nulo  THEN
                   IF v_template_evaluado is NULL THEN --RAISE 'p_tipo: %', p_tipo;
                       raise exception 'En la plantilla ,revise la información del funcionario: %',v_funcionario.nombre;
                   END IF;
                END IF;

              return  v_template_evaluado;



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

ALTER FUNCTION orga.f_procesar_plantilla_documento_contrato (p_id_uo_funcionario integer, p_id_funcionario integer, p_id_uo integer, p_id_cargo integer, p_tipo varchar)
  OWNER TO postgres;