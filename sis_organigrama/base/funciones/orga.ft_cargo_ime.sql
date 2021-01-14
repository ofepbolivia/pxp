CREATE OR REPLACE FUNCTION orga.ft_cargo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_cargo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'orga.tcargo'
 AUTOR: 		 (admin)
 FECHA:	        14-01-2014 19:16:06
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
	v_id_cargo	integer;
	v_nombre_cargo			varchar;
	v_id_lugar				integer;

	v_cargo					record;
  v_presupuesto			record;
	v_id_presupuesto		integer;
  v_asignacion			record;
  v_id_gestion			integer;

  v_funcionarios			record;
  v_contador				integer = 1;
BEGIN

    v_nombre_funcion = 'orga.ft_cargo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_CARGO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		14-01-2014 19:16:06
	***********************************/

	if(p_transaccion='OR_CARGO_INS')then

        begin
        	select id_lugar into v_id_lugar
        	from orga.toficina
        	where id_oficina = v_parametros.id_oficina;

          --(franklin.espinoza) se obtiene el nombre para el item
        	select tc.nombre into v_nombre_cargo
            from orga.ttemporal_cargo tc
            where tc.id_temporal_cargo = v_parametros.id_temporal_cargo;


        	--Sentencia de la insercion
        	insert into orga.tcargo(
			id_tipo_contrato,
			id_lugar,
			id_uo,
			id_escala_salarial,
			codigo,
			nombre,
			fecha_ini,
			estado_reg,
			fecha_fin,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
			id_oficina,
			id_temporal_cargo
          	) values(
			v_parametros.id_tipo_contrato,
			v_id_lugar,
			v_parametros.id_uo,
			v_parametros.id_escala_salarial,
			v_parametros.codigo,
			v_nombre_cargo,
			v_parametros.fecha_ini,
			'activo',
			v_parametros.fecha_fin,
			now(),
			p_id_usuario,
			null,
			null,
			v_parametros.id_oficina,
			v_parametros.id_temporal_cargo
			)RETURNING id_cargo into v_id_cargo;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cargo almacenado(a) con exito (id_cargo'||v_id_cargo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cargo',v_id_cargo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_CARGO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		14-01-2014 19:16:06
	***********************************/

	elsif(p_transaccion='OR_CARGO_MOD')then

		begin


        	select id_lugar into v_id_lugar
        	from orga.toficina
        	where id_oficina = v_parametros.id_oficina;

			    /*select tca.*
            into v_cargo
            from orga.tcargo tca
            where tca.id_cargo = v_parametros.id_cargo;

            if v_id_lugar != v_cargo.id_lugar and v_parametros.fecha_fin is not null  then
            	--raise 'temporal: %', v_parametros.id_temporal_cargo;
                select tc.nombre into v_nombre_cargo
            	  from orga.ttemporal_cargo tc
            	  where tc.id_temporal_cargo = v_cargo.id_temporal_cargo;

            	  insert into orga.tcargo(
                  id_tipo_contrato,
                  id_lugar,
                  id_uo,
                  id_escala_salarial,
                  codigo,
                  nombre,
                  fecha_ini,
                  estado_reg,
                  fecha_fin,
                  fecha_reg,
                  id_usuario_reg,
                  fecha_mod,
                  id_usuario_mod,
                  id_oficina,
                  id_temporal_cargo
          		  ) values (
                  v_cargo.id_tipo_contrato,
                  v_id_lugar,
                  v_cargo.id_uo,
                  v_cargo.id_escala_salarial,
                  v_cargo.codigo,
                  v_nombre_cargo,
                  '01/01/2020'::date,
                  'activo',
                  null,
                  now(),
                  p_id_usuario,
                  null,
                  null,
                  v_parametros.id_oficina,
                  v_cargo.id_temporal_cargo
				        )RETURNING id_cargo into v_id_cargo;

                select tcp.*
                into v_presupuesto
                from orga.tcargo_presupuesto tcp
                where tcp.id_cargo = v_parametros.id_cargo and tcp.id_gestion = 17 and (tcp.fecha_fin is null or current_date <= tcp.fecha_fin);

                select tpi.id_presupuesto_dos
                into v_id_presupuesto
                from pre.tpresupuesto_ids tpi
                where tpi.id_presupuesto_uno = v_presupuesto.id_centro_costo;

                select tcc.id_gestion
                into v_id_gestion
                from param.tcentro_costo tcc
                where tcc.id_centro_costo = v_id_presupuesto;

                insert into orga.tcargo_presupuesto(
                  id_cargo,
                  id_gestion,
                  id_centro_costo,
                  porcentaje,
                  fecha_ini,
                  estado_reg,
                  id_usuario_reg,
                  fecha_reg,
                  fecha_mod,
                  id_usuario_mod,
                  id_ot,
                  fecha_fin
                ) values(
                  v_id_cargo,
                  v_id_gestion,
                  v_id_presupuesto,
                  v_presupuesto.porcentaje,
                  '01/01/2020'::date,
                  'activo',
                  p_id_usuario,
                  now(),
                  null,
                  null,
                  v_presupuesto.id_ot,
                  '31/12/2020'::date

                );--RETURNING id_cargo_presupuesto into v_id_cargo_presupuesto;

                select tuo.*
                into v_asignacion
                from orga.tcargo tcar
                inner join orga.tuo_funcionario tuo on tuo.id_cargo = tcar.id_cargo
                --inner join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
                where tcar.id_cargo = v_cargo.id_cargo and tcar.codigo = v_cargo.codigo
                and tcar.estado_reg = 'activo' and tcar.id_uo = v_cargo.id_uo
                and tuo.estado_reg = 'activo' and tuo.tipo = 'oficial' and (tuo.fecha_finalizacion is null or current_date<=tuo.fecha_finalizacion);


                update orga.tuo_funcionario set
                  estado_funcional = 'inactivo',
                  fecha_finalizacion = '31/12/2019'
                where id_uo_funcionario = v_asignacion.id_uo_funcionario;

                insert into orga.tuo_funcionario(
                   id_uo, 						id_funcionario, 						fecha_asignacion,
                   fecha_finalizacion,			id_cargo,								observaciones_finalizacion,
                   nro_documento_asignacion,	fecha_documento_asignacion,				id_usuario_reg,
                   tipo, certificacion_presupuestaria, codigo_ruta, estado_funcional
                )
                values(
                   v_asignacion.id_uo, 		v_asignacion.id_funcionario,			'01/01/2020'::date,
                   v_asignacion.fecha_finalizacion,v_id_cargo,				v_asignacion.observaciones_finalizacion,
                   v_asignacion.nro_documento_asignacion,v_asignacion.fecha_documento_asignacion,p_id_usuario,
                   v_asignacion.tipo, v_asignacion.certificacion_presupuestaria, v_asignacion.codigo_ruta, 'activo'
                );

            end if;*/

            --(franklin.espinoza) se obtiene el nombre para el item
        	select tc.nombre into v_nombre_cargo
            from orga.ttemporal_cargo tc
            where tc.id_temporal_cargo = v_parametros.id_temporal_cargo;

			--Sentencia de la modificacion
			update orga.tcargo set
			id_temporal_cargo = v_parametros.id_temporal_cargo,
            nombre = v_nombre_cargo,
			id_lugar = v_id_lugar,
			codigo = v_parametros.codigo,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_oficina = v_parametros.id_oficina,
      id_escala_salarial = v_parametros.id_escala_salarial/*,
      estado_reg = 'inactivo'*/
			where id_cargo=v_parametros.id_cargo;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cargo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cargo',v_parametros.id_cargo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'OR_CARGO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		14-01-2014 19:16:06
	***********************************/

	elsif(p_transaccion='OR_CARGO_ELI')then

		begin

			if (exists (select 1 from orga.tuo_funcionario
						where estado_reg = 'activo' and (fecha_finalizacion > now()::date or fecha_finalizacion is null)
							and id_cargo = v_parametros.id_cargo))then
				raise exception 'No es posible eliminar un cargo asignado a un empleado';
			end if;
			--Sentencia de la eliminacion
			update orga.tcargo
			set estado_reg = 'inactivo'
            where id_cargo=v_parametros.id_cargo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cargo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cargo',v_parametros.id_cargo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
	/**********************************
 	#TRANSACCION:  'OR_CARGO_CLONAR'
 	#DESCRIPCION:	Permite clonar los presupuestos a la siguiente gestion
 	#AUTOR:		franklin.espinoza
 	#FECHA:		27-12-2019 19:16:06
	***********************************/

	elsif(p_transaccion='OR_CARGO_CLONAR')then

		begin

			for v_funcionarios in /*select
                                    vf.id_funcionario,
                                    cargo.id_cargo,
                                    cargo.id_uo,
                                    cargo.id_tipo_contrato,
                                    cargo.id_lugar,
                                    cargo.id_temporal_cargo,
                                    cargo.id_escala_salarial,
                                    cargo.codigo,
                                    cargo.nombre as cargo,
                                    cargo.fecha_ini,
                                    cargo.estado_reg,
                                    cargo.fecha_fin,
                                    cargo.fecha_reg,
                                    cargo.id_usuario_reg,
                                    cargo.fecha_mod,
                                    cargo.id_usuario_mod,
                                    usu1.cuenta as usr_reg,
                                    usu2.cuenta as usr_mod,

                                    tipcon.nombre as nombre_tipo_contrato,
                                    escsal.nombre as nombre_escala,
                                    ofi.nombre as nombre_oficina,
                                    cargo.id_oficina,
                                    cargo.id_cargo as identificador,
                                    tipcon.codigo as codigo_tipo_contrato,
                                    vf.desc_funcionario1::varchar as desc_func,
                                    tuo.fecha_asignacion,
                                    tuo.fecha_finalizacion
                                    from orga.tcargo cargo
                                    inner join segu.tusuario usu1 on usu1.id_usuario = cargo.id_usuario_reg
                                    left join segu.tusuario usu2 on usu2.id_usuario = cargo.id_usuario_mod
                                    inner join orga.ttipo_contrato tipcon on tipcon.id_tipo_contrato = cargo.id_tipo_contrato
                                    inner join orga.tescala_salarial escsal on escsal.id_escala_salarial = cargo.id_escala_salarial
                                    LEFT join orga.toficina ofi on ofi.id_oficina = cargo.id_oficina
                                    left join orga.tcargo_presupuesto tcp on tcp.id_cargo = cargo.id_cargo and tcp.id_gestion = 19
                                    LEFT join orga.tuo_funcionario tuo on tuo.id_cargo = cargo.id_cargo and  (tuo.fecha_finalizacion is null or current_date<=tuo.fecha_finalizacion)
                                    LEFT join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
                                    where cargo.estado_reg = 'activo' and tipcon.codigo != 'PCP' and tuo.tipo = 'oficial' and tuo.estado_reg = 'activo' and (tcp.id_cargo_presupuesto is null or tcp.id_ot is null)*/
                                   select vf.id_funcionario,
                                   cargo.id_cargo,
                                   cargo.id_uo,
                                   cargo.id_tipo_contrato,
                                   cargo.id_lugar,
                                   cargo.id_temporal_cargo,
                                   cargo.id_escala_salarial,
                                   cargo.codigo,
                                   cargo.nombre as cargo,
                                   cargo.fecha_ini,
                                   cargo.estado_reg,
                                   cargo.fecha_fin,
                                   cargo.fecha_reg,
                                   cargo.id_usuario_reg,
                                   cargo.fecha_mod,
                                   cargo.id_usuario_mod,
                                   usu1.cuenta as usr_reg,
                                   usu2.cuenta as usr_mod,
                                   tipcon.nombre as nombre_tipo_contrato,
                                   escsal.nombre as nombre_escala,
                                   ofi.nombre as nombre_oficina,
                                   cargo.id_oficina,
                                   cargo.id_cargo as identificador,
                                   tipcon.codigo as codigo_tipo_contrato,
                                   vf.desc_funcionario1::varchar as desc_func,
                                   tuo.fecha_asignacion,
                                   tuo.fecha_finalizacion
                                  from orga.tcargo cargo
                                  inner join segu.tusuario usu1 on usu1.id_usuario = cargo.id_usuario_reg
                                  left join segu.tusuario usu2 on usu2.id_usuario = cargo.id_usuario_mod
                                  inner join orga.ttipo_contrato tipcon on tipcon.id_tipo_contrato = cargo.id_tipo_contrato
                                  inner join orga.tescala_salarial escsal on escsal.id_escala_salarial = cargo.id_escala_salarial
                                  LEFT join orga.toficina ofi on ofi.id_oficina = cargo.id_oficina
                                  left join orga.tcargo_presupuesto tcp on tcp.id_cargo = cargo.id_cargo and tcp.id_gestion = 19
                                  LEFT join orga.tuo_funcionario tuo on tuo.id_cargo = cargo.id_cargo and (tuo.fecha_finalizacion is null or current_date <= tuo.fecha_finalizacion)
                                  LEFT join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
                                  where cargo.estado_reg = 'activo' and tipcon.codigo != 'PCP' and
                                  (tcp.id_cargo_presupuesto is null and tcp.id_ot is null and tuo.id_uo_funcionario is null) loop

                select
                  tcp.id_cargo,
                  tcp.id_gestion,
                  tcp.id_centro_costo,
                  tcp.porcentaje,
                  tcp.fecha_ini,
                  tcp.fecha_fin,
                  tcp.id_ot
              	into v_presupuesto
                from orga.tcargo_presupuesto tcp
                where tcp.id_cargo = v_funcionarios.identificador and tcp.id_gestion = 17 and (tcp.fecha_fin is null or tcp.fecha_fin between '01/01/2019'::date and '31/12/2019'::date);



                select tpi.id_presupuesto_dos
                into v_id_presupuesto
                from pre.tpresupuesto_ids tpi
                where tpi.id_presupuesto_uno = v_presupuesto.id_centro_costo;

                select tcc.id_gestion
                into v_id_gestion
                from param.tcentro_costo tcc
                where tcc.id_centro_costo = v_id_presupuesto;
              	--raise notice 'v_contador: %, v_presupuesto: %, v_id_presupuesto: %, v_id_gestion: %',v_contador, v_presupuesto, v_id_presupuesto, v_id_gestion;
                v_contador = v_contador + 1;

                IF v_id_presupuesto IS NULL THEN
      				    CONTINUE;
                END IF;
                /*insert into orga.tcargo_presupuesto(
                  id_cargo,
                  id_gestion,
                  id_centro_costo,
                  porcentaje,
                  fecha_ini,
                  estado_reg,
                  id_usuario_reg,
                  fecha_reg,
                  fecha_mod,
                  id_usuario_mod,
                  id_ot,
                  fecha_fin
                ) values(
                  v_funcionarios.identificador,
                  v_id_gestion,
                  v_id_presupuesto,
                  v_presupuesto.porcentaje,
                  '01/01/2020'::date,
                  'activo',
                  p_id_usuario,
                  now(),
                  null,
                  null,
                  v_presupuesto.id_ot,
                  '31/12/2020'::date
                );*/
            end loop;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cargo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cargo','0'::varchar);

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