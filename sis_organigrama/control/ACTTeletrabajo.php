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
	  if (isset($data->success) and $data->success == true) {*/

		  $this->objFunc=$this->create('MODTeletrabajo');
		  $this->res=$this->objFunc->InsertarFuncionarioTeleTrabajo($this->objParam);
		  $this->res->imprimirRespuesta($this->res->generarJson());

	  }else{
		  echo "eres un robot";
	  }


	}

	function listarTeletrabajo(){

		$this->objParam->defecto('ordenacion','id_teletrabajo');
        $this->objParam->defecto('dir_ordenacion','asc');

				if ($this->objParam->getParametro('pes_estado') == 'borrador') {
						$this->objParam->addFiltro("tele.estado_solicitud is NULL");
				}

				if ($this->objParam->getParametro('pes_estado') == 'aprobados') {
						$this->objParam->addFiltro("tele.estado_solicitud = ''si''");
				}

				if ($this->objParam->getParametro('pes_estado') == 'rechazados') {
						$this->objParam->addFiltro("tele.estado_solicitud = ''no''");
				}


		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTeletrabajo','listarTeletrabajo');
		} else{
			$this->objFunc=$this->create('MODTeletrabajo');

			$this->res=$this->objFunc->listarTeletrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


	function evaluarFormulario(){

		  $this->objFunc=$this->create('MODTeletrabajo');
		  $this->res=$this->objFunc->evaluarFormulario($this->objParam);
		  $this->res->imprimirRespuesta($this->res->generarJson());


	}



}

?>
