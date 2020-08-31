<?php
/**
*@package pXP
*@file gen-MODPermisosGerencia.php
*@author  (jrivera)
*@date 07-10-2015 13:00:56
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPermisosGerencia extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarPermisosGerencias(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='orga.ft_permiso_gerencias_sel';
		$this->transaccion='ORGA_LIST_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_autorizacion','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('id_gerencia','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombres_gerencias','varchar');
		$this->captura('desc_funcionario1','varchar');
		$this->captura('nombre_cargo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarPermisosGerencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='orga.ft_permiso_gerencias_ime';
		$this->transaccion='ORGA_INSPERMISOS_INS';
		$this->tipo_procedimiento='IME';



		//Define los parametros para la funcion
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_gerencia','id_gerencia','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarPermisosGerencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='orga.ft_permiso_gerencias_ime';
		$this->transaccion='ORGA_PERMIGEREN_MOD';
		$this->tipo_procedimiento='IME';


		//Define los parametros para la funcion
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_gerencia','id_gerencia','varchar');
		$this->setParametro('id_autorizacion','id_autorizacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();

		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarPermisosGerencia(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='orga.ft_permiso_gerencias_ime';
		$this->transaccion='ORGA_PERMGEREN_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_autorizacion','id_autorizacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarGerencias(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='orga.ft_permiso_gerencias_sel';
		$this->transaccion='ORGA_LIS_GEREN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_uo','int4');
		$this->captura('nombre_unidad','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarGerenciasPermitidas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='orga.ft_permiso_gerencias_sel';
		$this->transaccion='ORGA_LIS_PERGERE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_uo','int4');
		$this->captura('descripcion','varchar');
		$this->captura('codigo','varchar');
		$this->captura('id_funcionario','integer');
		$this->captura('defecto','varchar');
		$this->captura('nombre_unidad','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>
