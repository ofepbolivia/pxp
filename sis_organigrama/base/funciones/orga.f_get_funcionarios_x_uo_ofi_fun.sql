CREATE OR REPLACE FUNCTION orga.f_get_funcionarios_x_uo_ofi_fun (
  p_id_uo integer,
  p_fecha date
)
RETURNS integer [] AS
$body$
/**************************************************************************
 SISTEMA:		ORGANIGRAMA
 FUNCION: 		orga.f_get_funcionarios_x_uo_ofi_fun
 DESCRIPCION:   funcion que retorna los funcionarios asignados a la uo
 AUTOR: 		maylee.perez
 FECHA:	       10-08-2021
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE
  v_id_empleado				integer;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_mensaje_error         	text;
BEGIN
  v_nombre_funcion = 'orga.f_get_funcionarios_x_uo_ofi_fun';
  select
     pxp.aggarray (asig.id_funcionario)
  into
      v_resp
  from orga.tuo_funcionario asig
  where
         asig.fecha_asignacion <= p_fecha
     and coalesce(asig.fecha_finalizacion, p_fecha)>=p_fecha
     and asig.estado_reg = 'activo'
     and asig.tipo = 'oficial'
     and asig.id_uo = p_id_uo;

     IF (v_resp is null) THEN

           select  pxp.aggarray (asig.id_funcionario)
           into  v_resp
           from orga.tuo_funcionario asig
           where asig.fecha_asignacion <= p_fecha
           and coalesce(asig.fecha_finalizacion, p_fecha)>=p_fecha
           and asig.estado_reg = 'activo'
           and asig.tipo = 'funcional'
           and asig.id_uo = p_id_uo;

     END IF;


  return v_resp::varchar;
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
