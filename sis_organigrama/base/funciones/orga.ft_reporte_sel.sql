CREATE OR REPLACE FUNCTION orga.ft_reporte_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Recursos Humanos
 FUNCION: 		orga.ft_reporte_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'orga.ft_reporte_sel'
 AUTOR: 		(fea)
 FECHA:	        18-04-2018 17:29:14
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
	v_filtro			varchar = '';
    v_mes				integer;
    v_fechas			record;
    v_id_gestion 		integer;
BEGIN

	v_nombre_funcion = 'orga.ft_reporte_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'OR_R_MAIL_BOA_SEL'
 	#DESCRIPCION:	reporte de correos de funcionario boa
 	#AUTOR:		f.e.a
 	#FECHA:		18-04-2018 17:29:14
	***********************************/

	if(p_transaccion='OR_R_MAIL_BOA_SEL')then

    	begin

            if(v_parametros.oficina != '0')then
            	v_filtro = ' and tl.id_lugar in ( '||v_parametros.oficina||')';
            end if;

            v_mes = date_part('month', current_date);

            select tg.id_gestion
            into v_id_gestion
            from param.tgestion tg
            where tg.gestion = date_part('year', current_date);

            select tp.fecha_ini, tp.fecha_fin
            into v_fechas
            from param.tperiodo tp
            where tp.periodo = v_mes and tp.id_gestion = v_id_gestion;


    		--Sentencia de la consulta
			v_consulta:='select distinct (''(''||tuo.codigo||'')''||tuo.nombre_unidad)::varchar as gerencia,
             ttc.nombre as contrato ,
             tf.desc_funcionario1::varchar AS desc_funcionario,
             tc.nombre as cargo,
             tl.nombre as lugar,
             tl.codigo,
             tf.email_empresa
             from orga.vfuncionario_cargo tf
             inner JOIN orga.tuo_funcionario uof ON uof.id_funcionario = tf.id_funcionario --and (current_date <= uof.fecha_finalizacion or  uof.fecha_finalizacion is null)
             inner JOIN orga.tuo tuo on tuo.id_uo = orga.f_get_uo_gerencia(uof.id_uo,uof.id_funcionario,current_date)
             inner JOIN orga.tcargo tc ON tc.id_cargo = uof.id_cargo
             inner join param.tlugar tl on tl.id_lugar = tc.id_lugar
             inner join orga.ttipo_contrato ttc on ttc.id_tipo_contrato = tc.id_tipo_contrato
             where tc.estado_reg = ''activo'' and ttc.codigo in (''PLA'',''EVE'',''PEXT'', ''PEXTE'') and uof.tipo = ''oficial'' and
             uof.estado_reg != ''inactivo'' and uof.fecha_asignacion <= '''||v_fechas.fecha_fin||'''::date and
             (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= '''||v_fechas.fecha_ini||'''::date)'||v_filtro||'
             order by tl.codigo, gerencia, desc_funcionario';

			--Definicion de la respuesta
			--v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			RAISE NOTICE 'v_consulta: %', v_consulta;
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