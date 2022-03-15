<?php
/**
 *@package pXP
 *@file gen-ACTHerederos.php
 *@author  (franklin.espinoza)
 *@date 16-07-2021 14:16:29
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTHerederos extends ACTbase{

    function listarHerederos(){
        $this->objParam->defecto('ordenacion','id_herederos');

        $this->objParam->defecto('dir_ordenacion','asc');


        if ($this->objParam->getParametro('id_funcionario') != '') {

            $this->objParam->addFiltro("here.id_funcionario = ". $this->objParam->getParametro('id_funcionario'));

        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODHerederos','listarHerederos');
        } else{
            $this->objFunc=$this->create('MODHerederos');

            $this->res=$this->objFunc->listarHerederos($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarHerederos(){ //var_dump($this->objParam);exit;

        /*********************Servicio Insertar*******************/
        /*$action =  $this->objParam->getParametro('momento');

        $data = array(
            "from" => $from,
            "to" => $to,
            "type" => $type,
            "documentNumber" => "TODOS",
            "action" => $action ? $action : 0
        );

        $json_data = json_encode($data);
        $s = curl_init();
        curl_setopt($s, CURLOPT_URL, 'http://sms.obairlines.bo/CommissionServices/ServiceComision.svc/GetListDocumentsACM');
        curl_setopt($s, CURLOPT_POST, true);
        curl_setopt($s, CURLOPT_POSTFIELDS, $json_data);
        curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($s, CURLOPT_CONNECTTIMEOUT, 20);
        curl_setopt($s, CURLOPT_HTTPHEADER, array(
                'Content-Type: application/json',
                'Content-Length: ' . strlen($json_data))
        );
        $_out = curl_exec($s);//var_dump('$response', $_out);exit;
        $status = curl_getinfo($s, CURLINFO_HTTP_CODE);
        if (!$status) {
            throw new Exception("No se pudo conectar con el Servicio");
        }
        curl_close($s);

        $res = json_decode($_out);
        $res = json_decode($res->GetListDocumentsACMResult);*/
        /*********************Servicio Insertar*******************/
        $this->objFunc=$this->create('MODHerederos');
        if($this->objParam->insertar('id_herederos')){
            $this->res=$this->objFunc->insertarHerederos($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarHerederos($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarHerederos(){
        $this->objFunc=$this->create('MODHerederos');
        $this->res=$this->objFunc->eliminarHerederos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>