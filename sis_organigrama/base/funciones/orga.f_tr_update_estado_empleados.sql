CREATE OR REPLACE FUNCTION orga.f_tr_update_estado_empleados (
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema Organigrama
 FUNCION: 		orga.f_tr_update_estado_empleados
 DESCRIPCION:   Funcion que actualiza el estado en la bd Ficha Personal.
 AUTOR: 		(franklin.espinoza)
 FECHA:	        28-06-2020 15:15:26
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
    v_record				record;
    v_consulta				varchar;

BEGIN
	v_nombre_funcion = 'orga.f_tr_update_estado_empleados';
	for v_record in select distinct tuo.id_funcionario,
                                    tuo.id_cargo,
                                    tuo.id_uo_funcionario,
                                    tuo.fecha_asignacion,
                                    tuo.fecha_finalizacion,
                                    tcon.codigo,
                                    tcon.nombre,
                                    vf.desc_funcionario1 as nombre_emp,
                                    tc.nombre as nombre_cargo,
                                    tuo.tipo,
                                    tof.id_oficina,
                                    tf.codigo,
                                    tf.fecha_ingreso,
                                    tuo.fecha_documento_asignacion,
                                    tuo.nro_documento_asignacion,
                                    tc.id_oficina oficina_item,
                                    tlug.codigo as oficina_codigo
                    from orga.tuo_funcionario tuo
                    inner join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
                    inner join orga.tfuncionario tf on tf.id_funcionario = tuo.id_funcionario
                    inner join orga.tcargo tc on tc.id_cargo = tuo.id_cargo
                    inner join orga.toficina tof on tof.id_oficina = tc.id_oficina
                    inner join param.tlugar tlug on tlug.id_lugar = tc.id_lugar
                    inner join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tc.id_tipo_contrato
                    where (coalesce(tuo.fecha_finalizacion::date, '31/12/9999'::date) between current_date and current_date) and
                    tuo.tipo='oficial' and tuo.id_funcionario not in (
                    select distinct tu.id_funcionario
                    from orga.tuo_funcionario tu
                    where  coalesce(tu.fecha_finalizacion::date, '31/12/9999'::date) > current_date
                    and tu.tipo = 'oficial' and tu.estado_reg = 'activo' and tu.id_funcionario is not null
                    )
                    order by tuo.id_funcionario asc loop

        v_consulta =  'exec Ende_HistorialCargo "UPD", '||v_record.id_uo_funcionario||', '||v_record.id_funcionario||', '||
                      v_record.id_cargo||', "'||coalesce(v_record.nro_documento_asignacion::varchar,'')||'", "'||v_record.fecha_asignacion||'", "'||
                      coalesce(v_record.fecha_finalizacion::varchar,'')||'", 1957, "'||coalesce(v_record.fecha_documento_asignacion::varchar,'')||'", "inactivo", '||coalesce(v_record.oficina_item,0)||', "'||v_record.oficina_codigo||'";';

		if v_consulta is not null then
        	INSERT INTO sqlserver.tmigracion
            (	id_usuario_reg,
              	consulta,
                estado,
                respuesta,
                operacion,
                cadena_db
            )
            VALUES (
              	1,
              	v_consulta,
                'pendiente',
                null,
                'UPDATE',
                '10.150.0.20,Personal,sispersonal,pl@nt@s'
            );
        else
        	raise notice 'Empleado Problema: %', v_record.nombre_emp;
        end if;

    end loop;

    return 'EXITO';

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