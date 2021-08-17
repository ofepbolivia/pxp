CREATE OR REPLACE FUNCTION orga.f_rellenar_ceros_numero_contrato (
  p_campo varchar,
  p_ceros integer
)
RETURNS varchar AS
$body$
DECLARE

v_resp				varchar;
v_nombre_funcion 	varchar;

v_campo				varchar;
v_numero_array		varchar [];

BEGIN

	v_nombre_funcion = 'orga.f_rellenar_ceros_numero_contrato';

	v_numero_array = string_to_array(p_campo,'.');

	v_numero_array[4] = LPAD(v_numero_array[4], p_ceros, '0');

	v_campo = array_to_string(v_numero_array,'.')::varchar;

	return  v_campo;
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