CREATE OR REPLACE FUNCTION orga.f_disparar_alarma_teletrabajo (
  p_id_limite_teletrabajo integer
)
RETURNS varchar AS
$body$
DECLARE

	v_recuperados record;
    v_correos     varchar;
    v_mensaje_semi	varchar;
    v_mensaje_motivo varchar;
    v_mensaje_equipo	varchar;
	v_mensaje_correo	varchar;
    v_responsable	integer;
    v_datos_responsable record;
BEGIN

 for v_recuperados in (

	select car.id_uo,
    	   form.id_funcionario,
           car.email_empresa,
           car.desc_funcionario1,
           car.nombre_cargo,
           form.cambio_modalidad,
           form.dias_asistencia_fisica,
           form.motivo_solicitud,
           form.desc_motivo_solicitud,
           form.equipo_computacion,
           form.tipo_de_uso,
           form.cuenta_con_internet,
           COALESCE (
           (select uo.nombre_unidad::varchar
                              from orga.tuo uo
                              where uo.id_uo = orga.f_get_uo_gerencia(car.id_uo,car.id_funcionario,now()::date)),'SIN GERENCIA')::varchar as gerencia
    from orga.tformulario_teletrabajo form
    inner join orga.vfuncionario_ultimo_cargo car on car.id_funcionario = form.id_funcionario
    where form.id_teletrabajo <= p_id_limite_teletrabajo )

    LOOP
              select est.id_uo_padre into v_responsable
              from orga.testructura_uo est
              where est.id_uo_hijo = v_recuperados.id_uo::integer;


              select
                             car.nombre_cargo::varchar,
                             car.email_empresa
                             into
                             v_datos_responsable
        			  from  orga.vfuncionario_ultimo_cargo car
                      where car.id_uo = v_responsable and car.estado_reg_fun = 'activo' and (car.fecha_finalizacion is null or car.fecha_finalizacion >= now());

               IF (v_datos_responsable.email_empresa is null) then
                     select est.id_uo_padre into v_responsable
                    from orga.testructura_uo est
                    where est.id_uo_hijo = v_responsable::integer;

                    select
                             car.nombre_cargo::varchar,
                             car.email_empresa
                             into
                             v_datos_responsable
        			  from  orga.vfuncionario_ultimo_cargo car
                      where car.id_uo = v_responsable and car.estado_reg_fun = 'activo' and (car.fecha_finalizacion is null or car.fecha_finalizacion >= now());
               end if;


               v_correos = v_datos_responsable.email_empresa||';'||v_recuperados.email_empresa||';';
               --v_correos = v_datos.email_empresa||';';

               if (v_recuperados.cambio_modalidad = 'Semi-Presencial') then
               		v_mensaje_semi = '<p><b>DÍAS DE ASISTENCIA FÍSICA:</b> '||v_recuperados.dias_asistencia_fisica||'.</p>';
               else
               		v_mensaje_semi = '';
               end if;

               if (v_recuperados.motivo_solicitud = 'Enfermedad de base crónica' or v_recuperados.motivo_solicitud = 'Otro') then
               		v_mensaje_motivo = '<p><b>DESCRIPCIÓN DE LA SOLICITUD:</b> '||v_recuperados.desc_motivo_solicitud||'.</p>';
               else
               		v_mensaje_motivo = '';
               end if;

                if (v_recuperados.equipo_computacion = 'Si') then
               		v_mensaje_equipo = '<p><b>USO DEL EQUIPO DE COMPUTACIÓN:</b> '||v_recuperados.tipo_de_uso||'</p>';
               else
               		v_mensaje_equipo = '';
               end if;


               v_mensaje_correo = '         <p>EL funcionario <b>'||v_recuperados.desc_funcionario1||'</b> registró la solicitud de cambio de modalidad de trabajo con la siguiente información:</p><br><br>
                                             <p><b>CARGO:</b> '||v_recuperados.nombre_cargo||'.</p>
                                             <p><b>MODALIDAD:</b> '||v_recuperados.cambio_modalidad||'.</p>
                                             '||v_mensaje_semi||'
                                             <p><b>MOTIVO DE LA SOLICITUD:</b> '||v_recuperados.motivo_solicitud||'.</p>
                                             '||v_mensaje_motivo||'
                                             <p><b>CUENTA CON EQUIPO DE COMPUTADORA:</b> '||v_recuperados.equipo_computacion||'.</p>
                                             '||v_mensaje_equipo||'
                                             <p><b>CUENTA CON INTERNET:</b> '||v_recuperados.cuenta_con_internet||'.</p>
                                             <p><b>GERENCIA:</b> '||v_recuperados.gerencia||'.</p>';

    		    INSERT INTO param.talarma (descripcion,
                 							acceso_directo,
                                            fecha,
                                            id_funcionario,
                                            tipo,
                                            titulo,
                                            id_usuario,
                                            titulo_correo,
                                            correos,
                                            documentos,
                                            estado_envio,
                                            estado_comunicado,
                                            pendiente,
                                            estado_notificacion,
                                            id_usuario_reg
                                            )
                							values
                						   (v_mensaje_correo,
                                           NULL,
                                           now()::date,
                                           v_recuperados.id_funcionario,
                                           'notificacion',
                                           'Solicitud para cambio de modalidad de trabajo',
                                           1070,
                                           'Solicitud para cambio de modalidad de trabajo',
                                           v_correos,
                                           NULL,
                                           'exito',
                                           'borrador',
                                           'no',
                                           NULL,
                                           1070
                                           );


    end loop;


    return 'Envio de Correos correctamente';

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;