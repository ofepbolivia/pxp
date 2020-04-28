CREATE OR REPLACE FUNCTION wf.ft_num_tramite_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Work Flow
 FUNCION: 		wf.f_num_tramite_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'wf.tnum_tramite'
 AUTOR: 		 (FRH)
 FECHA:	        19-02-2013 13:51:54
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

    --breydi vasquez (20/04/2020)
    v_index				integer;    
    v_sistemas			varchar[];
			    
BEGIN

	v_nombre_funcion = 'wf.ft_num_tramite_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'WF_NUMTRAM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		19-02-2013 13:51:54
	***********************************/

	if(p_transaccion='WF_NUMTRAM_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						numtram.id_num_tramite,
						numtram.id_proceso_macro,
						numtram.estado_reg,
						numtram.id_gestion,
						numtram.num_siguiente,
						numtram.fecha_reg,
						numtram.id_usuario_reg,
						numtram.id_usuario_mod,
						numtram.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        ges.gestion::varchar AS desc_gestion,
                        (prom.codigo||lpad(COALESCE(numtram.num_siguiente, 0)::varchar,6,''0'')||ges.gestion)::varchar AS codificacion_siguiente                      
						from wf.tnum_tramite numtram
						inner join segu.tusuario usu1 on usu1.id_usuario = numtram.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = numtram.id_usuario_mod
                        INNER JOIN param.tgestion ges on ges.id_gestion = numtram.id_gestion
                        INNER JOIN wf.tproceso_macro prom on prom.id_proceso_macro =  numtram.id_proceso_macro
				        WHERE  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'WF_NUMTRAM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		19-02-2013 13:51:54
	***********************************/

	elsif(p_transaccion='WF_NUMTRAM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_num_tramite)
					    from wf.tnum_tramite numtram
					    inner join segu.tusuario usu1 on usu1.id_usuario = numtram.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = numtram.id_usuario_mod
                        INNER JOIN param.tgestion ges on ges.id_gestion = numtram.id_gestion
                        INNER JOIN wf.tproceso_macro prom on prom.id_proceso_macro =  numtram.id_proceso_macro
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
/*********************************    
 	#TRANSACCION:  'WF_TRAPRBXFUN_SEL'
 	#DESCRIPCION:	Consulta para reporte de tramites aprobado por funcionario
 	#AUTOR:		breydi vasquez 	
 	#FECHA:		15-04-2020
	***********************************/

	elsif(p_transaccion='WF_TRAPRBXFUN_SEL')then
     				
    	begin
                
			-- tabla temporal 
            CREATE TEMPORARY TABLE temp_tramites_aprobados_x_funcionario (
                                            nro_tramite				varchar,
                                            fecha_ini				timestamp,
                                            fecha_fin				timestamp,
                                            anterior_estado			varchar,
                                            seguiente_estado		varchar,
                                            proveido				text,
                                            funcionario_aprobador	text,   
                                            solicitante				text,                               
                                            proveedor				varchar,                                                                  
                                            justificacion			varchar,
                                            importe					numeric,                                            
                                            moneda					varchar,
                                            contador_estados        bigint                                     
                                           ) ON COMMIT DROP;    
                                                       
			-- sistemas leccionados en la interfaz 
            	if v_parametros.sistema_rep = 'todos' then
	                v_sistemas  = string_to_array('v_org,v_adq,v_obl,v_alm,v_kaf,v_ctr,v_pls,v_fea,v_prs,v_sdc,v_gro,v_gsm'::text, ',');                	
                else
                    v_sistemas  = string_to_array(v_parametros.sistema_rep::text, ',');
                end if;
                


			-- recorrido de sistemas para reporte  para insercion de datos 
                
            	FOR v_index IN 1..array_length(v_sistemas, 1)                        
                                              
                 loop
                 
                    if v_sistemas[v_index] = 'v_org' then   
                    
					   ----------ORGANIGRAMA: REGISTRO ESQUEMA ORG--------------------------------------
	             	   -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario 
                            
                              WITH wf_estado as (
                                    select 
                                    	  ewf.id_usuario_reg,
                                          ewf.id_estado_wf,
                                          ewf.id_estado_anterior,
                                          ewf.fecha_reg,
                                          ewf.id_tipo_estado,
                                          ewf.obs,
                                          pwf.nro_tramite,
                                          pwf.id_proceso_wf,
                                          te.nombre_estado,                                          
                                          (select count(*)
                                          from unnest(id_tipo_estado_wfs) elemento
                                          where elemento = ewf.id_tipo_estado) as contador_estados          
                                    FROM  wf.testado_wf ewf
                                    inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                    left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                    WHERE
                                          ewf.id_usuario_reg = v_parametros.id_usuario
                                          and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                          and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                          and substr(pwf.nro_tramite, 1, 3) = 'CT-'
                                    order by ewf.fecha_reg  
                                    )
                                  select  
                                          tid.nro_tramite,
                                          ewf.fecha_reg as fecha_ini,
                                          tid.fecha_reg as fecha_fin,                 
                                          te.nombre_estado as anterior_estado,
                                          tid.nombre_estado as seguiente_estado,
                                          tid.obs as proveido,
                                          usu.desc_persona as funcionario_aprobador,
                                          fun.desc_funcionario1 as solicitante,
                                          ''::varchar as proveedor,
                                          certi.tipo_certificado as justificacion,
                                          0.00::numeric as importe,
                                          ''::varchar as moneda,
                                          tid.contador_estados
                                                                                                                                                                                                                       
                                  from  wf_estado  tid
                                  inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                  inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                  left  join orga.tcertificado_planilla certi on certi.id_proceso_wf = tid.id_proceso_wf    
                                  left  join orga.vfuncionario fun on fun.id_funcionario = certi.id_funcionario
                                  where                                           
                                        certi.estado_reg = 'activo' and certi.estado != 'anulado'
                                        and certi.id_certificado_planilla is not null                   
                                                                     
                                  ORDER BY tid.nro_tramite desc, tid.fecha_reg desc;
                      
                    elsif  v_sistemas[v_index] = 'v_adq' then
                    
                           ---------------ADQUISICIONES: REGISTRO ESQUEMA ADQ-----------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario 
                            
                            (
                            ---------------------------Solicitud------------------ 
                              WITH wf_estado as (
                                select 
                                	  ewf.id_usuario_reg,
                                      ewf.id_estado_wf,
                                      ewf.id_estado_anterior,
                                      ewf.fecha_reg,
                                      ewf.id_tipo_estado,
                                      ewf.obs,
                                      pwf.nro_tramite,
                                      pwf.id_proceso_wf,
                                      te.nombre_estado,                                                                            
                                      (select count(*)
                                      from unnest(id_tipo_estado_wfs) elemento
                                      where elemento = ewf.id_tipo_estado) as contador_estados          
                                FROM  wf.testado_wf ewf
                                inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                WHERE
                                      ewf.id_usuario_reg = v_parametros.id_usuario
                                      and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                      and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                      and substr(pwf.nro_tramite, 1, 3) in ('CNA', 'CIN', 'GC-', 'GA-', 'GM-', 'GO-')
                                order by ewf.fecha_reg  
                                )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,
                                      usu.desc_persona as funcionario_aprobador,
                                      fun.desc_funcionario1 as  solicitante,
                                      pros.desc_proveedor as proveedor,
                                      sol.justificacion,
                                      (select sum(sd.precio_total)
                                       from adq.tsolicitud_det sd
                                       where sd.id_solicitud = sol.id_solicitud
                                       ) as importe,
                                       mons.codigo as moneda,
                                       tid.contador_estados
                                                                                                                                                                                                                 
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join adq.tsolicitud sol on sol.id_proceso_wf = tid.id_proceso_wf
                              left  join param.vproveedor pros on pros.id_proveedor = sol.id_proveedor
                              left  join param.tmoneda mons on mons.id_moneda = sol.id_moneda 
                              left  join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
                              where  
                              		sol.id_solicitud is not null
                                                               
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                            
                                                        
                            ) union (
                            
                           ---------------------------Proceso compra---------------  
                           
                              WITH wf_estado as (
                                select 
                                      ewf.id_usuario_reg,
                                      ewf.id_estado_wf,
                                      ewf.id_estado_anterior,
                                      ewf.fecha_reg,
                                      ewf.id_tipo_estado,
                                      ewf.obs,
                                      pwf.nro_tramite,
                                      pwf.id_proceso_wf,
                                      te.nombre_estado,                                      
                                      (select count(*)
                                      from unnest(id_tipo_estado_wfs) elemento
                                      where elemento = ewf.id_tipo_estado) as contador_estados          
                                FROM  wf.testado_wf ewf
                                inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                WHERE
                                      ewf.id_usuario_reg = v_parametros.id_usuario
                                      and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                      and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                      and substr(pwf.nro_tramite, 1, 3) in ('CNA', 'CIN', 'GC-', 'GA-', 'GM-', 'GO-')
                                order by ewf.fecha_reg  
                                )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,
                                      usu.desc_persona as funcionario_aprobador,
                                      funpcc.desc_funcionario1 as  solicitante,
                                      provcc.desc_proveedor as proveedor,
                                      solp.justificacion,
                                      (select sum(sd.precio_total)
                                        from adq.tsolicitud_det sd
                                        where sd.id_solicitud = solp.id_solicitud
                                        ) as importe, 
                                      moncc.codigo as moneda,          
                                      tid.contador_estados
                                                                                                                                                                                                                 
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join adq.tproceso_compra procc on procc.id_proceso_wf = tid.id_proceso_wf 
                              left  join adq.tsolicitud solp on solp.id_solicitud = procc.id_solicitud
                              left  join param.vproveedor provcc on provcc.id_proveedor = solp.id_proveedor
                              left  join param.tmoneda moncc on moncc.id_moneda = solp.id_moneda
                              left  join orga.vfuncionario funpcc on funpcc.id_funcionario = solp.id_funcionario 
                              where                                       
                                    procc.id_proceso_compra is not null
                                                               
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                              
                                                      
                            ) union (
                            
                            ---------------------------Cotizacion--------------- 
                            
                              WITH wf_estado as (
                                select
                                	  ewf.id_usuario_reg, 
                                      ewf.id_estado_wf,
                                      ewf.id_estado_anterior,
                                      ewf.fecha_reg,
                                      ewf.id_tipo_estado,
                                      ewf.obs,
                                      pwf.nro_tramite,
                                      pwf.id_proceso_wf,
                                      te.nombre_estado,
                                      (select count(*)
                                      from unnest(id_tipo_estado_wfs) elemento
                                      where elemento = ewf.id_tipo_estado) as contador_estados          
                                FROM  wf.testado_wf ewf
                                inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                WHERE
                                      ewf.id_usuario_reg = v_parametros.id_usuario
                                      and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                      and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                      and substr(pwf.nro_tramite, 1, 3) in ('CNA', 'CIN', 'GC-', 'GA-', 'GM-', 'GO-')
                                order by ewf.fecha_reg  
                                )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,
                                      usu.desc_persona as funcionario_aprobador,
                                      fun.desc_funcionario1 as solicitante,
                                      proc.desc_proveedor as proveedor,
                                      cot.obs as justificacion,
                                      (select sum(cd.cantidad_coti *cd.precio_unitario)
                                      from adq.tcotizacion_det cd
                                      where cd.id_cotizacion = cot.id_cotizacion) as importe,
                                      monc.codigo as moneda,                    
                                      tid.contador_estados
                                                                                                                                                                                                                 
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join adq.tcotizacion cot on cot.id_proceso_wf = tid.id_proceso_wf
                              left  join adq.tproceso_compra proce on proce.id_proceso_compra = cot.id_proceso_compra
                              left  join adq.tsolicitud sol on sol.id_solicitud = proce.id_solicitud    
                              left  join param.vproveedor proc on proc.id_proveedor = cot.id_proveedor
                              left  join param.tmoneda monc on monc.id_moneda = cot.id_moneda
                              left  join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
                              where   
                                    cot.id_cotizacion is not null
                                                               
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                                                                                 
                            );
                                               
                    elsif  v_sistemas[v_index] = 'v_obl' then 

                       	   ----------------OBLIGACIONES DE PAGO_ REGISTRO ESQUEMA TES--------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario 
                                                        
                           (
                           	---------------------------obligaciones de pago---------------
                           
                              WITH wf_estado as (
                                  select
                                  	    ewf.id_usuario_reg, 
                                        ewf.id_estado_wf,
                                        ewf.id_estado_anterior,
                                        ewf.fecha_reg,
                                        ewf.id_tipo_estado,
                                        ewf.obs,
                                        pwf.nro_tramite,
                                        pwf.id_proceso_wf,
                                        te.nombre_estado,
                                        (select count(*)
                                        from unnest(id_tipo_estado_wfs) elemento
                                        where elemento = ewf.id_tipo_estado) as contador_estados          
                                  FROM  wf.testado_wf ewf
                                  inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                  WHERE
                                        ewf.id_usuario_reg = v_parametros.id_usuario
                                        and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                        and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                        and substr(pwf.nro_tramite, 1, 3) in ('BR','CIN','CNA','GA-','GC-','GM-','GO-','PCE','PCP','PD-','PGA','PPM','PU-','RRH','SPD','TES')
                                  order by ewf.fecha_reg  
                                  )
                                select  
                                        tid.nro_tramite,
                                        ewf.fecha_reg as fecha_ini,
                                        tid.fecha_reg as fecha_fin,                 
                                        te.nombre_estado as anterior_estado,
                                        tid.nombre_estado as seguiente_estado,
                                        tid.obs as proveido,
                                        usu.desc_persona as funcionario_aprobador,
                                        fun.desc_funcionario1 as solicitante,
                                        obprov.desc_proveedor as proveedor,
                                        obpa.obs as justificacion,
                                        obpa.total_pago as importe,
                                        obmon.codigo as moneda,                    
                                        tid.contador_estados
                                                                                                                                                                                                                     
                                from  wf_estado  tid
                                inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                left  join tes.tobligacion_pago obpa on obpa.id_proceso_wf = tid.id_proceso_wf
                                left  join param.vproveedor  obprov on obprov.id_proveedor = obpa.id_proveedor
                                left  join param.tmoneda obmon on obmon.id_moneda = obpa.id_moneda
                                left  join orga.vfuncionario fun on fun.id_funcionario = obpa.id_funcionario
                                where 
                                      obpa.id_obligacion_pago is not null 
                                                                   
                                ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                          
                       ) union (
                       
                        ---------------------------libro de bancos---------------
                        
                        WITH wf_estado as (
                          select
                          	    ewf.id_usuario_reg, 
                                ewf.id_estado_wf,
                                ewf.id_estado_anterior,
                                ewf.fecha_reg,
                                ewf.id_tipo_estado,
                                ewf.obs,
                                coalesce(pwf.nro_tramite, pwf.codigo_proceso) as nro_tramite,
                                pwf.id_proceso_wf,
                                te.nombre_estado,
                                (select count(*)
                                from unnest(id_tipo_estado_wfs) elemento
                                where elemento = ewf.id_tipo_estado) as contador_estados          
                          FROM  wf.testado_wf ewf
                          inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                          left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                          WHERE
                                ewf.id_usuario_reg = v_parametros.id_usuario
                                and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                and (substr(pwf.nro_tramite, 1, 3) in ('BR-','CAJ','CIN','CNA','FA-','GA-','GC-','GM-','GO-','GVC','LIB','PCE','PCP','PD-','PGA','PPM','PU-','TES')
                                      or pwf.nro_tramite is null)
                          order by ewf.fecha_reg  
                          )
                        select  
                                tid.nro_tramite,
                                ewf.fecha_reg as fecha_ini,
                                tid.fecha_reg as fecha_fin,                 
                                te.nombre_estado as anterior_estado,
                                tid.nombre_estado as seguiente_estado,
                                tid.obs as proveido,
                                usu.desc_persona as funcionario_aprobador,
                                ''::text as solicitante,
                                ''::varchar as proveedor,
                                liban.detalle as justificacion,
                                0.00::numeric as importe,
                                libmon.codigo as moneda,                    
                                tid.contador_estados
                                                                                                                                                                                                             
                        from  wf_estado  tid
                        inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                        inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                        left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                        left join tes.tts_libro_bancos liban on liban.id_proceso_wf = tid.id_proceso_wf
                        left join tes.tcuenta_bancaria cub on cub.id_cuenta_bancaria = liban.id_cuenta_bancaria
                        left join param.tmoneda libmon on libmon.id_moneda = cub.id_moneda
                        where   
                              liban.id_libro_bancos is not null
                                                           
                        ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                        
                        
                        ) union (
                        
                       ---------------------------Cajas-------------------------
                       
                         WITH wf_estado as (
                            select
                            	  ewf.id_usuario_reg,	 
                                  ewf.id_estado_wf,
                                  ewf.id_estado_anterior,
                                  ewf.fecha_reg,
                                  ewf.id_tipo_estado,
                                  ewf.obs,
                                  pwf.nro_tramite,
                                  pwf.id_proceso_wf,
                                  te.nombre_estado,
                                  (select count(*)
                                  from unnest(id_tipo_estado_wfs) elemento
                                  where elemento = ewf.id_tipo_estado) as contador_estados          
                            FROM  wf.testado_wf ewf
                            inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                            left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                            WHERE
                                  ewf.id_usuario_reg = v_parametros.id_usuario
                                  and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                  and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                            order by ewf.fecha_reg  
                            )
                          select  
                                  tid.nro_tramite,
                                  ewf.fecha_reg as fecha_ini,
                                  tid.fecha_reg as fecha_fin,                 
                                  te.nombre_estado as anterior_estado,
                                  tid.nombre_estado as seguiente_estado,
                                  tid.obs as proveido,
                                  usu.desc_persona as funcionario_aprobador,
                                  ''::text as solicitante,
                                  ''::varchar as proveedor,
                                  prcaj.motivo as justificacion,
                                  0.00::numeric as importe,
                                  prmon.codigo as moneda,                    
                                  tid.contador_estados
                                                                                                                                                                                                             
                          from  wf_estado  tid
                          inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                          inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                          left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                          left  join tes.tproceso_caja prcaj on prcaj.id_proceso_wf = tid.id_proceso_wf
                          left  join tes.tcaja tcaj on tcaj.id_caja = prcaj.id_caja
                          left  join param.tmoneda prmon on prmon.id_moneda = tcaj.id_moneda
                          where   
                                (substr(tid.nro_tramite, 1, 3) = 'TES'
                                    or prcaj.tipo in (select distinct(tipo) from tes.tproceso_caja))
                                and prcaj.id_proceso_caja is not null
                                                           
                          ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                      
                      ) union (
                      
                           ---------------------------Solicitud Efectivo-------------------------
                           
                        WITH wf_estado as (
                          select
                          	    ewf.id_usuario_reg, 
                                ewf.id_estado_wf,
                                ewf.id_estado_anterior,
                                ewf.fecha_reg,
                                ewf.id_tipo_estado,
                                ewf.obs,
                                pwf.nro_tramite,
                                pwf.id_proceso_wf,
                                te.nombre_estado,
                                (select count(*)
                                from unnest(id_tipo_estado_wfs) elemento
                                where elemento = ewf.id_tipo_estado) as contador_estados          
                          FROM  wf.testado_wf ewf
                          inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                          left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                          WHERE
                                ewf.id_usuario_reg = v_parametros.id_usuario
                                and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                and (substr(pwf.nro_tramite, 1, 3) = 'FR-'
                                      or pwf.nro_tramite is null)          
                          order by ewf.fecha_reg  
                          )
                        select  
                                coalesce(tid.nro_tramite, solef.nro_tramite) as nro_tramite,
                                ewf.fecha_reg as fecha_ini,
                                tid.fecha_reg as fecha_fin,                 
                                te.nombre_estado as anterior_estado,
                                tid.nombre_estado as seguiente_estado,
                                tid.obs as proveido,
                                usu.desc_persona as funcionario_aprobador,
                                fun.desc_funcionario1 as solicitante,
                                ''::varchar as proveedor,
                                solef.motivo as justificacion,
                                solef.monto as importe,
                                mon.codigo as moneda,
                                tid.contador_estados
                                                                                                                                                                                                           
                        from  wf_estado  tid
                        inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                        inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                        left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                        left  join tes.tsolicitud_efectivo solef on solef.id_proceso_wf = tid.id_proceso_wf
                        left  join orga.vfuncionario fun on fun.id_funcionario = solef.id_funcionario
                        left  join tes.tcaja caja on caja.id_caja = solef.id_caja
                        left  join param.tmoneda mon on mon.id_moneda = caja.id_moneda
                        where   
                              solef.id_solicitud_efectivo is not null
                                                         
                        ORDER BY tid.nro_tramite desc, tid.fecha_reg desc        
                      
                      ) union (
                      
                     -------------------------------Plan Pago-------------------
                     
                        WITH wf_estado as (
                              select
                                    ewf.id_usuario_reg, 
                                    ewf.id_estado_wf,
                                    ewf.id_estado_anterior,
                                    ewf.fecha_reg,
                                    ewf.id_tipo_estado,
                                    ewf.obs,
                                    pwf.nro_tramite,
                                    pwf.id_proceso_wf,
                                    te.nombre_estado,
                                    (select count(*)
                                    from unnest(id_tipo_estado_wfs) elemento
                                    where elemento = ewf.id_tipo_estado) as contador_estados          
                              FROM  wf.testado_wf ewf
                              inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                              WHERE
                                    ewf.id_usuario_reg = v_parametros.id_usuario
                                    and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                    and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                    and substr(pwf.nro_tramite, 1, 3) in ('BR-','CIN','CNA','GA-','GC-','GM-','GO-','PCE','PCP','PD-','PGA','PLA','PPM','PU-','SPD','SPI','TES')         
                              order by ewf.fecha_reg  
                              )
                            select  
                                    tid.nro_tramite,
                                    ewf.fecha_reg as fecha_ini,
                                    tid.fecha_reg as fecha_fin,                 
                                    te.nombre_estado as anterior_estado,
                                    tid.nombre_estado as seguiente_estado,
                                    tid.obs as proveido,      
                                    usu.desc_persona as funcionario_aprobador,
                                    fun.desc_funcionario1::text as solicitante,
                                    pro.desc_proveedor as proveedor,
                                    plpag.nombre_pago as justificacion,
                                    plpag.monto as importe,
                                    mon.codigo as moneda,
                                    tid.contador_estados
                                                                                                                                                                                                               
                            from  wf_estado  tid
                            inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                            inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                            left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                            left  join tes.tplan_pago plpag on plpag.id_proceso_wf = tid.id_proceso_wf
                            left  join tes.tobligacion_pago op on op.id_obligacion_pago = plpag.id_obligacion_pago
                            left  join param.tmoneda mon on mon.id_moneda = op.id_moneda
                            left  join param.vproveedor pro on pro.id_proveedor = op.id_proveedor
                            left  join orga.vfuncionario fun on fun.id_funcionario = op.id_funcionario
                            where   
                                  plpag.id_plan_pago is not null
                                                             
                            ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                        );
                        
                    elsif  v_sistemas[v_index] = 'v_alm' then
                    
               			   ----------------ALMACENES: REGISTRO ESQUEMA ALM--------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario  
                            
                           (                        
                              WITH wf_estado as (
                                select
                                      ewf.id_usuario_reg, 
                                      ewf.id_estado_wf,
                                      ewf.id_estado_anterior,
                                      ewf.fecha_reg,
                                      ewf.id_tipo_estado,
                                      ewf.obs,
                                      pwf.nro_tramite,
                                      pwf.id_proceso_wf,
                                      te.nombre_estado,
                                      (select count(*)
                                      from unnest(id_tipo_estado_wfs) elemento
                                      where elemento = ewf.id_tipo_estado) as contador_estados          
                                FROM  wf.testado_wf ewf
                                inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                WHERE
                                      ewf.id_usuario_reg = v_parametros.id_usuario
                                      and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                      and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                      and substr(pwf.nro_tramite, 1, 3) = 'ALM'
                                order by ewf.fecha_reg  
                                )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,      
                                      usu.desc_persona as funcionario_aprobador,
                                      emp.desc_funcionario1 as solicitante,
                                      almprov.desc_proveedor as proveedor,
                                      almmov.descripcion as justificacion,
                                      0.00::numeric as importe,
                                      ''::varchar as moneda,
                                      tid.contador_estados
                                                                                                                                                                                                                 
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join alm.tmovimiento almmov on almmov.id_proceso_wf = tid.id_proceso_wf  
                              left  JOIN alm.tmovimiento_tipo movtip on movtip.id_movimiento_tipo = almmov.id_movimiento_tipo  
                              left  join param.vproveedor  almprov on almprov.id_proveedor = almmov.id_proveedor
                              LEFT  JOIN orga.vfuncionario emp on emp.id_funcionario = almmov.id_funcionario
                              where   
                                    almmov.id_movimiento is not null
                                                               
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                            
                         ) union (
                         
                              WITH wf_estado as (
                                select 
                                      ewf.id_usuario_reg, 
                                      ewf.id_estado_wf,
                                      ewf.id_estado_anterior,
                                      ewf.fecha_reg,
                                      ewf.id_tipo_estado,
                                      ewf.obs,
                                      pwf.nro_tramite,
                                      pwf.id_proceso_wf,
                                      te.nombre_estado,
                                      (select count(*)
                                      from unnest(id_tipo_estado_wfs) elemento
                                      where elemento = ewf.id_tipo_estado) as contador_estados          
                                FROM  wf.testado_wf ewf
                                inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                WHERE
                                      ewf.id_usuario_reg = v_parametros.id_usuario
                                      and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                      and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                      and substr(pwf.nro_tramite, 1, 3) in ('CIN','CNA','GA-','GC-','GM-','GO-')
                                order by ewf.fecha_reg  
                                )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,      
                                      usu.desc_persona as funcionario_aprobador,
                                      func.desc_funcionario1 as solicitante,
                                      pro.desc_proveedor as proveedor,
                                      sol.justificacion,
                                      0.00::numeric as importe,
                                      premon.codigo as moneda,
                                      tid.contador_estados
                                                                                                                                                                                                                 
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join alm.tpreingreso preing on preing.id_proceso_wf = tid.id_proceso_wf  
                              left  join param.tmoneda premon on premon.id_moneda = preing.id_moneda
                              left  join adq.tcotizacion cot on cot.id_cotizacion = preing.id_cotizacion
                              left  join adq.tproceso_compra pcom on pcom.id_proceso_compra = cot.id_proceso_compra
                              left  join adq.tsolicitud sol on sol.id_solicitud = pcom.id_solicitud
                              left  join orga.vfuncionario func on func.id_funcionario = sol.id_funcionario
                              left  join param.vproveedor pro on pro.id_proveedor = cot.id_proveedor
                              where   
                                    preing.id_preingreso is not null
                                    and preing.estado != 'cancelado'
                                                               
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                   			);
                                                
                    elsif  v_sistemas[v_index] = 'v_kaf' then

	  	                   ------------------ACTIVOS FIJOS: REGISTRO ESQUEMA KAF--------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario 
                                                
                              WITH wf_estado as (
                                    select
                                          ewf.id_usuario_reg, 
                                          ewf.id_estado_wf,
                                          ewf.id_estado_anterior,
                                          ewf.fecha_reg,
                                          ewf.id_tipo_estado,
                                          ewf.obs,
                                          pwf.nro_tramite,
                                          pwf.id_proceso_wf,
                                          te.nombre_estado,
                                          (select count(*)
                                          from unnest(id_tipo_estado_wfs) elemento
                                          where elemento = ewf.id_tipo_estado) as contador_estados          
                                    FROM  wf.testado_wf ewf
                                    inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                    left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                    WHERE
                                          ewf.id_usuario_reg = v_parametros.id_usuario
                                          and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                          and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                          and substr(pwf.nro_tramite, 1, 3) = 'KAF'
                                    order by ewf.fecha_reg  
                                    )
                                  select  
                                          tid.nro_tramite,
                                          ewf.fecha_reg as fecha_ini,
                                          tid.fecha_reg as fecha_fin,                 
                                          te.nombre_estado as anterior_estado,
                                          tid.nombre_estado as seguiente_estado,
                                          tid.obs as proveido,      
                                          usu.desc_persona as funcionario_aprobador,
                                          ''::text as solicitante,                 	
                                          ''::varchar as proveedor,
                                          mov.glosa as justificacion,
                                          0.00::numeric as importe,
                                          ''::varchar as moneda,
                                          tid.contador_estados
                                                                                                                                                                                                                     
                                  from  wf_estado  tid
                                  inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                  inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                  left  join kaf.tmovimiento mov on mov.id_proceso_wf = tid.id_proceso_wf
                                  where   
                                       mov.id_movimiento is not null
                                                                   
                                  ORDER BY tid.nro_tramite desc, tid.fecha_reg desc;
                    
                    elsif  v_sistemas[v_index] = 'v_ctr' then 
                    
 					       --------------CONTRATOS: REGISTRO ESQUEMA LEG--------------------------------------  
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario                                                   
                            
                              WITH wf_estado as (
                                    select
                                    	  ewf.id_usuario_reg, 
                                          ewf.id_estado_wf,
                                          ewf.id_estado_anterior,
                                          ewf.fecha_reg,
                                          ewf.id_tipo_estado,
                                          ewf.obs,
                                          pwf.nro_tramite,
                                          pwf.id_proceso_wf,
                                          te.nombre_estado,
                                          (select count(*)
                                          from unnest(id_tipo_estado_wfs) elemento
                                          where elemento = ewf.id_tipo_estado) as contador_estados          
                                    FROM  wf.testado_wf ewf
                                    inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                    left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                    WHERE
                                          ewf.id_usuario_reg = v_parametros.id_usuario
                                          and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                          and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                          and substr(pwf.nro_tramite, 1, 3) in ('CIN','CNA','LEG')
                                    order by ewf.fecha_reg  
                                    )
                                  select  
                                          tid.nro_tramite,
                                          ewf.fecha_reg as fecha_ini,
                                          tid.fecha_reg as fecha_fin,                 
                                          te.nombre_estado as anterior_estado,
                                          tid.nombre_estado as seguiente_estado,
                                          tid.obs as proveido,
                                          usu.desc_persona as funcionario_aprobador,
                                          cfun.desc_funcionario1 as solicitante,
                                          cprov.desc_proveedor as proveedor,
                                          contr.objeto as justificacion,
                                          contr.monto as importe,
                                          cmon.codigo as moneda,
                                          tid.contador_estados
                                                                                                                                                                                                                     
                                  from  wf_estado  tid
                                  inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                  inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                  left  join leg.tcontrato contr on contr.id_proceso_wf = tid.id_proceso_wf
                                  left  join param.tmoneda cmon on cmon.id_moneda = contr.id_moneda
                                  left  join orga.vfuncionario cfun on cfun.id_funcionario = contr.id_funcionario     
                                  left  join param.vproveedor cprov on cprov.id_proveedor = contr.id_proveedor    
                                  where   
                                        contr.id_contrato is not null 
                                                                   
                                  ORDER BY tid.nro_tramite desc, tid.fecha_reg desc;
                                           
                    elsif  v_sistemas[v_index] = 'v_pls' then 
                    
 					       ---------------PLANILLAS DE SUELDO: REGISTRO ESQUEMA PLANI--------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario                      
                            
                              WITH wf_estado as (
                                  select
                                  	    ewf.id_usuario_reg, 
                                        ewf.id_estado_wf,
                                        ewf.id_estado_anterior,
                                        ewf.fecha_reg,
                                        ewf.id_tipo_estado,
                                        ewf.obs,
                                        pwf.nro_tramite,
                                        pwf.id_proceso_wf,
                                        te.nombre_estado,
                                        (select count(*)
                                        from unnest(id_tipo_estado_wfs) elemento
                                        where elemento = ewf.id_tipo_estado) as contador_estados          
                                  FROM  wf.testado_wf ewf
                                  inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                  WHERE
                                        ewf.id_usuario_reg = v_parametros.id_usuario
                                        and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                        and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                        and substr(pwf.nro_tramite, 1, 3) = 'PLA'
                                  order by ewf.fecha_reg  
                                  )
                                select  
                                        tid.nro_tramite,
                                        ewf.fecha_reg as fecha_ini,
                                        tid.fecha_reg as fecha_fin,                 
                                        te.nombre_estado as anterior_estado,
                                        tid.nombre_estado as seguiente_estado,
                                        tid.obs as proveido,
                                        usu.desc_persona as funcionario_aprobador,
                                        ''::varchar as solicitante,
                                        ''::varchar as proveedor,
                                        plan.nro_planilla||': '||plan.observaciones as justificacion,                    
                                        0.00::numeric as importe,
                                        ''::varchar as moneda,
                                        tid.contador_estados
                                                                                                                                                                                                                   
                                from  wf_estado  tid
                                inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                left  join plani.tplanilla plan on plan.id_proceso_wf = tid.id_proceso_wf
                                where   
                                      plan.id_planilla is not null
                                                                 
                                ORDER BY tid.nro_tramite desc, tid.fecha_reg desc;    
                                              
                    elsif  v_sistemas[v_index] = 'v_fea' then 

 					       ---------------FONDOS EN AVANCE: REGISTRO ESQUEMA CD--------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario      
                                                       
                              WITH wf_estado as (
                                  select 
                                        ewf.id_usuario_reg,
                                        ewf.id_estado_wf,
                                        ewf.id_estado_anterior,
                                        ewf.fecha_reg,
                                        ewf.id_tipo_estado,
                                        ewf.obs,
                                        pwf.nro_tramite,
                                        pwf.id_proceso_wf,
                                        te.nombre_estado,
                                        (select count(*)
                                        from unnest(id_tipo_estado_wfs) elemento
                                        where elemento = ewf.id_tipo_estado) as contador_estados          
                                  FROM  wf.testado_wf ewf
                                  inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                  WHERE
                                        ewf.id_usuario_reg = v_parametros.id_usuario
                                        and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                        and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                        and substr(pwf.nro_tramite, 1, 3) = 'FA-'
                                  order by ewf.fecha_reg  
                                  )
                                select  
                                        tid.nro_tramite,
                                        ewf.fecha_reg as fecha_ini,
                                        tid.fecha_reg as fecha_fin,                 
                                        te.nombre_estado as anterior_estado,
                                        tid.nombre_estado as seguiente_estado,
                                        tid.obs as proveido,
                                        usu.desc_persona as funcionario_aprobador,
                                        fun.desc_funcionario1 as solicitante,
                                        ''::varchar as proveedor,
                                        cudoc.motivo as justificacion,                    
                                        cudoc.importe,
                                        cumon.codigo as moneda,
                                        tid.contador_estados
                                                                                                                                                                                                                   
                                from  wf_estado  tid
                                inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                left  join cd.tcuenta_doc cudoc on cudoc.id_proceso_wf = tid.id_proceso_wf
                                left  join param.tmoneda cumon on cumon.id_moneda = cudoc.id_moneda
                                left  join orga.vfuncionario fun on fun.id_funcionario = cudoc.id_funcionario
                                where   
                                      cudoc.id_cuenta_doc is not null
                                                                 
                                ORDER BY tid.nro_tramite desc, tid.fecha_reg desc;
                                           
                    elsif  v_sistemas[v_index] = 'v_prs' then 
                    
						   ---------------PRESUPUESTOS: REGISTRO ESQUEMA PRE--------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario 
                                                
					       (
	                        --------------------------Presupuesto--------------------
                            WITH wf_estado as (
                                  select 
                                  		ewf.id_usuario_reg,
                                        ewf.id_estado_wf,
                                        ewf.id_estado_anterior,
                                        ewf.fecha_reg,
                                        ewf.id_tipo_estado,
                                  		ewf.obs,
                                        pwf.nro_tramite,
                                        pwf.id_proceso_wf,
                                        te.nombre_estado,
                                        (select count(*)
                                        from unnest(id_tipo_estado_wfs) elemento
                                        where elemento = ewf.id_tipo_estado) as contador_estados          
                                  FROM  wf.testado_wf ewf
                                  inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left  join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                  WHERE
                                        ewf.id_usuario_reg = v_parametros.id_usuario
                                        and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                        and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                        and substr(pwf.nro_tramite, 1, 3) = 'FP-'
                                  order by ewf.fecha_reg  
                                  )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,
                                      usu.desc_persona as funcionario_aprobador,
                                      vcc.codigo_uo||': '||vcc.nombre_uo as solicitante,          
                                      ''::varchar as proveedor,
                                      presp.descripcion as justificacion,
                                      (select coalesce(sum(prpa.importe_aprobado),0)
                                      from pre.tpresup_partida prpa 
                                      where prpa.id_presupuesto = presp.id_presupuesto)::numeric as importe,                                                                                                            
                                      ''::varchar as moneda,
                                      tid.contador_estados
                                                                                                                                                                                                         
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join pre.tpresupuesto presp on presp.id_proceso_wf  = tid.id_proceso_wf
                              left  join param.vcentro_costo vcc on vcc.id_centro_costo = presp.id_centro_costo                              
                              where   
                                    presp.id_presupuesto is not null 
                                                                 
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                  
                            
	                    ) union (
                        
				            --------------------------Modificacion presupuestaria---------------
                            
                            WITH wf_estado as (
                              select 
                              		ewf.id_usuario_reg,
                                    ewf.id_estado_wf,
                                    ewf.id_estado_anterior,
                                    ewf.fecha_reg,
                                    ewf.id_tipo_estado,
                                    ewf.obs,
                                    pwf.nro_tramite,
                                    pwf.id_proceso_wf,
                                    te.nombre_estado,
                                   (select count(*)
                                   from unnest(id_tipo_estado_wfs) elemento
                                   where elemento = ewf.id_tipo_estado) as contador_estados                                     
                              FROM  wf.testado_wf ewf
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                              WHERE
                                    ewf.id_usuario_reg = v_parametros.id_usuario
                                    and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                    and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                    and substr(pwf.nro_tramite, 1, 3) in ('AJT','CIN','CNA','GA-','GC-','GM-','GO-','PCE','PCP','PD-','PGA')          
                              order by ewf.fecha_reg  
                              )
                            select  
                                    tid.nro_tramite,
                                    ewf.fecha_reg as fecha_ini,
                                    tid.fecha_reg as fecha_fin,                 
                                    te.nombre_estado as anterior_estado,
                                    tid.nombre_estado as seguiente_estado,
                                    tid.obs as proveido,
                                    usu.desc_persona as funcionario_aprobador,
                                    ''::varchar as solicitante,
                                    ''::varchar as proveedor,                                    
                                    paju.justificacion,
                                    paju.importe_ajuste as importe,
                                    mon.codigo as moneda,
                                    tid.contador_estados
                                                                                                                                                                           
                            from  wf_estado  tid
                            inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                            inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                            left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                            left  join pre.tajuste paju on paju.id_proceso_wf  = tid.id_proceso_wf
                            left  join param.tmoneda mon on mon.id_moneda = paju.id_moneda
                            where   
                                  paju.id_ajuste is not null 
                                   
                                ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                            );
                                        
                    elsif  v_sistemas[v_index] = 'v_sdc' then
                    
						   ---------------SISTEMA DE CONTABILIDAD: REGISTRO ESQUEMA REC------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario

                            (
                            ----------------------Comprobante de pago--------------------------------------
                            
                            WITH wf_estado as (
                                  select 
                                        ewf.id_usuario_reg,
                                        ewf.id_estado_wf,
                                        ewf.id_estado_anterior,
                                        ewf.fecha_reg,
                                        ewf.id_tipo_estado,
                                        ewf.obs,
                                        pwf.nro_tramite,
                                        pwf.id_proceso_wf,
                                        te.nombre_estado,
                                        (select count(*)
                                        from unnest(id_tipo_estado_wfs) elemento
                                        where elemento = ewf.id_tipo_estado) as contador_estados          
                                  FROM  wf.testado_wf ewf
                                  inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                  WHERE
                                        ewf.id_usuario_reg = v_parametros.id_usuario
                                        and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                        and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                        and substr(pwf.nro_tramite, 1, 3) in ('BR-','CAJ','CBT','CIN','CNA','FA-','GA-','GC-','GM-','GO-','PCE','PCP','PD-','PGA','PLA','PPM','PU-','RRH','SP-','SPD','SPI','TES')
                                  order by ewf.fecha_reg  
                                  )
                                select  
                                        tid.nro_tramite,
                                        ewf.fecha_reg as fecha_ini,
                                        tid.fecha_reg as fecha_fin,                 
                                        te.nombre_estado as anterior_estado,
                                        tid.nombre_estado as seguiente_estado,
                                        tid.obs as proveido,
                                        usu.desc_persona as funcionario_aprobador,
                                        ''::varchar as solicitante,
                                        ''::varchar as proveedor,
                                        incbte.glosa1 as justificacion,
                                        0.00::numeric as importe,
                                        mon.codigo as moneda,          
                                        tid.contador_estados
                                                                                                                                                                                                                                               
                                from  wf_estado  tid
                                inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                left  join conta.tint_comprobante incbte on incbte.id_proceso_wf = tid.id_proceso_wf
                                left  join param.tmoneda mon ON mon.id_moneda = incbte.id_moneda
                                where   
                                      incbte.id_int_comprobante is not null
                                                                                             
                                ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                                
                                ) union (
                                
                                ----------------------Entrega--------------------------------------
                                
                                WITH wf_estado as (
                                    select 
                                          ewf.id_usuario_reg,
                                          ewf.id_estado_wf,
                                          ewf.id_estado_anterior,
                                          ewf.fecha_reg,
                                          ewf.id_tipo_estado,
                                          ewf.obs,
                                          pwf.nro_tramite,
                                          pwf.id_proceso_wf,
                                          te.nombre_estado,
                                          (select count(*)
                                          from unnest(id_tipo_estado_wfs) elemento
                                          where elemento = ewf.id_tipo_estado) as contador_estados          
                                    FROM  wf.testado_wf ewf
                                    inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                    left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                    WHERE
                                          ewf.id_usuario_reg = v_parametros.id_usuario
                                          and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                          and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                          and substr(pwf.nro_tramite, 1, 3) in ('BR-','CAJ','CBT','CIN','CNA','FA-','GA-','GC-','GM-','GO-','PCE','PCP','PD-','PGA','PLA','PPM','PU-','TES')
                                    order by ewf.fecha_reg  
                                    )
                                  select  
                                          tid.nro_tramite,
                                          ewf.fecha_reg as fecha_ini,
                                          tid.fecha_reg as fecha_fin,                 
                                          te.nombre_estado as anterior_estado,
                                          tid.nombre_estado as seguiente_estado,
                                          tid.obs as proveido,
                                          usu.desc_persona as funcionario_aprobador,
                                          ''::varchar as solicitante,
                                          ''::varchar as proveedor,
                                          ''::varchar as justificacion,
                                          (select sum(pp.monto)
                                          from conta.tentrega_det ende
                                          inner join tes.tplan_pago pp on pp.id_int_comprobante = ende.id_int_comprobante
                                          where ende.id_entrega = ent.id_entrega) as importe,
                                          com.desc_moneda::varchar,
                                          tid.contador_estados
                                                                                                                                                                                                                                                 
                                  from  wf_estado  tid
                                  inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                  inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                  left  join conta.tentrega ent on ent.id_proceso_wf = tid.id_proceso_wf
                                  left join conta.tentrega_det det on det.id_entrega = ent.id_entrega  
                                  left  join conta.vint_comprobante com on com.id_int_comprobante = det.id_int_comprobante
                                  where   
                                        ent.id_entrega is not null
                                                                                               
                                  ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                                
                                );                                                        
                                                
                    elsif  v_sistemas[v_index] = 'v_gro' then
                    
						   ---------------GESTION DE RECLAMO ODECO: REGISTRO ESQUEMA REC------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario  
                                
                           (  
                           --------------------------Reclamo--------------------                          
                            WITH wf_estado as (
                                  select 
                                        ewf.id_usuario_reg,
                                        ewf.id_estado_wf,
                                        ewf.id_estado_anterior,
                                        ewf.fecha_reg,
                                        ewf.id_tipo_estado,
                                        ewf.obs,
                                        pwf.nro_tramite,
                                        pwf.id_proceso_wf,
                                        te.nombre_estado,
                                        (select count(*)
                                        from unnest(id_tipo_estado_wfs) elemento
                                        where elemento = ewf.id_tipo_estado) as contador_estados          
                                  FROM  wf.testado_wf ewf
                                  inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                  WHERE
                                        ewf.id_usuario_reg = v_parametros.id_usuario
                                        and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                        and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                        and substr(pwf.nro_tramite, 1, 3) = 'REC'
                                  order by ewf.fecha_reg  
                                  )
                                select  
                                        tid.nro_tramite,
                                        ewf.fecha_reg as fecha_ini,
                                        tid.fecha_reg as fecha_fin,                 
                                        te.nombre_estado as anterior_estado,
                                        tid.nombre_estado as seguiente_estado,
                                        tid.obs as proveido,
                                        usu.desc_persona as funcionario_aprobador,
                                        rc.nombre_completo1 as solicitante,          
                                        ''::varchar as proveedor,
                                        ''::varchar as justificacion,                    
                                        0.00::numeric as importe,
                                        ''::varchar as moneda,
                                        tid.contador_estados
                                                                                                                                                                                                                         
                                from  wf_estado  tid
                                inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                left  join rec.treclamo recla on recla.id_proceso_wf = tid.id_proceso_wf
                                left  join rec.vcliente rc on rc.id_cliente = recla.id_cliente
                                where   
                                      recla.id_reclamo is not null
                                                                       
                                ORDER BY tid.nro_tramite desc, tid.fecha_reg desc
                              
                              ) union (
                              
                              --------------------------Respuesta----------------
           						WITH wf_estado as (
                                    select 
                                          ewf.id_usuario_reg,
                                          ewf.id_estado_wf,
                                          ewf.id_estado_anterior,
                                          ewf.fecha_reg,
                                          ewf.id_tipo_estado,
                                          ewf.obs,
                                          pwf.nro_tramite,
                                          pwf.id_proceso_wf,
                                          te.nombre_estado,
                                          (select count(*)
                                          from unnest(id_tipo_estado_wfs) elemento
                                          where elemento = ewf.id_tipo_estado) as contador_estados          
                                    FROM  wf.testado_wf ewf
                                    inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                    left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                    WHERE
                                          ewf.id_usuario_reg = v_parametros.id_usuario
                                          and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                          and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                          and substr(pwf.nro_tramite, 1, 3) = 'REC'
                                    order by ewf.fecha_reg  
                                    )
                                  select  
                                          tid.nro_tramite,
                                          ewf.fecha_reg as fecha_ini,
                                          tid.fecha_reg as fecha_fin,                 
                                          te.nombre_estado as anterior_estado,
                                          tid.nombre_estado as seguiente_estado,
                                          tid.obs as proveido,
                                          usu.desc_persona as funcionario_aprobador,
                                          rcli.nombre_completo1 as solicitante,          
                                          ''::varchar as proveedor,
                                          rresp.asunto||': '|| rresp.nro_respuesta as justificacion,                    
                                          0.00::numeric as importe,
                                          ''::varchar as moneda,
                                          tid.contador_estados
                                                                                                                                                                                                                     
                                  from  wf_estado  tid
                                  inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                                  inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                  left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                                  left  join rec.trespuesta rresp on rresp.id_proceso_wf = tid.id_proceso_wf
                                  left  join rec.treclamo recl on recl.id_reclamo = rresp.id_reclamo
                                  left  join rec.vcliente rcli on rcli.id_cliente = recl.id_cliente
                                  where   
                                        rresp.id_respuesta is not null
                                                                   
                                  ORDER BY tid.nro_tramite desc, tid.fecha_reg desc                            
                              );   
                                               
                    elsif  v_sistemas[v_index] = 'v_gsm' then

						   ----------------GESTION DE MATERIALES: REGISTRO ESQUEMA MAT--------------------------------------
                           -- insercion de registros                 
                            insert into temp_tramites_aprobados_x_funcionario      
                                                  
                 			WITH wf_estado as (
                                select 
                                      ewf.id_usuario_reg,
                                      ewf.id_estado_wf,
                                      ewf.id_estado_anterior,
                                      ewf.fecha_reg,
                                      ewf.id_tipo_estado,
                                      ewf.obs,
                                      pwf.nro_tramite,
                                      pwf.id_proceso_wf,
                                      te.nombre_estado,
                                      (select count(*)
                                      from unnest(id_tipo_estado_wfs) elemento
                                      where elemento = ewf.id_tipo_estado) as contador_estados          
                                FROM  wf.testado_wf ewf
                                inner join  wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                                left join wf.tproceso_wf pwf on pwf.id_proceso_wf = ewf.id_proceso_wf    
                                WHERE
                                      ewf.id_usuario_reg = v_parametros.id_usuario
                                      and ewf.fecha_reg between v_parametros.fecha_ini and v_parametros.fecha_fin
                                      and te.codigo not in ('anulado','anulada','cancelado','cancelada', 'eliminado', 'eliminada')          
                                      and substr(pwf.nro_tramite, 1, 3) in ('GR-', 'GM-', 'GO-', 'GA-', 'GC-')
                                order by ewf.fecha_reg  
                                )
                              select  
                                      tid.nro_tramite,
                                      ewf.fecha_reg as fecha_ini,
                                      tid.fecha_reg as fecha_fin,                 
                                      te.nombre_estado as anterior_estado,
                                      tid.nombre_estado as seguiente_estado,
                                      tid.obs as proveido,
                                      usu.desc_persona as funcionario_aprobador,
                                      fun.desc_funcionario1 as solicitante,          
                                      mprov.desc_proveedor as proveedor,
                                      msol.justificacion as justificacion,
                                      (select sum(ds.cantidad_sol * ds.precio_unitario)
                                        from mat.tdetalle_sol ds
                                        where ds.id_solicitud = msol.id_solicitud) as importe,
                                      mmon.codigo as moneda,
                                      tid.contador_estados
                                                                                                                                                                                                                 
                              from  wf_estado  tid
                              inner join wf.testado_wf ewf on ewf.id_estado_wf = tid.id_estado_anterior
                              inner join wf.ttipo_estado te on ewf.id_tipo_estado = te.id_tipo_estado    
                              left  join segu.vusuario usu on usu.id_usuario = tid.id_usuario_reg
                              left  join mat.tsolicitud msol on msol.id_proceso_wf = tid.id_proceso_wf
                              left  join param.vproveedor mprov on mprov.id_proveedor = msol.id_proveedor
                              left  join param.tmoneda mmon on mmon.id_moneda = msol.id_moneda
                              left  join orga.vfuncionario fun on fun.id_funcionario = msol.id_funcionario_sol                          
                              where   
                                    msol.id_solicitud is not null
                                                               
                              ORDER BY tid.nro_tramite desc, tid.fecha_reg desc;
                	end if;               
                    
                 end loop;
                                                               				
                     
    		--Sentencia de la consulta
              v_consulta:= 'select * from temp_tramites_aprobados_x_funcionario order by nro_tramite asc';
            
			--Devuelve la respuesta
            raise notice '%', v_consulta;
			return v_consulta;
						
		end;
        
    /*******************************
     #TRANSACCION:  WF_FUNCIOCARCS_SEL
     #DESCRIPCION:	Listado de funcionarios con su ultimo cargo, y sus cuentas de usuario 
     #AUTOR:		breydi vasquez
     #FECHA:		25/04/2020
    ***********************************/
    elsif(p_transaccion='WF_FUNCIOCARCS_SEL')then

      BEGIN

        v_consulta:='
                      select
                      	vusu.id_usuario,
                        vusu.cuenta,
                        funulc.id_uo_funcionario,
                        funulc.id_funcionario,
                        funulc.desc_funcionario1,
                        funulc.desc_funcionario2,
                        funulc.id_uo,
                        funulc.nombre_cargo,
                        funulc.fecha_asignacion,
                        funulc.fecha_finalizacion,
                        funulc.num_doc,
                        funulc.ci,
                        funulc.codigo,
                        funulc.email_empresa,
                        funulc.id_cargo,
                        funulc.descripcion_cargo,
                        funulc.cargo_codigo,
                        funulc.lugar_nombre,
                        funulc.oficina_nombre
                      FROM orga.vfuncionario_ultimo_cargo funulc 
                      inner join orga.vfuncionario fun on fun.id_funcionario = funulc.id_funcionario
                      inner join segu.vusuario vusu on vusu.id_persona = fun.id_persona
                      where ';

        v_consulta:=v_consulta||v_parametros.filtro;
        v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

		raise notice 'v_consulta %', v_consulta;
        return v_consulta;

      END;      

    /*******************************
     #TRANSACCION:  WF_FUNCIOCARCS_CONT
     #DESCRIPCION:	Conteo de funcionarios con su ultmimo cargo, y sus cuentas de usuario
     #AUTOR:		breydi vasquez 
     #FECHA:		25/04/2020
    ***********************************/
    elsif(p_transaccion='WF_FUNCIOCARCS_CONT')then

      BEGIN
      

        v_consulta:='SELECT count(vusu.id_usuario)
                        from orga.vfuncionario_ultimo_cargo funulc 
                        left join orga.vfuncionario fun on fun.id_funcionario = funulc.id_funcionario
                        left join segu.vusuario vusu on vusu.id_persona = fun.id_persona
                        where ';
        v_consulta:=v_consulta||v_parametros.filtro;
        return v_consulta;
      END;                
					
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