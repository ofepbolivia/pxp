CREATE OR REPLACE FUNCTION orga.ft_teletrabajo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Organigrama
 FUNCION: 		orga.ft_teletrabajo_ime
 DESCRIPCION:   Funcion para ir registrando los funcionarios en teletrabajo
 AUTOR: 		Ismael Valdivia
 FECHA:	        26/05/2020 23:30:00
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE


	v_parametros           	record;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_id_teletrabajo		integer;

    v_existencia			integer;
	v_mensaje				varchar;
    v_datos					record;
    v_mensaje_correo		varchar;
    v_mensaje_semi			varchar;
    v_mensaje_motivo		varchar;
    v_mensaje_equipo		varchar;
    v_correos				varchar;
    v_responsable			integer;
    v_datos_responsable		record;

BEGIN

    v_nombre_funcion = 'orga.ft_teletrabajo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ORGA_INS_TELTRA_IME'
 	#DESCRIPCION:	Insercion de registros
    #AUTOR: 		Ismael Valdivia
    #FECHA:	        26/05/2020
	***********************************/

	if(p_transaccion='ORGA_INS_TELTRA_IME')then

		begin

        	/*Aqui ponemos el control para verrificar si ya se registro el funcionario*/
            select count(tele.ci) into v_existencia
            from orga.tformulario_teletrabajo tele
            where tele.ci = v_parametros.ci;
          /**************************************************************************/

          if (v_existencia > 0) then
              v_mensaje = 'El funcionario ya se encuentra registrado';
          else
              v_mensaje = 'Registro exitoso!!, Para su presentación a R.R.H.H., descargue su formulario en formato PDF';

              insert into orga.tformulario_teletrabajo( id_funcionario,
                                                      ci,
                                                      equipo_computacion,
                                                      tipo_de_uso,
                                                      cuenta_con_internet,
                                                      zona_domicilio,
                                                      transporte_particular,
                                                      tipo_transporte,
                                                      placa,
                                                      id_usuario_reg,
                                                      cambio_modalidad,
                                                      dias_asistencia_fisica,
                                                      motivo_solicitud,
                                                      desc_motivo_solicitud,
                                                      aplica_teletrabajo
                                                      )VALUES(
                                                      v_parametros.id_funcionario,
                                                      v_parametros.ci,
                                                      v_parametros.equipo_computacion,
                                                      v_parametros.tipo_de_uso,
                                                      v_parametros.cuenta_con_internet,
                                                      v_parametros.zona_domicilio,
                                                      v_parametros.transporte_particular,
                                                      v_parametros.tipo_transporte,
                                                      v_parametros.placa,
                                                      p_id_usuario,
                                                      v_parametros.cambio_modalidad,
                                                      v_parametros.dias_asistencia_fisica,
                                                      v_parametros.motivo_solicitud,
                                                      v_parametros.desc_motivo_solicitud,
                                                      v_parametros.aplica_teletrabajo )RETURNING id_teletrabajo into v_id_teletrabajo;





          	select
                             car.nombre_cargo::varchar,
                             car.desc_funcionario1,
                             car.email_empresa,
                             car.id_uo,
                             COALESCE (
                             (select uo.nombre_unidad::varchar
                              from orga.tuo uo
                              where uo.id_uo = orga.f_get_uo_gerencia(car.id_uo,car.id_funcionario,now()::date)),'SIN GERENCIA')::varchar as gerencia
                             into
                             v_datos
        			  from  orga.vfuncionario_ultimo_cargo car
                      where car.id_funcionario = v_parametros.id_funcionario;


              select est.id_uo_padre into v_responsable
              from orga.testructura_uo est
              where est.id_uo_hijo = v_datos.id_uo::integer;


              select
                             car.nombre_cargo::varchar,
                             car.email_empresa
                             into
                             v_datos_responsable
        			  from  orga.vfuncionario_ultimo_cargo car
                      where car.id_uo = v_responsable;


               v_correos = v_datos_responsable.email_empresa||';'||v_datos.email_empresa||';';

               if (v_parametros.cambio_modalidad = 'Semi-Presencial') then
               		v_mensaje_semi = '<p><b>DÍAS DE ASISTENCIA FÍSICA:</b> '||v_parametros.dias_asistencia_fisica||'</p><br>';
               else
               		v_mensaje_semi = '';
               end if;

               if (v_parametros.motivo_solicitud = 'Enfermedad de base crónica' or v_parametros.motivo_solicitud = 'Otro') then
               		v_mensaje_motivo = '<p><b>DESCRIPCIÓN DE LA SOLICITUD:</b> '||v_parametros.desc_motivo_solicitud||'</p><br>';
               else
               		v_mensaje_motivo = '';
               end if;

                if (v_parametros.equipo_computacion = 'Si') then
               		v_mensaje_equipo = '<p><b>USO DEL EQUIPO DE COMPUTACIÓN:</b> '||v_parametros.tipo_de_uso||'</p><br>';
               else
               		v_mensaje_equipo = '';
               end if;


          		v_mensaje_correo = '         <p>EL funcionario <b>'||v_datos.desc_funcionario1||'</b> registró la solicitud de cambio de modalidad de trabajo con la siguiente información:</p><br><br>
                                             <p><b>CARGO:</b> '||v_datos.nombre_cargo||'</p><br>
                                             <p><b>MODALIDAD:</b> '||v_parametros.cambio_modalidad||'</p><br>
                                             '||v_mensaje_semi||'
                                             <p><b>MOTIVO DE LA SOLICITUD:</b> '||v_parametros.motivo_solicitud||'</p><br>
                                             '||v_mensaje_motivo||'
                                             <p><b>CUENTA CON EQUIPO DE COMPUTADORA:</b> '||v_parametros.equipo_computacion||'</p><br>
                                             '||v_mensaje_equipo||'
                                             <p><b>CUENTA CON INTERNET:</b> '||v_parametros.cuenta_con_internet||'</p><br>
                                             <p><b>GERENCIA:</b> '||v_datos.gerencia||'</p><br>';


			/*Aqui insertamos en la alarma para que nos salga la notificacion*/
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
                                           v_parametros.id_funcionario,
                                           'notificacion',
                                           'Solicitud para cambio de modalidad de trabajo',
                                           p_id_usuario,
                                           'Solicitud para cambio de modalidad de trabajo',
                                           v_correos,
                                           NULL,
                                           'exito',
                                           'borrador',
                                           'no',
                                           NULL,
                                           p_id_usuario
                                           );

			 end if;
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'Mensaje','Exito');
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_mensaje::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_teletrabajo',v_id_teletrabajo::varchar);


            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'ORGA_EVAL_TELE_IME'
 	#DESCRIPCION:	Registro de la evaluacion
    #AUTOR: 		Ismael Valdivia
    #FECHA:	        26/05/2020
	***********************************/

	elsif(p_transaccion='ORGA_EVAL_TELE_IME')then

		begin

        	update orga.tformulario_teletrabajo set
            estado_solicitud = v_parametros.estado_solicitud,
            observaciones = v_parametros.observaciones
            where id_teletrabajo = v_parametros.id_teletrabajo;


			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'Mensaje','Exito');
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_mensaje::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_teletrabajo',v_id_teletrabajo::varchar);


            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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

ALTER FUNCTION orga.ft_teletrabajo_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;
