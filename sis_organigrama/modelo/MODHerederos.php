<?php
/**
 *@package pXP
 *@file gen-MODHerederos.php
 *@author  (franklin.espinoza)
 *@date 16-07-2021 14:16:29
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODHerederos extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarHerederos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_herederos_sel';
        $this->transaccion='OR_HERE_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_herederos','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('parentesco','varchar');
        $this->captura('edad','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_funcionario','integer');
        $this->captura('benefactor','varchar');
        $this->captura('tiempo','varchar');

        /****************************************************PERSONA****************************************************/
        $this->captura('id_persona','integer');
        $this->captura('desc_person','varchar');

        $this->captura('nombre','varchar');
        $this->captura('ap_materno','varchar');
        $this->captura('ap_paterno','varchar');
        $this->captura('fecha_nacimiento','date');
        $this->captura('genero','varchar');
        $this->captura('nacionalidad','varchar');
        $this->captura('id_lugar','integer');
        $this->captura('id_tipo_doc_identificacion','integer');
        $this->captura('ci','varchar');
        $this->captura('expedicion','varchar');
        $this->captura('estado_civil','varchar');
        $this->captura('discapacitado','varchar');
        $this->captura('telefono1','varchar');
        $this->captura('celular1','varchar');
        $this->captura('correo','varchar');
        $this->captura('telefono2','varchar');
        $this->captura('celular2','varchar');
        $this->captura('direccion','varchar');
        /****************************************************PERSONA****************************************************/

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarHerederos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_herederos_ime';
        $this->transaccion='OR_HERE_INS';
        $this->tipo_procedimiento='IME';

        //$this->setParametro('id_funcionario','id_funcionario','integer');

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('nombres','nombres','varchar');
        $this->setParametro('apellido_paterno','apellido_paterno','varchar');
        $this->setParametro('apellido_materno','apellido_materno','varchar');
        $this->setParametro('parentesco','parentesco','varchar');
        $this->setParametro('edad','edad','int4');
        $this->setParametro('nro_documento','nro_documento','varchar');
        $this->setParametro('id_funcionario','id_funcionario','integer');
        $this->setParametro('tiempo','tiempo','varchar');


        /****************************************************PERSONA****************************************************/
        $this->setParametro('id_persona','id_persona','integer');
        $this->setParametro('nombre','nombre','varchar');
        $this->setParametro('ap_paterno','ap_paterno','varchar');
        $this->setParametro('ap_materno','ap_materno','varchar');
        $this->setParametro('fecha_nacimiento','fecha_nacimiento','date');
        $this->setParametro('genero','genero','varchar');
        $this->setParametro('nacionalidad','nacionalidad','varchar');
        $this->setParametro('id_lugar','id_lugar','integer');
        $this->setParametro('id_tipo_doc_identificacion','id_tipo_doc_identificacion','integer');
        $this->setParametro('ci','ci','varchar');
        $this->setParametro('expedicion','expedicion','varchar');
        $this->setParametro('estado_civil','estado_civil','varchar');
        $this->setParametro('discapacitado','discapacitado','varchar');
        $this->setParametro('telefono1','telefono1','varchar');
        $this->setParametro('celular1','celular1','varchar');
        $this->setParametro('correo','correo','varchar');
        $this->setParametro('telefono2','telefono2','varchar');
        $this->setParametro('celular2','celular2','varchar');
        $this->setParametro('direccion','direccion','varchar');
        $this->setParametro('carnet_discapacitado','carnet_discapacitado','varchar');
        /****************************************************PERSONA****************************************************/

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarHerederos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_herederos_ime';
        $this->transaccion='OR_HERE_MOD';
        $this->tipo_procedimiento='IME';

        //$this->setParametro('id_funcionario','id_funcionario','integer');

        //Define los parametros para la funcion
        $this->setParametro('id_herederos','id_herederos','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('nombres','nombres','varchar');
        $this->setParametro('apellido_paterno','apellido_paterno','varchar');
        $this->setParametro('apellido_materno','apellido_materno','varchar');
        $this->setParametro('parentesco','parentesco','varchar');
        $this->setParametro('edad','edad','int4');
        $this->setParametro('nro_documento','nro_documento','varchar');
        $this->setParametro('id_funcionario','id_funcionario','integer');
        $this->setParametro('tiempo','tiempo','varchar');
        /****************************************************PERSONA****************************************************/
        $this->setParametro('id_persona','id_persona','integer');
        $this->setParametro('nombre','nombre','varchar');
        $this->setParametro('ap_paterno','ap_paterno','varchar');
        $this->setParametro('ap_materno','ap_materno','varchar');
        $this->setParametro('fecha_nacimiento','fecha_nacimiento','date');
        $this->setParametro('genero','genero','varchar');
        $this->setParametro('nacionalidad','nacionalidad','varchar');
        $this->setParametro('id_lugar','id_lugar','integer');
        $this->setParametro('id_tipo_doc_identificacion','id_tipo_doc_identificacion','integer');
        $this->setParametro('ci','ci','varchar');
        $this->setParametro('expedicion','expedicion','varchar');
        $this->setParametro('estado_civil','estado_civil','varchar');
        $this->setParametro('discapacitado','discapacitado','varchar');
        $this->setParametro('telefono1','telefono1','varchar');
        $this->setParametro('celular1','celular1','varchar');
        $this->setParametro('correo','correo','varchar');
        $this->setParametro('telefono2','telefono2','varchar');
        $this->setParametro('celular2','celular2','varchar');
        $this->setParametro('direccion','direccion','varchar');
        $this->setParametro('carnet_discapacitado','carnet_discapacitado','varchar');
        /****************************************************PERSONA****************************************************/

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarHerederos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_herederos_ime';
        $this->transaccion='OR_HERE_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_herederos','id_herederos','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>