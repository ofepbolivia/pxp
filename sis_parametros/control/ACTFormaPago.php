<?php
/**
*@package pXP
*@file gen-ACTFormaPago.php
*@author  (maylee.perez)
*@date 11-06-2019 20:56:48
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFormaPago extends ACTbase{

    function listarFormaPago(){
        $this->objParam->defecto('ordenacion','id_forma_pago');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODFormaPago','listarFormaPago');
        } else{
            $this->objFunc=$this->create('MODFormaPago');

            $this->res=$this->objFunc->listarFormaPago($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
	function listarFormaPagofil(){
		$this->objParam->defecto('ordenacion','orden');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFormaPago','listarFormaPagofil');
		} else{
			$this->objFunc=$this->create('MODFormaPago');
			
			$this->res=$this->objFunc->listarFormaPagofil($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

				
	function insertarFormaPago(){
		$this->objFunc=$this->create('MODFormaPago');	
		if($this->objParam->insertar('id_forma_pago')){
			$this->res=$this->objFunc->insertarFormaPago($this->objParam);
		} else{			
			$this->res=$this->objFunc->modificarFormaPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFormaPago(){
			$this->objFunc=$this->create('MODFormaPago');	
		$this->res=$this->objFunc->eliminarFormaPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>