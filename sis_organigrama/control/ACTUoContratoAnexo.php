<?php
/**
 *@package pXP
 *@file gen-ACTUoContratoAnexo.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 13:16:48
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTUoContratoAnexo extends ACTbase{

    function listarUoContratoAnexo(){
        $this->objParam->defecto('ordenacion','id_uo_contrato_anexo');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_uo') != '') {
            $this->objParam->addFiltro("uo_ca.id_uo = ". $this->objParam->getParametro('id_uo'));
        }
        
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODUoContratoAnexo','listarUoContratoAnexo');
        } else{
            $this->objFunc=$this->create('MODUoContratoAnexo');

            $this->res=$this->objFunc->listarUoContratoAnexo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarUoContratoAnexo(){
        $this->objFunc=$this->create('MODUoContratoAnexo');
        if($this->objParam->insertar('id_uo_contrato_anexo')){
            $this->res=$this->objFunc->insertarUoContratoAnexo($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarUoContratoAnexo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarUoContratoAnexo(){
        $this->objFunc=$this->create('MODUoContratoAnexo');
        $this->res=$this->objFunc->eliminarUoContratoAnexo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>