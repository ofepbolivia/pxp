CREATE OR REPLACE FUNCTION orga.f_get_ultima_fecha_finalizacion (
  p_id_funcionario integer
)
RETURNS date AS
$body$
DECLARE

  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_fecha_finalizacion		date;
  v_consulta 				varchar;
BEGIN

  v_nombre_funcion = 'orga.f_get_ultima_fecha_finalizacion';


   select coalesce(tuo.fecha_finalizacion, '31/12/9999'::date)
   into v_fecha_finalizacion
   from orga.tuo_funcionario tuo
   inner join orga.tcargo tc on tc.id_cargo = tuo.id_cargo
   inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato
   where tuo.id_funcionario = p_id_funcionario and tuo.estado_reg = 'activo' and tuo.tipo = 'oficial' and ttc.codigo in ('PLA', 'EVE')
   order by tuo.fecha_asignacion desc limit 1;

  return v_fecha_finalizacion;



EXCEPTION
WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
END;
$body$
LANGUAGE 'plpgsql'
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;