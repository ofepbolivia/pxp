CREATE OR REPLACE FUNCTION orga.f_listar_uo_items (
  p_fecha date,
  p_licencia varchar
)
RETURNS TABLE (
  escala varchar,
  cargo varchar,
  nro_item varchar,
  nombre_funcionario varchar,
  genero varchar,
  haber_basico numeric,
  bono_antiguedad numeric,
  bono_frontera numeric,
  sumatoria numeric,
  fecha_inicio varchar,
  ci varchar,
  expedicion varchar,
  codigo varchar,
  nombre varchar,
  codigo_nombre_gerencia varchar,
  nombre_unidad varchar,
  id_tipo_contrato varchar,
  gerencia varchar,
  departamento varchar,
  categoria_programatica varchar,
  fecha_finalizacion varchar,
  id_uo integer,
  correlativo integer,
  id_funcionario integer
) AS
$body$
/**************************************************************************
 SISTEMA:		Sistema Organigrama
 FUNCION: 		public.f_listar_uo_items
 DESCRIPCION:   Funcion que recupera la estructura de el arbol unidad organizacional por items
 AUTOR: 		(franklin.espinoza)
 FECHA:	        19-04-2021
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_resp		            varchar='';
	v_nombre_funcion        text;
	v_record 				record;
    v_record_ids			record;
    v_cadena_ids			  varchar = '';
    v_id_uo					  integer;

    v_escala                  varchar;
    v_cargo                   varchar;
    v_nro_item                varchar;
    v_nombre_funcionario      varchar;
    v_genero                  varchar;
    v_haber_basico            numeric;
    v_bono_antiguedad         numeric;
    v_bono_frontera           numeric;
    v_sumatoria               numeric;
    v_fecha_inicio            varchar;
    v_ci                      varchar;
    v_expedicion              varchar;
    v_codigo                  varchar;
    v_nombre                  varchar;
    v_codigo_nombre_gerencia  varchar;
    v_nombre_unidad           varchar;
    v_id_tipo_contrato        varchar;
    v_gerencia                varchar;
    v_departamento            varchar;
    v_categoria_programatica  varchar;
    v_fecha_finalizacion      varchar;
    v_tiempo_empresa          interval;
    v_item                    record;
    v_id_gerente              integer;

    v_correlativo					  integer = 1;

BEGIN

    v_nombre_funcion = 'orga.f_listar_uo_items';

    select pxp.list(tuo.id_funcionario::varchar)
    into v_id_gerente
    from orga.tcargo tcar
    inner join orga.tuo_funcionario tuo on tuo.id_cargo = tcar.id_cargo
    inner join orga.tuo uo on uo.id_uo = tuo.id_uo
    where tuo.estado_reg = 'activo' and tuo.tipo = 'oficial' and tcar.codigo = '1' and uo.estado_reg = 'activo';

    for v_id_uo in select unnest(string_to_array(10113||','||rtrim(orga.f_get_arbol_uo(10113),','), ',')) /*limit 15*/   loop

    	for v_item in	select tc.id_uo, tc.id_cargo
      					from orga.tcargo tc
        				inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato and ttc.codigo in ('PLA','EVE')
                    	where tc.id_uo = v_id_uo and coalesce(tc.fecha_ini,'31/12/9999'::date) >= '01/03/2021'::date and tc.estado_reg = 'activo' loop




			select tes.nombre escala, tc.nombre cargo, tc.codigo nro_item, COALESCE(initcap(vf.desc_funcionario2), 'ACEFALO')::varchar nombre_funcionario,
                   (CASE
                        WHEN tpe.genero::text = ANY (ARRAY['varon'::character varying,'VARON'::character varying, 'Varon'::character varying]::text[]) THEN 'M'
                        WHEN tpe.genero::text = ANY (ARRAY['mujer'::character varying,'MUJER'::character varying, 'Mujer'::character varying]::text[]) THEN 'F'
                    ELSE '' END)::varchar genero,  tes.haber_basico,
                   (coalesce(round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(tuo.id_uo_funcionario, tuo.id_funcionario, tuo.fecha_asignacion), p_fecha, tf.antiguedad_anterior), 2),0))::numeric AS bono_antiguedad,
                   (CASE WHEN ofi.frontera = 'si' AND tf.id_funcionario IS NOT NULL THEN tes.haber_basico * 0.2 ELSE 0.00 END)::numeric AS bono_frontera,

                   case when ofi.frontera = 'si' and tf.id_funcionario is not null then
                    (tes.haber_basico + coalesce(round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(tuo.id_uo_funcionario, tuo.id_funcionario, tuo.fecha_asignacion), p_fecha, tf.antiguedad_anterior), 2),0) + tes.haber_basico * 0.2)::numeric
                    else (tes.haber_basico + coalesce(round(plani.f_evaluar_antiguedad(plani.f_get_fecha_primer_contrato_empleado(tuo.id_uo_funcionario, tuo.id_funcionario, tuo.fecha_asignacion), p_fecha, tf.antiguedad_anterior), 2),0))::numeric end AS sumatoria,

                   (CASE WHEN tf.id_funcionario IS NOT NULL THEN orga.f_get_fechas_ini_historico(tf.id_funcionario, p_fecha) ELSE NULL END)::varchar fecha_inicio,
                   --(plani.f_get_fecha_primer_contrato_empleado(tuo.id_uo_funcionario, tuo.id_funcionario, tuo.fecha_asignacion))::varchar fecha_inicio,

                    tpe.ci,
                    tpe.expedicion,
                    lug.codigo,
                    ofi.nombre,

                   (ger.codigo || ' - ' || ger.nombre_unidad)::varchar codigo_nombre_gerencia,
                    dep.nombre_unidad,
                    tc.id_tipo_contrato,
                    ger.nombre_unidad  gerencia,
                    dep.nombre_unidad departamento,

                    ( case
                    when lower(ger.nombre_unidad) like '%cobija%' then
                        '6.CIJ'
                    when tc.codigo = '0' then
                        '5.EVE'
                    when cas.codigo = 'SUPER' and (tf.id_funcionario not in (v_id_gerente) or tf.id_funcionario is null)  then
                        '3.ESP'
                    when (catp.desc_programa ilike '%ADM%' or (cas.codigo = 'SUPER' and tf.id_funcionario in (v_id_gerente))) then
                        '1.ADM'
                    when catp.desc_programa ilike '%OPE%' then
                        '2.OPE'
                    when catp.desc_programa ilike '%COM%' then
                        '4.COM'
                    else
                        'SINCAT'
                    end )::varchar as categoria_programatica,

                    to_char(tuo.fecha_finalizacion,'DD/MM/YYYY')::varchar as fecha_finalizacion,
                    tf.id_funcionario

					into v_record
                      from orga.tcargo tc

                      left join orga.tcargo_presupuesto tcp on tcp.id_cargo = tc.id_cargo and tcp.estado_reg = 'activo' and tcp.id_gestion = (SELECT tg.id_gestion
                                                                                                                 FROM param.tgestion tg
                                                                                                                 WHERE tg.gestion = date_part('year', current_date))
                      LEFT JOIN pre.tpresupuesto tpre on tpre.id_presupuesto = tcp.id_centro_costo

                      LEFT JOIN pre.vcategoria_programatica catp on catp.id_categoria_programatica = tpre.id_categoria_prog
                      join orga.tescala_salarial tes on tes.id_escala_salarial = tc.id_escala_salarial and tes.estado_reg = 'activo'
                      join orga.tcategoria_salarial cas ON cas.id_categoria_salarial = tes.id_categoria_salarial and cas.estado_reg = 'activo'

                      left join orga.tuo_funcionario tuo on tuo.id_cargo = tc.id_cargo and tuo.estado_reg = 'activo' and tuo.tipo = 'oficial' and
                      (coalesce (tuo.fecha_finalizacion,'31/12/9999'::date) >= current_date)

                      left join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
                      left join orga.tfuncionario tf on tf.id_funcionario = vf.id_funcionario
                      left join segu.tpersona tpe on tpe.id_persona = tf.id_persona
                      left  join orga.toficina ofi on ofi.id_oficina = tc.id_oficina
                      left  join param.tlugar lug on lug.id_lugar = ofi.id_lugar


                      inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato and ttc.codigo in ('PLA','EVE')

                      join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(tc.id_uo, NULL::integer, NULL::date)
                      join orga.tuo dep on dep.id_uo = orga.f_get_uo_departamento(tc.id_uo, NULL::integer, NULL::date)

                      where tc.estado_reg = 'activo' and tc.id_cargo = v_item.id_cargo::integer;

                      --raise 'v_record: %',v_record;

        escala                  = v_record.escala::varchar;
        cargo                   = v_record.cargo::varchar;
        nro_item                = v_record.nro_item::varchar;
        nombre_funcionario      = v_record.nombre_funcionario::varchar;
        genero                  = v_record.genero::varchar;
        haber_basico            = v_record.haber_basico::numeric;
        bono_antiguedad         = v_record.bono_antiguedad::numeric;
        bono_frontera           = v_record.bono_frontera::numeric;
        sumatoria               = v_record.sumatoria::numeric;
        fecha_inicio            = v_record.fecha_inicio::varchar;
        ci                      = v_record.ci::varchar;
        expedicion              = v_record.expedicion::varchar;
        codigo                  = v_record.codigo::varchar;
        nombre                  = v_record.nombre::varchar;
        codigo_nombre_gerencia  = v_record.codigo_nombre_gerencia::varchar;
        nombre_unidad           = v_record.nombre_unidad::varchar;
        id_tipo_contrato        = v_record.id_tipo_contrato::varchar;
        gerencia                = v_record.gerencia::varchar;
        departamento            = v_record.departamento::varchar;
        categoria_programatica  = v_record.categoria_programatica::varchar;
        fecha_finalizacion      = v_record.fecha_finalizacion::varchar;
        id_uo					= v_id_uo::integer;
		correlativo				= v_correlativo::integer;
        id_funcionario			= v_record.id_funcionario;
        return next;
        v_correlativo = v_correlativo + 1;
      end loop;

    end loop;

    return;

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