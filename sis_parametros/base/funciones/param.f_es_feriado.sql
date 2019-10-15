CREATE OR REPLACE FUNCTION param.f_es_feriado (
  p_fecha date
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:        Parametros
 FUNCION:        param.f_es_feriado
 DESCRIPCION:    Funcion que devuelve true o false si es feriado un fecha especifica.
 AUTOR:          FEA
 FECHA:          21/02/2018
 COMENTARIOS:
**************************************************************************/

DECLARE

    v_nombre_funcion  varchar;
    v_consulta        varchar;
    v_cont			  integer;
    v_respuesta       varchar;
    --v_id_gestion	  integer;
BEGIN
    v_nombre_funcion='param.f_es_feriado';

      /*select tg.id_gestion
      into v_id_gestion
      from param.tgestion tg
      where tg.gestion = date_part('year', p_fecha);*/

      select count(tf.id_feriado)
      into v_cont
      from rec.tferiados tf
      where tf.fecha = p_fecha and tf.tipo = 0;

      if(v_cont>0)then
      	return true;
      else
      	return false;
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