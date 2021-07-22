CREATE OR REPLACE FUNCTION orga.ft_representante_legal_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_representante_legal_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.trepresentate_legal'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        19-07-2021 12:11:06
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-07-2021 12:11:06								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.trepresentate_legal'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	 integer;
	v_parametros           	 record;
	v_id_requerimiento     	 integer;
	v_resp		             varchar;
	v_nombre_funcion         text;
	v_mensaje_error          text;
	v_id_representante_legal integer;

BEGIN

    v_nombre_funcion = 'orga.ft_representante_legal_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_REP_LEG_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 12:11:06
	***********************************/

	if(p_transaccion='OR_REP_LEG_INS')then

        begin
        	--Sentencia de la insercion
        	insert into orga.trepresentante_legal(
			estado_reg,
			id_funcionario,
			nro_resolucion,
			fecha_resolucion,
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
			v_parametros.id_funcionario,
			v_parametros.nro_resolucion,
			v_parametros.fecha_resolucion,
			v_parametros.fecha_ini,
			v_parametros.fecha_fin,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
			)RETURNING id_representante_legal into v_id_representante_legal;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Representante Legal almacenado(a) con exito (id_representante_legal '||v_id_representante_legal||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_representante_legal',v_id_representante_legal::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_REP_LEG_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 12:11:06
	***********************************/

	elsif(p_transaccion='OR_REP_LEG_MOD')then

		begin
			--Sentencia de la modificacion
			update orga.trepresentante_legal set
			id_funcionario = v_parametros.id_funcionario,
			nro_resolucion = v_parametros.nro_resolucion,
			fecha_resolucion = v_parametros.fecha_resolucion,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_representante_legal = v_parametros.id_representante_legal;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Representante Legal modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_representante_legal',v_parametros.id_representante_legal::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_REP_LEG_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		19-07-2021 12:11:06
	***********************************/

	elsif(p_transaccion='OR_REP_LEG_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from orga.trepresentante_legal
            where id_representante_legal=v_parametros.id_representante_legal;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Representante Legal eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_representante_legal',v_parametros.id_representante_legal::varchar);

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