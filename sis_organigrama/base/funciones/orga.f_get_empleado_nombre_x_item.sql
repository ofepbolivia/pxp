CREATE OR REPLACE FUNCTION orga.f_get_empleado_nombre_x_item (
  p_id_cargo integer,
  p_fecha date = now()
)
RETURNS varchar AS
$body$
DECLARE
  v_funcionario				varchar;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
BEGIN
  v_nombre_funcion = 'orga.f_get_empleado_nombre_x_item';
  v_funcionario = NULL;
  select vf.desc_funcionario2::varchar
  into v_funcionario
  from orga.tuo_funcionario asig
  inner join orga.vfuncionario vf on vf.id_funcionario = asig.id_funcionario
  where asig.id_cargo = p_id_cargo and asig.fecha_asignacion <= p_fecha
  	and (asig.fecha_finalizacion >= p_fecha or asig.fecha_finalizacion is null) and
    asig.tipo = 'oficial' and asig.estado_reg = 'activo';

  return v_funcionario;

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