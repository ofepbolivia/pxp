<?php
/**
 *@package pXP
 *@file gen-MODProveedorContacto.php
 *@author  Maylee Perez Pastor
 *@date 30-03-2020 20:07:41
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODProveedorContacto extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarProveedorContactos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='param.ft_proveedor_contacto_sel';
        $this->transaccion='PM_PROVCONTAC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_proveedor_contacto','int4');
        $this->captura('id_proveedor','int4');
        $this->captura('nombre_contacto','varchar');
        $this->captura('telefono','varchar');
        $this->captura('fax','varchar');
        $this->captura('area','varchar');
        $this->captura('email','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('ci','varchar');
        $this->captura('id_proveedor_alkym','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarProveedorContactos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='param.ft_proveedor_contacto_ime';
        $this->transaccion='PM_PROVCONTAC_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proveedor','id_proveedor','int4');
        $this->setParametro('nombre_contacto','nombre_contacto','varchar');
        $this->setParametro('telefono','telefono','varchar');
        $this->setParametro('fax','fax','varchar');
        $this->setParametro('area','area','varchar');
        $this->setParametro('email','email','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');

        $this->setParametro('ci','ci','varchar');

        $this->setParametro('id_proveedor_alkym','id_proveedor_alkym','int4');
        $this->setParametro('id_alkym_proveedor_contacto','id_alkym_proveedor_contacto','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarProveedorContactos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='param.ft_proveedor_contacto_ime';
        $this->transaccion='PM_PROVCONTAC_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proveedor_contacto','id_proveedor_contacto','int4');
        $this->setParametro('id_proveedor','id_proveedor','int4');
        $this->setParametro('nombre_contacto','nombre_contacto','varchar');
        $this->setParametro('telefono','telefono','varchar');
        $this->setParametro('fax','fax','varchar');
        $this->setParametro('area','area','varchar');
        $this->setParametro('email','email','varchar');

        $this->setParametro('ci','ci','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarProveedorContactos(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='param.ft_proveedor_contacto_ime';
        $this->transaccion='PM_PROVCONTAC_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proveedor_contacto','id_proveedor_contacto','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

   /* function listarProveedorCtaBancariaActivo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='param.ft_proveedor_cta_bancaria_sel';
        $this->transaccion='PM_PCTABANACT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_proveedor_cta_bancaria','int4');
        $this->captura('id_banco_beneficiario','int4');
        $this->captura('banco_beneficiario','varchar');
        $this->captura('fw_aba_cta','varchar');
        $this->captura('swift_big','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('banco_intermediario','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('id_proveedor','int4');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('estado_cta','varchar');
        $this->captura('prioridad','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }*/


}
?>