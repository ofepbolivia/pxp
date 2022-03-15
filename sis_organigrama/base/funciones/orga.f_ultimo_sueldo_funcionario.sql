CREATE OR REPLACE FUNCTION orga.f_ultimo_sueldo_funcionario (
  p_id_funcionario integer,
  p_fecha_solicitud date
)
RETURNS numeric AS
$body$
DECLARE
  v_resp   				numeric;
  v_saldo				numeric;
  v_id_periodo			integer;
  v_fecha_planilla		date;
  v_fecha_ultima		date;
BEGIN


        select p.id_periodo
        	into v_id_periodo
        from param.tperiodo p
        where (p_fecha_solicitud - interval '1 month') between p.fecha_ini and p.fecha_fin;

        select distinct  p.fecha_planilla
        	into v_fecha_planilla
        from plani.tplanilla p
        inner join plani.ttipo_planilla tp on tp.id_tipo_planilla = p.id_tipo_planilla
        where tp.codigo = 'PLASUE'
        and p.id_periodo = v_id_periodo;

	if v_fecha_planilla is null then
    	v_resp = null;
    else
        select
        round(colval.valor,2)
        into v_resp
        from plani.tcolumna_valor colval
        inner join plani.tfuncionario_planilla funpla on funpla.id_funcionario_planilla = colval.id_funcionario_planilla
        inner join plani.tplanilla pla on pla.id_planilla = funpla.id_planilla and pla.id_tipo_planilla = 1
        where  funpla.id_funcionario = p_id_funcionario
        and colval.codigo_columna = 'COTIZABLE'
        and pla.fecha_planilla = v_fecha_planilla;

    end if;

	if v_resp is null then

       		select max(pla.fecha_planilla)
             into v_fecha_ultima
            from plani.tcolumna_valor colval
            inner join plani.tfuncionario_planilla funpla on funpla.id_funcionario_planilla = colval.id_funcionario_planilla
            inner join plani.tplanilla pla on pla.id_planilla = funpla.id_planilla and pla.id_tipo_planilla = 1
            where  funpla.id_funcionario = p_id_funcionario
            and colval.codigo_columna = 'COTIZABLE';

            select
            round(colval.valor,2)
            into v_saldo
            from plani.tcolumna_valor colval
            inner join plani.tfuncionario_planilla funpla on funpla.id_funcionario_planilla = colval.id_funcionario_planilla
            inner join plani.tplanilla pla on pla.id_planilla = funpla.id_planilla and pla.id_tipo_planilla = 1
            where  funpla.id_funcionario = p_id_funcionario
            and colval.codigo_columna = 'COTIZABLE'
            and pla.fecha_planilla = v_fecha_ultima;



    else
     v_saldo = v_resp;
    end if;


  return v_saldo;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;
