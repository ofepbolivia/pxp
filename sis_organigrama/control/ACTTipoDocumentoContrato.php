<?php
/**
 *@package pXP
 *@file gen-ACTTipoDocumentoContrato.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 16:12:10
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTTipoDocumentoContrato extends ACTbase{

    function listarTipoDocumentoContrato(){
        $this->objParam->defecto('ordenacion','id_tipo_documento_contrato');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('tipo') != ''){
            $this->objParam->addFiltro("tip_dc.tipo = ''".$this->objParam->getParametro('tipo')."''");
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODTipoDocumentoContrato','listarTipoDocumentoContrato');
        } else{
            $this->objFunc=$this->create('MODTipoDocumentoContrato');

            $this->res=$this->objFunc->listarTipoDocumentoContrato($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarTipoDocumentoContrato(){
        $this->objFunc=$this->create('MODTipoDocumentoContrato');
        if($this->objParam->insertar('id_tipo_documento')){
            $this->res=$this->objFunc->insertarTipoDocumentoContrato($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarTipoDocumentoContrato($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarTipoDocumentoContrato(){
        $this->objFunc=$this->create('MODTipoDocumentoContrato');
        $this->res=$this->objFunc->eliminarTipoDocumentoContrato($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>