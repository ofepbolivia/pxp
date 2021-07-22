<?php
/**
 *@package pXP
 *@file gen-MODUoContratoAnexo.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 13:16:48
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODUoContratoAnexo extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarUoContratoAnexo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_uo_contrato_anexo_sel';
        $this->transaccion='OR_UO_CA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_uo_contrato_anexo','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_uo','int4');
        $this->captura('id_tipo_documento_contrato','int4');
        $this->captura('id_tipo_contrato','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('anexo','varchar');
        $this->captura('contrato','varchar');
        $this->captura('nombre_unidad','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarUoContratoAnexo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_contrato_anexo_ime';
        $this->transaccion='OR_UO_CA_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_tipo_documento_contrato','id_tipo_documento_contrato','int4');
        $this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarUoContratoAnexo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_contrato_anexo_ime';
        $this->transaccion='OR_UO_CA_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_uo_contrato_anexo','id_uo_contrato_anexo','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_tipo_documento_contrato','id_tipo_documento_contrato','int4');
        $this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarUoContratoAnexo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_contrato_anexo_ime';
        $this->transaccion='OR_UO_CA_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_uo_contrato_anexo','id_uo_contrato_anexo','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>