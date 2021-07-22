CREATE OR REPLACE FUNCTION orga.ft_uo_funcionario_ime (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla varchar,
  par_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
     FUNCION: 		orga.ft_uofunc_ime
     DESCRIPCIÓN:   modificaciones de funciones
     AUTOR: 	    KPLIAN (mzm)
     FECHA:
     COMENTARIOS:
    ***************************************************************************
     HISTORIA DE MODIFICACIONES:

     DESCRIPCION:
     AUTOR:
     FECHA:		03-06-2011
     ***************************************************************************/
  DECLARE


    v_parametros                record;
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_mensaje_error             text;

    v_id_uo  				integer;
    v_id_funcionario integer;

    --10abr12
    v_respuesta_sinc       varchar;
    v_id_uo_funcionario     integer;
    v_mail_resp				varchar;
    v_cargo					record;
    v_id_alarma				integer;
    v_id_gestion			integer;
	v_data_func				record;

	v_contador				integer = 0;
	v_tipo            varchar;

	v_numero_contrato       varchar;
    v_nro_documento_asignacion  varchar;
  BEGIN

    v_nombre_funcion:='orga.ft_uo_funcionario_ime';
    v_parametros:=pxp.f_get_record(par_tabla);


    /*******************************
    #TRANSACCION:  RH_UOFUNC_INS
    #DESCRIPCION:	Inserta uos funcionario
    #AUTOR:		KPLIAN (mzm)
    #FECHA:		25-06-2011
   ***********************************/
    if(par_transaccion='RH_UOFUNC_INS')then


      BEGIN

        -- verificar si la uo permite multiples asignaciones de funcionario
        --RAC NO ESTA FUNCIOANNDO ESTO DEL CARGO INDIVIDUAL
        if (select count(*)=1
           from orga.tuo_funcionario where id_uo=v_parametros.id_uo and estado_reg='activo' and tipo = 'oficial' and (fecha_finalizacion is null or current_date <= fecha_finalizacion) and
            id_uo=(select id_uo from orga.tuo where  id_uo=v_parametros.id_uo and estado_reg='activo' and cargo_individual='si') AND v_parametros.tipo = 'oficial') then
                      raise exception 'El cargo es individual y ya existe otro funcionario asignado actualmente';
        end if;

        --insercion de nuevo uo
        if exists (select 1 from orga.tuo_funcionario where id_funcionario=v_parametros.id_funcionario and
        id_uo=v_parametros.id_uo and estado_reg='activo' and tipo = 'oficial' and (fecha_finalizacion > current_date or fecha_finalizacion is null)) AND v_parametros.tipo = 'oficial' then
           raise exception 'Insercion no realizada. El funcionacio ya esta asignado a la unidad';
        end if;

        --verficar que el funcionario no este activo en dos unidades simultaneamente
		    select count(ouf.id_funcionario)
        into v_contador
        from orga.tuo_funcionario  ouf
        where ouf.id_funcionario=v_parametros.id_funcionario and ouf.estado_reg='activo' and ouf.tipo = 'oficial' and
        ouf.estado_funcional = 'activo' and (ouf.fecha_finalizacion > current_date or fecha_finalizacion is null);

         if v_contador > 0 AND v_parametros.tipo = 'oficial' then
			    raise exception 'El Funcionario se encuentra en otro cargo vigente primero inactive su asignacion actual';
         end if;

        v_mail_resp = pxp.f_get_variable_global('orga_mail_resp_cargo_presupuesto');

        select po_id_gestion from into v_id_gestion
        param.f_get_periodo_gestion(v_parametros.fecha_asignacion);

        if (v_mail_resp is not null and v_mail_resp != '' ) then
        	if(not exists (select 1
            	from orga.tcargo_presupuesto cp
                where estado_reg = 'activo' and cp.id_cargo = v_parametros.id_cargo
                and cp.id_gestion = v_id_gestion) ) then

                select *,tc.codigo as tipo_contrato into v_cargo
                from orga.tcargo c
                inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
                where c.id_cargo = v_parametros.id_cargo;

                if (v_cargo.tipo_contrato in ('PLA','EVE')) then
                	v_id_alarma = (select param.f_inserta_alarma_dblink (1,'Cargo asignado sin asignacion presupuestaria',
                    		'El cargo ' || v_cargo.nombre || '  con numero de item ' || v_cargo.codigo || ' e identificador ' || v_cargo.id_cargo || ' , no tiene relacion presupuestaria y ha sido asignado a un empleado. Favor realizar la asignacion',
                            v_mail_resp));
            	end if;
            end if;
        end if;

        if (v_parametros.fecha_finalizacion is not null and v_parametros.fecha_finalizacion <= v_parametros.fecha_asignacion)then
          raise exception 'La fecha de finalización no puede ser menor o igual a la fecha de asignación';
        end if;



        select tuo.id_uo_funcionario, vf.desc_funcionario1 as nombre_func,
        date_trunc('month',tuo.fecha_asignacion)::date as fecha_ini,
        (date_trunc('month',tuo.fecha_asignacion) +'1month' ::interval -'1sec' ::interval)::date as fecha_fin
        into v_data_func
        from orga.tuo_funcionario tuo
        inner join orga.vfuncionario vf on vf.id_funcionario = tuo.id_funcionario
        where tuo.id_funcionario = v_parametros.id_funcionario and tuo.id_cargo = v_parametros.id_cargo and tuo.estado_reg = 'activo' and
        (v_parametros.fecha_asignacion between date_trunc('month',tuo.fecha_asignacion) and date_trunc('month',tuo.fecha_asignacion) +'1month' ::interval -'1sec' ::interval)
        limit 1;

        if  v_data_func is not null then
          raise exception 'Estimado Usuario: Ya registro una asignación para el funcionario, % en el intervalo de fechas: de % a % ',v_data_func.nombre_func,
          to_char(v_data_func.fecha_ini,'dd/mm/yyyy'), to_char(v_data_func.fecha_fin,'dd/mm/yyyy');
        end if;

        INSERT INTO orga.tuo_funcionario
        (	id_uo, 						id_funcionario, 						fecha_asignacion,
           fecha_finalizacion,			id_cargo,								observaciones_finalizacion,
           nro_documento_asignacion,	fecha_documento_asignacion,				id_usuario_reg,
           tipo, certificacion_presupuestaria, codigo_ruta, estado_funcional)
        values(		v_parametros.id_uo, 		v_parametros.id_funcionario,			v_parametros.fecha_asignacion,
                   v_parametros.fecha_finalizacion,v_parametros.id_cargo,				v_parametros.observaciones_finalizacion,
                   v_parametros.nro_documento_asignacion,v_parametros.fecha_documento_asignacion,par_id_usuario,
                   v_parametros.tipo, v_parametros.certificacion_presupuestaria, v_parametros.codigo_ruta, v_parametros.estado_funcional)
        RETURNING id_uo_funcionario INTO v_id_uo_funcionario;


        --10-04-2012: sincronizacion de UO entre BD
        /* v_respuesta_sinc:=orga.f_sincroniza_uo_empleado_entre_bd(v_id_uo_funcionario,'10.172.0.13','5432','db_link','db_link','dbendesis' ,'INSERT');

         if(v_respuesta_sinc!='si')  then
            raise exception 'Sincronizacion de UO en BD externa no realizada%',v_respuesta_sinc;
         end if;*/

        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Asignacion empleado-uo registrada con exito: Funcionario ('|| (select desc_funcionario1 from orga.vfuncionario where id_funcionario=v_parametros.id_funcionario) || ') - UO'|| (select nombre_unidad from orga.tuo where id_uo=v_parametros.id_uo));
        v_resp = pxp.f_agrega_clave(v_resp,'id_uo',v_id_uo::varchar);
      END;
    /*******************************
    #TRANSACCION:  RH_UOFUNC_MOD
    #DESCRIPCION:	Modifica la parametrizacion seleccionada
    #AUTOR:		KPLIAN (mzm)
    #FECHA:		03-06-2011
   ***********************************/
    elsif(par_transaccion='RH_UOFUNC_MOD')then


      BEGIN
        -- raise exception 'rererer: % % %',v_parametros.id_uo,v_parametros.estado_reg,v_parametros.id_funcionario;
        /*if ( select count(*)=1 from
                     orga.tuo_funcionario
                     where    id_uo=v_parametros.id_uo
                          and estado_reg=v_parametros.estado_reg and
                              id_funcionario!=v_parametros.id_funcionario and
                              id_uo=(select id_uo from orga.tuo where estado_reg='activo' and cargo_individual='si')
                              and id_uo=v_parametros.id_uo) then

                     raise exception 'El cargo es individual y ya existe otro funcionario asignado actualmente';
         end if;*/


        --verficar que el funcionario no este activo en dos unidades simultaneamente
        --raise exception '%    %',v_parametros.id_funcionario,v_parametros.id_uo;
        /*if ( ((select count(id_funcionario) from
          orga.tuo_funcionario  a
        where a.id_funcionario=v_parametros.id_funcionario
              and a.estado_reg = 'activo' and
              a.fecha_finalizacion > v_parametros.fecha_asignacion
              and a.id_uo != v_parametros.id_uo))>0) then

          select tuo.tipo
          into v_tipo
          from orga.tuo_funcionario tuo
          where tuo.id_uo_funcionario = v_parametros.id_uo_funcionario;

          if v_tipo = 'oficial' then
			      raise exception 'El Funcionario se encuentra en otro cargo vigente primero inactive su asignacion actual';
          end if;
        end if;*/



        --si el estado es inactivo == la fecha finalizacion debe ser llenada


        if (v_parametros.fecha_finalizacion is not null and v_parametros.fecha_finalizacion <= v_parametros.fecha_asignacion)then
          raise exception 'La fecha de finalización no puede ser menor o igual a la fecha de asignación';
        end if;

        update orga.tuo_funcionario
        set
          observaciones_finalizacion = v_parametros.observaciones_finalizacion,
          nro_documento_asignacion = v_parametros.nro_documento_asignacion,
          fecha_documento_asignacion = v_parametros.fecha_documento_asignacion,
          fecha_finalizacion = v_parametros.fecha_finalizacion,
          certificacion_presupuestaria = v_parametros.certificacion_presupuestaria,
          codigo_ruta = v_parametros.codigo_ruta,
          estado_funcional = v_parametros.estado_funcional,
          fecha_asignacion = v_parametros.fecha_asignacion,
          id_cargo = v_parametros.id_cargo,
          id_usuario_mod = par_id_usuario,
          fecha_mod = now()
        where id_uo=v_parametros.id_uo
              and id_uo_funcionario=v_parametros.id_uo_funcionario;

        --10-04-2012: sincronizacion de UO entre BD
        /*                v_respuesta_sinc:=orga.f_sincroniza_uo_empleado_entre_bd(v_parametros.id_uo_funcionario,'10.172.0.13','5432','db_link','db_link','dbendesis' ,'UPDATE');

                        if(v_respuesta_sinc!='si')  then
                          raise exception 'Sincronizacion de UO en BD externa no realizada%',v_respuesta_sinc;
                        end if;*/

        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Modificacion a asignacion empleado-uo modificada con exito '||v_parametros.id_uo_funcionario||': Funcionario ('|| (select desc_funcionario1 from orga.vfuncionario where id_funcionario=v_parametros.id_funcionario) || ') - UO'|| (select nombre_unidad from orga.tuo where id_uo=v_parametros.id_uo));
        v_resp = pxp.f_agrega_clave(v_resp,'id_uo',v_parametros.id_uo::varchar);
      END;

    /*******************************
     #TRANSACCION:  RH_UOFUNC_ELI
     #DESCRIPCION:	Inactiva la parametrizacion selecionada
     #AUTOR:	    KPLIAN (mzm)
     #FECHA:		03-06-2011
    ***********************************/
    elsif(par_transaccion='RH_UOFUNC_ELI')then
      BEGIN

        --inactivacion de la uo
        select id_funcionario,id_uo
        into v_id_funcionario, v_id_uo
        from orga.tuo_funcionario
        where  id_uo_funcionario=v_parametros.id_uo_funcionario;

        --elimina siempre que puede: como el registro de uo_fun es referncial en ORGA, se posible eliminarlo todo el tiempo
        -- se debe cuidar q en el diseno cuando se requiera obtener la dependencia de un funcionario, se deb guardar la referencia vigente de uo_funcionario
        update orga.tuo_funcionario
        set estado_reg = 'inactivo'
        where id_uo_funcionario=v_parametros.id_uo_funcionario;

        --10-04-2012: sincronizacion de UO entre BD
        /* v_respuesta_sinc:=orga.f_sincroniza_uo_empleado_entre_bd(v_parametros.id_uo_funcionario,'10.172.0.13','5432','db_link','db_link','dbendesis' ,'DELETE');

         if(v_respuesta_sinc!='si')  then
           raise exception 'Sincronizacion de UO en BD externa no realizada%',v_respuesta_sinc;
         end if;*/

        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','asignacion empleado-uo eliminada con exito '||v_parametros.id_uo_funcionario||': Funcionario ('|| (select desc_funcionario1 from orga.vfuncionario where id_funcionario=v_id_funcionario) || ') - UO'|| (select nombre_unidad from orga.tuo where id_uo=v_id_uo));
        v_resp = pxp.f_agrega_clave(v_resp,'id_uo',v_id_uo::varchar);

      END;
    /*******************************
     #TRANSACCION:  RH_NUM_CONTRATO_GET
     #DESCRIPCION:	Regupera el numero de contrato o genera uno nuevo
     #AUTOR:	    (franklin.espinoza)
     #FECHA:		14/07/2021
    ***********************************/
    elsif(par_transaccion='RH_NUM_CONTRATO_GET')then
      BEGIN

        select  cor.numero_contrato
        into v_numero_contrato
        from orga.tcorrelativo_contrato cor
        order by id_correlativo_contrato desc
        limit 1;

        select tuo.nro_documento_asignacion
        into v_nro_documento_asignacion
        from orga.tuo_funcionario tuo
        where tuo.nro_documento_asignacion = v_numero_contrato;

        if v_parametros.momento = 'new'  and v_nro_documento_asignacion is not null then
            v_numero_contrato = param.f_obtener_correlativo(
                                    'CONTRATO',
                                    null,
                                    null,
                                    null,
                                    par_id_usuario,
                                    'ORGA',
                                    null,0,0,'orga.tuo_funcionario'
                                );
            INSERT INTO orga.tcorrelativo_contrato  (numero_contrato) values (v_numero_contrato);
        end if;


        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','numero contrato recuperado con exito.');
        v_resp = pxp.f_agrega_clave(v_resp,'v_numero_contrato',v_numero_contrato::varchar);

      END;

    else

      raise exception 'No existe la transaccion: %',par_transaccion;
    end if;

    return v_resp;

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