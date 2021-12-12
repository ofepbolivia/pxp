CREATE OR REPLACE FUNCTION segu.ft_certificados_seguridad_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Seguridad
 FUNCION: 		segu.ft_certificados_seguridad_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'segu.tcertificados_seguridad'
 AUTOR: 		 (breydi.vasquez)
 FECHA:	        03-11-2021 15:36:08
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				03-11-2021 15:36:08								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'segu.tcertificados_seguridad'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    		integer;
	v_parametros           		record;
	v_id_requerimiento     		integer;
	v_resp		            	varchar;
	v_nombre_funcion        	text;
	v_mensaje_error         	text;
	v_id_certificado_seguridad	integer;
    v_id_gestion				integer;
    v_nro_tramite				varchar;
   	v_id_proceso_wf				integer;
    v_id_estado_wf				integer;
    v_codigo_estado				varchar;
    v_codigo_tipo_proceso 		varchar;
    v_id_proceso_macro			integer;
    v_obs                       varchar;
    v_acceso_directo            varchar;
    v_clase                     varchar;
    v_parametros_ad             varchar;
    v_tipo_noti                 varchar;
    v_titulo                    varchar;
    v_id_tipo_estado            integer;
    v_pedir_obs                 varchar;    
    v_id_depto                  integer;
    v_id_estado_actual          integer;
    v_codigo_estado_siguiente   varchar;  
    v_id_funcionario			integer;
    v_id_usuario_reg			integer; 
    v_id_estado_wf_ant			integer;
			    
BEGIN

    v_nombre_funcion = 'segu.ft_certificados_seguridad_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'SG_CERS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		03-11-2021 15:36:08
	***********************************/

	if(p_transaccion='SG_CERS_INS')then
					
        begin
           


           --Gestion para WF
    	   SELECT g.id_gestion
           INTO v_id_gestion
           FROM param.tgestion g
           WHERE g.gestion = EXTRACT(YEAR FROM current_date);

           select tp.codigo, pm.id_proceso_macro
           into v_codigo_tipo_proceso, v_id_proceso_macro
           from  wf.tproceso_macro pm
           inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
           where pm.codigo='CTDSG' and tp.estado_reg = 'activo' and tp.inicio = 'si' ;

            SELECT
                 ps_num_tramite ,
                 ps_id_proceso_wf ,
                 ps_id_estado_wf ,
                 ps_codigo_estado
              into
                 v_nro_tramite,
                 v_id_proceso_wf,
                 v_id_estado_wf,
                 v_codigo_estado

            FROM wf.f_inicia_tramite(
                 p_id_usuario,
                 v_parametros._id_usuario_ai,
                 v_parametros._nombre_usuario_ai,
                 v_id_gestion,
                 v_codigo_tipo_proceso,
                 NULL,
                 NULL,
                 'Certificados de Seguridad',
                 v_codigo_tipo_proceso);
                 
        	--Sentencia de la insercion
        	insert into segu.tcertificados_seguridad(
			estado_reg,
			--titular_certificado,
			--entidad_certificadora,
			nro_serie,
			fecha_emision,
			fecha_vencimiento,
			--tipo_certificado,
			clave_publica,
			ip_servidor,
			observaciones,
			area_de_uso,
			dias_anticipacion_alerta,
            id_funcionario_resp,
            id_funcionario_cc,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod,
            nro_tramite,
            estado,
            id_proceso_wf,
            id_estado_wf,
            id_gestion,
            id_titular_certificado,
            id_entidad_certificadora,
            id_tipo_certificado
          	) values(
			'activo',
			--v_parametros.titular_certificado,
			--v_parametros.entidad_certificadora,
			v_parametros.nro_serie,
			v_parametros.fecha_emision,
			v_parametros.fecha_vencimiento,
			--v_parametros.tipo_certificado,
			v_parametros.clave_publica,
			v_parametros.ip_servidor,
			v_parametros.observaciones,
			v_parametros.area_de_uso,
			v_parametros.dias_anticipacion_alerta,
            v_parametros.id_funcionario_resp,
            string_to_array (v_parametros.id_funcionario_cc,',')::INTEGER[],
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null,
            v_nro_tramite,
            v_codigo_estado,
            v_id_proceso_wf,
			v_id_estado_wf,
			v_id_gestion,
            v_parametros.id_titular_certificado,
            v_parametros.id_entidad_certificadora,
            v_parametros.id_tipo_certificado            						
			)RETURNING id_certificado_seguridad into v_id_certificado_seguridad;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Certificados Seguridad almacenado(a) con exito (id_certificado_seguridad'||v_id_certificado_seguridad||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_certificado',v_id_certificado_seguridad::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'SG_CERS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		03-11-2021 15:36:08
	***********************************/

	elsif(p_transaccion='SG_CERS_MOD')then

		begin
			--Sentencia de la modificacion
			update segu.tcertificados_seguridad set
--			titular_certificado = v_parametros.titular_certificado,
--			entidad_certificadora = v_parametros.entidad_certificadora,
			nro_serie = v_parametros.nro_serie,
			fecha_emision = v_parametros.fecha_emision,
			fecha_vencimiento = v_parametros.fecha_vencimiento,
--			tipo_certificado = v_parametros.tipo_certificado,
			clave_publica = v_parametros.clave_publica,
			ip_servidor = v_parametros.ip_servidor,
			observaciones = v_parametros.observaciones,
			area_de_uso = v_parametros.area_de_uso,
			dias_anticipacion_alerta = v_parametros.dias_anticipacion_alerta,
            id_funcionario_resp = v_parametros.id_funcionario_resp,
            id_funcionario_cc = string_to_array (v_parametros.id_funcionario_cc,',')::INTEGER[],            
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_titular_certificado = v_parametros.id_titular_certificado,
            id_entidad_certificadora = v_parametros.id_entidad_certificadora,
            id_tipo_certificado = v_parametros.id_tipo_certificado           
			where id_certificado_seguridad=v_parametros.id_certificado_seguridad;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Certificados Seguridad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_certificado_seguridad',v_parametros.id_certificado_seguridad::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'SG_CERS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		03-11-2021 15:36:08
	***********************************/

	elsif(p_transaccion='SG_CERS_ELI')then

		begin
			--Sentencia de la eliminacion
			update segu.tcertificados_seguridad set
            estado_reg = 'inactivo'
            where id_certificado_seguridad=v_parametros.id_certificado_seguridad;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Certificados Seguridad eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_certificado_seguridad',v_parametros.id_certificado_seguridad::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'SG_CERSACT_MOD'
 	#DESCRIPCION:	Modificacion de registros alerta correo enviado vencimiento certificado
 	#AUTOR:		breydi.vasquez	
 	#FECHA:		04-11-2021
	***********************************/

	elsif(p_transaccion='SG_CERSACT_MOD')then

		begin
			--Sentencia de la modificacion
            if v_parametros.notificado = 'si' then
              update segu.tcertificados_seguridad set
              estado_notificacion = 'enviado',
              notificacion_vencimiento = current_date
              where id_certificado_seguridad=v_parametros.id_certificado_seguridad;
            end if;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Certificado Seguridad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_certificado_seguridad',v_parametros.id_certificado_seguridad::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;    

     /*********************************
 	#TRANSACCION:  'SG_SIGECTS_EMI'
 	#DESCRIPCION:	Siguiente estado certificado de seguridad
 	#AUTOR:		breydi.vasquez
 	#FECHA:		10-11-2021
	***********************************/
    elseif(p_transaccion='SG_SIGECTS_EMI') then
    	begin
        

            --Obtiene los datos del movimiento
            select
                id_certificado_seguridad
            into
                v_id_certificado_seguridad
            from segu.tcertificados_seguridad
            where id_estado_wf = v_parametros.id_estado_wf_act;

            --Obtención de datos del Estado Actual
            select
                ew.id_tipo_estado,
                te.pedir_obs,
                ew.id_estado_wf
            into
                v_id_tipo_estado,
                v_pedir_obs,
                v_id_estado_wf
            from wf.testado_wf ew
            inner join wf.ttipo_estado te
            on te.id_tipo_estado = ew.id_tipo_estado
            where ew.id_estado_wf = v_parametros.id_estado_wf_act;

            if pxp.f_existe_parametro(p_tabla,'id_depto_wf') then
                v_id_depto = v_parametros.id_depto_wf;
            end if;
            
            if pxp.f_existe_parametro(p_tabla,'obs') THEN
                v_obs=v_parametros.obs;
            else
                v_obs='---';
            end if;

            --Configuración del acceso directo para la alarma
            v_acceso_directo = '';
            v_clase = '';
            v_parametros_ad = '';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'Pendiente';

            select
                codigo
            into
                v_codigo_estado_siguiente
            from wf.ttipo_estado tes
            where tes.id_tipo_estado =  v_parametros.id_tipo_estado;

            if v_codigo_estado_siguiente not in ('finalizado') then
                v_acceso_directo = '../../../sis_seguridad/vista/certificados_seguridad/CertificadosSeguridad.php';
                v_clase = 'CertificadosSeguridad';
                v_parametros_ad = '{filtro_directo:{campo:"cers.id_proceso_wf",valor:"'||v_parametros.id_proceso_wf_act::varchar||'"}}';
                v_tipo_noti = 'notificacion';
                v_titulo  = 'Notificacion';
            end if;


            --Obtención id del estaado actual
            v_id_estado_actual =  wf.f_registra_estado_wf(
                v_parametros.id_tipo_estado,
                null,
/*                v_parametros.id_funcionario_wf,*/
                v_parametros.id_estado_wf_act,
                v_parametros.id_proceso_wf_act,
                p_id_usuario,
                v_parametros._id_usuario_ai,
                v_parametros._nombre_usuario_ai,
                v_id_depto,
                ' Obs: '||v_obs,
                v_acceso_directo ,
                v_clase,
                v_parametros_ad,
                v_tipo_noti,
                v_titulo
            );

            --Actualiza el estado actual del movimiento
            update segu.tcertificados_seguridad set
            id_estado_wf = v_id_estado_actual,
            estado = v_codigo_estado_siguiente
            where id_certificado_seguridad = v_id_certificado_seguridad;

          -- si hay mas de un estado disponible  preguntamos al usuario
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del Certificado de Seguridad)');
          v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
          v_resp = pxp.f_agrega_clave(v_resp,'v_codigo_estado_siguiente',v_codigo_estado_siguiente);

          -- Devuelve la respuesta
          return v_resp;
        end;

    /*********************************
 	#TRANSACCION:  'SG_ANTCTS_IME'
 	#DESCRIPCION:	Anterior estado certificado de seguridad
 	#AUTOR:		breydi.vasquez
 	#FECHA:		10-11-2021
	***********************************/
    elseif(p_transaccion='SG_ANTCTS_IME') then
    	begin


            --Obtiene los datos del movimiento
            select id_certificado_seguridad
            into v_id_certificado_seguridad
            from segu.tcertificados_seguridad
            where id_proceso_wf = v_parametros.id_proceso_wf;

            --Obtiene los datos del Estado Actual
            select
                ew.id_tipo_estado,
                te.pedir_obs,
                ew.id_estado_wf
            into
                v_id_tipo_estado,
                v_pedir_obs,
                v_id_estado_wf
            from wf.testado_wf ew
            inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
            where ew.id_estado_wf = v_parametros.id_estado_wf;

            --------------------------------------------------
            --Retrocede al estado inmediatamente anterior
            -------------------------------------------------
            SELECT
                ps_id_tipo_estado,
                ps_id_funcionario,
                ps_id_usuario_reg,
                ps_id_depto,
                ps_codigo_estado,
                ps_id_estado_wf_ant
            into
                v_id_tipo_estado,
                v_id_funcionario,
                v_id_usuario_reg,
                v_id_depto,
                v_codigo_estado,
                v_id_estado_wf_ant
            FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);


            select
            ew.id_proceso_wf
            into
            v_id_proceso_wf
            from wf.testado_wf ew
            where ew.id_estado_wf= v_id_estado_wf_ant;


            v_acceso_directo = '../../../sis_seguridad/vista/certificados_seguridad/CertificadosSeguridad.php';
            v_clase = 'CertificadosSeguridad';
            v_parametros_ad = '{filtro_directo:{campo:"cers.id_proceso_wf",valor:"'||v_parametros.id_proceso_wf_act::varchar||'"}}';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'Notificacion';


          --Registra nuevo estado
            v_id_estado_actual = wf.f_registra_estado_wf(
                v_id_tipo_estado,
                v_id_funcionario,
                v_parametros.id_estado_wf,
                v_id_proceso_wf,
                p_id_usuario,
                v_parametros._id_usuario_ai,
                v_parametros._nombre_usuario_ai,
                v_id_depto,
                '[RETROCESO] '|| v_parametros.obs,
                v_acceso_directo,
                v_clase,
                v_parametros_ad,
                v_tipo_noti,
                v_titulo
            );

            --Actualiza el estado actual
            select
            codigo
            into v_codigo_estado_siguiente
            from wf.ttipo_estado tes
            inner join wf.testado_wf ew
            on ew.id_tipo_estado = tes.id_tipo_estado
            where ew.id_estado_wf = v_id_estado_actual;

            update segu.tcertificados_seguridad set
            id_estado_wf = v_id_estado_actual,
            estado = v_codigo_estado_siguiente
            where id_certificado_seguridad = v_id_certificado_seguridad;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se retorocedio el estado del movimiento');
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

            --Devuelve la respuesta
            return v_resp;

        end;            
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

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

ALTER FUNCTION segu.ft_certificados_seguridad_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;