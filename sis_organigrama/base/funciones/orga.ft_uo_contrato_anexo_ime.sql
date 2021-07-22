CREATE OR REPLACE FUNCTION orga.ft_uo_contrato_anexo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_uo_contrato_anexo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.tuo_contrato_anexo'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        19-07-2021 13:16:48
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-07-2021 13:16:48								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.tuo_contrato_anexo'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_uo_contrato_anexo	integer;

BEGIN

    v_nombre_funcion = 'orga.ft_uo_contrato_anexo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_UO_CA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 13:16:48
	***********************************/

	if(p_transaccion='OR_UO_CA_INS')then

        begin
        	--Sentencia de la insercion
        	insert into orga.tuo_contrato_anexo(
			estado_reg,
			id_uo,
			id_tipo_documento_contrato,
			id_tipo_contrato,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_uo,
			v_parametros.id_tipo_documento_contrato,
			v_parametros.id_tipo_contrato,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_uo_contrato_anexo into v_id_uo_contrato_anexo;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Uo Contrato Anexo almacenado(a) con exito (id_uo_contrato_anexo'||v_id_uo_contrato_anexo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_uo_contrato_anexo',v_id_uo_contrato_anexo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_UO_CA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 13:16:48
	***********************************/

	elsif(p_transaccion='OR_UO_CA_MOD')then

		begin
			--Sentencia de la modificacion
			update orga.tuo_contrato_anexo set
			id_uo = v_parametros.id_uo,
			id_tipo_documento_contrato = v_parametros.id_tipo_documento_contrato,
			id_tipo_contrato = v_parametros.id_tipo_contrato,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_uo_contrato_anexo=v_parametros.id_uo_contrato_anexo;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Uo Contrato Anexo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_uo_contrato_anexo',v_parametros.id_uo_contrato_anexo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_UO_CA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 13:16:48
	***********************************/

	elsif(p_transaccion='OR_UO_CA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from orga.tuo_contrato_anexo
            where id_uo_contrato_anexo=v_parametros.id_uo_contrato_anexo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Uo Contrato Anexo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_uo_contrato_anexo',v_parametros.id_uo_contrato_anexo::varchar);

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