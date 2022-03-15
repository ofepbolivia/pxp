<?php
/**
 *@package  BoA
 *@file     ACTBaseOperativa.php
 *@author  (franklin.espinoza)
 *@date     05-11-2021 10:16:06
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTBaseOperativa extends ACTbase{

    function listarBaseOperativa(){

        $this->objParam->defecto('ordenacion','id_funcionario_oficina');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODBaseOperativa','listarBaseOperativa');
        } else{
            $this->objFunc=$this->create('MODBaseOperativa');

            $this->res=$this->objFunc->listarBaseOperativa($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }


    function insertarBaseOperativa(){
        $this->objFunc=$this->create('MODBaseOperativa');
        if($this->objParam->insertar('id_funcionario_oficina')){
            $this->res=$this->objFunc->insertarBaseOperativa($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarBaseOperativa($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarBaseOperativa(){
        $this->objFunc=$this->create('MODBaseOperativa');
        $this->res=$this->objFunc->eliminarBaseOperativa($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>