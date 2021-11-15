CREATE OR REPLACE FUNCTION param.ft_registrar_periodos_automaticamente (
  p_gestion integer
)
RETURNS varchar AS
$body$
DECLARE
v_id_gestion 			integer;
v_fecha_ini 			date;
v_fecha_fin 			date;
v_cont 					integer;
v_id_periodo			integer;
v_rec					record;
v_registros				record;
v_departamentos_conta	record;
BEGIN
			--raise exception 'Empieza data';

			--(1) Validación de existencia de la gestión
            if exists(select 1 from param.tgestion
            		where gestion = p_gestion) THEN
              return 'existe_gestion';
            end if;

        	--(2) Sentencia de la insercion
        	insert into param.tgestion(
			id_moneda_base,
			id_empresa,
			estado_reg,
			estado,
			gestion,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
            tipo
          	) values(
			1,
			1,
			'activo',
			'activo',
			p_gestion,
			now(),
			1,
			null,
			null,
            'MES'
			) returning id_gestion into v_id_gestion;

			--(3) Generación de los Períodos y Períodos Subsistema
            v_cont =1;

            while v_cont <= 12 loop



	            --Obtención del primer día del mes correspondiente a la fecha_ini
	            v_fecha_ini= ('01-'||v_cont||'-'||p_gestion)::date;

	            --Obtención el último dia del mes correspondiente a la fecha_fin
	            v_fecha_fin=(date_trunc('MONTH', v_fecha_ini) + INTERVAL '1 MONTH - 1 day')::date;

	            insert into param.tperiodo(
                  id_usuario_reg,
                  id_usuario_mod,
                  fecha_reg,
                  fecha_mod,
                  estado_reg,
                  periodo,
                  id_gestion,
                  fecha_ini,
                  fecha_fin
                ) VALUES (
                  1,
                  NULL,
                  now(),
                  NULL,
                  'activo',
                  v_cont,
                  v_id_gestion,
                  v_fecha_ini,
                  v_fecha_fin
                ) returning id_periodo into v_id_periodo;

                --Registro de los periodos de los subsistemas existentes
                for v_rec in (select id_subsistema
                			from segu.tsubsistema
                			where estado_reg = 'activo'
                			and codigo not in ('PXP','GEN','SEGU','WF','PARAM','ORGA','MIGRA')) loop
                	insert into param.tperiodo_subsistema(
                	id_periodo,
                	id_subsistema,
                	estado,
                	id_usuario_reg,
                	fecha_reg
                	) values(
                	v_id_periodo,
                	v_rec.id_subsistema,
                	'cerrado',
                	1,
                	now()
                	);


                end loop;

               v_cont=v_cont+1;

            END LOOP;


            /*Aqui para registrar los periodos de todos los subsistemas que pertenecen a Contabilidad*/

            for v_departamentos_conta in (
                                          select dep.id_depto,
                                                 dep.codigo
                                          from param.tdepto dep
                                          where dep.id_subsistema = (select sis.id_subsistema
                                                                     from segu.tsubsistema sis
                                                                     where sis.codigo = 'CONTA')
            ) LOOP

                      FOR v_registros in  (
                          select
                              per.id_periodo
                          from param.tperiodo as per
                          where per.estado_reg = 'activo'
                          and per.id_periodo not in (
                              select pcv.id_periodo
                              from conta.tperiodo_compra_venta pcv
                              inner join param.tperiodo p2 on p2.id_periodo = pcv.id_periodo
                              where pcv.id_depto = v_departamentos_conta.id_depto
                              and p2.id_gestion = v_id_gestion
                          ) and per.id_gestion = v_id_gestion
                      ) LOOP

                        INSERT INTO  conta.tperiodo_compra_venta
                                  (
                                    id_usuario_reg,
                                    fecha_reg,
                                    estado_reg,
                                    id_depto,
                                    id_periodo,
                                    estado
                                  )
                                  VALUES (
                                     1,
                                     now(),
                                    'activo',
                                    v_departamentos_conta.id_depto,
                                    v_registros.id_periodo,
                                    'abierto'
                                  );

                      END LOOP;
            END LOOP;
            /*****************************************************************************************/



    return 'Registro de periodos Correctamente';
EXCEPTION
	WHEN OTHERS THEN

            return SQLERRM;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION param.ft_registrar_periodos_automaticamente (p_gestion integer)
  OWNER TO postgres;
