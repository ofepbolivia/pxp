CREATE OR REPLACE FUNCTION orga.ft_base_operativa_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.ft_base_operativa_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.ft_base_operativa_sel'
 AUTOR: 		(franklin.espinoza)
 FECHA:	        06-11-2021 15:14:58
 COMENTARIOS:
 ***************************************************************************/

  DECLARE

	v_consulta    		varchar;
    v_parametros  		record;
    v_nombre_funcion   	text;
    v_resp				varchar;


  BEGIN

    v_nombre_funcion = 'orga.ft_base_operativa_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ORGA_BASE_OPE_SEL'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		franklin.espinoza
     #FECHA:		06-11-2021 15:14:58
    ***********************************/
    if(p_transaccion='ORGA_BASE_OPE_SEL')then

      begin
      	--Sentencia de la consulta
        v_consulta:='select
                        base.id_funcionario_oficina,
						base.fecha_ini,
                    	base.fecha_fin,
                        base.id_funcionario,
                        base.id_oficina,
                        base.observaciones,
                        base.estado_reg,
                        base.id_usuario_reg
						from orga.tfuncionario_oficina base
            			where ';
        v_consulta = v_consulta||v_parametros.filtro;
      	v_consulta = v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
        --Devuelve la respuesta
        return v_consulta;
      end;

    /*********************************
     #TRANSACCION:  'ORGA_BASE_OPE_CONT'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		franklin.espinoza
     #FECHA:		06-11-2021 15:14:58
    ***********************************/
    elsif(p_transaccion='ORGA_BASE_OPE_CONT')then

      begin
      	--Sentencia de la consulta
        v_consulta = 'select count(base.id_funcionario_oficina)
					 from orga.tfuncionario_oficina base
            		 where ';
        v_consulta = v_consulta||v_parametros.filtro;
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

ALTER FUNCTION orga.ft_base_operativa_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;