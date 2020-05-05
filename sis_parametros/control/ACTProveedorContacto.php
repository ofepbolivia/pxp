<?php
/**
 *@package pXP
 *@file gen-ACTProveedorContacto.php
 *@author  Maylee Perez Pastor
 *@date 30-03-2020 20:07:41
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTProveedorContacto extends ACTbase{

    function listarProveedorContactos(){
        $this->objParam->defecto('ordenacion','id_proveedor_contacto');

        if($this->objParam->getParametro('id_proveedor')!=''){
            $this->objParam->addFiltro("pcontac.id_proveedor = ".$this->objParam->getParametro('id_proveedor'));
        }

        if($this->objParam->getParametro('id_proveedor_contacto')!=''){
            $this->objParam->addFiltro("pcontac.id_proveedor_contacto = ".$this->objParam->getParametro('id_proveedor_contacto'));
        }

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProveedorContacto','listarProveedorContactos');
        } else{
            $this->objFunc=$this->create('MODProveedorContacto');

            $this->res=$this->objFunc->listarProveedorContactos($this->objParam);
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

    function insertarProveedorContactos(){

        //para la conexion con Alkym
        $variable_global = $this->conexionAlkym();
        $conexionAlkym = $variable_global->getDatos();
        $respuesta = $conexionAlkym[0]["variable_obtenida"];

        //variable global = 'si'
        if ($respuesta == 'si') {

                $tipo = $this->objParam->getParametro('tipo');

                //TIPO PROVEEDOR GENERAL
                if($tipo == 'general' || $tipo == ''){
                    $this->objFunc=$this->create('MODProveedorContacto');
                    if($this->objParam->insertar('id_proveedor_contacto')){
                        $this->res=$this->objFunc->insertarProveedorContactos($this->objParam);
                    } else{
                        $this->res=$this->objFunc->modificarProveedorContactos($this->objParam);
                    }
                    $this->res->imprimirRespuesta($this->res->generarJson());

                }else{

                    //TIPO PROVEEDOR BROKER, HACE CONEXION CON ALKYM

                    //PARA INSERTAR
                    if($this->objParam->insertar('id_proveedor_contacto')){
                        //var_dump('llega INS' );exit;

                        $credenciales = '';
                        $id_proveedor_alkym = $this->objParam->getParametro('id_proveedor_alkym');
                        $nombre_contacto = $this->objParam->getParametro('nombre_contacto');
                        $telefono = $this->objParam->getParametro('telefono');
                        $fax = $this->objParam->getParametro('fax');
                        $email = $this->objParam->getParametro('email');
                        $area = $this->objParam->getParametro('area');
                        $ci = $this->objParam->getParametro('ci');

                        $dato = array (
                            "Tipo"=>"INS",
                            "IdProveedor"=>$id_proveedor_alkym,
                            "IdContactoProveedor"=>"0",
                            "Contacto"=>$nombre_contacto,
                            "Telefono"=>$telefono,
                            "Fax"=>$fax,
                            "email"=>$email,
                            "Area"=>$area,
                            "NroDocumento"=>$ci);

                        $dato_json = json_encode($dato);
                        $dato_envio = array ("Credenciales"=>$credenciales, "dato"=>$dato_json);
                        $dato_envio_json = json_encode ($dato_envio);

                        //var_dump('llegadato', $dato_envio_json);exit;
                         $request =  'http://sms.obairlines.bo/ServSisComm/servSiscomm.svc/RegistrarContactoProveedor';
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
                         $respuesta_final = json_decode($respuesta->RegistrarContactoProveedorResult);


                     //var_dump('llegadato', $respuesta_final);exit;
                         if (($respuesta_final->codigo == null) || ($respuesta_final->codigo == '')) {
                             throw new Exception('No se puede conectar con el servicio Alkym. Porfavor consulte con el Área de Sistemas');
                         }


                        if ($respuesta_final->codigo != 1) {

                            throw new Exception($respuesta_final->mensaje.'favor verifique');

                        } else {

                            $id_alkym_contacto_recu=$respuesta_final->objeto;
                            $id_alkym_proveedor_contacto = $id_alkym_contacto_recu->IdContactoProveedor_alkym;

                            $this->objParam->addParametro('id_alkym_proveedor_contacto',$id_alkym_proveedor_contacto);
                            $this->objFunc=$this->create('MODProveedorContacto');
                            $this->res=$this->objFunc->insertarProveedorContactos();

                            $this->res->imprimirRespuesta($this->res->generarJson());

                        }

                    }else{
                        //PARA MODIFICAR
                        //var_dump('llega EDIT' );exit;

                        if($this->objParam->getParametro('id_proveedor_alkym') != ''){
                            $credenciales = '';
                            $id_proveedor_alkym = $this->objParam->getParametro('id_proveedor_alkym');
                            $id_proveedor_contacto = $this->objParam->getParametro('id_proveedor_contacto');
                            $nombre_contacto = $this->objParam->getParametro('nombre_contacto');
                            $telefono = $this->objParam->getParametro('telefono');
                            $fax = $this->objParam->getParametro('fax');
                            $email = $this->objParam->getParametro('email');
                            $area = $this->objParam->getParametro('area');
                            $ci = $this->objParam->getParametro('ci');

                            $dato = array (
                                "Tipo"=>"UPD",
                                "IdProveedor"=>$id_proveedor_alkym,
                                "IdContactoProveedor"=>$id_proveedor_contacto,
                                "Contacto"=>$nombre_contacto,
                                "Telefono"=>$telefono,
                                "Fax"=>$fax,
                                "email"=>$email,
                                "Area"=>$area,
                                "NroDocumento"=>$ci);
                            var_dump('llega EDIT',$dato );exit;
                            $dato_json = json_encode($dato);
                            $dato_envio = array ("Credenciales"=>$credenciales, "dato"=>$dato_json);
                            $dato_envio_json = json_encode ($dato_envio);
                            //var_dump('llegadato', $dato_envio_json);exit;
                             $request =  'http://sms.obairlines.bo/ServSisComm/servSiscomm.svc/RegistrarContactoProveedor';
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
                             $respuesta_final = json_decode($respuesta->RegistrarContactoProveedorResult);


                         //var_dump('llegadato', $respuesta_final);exit;
                             if (($respuesta_final->codigo == null) || ($respuesta_final->codigo == '')) {
                                 throw new Exception('No se puede conectar con el servicio Alkym. Porfavor consulte con el Área de Sistemas');
                             }


                            if ($respuesta_final->codigo != 1) {

                                throw new Exception($respuesta_final->mensaje.'favor verifique');

                            } else {

                              /*  $id_alkym_contacto_recu=$respuesta_final->objeto;
                                $id_alkym_proveedor_contacto = $id_alkym_contacto_recu->IdContactoProveedor_alkym;

                                $this->objParam->addParametro('id_alkym_proveedor_contacto',$id_alkym_proveedor_contacto);*/

                                $this->objFunc=$this->create('MODProveedorContacto');
                                $this->res=$this->objFunc->modificarProveedorContactos();

                                $this->res->imprimirRespuesta($this->res->generarJson());

                            }

                        }else{

                            throw new Exception('No tiene registrado el párametro id_proveedor_alkym');

                        }

                    }

                }

        } else {
            
            //variable global = 'no'
            $this->objFunc=$this->create('MODProveedorContacto');
            if($this->objParam->insertar('id_proveedor_contacto')){
                $this->res=$this->objFunc->insertarProveedorContactos($this->objParam);
            } else{
                $this->res=$this->objFunc->modificarProveedorContactos($this->objParam);
            }
            $this->res->imprimirRespuesta($this->res->generarJson());
        }
    }

    function eliminarProveedorContactos(){
        $this->objFunc=$this->create('MODProveedorContacto');
        $this->res=$this->objFunc->eliminarProveedorContactos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

   /* function listarProveedorCtaBancariaActivo(){
        $this->objParam->defecto('ordenacion','id_proveedor_cta_bancaria');

        if($this->objParam->getParametro('id_proveedor')!=''){
            $this->objParam->addFiltro("pctaban.id_proveedor = ".$this->objParam->getParametro('id_proveedor'));
        }
        if($this->objParam->getParametro('id_proveedor_cta_bancaria')!=''){
            $this->objParam->addFiltro("pctaban.id_proveedor_cta_bancaria = ".$this->objParam->getParametro('id_proveedor_cta_bancaria'));
        }

        if($this->objParam->getParametro('lbrTP') == 'conLbr') {
            if ($this->objParam->getParametro('id_depto_lb') != '') {
                $this->objParam->addFiltro("  pctaban.id_proveedor_cta_bancaria in (select cb.id_proveedor_cta_bancaria
                        											                from  tes.tcuenta_bancaria cb
                                                                                    left join tes.tdepto_cuenta_bancaria deptctab on deptctab.id_cuenta_bancaria = cb.id_cuenta_bancaria 
                                                                                    where deptctab.id_depto =  " . $this->objParam->getParametro('id_depto_lb') ."
                                                                                    and cb.id_proveedor_cta_bancaria = pctaban.id_proveedor_cta_bancaria)");

            }
        }


        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProveedorCtaBancaria','listarProveedorCtaBancariaActivo');
        } else{
            $this->objFunc=$this->create('MODProveedorCtaBancaria');

            $this->res=$this->objFunc->listarProveedorCtaBancariaActivo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }*/


}

?>