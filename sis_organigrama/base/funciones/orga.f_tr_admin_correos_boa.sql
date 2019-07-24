CREATE OR REPLACE FUNCTION orga.f_tr_admin_correos_boa (
)
RETURNS trigger AS
$body$
  DECLARE

    v_resp    			varchar;
    v_mensaje 			varchar;
	v_rec_contrato		record;
	v_id_alarma			integer;
	v_bandera			varchar;
    v_correo			varchar;
    v_plantilla			varchar;
    v_hora_saludo		varchar;
    v_rec_funcionario		record;
	v_procedimiento		varchar;

  BEGIN
  	/*select tcon.codigo, tcon.nombre
	into v_rec_contrato
    from orga.tcargo tc
    left join orga.ttipo_contrato tcon on tcon.id_tipo_contrato = tc.id_tipo_contrato
    where tc.id_cargo = new.id_cargo;

    --if(TG_OP = 'INSERT' or TG_OP = 'UPDATE')then
    	if v_rec_contrato.codigo in ('PLA', 'EVE', 'CONS', 'PEXTE', 'PEXT') then

          select tf.desc_funcionario1
          into v_rec_funcionario
          from orga.vfuncionario tf
          where tf.id_funcionario = new.id_funcionario;

          --if v_rec_funcionario.email_empresa = '' or v_rec_funcionario.email_empresa is null  then

            v_hora_saludo = case when current_time between '08:00:00'::time and '12:00:00'::time then '<b>Buenos dias' ::varchar
                                 when current_time between '12:00:00'::time and '19:00:00'::time then '<b>Buenas tardes'::varchar end;

            v_plantilla = v_hora_saludo||' estimado Administrador:</b><br>
              <p>El motivo del presente es solicitar cuenta de correo para el funcionario <b>'||coalesce(v_rec_funcionario.desc_funcionario1, 'Comunicarse con Franklin Espinoza')||'</b>.<br>
              <b>Tipo de Contrato:</b> '||coalesce(v_rec_contrato.nombre,'Por Definirse')||'<br>
              <b>Fecha Asignación:</b> '||coalesce(to_char(new.fecha_asignacion, 'dd/mm/yyyy'),'')||'<br>
              <b>Fecha Finalización:</b> '||coalesce(to_char(new.fecha_finalizacion, 'dd/mm/yyyy'),'')||'
              </p>';

            v_id_alarma :=  param.f_inserta_alarma(
                                                null,
                                                v_plantilla,
                                                '../../../sis_organigrama/vista/reporte/CorreosEmpBoa.php',
                                                now()::date,
                                                'notificacion',
                                                'Ninguna',
                                                1,
                                                'CorreosEmpBoa',
                                                v_rec_funcionario.desc_funcionario1,--titulo
                                                '{filtro_directo:{campo:"id_funcionario",valor:"'||new.id_funcionario::varchar||'"}}',
                                                NULL::integer,
                                                'Solicitud Creacion Cuenta de Correo ',
                                                'correos@boa.bo,(franklin.espinoza@boa.bo)',
                                                null,
                                                null
                                                );
          --end if;
    	end if;
	--end if;*/
    v_procedimiento = orga.f_tr_registra_movimiento_asignacion();
    --raise exception 'v_procedimiento:%',v_procedimiento;
	RETURN NULL;

  END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;