CREATE OR REPLACE FUNCTION orga.ft_funcionario_sel (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla varchar,
  par_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
     FUNCION: 		orga.ft_funcionario_sel
     DESCRIPCIÓN:  listado de funcionario
     AUTOR: 	    KPLIAN (mzm)
     FECHA:
     COMENTARIOS:
    ***************************************************************************
     HISTORIA DE MODIFICACIONES:

     DESCRIPCION:
     AUTOR:
     FECHA:		21-01-2011
    ***************************************************************************/


  DECLARE


    v_consulta         varchar;
    v_parametros       record;
    v_nombre_funcion   text;
    v_mensaje_error    text;
    v_resp             varchar;
    v_filadd           varchar;
    v_id_funcionario	integer;
    v_ids_funcionario	varchar;

    v_id_uo					integer;
    v_gerencia			varchar;
    v_id_uo_hijo		integer;
    v_nivel				integer;
	v_filtro			varchar='';
    v_inner				varchar='';
    v_estado_func		varchar = 'general';

    v_id_uo_gerencia	integer;

    v_id_lugar      integer;
    v_id_funcionario_filtro	integer;
    v_existencia_permiso	integer;
  BEGIN

    v_parametros:=pxp.f_get_record(par_tabla);
    v_nombre_funcion:='orga.ft_funcionario_sel';

    /*******************************
     #TRANSACCION:  RH_FUNCIO_SEL
     #DESCRIPCION:	Listado de funcionarios
     #AUTOR:
     #FECHA:		23/05/11
    ***********************************/
    if(par_transaccion='RH_FUNCIO_SEL')then

      --consulta:=';
      BEGIN

	  --Creamos una tabla donde obtenemos la ultima asignacion de un funcionario
      		/*Aqui aumentamos para el filtro de funcionario y gerencia*/
       	  IF (pxp.f_existe_parametro(par_tabla,'id_uo') and pxp.f_existe_parametro(par_tabla,'boa_file')) THEN
          if (v_parametros.id_uo is not null) then
           select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
              from segu.tusuario usu
              inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
              inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
              where usu.id_usuario = par_id_usuario;

          v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);

          IF (v_parametros.id_uo = v_id_uo_gerencia) then
          select count(1) into v_existencia_permiso
          where v_id_uo_gerencia =ANY (SELECT unnest (gere.id_gerencia)
                                      from orga.tpermiso_gerencias gere
                                      where gere.id_funcionario = v_id_funcionario);

              if (v_existencia_permiso > 0) then
                  v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||' and';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              else
                  v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||' and FUNCIO.id_funcionario = '||v_id_funcionario||' and';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              end if;
          else

                v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||' and';
                v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';

          end if;

        else
        	 select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
              from segu.tusuario usu
              inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
              inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
              where usu.id_usuario = par_id_usuario;

          v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);


          select count(1) into v_existencia_permiso
          where v_id_uo_gerencia =ANY (SELECT unnest (gere.id_gerencia)
                                      from orga.tpermiso_gerencias gere
                                      where gere.id_funcionario = v_id_funcionario);

              if (v_existencia_permiso > 0) then
                  v_filtro = 'ger.id_uo = '||v_id_uo_gerencia::integer||' and ';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              else
                  v_filtro = 'ger.id_uo = '||v_id_uo_gerencia::integer||' and FUNCIO.id_funcionario = '||v_id_funcionario||' and';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              end if;
        end if;
      END IF;
        /**********************************************************/

    IF (pxp.f_existe_parametro(par_tabla,'boa_file') and pxp.f_existe_parametro(par_tabla,'id_uo')=false) THEN

      	if (v_parametros.boa_file is not null) then
        	select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
            from segu.tusuario usu
            inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
            inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
            where usu.id_usuario = par_id_usuario;

            v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);

            select count(1) into v_existencia_permiso
        	where v_id_uo_gerencia =ANY (SELECT unnest (gere.id_gerencia)
                                    from orga.tpermiso_gerencias gere
                                    where gere.id_funcionario = v_id_funcionario);

            if (v_existencia_permiso > 0) then
            	v_filtro = 'ger.id_uo = '||v_id_uo_gerencia::integer||' and';
                v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
            else
             	v_filtro = 'ger.id_uo = '||v_id_uo_gerencia||' and FUNCIO.id_funcionario = '||v_id_funcionario||' and';
                v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
            end if;


        end if;
      END IF;
      /**********************************************************************************************************/




      	if pxp.f_existe_parametro(par_tabla,'estado_func') then
          v_estado_func =v_parametros.estado_func;
        end if;

      	if v_estado_func != 'sin_asignacion' then
          create temp table tt_orga_filtro (
              id_funcionario integer,
              fecha_asignacion date
          )on commit drop;

          v_consulta = 'insert into tt_orga_filtro
          select  tuo.id_funcionario, max(tuo.fecha_asignacion)
          from orga.tuo_funcionario tuo
          where tuo.tipo = ''oficial'' and tuo.estado_reg = ''activo''
          group by  tuo.id_funcionario';

          execute(v_consulta);

          v_consulta:='SELECT
                          FUNCIO.id_funcionario,
                          FUNCIO.codigo,
                          FUNCIO.estado_reg,
                          FUNCIO.fecha_reg,
                          FUNCIO.id_persona,
                          FUNCIO.id_usuario_reg,
                          FUNCIO.fecha_mod,
                          FUNCIO.id_usuario_mod,
                          FUNCIO.email_empresa,
                          gecom.f_get_numeros_asignados(''interno'',FUNCIO.id_funcionario) as interno,
                          --''01/03/2021''::date fecha_ingreso,
                          --plani.f_get_fecha_primer_contrato_empleado (tuo.id_uo_funcionario, tuo.id_funcionario, tuo.fecha_asignacion) as fecha_ingreso,
                          FUNCIO.fecha_ingreso_calculado as fecha_ingreso,
                          PERSON.nombre_completo2 AS desc_person,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          PERSON.ci,
                          PERSON.num_documento,
                          PERSON.telefono1,
                          PERSON.celular1,
                          PERSON.correo,
                          gecom.f_get_numeros_asignados(''celular'',FUNCIO.id_funcionario) as telefono_ofi,
                          FUNCIO.antiguedad_anterior,
                          PERSON2.estado_civil,
                          PERSON2.genero,
                          PERSON2.fecha_nacimiento,
                          PERSON2.id_lugar,
                          LUG.nombre as nombre_lugar,
                          PERSON2.nacionalidad,
                          PERSON2.discapacitado,
                          PERSON2.carnet_discapacitado,
                          FUNCIO.id_biometrico,
                          tar.nombre_archivo,
                          tar.extension,
                          tar.folder,
                          PERSON.telefono2,
                          PERSON.celular2,
                          PERSON.nombre,
                          PERSON.ap_materno,
                          PERSON.ap_paterno,
                          tdoc.nombre as tipo_documento,
                          PERSON2.expedicion,
                          PERSON2.direccion,
                          FUNCIO.es_tutor,
                          tuo.fecha_asignacion,
                          tuo.fecha_finalizacion,
                          tca.nombre as nombre_cargo,
                          tof.nombre as nombre_oficina,
                          tlo.nombre as nombre_lugar_ofi,
                          FUNCIO.codigo_rc_iva,
                          PERSON2.id_tipo_doc_identificacion,
                          ten.id_especialidad_nivel,
                          ten.nombre as desc_titulo,

                          orga.f_get_funcionario_base_operativa(FUNCIO.id_funcionario) base_operativa,

                          (''(''||vcc.codigo_tcc ||'') '' ||vcc.descripcion_tcc)::varchar AS centro_costo,
                          cp.codigo_categoria categoria,
                          (date_part(''year'',age(current_date, FUNCIO.fecha_ingreso_calculado))::varchar ||'' años ''||date_part(''month'',age(current_date, FUNCIO.fecha_ingreso_calculado))::varchar||'' meses ''||date_part(''day'',age(current_date, FUNCIO.fecha_ingreso_calculado))::varchar||'' dias'')::varchar tiempo_empresa,
                          (SELECT afp.tipo_jubilado FROM plani.tfuncionario_afp afp where afp.id_funcionario =  FUNCIO.id_funcionario and afp.fecha_fin is null order by afp.fecha_ini desc limit 1)::varchar jubilado

                          --dep.nombre_unidad
                          --(select org.nombre_unidad  from orga.tuo org where org.id_uo =orga.f_get_uo_departamento(tuo.id_uo, NULL::integer, NULL::date))::varchar nombre_unidad

                          FROM orga.tfuncionario FUNCIO
                          inner join orga.tuo_funcionario tuo on tuo.id_funcionario = FUNCIO.id_funcionario AND
                          tuo.fecha_asignacion  in (select fecha_asignacion
                                                      from tt_orga_filtro where id_funcionario = FUNCIO.id_funcionario)
                          inner join orga.tcargo tca on tca.id_cargo = tuo.id_cargo
                          inner join orga.ttemporal_cargo ttc on ttc.id_temporal_cargo = tca.id_temporal_cargo
                          inner join orga.toficina tof on tof.id_oficina = tca.id_oficina
                          inner join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                          INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                          INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                          left join segu.ttipo_documento tdoc on tdoc.id_tipo_documento = PERSON2.id_tipo_doc_identificacion
                          LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                          inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                          left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10 and tar.id_archivo_fk is null
                          left join orga.tespecialidad_nivel ten on ten.id_especialidad_nivel = FUNCIO.id_especialidad_nivel

                          '||v_inner||'

                          left join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuo.id_cargo and tcp.id_gestion = (select tg.id_gestion from param.tgestion tg where tg.gestion = date_part(''year'',tuo.fecha_asignacion))
                          left join param.vcentro_costo vcc on vcc.id_centro_costo = tcp.id_centro_costo
                          left join pre.tpresupuesto pre on pre.id_centro_costo = tcp.id_centro_costo
                          left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pre.id_categoria_prog

                          WHERE tuo.estado_reg = ''activo'' and tuo.tipo = ''oficial'' and '||v_filtro||'';

		  else
        	v_consulta:='SELECT
            				FUNCIO.id_funcionario,
                            FUNCIO.codigo,
                            FUNCIO.estado_reg,
                            FUNCIO.fecha_reg,
                            FUNCIO.id_persona,
                            FUNCIO.id_usuario_reg,
                            FUNCIO.fecha_mod,
                            FUNCIO.id_usuario_mod,
                            FUNCIO.email_empresa,
                            gecom.f_get_numeros_asignados(''interno'',FUNCIO.id_funcionario) as interno,
                            --''01/03/2021''::date fecha_ingreso,
                            coalesce(plani.f_get_fecha_primer_contrato_empleado (tuo.id_uo_funcionario, tuo.id_funcionario, tuo.fecha_asignacion), FUNCIO.fecha_ingreso) as fecha_ingreso,
                            PERSON.nombre_completo2 AS desc_person,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            PERSON.ci,
                            PERSON.num_documento,
                            PERSON.telefono1,
                            PERSON.celular1,
                            PERSON.correo,
                            gecom.f_get_numeros_asignados(''celular'',FUNCIO.id_funcionario) as telefono_ofi,
                            FUNCIO.antiguedad_anterior,
                            PERSON2.estado_civil,
                            PERSON2.genero,
                            PERSON2.fecha_nacimiento,
                            PERSON2.id_lugar,
                            LUG.nombre as nombre_lugar,
                            PERSON2.nacionalidad,
                            PERSON2.discapacitado,
                            PERSON2.carnet_discapacitado,
                            FUNCIO.id_biometrico,
                            tar.nombre_archivo,
                            tar.extension,
                            tar.folder,
                            PERSON.telefono2,
                            PERSON.celular2,
                            PERSON.nombre,
                            PERSON.ap_materno,
                            PERSON.ap_paterno,
                            tdoc.nombre as tipo_documento,
                            PERSON2.expedicion,
                            PERSON2.direccion,
                            FUNCIO.es_tutor,
                            tuo.fecha_asignacion,
                            tuo.fecha_finalizacion,
                            tca.nombre as nombre_cargo,
                            tof.nombre as nombre_oficina,
                            tlo.nombre as nombre_lugar_ofi,
                            FUNCIO.codigo_rc_iva,
                            PERSON2.id_tipo_doc_identificacion,
                            ten.id_especialidad_nivel,
                          ten.nombre as desc_titulo,

                          orga.f_get_funcionario_base_operativa(FUNCIO.id_funcionario) base_operativa,
                          null::varchar,
                          null::varchar,
                          null::varchar,
						  null::varchar
                          FROM orga.tfuncionario FUNCIO
                          left join orga.tuo_funcionario tuo on tuo.id_funcionario = FUNCIO.id_funcionario
                          left join orga.tcargo tca on tca.id_cargo = tuo.id_cargo
                          inner join orga.ttemporal_cargo ttc on ttc.id_temporal_cargo = tca.id_temporal_cargo
                          left join orga.toficina tof on tof.id_oficina = tca.id_oficina
                          left join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                          INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                          INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                          left join segu.ttipo_documento tdoc on tdoc.id_tipo_documento = PERSON2.id_tipo_doc_identificacion
                          LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                          inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                          left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10 and tar.id_archivo_fk is null
                          left join orga.tespecialidad_nivel ten on ten.id_especialidad_nivel = FUNCIO.id_especialidad_nivel

                          '||v_inner||'
                          WHERE FUNCIO.estado_reg = ''activo'' and (FUNCIO.fecha_ingreso between date_trunc(''year'', current_date)::date and (date_trunc(''year'',current_date) + interval ''1 year'' - interval ''1 day'')::date) and '||v_filtro||'';
      end if;
        v_consulta := v_consulta || v_parametros.filtro;

        if (pxp.f_existe_parametro(par_tabla, 'tipo') and
            pxp.f_existe_parametro(par_tabla, 'fecha') and
            pxp.f_existe_parametro(par_tabla, 'id_uo')) then

          if (v_parametros.tipo is not null and v_parametros.tipo = 'oficial' and v_parametros.fecha is not null and v_parametros.id_uo is not null) then
            v_ids_funcionario = orga.f_get_funcionarios_con_asignacion_activa(v_parametros.id_uo, v_parametros.fecha);
            v_consulta := v_consulta || ' and FUNCIO.id_funcionario not in (' || v_ids_funcionario ||') ';

          end if;
        end if;

        v_consulta:=v_consulta||' order by PERSON.nombre_completo2 asc limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

        return v_consulta;


      END;

    /*******************************
     #TRANSACCION:  RH_FUNCIO_CONT
     #DESCRIPCION:	Conteo de funcionarios
     #AUTOR:
     #FECHA:		23/05/11
    ***********************************/
    elsif(par_transaccion='RH_FUNCIO_CONT')then

      --consulta:=';
      BEGIN
	  --Creamos una tabla donde obtenemos la ultima asignacion de un funcionario
      /*Aqui aumentamos para el filtro de funcionario y gerencia*/
       	/*Aqui aumentamos para el filtro de funcionario y gerencia*/
        /*Aqui aumentamos para el filtro de funcionario y gerencia*/
       	  IF (pxp.f_existe_parametro(par_tabla,'id_uo') and pxp.f_existe_parametro(par_tabla,'boa_file')) THEN
          if (v_parametros.id_uo is not null) then
           select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
              from segu.tusuario usu
              inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
              inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
              where usu.id_usuario = par_id_usuario;

          v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);

          IF (v_parametros.id_uo = v_id_uo_gerencia) then
          select count(1) into v_existencia_permiso
          where v_id_uo_gerencia =ANY (SELECT unnest (gere.id_gerencia)
                                      from orga.tpermiso_gerencias gere
                                      where gere.id_funcionario = v_id_funcionario);

              if (v_existencia_permiso > 0) then
                  v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||' and';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              else
                  v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||' and FUNCIO.id_funcionario = '||v_id_funcionario||' and';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              end if;
          else

                v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||' and';
                v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';

          end if;

        else
        	 select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
              from segu.tusuario usu
              inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
              inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
              where usu.id_usuario = par_id_usuario;

          v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);


          select count(1) into v_existencia_permiso
          where v_id_uo_gerencia =ANY (SELECT unnest (gere.id_gerencia)
                                      from orga.tpermiso_gerencias gere
                                      where gere.id_funcionario = v_id_funcionario);

              if (v_existencia_permiso > 0) then
                  v_filtro = 'ger.id_uo = '||v_id_uo_gerencia::integer||' and ';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              else
                  v_filtro = 'ger.id_uo = '||v_id_uo_gerencia::integer||' and FUNCIO.id_funcionario = '||v_id_funcionario||' and';
                  v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
              end if;
        end if;
      END IF;
        /**********************************************************/

    IF (pxp.f_existe_parametro(par_tabla,'boa_file') and pxp.f_existe_parametro(par_tabla,'id_uo')=false) THEN

      	if (v_parametros.boa_file is not null) then
        	select per.id_funcionario,fun.id_uo into v_id_funcionario, v_id_uo
            from segu.tusuario usu
            inner join orga.vfuncionario_persona per on per.id_persona = usu.id_persona
            inner join orga.vfuncionario_ultimo_cargo fun on fun.id_funcionario = per.id_funcionario
            where usu.id_usuario = par_id_usuario;

            v_id_uo_gerencia = orga.f_get_uo_gerencia(v_id_uo,null::integer,null::date);

            select count(1) into v_existencia_permiso
        	where v_id_uo_gerencia =ANY (SELECT unnest (gere.id_gerencia)
                                    from orga.tpermiso_gerencias gere
                                    where gere.id_funcionario = v_id_funcionario);

            if (v_existencia_permiso > 0) then
            	v_filtro = 'ger.id_uo = '||v_id_uo_gerencia::integer||' and';
                v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
            else
             	v_filtro = 'ger.id_uo = '||v_id_uo_gerencia||' and FUNCIO.id_funcionario = '||v_id_funcionario||' and';
                v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuo.id_uo,null::integer,null::date)';
            end if;


        end if;
      END IF;
      /**********************************************************************************************************/

        if pxp.f_existe_parametro(par_tabla,'estado_func') then
          v_estado_func =v_parametros.estado_func;
        end if;

      	if v_estado_func != 'sin_asignacion' then
      	  create temp table tt_orga_filtro (
          	id_funcionario integer,
          	fecha_asignacion date
       	  )on commit drop;

          v_consulta = 'insert into tt_orga_filtro
                      select  tuo.id_funcionario, max(tuo.fecha_asignacion)
                      from orga.tuo_funcionario tuo
                      where tuo.tipo = ''oficial'' and tuo.estado_reg = ''activo''
                      group by  tuo.id_funcionario';

          execute(v_consulta);

          v_consulta:='SELECT
                    count(FUNCIO.id_funcionario)
                    FROM orga.tfuncionario FUNCIO
                    inner join orga.tuo_funcionario tuo on tuo.id_funcionario = FUNCIO.id_funcionario  AND
                    tuo.fecha_asignacion  in (select fecha_asignacion
                                                from tt_orga_filtro where id_funcionario = FUNCIO.id_funcionario)
                    inner join orga.tcargo tca on tca.id_cargo = tuo.id_cargo
                    inner join orga.ttemporal_cargo ttc on ttc.id_temporal_cargo = tca.id_temporal_cargo
                    inner join orga.toficina tof on tof.id_oficina = tca.id_oficina
                    inner join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                    INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                    INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                    LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                    inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
                    left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                    left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10 and tar.id_archivo_fk is null
                    left join orga.tespecialidad_nivel ten on ten.id_especialidad_nivel = FUNCIO.id_especialidad_nivel

                    '||v_inner||'

                    left join orga.tcargo_presupuesto tcp on tcp.id_cargo = tuo.id_cargo and tcp.id_gestion = (select tg.id_gestion from param.tgestion tg where tg.gestion = date_part(''year'',tuo.fecha_asignacion))
                    left join param.vcentro_costo vcc on vcc.id_centro_costo = tcp.id_centro_costo
                    left join pre.tpresupuesto pre on pre.id_centro_costo = tcp.id_centro_costo
                    left join pre.vcategoria_programatica cp on cp.id_categoria_programatica = pre.id_categoria_prog
                    --left join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(tuo.id_uo, NULL::integer, NULL::date)


                    WHERE tuo.estado_reg = ''activo'' and tuo.tipo = ''oficial'' and '||v_filtro||'';
        else
      		v_consulta:='SELECT
            			  count(FUNCIO.id_funcionario)
                    FROM orga.tfuncionario FUNCIO
                    left join orga.tuo_funcionario tuo on tuo.id_funcionario = FUNCIO.id_funcionario
                    left join orga.tcargo tca on tca.id_cargo = tuo.id_cargo
                    inner join orga.ttemporal_cargo ttc on ttc.id_temporal_cargo = tca.id_temporal_cargo
                    left join orga.toficina tof on tof.id_oficina = tca.id_oficina
                    left join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                    INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                    INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                    left join segu.ttipo_documento tdoc on tdoc.id_tipo_documento = PERSON2.id_tipo_doc_identificacion
                    LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                    inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
                    left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                    left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10 and tar.id_archivo_fk is null
                    left join orga.tespecialidad_nivel ten on ten.id_especialidad_nivel = FUNCIO.id_especialidad_nivel

                    '||v_inner||'
                    WHERE FUNCIO.estado_reg = ''activo'' and (FUNCIO.fecha_ingreso between date_trunc(''year'', current_date)::date and (date_trunc(''year'',current_date) + interval ''1 year'' - interval ''1 day'')::date) and '||v_filtro||'';
        end if;
        v_consulta:=v_consulta||v_parametros.filtro;
        if (pxp.f_existe_parametro(par_tabla, 'tipo') and
            pxp.f_existe_parametro(par_tabla, 'fecha') and
            pxp.f_existe_parametro(par_tabla, 'id_uo')) then

          if (v_parametros.tipo is not null and v_parametros.tipo = 'oficial' and v_parametros.fecha is not null and v_parametros.id_uo is not null) then
            v_ids_funcionario = orga.f_get_funcionarios_con_asignacion_activa(v_parametros.id_uo, v_parametros.fecha);
            v_consulta := v_consulta || ' and FUNCIO.id_funcionario not in (' || v_ids_funcionario ||') ';

          end if;
        end if;
        return v_consulta;
      END;

    /*******************************
     #TRANSACCION:  RH_FUN_ASIG_SEL
     #DESCRIPCION:	Listado de funcionarios sin asignacion
     #AUTOR:		franklin.espinoza
     #FECHA:		23/05/18
    ***********************************/
    elsif(par_transaccion='RH_FUN_ASIG_SEL')then
      BEGIN
        v_consulta:='SELECT
                            FUNCIO.id_funcionario,
                            FUNCIO.codigo,
                            FUNCIO.estado_reg,
                            FUNCIO.fecha_reg,
                            FUNCIO.id_persona,
                            FUNCIO.id_usuario_reg,
                            FUNCIO.fecha_mod,
                            FUNCIO.id_usuario_mod,
                            FUNCIO.email_empresa,
                            FUNCIO.interno,
                            FUNCIO.fecha_ingreso,
                            PERSON.nombre_completo2 AS desc_person,
                            usu1.cuenta as usr_reg,
						    usu2.cuenta as usr_mod,
                            PERSON.ci,
                            PERSON.num_documento,
                            PERSON.telefono1,
                            PERSON.celular1,
                            PERSON.correo,
                            FUNCIO.telefono_ofi,
                            FUNCIO.antiguedad_anterior,
                            PERSON2.estado_civil,
                            PERSON2.genero,
                            PERSON2.fecha_nacimiento,
                            PERSON2.id_lugar,
                            LUG.nombre as nombre_lugar,
                            PERSON2.nacionalidad,
                            PERSON2.discapacitado,
                            PERSON2.carnet_discapacitado,
                            FUNCIO.id_biometrico,
                            tar.nombre_archivo,
                            tar.extension
                            FROM orga.tfuncionario FUNCIO
                            INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                            INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                            LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                            inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
						    left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                            left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10
                            WHERE ';

        v_consulta := v_consulta || v_parametros.filtro;
        if (v_parametros.tipo is not null and v_parametros.tipo = 'oficial' and v_parametros.fecha is not null and v_parametros.id_uo is not null) then
        	v_ids_funcionario = orga.f_get_funcionarios_con_asignacion_activa(v_parametros.id_uo, v_parametros.fecha);
        	v_consulta := v_consulta || ' and FUNCIO.id_funcionario not in (' || v_ids_funcionario ||')';
        end if;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
		raise notice ' v_consulta: %',v_consulta;
        return v_consulta;

      END;

    /*******************************
     #TRANSACCION:  RH_FUN_ASIG_CONT
     #DESCRIPCION:	Conteo de funcionarios sin asignacion
     #AUTOR:		franklin.espinoza
     #FECHA:		23/05/18
    ***********************************/
    elsif(par_transaccion='RH_FUN_ASIG_CONT')then

      --consulta:=';
      BEGIN

        v_consulta:='SELECT count(distinct FUNCIO.id_funcionario)
                            FROM orga.tfuncionario FUNCIO
                            INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                            INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                            LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                            inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
						    left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                            left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10
                            WHERE ';
        v_consulta:=v_consulta||v_parametros.filtro;


        if (v_parametros.tipo is not null and v_parametros.tipo = 'oficial' and v_parametros.fecha is not null and v_parametros.id_uo is not null) then
        	v_ids_funcionario = orga.f_get_funcionarios_con_asignacion_activa(v_parametros.id_uo, v_parametros.fecha);
        	v_consulta := v_consulta || ' and FUNCIO.id_funcionario not in (' || v_ids_funcionario ||') ';
		end if;
        return v_consulta;
      END;

    /*******************************
    #TRANSACCION:  RH_GETDAFUN_SEL
    #DESCRIPCION:	Obtener datos de funcionario a partir del nombre
    #AUTOR:
    #FECHA:		23/05/11
   ***********************************/
    elsif(par_transaccion='RH_GETDAFUN_SEL')then

      --consulta:=';
      BEGIN

        v_consulta='SELECT
               				FUNCIO.id_funcionario,
                            PERSON.nombre_completo1::varchar,
                            CAR.nombre,
                            pxp.list_unique(nc.numero)::varchar,
                            FUNCIO.email_empresa,
                            PERSON.nombre,
                            PERSON.ap_paterno,
                            ofi.nombre,
                            lug.nombre,
                            uo.nombre_unidad,
                            ofi.direccion,
                            PERSON.celular1,
                            pxp.list_unique(ni.numero)::varchar
                            FROM orga.tfuncionario FUNCIO
                            INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                            INNER JOIN orga.tuo_funcionario uofun on
                            	uofun.id_funcionario = FUNCIO.id_funcionario and uofun.estado_reg = ''activo'' and
                                uofun.fecha_asignacion <= now()::date and uofun.tipo = ''oficial'' and
                                (uofun.fecha_finalizacion >= now()::date or uofun.fecha_finalizacion is null)
                            INNER JOIN orga.tcargo car on car.id_cargo = uofun.id_cargo
                            LEFT JOIN gecom.tfuncionario_celular fc on fc.id_funcionario = FUNCIO.id_funcionario
                            	and fc.estado_reg = ''activo'' and fc.fecha_inicio <= now()::date and
                                (fc.fecha_fin >= now()::date or fc.fecha_fin is null) and fc.tipo_asignacion = ''personal''
                            LEFT JOIN gecom.tnumero_celular nc ON
                            	nc.id_numero_celular = fc.id_numero_celular and nc.tipo in (''celular'')
                            LEFT JOIN gecom.tfuncionario_celular fi on fi.id_funcionario = FUNCIO.id_funcionario
                            	and fi.estado_reg = ''activo'' and fi.fecha_inicio <= now()::date and
                                (fi.fecha_fin >= now()::date or fi.fecha_fin is null) and fi.tipo_asignacion = ''personal''
                            LEFT JOIN gecom.tnumero_celular ni ON
                            	ni.id_numero_celular = fi.id_numero_celular and ni.tipo in (''interno'')
                            LEFT JOIN orga.toficina ofi ON
                            	ofi.id_oficina = car.id_oficina
                            LEFT JOIN param.tlugar lug on lug.id_lugar = ofi.id_lugar
                            INNER JOIN orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)

                            WHERE ';



        v_consulta = v_consulta || v_parametros.filtro;
        v_consulta = v_consulta ||  ' GROUP BY FUNCIO.id_funcionario,
                            PERSON.nombre_completo1,
                            CAR.nombre,
                            FUNCIO.email_empresa,
                            PERSON.nombre,
                            PERSON.ap_paterno,
                            ofi.nombre,
                            lug.nombre,
                            uo.nombre_unidad,
                            ofi.direccion,
                            PERSON.celular1';


        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

        return v_consulta;


      END;

    /*******************************
     #TRANSACCION:  RH_GETDAFUN_CONT
     #DESCRIPCION:	Conteo de registros al obtener datos de funcionario a partir del nombre
     #AUTOR:
     #FECHA:		23/05/11
    ***********************************/
    elsif(par_transaccion='RH_GETDAFUN_CONT')then

      --consulta:=';
      BEGIN

        v_consulta:='SELECT
               				count(FUNCIO.id_funcionario)

                            FROM orga.tfuncionario FUNCIO
                            INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                            INNER JOIN orga.tuo_funcionario uofun on
                            	uofun.id_funcionario = FUNCIO.id_funcionario and uofun.estado_reg = ''activo'' and
                                uofun.fecha_asignacion <= now()::date and
                                (uofun.fecha_finalizacion >= now()::date or uofun.fecha_finalizacion is null)
                            INNER JOIN orga.tcargo car on car.id_cargo = uofun.id_cargo

                            WHERE ';



        v_consulta := v_consulta || v_parametros.filtro;

        return v_consulta;


      END;

    /*******************************
     #TRANSACCION:  RH_GETCUMPLEA_SEL
     #DESCRIPCION:	Cumpleaneros a fecha sel
     #AUTOR:
     #FECHA:		23/05/11
    ***********************************/
    elsif(par_transaccion='RH_GETCUMPLEA_SEL')then

      --consulta:=';
      BEGIN

        v_consulta:='SELECT
               				FUNCIO.id_funcionario,
                            FUNCIO.desc_funcionario1::varchar,
                            CAR.nombre,
                            F.email_empresa

                            FROM orga.vfuncionario FUNCIO

                            INNER JOIN orga.tfuncionario F ON F.id_funcionario=FUNCIO.id_funcionario
                            INNER JOIN SEGU.tpersona PERSON ON PERSON.id_persona=F.id_persona
                            INNER JOIN orga.tuo_funcionario uofun on
                            	uofun.id_funcionario = FUNCIO.id_funcionario and
                                uofun.tipo = ''oficial'' and
                                uofun.estado_reg = ''activo'' and
                                uofun.fecha_asignacion <= now()::date and
                                (uofun.fecha_finalizacion >= now()::date or uofun.fecha_finalizacion is null)
                            INNER JOIN orga.tcargo car on car.id_cargo = uofun.id_cargo
                            WHERE ';



        v_consulta := v_consulta || v_parametros.filtro;


        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

        return v_consulta;


      END;

    /*******************************
     #TRANSACCION:  RH_GETCUMPLEA_CONT
     #DESCRIPCION:	Conteo de empleados que cumplen anos a una fecha
     #AUTOR:
     #FECHA:		23/05/11
    ***********************************/
    elsif(par_transaccion='RH_GETCUMPLEA_CONT')then

      --consulta:=';
      BEGIN

        v_consulta:='SELECT
               				count(FUNCIO.id_funcionario)

                            FROM orga.vfuncionario FUNCIO
                            INNER JOIN orga.tfuncionario F ON F.id_funcionario=FUNCIO.id_funcionario
                            INNER JOIN SEGU.tpersona PERSON ON PERSON.id_persona=F.id_persona
                            INNER JOIN orga.tuo_funcionario uofun on
                            	uofun.id_funcionario = FUNCIO.id_funcionario and uofun.estado_reg = ''activo'' and
                                uofun.fecha_asignacion <= now()::date and
                                (uofun.fecha_finalizacion >= now()::date or uofun.fecha_finalizacion is null)
                            INNER JOIN orga.tcargo car on car.id_cargo = uofun.id_cargo

                            WHERE ';



        v_consulta := v_consulta || v_parametros.filtro;

        return v_consulta;


      END;

    /*******************************
     #TRANSACCION:  RH_FUNCIOCAR_SEL
     #DESCRIPCION:	Listado de funcionarios con cargos historicos
     #AUTOR:		KPLIAN (RAC)
     #FECHA:		29/10/11
    ***********************************/
    elseif(par_transaccion='RH_FUNCIOCAR_SEL')then

      --consulta:=';
      BEGIN

        v_filadd = '';
        IF (pxp.f_existe_parametro(par_tabla,'estado_reg_asi')) THEN
          v_filadd = ' (FUNCAR.estado_reg_asi = '''||v_parametros.estado_reg_asi||''') and ';
        END IF;

        v_consulta:='SELECT
                            FUNCAR.id_uo_funcionario,
                            FUNCAR.id_funcionario,
                            FUNCAR.desc_funcionario1,
                            FUNCAR.desc_funcionario2,
                            FUNCAR.id_uo,
                            FUNCAR.nombre_cargo,
                            FUNCAR.fecha_asignacion,
                            FUNCAR.fecha_finalizacion,
                            FUNCAR.num_doc,
                            FUNCAR.ci,
                            FUNCAR.codigo,
                            FUNCAR.email_empresa,
                            FUNCAR.estado_reg_fun,
                            FUNCAR.estado_reg_asi,
                            FUNCAR.id_cargo,
                            FUNCAR.descripcion_cargo,
                            FUNCAR.cargo_codigo,
                            FUNCAR.id_lugar,
                            FUNCAR.id_oficina,
                            FUNCAR.lugar_nombre,
                            FUNCAR.oficina_nombre

                            FROM orga.vfuncionario_cargo_lugar FUNCAR
                            WHERE '||v_filadd;


        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;


		raise notice 'v_consulta %', v_consulta;
        return v_consulta;


      END;

    /*******************************
     #TRANSACCION:  RH_FUNCIOCAR_CONT
     #DESCRIPCION:	Conteo de funcionarios con cargos historicos
     #AUTOR:		KPLIAN (rac)
     #FECHA:		23/05/11
    ***********************************/
    elsif(par_transaccion='RH_FUNCIOCAR_CONT')then

      --consulta:=';
      BEGIN

        v_filadd = '';
        IF (pxp.f_existe_parametro(par_tabla,'estado_reg_asi')) THEN
          v_filadd = ' (FUNCAR.estado_reg_asi = '''||v_parametros.estado_reg_asi||''') and ';
        END IF;

        v_consulta:='SELECT
                                  count(id_uo_funcionario)
                            FROM orga.vfuncionario_cargo_lugar FUNCAR
                            WHERE '||v_filadd;
        v_consulta:=v_consulta||v_parametros.filtro;
        return v_consulta;
      END;
    /*******************************
   #TRANSACCION:  ORGA_FUN_DOC_SEL
   #DESCRIPCION:	Lista los documento que tiene un funcionario.
   #AUTOR:		Franklin Espinoza A. (fea)
   #FECHA:		30/10/2017
  ***********************************/
  elsif(par_transaccion='ORGA_FUN_DOC_SEL')then
  --consulta:=';
    BEGIN

  --Creamos una tabla donde obtenemos la ultima asignacion de un funcionario
      create temp table tt_orga_filtro (
          id_funcionario integer,
          fecha_asignacion date
      )on commit drop;

      v_consulta = 'insert into tt_orga_filtro
                    select tuo.id_funcionario, max(tuo.fecha_asignacion)
                    from orga.tuo_funcionario tuo
                    where tuo.tipo = ''oficial'' and tuo.estado_reg = ''activo''
                    group by  tuo.id_funcionario';
      execute(v_consulta);
      --raise 'a: % b: %', v_parametros.id_uo is null,  v_parametros.id_lugar is null;

       IF (pxp.f_existe_parametro(par_tabla,'id_funcionario')) THEN
          if v_parametros.id_funcionario is not null then
          	v_id_funcionario_filtro = v_parametros.id_funcionario;
          ELSE
       		v_id_funcionario_filtro = null;
          end if;
       end if;


      IF (pxp.f_existe_parametro(par_tabla,'id_uo')) THEN
      	if (v_parametros.id_uo is not null and v_id_funcionario_filtro is not null) then
        	v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer||'and tf.id_funcionario = '||v_parametros.id_funcionario;
            v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuoo.id_uo,null::integer,null::date)';
        else
        	v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer;
            v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuoo.id_uo,null::integer,null::date)';
        end if;
      END IF;
      --raise 'filtro: %', v_filtro;
      IF (pxp.f_existe_parametro(par_tabla,'id_lugar')) THEN
      	if v_parametros.id_lugar is not null then
          v_filtro = ' tlo.id_lugar = '||v_parametros.id_lugar::integer;
          v_inner = '';
      	end if;
      END IF;

      --raise 'filtro: %', v_filtro;

      v_consulta = 'select
             		/*distinct on (tf.desc_funcionario2) */tf.desc_funcionario2::varchar AS desc_funcionario,
             		tf.id_funcionario,
                   tf.id_biometrico,
                   tf.ci,
                   (case when position(''FOTO_FUNCIONARIO'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Foto'' else ''X'' end)::varchar as fotografia,
                   (case when position(''DIAC'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''D. Academico'' else ''X'' end)::varchar as diploma_academico,
                   (case when position(''TIT_BACHILLER'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''T. Bachiller'' else ''X'' end)::varchar as titulo_bachiller,
                   (case when position(''TIT_PROF'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''T. Profesional'' else ''X'' end)::varchar as titulo_profesional,
                   (case when position(''TIT_MAES'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''T. Maestria'' else ''X'' end)::varchar as titulo_maestria,
                   (case when position(''TIT_DOC'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''T. Doctorado'' else ''X'' end)::varchar as titulo_doctorado,
                   (case when position(''CERT_EGRESO'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Egreso'' else ''X'' end)::varchar as certificado_egreso,
                   (case when position(''CI_FUNCIONARIO'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''CI'' else ''X'' end)::varchar as carnet_identidad,
                   (case when position(''CER_NAC'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Nacimiento'' else ''X'' end)::varchar as certificado_nacimiento,
                   (case when position(''CERT_MATR'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Matrimonio'' else ''X'' end)::varchar as certificado_matrimonio,
                   (case when position(''LIB_MIL'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''L. Militar'' else ''X'' end)::varchar as libreta_militar,

                   (case when position(''AVISO_FILIA'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''A. Afiliación'' else ''X'' end)::varchar as aviso_afiliacion,
                   (case when position(''EXA_PREOC'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''E. Preocupacional'' else ''X'' end)::varchar as examen_pre,
                   (case when position(''CARN_ASEG'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Asegurado'' else ''X'' end)::varchar as carnet_asegurado,
                   (case when position(''CAR_DIS'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Discapacidad'' else ''X'' end)::varchar as carnet_discapacidad,
                   (case when position(''FELCC'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''FELCC'' else ''X'' end)::varchar as felcc,
                   (case when position(''FELCN'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''FELCN'' else ''X'' end)::varchar as felcn,
                   (case when position(''CONTRA'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Contraloria'' else ''X'' end)::varchar as declaracion_jurada,
                   (case when position(''SIPASS'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Sipasse'' else ''X'' end)::varchar as sipasse,
                   (case when position(''DJ-PARENT'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''D.J. Parentesco'' else ''X'' end)::varchar as dj_parentesco,
                   (case when position(''DJ_PERS'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''D.J. Percepciones'' else ''X'' end)::varchar as dj_percepciones,
                   (case when position(''DESIG'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Memo Designación'' else ''X'' end)::varchar as memorandum_designacion,
                   (case when position(''CONTRATO'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Memo Contrato'' else ''X'' end)::varchar as memorandum_contrato,
                   (case when position(''DECL-HER'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''D. Herederos'' else ''X'' end)::varchar as declaracion_herederos,
                   (case when position(''FINIQ'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Finiquito'' else ''X'' end)::varchar as finiquito,
                   (case when position(''CART_DESP'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Despido'' else ''X'' end)::varchar as carta_despido,
                   (case when position(''CONC_CONTR'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''C. Contrato'' else ''X'' end)::varchar as conclusion_contrato,
                   (case when position(''DESV_PER_PRUE'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Desvinculación Prueba'' else ''X'' end)::varchar as desvinculacion_prueba,
                   (case when position(''OTR_RET'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Otro Retiro'' else ''X'' end)::varchar as otro_retiro,
                   (case when position(''BAJA'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Baja Afiliación'' else ''X'' end)::varchar as aviso_bajaf,
                   (case when position(''SUM'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''Sumario'' else ''X'' end)::varchar as sumario,
         (case when position(''PEN-EX-TRA'' in pxp.list(distinct tta.codigo)::varchar)>0 then ''P. Ex. Trabajadores'' else ''X'' end)::varchar as pendientes_extrabajadores,

                   orga.f_url_foto(tf.id_funcionario, pxp.list(distinct tta.codigo)::varchar) as url_foto,
                   tf.estado_reg,
                   tf.fecha_ingreso,
         		   uo.fecha_finalizacion,
                   tca.nombre as cargo,
                   tof.nombre as nombre_oficina,
         		   tlo.nombre as nombre_lugar_ofi,
                   tuoo.descripcion,
                   tca.id_lugar
				   from orga.vfuncionario_biometrico tf
                   inner join orga.tuo_funcionario uo on uo.id_funcionario = tf.id_funcionario AND
                   uo.fecha_asignacion  in (select fecha_asignacion
                                                      from tt_orga_filtro where id_funcionario = tf.id_funcionario)
         			left join param.tarchivo tar on tar.id_tabla = tf.id_funcionario
        			left join param.ttipo_archivo tta on tta.id_tipo_archivo = tar.id_tipo_archivo
                   inner join orga.tuo tuoo on tuoo.id_uo = uo.id_uo
                   '||v_inner||'
                   inner join orga.tcargo tca on tca.id_cargo = uo.id_cargo
                   inner join orga.toficina tof on tof.id_oficina = tca.id_oficina
                   inner join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                   where uo.estado_reg = ''activo'' and uo.tipo = ''oficial'' and '||v_filtro||' and ';

      v_consulta:=v_consulta||v_parametros.filtro;
      v_consulta:=v_consulta||'group by tf.id_funcionario, tf.id_biometrico, tf.desc_funcionario2, tf.ci, tf.estado_reg, tf.fecha_ingreso, uo.fecha_finalizacion, tca.nombre, tof.nombre, tlo.nombre, tuoo.descripcion, tca.id_lugar
      order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
  raise notice 'v_consulta: %',v_consulta;
      return v_consulta;
    END;
  /*******************************
   #TRANSACCION:  ORGA_FUN_DOC_CONT
   #DESCRIPCION:	Contador lista de documento que tiene un funcionario.
   #AUTOR:		Franklin Espinoza A. (fea)
   #FECHA:		30/10/2017
  ***********************************/
  elsif(par_transaccion='ORGA_FUN_DOC_CONT')then
    --consulta:=';
    BEGIN

  --Creamos una tabla donde obtenemos la ultima asignacion de un funcionario
  create temp table tt_orga_filtro (
          id_funcionario integer,
          fecha_asignacion date
      )on commit drop;


      v_consulta = 'insert into tt_orga_filtro
                    select tuo.id_funcionario, max(tuo.fecha_asignacion)
                    from orga.tuo_funcionario tuo
                    where tuo.tipo = ''oficial'' and tuo.estado_reg = ''activo''
                    group by  tuo.id_funcionario';

      execute(v_consulta);

      IF pxp.f_existe_parametro(par_tabla,'id_uo') THEN
      	if v_parametros.id_uo is not null then
        	v_filtro = 'ger.id_uo = '||v_parametros.id_uo::integer;
            v_inner = 'inner join orga.tuo ger on ger.id_uo=orga.f_get_uo_gerencia(tuoo.id_uo,null::integer,null::date)';
        end if;
      END IF;

      IF pxp.f_existe_parametro(par_tabla,'id_lugar') THEN
      	if v_parametros.id_lugar is not null then
          v_filtro = ' tlo.id_lugar = '||v_parametros.id_lugar::integer;
          v_inner = '';
      	end if;
      END IF;

      v_consulta = 'select count( /*distinct*/ tf.id_funcionario)
         			from orga.vfuncionario_biometrico tf
                   	inner join orga.tuo_funcionario uo on uo.id_funcionario = tf.id_funcionario AND
                   	uo.fecha_asignacion  in (select fecha_asignacion
                                                      from tt_orga_filtro where id_funcionario = tf.id_funcionario)
         			left join param.tarchivo tar on tar.id_tabla = tf.id_funcionario
        			left join param.ttipo_archivo tta on tta.id_tipo_archivo = tar.id_tipo_archivo
                   	inner join orga.tuo tuoo on tuoo.id_uo = uo.id_uo
                   	'||v_inner||'
                   	inner join orga.tcargo tca on tca.id_cargo = uo.id_cargo
                   	inner join orga.toficina tof on tof.id_oficina = tca.id_oficina
                   	inner join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                   	where uo.estado_reg = ''activo'' and uo.tipo = ''oficial'' and '||v_filtro||' and ';
      v_consulta:=v_consulta||v_parametros.filtro;

      return v_consulta;
    END;
    /*******************************
     #TRANSACCION:  ORGA_REP_DOC_SEL
     #DESCRIPCION:	Reporte de documento que tiene un funcionario.
     #AUTOR:		Franklin Espinoza A. (fea)
     #FECHA:		02-04-2018
    ***********************************/
    elsif(par_transaccion='ORGA_REP_DOC_SEL')then
      BEGIN

        v_consulta = 'select
        			 (''(''||tuo.codigo||'')''||tuo.nombre_unidad)::varchar as gerencia,
                     tf.desc_funcionario2::varchar AS desc_funcionario,
        			 tf.id_funcionario,
                     tf.ci,
                     tc.nombre as cargo,
                     tf.fecha_ingreso,
                     orga.f_get_documentos_func(tf.id_funcionario) as documento
					 from orga.vfuncionario_biometrico tf
                     inner JOIN orga.tuo_funcionario uof ON uof.id_funcionario = tf.id_funcionario and (current_date <= uof.fecha_finalizacion or  uof.fecha_finalizacion is null)
                     inner JOIN orga.tuo tuo on tuo.id_uo = orga.f_get_uo_gerencia(uof.id_uo,uof.id_funcionario,current_date)
     				 inner JOIN orga.tcargo tc ON tc.id_cargo = uof.id_cargo
                     where tf.estado_reg = ''activo'' and tc.estado_reg = ''activo'' and tc.codigo != ''99999''
                     order by gerencia,desc_funcionario ';
		raise notice 'v_consulta: %',v_consulta;
        return v_consulta;
      END;
    /*********************************
 	#TRANSACCION:  'RH_URL_IMG_SEL'
 	#DESCRIPCION:	url de la fotografia de un funcionario
 	#AUTOR:		franklin.espinoza
 	#FECHA:		20-09-2017 20:55:18
	***********************************/
	elsif(par_transaccion='RH_URL_IMG_SEL')then

    	begin
        	v_consulta = 'select (''erp.obairlines.bo''||substr(tar.folder,11)||tar.nombre_archivo||''.''||tar.extension)::varchar
					  	  from orga.tfuncionario tf
					  	  inner join param.tarchivo tar on tar.id_tabla = tf.id_funcionario and tar.id_tipo_archivo = 10 and tar.id_archivo_fk  is null
					  	  where tf.id_funcionario = '||v_parametros.id_funcionario||' and tar.estado_reg = ''activo''';
        	return v_consulta;
        end;
    /*********************************
 	#TRANSACCION:  'ORGA_URL_IMG_U_SEL'
 	#DESCRIPCION:	url de la fotografia de un funcionario
 	#AUTOR:		franklin.espinoza
 	#FECHA:		20-09-2017 20:55:18
	***********************************/

	elsif(par_transaccion='ORGA_URL_IMG_U_SEL')then

    	begin

        SELECT tf.id_funcionario
        into v_id_funcionario
        FROM segu.tusuario tu
        INNER JOIN orga.tfuncionario tf on tf.id_persona = tu.id_persona
		WHERE tu.id_usuario =v_parametros.id_usuario ;
        --raise exception 'v_id_funcionario: %',v_id_funcionario
        	v_consulta = 'select (''http://172.17.58.12:/datasys/erp_produccion/uploaded_files''||substr(tar.folder,11)||tar.nombre_archivo||''.''||tar.extension)::varchar
					  	  from orga.tfuncionario tf
					  	  inner join param.tarchivo tar on tar.id_tabla = tf.id_funcionario and tar.id_tipo_archivo = 10
					  	  where tf.id_funcionario = '||v_id_funcionario||' and tar.estado_reg = ''activo''';
        	return v_consulta;
        end;
    /*******************************
     #TRANSACCION:  RH_FUN_ALT_BAJ_SEL
     #DESCRIPCION:	Listado de Altas y Bajas Funcionarios
     #AUTOR:		franklin.espinoza
     #FECHA:		10/06/2019
    ***********************************/
    elsif(par_transaccion='RH_FUN_ALT_BAJ_SEL')then
      BEGIN


      	/*if v_parametros.estado_func = 'altas' then
        	v_filtro = 'tuo.fecha_asignacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
        else
        	v_filtro = 'tuo.fecha_finalizacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
        end if;*/
		if v_parametros.estado_func = 'altas' then
        	v_filtro = 'tuo.fecha_asignacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
          v_inner  =  'tuo.id_funcionario not in (select tu.id_funcionario from orga.tuo_funcionario tu where tu.fecha_finalizacion between '''||(v_parametros.fecha_ini - interval '1 month')::date||'''::date and '''||(v_parametros.fecha_fin - interval '1 month')::date||'''::date) and  '::varchar;
        else
        	v_filtro = 'tuo.fecha_finalizacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
            v_inner  = 'tuo.id_funcionario not in (select tu.id_funcionario from orga.tuo_funcionario tu where tu.fecha_asignacion between '''||(v_parametros.fecha_ini + interval '1 month')::date||'''::date and '''||(v_parametros.fecha_fin + interval '1 month')::date||'''::date) and  '::varchar;
        end if;

        v_consulta:='SELECT
                            FUNCIO.id_funcionario,
                            FUNCIO.codigo,
                            FUNCIO.email_empresa,
                            FUNCIO.interno,
                            FUNCIO.fecha_ingreso,
                            FUNCIO.id_persona,
                            PERSON.nombre_completo2 AS desc_person,
                            PERSON.ci,
                            PERSON2.expedicion,
                            PERSON.num_documento,
                            PERSON.telefono1,
                            PERSON.celular1,
                            PERSON.correo,
                            FUNCIO.telefono_ofi,
                            PERSON.telefono2,
                            PERSON.celular2,
                            PERSON.nombre,
                            PERSON.ap_materno,
                            PERSON.ap_paterno,
                            tuo.fecha_asignacion,
                            tuo.fecha_finalizacion,
                            tca.nombre as nombre_cargo,
                            tof.nombre as nombre_oficina,
                            tlo.nombre as nombre_lugar_ofi,

                            FUNCIO.id_usuario_reg,
                            FUNCIO.id_usuario_mod,
                            usu1.cuenta as usr_reg,
						    usu2.cuenta as usr_mod,
                            FUNCIO.estado_reg,
                            FUNCIO.fecha_reg,
                            FUNCIO.fecha_mod,

                            tes.nombre as desc_nivel_salarial,
                            tes.haber_basico::numeric,
                            0::numeric as bono_antiguedad,
                            0::numeric as bono_frontera,
                            tes.haber_basico::numeric as total_ganado,
                            tar.nombre_archivo,
                            tar.extension,
                            tuo.observaciones_finalizacion as motivo_fin,
                            tcon.nombre as nombre_contrato

                            FROM orga.tfuncionario FUNCIO
                            inner join orga.tuo_funcionario tuo on tuo.id_funcionario = FUNCIO.id_funcionario
                            inner join orga.tcargo tca on tca.id_cargo = tuo.id_cargo
                            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tca.id_tipo_contrato
                            inner join orga.tescala_salarial tes on tes.id_escala_salarial = tca.id_escala_salarial
                            inner join orga.toficina tof on tof.id_oficina = tca.id_oficina
                            inner join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                            INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                            INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                            LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                            inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
						    left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                            left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10
                            WHERE tuo.estado_reg = ''activo'' and '||v_filtro||' and '||v_inner;

        v_consulta := v_consulta || v_parametros.filtro;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
		RAISE NOTICE 'v_consulta: %',v_consulta;
        return v_consulta;

      END;
    /*********************************
 	#TRANSACCION:  'RH_FUN_ALT_BAJ_CONT'
 	#DESCRIPCION:	Contador listado de Altas y Bajas Funcionarios
 	#AUTOR:		franklin.espinoza
 	#FECHA:		10/06/2019
	***********************************/
	elsif(par_transaccion='RH_FUN_ALT_BAJ_CONT')then

    	begin
			/*if v_parametros.estado_func = 'altas' then
        		v_filtro = 'tuo.fecha_asignacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
            else
                v_filtro = 'tuo.fecha_finalizacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
            end if;*/
            if v_parametros.estado_func = 'altas' then
        		v_filtro = 'tuo.fecha_asignacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
            v_inner  =  'tuo.id_funcionario not in (select tu.id_funcionario from orga.tuo_funcionario tu where tu.fecha_finalizacion between '''||(v_parametros.fecha_ini - interval '1 month')::date||'''::date and '''||(v_parametros.fecha_fin - interval '1 month')::date||'''::date) and  '::varchar;
        	else
        		v_filtro = 'tuo.fecha_finalizacion between '''||v_parametros.fecha_ini||'''::date and '''||v_parametros.fecha_fin||'''::date';
            	v_inner  = 'tuo.id_funcionario not in (select tu.id_funcionario from orga.tuo_funcionario tu where tu.fecha_asignacion between '''||(v_parametros.fecha_ini + interval '1 month')::date||'''::date and '''||(v_parametros.fecha_fin + interval '1 month')::date||'''::date) and  '::varchar;
        	end if;

        v_consulta:='SELECT count(FUNCIO.id_funcionario)
                            FROM orga.tfuncionario FUNCIO
                            inner join orga.tuo_funcionario tuo on tuo.id_funcionario = FUNCIO.id_funcionario
                            inner join orga.tcargo tca on tca.id_cargo = tuo.id_cargo
                            inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tca.id_tipo_contrato
                            inner join orga.toficina tof on tof.id_oficina = tca.id_oficina
                            inner join param.tlugar tlo on tlo.id_lugar = tca.id_lugar
                            INNER JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona
                            INNER JOIN SEGU.tpersona PERSON2 ON PERSON2.id_persona=FUNCIO.id_persona
                            LEFT JOIN param.tlugar LUG on LUG.id_lugar = PERSON2.id_lugar
                            inner join segu.tusuario usu1 on usu1.id_usuario = FUNCIO.id_usuario_reg
						    left join segu.tusuario usu2 on usu2.id_usuario = FUNCIO.id_usuario_mod
                            left join param.tarchivo tar on tar.id_tabla = FUNCIO.id_funcionario and tar.id_tipo_archivo = 10
                            WHERE tuo.estado_reg = ''activo'' and '||v_filtro||' and '||v_inner;
        v_consulta := v_consulta || v_parametros.filtro;
        return v_consulta;
        end;
    /*********************************
    #TRANSACCION:  'ORGA_LUG_FUNC_SEL'
    #DESCRIPCION:	Retorna el lugar de la oficina de un funcionario
    #AUTOR:		franklin.espinoza
    #FECHA:		16-01-2020 09:19:28
    ***********************************/
    elsif(par_transaccion='ORGA_LUG_FUNC_SEL')then
      begin
          --Sentencia lugar de trabajo
          select lug.id_lugar
              into v_id_lugar
              from segu.tusuario usu
              inner join orga.tfuncionario fun on fun.id_persona = usu.id_persona
              inner join orga.tuo_funcionario uof on uof.id_funcionario = fun.id_funcionario
              inner join orga.tcargo car on car.id_cargo = uof.id_cargo
              inner join param.tlugar lug on lug.id_lugar = car.id_lugar
              where usu.id_usuario = par_id_usuario and current_date <= coalesce(uof.fecha_finalizacion, '31/12/9999'::date)
              and uof.estado_reg = 'activo'and car.estado_reg = 'activo';

          --Sentencia de la consulta
          v_consulta:='select
              lug.id_lugar,
              lug.codigo,
              lug.estado_reg,
              lug.id_lugar_fk,
              lug.nombre,
              lug.sw_impuesto,
              lug.sw_municipio,
              lug.tipo,
              lug.fecha_reg,
              lug.id_usuario_reg,
              lug.fecha_mod,
              lug.id_usuario_mod,
              usu1.cuenta as usr_reg,
              usu2.cuenta as usr_mod,
              lug.es_regional,
              lug.id_sql_server
              from param.tlugar lug
              inner join segu.tusuario usu1 on usu1.id_usuario = lug.id_usuario_reg
              left join segu.tusuario usu2 on usu2.id_usuario = lug.id_usuario_mod
                  where  lug.id_lugar = '||v_id_lugar||' and ';

        --Definicion de la respuesta
        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

        --Devuelve la respuesta
        return v_consulta;

      end;
    else
      raise exception 'No existe la opcion';

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

ALTER FUNCTION orga.ft_funcionario_sel (par_administrador integer, par_id_usuario integer, par_tabla varchar, par_transaccion varchar)
  OWNER TO postgres;