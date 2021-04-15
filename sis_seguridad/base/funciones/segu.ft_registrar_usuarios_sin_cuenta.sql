CREATE OR REPLACE FUNCTION segu.ft_registrar_usuarios_sin_cuenta (
)
RETURNS varchar AS
$body$
DECLARE
  v_usuario_new	record;
  v_existe_usuario	numeric;
  v_pass_usuario	varchar;
  v_fecha_finalizacion	varchar;
BEGIN
/****************************************************************************
Funcion que registra cuenta de usuarios para todos los funcionarios activos
(Ismael Valdivia 15/04/2021)
*****************************************************************************/

          /*Aqui recuperamos a todos los funcionarios sin cuenta de usuario*/
   FOR v_usuario_new in(       select  (nombres[1]||'.'||apellidos[1]) as cuenta,
                                        fecha_fin,
                                        id_persona
                              from (  select
                                             regexp_split_to_array(lower(per.nombre),' ') as nombres,
                                             regexp_split_to_array(COALESCE (lower(Replace(per.apellido_paterno,' ','')),lower(per.apellido_materno)),' ') as apellidos,
                                             uc.fecha_finalizacion,
                                             fun.id_persona
                                      from orga.vfuncionario fun
                                      inner join orga.vfuncionario_ultimo_cargo uc on uc.id_funcionario = fun.id_funcionario
                                      LEFT join segu.vusuario usu on usu.id_persona = fun.id_persona and usu.estado_reg = 'activo'
                                      INNER JOIN segu.tpersona per on per.id_persona = fun.id_persona
                                      where (uc.fecha_finalizacion is null or current_date <= uc.fecha_finalizacion)
                                      and usu.cuenta is NULL
                                      ORDER BY fun.id_persona
                                      --limit 1

                                      ) as usuarios(nombres,apellidos,fecha_fin,id_persona)) loop
             --raise exception 'llega aqui data %',v_usuario_new.cuenta;
            /*Aqui verificamos si la cuenta de usuario existe*/
            select count (usu.id_usuario)
            into
            v_existe_usuario
            from segu.tusuario usu
            where usu.cuenta = v_usuario_new.cuenta;
            /*************************************************/
            /*Si el usuario no existe entonces creamos la cuenta*/
            if (v_existe_usuario = 0) then

            	select md5(v_usuario_new.cuenta) into v_pass_usuario;

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
            /*Si la cuenta de usuario ya existe entonces tomamos los dos nombres*/
            elsif (v_existe_usuario > 0) then

               FOR v_usuario_new in(   select   (nombres[1]||
                                                (case when  nombres[2] is not null then
                                                 '.'||nombres[2]
                                                else
                                                  ''
                                                end)||'.'||apellidos[1]) as cuenta,
                                                fecha_fin,
                                                id_persona
                                        from (  select
                                                     regexp_split_to_array(lower(per.nombre),' ') as nombres,
                                                     regexp_split_to_array(COALESCE (lower(Replace(per.apellido_paterno,' ','')),lower(per.apellido_materno)),' ') as apellidos,
                                                     uc.fecha_finalizacion,
                                                     fun.id_persona
                                              from orga.vfuncionario fun
                                              inner join orga.vfuncionario_ultimo_cargo uc on uc.id_funcionario = fun.id_funcionario
                                              LEFT join segu.vusuario usu on usu.id_persona = fun.id_persona and usu.estado_reg = 'activo'
                                              INNER JOIN segu.tpersona per on per.id_persona = fun.id_persona
                                              where (uc.fecha_finalizacion is null or current_date <= uc.fecha_finalizacion)
                                              and usu.cuenta is NULL
                                              ORDER BY fun.id_persona
                                              --limit 1
                                              ) as usuarios(nombres,apellidos,fecha_fin,id_persona) ) LOOP

                  /*Aqui verificamos si existe la cuenta con los dos nombres*/
                  select count (usu.id_usuario)
                  into
                  v_existe_usuario
                  from segu.tusuario usu
                  where usu.cuenta = v_usuario_new.cuenta;

                    if (v_existe_usuario = 0) then

                    select md5(v_usuario_new.cuenta) into v_pass_usuario;

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

                    elsif (v_existe_usuario > 0) then

                    /*Si la cuenta existe entonces tomamos los dos nombres y los dos apellidos*/

                    FOR v_usuario_new in(
                                      select   (nombres[1]||
                                              (case when  nombres[2] is not null then
                                               '.'||nombres[2]
                                              else
                                                ''
                                              end)||'.'||apellidos[1]||

                                              (case when  apellidos[1] != apellido_materno[1] then
                                               '.'||apellido_materno[1]
                                              else
                                                ''
                                              end)

                                              ) as cuenta,
                                              fecha_fin,
                                              id_persona
                                      from (  select
                                                   regexp_split_to_array(lower(per.nombre),' ') as nombres,
                                                   regexp_split_to_array(COALESCE ((Replace(lower(per.apellido_paterno),' ','')),lower(per.apellido_materno)),' ') as apellidos,
                                                   uc.fecha_finalizacion,
                                                   fun.id_persona,
                                                   regexp_split_to_array(Replace(lower(per.apellido_materno),' ',''),' ') as apellido_materno
                                            from orga.vfuncionario fun
                                            inner join orga.vfuncionario_ultimo_cargo uc on uc.id_funcionario = fun.id_funcionario
                                            LEFT join segu.vusuario usu on usu.id_persona = fun.id_persona and usu.estado_reg = 'activo'
                                            INNER JOIN segu.tpersona per on per.id_persona = fun.id_persona
                                            where (uc.fecha_finalizacion is null or current_date <= uc.fecha_finalizacion)
                                            and usu.cuenta is NULL
                                            ORDER BY fun.id_persona
                                            --limit 1
                                            ) as usuarios(nombres,apellidos,fecha_fin,id_persona,apellido_materno)
                      ) LOOP

                      /*Aqui verificamos si existe la cuenta con los dos nombres*/
                      select count (usu.id_usuario)
                      into
                      v_existe_usuario
                      from segu.tusuario usu
                      where usu.cuenta = v_usuario_new.cuenta;

                      if (v_existe_usuario = 0) then

                      select md5(v_usuario_new.cuenta) into v_pass_usuario;

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
                          else
                          Raise exception 'Ya se tiene registrada la cuenta %, con las diferentes combinaciones',v_usuario_new.cuenta;
                           end if;
                      END LOOP;


                    end if;
                  /**********************************************************/

            	  END LOOP;


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

ALTER FUNCTION segu.ft_registrar_usuarios_sin_cuenta ()
  OWNER TO postgres;
