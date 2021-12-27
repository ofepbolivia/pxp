<?php
/**
*@package pXP
*@file gen-ACTProveedor.php
*@author  (mzm)
*@date 15-11-2011 10:44:58
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProveedor extends ACTbase{    
			
	function listarProveedor(){
		$this->objParam->defecto('ordenacion','id_proveedor');
		$this->objParam->defecto('dir_ordenacion','asc');
		//echo $this->objParam->getParametro('id_servicio');exit;
		
		if($this->objParam->getParametro('id_servicio')!=null){
			$aux="provee.id_proveedor in (select id_proveedor from param.tproveedor_item_servicio itserv where itserv.id_servicio = ".$this->objParam->getParametro('id_servicio').")";
			$this->objParam->addFiltro($aux);
		} 
		if($this->objParam->getParametro('id_item')!=null){
			$aux="provee.id_proveedor in (select id_proveedor from param.tproveedor_item_servicio itserv where itserv.id_item = ".$this->objParam->getParametro('id_item').")";
			$this->objParam->addFiltro($aux);
		}
		
		
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODProveedor','listarProveedor');
		} else{
			$this->objFunc=$this->create('MODProveedor');	
			$this->res=$this->objFunc->listarProveedor();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function listarProveedorV2(){
		$this->objParam->defecto('ordenacion','id_proveedor');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('prov_estado')=='borrador'){
             $this->objParam->addFiltro("provee.estado in (''borrador'')");
        }
        if($this->objParam->getParametro('prov_estado')=='en_proceso'){
             $this->objParam->addFiltro("provee.estado not in (''borrador'',''aprobado'',''anulado'')");
        }
        if($this->objParam->getParametro('prov_estado')=='finalizados'){
             $this->objParam->addFiltro("provee.estado in (''aprobado'',''anulado'')");
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODProveedor','listarProveedorV2');
		} else{
			$this->objFunc=$this->create('MODProveedor');	
			$this->res=$this->objFunc->listarProveedorV2();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function listarProveedorWf(){
		$this->objParam->defecto('ordenacion','id_proveedor');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]);
		
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODProveedor','listarProveedorWf');
		} else{
			$this->objFunc=$this->create('MODProveedor');	
			$this->res=$this->objFunc->listarProveedorWf();
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}



	function listarProveedorCombos(){
		$this->objParam->defecto('ordenacion','id_proveedor');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam, $this);
			$this->res = $this->objReporte->generarReporteListado('MODProveedor','listarProveedorCombos');
		} else{
			$this->objFunc=$this->create('MODProveedor');
			$this->res=$this->objFunc->listarProveedorCombos();
		}
		if($this->objParam->getParametro('_adicionar')!=''){

            $respuesta = $this->res->getDatos();

            array_unshift ( $respuesta, array(  'id_proveedor'=>'0',
                'rotulo_comercial'=>'Todos', 'desc_proveedor'=>'Todos'
            ));
            //		var_dump($respuesta);
            $this->res->setDatos($respuesta);
        }
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    //(may) conexion al sistema ALkym
    function conexionAlkym(){
        $this->objParam->addParametro('variable_global','servicio_alkym');
        $this->objFunc = $this->create('sis_parametros/MODVariableGlobal');
        $cbteHeader = $this->objFunc->conexionAlkym($this->objParam);
        if ($cbteHeader->getTipo() == 'EXITO') {
            return $cbteHeader;
        } else {
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }
    }
				
	function insertarProveedor(){

        //para la conexion con Alkym
        $variable_global = $this->conexionAlkym();
        $conexionAlkym = $variable_global->getDatos();
        $respuesta = $conexionAlkym[0]["variable_obtenida"];

        //variable global = 'si'
        if ($respuesta == 'si') {

                $tipo = $this->objParam->getParametro('tipo');

                //TIPO PROVEEDOR GENERAL
                if($tipo == 'general' || $tipo == ''){
                    //var_dump('llega general' );exit;

                     $this->objFunc=$this->create('MODProveedor');
                     if($this->objParam->insertar('id_proveedor')){
                         $this->res=$this->objFunc->insertarProveedor();
                     } else{
                         $this->res=$this->objFunc->modificarProveedor();
                     }
                    $this->res->imprimirRespuesta($this->res->generarJson());

                }else{
                 //TIPO PROVEEDOR BROKER, HACE CONEXION CON ALKYM
                    //var_dump('llega broker' );exit;

                    //PARA INSERTAR
                    if($this->objParam->insertar('id_proveedor')){
                        //var_dump('llega INS' );exit;

                            $credenciales = '';

                            $codigo = $this->objParam->getParametro('codigo_alkym');
                            $nombre_dinamico = $this->objParam->getParametro('nombre_dinamico');

                            $fecha = new DateTime($this->objParam->getParametro('fecha_reg'));
                            $fecha_format =  date_format($fecha,'Y-m-d');

                            $direccion_dinamico = $this->objParam->getParametro('direccion_dinamico');
                            $nombre_ciudad = $this->objParam->getParametro('nombre_ciudad');
                            $nombre_departamento = $this->objParam->getParametro('nombre_departamento');
                            $nombre_pais = $this->objParam->getParametro('nombre_pais');
                            $correo_dinamico = $this->objParam->getParametro('correo_dinamico');
                            $num_proveedor = $this->objParam->getParametro('num_proveedor');
                            $telefono_dinamico = $this->objParam->getParametro('telefono_dinamico');
                            $fax_dinamico = $this->objParam->getParametro('fax_dinamico');
                            $correo_dinamico2 = $this->objParam->getParametro('correo_dinamico2');
                            $codigo_fabricante = $this->objParam->getParametro('codigo_fabricante');
                            $pagweb_dinamico =  $this->objParam->getParametro('pagweb_dinamico');
                            $observaciones = $this->objParam->getParametro('observaciones_dinamico');
                            $ci = $this->objParam->getParametro('doc_ci');

                            $dnrp = $this->objParam->getParametro('dnrp');
                            $nit = $this->objParam->getParametro('nit');
                            $ingreso_bruto = $this->objParam->getParametro('ingreso_bruto');
                            $cod_moneda= $this->objParam->getParametro('cod_moneda');
                            $codigo_externo = $this->objParam->getParametro('codigo_externo');
                            $tipo_habilitacion = $this->objParam->getParametro('tipo_habilitacion');
                            $motivo_habilitacion = $this->objParam->getParametro('motivo_habilitacion');



                            $dato = array (
                                "Tipo"=>"INS",
                                "IdProveedor"=>"0",
                                "Codigo"=>$codigo,
                                "Nombre"=>$nombre_dinamico,
                                "FechaAlta"=>$fecha_format,
                                "Direccion"=>$direccion_dinamico,
                                "Ciudad"=>$nombre_ciudad,
                                "Estado"=>$nombre_departamento,
                                "Pais"=>$nombre_pais,
                                "emailContacto"=>$correo_dinamico,
                                "cp"=>$num_proveedor,
                                "Telefono"=>$telefono_dinamico,
                                "Fax"=>$fax_dinamico,
                                "email"=>$correo_dinamico2,
                                "CodigoFabricante"=>$codigo_fabricante,
                                "DireccInternet"=>$pagweb_dinamico,
                                "Observacion"=>$observaciones,
                                "NroDocumento"=>$ci,
                                "DNRP"=>$dnrp,
                                "CUIT"=>$nit,
                                "IngrBrutos"=>$ingreso_bruto,
                                "Moneda"=>$cod_moneda,
                                "CodigoExterno"=>$codigo_externo,
                                "TipoHabilitacion"=>$tipo_habilitacion,
                                "MotivoHabilitacion"=>$motivo_habilitacion

                            );

                            $dato_json = json_encode($dato);
                        var_dump('llega',$dato_json);
                            $dato_envio = array ("Credenciales"=>$credenciales, "dato"=>$dato_json);
                            $dato_envio_json = json_encode ($dato_envio);

                              //27-12-2021(may) se modifico el servicio por Jhon Claros
                              //$request =  'http://sms.obairlines.bo/ServSisComm/servSiscomm.svc/RegistrarProveedor';
                              $request =  'http://sms.obairlines.bo/ServMantenimiento/servSiscomm.svc/RegistrarProveedor';
                              $session = curl_init($request);
                              curl_setopt($session, CURLOPT_CUSTOMREQUEST, "POST");
                              curl_setopt($session, CURLOPT_POSTFIELDS, $dato_envio_json);
                              curl_setopt($session, CURLOPT_RETURNTRANSFER, true);
                              curl_setopt($session, CURLOPT_HTTPHEADER, array(
                                      'Content-Type: application/json',
                                      'Content-Length: ' . strlen($dato_envio_json))
                              );

                              $result = curl_exec($session);
                              curl_close($session);

                              $respuesta = json_decode($result);
                              $respuesta_final = json_decode($respuesta->RegistrarProveedorResult);


                      //var_dump('llega ressp', $respuesta_final);exit;
                              if (($respuesta_final->codigo == null) || ($respuesta_final->codigo == '')) {
                                  throw new Exception('No se puede conectar con el servicio Alkym. Porfavor consulte con el Área de Sistemas');
                              }


                            if ($respuesta_final->codigo != 1) {

                                throw new Exception($respuesta_final->mensaje.'favor verifique');

                            } else {
                                $id_alkym_recu=$respuesta_final->objeto;
                                $id_alkym_proveedor = $id_alkym_recu->IdProveedor_alkym;

                                $this->objParam->addParametro('id_alkym_proveedor',$id_alkym_proveedor);

                                $this->objFunc=$this->create('MODProveedor');
                                $this->res=$this->objFunc->insertarProveedor();

                                $this->res->imprimirRespuesta($this->res->generarJson());
                            }


                    }else{
                    //PARA MODIFICAR
                        //var_dump('llega EDIT' );exit;

                        if($this->objParam->getParametro('id_proveedor_alkym') != ''){
                                $credenciales = '';

                                $id_proveedor_alkym = $this->objParam->getParametro('id_proveedor_alkym');

                                $codigo = $this->objParam->getParametro('codigo_alkym');
                                $nombre_dinamico = $this->objParam->getParametro('nombre_dinamico');

                                $fecha = new DateTime($this->objParam->getParametro('fecha_reg'));
                                $fecha_format =  date_format($fecha,'Y-m-d');

                                $direccion_dinamico = $this->objParam->getParametro('direccion_dinamico');
                                $nombre_ciudad = $this->objParam->getParametro('nombre_ciudad');
                                $nombre_departamento = $this->objParam->getParametro('nombre_departamento');
                                $nombre_pais = $this->objParam->getParametro('nombre_pais');
                                $correo_dinamico = $this->objParam->getParametro('correo_dinamico');
                                $num_proveedor = $this->objParam->getParametro('num_proveedor');
                                $telefono_dinamico = $this->objParam->getParametro('telefono_dinamico');
                                $fax_dinamico = $this->objParam->getParametro('fax_dinamico');
                                $correo_dinamico2 = $this->objParam->getParametro('correo_dinamico2');
                                $codigo_fabricante_dinamico = $this->objParam->getParametro('codigo_fabricante_dinamico');
                                $pagweb_dinamico =  $this->objParam->getParametro('pagweb_dinamico');
                                $observaciones = $this->objParam->getParametro('observaciones_dinamico');
                                $ci = $this->objParam->getParametro('doc_ci');

                                $dnrp = $this->objParam->getParametro('dnrp');
                                $nit = $this->objParam->getParametro('nit');
                                $ingreso_bruto = $this->objParam->getParametro('ingreso_bruto');
                                $cod_moneda= $this->objParam->getParametro('cod_moneda');
                                $codigo_externo = $this->objParam->getParametro('codigo_externo');
                                $tipo_habilitacion = $this->objParam->getParametro('tipo_habilitacion');
                                $motivo_habilitacion = $this->objParam->getParametro('motivo_habilitacion');



                                $dato = array (
                                    "Tipo"=>"UPD",
                                    "IdProveedor"=>$id_proveedor_alkym,
                                    "Codigo"=>$codigo,
                                    "Nombre"=>$nombre_dinamico,
                                    "FechaAlta"=>$fecha_format,
                                    "Direccion"=>$direccion_dinamico,
                                    "Ciudad"=>$nombre_ciudad,
                                    "Estado"=>$nombre_departamento,
                                    "Pais"=>$nombre_pais,
                                    "emailContacto"=>$correo_dinamico,
                                    "cp"=>$num_proveedor,
                                    "Telefono"=>$telefono_dinamico,
                                    "Fax"=>$fax_dinamico,
                                    "email"=>$correo_dinamico2,
                                    "CodigoFabricante"=>$codigo_fabricante_dinamico,
                                    "DireccInternet"=>$pagweb_dinamico,
                                    "Observacion"=>$observaciones,
                                    "NroDocumento"=>$ci,
                                    "DNRP"=>$dnrp,
                                    "CUIT"=>$nit,
                                    "IngrBrutos"=>$ingreso_bruto,
                                    "Moneda"=>$cod_moneda,
                                    "CodigoExterno"=>$codigo_externo,
                                    "TipoHabilitacion"=>$tipo_habilitacion,
                                    "MotivoHabilitacion"=>$motivo_habilitacion
                                );

                                $dato_json = json_encode($dato);
                                $dato_envio = array ("Credenciales"=>$credenciales, "dato"=>$dato_json);
                                $dato_envio_json = json_encode ($dato_envio);

                                  //27-12-2021(may) se modifico el servicio por Jhon Claros
                                  //$request =  'http://sms.obairlines.bo/ServSisComm/servSiscomm.svc/RegistrarProveedor';
                                  $request =  'http://sms.obairlines.bo/ServMantenimiento/servSiscomm.svc/RegistrarProveedor';
                                  $session = curl_init($request);
                                  curl_setopt($session, CURLOPT_CUSTOMREQUEST, "POST");
                                  curl_setopt($session, CURLOPT_POSTFIELDS, $dato_envio_json);
                                  curl_setopt($session, CURLOPT_RETURNTRANSFER, true);
                                  curl_setopt($session, CURLOPT_HTTPHEADER, array(
                                          'Content-Type: application/json',
                                          'Content-Length: ' . strlen($dato_envio_json))
                                  );

                                  $result = curl_exec($session);
                                  curl_close($session);

                                  $respuesta = json_decode($result);
                                  $respuesta_final = json_decode($respuesta->RegistrarProveedorResult);


                          //var_dump('llega ressp', $respuesta_final);exit;
                                  if (($respuesta_final->codigo == null) || ($respuesta_final->codigo == '')) {
                                      throw new Exception('No se puede conectar con el servicio Alkym. Porfavor consulte con el Área de Sistemas');
                                  }


                                if ($respuesta_final->codigo != 1) {

                                    throw new Exception($respuesta_final->mensaje.'favor verifique');

                                } else {

                                   /* $id_alkym_recu=$respuesta_final->objeto;
                                    $id_alkym_proveedor = $id_alkym_recu->IdProveedor_alkym;

                                    $this->objParam->addParametro('id_alkym_proveedor',$id_alkym_proveedor);
                                    */

                                    $this->objFunc=$this->create('MODProveedor');
                                    $this->res=$this->objFunc->modificarProveedor();

                                    $this->res->imprimirRespuesta($this->res->generarJson());
                                }

                        }else{

                            throw new Exception('No tiene registrado el párametro id_proveedor_alkym');

                        }






                    }


                }

        } else {
                $this->objFunc=$this->create('MODProveedor');
                if($this->objParam->insertar('id_proveedor')){
                    $this->res=$this->objFunc->insertarProveedor();
                } else{
                    $this->res=$this->objFunc->modificarProveedor();
                }
                $this->res->imprimirRespuesta($this->res->generarJson());
        }


	}
						
	function eliminarProveedor(){
		$this->objFunc=$this->create('MODProveedor');
		$this->res=$this->objFunc->eliminarProveedor();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function iniciarTramite(){
		$this->objParam->addParametro('id_funcionario_usu',$_SESSION["ss_id_funcionario"]); 
		$this->objFunc=$this->create('MODProveedor');	
		$this->res=$this->objFunc->iniciarTramite();
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstadoProveedor(){
        $this->objFunc=$this->create('MODProveedor');  
        $this->res=$this->objFunc->siguienteEstadoProveedor($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   function anteriorEstadoProveedor(){
        $this->objFunc=$this->create('MODProveedor');  
        $this->res=$this->objFunc->anteriorEstadoProveedor($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarProveedorCtaBan(){
        $this->objParam->defecto('ordenacion','id_proveedor');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('prov_estado')=='borrador'){
            $this->objParam->addFiltro("provee.estado in (''borrador'')");
        }
        if($this->objParam->getParametro('prov_estado')=='en_proceso'){
            $this->objParam->addFiltro("provee.estado not in (''borrador'',''aprobado'',''anulado'')");
        }
        if($this->objParam->getParametro('prov_estado')=='finalizados'){
            $this->objParam->addFiltro("provee.estado in (''aprobado'',''anulado'')");
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODProveedor','listarProveedorCtaBan');
        } else{
            $this->objFunc=$this->create('MODProveedor');
            $this->res=$this->objFunc->listarProveedorCtaBan();
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>