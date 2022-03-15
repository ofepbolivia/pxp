--------------- SQL ---------------

CREATE OR REPLACE FUNCTION gen.ft_tabla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
DECLARE

    v_nro_requerimiento    	integer;
    v_parametros           	record;
    v_id_requerimiento     	integer;
    v_resp		            varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_tabla			integer;
    v_registros         record;
    v_tabla_antigua     varchar;
    v_esquema           varchar;

    --(franklin.espinoza)insertar data en tablas parametricas
    v_record_json			jsonb;
    v_query_insert			text = '';
    v_array_columns			varchar[];
    v_name_type 			varchar[];
    v_column				varchar;
	  v_contador				integer = 1;
    v_data					text;
    v_length				integer;
    v_id_usuario    integer;
/*

 id_proyecto
 denominacion 
 descripcion
 estado_reg 

*/

BEGIN

     v_nombre_funcion:='gen.ft_tabla_ime';
     v_parametros:=pxp.f_get_record(p_tabla);

     if(p_transaccion='GEN_TABLA_INS')then

          BEGIN
                select lower(s.codigo)
                into v_esquema
                from segu.tsubsistema s
                where id_subsistema=v_parametros.id_subsistema;
                
               insert into gen.ttabla(
		          esquema,
		          nombre,
                 titulo,
                 id_subsistema,
                 id_usuario_reg,
                 id_usuario_mod,
                 fecha_reg,
                 fecha_mod,
                 estado_reg,
                 alias,
                 --reemplazar,
                 --menu,
                 --direccion,
                 cant_grupos
               ) values(
                v_esquema,
                v_parametros.nombre,
                v_parametros.titulo,
                v_parametros.id_subsistema,
                p_id_usuario,
                NULL,
                now(),
                NULL,
                'activo',
                v_parametros.alias,
                --v_parametros.reemplazar,
                --v_parametros.menu,
                --v_parametros.direccion,
                v_parametros.cant_grupos
               )RETURNING id_tabla into v_id_tabla;
                --raise exception 'llega%',v_parametros.nombre;
              
          		--Registro de las colummas de la tabla
                insert into gen.tcolumna(
                id_usuario_reg,
                 estado_reg, 
                 nombre, 
                 descripcion,  
                 tipo_dato, 
                 longitud, 
                 nulo,
                id_tabla, 
                etiqueta, 
                guardar, checks, valor_defecto, grid_ancho, grid_mostrar,
                form_ancho_porcen, orden, grupo
                )
                select
                p_id_usuario, 'activo', columna, descripcion, tipo_dato, longitud, nulo,
                v_id_tabla, columna, 'si', checks, valor_defecto,grid_ancho, grid_mostrar,
                form_ancho_porcen, orden, grupo
                from gen.f_obtener_datos_tabla_sel(p_id_usuario,v_parametros.nombre,'GEN_COLUMN_SEL') as (
                columna varchar,descripcion varchar,tipo_dato varchar,longitud text,
                nulo varchar,checks varchar, valor_defecto varchar, grid_ancho INTEGER,
                grid_mostrar varchar, form_ancho_porcen integer, orden smallint, grupo smallint);
                --
               
				v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tabla almacenada con exito (id_tabla'||v_id_tabla||')'); 
          		v_resp = pxp.f_agrega_clave(v_resp,'id_tabla',v_id_tabla::varchar);

               return v_resp;

         END;

     elsif(p_transaccion='GEN_TABLA_MOD')then

          BEGIN

              select nombre
              into v_tabla_antigua
              from gen.ttabla
              where id_tabla=v_parametros.id_tabla;
              select lower(s.codigo)
                into v_esquema
                from segu.tsubsistema s
                where id_subsistema=v_parametros.id_subsistema;
              if(v_tabla_antigua!=v_parametros.nombre)then
                delete from gen.tcolumna
                where id_tabla=v_parametros.id_tabla;
                
                --Registro de las colummas de la tabla
                insert into gen.tcolumna(
                id_usuario_reg, estado_reg, nombre, descripcion,  tipo_dato, longitud, nulo,
                id_tabla, etiqueta, guardar
                )
                select
                p_id_usuario, 'activo', columna, descripcion, tipo_dato, longitud, nulo,
                v_parametros.id_tabla, columna, 'si'
                from gen.f_obtener_datos_tabla_sel(p_id_usuario,v_parametros.nombre,'GEN_COLUMN_SEL') as (
                id integer,columna varchar,descripcion varchar,tipo_dato varchar,longitud integer,nulo varchar,checks varchar);
                --
              
              end if;
              

               update gen.ttabla set
               esquema=v_esquema,
               nombre=v_parametros.nombre,
               titulo=v_parametros.titulo,
               id_subsistema=v_parametros.id_subsistema,
               id_usuario_mod=p_id_usuario,
               fecha_mod=now(),
               alias = v_parametros.alias,
              -- reemplazar = v_parametros.reemplazar,
              -- menu = v_parametros.menu,
              -- direccion=v_parametros.direccion,
               cant_grupos=v_parametros.cant_grupos
               where id_tabla=v_parametros.id_tabla;
               
               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tabla modificada'); 
               v_resp = pxp.f_agrega_clave(v_resp,'id_tabla',v_parametros.id_tabla::varchar);
               
               return v_resp;
          END;

    elsif(p_transaccion='GEN_TABLA_ELI')then

          BEGIN
                delete from gen.tcolumna
               where id_tabla=v_parametros.id_tabla;
               
               delete from gen.ttabla
               where id_tabla=v_parametros.id_tabla;

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tabla eliminada'); 
               v_resp = pxp.f_agrega_clave(v_resp,'id_tabla',v_parametros.id_tabla::varchar);
              
               return v_resp;
         END;

    /*********************************
 	#TRANSACCION:  'GEN_DATA_TABLE_INS'
 	#DESCRIPCION:	Inserta data en una tabla especifica
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-07-2020 18:32:59
	***********************************/
    elsif(p_transaccion='GEN_DATA_TABLE_INS')then

      BEGIN
            v_array_columns = string_to_array(v_parametros.columns,',');
            v_length =  array_length(v_array_columns,1);


			if 'truncate' = v_parametros.action or 'insert' = v_parametros.action then

            	if 'truncate' = v_parametros.action then
                	execute ('TRUNCATE TABLE '||v_parametros.tabla||' RESTART IDENTITY');
                end if;

                for v_record_json in SELECT * FROM jsonb_array_elements(v_parametros.registros)  loop

                    v_query_insert = 'insert into '||v_parametros.tabla||'(id_usuario_reg,';
                    v_contador = 1;
                    foreach v_column in array v_array_columns loop
                        v_name_type = string_to_array(v_column,':');--raise 'v_name_type: :%',v_name_type;

                        if v_contador = v_length then
                            v_query_insert = v_query_insert||v_name_type[1];
                            v_contador = 1;
                        else
                            v_query_insert = v_query_insert||v_name_type[1]||',';
                        end if;
                        v_contador = v_contador + 1;
                    end loop;

                    v_query_insert = v_query_insert||') values('||p_id_usuario||',';
                    v_contador = 1;
                    foreach v_column in array v_array_columns loop
                        v_name_type = string_to_array(v_column,':');
                        v_data = v_record_json->>v_name_type[1];
                        if v_contador = v_length then
                            if '' = v_data then
                                v_query_insert = v_query_insert||'null::'||v_name_type[2];
                            else
                                v_query_insert = v_query_insert||''''||v_data||'''::'||v_name_type[2];
                            end if;
                            v_contador = 1;
                        else
                            if '' = v_data then
                                v_query_insert = v_query_insert||'null::'||v_name_type[2]||',';
                            else
                                v_query_insert = v_query_insert||''''||v_data||'''::'||v_name_type[2]||',';
                            end if;
                        end if;
                        v_contador = v_contador + 1;
                    end loop;
                    v_query_insert = v_query_insert||')';

                   execute(v_query_insert);
                end loop;

            elsif 'update' = v_parametros.action then

            	for v_record_json in SELECT * FROM jsonb_array_elements(v_parametros.registros)  loop

                    if 'sigep.tobjeto_gasto' = v_parametros.tabla then

                    	select tpi.id_partida_dos
                        into v_identificador
                        from pre.tpartida_ids tpi
                        where tpi.id_partida_uno = (v_record_json->>'id_partida')::integer;

                    end if;

                    if v_identificador is not null then
                        v_query_insert = 'update '||v_parametros.tabla||' set ';
                        v_query_insert = v_query_insert||'id_partida='||v_identificador;
                        v_query_insert = v_query_insert||'where id_objeto='||(v_record_json->>'id_objeto')||' and objeto='''||(v_record_json->>'objeto')||'''';

                    	execute(v_query_insert);
                    end if;

                end loop;
            end if;


        	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros Insertados Correctamente en la tabla');
       		--v_resp = pxp.f_agrega_clave(v_resp,'id_tabla',v_parametros.id_tabla::varchar);

       		return v_resp;
        END;

    else
     
         raise exception 'Transacción inexistente: %',p_transaccion;

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