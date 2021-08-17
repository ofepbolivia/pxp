CREATE OR REPLACE FUNCTION orga.f_get_empleado_presupuesto_x_periodo (
  p_id_funcionario integer,
  p_fecha_ini date,
  p_fecha_fin date
)
RETURNS varchar AS
$body$
DECLARE
  v_centro_costo			varchar;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
BEGIN
  v_nombre_funcion = 'orga.f_get_presupuesto_x_perido';
  v_centro_costo = NULL;
select '( '||ttc.codigo || ' )'||ttc.descripcion
into v_centro_costo
from orga.tuo_funcionario asig
inner join orga.tcargo_presupuesto car on car.id_cargo = asig.id_cargo and car.id_gestion = 20 and
--car.fecha_ini between p_fecha_ini and p_fecha_fin
(car.fecha_ini <= p_fecha_fin and car.fecha_ini >= '01/01/2021'::date)
inner join param.tcentro_costo cos on cos.id_centro_costo = car.id_centro_costo
inner join param.ttipo_cc ttc on ttc.id_tipo_cc = cos.id_tipo_cc
where asig.id_funcionario = p_id_funcionario and asig.tipo = 'oficial' and asig.estado_reg = 'activo' and
((coalesce(asig.fecha_finalizacion,'31/12/9999'::date) between '01/01/2021'::date and '28/02/2021'::date) or (coalesce(asig.fecha_finalizacion,'31/12/9999'::date) between '01/03/2021'::date and '31/12/9999'::date));

  return v_centro_costo;

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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;