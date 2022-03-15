<?php
/**
*@package pXP
*@file gen-MODCertificadosSeguridad.php
*@author  (breydi.vasquez)
*@date 03-11-2021 15:36:08
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCertificadosSeguridad extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCertificadosSeguridad(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='segu.ft_certificados_seguridad_sel';
		$this->transaccion='SG_CERS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_certificado_seguridad','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('titular_certificado','varchar');
		$this->captura('entidad_certificadora','varchar');
		$this->captura('nro_serie','varchar');
		$this->captura('fecha_emision','date');
		$this->captura('fecha_vencimiento','date');
		$this->captura('tipo_certificado','varchar');
		$this->captura('clave_publica','varchar');
		$this->captura('ip_servidor','text');
		$this->captura('observaciones','text');
		$this->captura('notificacion_vencimiento','date');
		$this->captura('area_de_uso','varchar');
		$this->captura('dias_anticipacion_alerta','int4');
		$this->captura('id_funcionario_resp', 'int4');
		$this->captura('desc_funcionario', 'text');
		$this->captura('id_funcionario_cc', 'varchar');		
		$this->captura('email_cc', 'varchar');		
		$this->captura('estado_notificacion', 'varchar');		
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('id_titular_certificado','int4');
		$this->captura('id_entidad_certificadora','int4');
		$this->captura('id_tipo_certificado','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCertificadosSeguridad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='segu.ft_certificados_seguridad_ime';
		$this->transaccion='SG_CERS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		// $this->setParametro('titular_certificado','titular_certificado','varchar');
		$this->setParametro('id_titular_certificado','id_titular_certificado','int4');
		// $this->setParametro('entidad_certificadora','entidad_certificadora','varchar');
		$this->setParametro('id_entidad_certificadora','id_entidad_certificadora','int4');
		$this->setParametro('nro_serie','nro_serie','varchar');
		$this->setParametro('fecha_emision','fecha_emision','date');
		$this->setParametro('fecha_vencimiento','fecha_vencimiento','date');
		// $this->setParametro('tipo_certificado','tipo_certificado','varchar');
		$this->setParametro('id_tipo_certificado','id_tipo_certificado','int4');
		$this->setParametro('clave_publica','clave_publica','varchar');
		$this->setParametro('ip_servidor','ip_servidor','text');
		$this->setParametro('observaciones','observaciones','text');
		// $this->setParametro('notificacion_vencimiento','notificacion_vencimiento','date');
		$this->setParametro('area_de_uso','area_de_uso','varchar');
		$this->setParametro('dias_anticipacion_alerta','dias_anticipacion_alerta','int4');
		$this->setParametro('id_funcionario_resp','id_funcionario_resp','int4');
		$this->setParametro('id_funcionario_cc','id_funcionario_cc','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCertificadosSeguridad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='segu.ft_certificados_seguridad_ime';
		$this->transaccion='SG_CERS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_certificado_seguridad','id_certificado_seguridad','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		// $this->setParametro('titular_certificado','titular_certificado','varchar');
		$this->setParametro('id_titular_certificado','id_titular_certificado','int4');
		// $this->setParametro('entidad_certificadora','entidad_certificadora','varchar');
		$this->setParametro('id_entidad_certificadora','id_entidad_certificadora','int4');
		$this->setParametro('nro_serie','nro_serie','varchar');
		$this->setParametro('fecha_emision','fecha_emision','date');
		$this->setParametro('fecha_vencimiento','fecha_vencimiento','date');
		// $this->setParametro('tipo_certificado','tipo_certificado','varchar');
		$this->setParametro('id_tipo_certificado','id_tipo_certificado','int4');
		$this->setParametro('clave_publica','clave_publica','varchar');
		$this->setParametro('ip_servidor','ip_servidor','text');
		$this->setParametro('observaciones','observaciones','text');
		// $this->setParametro('notificacion_vencimiento','notificacion_vencimiento','date');
		$this->setParametro('area_de_uso','area_de_uso','varchar');
		$this->setParametro('dias_anticipacion_alerta','dias_anticipacion_alerta','int4');
		$this->setParametro('id_funcionario_resp','id_funcionario_resp','int4');
		$this->setParametro('id_funcionario_cc','id_funcionario_cc','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCertificadosSeguridad(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='segu.ft_certificados_seguridad_ime';
		$this->transaccion='SG_CERS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_certificado_seguridad','id_certificado_seguridad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function obtenerDatosCertificados() {
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='segu.ft_certificados_seguridad_sel';
		$this->transaccion='SG_CERSNOTF_SEL';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);

		$this->captura('jsonData','text');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;		
	}

	function actuEstadoNotificacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='segu.ft_certificados_seguridad_ime';
		$this->transaccion='SG_CERSACT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('notificado','notificado','varchar');
		$this->setParametro('id_certificado_seguridad','id_certificado_seguridad','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
		
    function siguienteEstado() {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'segu.ft_certificados_seguridad_ime';
        $this->transaccion = 'SG_SIGECTS_EMI';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act', 'id_proceso_wf_act', 'int4');
        $this->setParametro('id_estado_wf_act', 'id_estado_wf_act', 'int4');
        $this->setParametro('id_tipo_estado', 'id_tipo_estado', 'int4');                
        $this->setParametro('obs', 'obs', 'text');
        $this->setParametro('json_procesos', 'json_procesos', 'text');
		
        //Ejecuta la instruccion
        $this->armarConsulta();		
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function anteriorEstado() {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'segu.ft_certificados_seguridad_ime';
        $this->transaccion = 'SG_ANTCTS_IME';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf', 'id_proceso_wf', 'int4');
        $this->setParametro('id_estado_wf', 'id_estado_wf', 'int4');
        $this->setParametro('id_proceso_wf_act', 'id_proceso_wf_act', 'int4');
        $this->setParametro('obs', 'obs', 'text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>