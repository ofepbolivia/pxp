CREATE OR REPLACE FUNCTION wf.f_gant_wf (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
DECLARE


v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;


v_sw integer;
v_sw2 integer;
v_count integer;
v_consulta varchar;
v_consulta2 varchar;
v_registros  record;  -- PARA ALMACENAR EL CONJUNTO DE DATOS RESULTADO DEL SELECT
v_tabla varchar;
v_valor_nivel varchar;
v_nivel varchar;
v_niveles_acsi varchar;

pm_criterio_filtro varchar;
v_id integer;


v_registro_proceso_wf  record;
v_fecha_ini_proc timestamp;
v_fecha_fin_proc timestamp;
v_id_procesos_sig integer[];
v_id_almacenado  integer[];
v_fecha_fin_ant TIMESTAMP;
v_id_proceso integer;
v_id_estado integer;
v_id_proceso_ant integer;

v_i integer;
p_id_proceso_wf integer;
v_id_proceso_wf_prev integer;
v_orden				varchar;
v_cod_tramite		varchar;

--(f.e.a/24-12-2018)Procesos Boa Rep
v_proceso			varchar;
v_estado			varchar;
BEGIN



    v_nombre_funcion = 'wf.f_gant_wf';


     v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
 	#TRANSACCION:  'WF_GATNREP_SEL'
 	#DESCRIPCION:	Consulta del diagrama gant del WF
 	#AUTOR:		rac
 	#FECHA:		16-03-2012 17:06:17
	***********************************/

	IF(p_transaccion='WF_GATNREP_SEL')then


    p_id_proceso_wf = v_parametros.id_proceso_wf;

	select
    substr (pro.nro_tramite,1,2)
    into v_cod_tramite
    from wf.tproceso_wf pro
    where pro.id_proceso_wf = p_id_proceso_wf;


  --if (v_cod_tramite = 'GA' or v_cod_tramite = 'GM' or v_cod_tramite = 'GO' or v_cod_tramite = 'GC') THEN
   -- raise exception 'El diagrama de Gantt no esta disponible para este tipo de tramite.';
   -- else
   --0) recperar id_proceso_wf inicial
	 WITH RECURSIVE path_rec(id_estado_wf_prev, id_proceso_wf_prev ) AS (
	    SELECT
	      pwf.id_estado_wf_prev,
	      ewf.id_proceso_wf as id_proceso_wf_prev
	    FROM wf.tproceso_wf pwf
	    inner join wf.testado_wf ewf on ewf.id_estado_wf = pwf.id_estado_wf_prev
	    WHERE pwf.id_proceso_wf = p_id_proceso_wf

	    UNION
	    SELECT
	    pwf2.id_estado_wf_prev,
	    ewf2.id_proceso_wf as id_proceso_wf_prev
	    FROM wf.tproceso_wf pwf2
	    inner join path_rec  pr on pwf2.id_proceso_wf = pr.id_proceso_wf_prev
	    inner join wf.testado_wf ewf2 on ewf2.id_estado_wf = pwf2.id_estado_wf_prev

	)
    SELECT
      id_proceso_wf_prev
    into
      v_id_proceso_wf_prev
    FROM path_rec order by id_proceso_wf_prev limit 1 offset 0;


   IF v_id_proceso_wf_prev is NULL THEN

      v_id_proceso_wf_prev = p_id_proceso_wf;

   END IF;


   -- 1) Crea una tabla temporal con los datos que se utilizaran

      CREATE TEMP TABLE temp_gant_wf (
                                      id serial,
                                      id_proceso_wf integer,
                                      id_estado_wf integer,
                                      tipo varchar,
                                      nombre VARCHAR,
                                      fecha_ini TIMESTAMP,
                                      fecha_fin TIMESTAMP,
                                      descripcion VARCHAR,
                                      id_siguiente integer,
                                      tramite varchar,
                                      codigo varchar,
                                      id_funcionario integer,
                                      funcionario text,
                                      id_usuario INTEGER,
                                      cuenta varchar,
                                      id_depto integer,
                                      depto varchar,
                                      nombre_usuario_ai varchar,
                                      id_padre integer,
                                      arbol varchar,
                                      id_obs integer,
                                      id_anterior integer,
                                      etapa		varchar,
                                      estado_reg varchar,
                                      disparador varchar
                                     ) ON COMMIT DROP;

      --resupera parametro de ordenacion
      if  pxp.f_existe_parametro(p_tabla, 'orden' ) then
         v_orden = v_parametros.orden;
      else
         v_orden = 'defecto';
      end if;


      IF v_orden = 'defecto' then
        IF not ( wf.f_gant_wf_recursiva(v_id_proceso_wf_prev,NULL ,p_id_usuario, NULL, NULL)) THEN
           raise exception 'Error al recuperar los datos del diagrama gant';
        END IF;
      ELSIF v_orden = 'grilla' THEN
      	IF not ( wf.f_gant_wf_recursiva_grilla(v_id_proceso_wf_prev,NULL ,p_id_usuario, NULL, NULL)) THEN
           raise exception 'Error al recuperar los datos del diagrama gant';
        END IF;
      ELSE
        IF not ( wf.f_gant_wf_recursiva_dinamico(v_id_proceso_wf_prev,NULL ,p_id_usuario, NULL, NULL)) THEN
          raise exception 'Error al recuperar los datos del diagrama gant';
         END IF;
      END IF;


       raise notice 'consulta tabla temporal';

		if (v_orden != 'grilla') then

             FOR v_registros in (SELECT
                                  id ,
                                  id_proceso_wf ,
                                  id_estado_wf ,
                                  tipo ,
                                  nombre ,
                                  fecha_ini ,
                                  fecha_fin ,
                                  descripcion ,
                                  id_siguiente ,
                                  tramite ,
                                  codigo ,
                                  COALESCE(id_funcionario,0) ,
                                  funcionario ,
                                  COALESCE(id_usuario,0),
                                  cuenta ,
                                  COALESCE(id_depto,0),
                                  depto,
                                  COALESCE(nombre_usuario_ai,''),
                                  arbol,
                                  id_padre,
                                  id_obs,
                                  id_anterior,
                                  etapa,
                                  estado_reg,
                                  disparador,
                                  ''::varchar,
                                  ''::varchar,
                                  ''::varchar,
                                  ''::varchar
                                FROM temp_gant_wf
                                order by id) LOOP

                SELECT top.tipo_obligacion
                into v_proceso
	    		FROM tes.tobligacion_pago top
	   			WHERE top.id_proceso_wf = p_id_proceso_wf;

                select tes.codigo
                into v_estado
                from wf.testado_wf tew
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = tew.id_tipo_estado
                where tew.id_estado_wf = v_registros.id_estado_wf;

                /*raise notice 'v_proceso %, %, %, %, %', v_proceso, v_registros.id_estado_wf,v_estado, v_registros.id_proceso_wf,v_registros.id;
                if v_proceso = 'pbr' then
                	if v_estado = 'registrado' or v_estado = 'vbpoa' or v_estado = 'suppresu' or v_estado = 'vbpresupuestos' then
                    	CONTINUE;
                    else
                    	RETURN NEXT v_registros;
                    end if;
                else*/
                	RETURN NEXT v_registros;
                --end if;

             END LOOP;
        else
        	FOR v_registros in (SELECT
                                  temporal.id ,
                                  temporal.id_proceso_wf ,
                                  temporal.id_estado_wf ,
                                  temporal.tipo ,
                                  temporal.nombre ,
                                  temporal.fecha_ini ,
                                  COALESCE(temporal.fecha_fin,temporal.fecha_ini) ,
                                  temporal.descripcion ,
                                  temporal.id_siguiente ,
                                  temporal.tramite ,
                                  temporal.codigo ,
                                  COALESCE(temporal.id_funcionario,0) ,

                                  (CASE
                                  		WHEN (temporal.id_funcionario is null) then
                                        	usu.desc_persona::text
                                        ELSE
                                        	 temporal.funcionario
                                  END)::text as funcionario,
                                  COALESCE(temporal.id_usuario,0),
                                  temporal.cuenta ,
                                  COALESCE(temporal.id_depto,0),
                                  temporal.depto,
                                  COALESCE(temporal.nombre_usuario_ai,''),
                                  temporal.arbol,
                                  temporal.id_padre,
                                  temporal.id_obs,
                                  temporal.id_anterior,
                                  temporal.etapa,
                                  temporal.estado_reg,
                                  temporal.disparador,
                                  tp.nombre::varchar as nombre_proceso,

                                  (CASE
                                      WHEN (temporal.etapa != '' and temporal.etapa is not null) THEN
                                        temporal.etapa || ' [' || temporal.nombre || '] (por: ' || (CASE
                                                                                                      WHEN (temporal.id_funcionario is null) then usu.desc_persona::text
                                                                                                      ELSE temporal.funcionario
                                                                                                    END)::text ||')'::VARCHAR
                                      ELSE
                                        temporal.nombre || ' (por: ' || (CASE
                                                                                                      WHEN (temporal.id_funcionario is null) then usu.desc_persona::text
                                                                                                      ELSE temporal.funcionario
                                                                                                    END)::text ||')'::VARCHAR
                                    END)::VARCHAR as etapa_consulta,
                                 (CASE
                                 	WHEN (COALESCE((temporal.fecha_fin::date-temporal.fecha_ini::date),0) = 1) THEN
                                    	(COALESCE((temporal.fecha_fin::date-temporal.fecha_ini::date),0) || ' día')
                                    ELSE
                                    	(COALESCE((temporal.fecha_fin::date-temporal.fecha_ini::date),0) || ' días')
                                 END)::VARCHAR as duracion_consulta,
                                usu.desc_persona::varchar as desc_usuario
                                FROM temp_gant_wf temporal
                                inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = temporal.id_proceso_wf
                                inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
                                inner join segu.vusuario usu on usu.id_usuario = temporal.id_usuario
                                where temporal.id_estado_wf is not null
                                order by temporal.id_estado_wf) LOOP

                SELECT top.tipo_obligacion
                into v_proceso
	    		FROM tes.tobligacion_pago top
	   			WHERE top.id_proceso_wf = p_id_proceso_wf;

                select tes.codigo
                into v_estado
                from wf.testado_wf tew
                inner join wf.ttipo_estado tes on tes.id_tipo_estado = tew.id_tipo_estado
                where tew.id_estado_wf = v_registros.id_estado_wf;

                /*raise notice 'v_proceso %, %, %, %, %', v_proceso, v_registros.id_estado_wf,v_estado, v_registros.id_proceso_wf,v_registros.id;
                if v_proceso = 'pbr' then
                	if v_estado = 'registrado' or v_estado = 'vbpoa' or v_estado = 'suppresu' or v_estado = 'vbpresupuestos' then
                    	CONTINUE;
                    else
                    	RETURN NEXT v_registros;
                    end if;
                else*/
                	RETURN NEXT v_registros;
                --end if;

             END LOOP;

        end if;
  --end if;

END IF;

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
COST 100 ROWS 1000;

ALTER FUNCTION wf.f_gant_wf (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;
