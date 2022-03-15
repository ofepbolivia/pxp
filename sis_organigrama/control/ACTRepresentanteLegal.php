<?php
/**
 *@package pXP
 *@file    ACTRepresentanteLegal.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 12:11:06
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTRepresentanteLegal extends ACTbase{

    function listarRepresentanteLegal(){
        $this->objParam->defecto('ordenacion','id_representante_legal');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODRepresentanteLegal','listarRepresentanteLegal');
        } else{
            $this->objFunc=$this->create('MODRepresentanteLegal');
            $this->res=$this->objFunc->listarRepresentanteLegal($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarRepresentanteLegal(){
        $this->objFunc=$this->create('MODRepresentanteLegal');
        if($this->objParam->insertar('id_representante_legal')){
            $this->res=$this->objFunc->insertarRepresentanteLegal($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarRepresentanteLegal($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarRepresentanteLegal(){
        $this->objFunc=$this->create('MODRepresentanteLegal');
        $this->res=$this->objFunc->eliminarRepresentanteLegal($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>