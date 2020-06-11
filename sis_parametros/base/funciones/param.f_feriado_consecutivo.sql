CREATE OR REPLACE FUNCTION param.f_feriado_consecutivo (
  p_fecha date
)
RETURNS date AS
$body$
/**************************************************************************
 SISTEMA:        Parametros
 FUNCION:        param.f_feriado_consecutivo
 DESCRIPCION:    Funcion que devuelve la fecha siguiente a feriados concecutivos.
 AUTOR:          FEA
 FECHA:          21/02/2018
 COMENTARIOS:
**************************************************************************/

DECLARE

    v_nombre_funcion  varchar;
    v_consulta        varchar;
    v_parametros      record;
    v_record          record;
    v_respuesta		  varchar;
    v_fecha_actual    date;
	v_cont 			  integer;
    v_feriado		  boolean;
BEGIN
    v_nombre_funcion='param.f_feriado_consecutivo';

      /*select count(tf.id_feriado)
      into v_cont
      from rec.tferiado tf
      where tf.dia::integer = date_part('day',p_fecha) and tf.mes::integer = date_part('month',p_fecha);*/
      v_fecha_actual = p_fecha;
      if (date_part('dow', p_fecha) in (1,2,3,4))then
          v_fecha_actual = v_fecha_actual + 1;
      elsif (date_part('dow', v_fecha_actual) = 5) then
          v_fecha_actual = v_fecha_actual + 3;
      end if;
	  raise notice 'v_fecha_actual pppppp: %', v_fecha_actual;
      if(param.f_es_feriado(v_fecha_actual))then raise notice 'es feriado';
      	return param.f_feriado_consecutivo(v_fecha_actual);
      else
      	return v_fecha_actual;
      end if;

EXCEPTION
  WHEN OTHERS THEN
    v_respuesta='';
    v_respuesta=pxp.f_agrega_clave(v_respuesta,'mensaje',SQLERRM);
    v_respuesta=pxp.f_agrega_clave(v_respuesta,'codigo_error',SQLSTATE);
    v_respuesta=pxp.f_agrega_clave(v_respuesta,'procedimiento',v_nombre_funcion);
    raise exception '%',v_respuesta;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;