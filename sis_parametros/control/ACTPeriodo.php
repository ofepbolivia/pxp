<?php
/**
*@package pXP
*@file gen-ACTPeriodo.php
*@author  (admin)
*@date 20-02-2013 04:11:23
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPeriodo extends ACTbase{

	function listarPeriodo(){
		$this->objParam->defecto('ordenacion','periodo');

	    if($this->objParam->getParametro('id_gestion')!=''){
	    	$this->objParam->addFiltro("per.id_gestion = ".$this->objParam->getParametro('id_gestion'));
		}

		if($this->objParam->getParametro('fecha')!=''){
	    	$this->objParam->addFiltro("per.id_periodo = (select po_id_periodo from param.f_get_periodo_gestion(''".$this->objParam->getParametro('fecha')."''))");
		}

		/*Aumentnado para recuperar los periodos de la gestion Actual (Ismael Valdivia 10/11/2021)*/
		if ($this->objParam->getParametro('gestion_actual') != '' ) {
			$this->objParam->addFiltro("per.id_gestion = (select ges.id_gestion
					                        from param.tgestion ges
					                        where ges.gestion = (select extract(year from now()::date))
					                        )");
		}
		/*******************************************************************************************/

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPeriodo','listarPeriodo');
		} else{
			$this->objFunc=$this->create('MODPeriodo');

			$this->res=$this->objFunc->listarPeriodo($this->objParam);
		}
        if($this->objParam->getParametro('_adicionar')!=''){
            $respuesta = $this->res->getDatos();
            array_unshift ( $respuesta, array(  'id_periodo'=>'0',
                'periodo'=>'--TODOS--',
                'id_gestion'=>'0',
                'literal'=>'--TODOS--'));
            //var_dump($respuesta);
            $this->res->setDatos($respuesta);
        }
		$this->res->imprimirRespuesta($this->res->generarJson());
	}


	function insertarPeriodo(){
		$this->objFunc=$this->create('MODPeriodo');
		if($this->objParam->insertar('id_periodo')){
			$this->res=$this->objFunc->insertarPeriodo($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarPeriodo(){
			$this->objFunc=$this->create('MODPeriodo');
		$this->res=$this->objFunc->eliminarPeriodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function literalPeriodo(){
		$this->objFunc=$this->create('MODPeriodo');
		$this->res=$this->objFunc->literalPeriodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>
