CREATE OR REPLACE FUNCTION segu.ft_certificados_seguridad_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Seguridad
 FUNCION: 		segu.ft_certificados_seguridad_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'segu.tcertificados_seguridad'
 AUTOR: 		 (breydi.vasquez)
 FECHA:	        03-11-2021 15:36:08
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				03-11-2021 15:36:08								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'segu.tcertificados_seguridad'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'segu.ft_certificados_seguridad_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SG_CERS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		03-11-2021 15:36:08
	***********************************/

	if(p_transaccion='SG_CERS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cers.id_certificado_seguridad,
						cers.estado_reg,
                        cat.descripcion as titular_certificado,
						cat1.descripcion as entidad_certificadora,
						cers.nro_serie,
						cers.fecha_emision,
						cers.fecha_vencimiento,
						cat2.descripcion as tipo_certificado,
						cers.clave_publica,
						cers.ip_servidor,
						cers.observaciones,
						cers.notificacion_vencimiento,
						cers.area_de_uso,
						cers.dias_anticipacion_alerta,
                        cers.id_funcionario_resp,
                        fun.desc_funcionario1 as desc_funcionario,
                        array_to_string(cers.id_funcionario_cc,'','')::varchar as id_funcionario_cc,
                        (select pxp.list(email_empresa) from orga.vfuncionario_persona p where p.id_funcionario =ANY(cers.id_funcionario_cc))::varchar as email_cc,
                        cers.estado_notificacion,
						cers.id_usuario_reg,
						cers.fecha_reg,
						cers.id_usuario_ai,
						cers.usuario_ai,
						cers.id_usuario_mod,
						cers.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cers.id_proceso_wf,
                        cers.id_estado_wf,
                        cers.id_titular_certificado,
                        cers.id_entidad_certificadora,
                        cers.id_tipo_certificado
						from segu.tcertificados_seguridad cers
						inner join segu.tusuario usu1 on usu1.id_usuario = cers.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cers.id_usuario_mod
                        inner join orga.vfuncionario fun on fun.id_funcionario = cers.id_funcionario_resp
                        inner join wf.testado_wf w on w.id_estado_wf = cers.id_estado_wf
                        inner join param.tcatalogo cat on cat.id_catalogo = cers.id_titular_certificado                        
                        inner join param.tcatalogo cat1 on cat1.id_catalogo = cers.id_entidad_certificadora
                        inner join param.tcatalogo cat2 on cat2.id_catalogo = cers.id_tipo_certificado                        
				        where cers.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'SG_CERS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		03-11-2021 15:36:08
	***********************************/

	elsif(p_transaccion='SG_CERS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_certificado_seguridad)
					    from segu.tcertificados_seguridad cers
					    inner join segu.tusuario usu1 on usu1.id_usuario = cers.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cers.id_usuario_mod
                        inner join orga.vfuncionario fun on fun.id_funcionario = cers.id_funcionario_resp 
                        inner join wf.testado_wf w on w.id_estado_wf = cers.id_estado_wf                        
                        inner join param.tcatalogo cat on cat.id_catalogo = cers.id_titular_certificado                        
                        inner join param.tcatalogo cat1 on cat1.id_catalogo = cers.id_entidad_certificadora
                        inner join param.tcatalogo cat2 on cat2.id_catalogo = cers.id_tipo_certificado                        
					    where cers.estado_reg = ''activo'' and ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
        
	/*********************************    
 	#TRANSACCION:  'SG_CERSNOTF_SEL'
 	#DESCRIPCION:	consulta datos para notificacion 
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		04-11-2021
	***********************************/        
	elsif(p_transaccion='SG_CERSNOTF_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='SELECT	TO_JSON(ROW_TO_JSON(jsonD) :: TEXT) #>> ''{}'' as jsonData
                        FROM (
                            SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(tvalue_data))) as data
                            FROM (
                            SELECT
                              cers.id_certificado_seguridad,
                              cat.descripcion as titular_certificado,
                              cat1.descripcion as entidad_certificadora,
                              cers.nro_serie,
                              to_char(cers.fecha_emision, ''DD/MM/YYYY'') as fecha_emision,
                              to_char(cers.fecha_vencimiento, ''DD/MM/YYYY'') as fecha_vencimiento,
                              to_char(cers.notificacion_vencimiento, ''DD/MM/YYYY'') as notificacion_vencimiento,
						      cat2.descripcion as tipo_certificado,
                              cers.clave_publica,
                              cers.ip_servidor,
                              cers.observaciones,
                              cers.area_de_uso,
                              cers.dias_anticipacion_alerta,
                              fun.desc_funcionario1 as desc_funcionario,
                              (SELECT rp.email_empresa 
                               FROM orga.vfuncionario_persona rp 
                               WHERE rp.id_funcionario = cers.id_funcionario_resp
                               )::varchar as email_resp,
                              (array(
                                SELECT email_empresa 
                                FROM orga.vfuncionario_persona p
                                WHERE p.id_funcionario =ANY(cers.id_funcionario_cc)
                                ) 
                               ) as email_cc
                              from segu.tcertificados_seguridad cers
                              inner join orga.vfuncionario fun on fun.id_funcionario = cers.id_funcionario_resp
                              inner join param.tcatalogo cat on cat.id_catalogo = cers.id_titular_certificado                        
                              inner join param.tcatalogo cat1 on cat1.id_catalogo = cers.id_entidad_certificadora
                              inner join param.tcatalogo cat2 on cat2.id_catalogo = cers.id_tipo_certificado                              
                              where cers.estado_reg = ''activo''
                              and cers.estado_notificacion != ''enviado''
                              and current_date::date  = (fecha_vencimiento - cers.dias_anticipacion_alerta)::date
                              ) tvalue_data
                             )jsonD ';
			
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

ALTER FUNCTION segu.ft_certificados_seguridad_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;