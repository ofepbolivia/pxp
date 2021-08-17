CREATE OR REPLACE FUNCTION orga.ft_envio_correos_ime (
  p_id_usuario integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Organigrama
 FUNCION: 		orga.ft_envio_correos_ime
 DESCRIPCION:   Funcion para enviar correo a todos los funcionarios
 AUTOR: 		Ismael Valdivia
 FECHA:	        03/11/2020 08:20:00
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

    v_mensaje_correo		varchar;
    v_datos_funcionario		record;
    v_correos				varchar;

BEGIN

    v_nombre_funcion = 'orga.ft_envio_correos_ime';

        		for v_datos_funcionario in (
                	/*Aqui recuperamos los datos del funcionario*/
                        select
                              car.id_funcionario,
                              car.desc_funcionario1,
                              car.email_empresa,
                              car.nombre_cargo::varchar,
                              fun.codigo_rc_iva
                        from  orga.vfuncionario_ultimo_cargo car
                        inner join orga.vfuncionario fun on fun.id_funcionario = car.id_funcionario
                        inner join param.tlugar lu on lu.id_lugar = car.id_lugar
                        where  car.estado_reg_fun = 'activo' and (car.fecha_finalizacion is null or car.fecha_finalizacion >= now())
                        and 1 = param.f_get_id_lugar_pais(car.id_lugar)
                        and (fun.codigo_rc_iva is not null and fun.codigo_rc_iva != '')
					/**********************************************/

        		)LOOP

                v_correos = v_datos_funcionario.email_empresa;

          		v_mensaje_correo = '<p>En cumplimiento a la Circular Instructiva OB.AH.CM.081.2020 de fecha 30/10/2020 emitida por el Departamento de Recursos Humanos,
                					se pone en conocimiento de cada funcionario su Código de Dependiente, mismo que es necesario para el registro en la Oficina Virtual de Impuestos,
                                    aplicativo Mis Facturas.</p><br>

                                    <table border="1" style="font-size: 12px;">
                                      <tbody>
                                        <tr>
                                          <td>Funcionario</td>
                                          <td><b>'||v_datos_funcionario.desc_funcionario1||'</b></td>
                                        </tr>
                                        <tr>
                                          <td>Código de Dependiente</td>
                                          <td style="color:red;"><b>'||v_datos_funcionario.codigo_rc_iva||'</b></td>
                                        </tr>
                                      </tbody>
                                    </table>

                                    <br><p>En caso de alguna duda o consulta, favor de comunicarse con Departamento de Recursos Humanos a los celulares corporativos <b>67407002</b> o <b>71731259</b>.</p>


                                    ';


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
                                           v_datos_funcionario.id_funcionario,
                                           'notificacion',
                                           'CODIGO DE DEPENDIENTE FORM 110 V4',
                                           null,
                                           'CODIGO DE DEPENDIENTE FORM 110 V4',
                                           v_correos,
                                           NULL,
                                           'exito',
                                           'borrador',
                                           'no',
                                           NULL,
                                           p_id_usuario
                                           );

			end loop;
			--Definicion de la respuesta
            return 'exito';



EXCEPTION
	WHEN OTHERS THEN

			--update a la tabla informix.migracion
            v_resp = 'El mensaje es '||SQLERRM||'';

            return v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;