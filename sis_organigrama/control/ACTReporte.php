<?php
/**
 *@package      pXP
 *@file         ACTReporte.php
 *@author       (fea)
 *@date         19-04-2018 16:05:34
 *@description  Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
require_once(dirname(__FILE__).'/../reportes/RCorreosDeEmpleadosXls.php');

class ACTReporte extends ACTbase{

    //reporte formato excel de los correos de los empleados activos de planta o eventuales
    function reporteCorreosEmpleadosBoa(){

        $this->objFunc=$this->create('MODReporte');
        $this->res=$this->objFunc->reporteCorreosEmpleadosBoa($this->objParam);

        $this->datos=$this->res->getDatos();
        $titulo_archivo = 'Lista de Correos';
        $nombreArchivo = uniqid(md5(session_id()).$titulo_archivo).'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $this->objParam->addParametro('titulo_archivo',$titulo_archivo);
        $this->objParam->addParametro('datos',$this->datos);

        $this->objReporte = new RCorreosDeEmpleadosXls($this->objParam);
        $this->objReporte->generarReporte();


        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>