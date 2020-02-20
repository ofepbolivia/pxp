<?php
/***
Nombre: ACTConexionOFEP.php
Proposito: Clase base para la conexión y envio de informacion a la OFEP
Autor:	Vladimir (OFEP)
Fecha:	29/01/2020
*/

class ACTConexionOFEP extends ACTbase{
	        
	function conexionOFEP($data){

		//obtención de la llave OFEP
		$this->objParam->addParametro('codigo','token_ofep');
		$this->objFunc=$this->create('sis_parametros/MODVariableGlobal');
		$key = $this->objFunc->obtenerVariableGlobal($this->objParam);
		$key = $key->getDatos();

		$data['token'] = $key['valor'];

		$json_data = json_encode($data);

		$s = curl_init();

		curl_setopt($s, CURLOPT_URL, 'https://empresas.ofep.gob.bo/api/trigger');
		curl_setopt($s, CURLOPT_POST, true);
		curl_setopt($s, CURLOPT_POSTFIELDS, $json_data);
		curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($s, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json',
			'Content-Length: ' . strlen($json_data))
		);
		$_out = curl_exec($s);
		echo $_out;
	}

}

?>