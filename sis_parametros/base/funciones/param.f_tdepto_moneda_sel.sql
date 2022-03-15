CREATE OR REPLACE FUNCTION param.f_tdepto_moneda_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Parametros Generales
 FUNCION:         param.f_tdepto_moneda_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'param.tdepto_moneda'
 AUTOR:          Maylee Perez Pastor
 FECHA:            08-09-2020 18:26:47
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;

BEGIN

    v_nombre_funcion = 'param.f_tdepto_moneda_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PM_DEPMONEDA_SEL'
     #DESCRIPCION:    Consulta de datos
      #AUTOR:        maylee.perez
     #FECHA:        08-09-2020 18:26:47
    ***********************************/

    if(p_transaccion='PM_DEPMONEDA_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
                              depmon.id_depto_moneda,
                              depmon.estado_reg,
                              depmon.id_depto,
                              depmon.id_usuario_reg,
                              depmon.fecha_reg,
                              depmon.id_usuario_mod,
                              depmon.fecha_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                              depmon.id_moneda,
                              mon.moneda,
                              mon.codigo

                        from param.tdepto_moneda depmon
                        inner join param.tmoneda mon on mon.id_moneda = depmon.id_moneda
                        inner join segu.tusuario usu1 on usu1.id_usuario = depmon.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = depmon.id_usuario_mod
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            if (pxp.f_existe_parametro(p_tabla,'id_depto')) then
                v_consulta:= v_consulta || ' and depmon.id_depto='||v_parametros.id_depto;
            end if;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PM_DEPMONEDA_CONT'
     #DESCRIPCION:    Conteo de registros
      #AUTOR:        maylee.perez
     #FECHA:        08-09-2020 18:26:47
    ***********************************/

    elsif(p_transaccion='PM_DEPMONEDA_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(depmon.id_depto_moneda)
                         from param.tdepto_moneda depmon
                        inner join param.tmoneda mon on mon.id_moneda = depmon.id_moneda
                        inner join segu.tusuario usu1 on usu1.id_usuario = depmon.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = depmon.id_usuario_mod
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            if (pxp.f_existe_parametro(p_tabla,'id_depto')) then
                v_consulta:= v_consulta || ' and depmon.id_depto='||v_parametros.id_depto;
            end if;
            --Devuelve la respuesta
            return v_consulta;

        end;

    else

        raise exception 'Transaccion inexistente';

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
COST 100;
