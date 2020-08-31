CREATE OR REPLACE FUNCTION orga.ft_permiso_gerencias_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Organigrama
 FUNCION: 		orga.ft_permiso_gerencias_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'cola.tusuario_sucursal'
 AUTOR: 		 Ismael Valdivia
 FECHA:	        26-08-2020 11:30:0
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
   	v_consulta        		text;
    v_id_autorizacion		integer;


BEGIN

    v_nombre_funcion = 'orga.ft_permiso_gerencias_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ORGA_INSPERMISOS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		26-08-2020 11:30:47
	***********************************/

	if(p_transaccion='ORGA_INSPERMISOS_INS')then

        begin

        	--Sentencia de la insercion
        	insert into orga.tpermiso_gerencias(
			id_funcionario,
			id_gerencia,
			estado_reg,
			id_usuario_reg,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
            v_parametros.id_funcionario,
			string_to_array (v_parametros.id_gerencia,',')::INTEGER[],
			'activo',
			p_id_usuario,
			now(),
			null,
			null
			)RETURNING id_autorizacion into v_id_autorizacion;



			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registro Exitoso');
            v_resp = pxp.f_agrega_clave(v_resp,'id_autorizacion',v_id_autorizacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ORGA_PERMIGEREN_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		26/08/2020
	***********************************/

      elsif(p_transaccion='ORGA_PERMIGEREN_MOD')then

		begin

			update orga.tpermiso_gerencias set
            id_gerencia = string_to_array (v_parametros.id_gerencia,',')::INTEGER[],
            id_funcionario = v_parametros.id_funcionario
            where id_autorizacion = v_parametros.id_autorizacion;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permiso Modificado');
            v_resp = pxp.f_agrega_clave(v_resp,'id_autorizacion',v_parametros.id_autorizacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ORGA_PERMGEREN_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		Ismael Valdivia
 	#FECHA:		26/08/2020
	***********************************/

	elsif(p_transaccion='ORGA_PERMGEREN_ELI')then

		begin

			delete from orga.tpermiso_gerencias
            where id_autorizacion=v_parametros.id_autorizacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Autorizacion Eliminada');
            v_resp = pxp.f_agrega_clave(v_resp,'id_autorizacion',v_parametros.id_autorizacion::varchar);

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

ALTER FUNCTION orga.ft_permiso_gerencias_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;
