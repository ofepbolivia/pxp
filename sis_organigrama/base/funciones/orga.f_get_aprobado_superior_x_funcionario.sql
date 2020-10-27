CREATE OR REPLACE FUNCTION orga.f_get_aprobado_superior_x_funcionario (
  par_fecha date,
  par_id_funcionario integer,
  par_filtro_presupuesto varchar = 'si'::character varying
)
RETURNS integer AS
$body$
/*

AUTOR: maylee.perez
FECHA  17/7/2020
Descripcion filtra los usarios inmediato superior por funcionario segun organigrama

parametros
   par_id_funcionario        funcionario sobre el que se busca
   par_filtro_presupuesto    si, no o todos


*/


DECLARE
  	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    --v_consulta				text;
    v_consulta				integer;
    v_id_funcionario		integer;
    v_filtro_pre			varchar;
    v_filtro_gerencia       varchar;
    v_lista_blanca          varchar;
    v_lista_negra           varchar;
    v_count_funcionario_ope	integer;

    par_filtro_gerencia  varchar;
    par_lista_blanca_nivel	varchar;
    par_lista_negra_nivel	varchar;

    v_funcionario			integer;
    v_desc_funcionario		varchar;
    v_numero_nivel			numeric;
    v_nivel 				text;

BEGIN




  	v_nombre_funcion = 'orga.f_get_aprobado_superior_x_funcionario';


    --raise exception 'ssss';
        par_lista_blanca_nivel = 'todos';
        par_lista_negra_nivel ='ninguno';
        par_filtro_gerencia = 'todos';

        --chequea si es necsario agregar un filtr de presupuestos
        IF par_filtro_presupuesto = 'todos' THEN
         v_filtro_pre = '';
        ELSE
          v_filtro_pre = 'and presupuesta = '''||par_filtro_presupuesto||'''';
        END IF;

        --chequea si es necsario agregar un filtr de presupuestos
        IF par_filtro_gerencia = 'todos' THEN
         v_filtro_gerencia = '';
        ELSE
          v_filtro_gerencia = 'and gerencia = '''||par_filtro_gerencia||'''';
        END IF;

        --chequea que niveles de organigrama entran en la lista, viene separados por comas ejm,..  0,1,2 ...  es el numero de la tabla nivel olrganizacion
        IF par_lista_blanca_nivel = 'todos' THEN
         v_lista_blanca = '';
        ELSE
          v_lista_blanca = ' and numero_nivel  in ('||par_lista_blanca_nivel||')  ';
        END IF;

        --chequea que niveles de organizaci, viene septa n no entran en la lisarados por comas ejm,..  0,1,2 ...  es el numero de la tabla nivel olrganizacion
        IF par_lista_negra_nivel = 'ninguno' THEN
            v_lista_negra = '';
        ELSE
            v_lista_negra = '  and  numero_nivel not in ('||par_lista_negra_nivel||')  ';
        END IF;

        SELECT fun.desc_funcionario1
        INTO v_desc_funcionario
        FROM orga.vfuncionario fun
        WHERE  fun.id_funcionario = par_id_funcionario ;



   --raise exception 'lleganumnivel %',v_numero_nivel;


    --raise exception 'lleganumnivel2 %',v_nivel;

        select
          count(ufo.id_uo_funcionario_ope)
        into
          v_count_funcionario_ope
        FROM  orga.tuo_funcionario_ope ufo
        WHERE id_funcionario = par_id_funcionario
        and   par_fecha BETWEEN ufo.fecha_asignacion and ufo.fecha_finalizacion and ufo.estado_reg = 'activo';

    --raise EXCEPTION 'llega fun %',v_count_funcionario_ope;


        IF  v_count_funcionario_ope > 1 THEN
          raise exception 'El Funcionario % tiene mas de una asignación funcional en el organigrama, consulte con el administrador de sistemas', v_desc_funcionario;
        ELSIF v_count_funcionario_ope = 1 THEN

             --si el funcioanrio tiene asginacion funcional
             --Obtener todos los empleados de la asignacion

              WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                      SELECT uofun.id_funcionario, uo.id_uo, uo.presupuesta, uo.gerencia,  0::numeric
                      FROM orga.tuo_funcionario_ope uofun
                      inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                      WHERE uofun.fecha_asignacion <= par_fecha
                      and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha )
                      and uofun.estado_reg = 'activo' and uofun.id_funcionario =  par_id_funcionario
                  UNION
                      SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                      FROM orga.testructura_uo euo
                      inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                      inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                      inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                      left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo and uofun.estado_reg = 'activo' and
                              uofun.fecha_asignacion <=  par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha )

                  )
                   SELECT  id_funcionario
                   into v_funcionario
                   FROM path
                   WHERE     id_funcionario is not null
                         and id_funcionario != par_id_funcionario ;


        ELSE

              --si el funcioanrio no tiene asignacion funcional busca segun jerarquia
                SELECT no.numero_nivel
                INTO v_numero_nivel
                FROM orga.tuo_funcionario uof
                join orga.tuo uo on uo.id_uo = uof.id_uo
                join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                WHERE uo.estado_reg = 'activo'
                and uof.estado_reg = 'activo'
                and uof.fecha_asignacion <= par_fecha
                and (uof.fecha_finalizacion is null or uof.fecha_finalizacion >=  par_fecha)
                and uof.id_funcionario = par_id_funcionario;

              --niveles 6=AREA 7=FUNCIONARIO BASE 8=FUNCIONARIO BASE II 9=FUNCIONARIO BASE III
              IF (v_numero_nivel in (8,9) ) THEN

                WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )


        	       SELECT  id_funcionario
                   into v_funcionario
                   FROM path
                   WHERE     id_funcionario is not null
                         and id_funcionario !=  par_id_funcionario and numero_nivel  in (5)  ;

                    IF (v_numero_nivel in (9) and v_funcionario is null)THEN
                   WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )

                   		 SELECT  id_funcionario
                         into v_funcionario
                         FROM path
                         WHERE     id_funcionario is not null
                         	and id_funcionario !=  par_id_funcionario and numero_nivel  in (4)  ;

                   END IF;
                   IF (v_numero_nivel in (8) )THEN
                   WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )

                   		 SELECT  id_funcionario
                         into v_funcionario
                         FROM path
                         WHERE     id_funcionario is not null
                         	and id_funcionario !=  par_id_funcionario and numero_nivel  in (7)  ;

                   END IF;
        ELSIF (v_numero_nivel in (10,11,12) ) THEN

                WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )
                -----------

              --Obtener todos los empleados de la asignacion


        	       SELECT  id_funcionario
                   into v_funcionario
                   FROM path
                   WHERE     id_funcionario is not null
                         and id_funcionario !=  par_id_funcionario and numero_nivel  in (7,9,10)  ;


                   IF (v_numero_nivel in (7,8) and v_funcionario is null)THEN
                   WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )

                   		 SELECT  id_funcionario
                         into v_funcionario
                         FROM path
                         WHERE     id_funcionario is not null
                         	and id_funcionario !=  par_id_funcionario and numero_nivel  in (4)  ;

                   END IF;

                   IF (v_numero_nivel in (12) and v_funcionario is null)THEN
                   WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )

                   		 SELECT  id_funcionario
                         into v_funcionario
                         FROM path
                         WHERE     id_funcionario is not null
                         	and id_funcionario !=  par_id_funcionario and numero_nivel  in (4)  ;

                   END IF;

        ELSIF (v_numero_nivel in (5,7)) THEN
         --raise exception 'llega2';
                   WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )
        	       SELECT  id_funcionario
                   into v_funcionario
                   FROM path
                   WHERE     id_funcionario is not null
                         and id_funcionario !=  par_id_funcionario and numero_nivel  in (4)  ;

                   IF (v_funcionario is null)THEN
                   WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                  SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                  FROM orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  WHERE uofun.fecha_asignacion <=  par_fecha
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                  and uofun.estado_reg = 'activo'
                                  and uofun.id_funcionario =  par_id_funcionario
                              UNION
                                  SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                  FROM orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                  and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                              )

                   		 SELECT  id_funcionario
                         into v_funcionario
                         FROM path
                         WHERE     id_funcionario is not null
                         	and id_funcionario !=  par_id_funcionario and numero_nivel  in (2)  ;

                   END IF;

        ELSIF (v_numero_nivel in (4,3)) THEN
           			WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                    SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                    FROM orga.tuo_funcionario uofun
                                    inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                    inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                    WHERE uofun.fecha_asignacion <=  par_fecha
                                    and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  par_fecha)
                                    and uofun.estado_reg = 'activo'
                                    and uofun.id_funcionario =  par_id_funcionario
                                UNION
                                    SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                    FROM orga.testructura_uo euo
                                    inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre_operativo
                                    inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                    inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                    left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo
                                    and uofun.estado_reg = 'activo'
                                    and uofun.fecha_asignacion <= par_fecha  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= par_fecha)

                                )
              SELECT  id_funcionario
                     into v_funcionario
                     FROM path
                     WHERE     id_funcionario is not null
                           and id_funcionario !=  par_id_funcionario and numero_nivel in (2)  ;



          END IF;


        END IF;


        raise notice '%',v_funcionario;
        --return query execute (v_consulta);
        return v_funcionario;



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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;