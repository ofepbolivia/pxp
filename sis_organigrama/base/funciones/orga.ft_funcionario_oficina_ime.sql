CREATE OR REPLACE FUNCTION orga.ft_funcionario_oficina_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_funcionario_oficina_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.tfuncionario_oficina'
 AUTOR: 		 (franklin.espinoza)
 FECHA:	        29-03-2021 18:50:34
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				29-03-2021 18:50:34								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.tfuncionario_oficina'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    		integer;
	v_parametros           		record;
	v_id_requerimiento     		integer;
	v_resp		            	varchar;
	v_nombre_funcion        	text;
	v_mensaje_error         	text;
	v_id_funcionario_oficina	integer;
    v_record_json				jsonb;

BEGIN

    v_nombre_funcion = 'orga.ft_funcionario_oficina_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_FUNCOFI_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-03-2021 18:50:34
	***********************************/

	if(p_transaccion='OR_FUNCOFI_INS')then

        begin
        	--Sentencia de la insercion
        	insert into orga.tfuncionario_oficina(
			estado_reg,
			id_funcionario,
			id_oficina,
			fecha_ini,
			fecha_fin,
			observaciones,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_funcionario,
			v_parametros.id_oficina,
			v_parametros.fecha_ini,
			v_parametros.fecha_fin,
			v_parametros.observaciones,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_funcionario_oficina into v_id_funcionario_oficina;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Oficina almacenado(a) con exito (id_funcionario_oficina'||v_id_funcionario_oficina||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_oficina',v_id_funcionario_oficina::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_FUNCOFI_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-03-2021 18:50:34
	***********************************/

	elsif(p_transaccion='OR_FUNCOFI_MOD')then

		begin
			--Sentencia de la modificacion
			update orga.tfuncionario_oficina set
			id_funcionario = v_parametros.id_funcionario,
			id_oficina = v_parametros.id_oficina,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			observaciones = v_parametros.observaciones,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_funcionario_oficina=v_parametros.id_funcionario_oficina;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Oficina modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_oficina',v_parametros.id_funcionario_oficina::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_FUNCOFI_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-03-2021 18:50:34
	***********************************/

	elsif(p_transaccion='OR_FUNCOFI_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from orga.tfuncionario_oficina
            where id_funcionario_oficina=v_parametros.id_funcionario_oficina;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionario Oficina eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario_oficina',v_parametros.id_funcionario_oficina::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'OR_FUNC_OFI_REST'
 	#DESCRIPCION:	Inserccion de Oficina Funcionario REST
 	#AUTOR:		franklin.espinoza
 	#FECHA:		29-03-2021 18:50:34
	***********************************/

	elsif(p_transaccion='OR_FUNC_OFI_REST')then

		begin
        	for v_record_json in SELECT * FROM jsonb_array_elements(v_parametros.dataJson)  loop
            --raise 'v_record_json: %', v_record_json->>'id_funcionario_oficina';
                --Sentencia de insercción
                if v_record_json->>'operacion' = 'INSERT' then

                    --Sentencia de la insercion
                    insert into orga.tfuncionario_oficina(
                        id_funcionario_oficina,
                        estado_reg,
                        id_funcionario,
                        id_oficina,
                        fecha_ini,
                        fecha_fin,
                        observaciones,
                        id_usuario_reg,
                        fecha_reg,
                        id_usuario_mod,
                        fecha_mod,
                        fuente
                    ) values(
                        (v_record_json->>'id_funcionario_oficina')::integer,
                        'activo',
                        (v_record_json->>'id_funcionario')::integer,
                        (v_record_json->>'id_oficina')::integer,
                        (v_record_json->>'fecha_ini')::date,
                        (v_record_json->>'fecha_fin')::date,
                        (v_record_json->>'observaciones')::text,
                        p_id_usuario,
                        now(),
                        null,
                        null,
                        (v_record_json->>'fuente')::varchar
                    );

                elsif v_record_json->>'operacion' = 'UPDATE' then
                    --Sentencia de la modificacion
                    update orga.tfuncionario_oficina set
                    --id_funcionario 	= v_parametros.dataJson->>'id_funcionario'::integer,
                    id_oficina 		= (v_record_json->>'id_oficina')::integer,
                    fecha_ini 		= (v_record_json->>'fecha_ini')::date,
                    fecha_fin 		= (v_record_json->>'fecha_fin')::date,
                    observaciones 	= (v_record_json->>'observaciones')::text,
                    id_usuario_mod 	= p_id_usuario,
                    fecha_mod 		= now(),
                    usuario 		= (v_record_json->>'usuario')::varchar,
                    estado_reg		= (v_record_json->>'estado_reg')::varchar
                    where id_funcionario_oficina = (v_record_json->>'id_funcionario_oficina')::integer;
                end if;
            end loop;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Oficina Funcionario transaccion exitosa'::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'status','success'::varchar);

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