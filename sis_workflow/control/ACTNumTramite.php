<?php
/**
*@package pXP
*@file gen-ACTNumTramite.php
*@author  (FRH)
*@date 19-02-2013 13:51:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
require_once(dirname(__FILE__).'/../reportes/REtramitesAprobados.php');
class ACTNumTramite extends ACTbase{    
			
	function listarNumTramite(){
		$this->objParam->defecto('ordenacion','id_num_tramite');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_proceso_macro')!=''){
			$this->objParam->addFiltro("prom.id_proceso_macro = ".$this->objParam->getParametro('id_proceso_macro'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODNumTramite','listarNumTramite');
		} else{
			$this->objFunc=$this->create('MODNumTramite');
			
			$this->res=$this->objFunc->listarNumTramite($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarNumTramite(){
		$this->objFunc=$this->create('MODNumTramite');	
		if($this->objParam->insertar('id_num_tramite')){
			$this->res=$this->objFunc->insertarNumTramite($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarNumTramite($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarNumTramite(){
		$this->objFunc=$this->create('MODNumTramite');	
		$this->res=$this->objFunc->eliminarNumTramite($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
    }
    
    function listaTramites(){
        $this->objFunc=$this->create('MODNumTramite');
        $dataTramite=$this->objFunc->listaTramites($this->objParam);        
        if ($dataTramite->getTipo() == 'EXITO') {
                return $dataTramite;
        } else {
                $dataTramite->imprimirRespuesta($dataTramite->generarJson());
                exit;
            }
    }

    // breydi vasquez (24/04/2020) para reporte tramites aprobados por funcionarios
    // ini
    function reporteTramiteXFuncionario() {

        $dataSource = $this->listaTramites();
        
        $nombreArchivo = 'Tramites_Aprobados'.uniqid(md5(session_id())).'.pdf';        
        //parametros basicos
        $tamano = 'LETTER';
        $orientacion = 'L';
        $titulo = 'Tramites Aprobados por Funcionario';


        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        
        //Instancia la clase de pdf        
        $reporte = new REtramitesAprobados($this->objParam);
        $reporte->setDatos($dataSource->getDatos());
        $reporte->generarReporte();
        $reporte->output($reporte->url_archivo,'F');

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    
    function usuarioAdminTF() {        
		$this->objFunc=$this->create('MODNumTramite');	
		$this->res=$this->objFunc->usuarioAdminTF($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());        
    }
     
    function listarFuncionarioCuentas() {                 
		$this->objFunc=$this->create('MODNumTramite');	
		$this->res=$this->objFunc->listarFuncionarioCuentas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());        
    }    
		//fin	
}

?>