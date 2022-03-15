<?php
/***
Nombre: ACTUoFuncionario.php
Proposito: Clase de Control para recibir los parametros enviados por los archivos
de la Vista para envio y ejecucion de los metodos del Modelo referidas a la tabla tuo_funcionario
Autor:	Kplian
Fecha:	01/07/2010
 */

require_once(dirname(__FILE__).'/../reportes/RModeloContratoRRHHPDF.php');

class ACTUoFuncionario extends ACTbase{

    function listarUoFuncionario(){

        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','FUNCIO.desc_funcionario1');
        $this->objParam->defecto('dir_ordenacion','asc');

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte=new Reporte($this->objParam, $this);
            $this->res=$this->objReporte->generarReporteListado('MODUoFuncionario','listarUoFuncionario');
        }
        else {
            //obtiene el parametro nodo enviado por la vista
            $id_uo=$this->objParam->getParametro('id_uo');
            $this->objParam->addParametro('id_uo',$id_uo);
            //$this->objParam->addParametro('id_subsistema',$id_subsistema);
            $this->objFunSeguridad=$this->create('MODUoFuncionario');
            //ejecuta el metodo de lista funcionarios a travez de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->listarUoFuncionario($this->objParam);

        }
        //imprime respuesta en formato JSON para enviar lo a la interface (vista)
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function guardarUoFuncionario(){
        //var_dump($this->objParam->getParametro('id_funcionario'), $_SESSION["_LOGIN"], $this->objParam);exit;
        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        $id_funcionario = $this->objParam->getParametro('id_funcionario');
        $fecha_ini = implode('-',array_reverse(explode('/',$this->objParam->getParametro('fecha_asignacion'))));
        $fecha_fin = $this->objParam->getParametro('fecha_finalizacion');
        if( $fecha_fin != '' ){
            $fecha_fin = implode('-',array_reverse(explode('/', $fecha_fin)));
        }else{
            $fecha_fin = '9999-12-31';
        }
        $observaciones = 'Por Nueva Asignacion (Nuevo Contrato, Renovacion Contrato, Reestructura)';

        $this->objFunSeguridad=$this->create('MODUoFuncionario');

        //preguntamos si se debe insertar o modificar
        if($this->objParam->insertar('id_uo_funcionario')){
            //$json = "http://172.17.45.127/GeneradorUsuario/Home/Generar?idEmpleadoENDE=".$this->objParam->getParametro('id_funcionario');
            //$jsonfile = file_get_contents($json);
            //ejecuta el metodo de insertar de la clase MODFuncionario a travez
            //de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->insertarUoFuncionario($this->objParam);
            /******************************************************* Base Operativa ********************************************************/
            $datos = $this->res->getDatos();
            if (true) {
                $cone = new conexion();
                $link = $cone->conectarpdo();

                $sql = "select tus.cuenta
                    from segu.tusuario tus
                    where tus.id_usuario = " . $_SESSION["ss_id_usuario"] . "
                    ";
                $consulta = $link->query($sql);
                $consulta->execute();
                $cuenta = $consulta->fetchAll(PDO::FETCH_ASSOC);
                $cuenta = $cuenta[0]['cuenta'];

                $host = 'http://sms.obairlines.bo/servplanificacion/servPlanificacion.svc/GuardarCambioBase';
                $data = array("data" =>
                    "{desde:" . "'" . $fecha_ini . "'" .
                    ",hasta:" . "'" . $fecha_fin . "'" .
                    ",empleadoID:" . '0' .
                    ",id_oficina:" . $datos['id_oficina'] .
                    ",observaciones:" . "'" . $observaciones . "'" .
                    ",usuario:" . "'" . $cuenta . "'" .
                    ",id_funcinario:" . $id_funcionario . "}"
                );

                $json_data = json_encode($data);//var_dump($json_data);exit;
                $s = curl_init();
                curl_setopt($s, CURLOPT_URL, $host);
                curl_setopt($s, CURLOPT_POST, true);
                curl_setopt($s, CURLOPT_POSTFIELDS, $json_data);
                curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($s, CURLOPT_CONNECTTIMEOUT, 20);
                curl_setopt($s, CURLOPT_HTTPHEADER, array(
                        'Content-Type: application/json',
                        'Content-Length: ' . strlen($json_data))
                );
                $_out = curl_exec($s);
                $status = curl_getinfo($s, CURLINFO_HTTP_CODE);
                //var_dump(curl_getinfo($s));
                if (!$status) {
                    throw new Exception("No se pudo conectar con PERSONAL");
                }
                curl_close($s);
                $res = json_decode($_out);
                $res = json_decode($res->GuardarCambioBaseResult);
                $this->res->datos['response'] = $res;
                //var_dump($res);
                //var_dump($this->res);
            }
            /******************************************************* Base Operativa ********************************************************/
        } else{ //var_dump('modificarUoFuncionario');exit;
            /******************************************************* Base Operativa ********************************************************/
            if (false) {
                $id_funcionario = $this->objParam->getParametro('id_funcionario');
                $data = array(
                    "id_funcionario" => $id_funcionario,
                    "usuario" => $_SESSION["_LOGIN"] ? $_SESSION["_LOGIN"] : 'erp'
                );

                $json_data = json_encode($data);
                $s = curl_init();
                curl_setopt($s, CURLOPT_URL, 'http://sms.obairlines.bo/servplanificacion/servPlanificacion.svc/ValidarcambiosHistorialCargoItem');//skbproduccion, skbpruebas
                curl_setopt($s, CURLOPT_POST, true);
                curl_setopt($s, CURLOPT_POSTFIELDS, $json_data);
                curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($s, CURLOPT_CONNECTTIMEOUT, 20);
                curl_setopt($s, CURLOPT_HTTPHEADER, array(
                        'Content-Type: application/json',
                        'Content-Length: ' . strlen($json_data))
                );
                $_out = curl_exec($s);
                $status = curl_getinfo($s, CURLINFO_HTTP_CODE);
                if (!$status) {
                    throw new Exception("No se pudo conectar con el Servicio");
                }
                curl_close($s);
                $res = json_decode($_out);

                //var_dump('$response', $res);
            }
            /******************************************************* Base Operativa ********************************************************/
            //ejecuta el metodo de modificar funcionario de la clase MODFuncionario a travez
            //de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->modificarUoFuncionario($this->objParam);

            /*$temp = Array();
            $temp['clave'] = 'valor';
            $this->res->addLastRecDatos($temp);*/
            //$this->res->datos['clave'] = 'valor';
            $datos = $this->res->getDatos();

            /******************************************************* Base Operativa ********************************************************/
            if (false) {
                $cone = new conexion();
                $link = $cone->conectarpdo();

                $sql = "select tus.cuenta
                    from segu.tusuario tus
                    where tus.id_usuario = " . $_SESSION["ss_id_usuario"] . "
                    ";
                $consulta = $link->query($sql);
                $consulta->execute();
                $cuenta = $consulta->fetchAll(PDO::FETCH_ASSOC);
                $cuenta = $cuenta[0]['cuenta'];

                $host = 'http://sms.obairlines.bo/servplanificacion/servPlanificacion.svc/GuardarCambioBase';
                $data = array("data" =>
                    "{desde:" . "'" . $fecha_ini . "'" .
                        ",hasta:" . "'" . $fecha_fin . "'" .
                        ",empleadoID:" . '0' .
                        ",id_oficina:" . $datos['id_oficina'] .
                        ",observaciones:" . "'" . $observaciones . "'" .
                        ",usuario:" . "'" . $cuenta . "'" .
                        ",id_funcinario:" . $id_funcionario . "}"
                );

                $json_data = json_encode($data);var_dump($json_data);
                $s = curl_init();
                curl_setopt($s, CURLOPT_URL, $host);
                curl_setopt($s, CURLOPT_POST, true);
                curl_setopt($s, CURLOPT_POSTFIELDS, $json_data);
                curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($s, CURLOPT_CONNECTTIMEOUT, 20);
                curl_setopt($s, CURLOPT_HTTPHEADER, array(
                        'Content-Type: application/json',
                        'Content-Length: ' . strlen($json_data))
                );
                $_out = curl_exec($s);
                $status = curl_getinfo($s, CURLINFO_HTTP_CODE);
                //var_dump(curl_getinfo($s));
                if (!$status) {
                    throw new Exception("No se pudo conectar con PERSONAL");
                }
                curl_close($s);
                $res = json_decode($_out);

                /*$this->res = new Mensaje();
                $this->res->setMensaje(
                    'EXITO',
                    'driver.php',
                    'Insercción Exitosa de Base Operativa.',
                    'Service Insert Operating Base',
                    'control',
                    'orga.ft_funcionario_oficina_ime',
                    'OR_FUNCOFI_MOD',
                    'IME'
                );
                $this->res->datos = json_decode($res->GuardarCambioBaseResult);*/
                $res = json_decode($res->GuardarCambioBaseResult);

                $this->res->datos['response'] = $res;

                //var_dump($res);
                //var_dump($this->res);
            }
            /******************************************************* Base Operativa ********************************************************/
        }

        //imprime respuesta en formato JSON
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    function eliminarUoFuncionario(){

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        $this->objFunSeguridad=$this->create('MODUoFuncionario');
        $this->res=$this->objFunSeguridad->eliminarUoFuncionario($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    function listarAsignacionFuncionario(){

        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','FUNCIO.desc_funcionario1');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('tipo') != ''){
            $this->objParam->addFiltro("UOFUNC.tipo = ''".$this->objParam->getParametro('tipo')."''");
        }

        if ($this->objParam->getParametro('id_funcionario') != ''){
            $this->objParam->addFiltro("UOFUNC.id_funcionario = ".$this->objParam->getParametro('id_funcionario'));
        }



        //$this->objParam->addParametro('id_subsistema',$id_subsistema);
        $this->objFunSeguridad=$this->create('MODUoFuncionario');
        //ejecuta el metodo de lista funcionarios a travez de la intefaz objetoFunSeguridad
        $this->res=$this->objFunSeguridad->listarAsignacionFuncionario($this->objParam);

        //imprime respuesta en formato JSON para enviar lo a la interface (vista)
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /****************************************Reporte Modelo Contrato RRHH(franklin.espinoza) 14/07/2021**************************************/
    function reporteModeloContrato (){
        $this->objFunc=$this->create('MODUoFuncionario');
        $dataSource=$this->objFunc->reporteModeloContrato();
        $this->dataSource=$dataSource->getDatos();

        if ( empty($this->dataSource) ) {
            $funcionario = $this->objParam->getParametro('funcionario');
            $this->mensajeExito = new Mensaje();
            $this->mensajeExito->setMensaje('ERROR', 'Reporte.php', '<br> <p style="text-align:justify ; font-weight: bold;">El Funcionario <span style="color: red;">'.$funcionario.'</span> no tiene parametrizado herederos, o la fecha de contrato no ha sido definida, favor de validar la información.</p>', 'Error al generar el reporte: ', 'control');
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
        }else {
            $nombreArchivo = uniqid(md5(session_id()) . '[Contrato - RRHH]') . '.pdf';
            $this->objParam->addParametro('orientacion', 'P');
            $this->objParam->addParametro('tamano', 'LEGAL');
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);

            $this->objReporte = new RModeloContratoRRHHPDF($this->objParam);
            $this->objReporte->setDatos($this->dataSource);
            $this->objReporte->generarReporte();
            $this->objReporte->output($this->objReporte->url_archivo, 'F');


            $this->mensajeExito = new Mensaje();
            $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado', 'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
        }
    }
    /****************************************Reporte Modelo Contrato RRHH(franklin.espinoza) 14/07/2021**************************************/

    /*****************************Recuperar el correlativo de contrato RRHH(franklin.espinoza) 14/07/2021*****************************/
    function recuperarNumeroContrato(){

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        $this->objFunSeguridad=$this->create('MODUoFuncionario');
        $this->res=$this->objFunSeguridad->recuperarNumeroContrato($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
    /*****************************Recuperar el correlativo de contrato RRHH(franklin.espinoza) 14/07/2021*****************************/
}

?>