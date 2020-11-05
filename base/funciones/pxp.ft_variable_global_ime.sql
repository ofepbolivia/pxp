CREATE OR REPLACE FUNCTION "pxp"."ft_variable_global_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		FRAMEWORK
 FUNCION: 		pxp.ft_variable_global_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pxp.variable_global'
 AUTOR: 		 (admin)
 FECHA:	        28-01-2020 15:30:09
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				28-01-2020 15:30:09								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pxp.variable_global'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_variable_global	integer;
    v_valor                 varchar;

BEGIN

    v_nombre_funcion = 'pxp.ft_variable_global_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PXP_varg_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		24-01-2020 19:50:15
	***********************************/

	if(p_transaccion='PXP_varg_INS')then

        begin
        	--Sentencia de la insercion
        	insert into pxp.variable_global(
			variable,
			valor,
			descripcion
          	) values(
			v_parametros.variable,
			v_parametros.valor,
			v_parametros.descripcion



			)RETURNING id_variable_global into v_id_variable_global;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Variable Global almacenado(a) con exito (id_variable_global'||v_id_variable_global||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_variable_global',v_id_variable_global::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PXP_varg_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		24-01-2020 19:50:15
	***********************************/

	elsif(p_transaccion='PXP_varg_MOD')then

		begin
			--Sentencia de la modificacion
			update pxp.variable_global set
			variable = v_parametros.variable,
			valor = v_parametros.valor,
			descripcion = v_parametros.descripcion
			where id_variable_global=v_parametros.id_variable_global;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Variable Global modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_variable_global',v_parametros.id_variable_global::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PXP_varg_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		24-01-2020 19:50:15
	***********************************/

	elsif(p_transaccion='PXP_varg_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pxp.variable_global
            where id_variable_global=v_parametros.id_variable_global;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Variable Global eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_variable_global',v_parametros.id_variable_global::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*******************************
     #TRANSACCION:   SEG_OBTVARGLO_MOD
     #DESCRIPCION:	obtiene variables globales
     #AUTOR:		KPLIAN(rac)
     #FECHA:
    ***********************************/

    elsif(p_transaccion = 'PXP_varg_GET')then

          begin

               v_valor = pxp.f_get_variable_global('token_ofep');
               v_resp = pxp.f_agrega_clave(v_resp,'mensaje','variable global');
               v_resp = pxp.f_agrega_clave(v_resp,'codigo',v_parametros.codigo::varchar);
               v_resp = pxp.f_agrega_clave(v_resp,'valor',v_valor::varchar);

               --retorna respuesta en formato JSON
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pxp"."ft_variable_global_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
