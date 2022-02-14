CREATE OR REPLACE FUNCTION orga.f_get_ultima_asignacion (
  p_id_funcionario integer
)
RETURNS integer AS
$body$
DECLARE

  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_id_uo_funcionario		integer;
  v_consulta 				varchar;
BEGIN

  v_nombre_funcion = 'orga.f_get_ultima_asignacion';

   --raise notice 'p_id_funcionario Ultima: %', p_id_funcionario;
   select tuo.id_uo_funcionario
   into v_id_uo_funcionario
   from orga.tuo_funcionario tuo
   inner join orga.tcargo tc on tc.id_cargo = tuo.id_cargo
   inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato
   where tuo.id_funcionario = p_id_funcionario and tuo.estado_reg = 'activo' and tuo.tipo = 'oficial' and ttc.codigo in ('PLA', 'EVE')
   order by tuo.fecha_asignacion desc limit 1;

  return v_id_uo_funcionario;



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

ALTER FUNCTION orga.f_get_ultima_asignacion (p_id_funcionario integer)
  OWNER TO postgres;