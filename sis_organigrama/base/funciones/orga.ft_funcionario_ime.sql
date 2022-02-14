CREATE OR REPLACE FUNCTION orga.ft_funcionario_ime (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla varchar,
  par_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 FUNCION: 		orga.ft_funcionario_ime
 DESCRIPCIÓN:   modificaciones de funciones
 AUTOR: 	    KPLIAN (mzm)
 FECHA:
 COMENTARIOS:
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:		KPLIAN (rac)
 FECHA:		21-01-2011
 ***************************************************************************/
DECLARE


v_parametros                record;
v_resp                      varchar;
v_nombre_funcion            text;
v_mensaje_error             text;

v_id_funcion  				integer;
v_ids						varchar[];
v_tamano					integer;
v_i 						integer;
v_id_funcionario			integer;
v_email_empresa             varchar;
v_registros					record;
v_asunto					varchar;
v_destinatorio				varchar;
v_template					varchar;
v_id_alarma					integer[];
v_titulo					varchar;
v_clase						varchar;
v_parametros_ad				varchar;
v_acceso_directo			varchar;
v_id_biometrico       integer;

v_persona					record;
v_codigo_empleado 			varchar;
v_id_persona				integer;
--variables para replicacion SQL (F.E.A)
v_cadena_db					varchar;
v_consulta					varchar;
v_id_usuario 				integer;
v_resultado					varchar;

v_gerente					record;
v_cuenta					varchar;
v_existe_usuario			integer;
v_funcionario               record;

BEGIN
	--raise exception 'COMUNIQUESE CON EL DEPTO. INFORMATICO';
     v_nombre_funcion:='orga.ft_funcionario_ime';
     v_parametros:=pxp.f_get_record(par_tabla);


 /*******************************
 #TRANSACCION:   RH_FUNCIO_INS
 #DESCRIPCION:	Inserta Funcionarios
 #AUTOR:
 #FECHA:		25-01-2011
***********************************/
     if(par_transaccion='RH_FUNCIO_INS')then


          BEGIN --RAISE EXCEPTION 'COMUNIQUESE CON EL DEPTO. INFORMATICO %', v_parametros.id_persona;
			  v_id_persona = v_parametros.id_persona;
              if(v_parametros.id_persona is null)then
                --CI
                if exists(select 1 from segu.tpersona
                      where ci = v_parametros.ci) then
                  raise exception 'Este número de Carnet de Identidad ya fue registrado';
                end if;
                --Nombre completo
                if exists(select 1 from segu.tpersona
                      where upper(nombre) = upper(v_parametros.nombre)
                      and upper(apellido_paterno) = upper(v_parametros.ap_paterno)
                      and upper(apellido_materno) = upper(v_parametros.ap_materno)) then
                  raise exception 'Persona ya registrada';
                end if;


               	insert into segu.tpersona (
                               nombre,
                               apellido_paterno,
                               apellido_materno,
                               fecha_nacimiento,
                               genero,
                               nacionalidad,
                               id_lugar,
                               --tipo_documento,
                               ci,
                               expedicion,
                               estado_civil,
                               discapacitado,
                               carnet_discapacitado,
                               correo,
                               celular1,
               				   telefono1,
                               telefono2,
                               celular2,
                               direccion,
                               id_tipo_doc_identificacion
                              )
               	values(
                      upper(v_parametros.nombre),
                      upper(v_parametros.ap_paterno),
                      upper(v_parametros.ap_materno),
                      v_parametros.fecha_nacimiento,
                      v_parametros.genero,
                      v_parametros.nacionalidad,
                      v_parametros.id_lugar,
                      --v_parametros.tipo_documento,
                      v_parametros.ci,
                      v_parametros.expedicion,
                      v_parametros.estado_civil,
                      v_parametros.discapacitado,
                      case when v_parametros.discapacitado = 'no' then null else v_parametros.carnet_discapacitado end,
                      v_parametros.correo,
                      v_parametros.celular1,
                      v_parametros.telefono1,
                      v_parametros.telefono2,
                      v_parametros.celular2,
                      v_parametros.direccion,
                      v_parametros.id_tipo_doc_identificacion
                      ) RETURNING id_persona INTO v_id_persona;
               end if;


               if exists(select 1 from orga.tfuncionario where id_persona=v_id_persona and estado_reg='activo') then
                  raise exception 'Insercion no realizada. Esta persona ya está registrada como funcionario';
               end if;
--raise 'valores: %, %, %',v_parametros.id_persona is not null, v_parametros.id_persona, v_id_persona;
			   -- Update datos civiles Persona si es Natural.
               if(v_parametros.id_persona is not null)then

                 select tp.*
                 into v_persona
                 from segu.tpersona tp
                 where tp.id_persona = v_id_persona;

                 if ( v_persona.nombre != upper(v_parametros.nombre) or v_persona.apellido_paterno != upper(v_parametros.ap_paterno) or
                    v_persona.apellido_materno != upper(v_parametros.ap_materno) or v_persona.fecha_nacimiento != v_parametros.fecha_nacimiento or
                    v_persona.genero != v_parametros.genero or v_persona.nacionalidad != v_parametros.nacionalidad or v_persona.ci != v_parametros.ci or
                    v_persona.expedicion != v_parametros.expedicion or v_persona.estado_civil != v_parametros.estado_civil or
                    v_persona.discapacitado != v_parametros.discapacitado or v_persona.carnet_discapacitado != v_parametros.carnet_discapacitado or
                    v_persona.correo != v_parametros.correo or v_persona.celular1 != v_parametros.celular1 or v_persona.telefono1 != v_parametros.telefono1 or
                    v_persona.telefono2 != v_parametros.telefono2 or v_persona.celular2 != v_parametros.celular2 or v_persona.direccion != v_parametros.direccion or
                    v_persona.id_tipo_doc_identificacion != v_parametros.id_tipo_doc_identificacion ) then

                    --RAISE EXCEPTION 'ENTRA %', v_parametros.id_persona;
                     update segu.tpersona set
                              nombre = upper(v_parametros.nombre),
                              apellido_paterno = upper(v_parametros.ap_paterno),
                              apellido_materno = upper(v_parametros.ap_materno),
                              fecha_nacimiento = v_parametros.fecha_nacimiento,
                              genero = v_parametros.genero,
                              nacionalidad = v_parametros.nacionalidad,
                              --id_lugar = v_parametros.id_lugar,
                              --tipo_documento = v_parametros.tipo_documento,
                              ci = v_parametros.ci,
                              expedicion = v_parametros.expedicion,
                              estado_civil = v_parametros.estado_civil,
                              discapacitado = v_parametros.discapacitado,
                              carnet_discapacitado = v_parametros.carnet_discapacitado,
                              correo = v_parametros.correo,
                              celular1 = v_parametros.celular1,
                              telefono1 = v_parametros.telefono1,
                              telefono2 = v_parametros.telefono2,
                              celular2 = v_parametros.celular2,
                              direccion = v_parametros.direccion,
                              id_tipo_doc_identificacion = v_parametros.id_tipo_doc_identificacion
                     where id_persona = v_parametros.id_persona;
                 end if;
                 --RAISE EXCEPTION ' NO ENTRA %', v_parametros.id_persona;
              end if;

			  select tp.apellido_materno, tp.apellido_paterno, tp.nombre
                 into v_persona
                 from segu.tpersona tp
                 where tp.id_persona = v_id_persona;
                 --Generamos codigo que es utilizado para seguro de un empleado
                 if (v_parametros.genero = 'masculino') then
                    v_codigo_empleado = to_char(v_parametros.fecha_nacimiento,'YY-MMDD-') ||
                                (case when v_persona.apellido_paterno is null or trim(both ' ' from v_persona.apellido_paterno) = '' then
                                            substr(v_persona.apellido_materno, 1 , 2)
                                       when v_persona.apellido_materno is null or trim(both ' ' from v_persona.apellido_materno) = '' then
                                            substr(v_persona.apellido_paterno, 1 , 2)
                                       else
                                            substr(v_persona.apellido_paterno, 1 , 1) || substr(v_persona.apellido_materno, 1 , 1)
                                      end) ||
                                substr(v_persona.nombre, 1 , 1);
                  else
                      v_codigo_empleado = to_char(v_parametros.fecha_nacimiento,'YY-') ||
                                  ((to_char(v_parametros.fecha_nacimiento,'MM')::integer) + 50 ) :: varchar || to_char(v_parametros.fecha_nacimiento,'DD-') ||
                                  (case when v_persona.apellido_paterno is null or trim(both ' ' from v_persona.apellido_paterno) = '' then
                                              substr(v_persona.apellido_materno, 1 , 2)
                                         when v_persona.apellido_materno is null or trim(both ' ' from v_persona.apellido_materno) = '' then
                                              substr(v_persona.apellido_paterno, 1 , 2)
                                         else
                                              substr(v_persona.apellido_paterno, 1 , 1) || substr(v_persona.apellido_materno, 1 , 1)
                                        end) ||
                                        substr(v_persona.nombre, 1 , 1);
                  end if;
               --insercion de nuevo FUNCIONARIO
               if exists (select 1 from orga.tfuncionario where codigo = v_codigo_empleado and estado_reg='activo') then
                  raise exception 'Insercion no realizada. CODIGO EN USO';
               end if;
--RAISE EXCEPTION ' v_codigo_empleado %', v_codigo_empleado;
               --Obtener el correlativo biometrico.
               SELECT nextval('orga.tfuncionario_id_biometrico_seq') INTO v_id_biometrico;
               --raise exception 'v_id_biometrico: %, %, %', v_id_biometrico,v_codigo_empleado, v_parametros.id_persona;
               INSERT INTO orga.tfuncionario(
		               codigo,
                       id_persona,
		               estado_reg,
		               fecha_reg,
		               id_usuario_reg,
                       fecha_ingreso,
		               --email_empresa,
		               --interno,
		               --telefono_ofi,
		               antiguedad_anterior,
					   id_biometrico,
                       es_tutor,
                       codigo_rc_iva,id_especialidad_nivel)
               values(
                      v_codigo_empleado,
                        coalesce(v_parametros.id_persona,v_id_persona),
                        'activo',
                        now(),
                        par_id_usuario,
                         v_parametros.fecha_ingreso,
                        --v_parametros.email_empresa,
                        --v_parametros.interno,
                        --v_parametros.telefono_ofi,
                        v_parametros.antiguedad_anterior,
                        v_id_biometrico,
                        v_parametros.es_tutor,
                        v_parametros.codigo_rc_iva, v_parametros.id_especialidad_nivel)
               RETURNING id_funcionario into v_id_funcionario;

               --breydi.vasquez 19/04/2021 verificacion de exisencia de usuario
               select count (id_usuario)
               into
               v_existe_usuario
               from segu.tusuario
               where id_persona = coalesce(v_parametros.id_persona,v_id_persona);

               if v_existe_usuario = 0 then
               -- breydi.vasquez 19/04/2021 registro de usuario, al dar de alta un funcionario.
                 v_cuenta =  segu.ft_registrar_usuarios_sin_cuenta(v_id_funcionario, 'Usuario registrado al dar de alta a funcionario.');
                 if v_cuenta != 'Cuentas de Usuario Registradas Correctamente' then
                      raise 'Aviso! %',v_cuenta;
                 end if;
               end if;
               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','funcionario '||v_codigo_empleado ||' insertado con exito ');
               v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_id_funcionario::varchar);
               v_resp = pxp.f_agrega_clave(v_resp,'acciones',v_cuenta::varchar);
         END;
 /*******************************
 #TRANSACCION:      RH_FUNCIO_MOD
 #DESCRIPCION:	Modifica la parametrizacion seleccionada
 #AUTOR:
 #FECHA:		25-01-2011
***********************************/
     elsif(par_transaccion='RH_FUNCIO_MOD')then
     	BEGIN --RAISE EXCEPTION 'UPDATE:  %, %', v_parametros, pxp.f_existe_parametro(par_tabla, 'estado_correo');
          	if pxp.f_existe_parametro(par_tabla, 'estado_correo') then
            	update orga.tfuncionario set
                	email_empresa=v_parametros.email_empresa
                where id_funcionario=v_parametros.id_funcionario;

                v_cadena_db = pxp.f_get_variable_global('cadena_db_sql_2');

                --if (v_parametros.email_empresa is not null or v_parametros.email_empresa !='')then

                v_consulta =  'exec Ende_Correo '''||v_parametros.email_empresa||''', '||v_parametros.id_funcionario||';';

                INSERT INTO sqlserver.tmigracion
                (	id_usuario_reg,
                    consulta,
                    estado,
                    respuesta,
                    operacion,
                    cadena_db
                )
                VALUES (
                    par_id_usuario,
                    v_consulta,
                    'pendiente',
                    null,
                    'UPDATE',
                    v_cadena_db
                );
                --end if;
            else
                /*if exists (select 1 from orga.tfuncionario
                			where id_funcionario!=v_parametros.id_funcionario
                			and codigo=v_parametros.codigo
                			and estado_reg='activo') then
                  raise exception 'Modificacion no realizada. CODIGO EN USO';
                end if;

                if exists(select 1 from orga.tfuncionario
                			where id_funcionario!=v_parametros.id_funcionario
                			and id_persona=v_parametros.id_persona and estado_reg='activo') then
                  raise exception 'Insercion no realizada. Esta persona ya está registrada como funcionario';
               end if;*/

                update segu.tpersona set
                    nombre = upper(v_parametros.nombre),
                    apellido_paterno = upper(v_parametros.ap_paterno),
                    apellido_materno = upper(v_parametros.ap_materno),
                    fecha_nacimiento = v_parametros.fecha_nacimiento,
                    genero = v_parametros.genero,
                    nacionalidad = v_parametros.nacionalidad,
                    id_lugar = v_parametros.id_lugar,
                    --tipo_documento = v_parametros.tipo_documento,
                    ci = v_parametros.ci,
                    expedicion = v_parametros.expedicion,
                    estado_civil = v_parametros.estado_civil,
                    discapacitado = v_parametros.discapacitado,
                    carnet_discapacitado = v_parametros.carnet_discapacitado,
                    correo = v_parametros.correo,
                    celular1 = v_parametros.celular1,
                    telefono1 = v_parametros.telefono1,
                    telefono2 = v_parametros.telefono2,
                    celular2 = v_parametros.celular2,
                    direccion = v_parametros.direccion,
                    id_tipo_doc_identificacion = v_parametros.id_tipo_doc_identificacion
               where id_persona = v_parametros.id_persona;

                update orga.tfuncionario set
                	codigo=v_parametros.codigo,
                    id_usuario_mod=par_id_usuario,
                    --id_persona=v_parametros.id_persona,
                    estado_reg=v_parametros.estado_reg,
                    email_empresa=v_parametros.email_empresa,
                    --interno=v_parametros.interno,
                    fecha_mod=now()::date,
                    --telefono_ofi= v_parametros.telefono_ofi,
                    antiguedad_anterior =  v_parametros.antiguedad_anterior,
                    es_tutor = v_parametros.es_tutor,
                    codigo_rc_iva = v_parametros.codigo_rc_iva,
                    id_especialidad_nivel = v_parametros.id_especialidad_nivel
                where id_funcionario=v_parametros.id_funcionario;
			end if;

      -- breydi.vasquez 19/04/2021 inactivar usuarios de funcionario,  si se inacitva al funcionario
      if pxp.f_existe_parametro(par_tabla, 'estado_reg') then
        if v_parametros.estado_reg = 'inactivo' then

           update segu.tusuario set
              fecha_caducidad=now()::date,
              id_usuario_mod=par_id_usuario,
              fecha_mod=now(),
              id_usuario_ai=v_parametros._id_usuario_ai,
              usuario_ai=v_parametros._nombre_usuario_ai
           where id_usuario in (select u.id_usuario
                                from orga.tfuncionario f
                                inner join segu.tusuario u on u.id_persona = f.id_persona and u.estado_reg = 'activo'
                                where f.id_funcionario = v_parametros.id_funcionario
                                );

        end if;
      end if;

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario modificado con exito '||v_parametros.id_funcionario);
               v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);
        END;
/*******************************
 #TRANSACCION:  RH_FUNCIO_ELI
 #DESCRIPCION:	Inactiva la parametrizacion selecionada
 #AUTOR:
 #FECHA:		25-01-2011
***********************************/

    elsif(par_transaccion='RH_FUNCIO_ELI')then
        BEGIN

         --inactivacion de la periodo
               update orga.tfuncionario
               set estado_reg='inactivo'
               where id_funcionario=v_parametros.id_funcionario;
               return 'Funcionario eliminado con exito';

               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario eliminado con exito '||v_parametros.id_funcionario);
               v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);

        END;

/*******************************
 #TRANSACCION:  RH_MAILFUN_GET
 #DESCRIPCION:	Recuepra el email del funcionario
 #AUTOR:	    RAC
 #FECHA:		04-02-2014
***********************************/

    elsif(par_transaccion='RH_MAILFUN_GET')then
        BEGIN

         --inactivacion de la periodo
              select
              fun.email_empresa
              into
              v_email_empresa
              from orga.tfuncionario fun
              where fun.id_funcionario = v_parametros.id_funcionario;

              v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Recupera el correo del funcionario');
              v_resp = pxp.f_agrega_clave(v_resp,'email_empresa',v_email_empresa::varchar);

        END;

    /*********************************
 	#TRANSACCION:  'RH_CUMPLECORR_INS'
 	#DESCRIPCION:	  Registra alertas para felicitar cumpleanero del dia
 	#AUTOR:		Gonzalo Sarmiento Sejas
 	#FECHA:		11-08-2016
	***********************************/

	ELSEIF (par_transaccion='RH_CUMPLECORR_INS')then

       begin

        select vf.desc_funcionario1 as nombre, ten.abreviatura
        into v_gerente
        from orga.tcargo tcar
        inner join orga.tuo_funcionario tuo on tuo.id_cargo = tcar.id_cargo
        inner join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
        inner join orga.tfuncionario tf on tf.id_funcionario = vf.id_funcionario
        inner join orga.tespecialidad_nivel ten on ten.id_especialidad_nivel =  tf.id_especialidad_nivel
        inner join orga.tuo uo on uo.id_uo = tuo.id_uo
        where tuo.estado_reg = 'activo' and tuo.tipo = 'oficial' and tcar.codigo = '1' and uo.estado_reg = 'activo'
        and current_date <= coalesce(tuo.fecha_finalizacion,'31/12/9999'::date);

        -- seleccionar los cumpleaneros del dia
         FOR v_registros in (SELECT FUNCIO.id_funcionario,
                                     FUNCIO.nombre::varchar,
                                     FUNCIO.ap_paterno,
                                     FUNCIO.ap_materno,
                                     CAR.nombre,
                                     F.email_empresa,
                                     usu.id_usuario
                              FROM orga.vfuncionario_personareporte FUNCIO
                                   INNER JOIN orga.tfuncionario F ON F.id_funcionario = FUNCIO.id_funcionario
                                   INNER JOIN SEGU.tpersona PERSON ON PERSON.id_persona = F.id_persona
                                   INNER JOIN orga.tuo_funcionario uofun on uofun.id_funcionario =
                                     FUNCIO.id_funcionario and uofun.estado_reg = 'activo' and
                                     uofun.fecha_asignacion <= now() ::date
                                     and (uofun.fecha_finalizacion >= now() ::date or uofun.fecha_finalizacion is null)
                                   INNER JOIN orga.tcargo car on car.id_cargo = uofun.id_cargo
                                   LEFT JOIN segu.tusuario usu on usu.id_persona=PERSON.id_persona
                              WHERE extract(day from PERSON.fecha_nacimiento) = extract(day from current_date)
                               AND extract(month from PERSON.fecha_nacimiento) = extract(month from current_date))  LOOP


                ----------------------------
                -- arma template de correo
                -----------------------------

                v_asunto = 'Hoy es tu cumpleaños y BoA quiere festejar contigo!!!';

                v_template = '<div style="width:400px; background-color: #019ADB; margin-right: auto; margin-left: auto;">
 							  <table width="400" style="background-color: #019ADB; font-family:''Helvetica Neue'',Helvetica,Arial,sans-serif; color: #ffffff; width: 400px;">
        					  <tr bgcolor="#019ADB">
				              <td>
                				<img src="http://www.boa.bo/Content/Aniversarios/fondo_cumple.jpg" alt="400">
            				  </td>
        					  </tr>
        					  <tr bgcolor="#019ADB" style="background-color: #019ADB;">
            				  <td style="background-color: #019ADB; font-size: 20px;" align="center">'||
                			  v_registros.nombre::varchar ||
            				  '</td>
        					  </tr>
                              <tr bgcolor="#019ADB" style="background-color: #019ADB;">
            				  <td style="background-color: #019ADB; font-size: 20px;" align="center">'||
                			  COALESCE(v_registros.ap_paterno,'')::varchar || '  ' || COALESCE(v_registros.ap_materno,'')::varchar ||
            				  '</td>
        					  </tr>
        					  <tr>
            				  <td style="background-color: #019ADB; font-size: 12px; padding-left: 20px; padding-right: 20px;" align="center">
                			  <br />
                			  Todos los que integramos la familia Boliviana de Aviaci&oacute;n nos sentimos agradecidos de poder ser
                			  parte de la celebraci&oacute;n de tu cumpleaños; fluyen palabras de buenos deseos, esperando que este d&iacute;a
                			  recibas grandes bendiciones.
                			  Que la salud nunca falte y que el &eacute;xito y la prosperidad sean constantes todos los d&iacute;as de
                			  tu vida a nivel personal, familiar y profesional.
                			  Recibe nuestro reconocimiento y sincero cariño
            				  </td>
        					  </tr>
        					  <tr>
            				  <td>
                				<table width="400" style="color: #ffffff; font-family:''Helvetica Neue'',Helvetica,Arial,sans-serif; font-size: 12px; width: 400px;">
                    		  <tr>
                        	  <td style="width: 100%; color: #ffffff;" align="center">
                              <br/>

                              <span >'||v_gerente.abreviatura||' '||v_gerente.nombre||'</span><br />
                              <span >GERENTE GENERAL</span><br />
                              <span >Empresa Pública Nacional Estratégica</span><br />
                              <span >Boliviana de Aviaci&oacute;n - BoA</span>
                        	  </td>
                    		  </tr>
                    		  <tr>
                        	  <td colspan="2">
                              <hr/>
                        	  </td>
                    		  </tr>
                			  </table>
            				  </td>
        					  </tr>
    						  </table>
							  </div>';
--<!--<img src="http://www.boa.bo/Content/Aniversarios/fi.png" width="200" ><br />-->
                v_titulo = ''|| v_registros.nombre || ' ' || COALESCE(v_registros.ap_paterno,'')::varchar || ' ' || COALESCE(v_registros.ap_materno,'')::varchar || '';
                v_acceso_directo = '';
                v_clase = '';
                v_parametros_ad = '{}';

                -- inserta registros de alarmas par ael usario que creo la obligacion
                v_id_alarma[1]:=param.f_inserta_alarma(v_registros.id_funcionario,
                                                    v_template ,    --descripcion alarmce
                                                    COALESCE(v_acceso_directo,''),--acceso directo
                                                    now()::date,
                                                    'felicitacion',
                                                    '',   -->
                                                    par_id_usuario,
                                                    v_clase,
                                                    v_titulo,--titulo
                                                    COALESCE(v_parametros_ad,''),
                                                    v_registros.id_usuario::integer,  --destino de la alarma
                                                    v_asunto);

       END LOOP;
       end;

	/*******************************
     #TRANSACCION:  RH_TRI_CAR_ASIG_IME
     #DESCRIPCION:	Envia emails responsable registro de correos de funcionario
     #AUTOR:	    franklin.espinoza
     #FECHA:		10-06-2019
    ***********************************/

    elsif(par_transaccion='RH_TRI_CAR_ASIG_IME')then
        BEGIN
        	v_resultado = orga.f_tr_registra_movimiento_asignacion();
        	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Envio de correos de las asignaciones de funcionario');
            v_resp = pxp.f_agrega_clave(v_resp,'envio',v_resultado::varchar);

        END;

    /*******************************
     #TRANSACCION:  RH_TRI_FIN_CONT_IME
     #DESCRIPCION:	Verifica la fecha fin contrato y la replica a SQL
     #AUTOR:	    franklin.espinoza
     #FECHA:		11-08-2020
    ***********************************/

    elsif(par_transaccion='RH_TRI_FIN_CONT_IME')then
        BEGIN
        	v_resultado = orga.f_tr_update_estado_empleados();
        	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Replicacion Exitosa Fin Contrato de Funcionario');
          v_resp = pxp.f_agrega_clave(v_resp,'replicacion',v_resultado::varchar);

        END;

    /*******************************
     #TRANSACCION:  RH_MOD_FUNC_REST
     #DESCRIPCION:	Actualiza datos de tpersona y tfuncionario
     #AUTOR:	    franklin.espinoza
     #FECHA:		29-03-2021
    ***********************************/

    elsif(par_transaccion='RH_MOD_FUNC_REST')then
        BEGIN

        	select tf.id_persona
            into v_id_persona
            from orga.tfuncionario tf
            where tf.id_funcionario = v_parametros.idFuncionario;

            update segu.tpersona set
                ci                = v_parametros.CI,
                expedicion        = v_parametros.Expedito,
                telefono1         = v_parametros.TelefonoFijo,
                celular1          = v_parametros.TelefonoCelular,
                correo            = v_parametros.Email,
                fecha_nacimiento  = v_parametros.FechaNacimiento::date,
                genero            = case when v_parametros.Genero = 'M' then 'VARON' else 'MUJER' end ,
                direccion         = v_parametros.Direccion,
                estado_civil      = v_parametros.EstadoCivil,
                zona_residencia   = v_parametros.Zona,
                numero_domicilio  = v_parametros.Numero,
                ciudad_residencia = v_parametros.Ciudad
            where id_persona = v_id_persona;

        	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Campos de Persona modificados exitosamente');
            v_resp = pxp.f_agrega_clave(v_resp,'estado','success');

        END;

    /*******************************
     #TRANSACCION:  RH_UPD_FECHA_ING_IME
     #DESCRIPCION:	Actualiza la fecha de ingreso de todos los funcianarios activos
     #AUTOR:	    franklin.espinoza
     #FECHA:		29-03-2021
    ***********************************/

    elsif(par_transaccion='RH_UPD_FECHA_ING_IME')then
        BEGIN

            for v_funcionario in select asig.id_funcionario, asig.id_uo_funcionario, asig.fecha_asignacion
                                 from orga.tuo_funcionario asig
        	                     where asig.tipo = 'oficial' and asig.estado_reg = 'activo' and coalesce(asig.fecha_finalizacion,'31/12/9999'::date) >= current_date loop
                update orga.tfuncionario set
                    fecha_ingreso_calculado = plani.f_get_fecha_primer_contrato_empleado (v_funcionario.id_uo_funcionario, v_funcionario.id_funcionario, v_funcionario.fecha_asignacion)
                where id_funcionario = v_funcionario.id_funcionario;
            end loop;

        	v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fecha de ingreso actualizado exitosamente');
            v_resp = pxp.f_agrega_clave(v_resp,'estado','success');

        END;

    else

         raise exception 'No existe la transaccion: %',par_transaccion;
    end if;

 return v_resp;

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

ALTER FUNCTION orga.ft_funcionario_ime (par_administrador integer, par_id_usuario integer, par_tabla varchar, par_transaccion varchar)
  OWNER TO postgres;