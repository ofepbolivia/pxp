CREATE OR REPLACE FUNCTION param.ft_proveedor_contacto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Parametros Generales
 FUNCION: 		param.ft_proveedor_cta_bancaria_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'param.ft_proveedor_contacto_ime'
 AUTOR: 		 Maylee Perez Pastor
 FECHA:	        30-03-2020 20:07:41
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_proveedor_contacto	integer;


BEGIN

    v_nombre_funcion = 'param.ft_proveedor_contacto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PM_PROVCONTAC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		30-03-2020 20:07:41
	***********************************/

	if(p_transaccion='PM_PROVCONTAC_INS')then

        begin
       -- raise exception 'llegabdalkym %',v_parametros.id_alkym_proveedor_contacto;

         	--Sentencia de la insercion
        	insert into param.tproveedor_contacto(
			id_proveedor,
            nombre_contacto,
            telefono,
            fax,
            area,
            email,
            id_usuario_reg,
            id_usuario_mod,
            fecha_reg,
            fecha_mod,
            estado_reg,
            ci,
            /*Aumentando para el id alkym*/
            id_proveedor_contacto_alkym

          	) values(
			v_parametros.id_proveedor,
            upper(v_parametros.nombre_contacto),
            v_parametros.telefono,
            v_parametros.fax,
            v_parametros.area,
            v_parametros.email,

			p_id_usuario,
            null,
			now(),
            null,
            'activo',
            v_parametros.ci,
            /*Aumentando para el id alkym*/
            v_parametros.id_alkym_proveedor_contacto



			)RETURNING id_proveedor_contacto into v_id_proveedor_contacto;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proveedor contacto almacenado(a) con exito (id_proveedor_contacto'||v_id_proveedor_contacto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor_contacto',v_id_proveedor_contacto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PM_PROVCONTAC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		30-03-2020 20:07:41
	***********************************/

	elsif(p_transaccion='PM_PROVCONTAC_MOD')then

		begin
       -- raise exception 'llegabd %',v_parametros.id_proveedor;
			--Sentencia de la modificacion
			update param.tproveedor_contacto set

			id_proveedor = v_parametros.id_proveedor,
            nombre_contacto = upper(v_parametros.nombre_contacto),
            telefono = v_parametros.telefono,
			fax = v_parametros.fax,
			area = v_parametros.area,
			email = v_parametros.email,

			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
            ci = v_parametros.ci
			where id_proveedor_contacto=v_parametros.id_proveedor_contacto;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proveedor contacto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor_contacto',v_parametros.id_proveedor_contacto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PM_PROVCONTAC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		30-03-2020 20:07:41
	***********************************/

	elsif(p_transaccion='PM_PROVCONTAC_ELI')then

		begin
			--Sentencia de la eliminacion

         	UPDATE param.tproveedor_contacto SET
            estado_reg = 'Inactivo'
            where id_proveedor_contacto=v_parametros.id_proveedor_contacto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proveedor Contacto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proveedor_contacto',v_parametros.id_proveedor_contacto::varchar);

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
