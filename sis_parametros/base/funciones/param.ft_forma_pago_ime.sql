CREATE OR REPLACE FUNCTION param.ft_forma_pago_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Contabilidad
 FUNCION: 		param.ft_forma_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'param.tforma_pago'
 AUTOR: 		Maylee Perez Pastor
 FECHA:	        11-06-2019 21:49:11
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

	v_id_forma_pago			integer;

BEGIN

    v_nombre_funcion = 'param.ft_forma_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PM_FORDEPA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	if(p_transaccion='PM_FORDEPA_INS')then

        begin


        	--Sentencia de la insercion
        	insert into param.tforma_pago(
                id_usuario_reg,
                id_usuario_mod,
                fecha_reg,
                fecha_mod,
                estado_reg,
                desc_forma_pago,
                observaciones,
                cod_inter,
                tipo,
                orden

          	) values(
			    p_id_usuario,
                null,
				now(),
                null,
                'activo',
                v_parametros.desc_forma_pago,
                v_parametros.observaciones,
                string_to_array(v_parametros.cod_inter,',')::varchar[],
                v_parametros.tipo,
                v_parametros.orden

		)RETURNING id_forma_pago into v_id_forma_pago;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Forma de Pago almacenado(a) con exito (id_forma_pago'||v_id_forma_pago||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_forma_pago',v_id_forma_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PM_FORDEPA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FORDEPA_MOD')then

		begin

			--Sentencia de la modificacion
			update param.tforma_pago set

                desc_forma_pago= v_parametros.desc_forma_pago,
                observaciones = v_parametros.observaciones,
                cod_inter = string_to_array(v_parametros.cod_inter,',')::varchar[],
                fecha_mod = now(),
                id_usuario_mod = p_id_usuario,
                tipo = v_parametros.tipo,
                orden = v_parametros.orden
			where id_forma_pago=v_parametros.id_forma_pago;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Forma de Pago modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_forma_pago',v_parametros.id_forma_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PM_FORDEPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Maylee Perez Pastor
 	#FECHA:		11-06-2019 21:49:11
	***********************************/

	elsif(p_transaccion='PM_FORDEPA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from param.tforma_pago
            where id_forma_pago=v_parametros.id_forma_pago;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Forma de Pago eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_forma_pago',v_parametros.id_forma_pago::varchar);

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
COST 100;
