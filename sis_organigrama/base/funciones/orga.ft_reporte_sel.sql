CREATE OR REPLACE FUNCTION orga.ft_reporte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Recursos Humanos
 FUNCION: 		orga.ft_reporte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.ft_reporte_sel'
 AUTOR: 		(fea)
 FECHA:	        18-04-2018 17:29:14
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
	v_filtro			varchar = '';
    v_mes				integer;
    v_fechas			record;
    v_id_gestion 		integer;
    v_orden				varchar;
BEGIN

	v_nombre_funcion = 'orga.ft_reporte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_R_MAIL_BOA_SEL'
 	#DESCRIPCION:	reporte de correos de funcionario boa
 	#AUTOR:		f.e.a
 	#FECHA:		18-04-2018 17:29:14
	***********************************/

	if(p_transaccion='OR_R_MAIL_BOA_SEL')then

    	begin

            if(v_parametros.oficina != '0')then
            	v_filtro = ' and tl.id_lugar in ( '||v_parametros.oficina||')';
            end if;

            v_mes = date_part('month', current_date);

            select tg.id_gestion
            into v_id_gestion
            from param.tgestion tg
            where tg.gestion = date_part('year', current_date);

            select tp.fecha_ini, tp.fecha_fin
            into v_fechas
            from param.tperiodo tp
            where tp.periodo = v_mes and tp.id_gestion = v_id_gestion;


    		--Sentencia de la consulta
			v_consulta:='select distinct (''(''||tuo.codigo||'')''||tuo.nombre_unidad)::varchar as gerencia,
             ttc.nombre as contrato ,
             tf.desc_funcionario1::varchar AS desc_funcionario,
             tc.nombre as cargo,
             tl.nombre as lugar,
             tl.codigo,
             tf.email_empresa,
             (case when (select coalesce(tot.fecha_finalizacion,''31/12/9999'') from orga.tuo_funcionario tot where tot.id_uo_funcionario = orga.f_get_ultima_asignacion(tf.id_funcionario))>current_date then ''activo'' else ''inactivo'' end)::varchar estado_fun
             from orga.vfuncionario_cargo tf
             inner JOIN orga.tuo_funcionario uof ON uof.id_funcionario = tf.id_funcionario --and (current_date <= uof.fecha_finalizacion or  uof.fecha_finalizacion is null)
             inner JOIN orga.tuo tuo on tuo.id_uo = orga.f_get_uo_gerencia(uof.id_uo,uof.id_funcionario,current_date)
             inner JOIN orga.tcargo tc ON tc.id_cargo = uof.id_cargo
             inner join param.tlugar tl on tl.id_lugar = tc.id_lugar
             inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato
             where tc.estado_reg = ''activo'' and ttc.codigo in (''PLA'',''EVE'',''PEXT'', ''PEXTE'') and uof.tipo = ''oficial'' and
             uof.estado_reg != ''inactivo'' and uof.fecha_asignacion <= '''||v_fechas.fecha_fin||'''::date and
             (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= '''||v_fechas.fecha_ini||'''::date)'||v_filtro||'
             order by tl.codigo, gerencia, desc_funcionario';

			--Definicion de la respuesta
			--v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			RAISE NOTICE 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'OR_R_CUMPLE_BOA_SEL'
 	#DESCRIPCION:	reporte de cumpleañeros de funcionarios boa
 	#AUTOR:		f.e.a
 	#FECHA:		18-05-2018 17:29:14
	***********************************/
	elsif(p_transaccion='OR_R_CUMPLE_BOA_SEL')then

    	begin

        	select tp.periodo
            into v_mes
			from param.tperiodo tp
			where tp.id_periodo = v_parametros.id_periodo and tp.id_gestion = v_parametros.id_gestion;
            --RAISE EXCEPTION 'v_mes: %, %, %', v_mes, v_parametros.id_periodo, v_parametros.id_gestion;
            if v_parametros.orden = 'gerencia' then
            	v_orden = 'order by uo.nombre_unidad asc';
            elsif v_parametros.orden = 'nombre_empleado' then
            	v_orden = 'order by fun.desc_funcionario2 asc';
            elsif v_parametros.orden = 'fecha_nacimiento' then
            	v_orden = 'order by  EXTRACT(day FROM per.fecha_nacimiento)::integer asc';
            else
            	v_orden = 'order by  EXTRACT(day FROM per.fecha_nacimiento)::integer asc';
            end if;

    		--Sentencia de la consulta
			v_consulta:='select
                          uo.nombre_unidad::varchar ,
                          fun.desc_funcionario2::varchar as desc_func,
                          to_char(per.fecha_nacimiento,''DD/MM'')::varchar as f_dia,
                          per.fecha_nacimiento,
                          c.nombre as nom_cargo,
                          ofi.nombre as nom_oficina,
                          plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_contrato,
                          f.email_empresa

                        from orga.vfuncionario fun
                        inner join orga.tfuncionario f on f.id_funcionario = fun.id_funcionario
                        inner join segu.tpersona per on per.id_persona = f.id_persona
                        inner join orga.tuo_funcionario uofun on uofun.id_funcionario = fun.id_funcionario
                        and uofun.fecha_asignacion <= current_date and
                        (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion>= current_date) and
                        uofun.estado_reg = ''activo''
                        inner join orga.tcargo c on c.id_cargo = uofun.id_cargo and c.id_tipo_contrato in (1,4,6,7)
                        inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uofun.id_uo,NULL,NULL)
                        left join orga.toficina ofi on ofi.id_oficina = c.id_oficina
                        where EXTRACT(month FROM per.fecha_nacimiento)::integer = '||v_mes||'
                        ';

			--Definicion de la respuesta
			--v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||v_orden;
			RAISE NOTICE 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ORGA_REP_DOC_RH_SEL'
 	#DESCRIPCION:	reporte planilla lista de documentos
 	#AUTOR:		f.e.a
 	#FECHA:		13-3-2019 17:29:14
	***********************************/

	elsif(p_transaccion='ORGA_REP_DOC_RH_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='

            select
        			 (''(''||tuo.codigo||'')''||tuo.nombre_unidad)::varchar as gerencia,
               tf.desc_funcionario2::varchar AS desc_funcionario,
        			 tf.id_funcionario,
               tf.ci,
               tc.nombre as cargo,
               tf.fecha_ingreso,
               orga.f_get_documentos_list_func(tf.id_funcionario, '''||v_parametros.tipo_archivo||'''::varchar) as documento,

               tl.nombre as lugar,
               tl.codigo

					 from orga.vfuncionario_biometrico tf
           inner JOIN orga.tuo_funcionario uof ON uof.id_funcionario = tf.id_funcionario and (current_date <= uof.fecha_finalizacion or  uof.fecha_finalizacion is null)
           inner JOIN orga.tuo tuo on tuo.id_uo = orga.f_get_uo_gerencia(uof.id_uo,uof.id_funcionario,current_date)
     			 inner JOIN orga.tcargo tc ON tc.id_cargo = uof.id_cargo
     			 inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato

           inner join orga.toficina tof on tof.id_oficina = tc.id_oficina
           inner join param.tlugar tl on tl.id_lugar = tof.id_lugar

           where tf.estado_reg = ''activo'' and tc.estado_reg = ''activo'' and uof.estado_reg = ''activo'' and uof.tipo = ''oficial''
           and ttc.codigo in (''PLA'',''EVE'')
           order by lugar, gerencia,desc_funcionario ';

            RAISE NOTICE 'v_consulta: %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
	/*********************************
 	#TRANSACCION:  'ORGA_HEADER_DOC_SEL'
 	#DESCRIPCION:	cabeceras lista de documentos
 	#AUTOR:		f.e.a
 	#FECHA:		13-3-2019 17:29:14
	***********************************/

	elsif(p_transaccion='ORGA_HEADER_DOC_SEL')then

    	begin
    	--Sentencia de la consulta
			v_consulta:='
				WITH archivos AS (
    				 select tta.id_tipo_archivo,
                     tta.codigo,
                     tta.nombre
                     from param.ttipo_archivo tta
                     where tta.id_tipo_archivo = any (string_to_array('''||v_parametros.tipo_archivo||''', '','')::integer[])
                     order by tta.id_tipo_archivo asc
				)

                SELECT
                TO_JSON(ROW_TO_JSON(jsonData) :: TEXT) #>> ''{}'' AS headers
                FROM (
                       SELECT
                         (
                           SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(t_archivos))) as header
                           FROM
                             (
                               SELECT fil.codigo, fil.nombre,
                                 (
                                   SELECT string_to_array(pxp.list(ROW_TO_JSON(t_campos)::varchar),'','') as campos
                                   FROM
                                     (
                                       select
                                       tfta.nombre as clave
                                       from param.tfield_tipo_archivo tfta
                                       where tfta.id_tipo_archivo = fil.id_tipo_archivo
                                     ) t_campos
                                 )
                               FROM archivos fil
                             ) t_archivos
                         )
                     ) jsonData ';
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ORGA_INF_RAPIDA_SEL'
 	#DESCRIPCION:	reporte Información Rapida
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-01-2021 10:00:00
	***********************************/

	elsif(p_transaccion='ORGA_INF_RAPIDA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='

            select
            	tf.id_funcionario,
               	tf.desc_funcionario2::varchar AS funcionario,
               	tf.ci,
                tper.fecha_nacimiento,
               	tc.nombre as cargo,
               	tf.fecha_ingreso,
                ((case when coalesce(tper.celular1,''no tiene'') != '''' then coalesce(tper.celular1,''no tiene'') else ''no tiene'' end)||'' / ''||(case when coalesce(tper.telefono1,''no tiene'') != '''' then coalesce(tper.telefono1,''no tiene'') else ''no tiene'' end))::varchar telefonos,
               	orga.f_get_documentos_list_func(tf.id_funcionario, ''13''::varchar) as profesion,
                orga.f_get_documentos_list_func(tf.id_funcionario, ''28''::varchar) as contrato,
                afp.nro_afp afp,
                taf.nombre::varchar institucion,
                tper.apellido_paterno::varchar,
			    tper.apellido_materno::varchar,
			    tper.nombre::varchar,
			    (coalesce(gecom.f_get_numero_asignado(''interno'', fun.id_funcionario),''Interno No Asignado'')||''/''||coalesce(gecom.f_get_numero_asignado(''celular'', fun.id_funcionario),''Celular No Asignado''))::varchar telefono_oficina,
                fun.email_empresa::varchar correo_institucional,
                tper.correo::varchar correo_personal,

                uo.nombre_unidad::varchar gerencia,
                ofi.nombre::varchar nombre_oficina,
                lug.nombre::varchar nombre_lugar,
                (CASE
                      WHEN tper.genero::text = ANY (ARRAY[''varon''::character varying,''VARON''::character varying, ''Varon''::character varying]::text[]) THEN ''M''
                      WHEN tper.genero::text = ANY (ARRAY[''mujer''::character varying,''MUJER''::character varying, ''Mujer''::character varying]::text[]) THEN ''F''
                      ELSE '''' END)::varchar genero,
                esc.haber_basico,
			    (case when plani.f_get_licencia(fun.id_funcionario, current_date) then ''SI'' else ''NO'' end)::varchar licencia
			   from orga.vfuncionario_biometrico tf
			   inner join orga.tfuncionario fun on fun.id_funcionario = tf.id_funcionario
               inner join segu.tpersona tper on tper.id_persona = fun.id_persona
               inner join plani.tfuncionario_afp afp on afp.id_funcionario = tf.id_funcionario and afp.estado_reg = ''activo'' and coalesce(afp.fecha_fin,''31/12/9999''::date) > current_date
               inner join plani.tafp taf on taf.id_afp = afp.id_afp
           	   inner JOIN orga.tuo_funcionario uof ON uof.id_funcionario = tf.id_funcionario and uof.estado_reg = ''activo'' and uof.tipo = ''oficial''
               and (coalesce (uof.fecha_finalizacion,''31/12/9999''::date) >= current_date)
     		   inner JOIN orga.tcargo tc ON tc.id_cargo = uof.id_cargo and tc.estado_reg = ''activo''
     		   inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato

               inner join orga.tescala_salarial esc on esc.id_escala_salarial = tc.id_escala_salarial
			   left join plani.tlicencia lic on lic.id_funcionario =  fun.id_funcionario

               inner  join orga.toficina ofi on ofi.id_oficina = tc.id_oficina
     		   inner  join param.tlugar lug on lug.id_lugar = ofi.id_lugar

               inner join orga.tuo uo on uo.id_uo = orga.f_get_uo_gerencia(uof.id_uo,NULL,NULL)

           	   where tf.estado_reg = ''activo'' and ttc.codigo in (''PLA'',''EVE'')
           	   order by funcionario ';

            RAISE NOTICE 'v_consulta: %', v_consulta;
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

ALTER FUNCTION orga.ft_reporte_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;