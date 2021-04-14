<?php
/**
 *@package pXP
 *@file gen-ACTFuncionarioOficina.php
 *@author  (admin)
 *@date 29-03-2021 18:50:34
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTFuncionarioOficina extends ACTbase{

    function listarFuncionarioOficina(){
        $this->objParam->defecto('ordenacion','id_funcionario_oficina');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODFuncionarioOficina','listarFuncionarioOficina');
        } else{
            $this->objFunc=$this->create('MODFuncionarioOficina');

            $this->res=$this->objFunc->listarFuncionarioOficina($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarFuncionarioOficina(){
        $this->objFunc=$this->create('MODFuncionarioOficina');
        if($this->objParam->insertar('id_funcionario_oficina')){
            $this->res=$this->objFunc->insertarFuncionarioOficina($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarFuncionarioOficina($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarFuncionarioOficina(){
        $this->objFunc=$this->create('MODFuncionarioOficina');
        $this->res=$this->objFunc->eliminarFuncionarioOficina($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarFuncionarioOficinaREST() {
        $this->objFunc = $this->create('MODFuncionarioOficina');
        $this->res = $this->objFunc->insertarFuncionarioOficinaREST();
        $this->res->imprimirRespuesta(json_encode($this->res->getDatos()));
    }

}

?>