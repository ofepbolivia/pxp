<?php
class ACTTabla extends ACTbase{
	
	


	function listarTabla(){		
		$this->objParam->defecto('ordenacion','id_tabla');
		$this->objParam->defecto('dir_ordenacion','asc');
		
			if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte=new Reporte($this->objParam, $this);
			$this->res=$this->objReporte->generarReporteListado('MODTabla','listarTabla');
		}
		else {
			$this->objFunc=$this->create('MODTabla');	
		    $this->res=$this->objFunc->listarTabla();
		}
	
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarTablaCombo(){		
		if($this->objParam->getParametro('esquema')!=''){
			$this->objParam->addFiltro("n.nspname=''".strtolower($this->objParam->getParametro('esquema'))."''");
		}
		$this->objFunc=$this->create('MODTabla');		
		$this->res=$this->objFunc->listarTablaCombo();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function guardarTabla(){
		$this->objFunc=$this->create('MODTabla');
		if($this->objParam->insertar('id_tabla')){
			$this->res=$this->objFunc->insertarTabla();			
		}
		else{			
			$this->res=$this->objFunc->modificarTabla();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
	function eliminarTabla(){
		$this->objFunc=$this->create('MODTabla');	
		$this->res=$this->objFunc->eliminarTabla();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    //{develop:franklin.espinoza date:27/7/2020}
    function uploadCsvDataTable(){

        //validar extnsion del archivo
        $arregloFiles = $this->objParam->getArregloFiles();
        $ext = pathinfo($arregloFiles['archivo']['name']);
        $extension = $ext['extension'];
        $error = 'no';
        $mensaje_completo = '';
        if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){
            if ($extension != 'csv' && $extension != 'CSV') {
                $mensaje_completo = "La extensión del archivo debe ser CSV";
                $error = 'error_fatal';
            }
            //upload directory
            $upload_dir = "/var/www/html/kerp/sis_generador/data/";
            //create file name
            $file_path = $upload_dir . $arregloFiles['archivo']['name'];

            //move uploaded file to upload dir
            if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {
                //error moving upload file
                $mensaje_completo = "Error al guardar el archivo csv en disco";
                $error = 'error_fatal';
            }

        } else {
            $mensaje_completo = "No se subio el archivo";
            $error = 'error_fatal';
        }

        $registros = array();
        $bandera_col = true;
        $estructura = array();

        if (($fichero = fopen("/var/www/html/kerp/sis_generador/data/".$ext['filename'].".csv", "r")) !== FALSE) {
            // Lee los registros
            while (($datos = fgetcsv($fichero, 0, ";", "\"", "\"")) !== FALSE) {
                // Crea un array asociativo con los nombres y valores de los campos
                if($bandera_col){
                    foreach ($datos as $rec){
                        $estructura[] = strtolower(trim(preg_replace('([^A-Za-z _])', '', $rec)));
                    }
                    $bandera_col = false;
                }else {
                    //$reg = new stdClass();
                    $reg = array();

                    foreach ($estructura as $key => $rec){
                        $reg["$rec"] = trim($datos[$key]);

                    }
                    // Añade el registro leido al array de registros
                    $registros[] = $reg;
                }
            }

            fclose($fichero);
        }
        
        $records = json_encode($registros, JSON_UNESCAPED_UNICODE);

        $this->objParam->addParametro('action', $this->objParam->getParametro('action'));
        $this->objParam->addParametro('tabla', $this->objParam->getParametro('table'));
        $this->objParam->addParametro('columns', $this->objParam->getParametro('columns'));
        $this->objParam->addParametro('headers', implode(',',$estructura));
        $this->objParam->addParametro('registros', $records);
        $this->objFunc=$this->create('MODTabla');
        $this->res=$this->objFunc->uploadCsvDataTable($this->objParam);

        //armar respuesta en caso de exito o error en algunas tuplas
        if ($error == 'error') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTReporte.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
                $mensaje_completo,'control');
        } else if ($error == 'no') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('EXITO','ACTReporte.php','El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito','control');
        }
        //devolver respuesta
        $this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
    }

}

?>