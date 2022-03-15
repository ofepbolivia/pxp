CREATE OR REPLACE FUNCTION orga.f_get_funcionario_base_operativa (
  p_id_funcionario integer
)
RETURNS varchar AS
$body$
DECLARE
  v_base_operativa			varchar;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;

BEGIN
  v_nombre_funcion = 'orga.f_get_funcionario_base_operativa';
  v_base_operativa = NULL;

  select tlu.nombre
  into v_base_operativa
  from orga.tfuncionario_oficina tf
  inner join param.tlugar tlu on tlu.id_lugar = tf.id_lugar
  where tf.id_funcionario = p_id_funcionario and current_date between tf.fecha_ini and tf.fecha_fin
  order by /*tf.fecha_ini*/tf.id_funcionario_oficina desc
  limit 1;

  return coalesce(v_base_operativa,'NO TIENE');

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

ALTER FUNCTION orga.f_get_funcionario_base_operativa (p_id_funcionario integer)
  OWNER TO postgres;