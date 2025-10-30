<?php
/**
 * @package      pXP
 * @file         ACTReporte.php
 * @author       (fea)
 * @date         19-04-2018 16:05:34
 * @description  Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
require_once(dirname(__FILE__) . '/../reportes/RCorreosDeEmpleadosXls.php');
require_once(dirname(__FILE__) . '/../reportes/RCumpleanosEmpleadosXls.php');
require_once(dirname(__FILE__) . '/../reportes/RDocumentosRHDXls.php');
require_once(dirname(__FILE__) . '/../reportes/RInformacionRapidaRRHHXls.php');
require_once(dirname(__FILE__) . '/../reportes/REstructuraUo.php');
require_once(dirname(__FILE__) . '/../reportes/RFuncionarios.php');
require_once(dirname(__FILE__) . '/../reportes/RDetalleCargos.php');

class ACTReporte extends ACTbase
{

    //reporte formato excel de los correos de los empleados activos de planta o eventuales
    function reporteCorreosEmpleadosBoa()
    {

        $this->objFunc = $this->create('MODReporte');
        $this->res = $this->objFunc->reporteCorreosEmpleadosBoa($this->objParam);

        $this->datos = $this->res->getDatos();
        $titulo_archivo = 'Lista de Correos';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo_archivo) . '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('titulo_archivo', $titulo_archivo);
        $this->objParam->addParametro('datos', $this->datos);

        $this->objReporte = new RCorreosDeEmpleadosXls($this->objParam);
        $this->objReporte->generarReporte();


        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }


    //reporte formato excel de los cumpleañeros de los empleados activos de planta o eventuales
    function reporteCumpleEmpleadosBoa()
    {

        //var_dump($this->objParam->getParametro('id_gestion'));var_dump($this->objParam->getParametro('id_periodo'));exit;
        $this->objFunc = $this->create('MODReporte');
        $this->res = $this->objFunc->reporteCumpleEmpleadosBoa($this->objParam);

        $this->datos = $this->res->getDatos();
        $titulo_archivo = 'Lista de Cumpleañeros';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo_archivo) . '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('titulo_archivo', $titulo_archivo);
        $this->objParam->addParametro('datos', $this->datos);

        $this->objReporte = new RCumpleanosEmpleadosXls($this->objParam);
        $this->objReporte->generarReporte();


        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function reporteGeneralRRHH()
    {
        $configuracion = $this->objParam->getParametro('configuracion_reporte');
        $nombreArchivo = '';

        switch ($configuracion) {
            case 'documentos': //Adalid: Refactorizado 22/09/2025
                $nombreArchivo = $this->generarDocumentosRrhh();
                break;
            case 'informacion': //Adalid: Refactorizado 22/09/2025
                $nombreArchivo = $this->generarInformacionRapida();
                break;
            case 'estructurauo': //Adalid: reporte HR 2025-01218
                $nombreArchivo = $this->generarEstructuraOrganizacional();
                break;
            case 'cargosunidad': //Adalid: reporte HR 2025-01218
                $nombreArchivo = $this->generarDetalleDeCargos();
                break;
            case 'funcionarios': //Adalid: reporte HR 2025-01218
                $nombreArchivo = $this->generarFuncionariosActivos();
                break;
            default:
                throw new Exception('Configuración de reporte no válida');
        }

        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    private function generarDocumentosRrhh()
    {
        $titulo = 'Lista de Documentos';

        $this->objFunc = $this->create('MODReporte');
        $this->headers = $this->objFunc->headerDocumentos($this->objParam);
        $this->headers = $this->headers->getDatos();

        $this->objFunc = $this->create('MODReporte');
        $this->res = $this->objFunc->reporteListaDocumentos($this->objParam);
        $this->datos = $this->res->getDatos();

        $nombreArchivo = uniqid(md5(session_id()) . $titulo) . '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('titulo_archivo', $titulo);
        $this->objParam->addParametro('headers', $this->headers);
        $this->objParam->addParametro('datos', $this->datos);

        $this->objReporte = new RDocumentosRHDXls($this->objParam);
        $this->objReporte->generarReporte();
        return $nombreArchivo;
    }

    private function generarInformacionRapida()
    {
        $titulo = 'Información Rapida';
        $this->objFunc = $this->create('MODReporte');
        $this->res = $this->objFunc->reporteInformacionRapida($this->objParam);
        $this->datos = $this->res->getDatos();

        $nombreArchivo = uniqid(md5(session_id()) . $titulo) . '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('titulo_archivo', $titulo);
        $this->objParam->addParametro('datos', $this->datos);

        $this->objReporte = new RInformacionRapidaRRHHXls($this->objParam);
        $this->objReporte->generarReporte();
        return $nombreArchivo;
    }

    private function generarEstructuraOrganizacional()
    {
        $titulo = 'EstructuraOrganizacional';
        $tamano = 'LETTER';
        $orientacion = 'P';

        $this->objFunc = $this->create('MODReporte');
        $this->res = $this->objFunc->reporteExtructuraOrganizacional();
        $nombreArchivo = uniqid(md5(session_id()) . $titulo) . '.pdf';

        $this->objParam->addParametro('tamano', $tamano);
        $this->objParam->addParametro('orientacion', $orientacion);
        $this->objParam->addParametro('titulo_archivo', $titulo);
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);

        $this->objReporte = new REstructuraUo($this->objParam);
        $this->objReporte->setTitulo("ESTRUCTURA ORGANIZACIONAL");
        $this->objReporte->datosHeader($this->res->getDatos());
        $this->objReporte->generarEstructuraOrganizacional();
        $this->objReporte->output($this->objReporte->url_archivo, 'F');
        return $nombreArchivo;
    }

    public function listarEstructuraOrganizacional()
    {
        $this->objFunc = $this->create('MODReporte');
        $this->res = $this->objFunc->reporteExtructuraOrganizacional();//var_dump($this->res);exit;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    private function generarDetalleDeCargos()
    {
        $titulo = 'DetalleDeCargos';
        $tamano = 'LETTER';
        $orientacion = 'P';

        $id_uo = $this->objParam->getParametro('id_uo');
        $unidad = $this->objParam->getParametro('unidad');
        $this->objParam->addParametro('id_uo', $id_uo);
        $this->objFun = $this->create('MODUoFuncionario');
        $this->res = $this->objFun->reportarUoFuncionario($this->objParam);

        $nombreArchivo = uniqid(md5(session_id()) . $titulo) . '.pdf';

        $this->objParam->addParametro('tamano', $tamano);
        $this->objParam->addParametro('orientacion', $orientacion);
        //$this->objParam->addParametro('unidad', $unidad);
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);

        $this->objReporte = new RDetalleCargos($this->objParam);
        $this->objReporte->datosHeader($this->res->getDatos());
        $this->objReporte->setUnidad($unidad);
        $this->objReporte->generarReporte();
        $this->objReporte->output($this->objReporte->url_archivo, 'F');
        return $nombreArchivo;
    }

    private function generarFuncionariosActivos()
    {
        $titulo = 'FuncionariosActivos';
        $tamano = 'LETTER';
        $orientacion = 'L';

        $this->objFun = $this->create('MODFuncionario');
        $this->res = $this->objFun->listarFuncionario($this->objParam);

        $nombreArchivo = uniqid(md5(session_id()) . $titulo) . '.pdf';
        $this->objParam->addParametro('tamano', $tamano);
        $this->objParam->addParametro('orientacion', $orientacion);
        $this->objParam->addParametro('titulo_archivo', $titulo);
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);

        $reporte = new RFuncionarios($this->objParam);
        $reporte->datosHeader($this->res->getDatos());
        $reporte->generarReporte();
        $reporte->output($reporte->url_archivo, 'F');
        return $nombreArchivo;
    }

    /*function reporteGeneralRRHH(){ //Código anterior al refactorizado
        $tamano = 'LETTER';
        $orientacion = 'P';

        $this->objFunc = $this->create('MODReporte');
        if($this->objParam->getParametro('configuracion_reporte') == 'documentos'){
            $this->headers = $this->objFunc->headerDocumentos($this->objParam);
            $this->objFunc=$this->create('MODReporte');
            $this->res = $this->objFunc->reporteListaDocumentos($this->objParam);
            $titulo_archivo = 'Lista de Documentos';

            $this->headers=$this->headers->getDatos();

            $this->objParam->addParametro('headers',$this->headers);
        }

        if($this->objParam->getParametro('configuracion_reporte') == 'informacion'){
            $this->objFunc=$this->create('MODReporte');
            $this->res = $this->objFunc->reporteInformacionRapida($this->objParam);
            $titulo_archivo = 'Información Rapida';
        }

        if($this->objParam->getParametro('configuracion_reporte') == 'estructurauo'){
            $this->res = $this->objFunc->reporteExtructuraOrganizacional();
            $titulo_archivo = 'EstructuraOrganizacional';
        }

        if($this->objParam->getParametro('configuracion_reporte') == 'funcionarios'){
            $this->res = $this->reportarFuncionariosActivos();
            $titulo_archivo = 'Funcionarios';
        }

        $this->datos = $this->res->getDatos();

        $nombreArchivo = uniqid(md5(session_id()).$titulo_archivo).'.xls';
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        $this->objParam->addParametro('titulo_archivo',$titulo_archivo);
        $this->objParam->addParametro('datos',$this->datos);


        if($this->objParam->getParametro('configuracion_reporte') == 'documentos'){
            $this->objReporte = new RDocumentosRHDXls($this->objParam);
            $this->objReporte->generarReporte();
        }

        if($this->objParam->getParametro('configuracion_reporte') == 'informacion'){
            $this->objReporte = new RInformacionRapidaRRHHXls($this->objParam);
            $this->objReporte->generarReporte();
        }

        if($this->objParam->getParametro('configuracion_reporte') == 'estructurauo'){
            $nombreArchivo = uniqid(md5(session_id()).$titulo_archivo).'.pdf';
            $this->objParam->addParametro('orientacion', $orientacion);
            $this->objParam->addParametro('tamano', $tamano);
            $this->objParam->addParametro('titulo_archivo', 'Estructura Organizacional');
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos','');
            $this->objReporte = new REstructuraUo($this->objParam);
            $this->objReporte->datosHeader($this->datos);
            $this->objReporte->generarEstructuraOrganizacional();
            $this->objReporte->output($this->objReporte->url_archivo, 'F');
        }

        if($this->objParam->getParametro('configuracion_reporte') == 'funcionarios'){
            $orientacion = 'L';
            $nombreArchivo = uniqid(md5(session_id()).$titulo_archivo).'.pdf';
            $this->objParam->addParametro('orientacion', $orientacion);
            $this->objParam->addParametro('tamano', $tamano);
            $this->objParam->addParametro('titulo_archivo', 'Estructura Organizacional');
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos','');
            $reporte = new RFuncionarios($this->objParam);
            $reporte->datosHeader($this->datos);
            $reporte->generarReporte();
            $reporte->output($reporte->url_archivo, 'F');
        }

        $mensajeExito = new Mensaje();
        $mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->res = $mensajeExito;
        $this->res->imprimirRespuesta($this->res->generarJson());
    }*/
}

?>