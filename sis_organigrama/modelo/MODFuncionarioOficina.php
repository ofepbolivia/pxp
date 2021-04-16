<?php
/**
 *@package pXP
 *@file gen-MODFuncionarioOficina.php
 *@author  (admin)
 *@date 29-03-2021 18:50:34
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODFuncionarioOficina extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarFuncionarioOficina(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_funcionario_oficina_sel';
        $this->transaccion='OR_FUNCOFI_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario_oficina','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('id_oficina','int4');
        $this->captura('fecha_ini','date');
        $this->captura('fecha_fin','date');
        $this->captura('observaciones','text');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarFuncionarioOficina(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_funcionario_oficina_ime';
        $this->transaccion='OR_FUNCOFI_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_oficina','id_oficina','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('observaciones','observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarFuncionarioOficina(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_funcionario_oficina_ime';
        $this->transaccion='OR_FUNCOFI_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_funcionario_oficina','id_funcionario_oficina','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_oficina','id_oficina','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('observaciones','observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarFuncionarioOficina(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_funcionario_oficina_ime';
        $this->transaccion='OR_FUNCOFI_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_funcionario_oficina','id_funcionario_oficina','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarFuncionarioOficinaREST(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_funcionario_oficina_ime';
        $this->transaccion='OR_FUNC_OFI_REST';
        $this->tipo_procedimiento='IME';
        $this->setParametro('dataJson','dataJson','jsonb');
        //Ejecuta la instruccion
        $this->armarConsulta();//var_dump($this->consulta);exit;
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>