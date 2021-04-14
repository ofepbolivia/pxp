CREATE OR REPLACE FUNCTION orga.ft_estructura_uo_ime (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla varchar,
  par_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 FUNCION: 		rhum.ft_estructura_uo_ime
 DESCRIPCIÓN:   modificaciones de funciones
 AUTOR: 	    KPLIAN (mzm)
 FECHA:
 COMENTARIOS:
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:		23-05-2011
 ***************************************************************************/
DECLARE


v_parametros                record;
v_resp                      varchar;
v_nombre_funcion            text;
v_mensaje_error             text;

v_id_uo  				    integer;



--10-04-2012: sincronizacion de UO entre BD
v_respuesta_sinc            varchar;

--variables para drag and drop
v_consulta					varchar = '';
v_unidad					record;
v_estructura_uo 			record;
BEGIN



     v_nombre_funcion:='orga.ft_estructura_uo_ime';
     v_parametros:=pxp.f_get_record(par_tabla);


 /*******************************
 #TRANSACCION:  RH_ESTRUO_INS
 #DESCRIPCION:	Inserta estructura de uos
 #AUTOR:
 #FECHA:		23-05-2011
***********************************/
     if(par_transaccion='RH_ESTRUO_INS')then


          BEGIN


               -- validacion de un solo nodo_base
               if exists (select distinct 1 from orga.tuo where nodo_base='si' and estado_reg='activo' and v_parametros.nodo_base='si') then
                  raise exception 'Insercion no realizada. Ya se definio alguna unidad como nodo base';
               end if;

               -- verificar duplicidad de codigo de uo
               if exists (select distinct 1 from orga.tuo where lower(codigo)=lower(v_parametros.codigo) and estado_reg='activo') then
               end if;
               -- insercion de uo nueva


               insert into orga.tuo(
                   codigo,
                   nombre_unidad,nombre_cargo,
                   descripcion,
                   cargo_individual,
                   presupuesta,
                   estado_reg,
                   fecha_reg,
                   id_usuario_reg,
                   nodo_base,
                   correspondencia,
                   gerencia,
                   id_nivel_organizacional,
                   prioridad)
               values(
                 upper(v_parametros.codigo),
                 v_parametros.nombre_unidad,
                 v_parametros.nombre_cargo,
                 v_parametros.descripcion,
                 v_parametros.cargo_individual,
                 v_parametros.presupuesta,
                 'activo',
                 now()::date,
                 par_id_usuario,
                 v_parametros.nodo_base,
                 v_parametros.correspondencia,
                 v_parametros.gerencia,
                 v_parametros.id_nivel_organizacional,
                 case when v_parametros.prioridad = '' then null else  v_parametros.prioridad end)

               RETURNING id_uo into v_id_uo;

               -- relacion de uo_hijo a o_padre



                IF(v_parametros.id_uo_padre <> 'id') THEN


                 INSERT INTO orga.testructura_uo(
                 	id_uo_hijo,
                 	id_uo_padre,
                 	estado_reg,
                   	id_usuario_reg,
                   	fecha_reg,
                   	id_uo_padre_operativo
                 )
                 values(
                 	v_id_uo,
                  	(v_parametros.id_uo_padre)::integer,
                  	'activo',
                   	par_id_usuario,
                   	now()::date,
                  	v_parametros.id_uo_padre::integer
                 );

                 ELSE

                    if(v_parametros.nodo_base='no')then

                    raise exception 'Cuando se trata de la raiz del organigrama tienes que colocar nodo_base = si';

                    end if;


                END IF;







              /* --10-04-2012: sincronizacion de UO entre BD
               v_respuesta_sinc:=orga.f_sincroniza_uo_entre_bd(v_id_uo,'10.172.0.13','5432','db_link','db_link','dbendesis' ,'INSERT');

               if(v_respuesta_sinc!='si')  then
                     raise exception 'Sincronizacion de UO en BD externa no realizada%',v_respuesta_sinc;
               end if;  */

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','estructura uo '||v_parametros.nombre_unidad ||' insertado con exito a ' || v_parametros.id_uo_padre);
               v_resp = pxp.f_agrega_clave(v_resp,'id_uo',v_id_uo::varchar);
         END;
 /*******************************
 #TRANSACCION:  RH_ESTRUO_MOD
 #DESCRIPCION:	Modifica la parametrizacion seleccionada
 #AUTOR:
 #FECHA:		23-05-2011
***********************************/
     elsif(par_transaccion='RH_ESTRUO_MOD')then


          BEGIN


               -- validacion de un solo nodo_base
               if exists (select distinct 1 from orga.tuo where nodo_base='si' and estado_reg='activo' and id_uo!=v_parametros.id_uo and v_parametros.nodo_base='si') then
                  raise exception 'Insercion no realizada. Ya se definio alguna unidad como nodo base';
               end if;

               update orga.tuo
               set codigo=upper(v_parametros.codigo),
                   nombre_unidad= v_parametros.nombre_unidad,
                   nombre_cargo=v_parametros.nombre_cargo,
                   descripcion=v_parametros.descripcion,
                   cargo_individual=v_parametros.cargo_individual,
                   presupuesta=v_parametros.presupuesta,
                   nodo_base=v_parametros.nodo_base,
                   correspondencia=v_parametros.correspondencia,
                   gerencia=v_parametros.gerencia,
                   id_nivel_organizacional = v_parametros.id_nivel_organizacional,
                   prioridad = case when v_parametros.prioridad = '' then null else  v_parametros.prioridad end
                where id_uo=v_parametros.id_uo;

               /* --10-04-2012: sincronizacion de UO entre BD
                v_respuesta_sinc:=orga.f_sincroniza_uo_entre_bd(v_parametros.id_uo,'10.172.0.13','5432','db_link','db_link','dbendesis' ,'UPDATE');

                if(v_respuesta_sinc!='si')  then
                     raise exception 'Sincronizacion de UO en BD externa no realizada%',v_respuesta_sinc;
                end if; */

                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','estructura uo modificado con exito '||v_parametros.id_uo);
                v_resp = pxp.f_agrega_clave(v_resp,'id_uo',v_parametros.id_uo::varchar);
          END;

/*******************************
 #TRANSACCION:  RH_ESTRUO_ELI
 #DESCRIPCION:	Inactiva la parametrizacion selecionada. Verifica dependencias hacia abajo
 #AUTOR:
 #FECHA:		23-05-2011
 *********************************
 #AUTOR_MOD:	KPLIAN (rac)
 #FECHA_MOD:	23-05-2011
 #DESC_MON:		Valida la eliminacion de nodos solo si sus hijos estan inactivos
***********************************/

    elsif(par_transaccion='RH_ESTRUO_ELI')then
        BEGIN




           --1) verificamos si tiene relaciones activas con sus hijos (asumimos que si tiene hijos tendra relaciones activas con ellos)

            if exists ( select DISTINCT 1
                          from orga.tuo uo
                          inner join  orga.testructura_uo euo on uo.id_uo = euo.id_uo_padre and euo.estado_reg='activo'
                          where uo.id_uo = v_parametros.id_uo) then

                        --NOTA) sera necesario adicionar  una trsaccion que realize una eliminacion recursiva
                        --      previa confirmacion del usuario despues de este error

                        raise exception 'Eliminacion no realizada.  La Unidad que se inactiva tiene dependencias  elimine primero los hijos';

              end if;

              --2) se fija que no tenga funcionarios en estado activo asignados a este uo
              if exists ( select DISTINCT 1
                          from orga.tuo_funcionario uof
                          where uof.id_uo = v_parametros.id_uo and uof.estado_reg='activo' and uof.estado_funcional = 'activo') then


                        raise exception 'Eliminacion no realizada. La Unidad que se intenta eliminar tiene relaciones vigentes con empleados';

              end if;

               --3) inactiva la unidad
               update orga.tuo
               set estado_reg='inactivo'
               where id_uo=v_parametros.id_uo;


               -- 4) inactiva las relaciones con los padres (para que se cumpla siempre la regla en 1)
               update orga.testructura_uo
               set estado_reg='inactivo'
               where id_uo_hijo=v_parametros.id_uo;

               --10-04-2012: sincronizacion de UO entre BD
               /* v_respuesta_sinc:=orga.f_sincroniza_uo_entre_bd(v_parametros.id_uo,'10.172.0.13','5432','db_link','db_link','dbendesis' ,'DELETE');

                if(v_respuesta_sinc!='si')  then
                     raise exception 'Sincronizacion de UO en BD externa no realizada%',v_respuesta_sinc;
                end if;*/

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','estructura uo eliminada con exito '||v_parametros.id_uo);
               v_resp = pxp.f_agrega_clave(v_resp,'id_uo',v_parametros.id_uo::varchar);

        END;
    /*******************************
    #TRANSACCION:	RH_ESTRUO_DRAG_DROP
    #DESCRIPCION:	Cambiar el padre de un nodo en el arbol de UO
    #AUTOR:			franklin.espinoza
    #FECHA:			16/10/2019
    #RESUMEN:
      ***********************************/
    ELSEIF (par_transaccion='RH_ESTRUO_DRAG_DROP') THEN
      BEGIN
        -- 1) si point es igual append
          IF (v_parametros.punto='append') then
                update orga.testructura_uo  set
                  id_uo_padre = v_parametros.id_target
                  where id_uo_hijo = v_parametros.id_nodo;

                  insert into orga.tmod_estructura_uo(
                    id_uo_padre,
                    id_uo_hijo,
                      id_uo_padre_old,
                    estado_reg,
                    id_usuario_reg,
                    fecha_reg
                  )values(
                    v_parametros.id_target,
                      v_parametros.id_nodo,
                      v_parametros.id_old_parent,
                    'activo',
                     par_id_usuario,
                     now()
                  );

            select tu.nombre_unidad, tu.descripcion, tu.codigo, tu.correspondencia, tu.id_nivel_organizacional, tu.estado_reg
            into v_unidad
            from orga.tuo tu
            where tu.id_uo = v_parametros.id_nodo;

            v_consulta =  'exec Ende_Organigrama "DRAG", '||v_parametros.id_nodo||', '||
          	v_parametros.id_target||', "'||coalesce(v_unidad.nombre_unidad,'')||'", "'||coalesce(v_unidad.descripcion,'')||'", "'||
          	coalesce(v_unidad.codigo,'')||'", "'||coalesce(v_unidad.correspondencia,'')||'", null, '||extract(year from current_date)||',  '||v_unidad.id_nivel_organizacional||
                ', "'||v_unidad.estado_reg||'", '||v_parametros.id_target||', "", "";';

            INSERT INTO sqlserver.tmigracion
            (
              id_usuario_reg,
              consulta,
              estado,
              respuesta,
              operacion,
              cadena_db
            )
            VALUES (
              par_id_usuario,
              v_consulta,
              'pendiente',
              null,
              'DRAG',
              pxp.f_get_variable_global('cadena_db_sql_2')
            );
          ELSE
        --	2) regresar error point no soportados
            raise exception 'POINT no soportado %',v_parametros.punto;
          END IF;

          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DRANG AND DROP exitoso id_nodo='||v_parametros.id_nodo||' id_target= '|| v_parametros.id_target||'  id_old_gui='|| v_parametros.id_old_parent);
          return v_resp;
      END;

    /*******************************
    #TRANSACCION:	RH_EUO_DRAG_DROP_O
    #DESCRIPCION:	Cambiar el padre operativo de un nodo en el arbol de UO
    #AUTOR:			franklin.espinoza
    #FECHA:			24/03/2020
    #RESUMEN:
    ***********************************/
    ELSEIF (par_transaccion='RH_EUO_DRAG_DROP_O') THEN
      BEGIN
        -- 1) si point es igual append
          IF (v_parametros.punto='append') then
            update orga.testructura_uo  set
            id_uo_padre_operativo = v_parametros.id_target
            where id_uo_hijo = v_parametros.id_nodo;
			--raise 'v_parametros.id_target: %, v_parametros.id_nodo: %, v_parametros.id_old_parent: %',v_parametros.id_target, v_parametros.id_nodo, v_parametros.id_old_parent;

            select teo.id_uo_padre, teo.id_uo_hijo
            into v_estructura_uo
            from orga.testructura_uo teo
            where id_uo_hijo = v_parametros.id_nodo;

            insert into orga.tmod_estructura_uo(
              id_uo_padre,
              id_uo_hijo,
                id_uo_padre_operativo_old,
              estado_reg,
              id_usuario_reg,
              fecha_reg
            )values(
              v_parametros.id_target,
                v_parametros.id_nodo,
                v_parametros.id_old_parent,
              'activo',
               par_id_usuario,
               now()
            );
          	select tu.nombre_unidad, tu.descripcion, tu.codigo, tu.correspondencia, tu.id_nivel_organizacional, tu.estado_reg
            into v_unidad
            from orga.tuo tu
            where tu.id_uo = v_parametros.id_nodo;

            /*v_consulta =  'exec Ende_Organigrama "DRAG", '||v_estructura_uo.id_uo_hijo||', '||
          	v_estructura_uo.id_uo_padre||', "'||coalesce(v_unidad.nombre_unidad,'')||'", "'||coalesce(v_unidad.descripcion,'')||'", "'||
          	coalesce(v_unidad.codigo,'')||'", "'||coalesce(v_unidad.correspondencia,'')||'", null, '||extract(year from current_date)||',  '||
            v_unidad.id_nivel_organizacional||', "'||v_unidad.estado_reg||'", '||v_parametros.id_target||';';

            INSERT INTO sqlserver.tmigracion
            (
              id_usuario_reg,
              consulta,
              estado,
              respuesta,
              operacion,
              cadena_db
            )
            VALUES (
              par_id_usuario,
              v_consulta,
              'pendiente',
              null,
              'DRAG',
              pxp.f_get_variable_global('cadena_db_sql_2')
            );*/
          ELSE
        --	2) regresar error point no soportados
            raise exception 'POINT no soportado %',v_parametros.punto;
          END IF;

          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','DRANG AND DROP exitoso id_nodo='||v_parametros.id_nodo||' id_target= '|| v_parametros.id_target||'  id_old_gui='|| v_parametros.id_old_parent);
          return v_resp;
      END;


    else

         raise exception 'No existe la transaccion: %',par_transaccion;
    end if;

 return v_resp;

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