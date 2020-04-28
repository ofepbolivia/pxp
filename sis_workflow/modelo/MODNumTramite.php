<?php
/**
*@package pXP
*@file gen-MODNumTramite.php
*@author  (admin)
*@date 19-02-2013 13:51:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODNumTramite extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarNumTramite(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='wf.ft_num_tramite_sel';
		$this->transaccion='WF_NUMTRAM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_num_tramite','int4');
		$this->captura('id_proceso_macro','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('num_siguiente','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_gestion','varchar');
		$this->captura('codificacion_siguiente','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarNumTramite(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='wf.ft_num_tramite_ime';
		$this->transaccion='WF_NUMTRAM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('num_siguiente','num_siguiente','int4');		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarNumTramite(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='wf.ft_num_tramite_ime';
		$this->transaccion='WF_NUMTRAM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_num_tramite','id_num_tramite','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('num_siguiente','num_siguiente','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarNumTramite(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='wf.ft_num_tramite_ime';
		$this->transaccion='WF_NUMTRAM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_num_tramite','id_num_tramite','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
    }

	// breydi vasquez (24/04/2020) para reporte tramites aprobados por funcionarios
	//ini
    function listaTramites(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='wf.ft_num_tramite_sel';
		$this->transaccion='WF_TRAPRBXFUN_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
				
		//Define los parametros para la funcion		
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('id_usuario','id_usuario','int4');
        $this->setParametro('sistema_rep','sistema_rep','varchar');
        
        //Captura de datos 
        $this->captura('nro_tramite', 'varchar');
        $this->captura('fecha_ini', 'timestamp');
        $this->captura('fecha_fin', 'timestamp');        
        $this->captura('anterior_estado', 'varchar');                
        $this->captura('seguiente_estado', 'varchar');                
        $this->captura('proveido', 'text');                
        $this->captura('funcionario_aprobador', 'text');        
        $this->captura('solicitante', 'text');        
        $this->captura('proveedor', 'varchar');        
        $this->captura('justificacion', 'varchar');                
        $this->captura('importe', 'numeric');          
        $this->captura('moneda', 'varchar');              
        $this->captura('contador_estados', 'bigint');    
		//Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    
    function usuarioAdminTF() {
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='wf.ft_num_tramite_ime';
		$this->transaccion='WF_GETUSADMIN_IME';
		$this->tipo_procedimiento='IME';
						
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;        
	}

	function listarFuncionarioCuentas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='wf.ft_num_tramite_sel';
		$this->transaccion='WF_FUNCIOCARCS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion		
				
		//Definicion de la lista del resultado del query
		$this->captura('id_usuario','integer');
        $this->captura('cuenta','varchar');        
        $this->captura('id_uo_funcionario','integer');
        $this->captura('id_funcionario','integer');
        $this->captura('desc_funcionario1','text');
        $this->captura('desc_funcionario2','text');
        $this->captura('id_uo','integer');
        $this->captura('nombre_cargo','varchar');
        $this->captura('fecha_asignacion','date');
        $this->captura('fecha_finalizacion','date');
        $this->captura('num_doc','integer');
        $this->captura('ci','varchar');
        $this->captura('codigo','varchar');
        $this->captura('email_empresa','varchar');
        $this->captura('id_cargo','integer');
        $this->captura('descripcion_cargo','varchar');
        $this->captura('cargo_codigo','varchar');                
        $this->captura('lugar_nombre','varchar');
        $this->captura('oficina_nombre','varchar');

			
		//Ejecuta la instruccion
		$this->armarConsulta();		
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//fin
}
?>