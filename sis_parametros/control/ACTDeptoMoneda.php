<?php
/**
 *@package pXP
 *@file gen-ACTDeptoUsuario.php
 *@author  (mzm)
 *@date 24-11-2011 18:26:47
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTDeptoMoneda extends ACTbase{

    function listarDeptoMoneda(){
        $this->objParam->defecto('ordenacion','id_depto_moneda');


        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_depto')!=''){
            $this->objParam->addFiltro("depmon.id_depto = ".$this->objParam->getParametro('id_depto'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODDeptoMoneda','listarDeptoMoneda');
        } else{
            $this->objFunc=$this->create('MODDeptoMoneda');
            $this->res=$this->objFunc->listarDeptoMoneda($this->objParam);
        }

        if($this->objParam->getParametro('_adicionar')!=''){

            $respuesta = $this->res->getDatos();

            array_unshift ( $respuesta, array(  'id_moneda'=>'0',
                'id_depto_moneda'=>'Todos',
                'moneda'=>'Todos',
                'codigo'=>'Todos'));
            //var_dump($respuesta);
            $this->res->setDatos($respuesta);
        }

        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    function insertarDeptoMoneda(){
        $this->objFunc=$this->create('MODDeptoMoneda');
        if($this->objParam->insertar('id_depto_moneda')){
            $this->res=$this->objFunc->insertarDeptoMoneda();
        } else{
            $this->res=$this->objFunc->modificarDeptoMoneda();
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarDeptoMoneda(){
        $this->objFunc=$this->create('MODDeptoMoneda');
        $this->res=$this->objFunc->eliminarDeptoMoneda();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>