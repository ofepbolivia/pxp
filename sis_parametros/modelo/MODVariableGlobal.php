<?php
/**
*@package pXP
*@file gen-MODVariableGlobal.php
*@author  (ismael.valdivia)
*@date 12-05-2021 12:56:39
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODVariableGlobal extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarVariableGlobal(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='param.ft_variable_global_sel';
		$this->transaccion='PARAM_varglo_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_variable_global','int4');
		$this->captura('variable','varchar');
		$this->captura('valor','varchar');
		$this->captura('descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarVariableGlobal(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='param.ft_variable_global_ime';
		$this->transaccion='PARAM_varglo_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('variable','variable','varchar');
		$this->setParametro('valor','valor','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarVariableGlobal(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='param.ft_variable_global_ime';
		$this->transaccion='PARAM_varglo_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_variable_global','id_variable_global','int4');
		$this->setParametro('variable','variable','varchar');
		$this->setParametro('valor','valor','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarVariableGlobal(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='param.ft_variable_global_ime';
		$this->transaccion='PARAM_varglo_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_variable_global','id_variable_global','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>
