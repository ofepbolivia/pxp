<?php
/**
*@package pXP
*@file gen-ACTPermisosGerencia.php
*@author  (Ismael Valdivia)
*@date 26-08-2020 10:40:56
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPermisosGerencia extends ACTbase{

	function listarPermisosGerencias(){
		$this->objParam->defecto('ordenacion','id_autorizacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPermisosGerencia','listarPermisosGerencias');
		} else{
			$this->objFunc=$this->create('MODPermisosGerencia');

			$this->res=$this->objFunc->listarPermisosGerencias($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

  function insertarPermisosGerencia(){
      $this->objFunc=$this->create('MODPermisosGerencia');
      if($this->objParam->insertar('id_autorizacion')){
          $this->res=$this->objFunc->insertarPermisosGerencia($this->objParam);
      } else{
          $this->res=$this->objFunc->modificarPermisosGerencia($this->objParam);
      }
      $this->res->imprimirRespuesta($this->res->generarJson());
  }

	function eliminarPermisosGerencia(){
			$this->objFunc=$this->create('MODPermisosGerencia');
		$this->res=$this->objFunc->eliminarPermisosGerencia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarGerencias(){
			$this->objFunc=$this->create('MODPermisosGerencia');
			$this->res=$this->objFunc->listarGerencias($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarGerenciasPermitidas(){
			$this->objFunc=$this->create('MODPermisosGerencia');
			$this->res=$this->objFunc->listarGerenciasPermitidas($this->objParam);	
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


}

?>
