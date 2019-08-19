<?php
/**
*@package pXP
*@file gen-MODFormaPago.php
*@author  (maylee.perez)
*@date 11-06-2019 20:56:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFormaPago extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFormaPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='param.ft_forma_pago_sel';
		$this->transaccion='PM_FORDEPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_forma_pago','int4');
        $this->captura('desc_forma_pago','varchar');
        $this->captura('observaciones','varchar');
        $this->captura('cod_inter','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('tipo','varchar');
        $this->captura('orden','numeric');
        $this->captura('codigo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarFormaPagofil(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='param.ft_forma_pago_sel';
		$this->transaccion='PM_FORDEPAFI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_forma_pago','int4');
        $this->captura('desc_forma_pago','varchar');
        $this->captura('observaciones','varchar');
        $this->captura('cod_inter','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('orden','numeric');
        $this->captura('codigo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
		$this->ejecutarConsulta();
//var_dump('llega con',$this->respuesta );exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFormaPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='param.ft_forma_pago_ime';
		$this->transaccion='PM_FORDEPA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('desc_forma_pago','desc_forma_pago','varchar');
        $this->setParametro('observaciones','observaciones','varchar');
        $this->setParametro('cod_inter','cod_inter','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('orden','orden','numeric');
        $this->setParametro('codigo','codigo','varchar');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
//        var_dump('llega form ins %',$this->respuesta)	;exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFormaPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='param.ft_forma_pago_ime';
		$this->transaccion='PM_FORDEPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_forma_pago','id_forma_pago','int4');
        $this->setParametro('desc_forma_pago','desc_forma_pago','varchar');
        $this->setParametro('observaciones','observaciones','varchar');
        $this->setParametro('cod_inter','cod_inter','varchar');
        $this->setParametro('fecha_mod','fecha_mod','timestamp');
        $this->setParametro('id_usuario_mod','id_usuario_mod','int4');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('orden','orden','numeric');
        $this->setParametro('codigo','codigo','varchar');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFormaPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='param.ft_forma_pago_ime';
		$this->transaccion='PM_FORDEPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_forma_pago','id_forma_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>