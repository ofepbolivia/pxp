CREATE OR REPLACE FUNCTION param.f_get_periodo_anual (
  p_gestion integer,
  p_periodo integer
)
RETURNS TABLE (
  periodo integer
) AS
$body$
 /**************************************************************************
  SISTEMA:        Sistema de Parametros
 FUNCION:         param.f_get_periodo_anual
 DESCRIPCION:   Funcion que devuelve conjuntos de de id periodos a partir de la seleccion del combo box de peridos de bancarizacion
 AUTOR:          Alan
 FECHA:            29-10-2019 11:00:00
 COMENTARIOS:
***************************************************************************/
DECLARE
	v_nombre_funcion   	text;
  v_periodo varchar;
  v_tabla record;
  v_per 	integer;
  v_gestion  integer;
  v_resp				varchar;
BEGIN

v_nombre_funcion:='param.f_get_periodo_anual';
if p_periodo = 0 THEN
		return query
         select per.id_periodo as periodo
    	 from param.tperiodo per
         where per.id_gestion = p_gestion
         limit 12;
ELSE
		return query select per.id_periodo as periodo
    	 from param.tperiodo per
         where per.id_periodo=p_periodo;
end if;

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
COST 100 ROWS 1000;

ALTER FUNCTION param.f_get_periodo_anual (p_gestion integer, p_periodo integer)
  OWNER TO postgres;