CREATE OR REPLACE FUNCTION param.f_sumar_dias_habiles (
  p_fecha date,
  p_dias integer
)
RETURNS date AS
$body$
/**************************************************************************
 SISTEMA:        Parametros
 FUNCION:        param.f_sumar_dias_habiles
 DESCRIPCION:    Funcion que devuelve la fecha fin de una fecha inicio sumandole solo dias habiles
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
	v_fecha_feriado	  date;
BEGIN
    v_nombre_funcion='param.f_sumar_dias_habiles';
    v_fecha_actual = p_fecha;
    if date_part('dow', v_fecha_actual) in (6) then
    	v_fecha_actual = v_fecha_actual + 1;
    end if;
    for v_dia in 1..p_dias loop
    	if date_part('dow', v_fecha_actual) in (1,2,3,4,0) then
        	raise notice 'v_fecha_actual 1: %', v_fecha_actual;
        	v_fecha_actual = v_fecha_actual + 1;
            --raise notice 'dia(1,2,3,4): % ----> fecha: %', v_dia, v_fecha_actual;
            if(param.f_es_feriado(v_fecha_actual))then
            	--raise notice 'feriado (1,2,3,4): %', v_fecha_actual;
            	v_fecha_actual = param.f_feriado_consecutivo(v_fecha_actual);
            end if;
        elsif date_part('dow', v_fecha_actual) = 5 then
        	raise notice 'v_fecha_actual 2: %', v_fecha_actual;
        	v_fecha_actual = v_fecha_actual + 3;
            --raise notice 'dia(5): % ----> fecha: %', v_dia, v_fecha_actual;
            if(param.f_es_feriado(v_fecha_actual))then
            	--raise notice 'feriado (5): %', v_fecha_actual;
                v_fecha_actual = param.f_feriado_consecutivo(v_fecha_actual);
            end if;
        end if;

        raise notice 'v_dia: %, %',v_dia, v_fecha_actual;
    end loop;
    return v_fecha_actual::date;

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