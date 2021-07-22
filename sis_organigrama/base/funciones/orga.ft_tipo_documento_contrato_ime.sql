CREATE OR REPLACE FUNCTION orga.ft_tipo_documento_contrato_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_tipo_documento_contrato_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.ttipo_documento_contrato'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        19-07-2021 16:12:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-07-2021 16:12:10								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.ttipo_documento_contrato'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_documento	integer;

BEGIN

    v_nombre_funcion = 'orga.ft_tipo_documento_contrato_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_TIP_DC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 16:12:10
	***********************************/

	if(p_transaccion='OR_TIP_DC_INS')then

        begin
        	--Sentencia de la insercion
        	insert into orga.ttipo_documento_contrato(
			estado_reg,
			tipo,
			tipo_detalle,
			contenido,
			fecha_ini,
			fecha_fin,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.tipo,
			v_parametros.tipo_detalle,
			v_parametros.contenido,
			v_parametros.fecha_ini,
			v_parametros.fecha_fin,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
			)RETURNING id_tipo_documento_contrato into v_id_tipo_documento;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Documento Contrato almacenado(a) con exito (id_tipo_documento_contrato '||v_id_tipo_documento||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_documento_contrato',v_id_tipo_documento::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_TIP_DC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 16:12:10
	***********************************/

	elsif(p_transaccion='OR_TIP_DC_MOD')then

		begin
			--Sentencia de la modificacion
			update orga.ttipo_documento_contrato set
			tipo = v_parametros.tipo,
			tipo_detalle = v_parametros.tipo_detalle,
			contenido = v_parametros.contenido,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_documento_contrato=v_parametros.id_tipo_documento_contrato;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Documento Contrato modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_documento_contrato',v_parametros.id_tipo_documento_contrato::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_TIP_DC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 16:12:10
	***********************************/

	elsif(p_transaccion='OR_TIP_DC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from orga.ttipo_documento_contrato
            where id_tipo_documento_contrato=v_parametros.id_tipo_documento_contrato;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Documento Contrato eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_documento_contrato',v_parametros.id_tipo_documento_contrato::varchar);

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