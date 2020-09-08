CREATE OR REPLACE FUNCTION param.f_tdepto_moneda_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Parametros Generales
 FUNCION: 		param.f_tdepto_moneda_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'param.tdepto_moneda'
 AUTOR: 		 Maylee Perez Pastor
 FECHA:	        08-09-2020 18:26:47
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
	v_id_depto_moneda	integer;

BEGIN

    v_nombre_funcion = 'param.f_tdepto_moneda_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PM_DEPMONEDA_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        maylee.perez
     #FECHA:        08-09-2020 18:26:47
    ***********************************/

    if(p_transaccion='PM_DEPMONEDA_INS')then

        begin
            --Sentencia de la insercion
            insert into param.tdepto_moneda(
            estado_reg,
            id_depto,
            id_moneda,
            id_usuario_reg,
            fecha_reg,
            id_usuario_mod,
            fecha_mod

              ) values(
            'activo',
            v_parametros.id_depto,
            v_parametros.id_moneda,
            p_id_usuario,
            now(),
            null,
            null
            )RETURNING id_depto_moneda into v_id_depto_moneda;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Moneda por Depto almacenado(a) con exito (id_depto_moneda'||v_id_depto_moneda||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_moneda',v_id_depto_moneda::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PM_DEPMONEDA_MOD'
     #DESCRIPCION:    Modificacion de registros
      #AUTOR:        maylee.perez
     #FECHA:        08-09-2020 18:26:47
    ***********************************/

    elsif(p_transaccion='PM_DEPMONEDA_MOD')then

        begin
            --Sentencia de la modificacion
            update param.tdepto_moneda set
            id_depto = v_parametros.id_depto,
            id_moneda = v_parametros.id_moneda,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now()
            where id_depto_moneda=v_parametros.id_depto_moneda;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Moneda por Depto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_moneda',v_parametros.id_depto_moneda::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PM_DEPMONEDA_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        mzm
     #FECHA:        24-11-2011 18:26:47
    ***********************************/

    elsif(p_transaccion='PM_DEPMONEDA_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from param.tdepto_moneda
            where id_depto_moneda=v_parametros.id_depto_moneda;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Moneda por Depto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_depto_moneda',v_parametros.id_depto_moneda::varchar);

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
