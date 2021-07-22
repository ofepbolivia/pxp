<?php
/**
 *@package pXP
 *@file gen-MODTipoDocumentoContrato.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 16:12:10
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODTipoDocumentoContrato extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarTipoDocumentoContrato(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_tipo_documento_contrato_sel';
        $this->transaccion='OR_TIP_DC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_tipo_documento_contrato','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('tipo','varchar');
        $this->captura('tipo_detalle','varchar');
        $this->captura('contenido','text');
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
        $this->captura('tipo_documento','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta(); //var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarTipoDocumentoContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_tipo_documento_contrato_ime';
        $this->transaccion='OR_TIP_DC_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('tipo_detalle','tipo_detalle','varchar');
        $this->setParametro('contenido','contenido','codigo_html');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarTipoDocumentoContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_tipo_documento_contrato_ime';
        $this->transaccion='OR_TIP_DC_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_tipo_documento_contrato','id_tipo_documento_contrato','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('tipo_detalle','tipo_detalle','varchar');
        $this->setParametro('contenido','contenido','codigo_html');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarTipoDocumentoContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_tipo_documento_contrato_ime';
        $this->transaccion='OR_TIP_DC_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_tipo_documento_contrato','id_tipo_documento_contrato','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>