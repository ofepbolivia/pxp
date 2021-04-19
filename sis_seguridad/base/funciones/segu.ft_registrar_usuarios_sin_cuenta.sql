CREATE OR REPLACE FUNCTION segu.ft_registrar_usuarios_sin_cuenta (
  p_id_funcionario integer = NULL::integer,
  p_observacion text = NULL::text
)
RETURNS varchar AS
$body$
DECLARE
  v_usuario_new	record;
  v_existe_usuario	numeric;
  v_pass_usuario	varchar;
  v_fecha_finalizacion	date;
  v_existe_cuenta	numeric;
  v_cuenta_user		varchar;
  v_segundo_nombre	varchar;
  v_segundo_apellido varchar;
  v_desc_funcionario	varchar;
  v_obervacion			text;
BEGIN
/****************************************************************************
Funcion que registra cuenta de usuarios para todos los funcionarios activos
(Ismael Valdivia 15/04/2021)
*****************************************************************************/
/****************************************************************************
modificado para recivir dos parametros, para registrar de un funcionario epecifico su usuario.
(beydi vasquez 19/04/2021)
*****************************************************************************/
  if p_observacion is null then
    v_obervacion = 'Usuario Registrado Automaticamente';
  else
    v_obervacion = p_observacion;
  end if;
          /*Aqui recuperamos a todos los funcionarios sin cuenta de usuario*/
   FOR v_usuario_new in(      select
                                     regexp_split_to_array(lower(per.nombre),' ') as nombres,
                                     regexp_split_to_array(COALESCE (lower(Replace(per.apellido_paterno,' ','')),lower(per.apellido_materno)),' ') as apellido_paterno,
                                     regexp_split_to_array(lower(per.apellido_materno),' ') as apellido_materno,
                                     uc.fecha_finalizacion,
                                     fun.id_persona
                              from orga.vfuncionario fun
                              LEFT join orga.vfuncionario_ultimo_cargo uc on uc.id_funcionario = fun.id_funcionario
                              LEFT join segu.vusuario usu on usu.id_persona = fun.id_persona and usu.estado_reg = 'activo'
                              INNER JOIN segu.tpersona per on per.id_persona = fun.id_persona
                              where
                              case when p_id_funcionario is null then
                                (uc.fecha_finalizacion is null or current_date <= uc.fecha_finalizacion)
                                and usu.cuenta is NULL
                              else
                                fun.id_funcionario = p_id_funcionario
                              end
                              ORDER BY fun.id_persona
   							  --limit 200

                                      ) loop
             --raise exception 'llega aqui data %',v_usuario_new.cuenta;
            /*Aqui verificamos si la cuenta de usuario existe*/
            select count (usu.id_usuario)
            into
            v_existe_usuario
            from segu.tusuario usu
            where usu.id_persona = v_usuario_new.id_persona;
            /*************************************************/
            /*Si el usuario no existe entonces creamos la cuenta*/
            if (v_existe_usuario = 0) then

            	v_cuenta_user = v_usuario_new.nombres[1]||'.'||v_usuario_new.apellido_paterno[1];

            /*verificamos si existe la cuenta del usuario*/
                  select count(us.id_usuario)
                  into
                  v_existe_cuenta
                  from segu.tusuario us
                  where us.cuenta = v_cuenta_user;

               /*Si la cuenta de usuario no existe entonces crearemos el usuario*/
                  if (v_existe_cuenta = 0) then

                  	select md5(v_cuenta_user) into v_pass_usuario;

                  	 IF (v_usuario_new.fecha_finalizacion is null) then
                        v_fecha_finalizacion = '31/12/9999';
                    else
                        v_fecha_finalizacion = v_usuario_new.fecha_finalizacion;
                    end if;

                    INSERT  INTO segu.tusuario(
                                            id_clasificador,
                                            cuenta,
                                            contrasena,
                                            fecha_caducidad,
                                            estilo,
                                            contrasena_anterior,
                                            id_persona,
                                            autentificacion,
                                            id_usuario_reg,
                                            usuario_ai,
                                            id_usuario_ai,
                                            observaciones
                                            )
                           VALUES(
                                            null,
                                            v_cuenta_user,
                                            v_pass_usuario,
                                            v_fecha_finalizacion,
                                            'xtheme-blue.css',
                                            NULL,
                                            v_usuario_new.id_persona,
                                            'local',
                                            null,
                                            null,
                                            null,
                                            v_obervacion
                           );
                  elsif(v_existe_cuenta >= 1) then

                  	if(v_usuario_new.nombres[2] is null) then
                    	v_segundo_nombre = '';
                    else
                    	v_segundo_nombre = '.'||v_usuario_new.nombres[2];
                    end if;


                  	v_cuenta_user = v_usuario_new.nombres[1]||v_segundo_nombre||'.'||v_usuario_new.apellido_paterno[1];

                    /*verificamos si existe la cuenta del usuario*/
                          select count(us.id_usuario)
                          into
                          v_existe_cuenta
                          from segu.tusuario us
                          where us.cuenta = v_cuenta_user;

                  	if (v_existe_cuenta = 0) then
                    		select md5(v_cuenta_user) into v_pass_usuario;

                             IF (v_usuario_new.fecha_finalizacion is null) then
                                v_fecha_finalizacion = '31/12/9999';
                            else
                                v_fecha_finalizacion = v_usuario_new.fecha_finalizacion;
                            end if;

                            INSERT  INTO segu.tusuario(
                                                    id_clasificador,
                                                    cuenta,
                                                    contrasena,
                                                    fecha_caducidad,
                                                    estilo,
                                                    contrasena_anterior,
                                                    id_persona,
                                                    autentificacion,
                                                    id_usuario_reg,
                                                    usuario_ai,
                                                    id_usuario_ai,
                                                    observaciones
                                                    )
                                   VALUES(
                                                    null,
                                                    v_cuenta_user,
                                                    v_pass_usuario,
                                                    v_fecha_finalizacion,
                                                    'xtheme-blue.css',
                                                    NULL,
                                                    v_usuario_new.id_persona,
                                                    'local',
                                                    null,
                                                    null,
                                                    null,
                                                    v_obervacion
                                   );

                    ELSIF(v_existe_cuenta >= 1)then

                    	if(v_usuario_new.nombres[2] is null) then
                            v_segundo_nombre = '';
                        else
                            v_segundo_nombre = '.'||v_usuario_new.nombres[2];
                        end if;

                        if (v_usuario_new.apellido_paterno[1] != v_usuario_new.apellido_materno[1]) then
                        	v_segundo_apellido = '.'||v_usuario_new.apellido_materno[1];
                        else
                        	v_segundo_apellido = '';
                        end if;


                        v_cuenta_user = v_usuario_new.nombres[1]||v_segundo_nombre||'.'||v_usuario_new.apellido_paterno[1]||v_segundo_apellido;

                        /*verificamos si existe la cuenta del usuario*/
                              select count(us.id_usuario)
                              into
                              v_existe_cuenta
                              from segu.tusuario us
                              where us.cuenta = v_cuenta_user;


                              if (v_existe_cuenta = 0) then
                                    select md5(v_cuenta_user) into v_pass_usuario;

                                    IF (v_usuario_new.fecha_finalizacion is null) then
                                        v_fecha_finalizacion = '31/12/9999';
                                    else
                                        v_fecha_finalizacion = v_usuario_new.fecha_finalizacion;
                                    end if;

                                  INSERT  INTO segu.tusuario(
                                                          id_clasificador,
                                                          cuenta,
                                                          contrasena,
                                                          fecha_caducidad,
                                                          estilo,
                                                          contrasena_anterior,
                                                          id_persona,
                                                          autentificacion,
                                                          id_usuario_reg,
                                                          usuario_ai,
                                                          id_usuario_ai,
                                                          observaciones
                                                          )
                                         VALUES(
                                                          null,
                                                          v_cuenta_user,
                                                          v_pass_usuario,
                                                          v_fecha_finalizacion,
                                                          'xtheme-blue.css',
                                                          NULL,
                                                          v_usuario_new.id_persona,
                                                          'local',
                                                          null,
                                                          null,
                                                          null,
                                                          v_obervacion
                                         );
                              ELSE

                              	select fun.desc_funcionario1
                                into
                                v_desc_funcionario
                                from orga.vfuncionario fun
                                where fun.id_persona = v_usuario_new.id_persona
                                limit 1;

                              	raise exception 'No se pudo crear cuenta del funcionario %',v_desc_funcionario;
                              end if;


                    end if;


                  end IF;




            	/*select md5(v_usuario_new.cuenta) into v_pass_usuario;

                /*Aqui condicional para la fecha de finalizacion
                  Si el funcionario tiene fecha finalizacion null*/

                IF (v_usuario_new.fecha_fin is null) then
                	v_fecha_finalizacion = '31/12/2034';
                else
                	v_fecha_finalizacion = v_usuario_new.fecha_fin;
                end if;

                INSERT  INTO segu.tusuario(
                                            id_clasificador,
                                            cuenta,
                                            contrasena,
                                            fecha_caducidad,
                                            estilo,
                                            contrasena_anterior,
                                            id_persona,
                                            autentificacion,
                                            id_usuario_reg,
                                            usuario_ai,
                                            id_usuario_ai,
                                            observaciones
                                            )
                           VALUES(
                                            null,
                                            v_usuario_new.cuenta,
                                            v_pass_usuario,
                                            '31/12/2034',
                                            'xtheme-blue.css',
                                            NULL,
                                            v_usuario_new.id_persona,
                                            'local',
                                            null,
                                            null,
                                            null,
                                            'Usuario Registrado Automaticamente'
                           );
           */

            end if;


    end loop;
          /********************************************************************************/

	return 'Cuentas de Usuario Registradas Correctamente';


END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION segu.ft_registrar_usuarios_sin_cuenta (p_id_funcionario integer, p_observacion text)
  OWNER TO postgres;
