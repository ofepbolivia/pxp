<?php
/**
 *@package pXP
 *@file gen-MODOficinaCuenta.php
 *@author  (jrivera)
 *@date 31-07-2014 22:57:29
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODReporte extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function reporteCorreosEmpleadosBoa(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_reporte_sel';
        $this->transaccion='OR_R_MAIL_BOA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('oficina','oficina','varchar');
        //Definicion de la lista del resultado del query
        $this->captura('gerencia','varchar');
        $this->captura('contrato','varchar');
        $this->captura('desc_funcionario','varchar');
        $this->captura('cargo','varchar');
        $this->captura('lugar','varchar');
        $this->captura('codigo','varchar');
        $this->captura('email_empresa','varchar');
        $this->captura('estado_fun','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reporteCumpleEmpleadosBoa(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_reporte_sel';
        $this->transaccion='OR_R_CUMPLE_BOA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('id_gestion','id_gestion','integer');
        $this->setParametro('id_periodo','id_periodo','integer');
        $this->setParametro('orden','orden','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('nombre_unidad','varchar');
        $this->captura('desc_func','varchar');
        $this->captura('f_dia','varchar');
        $this->captura('fecha_nacimiento','date');
        $this->captura('nom_cargo','varchar');
        $this->captura('nom_oficina','varchar');
        $this->captura('fecha_contrato','date');
        $this->captura('email_empresa','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reporteListaDocumentos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_reporte_sel';
        $this->transaccion='ORGA_REP_DOC_RH_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('configuracion_reporte','configuracion_reporte','varchar');
        $this->setParametro('tipo_archivo','tipo_archivo','varchar');

        $this->setCount(false);
        //Definicion de la lista del resultado del query
        $this->captura('gerencia','varchar');
        $this->captura('desc_funcionario','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('ci','varchar');
        $this->captura('cargo','varchar');
        $this->captura('fecha_ingreso','date');
        $this->captura('documento','json');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function headerDocumentos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_reporte_sel';
        $this->transaccion='ORGA_HEADER_DOC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //$this->setParametro('configuracion_reporte','configuracion_reporte','varchar');
        $this->setParametro('tipo_archivo','tipo_archivo','varchar');

        $this->setCount(false);
        //Definicion de la lista del resultado del query
        $this->captura('headers','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function reporteInformacionRapida(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_reporte_sel';
        $this->transaccion='ORGA_INF_RAPIDA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('configuracion_reporte','configuracion_reporte','varchar');

        $this->setCount(false);
        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','integer');
        $this->captura('funcionario','varchar');
        $this->captura('ci','varchar');
        $this->captura('fecha_nacimiento','date');
        $this->captura('cargo','varchar');
        $this->captura('fecha_ingreso','date');
        $this->captura('telefonos','varchar');
        $this->captura('profesion','json');
        $this->captura('contrato','json');
        $this->captura('afp','varchar');
        $this->captura('institucion','varchar');
        $this->captura('apellido_paterno','varchar');
        $this->captura('apellido_materno','varchar');
        $this->captura('nombre','varchar');
        $this->captura('telefono_oficina','varchar');
        $this->captura('correo_institucional','varchar');
        $this->captura('correo_personal','varchar');

        $this->captura('gerencia','varchar');
        $this->captura('nombre_oficina','varchar');
        $this->captura('nombre_lugar','varchar');
        $this->captura('genero','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        //echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>