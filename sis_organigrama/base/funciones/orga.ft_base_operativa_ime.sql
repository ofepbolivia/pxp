CREATE OR REPLACE FUNCTION orga.ft_base_operativa_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_base_operativa_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.ft_base_operativa_ime'
 AUTOR: 		(franklin.espinoza)
 FECHA:	        05-11-2021
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_parametros           	    record;
	v_resp		                varchar;
	v_nombre_funcion            text;
	v_mensaje_error             text;
    v_id_funcionario_oficina    integer;
BEGIN

    v_nombre_funcion = 'orga.ft_base_operativa_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
 	#TRANSACCION:  'ORGA_BASE_OPE_INS'
 	#DESCRIPCION:	Inserta Base Operativa de un funcionario
 	#AUTOR		:	franklin.espinoza
 	#FECHA		:	05-11-2021
	***********************************/
	if(p_transaccion='ORGA_BASE_OPE_INS')then

		begin
		    insert into orga.tfuncionario_oficina(
                fecha_ini,
                fecha_fin,
                id_funcionario,
                id_oficina,
                observaciones,
                estado_reg,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod
          	) values(
                v_parametros.fecha_ini,
                v_parametros.fecha_fin,
          	    v_parametros.id_funcionario,
          	    v_parametros.id_oficina,
          	    v_parametros.observaciones,
                'activo',
                p_id_usuario,
                now(),
                null,
                null
			)RETURNING id_funcionario_oficina into v_id_funcionario_oficina;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registro creado exitosamente');
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_oficina',v_id_funcionario_oficina::varchar);

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

ALTER FUNCTION orga.ft_base_operativa_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;