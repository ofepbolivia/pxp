<?php
/**
 *@package  BoA
 *@file     MODBaseOperativa.php
 *@author  (admin)
 *@date 14-01-2014 19:16:06
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */
include_once(dirname(__FILE__).'/../../lib/lib_modelo/ConexionSqlServer.php');
class MODBaseOperativa extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarBaseOperativa(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_cargo_sel';
        $this->transaccion='OR_CARGO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_funcionario','id_funcionario','integer');


        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario_oficina','int4');
        $this->captura('fecha_ini','int4');
        $this->captura('fecha_fin','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('id_oficina','int4');
        $this->captura('observaciones','text');
        $this->captura('estado_reg','varchar');
        $this->captura('id_usuario_reg','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();//var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }




    function insertarBaseOperativa(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='ORGA_BASE_OPE_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_oficina','id_oficina','int4');
        $this->setParametro('observaciones','observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarBaseOperativa(){

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='ORGA_BASE_OPE_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_funcionario_oficina','id_funcionario_oficina','date');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_oficina','id_oficina','int4');
        $this->setParametro('observaciones','observaciones','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarBaseOperativa(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='ORGA_BASE_OPE_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_funcionario_oficina','id_funcionario_oficina','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>