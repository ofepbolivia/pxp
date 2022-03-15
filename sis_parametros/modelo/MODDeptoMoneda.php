<?php
/**
 *@package pXP
 *@file gen-MODDeptoUsuario.php
 *@author  (mzm)
 *@date 24-11-2011 18:26:47
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODDeptoMoneda extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarDeptoMoneda(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='param.f_tdepto_moneda_sel';
        $this->transaccion='PM_DEPMONEDA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->setParametro('id_depto','id_depto','integer');

        $this->captura('id_depto_moneda','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_depto','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_moneda','int4');
        $this->captura('moneda','varchar');
        $this->captura('codigo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarDeptoMoneda(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='param.f_tdepto_moneda_ime';
        $this->transaccion='PM_DEPMONEDA_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_depto','id_depto','int4');
        $this->setParametro('id_moneda','id_moneda','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarDeptoMoneda(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='param.f_tdepto_moneda_ime';
        $this->transaccion='PM_DEPMONEDA_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_depto_moneda','id_depto_moneda','int4');
        $this->setParametro('id_depto','id_depto','int4');
        $this->setParametro('id_moneda','id_moneda','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarDeptoMoneda(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='param.f_tdepto_moneda_ime';
        $this->transaccion='PM_DEPMONEDA_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_depto_moneda','id_depto_moneda','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>