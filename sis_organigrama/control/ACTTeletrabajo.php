<?php
/**
*@package pXP
*@file ACTTeletrabajo.php
*@author  (Ismael Valdivia)
*@date 26-05-2020 21:00
*@description Servicio para Formulario de Teletrabajo
*/

class ACTTeletrabajo extends ACTbase{

/*Consultamos el Servicio para obtener datos del funcionario*/
	function ConsultaFuncionarioTeletrabajo(){
		$this->objFunc=$this->create('MODTeletrabajo');
			$this->res=$this->objFunc->ConsultaFuncionarioTeletrabajo($this->objParam);
		  $this->res->imprimirRespuesta($this->res->generarJson());
	}

  function InsertarFuncionarioTeleTrabajo(){

	  //g-recaptcha-response
	  $url = "https://www.google.com/recaptcha/api/siteverify";
	  $privateKey = "6LdD1fwUAAAAABdSETjibK4bCT8Ev8PLFN1yLx2s";
	  $res_captcha = $this->objParam->getParametro('g-recaptcha-response');
	  $response = file_get_contents($url . "?secret=" . $privateKey . "&response=" . $res_captcha);
	  $data = json_decode($response);
	  if (isset($data->success) and $data->success == true) {

		  $this->objFunc=$this->create('MODTeletrabajo');
		  $this->res=$this->objFunc->InsertarFuncionarioTeleTrabajo($this->objParam);
		  $this->res->imprimirRespuesta($this->res->generarJson());

	  }else{
		  echo "eres un robot";
	  }
	  
		
	}

}

?>
