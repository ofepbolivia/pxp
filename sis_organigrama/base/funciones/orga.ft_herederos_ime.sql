CREATE OR REPLACE FUNCTION orga.ft_herederos_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_herederos_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.therederos'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        16-07-2021 14:16:29
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-07-2021 14:16:29								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.therederos'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_herederos		    integer;
    v_id_persona			integer;
	v_persona				record;
BEGIN

    v_nombre_funcion = 'orga.ft_herederos_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_HERE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		16-07-2021 14:16:29
	***********************************/

	if(p_transaccion='OR_HERE_INS')then

        begin

        	 v_id_persona = v_parametros.id_persona;
             --raise 'valores: %; parametros: %',v_id_persona,v_parametros;
             if v_id_persona is null then
             	--CI
                if exists(select 1 from segu.tpersona
                      where ci = v_parametros.ci and v_parametros.ci != '') then
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
                               id_tipo_doc_identificacion,
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
                               direccion
                ) values(
                      upper(v_parametros.nombre),
                      upper(v_parametros.ap_paterno),
                      upper(v_parametros.ap_materno),
                      v_parametros.fecha_nacimiento,
                      v_parametros.genero,
                      v_parametros.nacionalidad,
                      v_parametros.id_lugar,
                       v_parametros.id_tipo_doc_identificacion,
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
                      v_parametros.direccion
                ) RETURNING id_persona INTO v_id_persona;
             end if;

             /*if v_id_persona is not null then

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

                	update segu.tpersona set
                      nombre = upper(v_parametros.nombre),
                      apellido_paterno = upper(v_parametros.ap_paterno),
                      apellido_materno = upper(v_parametros.ap_materno),
                      fecha_nacimiento = v_parametros.fecha_nacimiento,
                      genero = v_parametros.genero,
                      nacionalidad = v_parametros.nacionalidad,
                      ci = v_parametros.ci,
                      expedicion = v_parametros.expedicion,
                      estado_civil = v_parametros.estado_civil,
                      discapacitado = v_parametros.discapacitado,
                      carnet_discapacitado = case when v_parametros.discapacitado = 'no' then null else v_parametros.carnet_discapacitado end,
                      correo = v_parametros.correo,
                      celular1 = v_parametros.celular1,
                      telefono1 = v_parametros.telefono1,
                      telefono2 = v_parametros.telefono2,
                      celular2 = v_parametros.celular2,
                      direccion = v_parametros.direccion,
                      id_tipo_doc_identificacion = v_parametros.id_tipo_doc_identificacion
                     where id_persona = v_parametros.id_persona;
                 end if;
              end if;*/

        	--Sentencia de la insercion
        	insert into orga.therederos(
			estado_reg,
			parentesco,
			edad,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod,
            id_funcionario,
            id_persona,
            tiempo
          	) values(
			'activo',
			'heredero',
			v_parametros.edad,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null,
			v_parametros.id_funcionario,
			v_id_persona,
            v_parametros.tiempo
			)RETURNING id_herederos into v_id_herederos;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Herederos almacenado(a) con exito (id_herederos'||v_id_herederos||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_herederos',v_id_herederos::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_HERE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		16-07-2021 14:16:29
	***********************************/

	elsif(p_transaccion='OR_HERE_MOD')then

		begin
        	v_id_persona = v_parametros.id_persona;
        	select tp.*
          	into v_persona
          	from segu.tpersona tp
          	where tp.id_persona = v_id_persona;

            if ( v_persona.nombre != upper(v_parametros.nombre) or v_persona.apellido_paterno != upper(v_parametros.ap_paterno) or
              v_persona.apellido_materno != upper(v_parametros.ap_materno) or v_persona.fecha_nacimiento != v_parametros.fecha_nacimiento or
              v_persona.genero != v_parametros.genero or v_persona.nacionalidad != v_parametros.nacionalidad or v_persona.ci != v_parametros.ci or
              v_persona.expedicion != v_parametros.expedicion or v_persona.estado_civil != v_parametros.estado_civil or
              v_persona.discapacitado != v_parametros.discapacitado or
              v_persona.correo != v_parametros.correo or v_persona.celular1 != v_parametros.celular1 or v_persona.telefono1 != v_parametros.telefono1 or
              v_persona.telefono2 != v_parametros.telefono2 or v_persona.celular2 != v_parametros.celular2 or v_persona.direccion != v_parametros.direccion or
              v_persona.id_tipo_doc_identificacion != v_parametros.id_tipo_doc_identificacion ) then

                update segu.tpersona set
                  nombre = upper(v_parametros.nombre),
                  apellido_paterno = upper(v_parametros.ap_paterno),
                  apellido_materno = upper(v_parametros.ap_materno),
                  fecha_nacimiento = v_parametros.fecha_nacimiento,
                  genero = v_parametros.genero,
                  nacionalidad = v_parametros.nacionalidad,
                  ci = v_parametros.ci,
                  expedicion = v_parametros.expedicion,
                  estado_civil = v_parametros.estado_civil,
                  discapacitado = v_parametros.discapacitado,
                  --carnet_discapacitado = case when v_parametros.discapacitado = 'no' then null else v_parametros.carnet_discapacitado end,
                  correo = v_parametros.correo,
                  celular1 = v_parametros.celular1,
                  telefono1 = v_parametros.telefono1,
                  telefono2 = v_parametros.telefono2,
                  celular2 = v_parametros.celular2,
                  direccion = v_parametros.direccion,
                  id_tipo_doc_identificacion = v_parametros.id_tipo_doc_identificacion
                 where id_persona = v_parametros.id_persona;
            end if;
			--Sentencia de la modificacion
			update orga.therederos set
			--parentesco = v_parametros.parentesco,
			edad = v_parametros.edad,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_funcionario = v_parametros.id_funcionario,
            id_persona = v_id_persona,
            tiempo = v_parametros.tiempo
			where id_herederos=v_parametros.id_herederos;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Herederos modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_herederos',v_parametros.id_herederos::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_HERE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		16-07-2021 14:16:29
	***********************************/

	elsif(p_transaccion='OR_HERE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from orga.therederos
            where id_herederos=v_parametros.id_herederos;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Herederos eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_herederos',v_parametros.id_herederos::varchar);

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

ALTER FUNCTION orga.ft_herederos_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar) OWNER TO postgres;