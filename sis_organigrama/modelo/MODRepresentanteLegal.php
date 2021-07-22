<?php
/**
 *@package pXP
 *@file gen-MODRepresentateLegal.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 12:11:06
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODRepresentanteLegal extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarRepresentanteLegal(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_representante_legal_sel';
        $this->transaccion='OR_REP_LEG_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_representante_legal','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('nro_resolucion','varchar');
        $this->captura('fecha_resolucion','date');
        $this->captura('fecha_ini','date');
        $this->captura('fecha_fin','date');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_representante','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarRepresentanteLegal(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_representante_legal_ime';
        $this->transaccion='OR_REP_LEG_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('nro_resolucion','nro_resolucion','varchar');
        $this->setParametro('fecha_resolucion','fecha_resolucion','date');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarRepresentanteLegal(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_representante_legal_ime';
        $this->transaccion='OR_REP_LEG_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_representante_legal','id_representante_legal','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('nro_resolucion','nro_resolucion','varchar');
        $this->setParametro('fecha_resolucion','fecha_resolucion','date');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarRepresentanteLegal(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_representante_legal_ime';
        $this->transaccion='OR_REP_LEG_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_representante_legal','id_representante_legal','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>