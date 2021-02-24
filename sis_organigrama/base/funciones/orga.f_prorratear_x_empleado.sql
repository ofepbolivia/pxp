CREATE OR REPLACE FUNCTION orga.f_prorratear_x_empleado (
  p_id_periodo integer,
  p_monto numeric,
  p_codigo_prorrateo varchar,
  p_id_lugar integer,
  p_id_cuenta integer
)
RETURNS varchar AS
$body$
DECLARE
    v_resp		            varchar;
    v_nombre_funcion        	text;
    v_mensaje_error         	text;
    v_periodo					record;
    v_registros				record;
    v_funcionarios			record;
    v_cuentas					record;
    v_id_funcionario			integer;
    v_id_centro_costo			integer;
    v_id_oficina				integer;
    v_suma					numeric;
    v_sql_tabla				varchar;
    v_factor					numeric;
    v_tipo					varchar;
    v_id_ot					integer;
    v_id_cargo				integer;
    v_oficina					varchar;
    v_empleado				varchar;
    v_num_cuenta			varchar;

    v_sum_monto_prorra_ruta     record;
    v_total						numeric;
    v_importe_total_OD			numeric;
    v_factor_porcentual_prorrateo	numeric;
    v_temp_prorrateo_ruta		record;

    v_telefonia_detalle			record;
    v_importe_consumo			numeric;


  BEGIN

    v_nombre_funcion = 'orga.f_prorratear_x_empleado';
    --Crear tabla temporal con detalle costos
    v_sql_tabla = 'CREATE TEMPORARY TABLE tes_temp_prorrateo
    		(	id_tabla INTEGER,
            	id_funcionario INTEGER,
                id_centro_costo INTEGER,
                monto NUMERIC(18,2),
                descripcion TEXT,
                id_orden_trabajo INTEGER
  			) ON COMMIT DROP';

    select * into v_periodo
    from param.tperiodo
    where id_periodo = p_id_periodo;

    EXECUTE(v_sql_tabla);
    if (p_codigo_prorrateo = 'PCELULAR' or p_codigo_prorrateo = 'P4G'  or p_codigo_prorrateo = 'PFIJO') then
      v_tipo = 'celular';
    if (p_codigo_prorrateo = 'P4G') then
      v_tipo = '4g';
    elsif (p_codigo_prorrateo = 'PFIJO') then
      v_tipo = 'fijo';
    end if;

      v_suma = 0;
      for v_registros in ( select * ,
      							count(nc.id_numero_celular) OVER () as total,
                                row_number() OVER () as conteo,
                                sum(consumo) OVER() as suma_total
                          from gecom.tconsumo c
                            inner join gecom.tnumero_celular nc on c.id_numero_celular = nc.id_numero_celular
                          where id_periodo = p_id_periodo  and nc.tipo = v_tipo) loop


        --may 01-02-2021
        --PARA TIPO PRORRATEO p_codigo_prorrateo = 'PFIJO'
        IF (p_codigo_prorrateo = 'PFIJO') THEN

              --PARA LOS QUE EXISTAN EN LA TABLA RUTAS(con factor porcentual segun centro de costos)
              IF exists(select 1
                        from gecom.truta rut
                        inner join param.tperiodo per on per.id_gestion = rut.id_gestion
                        where rut.id_numero_celular = v_registros.id_numero_celular
                        and per.id_periodo = p_id_periodo
                        and rut.id_numero_celular is not null
                        group by rut.id_numero_celular  ) THEN


                  v_id_funcionario = gecom.f_get_ultimo_funcionario_asignado(v_registros.id_numero_celular,p_id_periodo);


                  select f.desc_funcionario1
                  into v_empleado
                  from orga.vfuncionario f
                  where f.id_funcionario = v_id_funcionario;

                  v_id_centro_costo = null;

                  --sum total de solo el prorrateo
                  SELECT sum(pdet.costo_llamada)
                  INTO v_total
                  FROM gecom.tpago_telefonia_det pdet
                  left join gecom.tpago_telefonia pt on pt.id_pago_telefonia = pdet.id_pago_telefonia
                  left join gecom.truta rut on rut.nro_ruta = pdet.ruta and rut.cod_compania = pdet.cod_compania
                  left join gecom.tnumero_celular numcel on numcel.id_numero_celular = rut.id_numero_celular
                  WHERE  numcel.id_numero_celular = v_registros.id_numero_celular
                  and pt.id_periodo = p_id_periodo;

                  --sum total deconsumo segun el numero
                  SELECT consu.consumo
                  INTO v_importe_consumo
                  FROM gecom.tconsumo consu
                  WHERE  consu.id_numero_celular = v_registros.id_numero_celular
                  and consu.id_periodo = p_id_periodo
                  limit 1;

                  --raise exception 'llegaav_totalOD %',v_total;

                  FOR v_telefonia_detalle in (select  NULL,
                                                      pdet.id_centro_costo,
                                                      NULL,--ccot.id_orden_trabajo
                                                      sum(pdet.costo_llamada) as monto

                                                from gecom.tpago_telefonia_det pdet
                                                left join gecom.tpago_telefonia pt on pt.id_pago_telefonia = pdet.id_pago_telefonia

                                                left join gecom.truta rut on rut.nro_ruta = pdet.ruta and rut.cod_compania = pdet.cod_compania
                                                left join gecom.tnumero_celular numcel on numcel.id_numero_celular = rut.id_numero_celular

                                                left join param.tcentro_costo cc on cc.id_centro_costo = pdet.id_centro_costo

                                                where numcel.id_numero_celular = v_registros.id_numero_celular
                                                and pt.id_periodo = p_id_periodo

                                                group by pdet.id_centro_costo) LOOP

                           --raise exception 'llega % - %',v_telefonia_detalle.id_centro_costo, v_telefonia_detalle.monto;
                           --raise notice 'llegabdww % - % - %', v_registros.id_numero_celular, v_telefonia_detalle.id_centro_costo, v_telefonia_detalle.monto;
                            if (v_telefonia_detalle.id_centro_costo is null) then
                              raise exception 'No tiene asignado un centro de costo';
                            end if;


                      		IF (v_total = 0)THEN
                            	v_total = 1;
                            ELSE
                            	v_total = v_total;
                            END IF;
                            v_factor_porcentual_prorrateo = ( (v_telefonia_detalle.monto * 100) / coalesce(v_total, 1) );
                      --raise notice 'llegabdww % - % - % - %', v_registros.id_numero_celular, v_telefonia_detalle.monto, v_total, round((v_factor_porcentual_prorrateo),2);
                            --para la OP
                            v_importe_total_OD =  ( (coalesce(v_importe_consumo,0) * coalesce(v_factor_porcentual_prorrateo,0)) / 100 );
                          --raise notice 'llegabd333 % - %',v_registros.id_numero_celular, v_importe_total_OD;
                           --raise exception 'llegaav_totalOD %',v_importe_total_OD;

                           --raise exception 'llegabd333 % - % - % - %',v_registros.total,v_registros.conteo,v_suma,p_monto ;
                           --raise notice 'llegabd333 % - %',v_registros.total, v_registros.conteo;
                           if (v_registros.total = v_registros.conteo) then


                                 insert into gecom.tes_temp_prorrateo_ruta ( id_tabla,
                                                                        id_funcionario,
                                                                        id_centro_costo,
                                                                        monto,
                                                                        id_orden_trabajo,
                                                                        descripcion,
                                                                        id_periodo,
                                                                        ruta
                                                                        ) values (
                                                                        v_registros.id_numero_celular, --id_numero_celular,
                                                                        v_id_funcionario,
                                                                        v_telefonia_detalle.id_centro_costo,
                                                                        coalesce(v_importe_total_OD,0),
                                                                        NULL,--v_telefonia_detalle.id_orden_trabajo,
                                                                        'Prorrateo ' || p_codigo_prorrateo,
                                                                        p_id_periodo,
                                                                        'si'
                                                                        );

                               --v_suma = p_monto;
                              v_suma = v_suma + round((v_importe_total_OD),2);


                              --raise exception 'llegabd333 % - %',v_suma,  p_monto;
                         else

                         		insert into gecom.tes_temp_prorrateo_ruta ( id_tabla,
                                                                        id_funcionario,
                                                                        id_centro_costo,
                                                                        monto,
                                                                        id_orden_trabajo,
                                                                        descripcion,
                                                                        id_periodo,
                                                                        ruta
                                                                        ) values (
                                                                        v_registros.id_numero_celular, --id_numero_celular,
                                                                        v_id_funcionario,
                                                                        v_telefonia_detalle.id_centro_costo,
                                                                        coalesce(v_importe_total_OD,0),
                                                                        NULL,--v_telefonia_detalle.id_orden_trabajo,
                                                                        'Prorrateo ' || p_codigo_prorrateo,
                                                                        p_id_periodo,
                                                                        'si'
                                                                        );

                                v_suma = v_suma + round((v_importe_total_OD),2);

                         end if;


                  END LOOP;





                  /*--raise exception 'llegabd333 % - %',v_registros.total,  v_registros.conteo;
                  if (v_registros.total = v_registros.conteo) then



                    else

                      insert into gecom.tes_temp_prorrateo_ruta (id_tabla,
                                                      id_funcionario,
                                                      id_centro_costo,
                                                      monto,
                                                      id_orden_trabajo,
                                                      descripcion,
                                                      id_periodo

                                                      ) values (
                                                    v_registros.id_numero_celular,
                                                    v_id_funcionario,
                                                    v_id_centro_costo,
                                                    v_registros.consumo, --round((v_registros.consumo*v_factor),2),
                                                    v_id_ot,
                                                    'Prorrateo ' || p_codigo_prorrateo,
                                                    p_id_periodo

                                                    );

                      --v_suma = v_suma + round((v_registros.consumo*v_factor),2);
                      v_suma = v_registros.consumo;

                    end if;*/




              ---
              ELSE
              --(MAY) PARA LOS QUE  < NO >  EXISTAN EN LA TABLA RUTAS (la funcion no se modifica)
                  --raise exception 'llegabd22222 %',v_factor;

                    v_factor = (p_monto / v_registros.suma_total);

                    v_id_funcionario = gecom.f_get_ultimo_funcionario_asignado(v_registros.id_numero_celular,p_id_periodo);

                    if (v_id_funcionario is null) then
                      raise exception 'No existe un funcionario asignado para el nro % en el periodo %,%,%',v_registros.numero,v_periodo.periodo,v_registros.id_numero_celular,p_id_periodo;
                    end if;
                    v_id_centro_costo = null;
                    v_id_centro_costo = null;

                    select po_id_cargo,po_id_centro_costo,po_id_ot into v_id_cargo,v_id_centro_costo,v_id_ot
                    from orga.f_get_ultimo_centro_costo_funcionario(v_id_funcionario,p_id_periodo);

                    select f.desc_funcionario1 into v_empleado
                    from orga.vfuncionario f
                    where f.id_funcionario = v_id_funcionario;

                    if (v_id_centro_costo is null) then
                      raise exception 'Existe un empleado que no tiene asignado centro de costo o ya no tiene un contrato activo en la empresa : %',v_empleado;
                    end if;

                    if (v_id_ot is null) then
                      raise exception 'Existe un empleado que no tiene asignado ot o ya no tiene un contrato activo en la empresa : %',v_empleado;
                    end if;

					--raise exception 'llega7 % - %',p_monto, v_suma;
                    if (v_registros.total = v_registros.conteo) then
                      insert into tes_temp_prorrateo (id_tabla,
                                                      id_funcionario,
                                                      id_centro_costo,
                                                      monto,
                                                      id_orden_trabajo,
                                                      descripcion
                                                      )
                                                    values (
                                                    v_registros.id_numero_celular,
                                                    v_id_funcionario,
                                                    v_id_centro_costo,
                                                    p_monto - v_suma ,
                                                    v_id_ot,
                                                    'Prorrateo ' || p_codigo_prorrateo
                                                    );
                      if (v_registros.suma_total != p_monto) then
                        v_resp ='El monto de la factura no iguala con la suma del consumo por numero. Monto Factura : ' || p_monto || ', Suma consumo por numero: ' || v_registros.suma_total || '. SE HA GENERADO EL PRORRATEO DE TODAS FORMAS!!!!';

                      else
                        v_resp ='exito';
                      end if;

                     -- v_suma = p_monto;
                      v_suma = p_monto - v_suma;

                    else

                      insert into tes_temp_prorrateo (id_tabla,
                                                      id_funcionario,
                                                      id_centro_costo,
                                                      monto,
                                                      id_orden_trabajo,
                                                      descripcion
                                                      )
                                                    values (
                                                    v_registros.id_numero_celular,
                                                    v_id_funcionario,
                                                    v_id_centro_costo,
                                                    round((v_registros.consumo*v_factor),2),
                                                    v_id_ot,
                                                    'Prorrateo ' || p_codigo_prorrateo
                                                    );

                      v_suma = v_suma + round((v_registros.consumo*v_factor),2);

                    end if;

              END IF;

        ELSE
        	--PARA TIPO PRORRATEO p_codigo_prorrateo = 'PCELULAR' or p_codigo_prorrateo = 'P4G'
        	v_factor = (p_monto / v_registros.suma_total);

            v_id_funcionario = gecom.f_get_ultimo_funcionario_asignado(v_registros.id_numero_celular,p_id_periodo);

            if (v_id_funcionario is null) then
              raise exception 'No existe un funcionario asignado para el nro % en el periodo %,%,%',v_registros.numero,v_periodo.periodo,v_registros.id_numero_celular,p_id_periodo;
            end if;
            v_id_centro_costo = null;
            v_id_centro_costo = null;

            select po_id_cargo,po_id_centro_costo,po_id_ot into v_id_cargo,v_id_centro_costo,v_id_ot
            from orga.f_get_ultimo_centro_costo_funcionario(v_id_funcionario,p_id_periodo);

            select f.desc_funcionario1 into v_empleado
            from orga.vfuncionario f
            where f.id_funcionario = v_id_funcionario;

            if (v_id_centro_costo is null) then
              raise exception 'Existe un empleado que no tiene asignado centro de costo o ya no tiene un contrato activo en la empresa : %',v_empleado;
            end if;

            if (v_id_ot is null) then
              raise exception 'Existe un empleado que no tiene asignado ot o ya no tiene un contrato activo en la empresa : %',v_empleado;
            end if;

            if (v_registros.total = v_registros.conteo) then
              insert into tes_temp_prorrateo (id_tabla,
                                              id_funcionario,
                                              id_centro_costo,
                                              monto,
                                              id_orden_trabajo,
                                              descripcion
                                              )
                                            values (
                                            v_registros.id_numero_celular,
                                            v_id_funcionario,
                                            v_id_centro_costo,
                                            p_monto - v_suma ,
                                            v_id_ot,
                                            'Prorrateo ' || p_codigo_prorrateo
                                            );
              if (v_registros.suma_total != p_monto) then
                v_resp ='El monto de la factura no iguala con la suma del consumo por numero. Monto Factura : ' || p_monto || ', Suma consumo por numero: ' || v_registros.suma_total || '. SE HA GENERADO EL PRORRATEO DE TODAS FORMAS!!!!';

              else
                v_resp ='exito';
              end if;

              v_suma = p_monto;

            else
              insert into tes_temp_prorrateo (id_tabla,
                                              id_funcionario,
                                              id_centro_costo,
                                              monto,
                                              id_orden_trabajo,
                                              descripcion
                                              )
                                            values (
                                            v_registros.id_numero_celular,
                                            v_id_funcionario,
                                            v_id_centro_costo,
                                            round((v_registros.consumo*v_factor),2),
                                            v_id_ot,
                                            'Prorrateo ' || p_codigo_prorrateo
                                            );

              v_suma = v_suma + round((v_registros.consumo*v_factor),2);

            end if;

        END IF;




      end loop;

    elsif (p_codigo_prorrateo = 'POFI') then

      /*Obtener el id_oficina a partir de la cuenta*/
      select id_oficina,nro_cuenta into v_id_oficina,v_num_cuenta
      from orga.toficina_cuenta
      where id_oficina_cuenta = p_id_cuenta;

      /*Obtener funcionarios activos al ultimo dia del mes que se encuentran en la oficina v_id_oficina*/
      v_suma = 0;
      for v_funcionarios in (
        select id_funcionario, count(id_funcionario) OVER () as total,row_number() OVER () as numero
        from orga.tuo_funcionario uofun
          inner join orga.tcargo car
            on uofun.id_cargo = car.id_cargo
          inner join orga.ttipo_contrato tc
            on tc.id_tipo_contrato = car.id_tipo_contrato and tc.codigo in ('PLA','EVE')
        where uofun.fecha_asignacion <= v_periodo.fecha_fin AND
              (uofun.fecha_finalizacion >= v_periodo.fecha_fin or uofun.fecha_finalizacion is NULL)
              and uofun.estado_reg = 'activo' and car.id_oficina = v_id_oficina )loop
        v_id_centro_costo = null;

        select po_id_cargo,po_id_centro_costo,po_id_ot into v_id_cargo,v_id_centro_costo,v_id_ot
        from orga.f_get_ultimo_centro_costo_funcionario(v_funcionarios.id_funcionario,p_id_periodo);

        select f.desc_funcionario1 into v_empleado
        from orga.vfuncionario f
        where f.id_funcionario = v_funcionarios.id_funcionario;

        if (v_id_centro_costo is null) then
          raise exception 'Existe un empleado que no tiene asignado centro de costo o ya no tiene un contrato activo en la empresa : %',v_empleado;
        end if;

        if (v_id_ot is null) then
          raise exception 'Existe un empleado que no tiene asignado ot o ya no tiene un contrato activo en la empresa : %',v_empleado;
        end if;

        if (v_funcionarios.total = v_funcionarios.numero) then

          insert into tes_temp_prorrateo (id_tabla,id_funcionario,id_centro_costo,monto,id_orden_trabajo,descripcion)
          values ( p_id_cuenta,v_funcionarios.id_funcionario,v_id_centro_costo,p_monto - v_suma,v_id_ot ,'Prorrateo por oficina: ' || v_oficina || ' cuenta: ' || v_num_cuenta);

          v_suma = p_monto;
        else
          insert into tes_temp_prorrateo (id_tabla,id_funcionario,id_centro_costo,monto,id_orden_trabajo,descripcion)
          values ( p_id_cuenta,v_funcionarios.id_funcionario,v_id_centro_costo,round((p_monto/v_funcionarios.total),2),v_id_ot,'Prorrateo por oficina: ' || v_oficina || ' cuenta: ' || v_num_cuenta);

          v_suma = v_suma + round((p_monto/v_funcionarios.total),2);
        end if;
      END LOOP;
      if (v_suma = 0) then
        raise exception 'No existe ningun empleado asignado a la oficina';
      end if;
      v_resp ='exito';

    elsif (p_codigo_prorrateo = 'PGLOBAL') then

      /*Obtener funcionarios activos al ultimo dia del mes*/
      v_suma = 0;
      for v_funcionarios in (
        select id_funcionario, count(id_funcionario) OVER () as total,row_number() OVER () as numero
        from orga.tuo_funcionario uofun
          inner join orga.tcargo car
            on uofun.id_cargo = car.id_cargo
          inner join orga.ttipo_contrato tc
            on tc.id_tipo_contrato = car.id_tipo_contrato and tc.codigo in ('PLA','EVE')
        where uofun.fecha_asignacion <= v_periodo.fecha_fin AND
              (uofun.fecha_finalizacion >= v_periodo.fecha_fin or uofun.fecha_finalizacion is NULL)
              and uofun.estado_reg = 'activo')loop
        v_id_centro_costo = null;
        select po_id_cargo,po_id_centro_costo,po_id_ot into v_id_cargo,v_id_centro_costo,v_id_ot
        from orga.f_get_ultimo_centro_costo_funcionario(v_funcionarios.id_funcionario,p_id_periodo);

        select f.desc_funcionario1 into v_empleado
        from orga.vfuncionario f
        where f.id_funcionario = v_funcionarios.id_funcionario;

        if (v_id_centro_costo is null) then
          raise exception 'Existe un empleado que no tiene asignado centro de costo o ya no tiene un contrato activo en la empresa : %',v_empleado;
        end if;

        if (v_id_ot is null) then
          raise exception 'Existe un empleado que no tiene asignado ot o ya no tiene un contrato activo en la empresa : %',v_empleado;
        end if;

        if (v_funcionarios.total = v_funcionarios.numero) then

          insert into tes_temp_prorrateo (id_tabla,id_funcionario,id_centro_costo,monto,id_orden_trabajo)
          values ( p_id_cuenta,v_funcionarios.id_funcionario,v_id_centro_costo,p_monto - v_suma,v_id_ot );

          v_suma = p_monto;
        else
          insert into tes_temp_prorrateo (id_tabla,id_funcionario,id_centro_costo,monto,id_orden_trabajo)
          values ( p_id_cuenta,v_funcionarios.id_funcionario,v_id_centro_costo,round((p_monto/v_funcionarios.total),2),v_id_orden_trabajo);

          v_suma = v_suma + round((p_monto/v_funcionarios.total),2);
        end if;
      END LOOP;


    else
      raise exception 'No existe el tipo de prorrateo: %',p_codigo_prorrateo;
    end if;


      --raise exception 'llegabd333fin %',v_suma;
      v_resp ='exito';

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
