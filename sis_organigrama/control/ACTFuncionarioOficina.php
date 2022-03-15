<?php
/**
 *@package pXP
 *@file gen-ACTFuncionarioOficina.php
 *@author  (admin)
 *@date 29-03-2021 18:50:34
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTFuncionarioOficina extends ACTbase{

    function listarFuncionarioOficina(){
        $this->objParam->defecto('ordenacion','id_funcionario_oficina');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('id_funcionario') != '') {
            $this->objParam->addFiltro("funcofi.id_funcionario = ". $this->objParam->getParametro('id_funcionario'));
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODFuncionarioOficina','listarFuncionarioOficina');
        } else{
            $this->objFunc=$this->create('MODFuncionarioOficina');

            $this->res=$this->objFunc->listarFuncionarioOficina($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarFuncionarioOficina(){


        //DateTime::createFromFormat('d/m/Y', $this->objParam->getParametro('fecha_ini'));
        //DateTime::createFromFormat('d/m/Y', $this->objParam->getParametro('fecha_fin'));

        //$fecha_ini = date_add($fecha_fin, date_interval_create_from_date_string("1 day"));
        //$fecha_ini = implode('-',array_reverse(explode('/',$fecha_ini->format('d/m/Y'))));
        //$fecha_fin = implode('',array_reverse(explode('/',$this->objParam->getParametro('fecha_fin'))));
        $fecha_ini = implode('-',array_reverse(explode('/',$this->objParam->getParametro('fecha_ini'))));
        $fecha_fin = implode('-',array_reverse(explode('/',$this->objParam->getParametro('fecha_fin'))));
        $id_funcionario = $this->objParam->getParametro('id_funcionario');
        $id_oficina = $this->objParam->getParametro('id_oficina');
        $observaciones = $this->objParam->getParametro('observaciones');


        $this->objFunc=$this->create('MODFuncionarioOficina');
        if($this->objParam->insertar('id_funcionario_oficina')){
            //$this->res=$this->objFunc->insertarFuncionarioOficina($this->objParam);
            $cone = new conexion();
            $link = $cone->conectarpdo();

            $sql = "select tus.cuenta
                from segu.tusuario tus
                where tus.id_usuario = ".$_SESSION["ss_id_usuario"]."
                ";
            $consulta = $link->query($sql);
            $consulta->execute();
            $cuenta = $consulta->fetchAll(PDO::FETCH_ASSOC);
            $cuenta = $cuenta[0]['cuenta'];

            $host = 'http://sms.obairlines.bo/servplanificacion/servPlanificacion.svc/GuardarCambioBase';
            $data = array( "data" =>
                "{desde:". "'".$fecha_ini."'".
                ",hasta:". "'".$fecha_fin."'".
                ",empleadoID:". '0'.
                ",id_oficina:". $id_oficina.
                ",observaciones:". "'".$observaciones."'".
                ",usuario:". "'".$cuenta."'".
                ",id_funcinario:". $id_funcionario."}"
            );

            $json_data = json_encode($data);//var_dump('$json_data',$json_data);exit;
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

            $this->res = new Mensaje();
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
            $this->res->datos = json_decode($res->GuardarCambioBaseResult);
        } else{
            $this->res=$this->objFunc->modificarFuncionarioOficina($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarFuncionarioOficina(){
        $this->objFunc=$this->create('MODFuncionarioOficina');
        $this->res=$this->objFunc->eliminarFuncionarioOficina($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarFuncionarioOficinaREST() {
        $this->objFunc = $this->create('MODFuncionarioOficina');
        $this->res = $this->objFunc->insertarFuncionarioOficinaREST();
        $this->res->imprimirRespuesta(json_encode($this->res->getDatos()));
    }

}

?>