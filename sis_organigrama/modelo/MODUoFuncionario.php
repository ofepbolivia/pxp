<?php
/***
Nombre: 	MODUoFuncionario.php
Proposito: Clase de Modelo, que contiene la definicion y llamada a funciones especificas relacionadas a la tabla tuo_funcionario del esquema RHUM
Autor:		Kplian
Fecha:		04/06/2011
 */
class MODUoFuncionario extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);

    }

    function listarUoFuncionario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_sel';// nombre procedimiento almacenado
        $this->transaccion='RH_UOFUNC_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_uo','id_uo','integer');
        //Definicion de la lista del resultado del query
        $this->captura('id_uo_funcionario','integer');
        $this->captura('id_uo','integer');
        $this->captura('id_funcionario','integer');
        $this->captura('ci','varchar');
        $this->captura('codigo','varchar');
        $this->captura('desc_funcionario1','text');
        $this->captura('desc_funcionario2','text');
        $this->captura('num_doc','integer');
        $this->captura('fecha_asignacion','date');
        $this->captura('fecha_finalizacion','date');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_mod','timestamp');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_mod','integer');
        $this->captura('id_usuario_reg','integer');
        $this->captura('USUREG','text');
        $this->captura('USUMOD','text');
        $this->captura('id_cargo','integer');
        $this->captura('desc_cargo','text');
        $this->captura('observaciones_finalizacion','varchar');
        $this->captura('nro_documento_asignacion','varchar');
        $this->captura('fecha_documento_asignacion','date');
        $this->captura('tipo','varchar');
        $this->captura('codigo_ruta','varchar');
        $this->captura('estado_funcional','varchar');
        $this->captura('certificacion_presupuestaria','varchar');
        $this->captura('nombre_escala','varchar');
        $this->captura('haber_basico','numeric');
        $this->captura('nro_contrato','varchar');
        $this->captura('fecha_contrato','date');

        $this->captura('centro_costo','varchar');
        $this->captura('categoria','varchar');

        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();

        $this->ejecutarConsulta();

        return $this->respuesta;

    }

    function reportarUoFuncionario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_sel';// nombre procedimiento almacenado
        $this->transaccion='RH_CARGO_FUNC_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_uo','id_uo','integer');
        //Definicion de la lista del resultado del query
        $this->captura('ci','varchar');
        $this->captura('codigo','varchar');
        $this->captura('fecha_asignacion','date');
        $this->captura('desc_funcionario1','text');
        $this->captura('desc_funcionario2','text');
        $this->captura('num_doc','integer');
        $this->captura('item','varchar');
        $this->captura('cargo','varchar');
        $this->captura('observaciones_finalizacion','varchar');
        $this->captura('nro_documento_asignacion','varchar');
        //$this->captura('nombre_escala','varchar');
        //$this->captura('haber_basico','numeric');
        $this->captura('tipo','varchar');
        $this->captura('estado_funcional','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function insertarUoFuncionario(){

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_ime';// nombre procedimiento almacenado
        $this->transaccion='RH_UOFUNC_INS';//nombre de la transaccion
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //Define los parametros para la funcion
        $this->setParametro('id_uo','id_uo','integer');
        $this->setParametro('id_funcionario','id_funcionario','integer');
        $this->setParametro('fecha_asignacion','fecha_asignacion','date');
        $this->setParametro('fecha_finalizacion','fecha_finalizacion','date');
        $this->setParametro('id_cargo','id_cargo','integer');
        $this->setParametro('observaciones_finalizacion','observaciones_finalizacion','varchar');
        $this->setParametro('nro_documento_asignacion','nro_documento_asignacion','varchar');
        $this->setParametro('fecha_documento_asignacion','fecha_documento_asignacion','date');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('certificacion_presupuestaria','certificacion_presupuestaria','varchar');
        $this->setParametro('codigo_ruta','codigo_ruta','varchar');
        $this->setParametro('estado_funcional','estado_funcional','varchar');
        $this->setParametro('nro_contrato','nro_contrato','varchar');
        $this->setParametro('fecha_contrato','fecha_contrato','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function modificarUoFuncionario(){

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_ime';// nombre procedimiento almacenado
        $this->transaccion='RH_UOFUNC_MOD';//nombre de la transaccion
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //Define los parametros para la funcion
        $this->setParametro('id_uo_funcionario','id_uo_funcionario','integer');
        $this->setParametro('id_uo','id_uo','integer');
        $this->setParametro('id_funcionario','id_funcionario','integer');
        $this->setParametro('fecha_asignacion','fecha_asignacion','date');
        $this->setParametro('fecha_finalizacion','fecha_finalizacion','date');
        $this->setParametro('id_cargo','id_cargo','integer');
        $this->setParametro('observaciones_finalizacion','observaciones_finalizacion','varchar');
        $this->setParametro('nro_documento_asignacion','nro_documento_asignacion','varchar');
        $this->setParametro('fecha_documento_asignacion','fecha_documento_asignacion','date');
        $this->setParametro('certificacion_presupuestaria','certificacion_presupuestaria','varchar');
        $this->setParametro('codigo_ruta','codigo_ruta','varchar');
        $this->setParametro('estado_funcional','estado_funcional','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('nro_contrato','nro_contrato','varchar');
        $this->setParametro('fecha_contrato','fecha_contrato','date');




        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;
    }


    function eliminarUoFuncionario(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_uo_funcionario_ime';
        $this->transaccion='RH_UOFUNC_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_uo_funcionario','id_uo_funcionario','integer');
        //Ejecuta la instruccion
        $this->armarConsulta();

        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function listarAsignacionFuncionario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_sel';// nombre procedimiento almacenado
        $this->transaccion='RH_ASIG_FUNC_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_uo','id_uo','integer');
        //Definicion de la lista del resultado del query
        $this->captura('id_uo_funcionario','integer');
        $this->captura('id_uo','integer');
        $this->captura('id_funcionario','integer');
        $this->captura('ci','varchar');
        $this->captura('codigo','varchar');
        $this->captura('desc_funcionario1','text');
        $this->captura('desc_funcionario2','text');
        $this->captura('num_doc','integer');
        $this->captura('fecha_asignacion','date');
        $this->captura('fecha_finalizacion','date');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_mod','timestamp');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_mod','integer');
        $this->captura('id_usuario_reg','integer');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_cargo','integer');
        $this->captura('desc_cargo','text');
        $this->captura('observaciones_finalizacion','varchar');
        $this->captura('nro_documento_asignacion','varchar');
        $this->captura('fecha_documento_asignacion','date');
        $this->captura('tipo','varchar');
        $this->captura('haber_basico','numeric');
        $this->captura('tipo_contrato','varchar');

        $this->captura('centro_costo','varchar');
        $this->captura('categoria','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();

        $this->ejecutarConsulta();

        return $this->respuesta;

    }

    /****************************************Reporte Modelo Contrato RRHH(franklin.espinoza) 14/07/2021**************************************/
    function reporteModeloContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_sel';// nombre procedimiento almacenado
        $this->transaccion='RH_CONTRATO_RRHH_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_uo_funcionario','id_uo_funcionario','integer');

        //Definicion de la lista del resultado del query
        $this->captura('contrato','text');
        $this->captura('anexo','text');
        //Ejecuta la funcion
        $this->armarConsulta();//var_dump($this->consulta);exit;
        $this->ejecutarConsulta();
        return $this->respuesta;

    }
    /****************************************Reporte Modelo Contrato RRHH(franklin.espinoza) 14/07/2021**************************************/

    /*****************************Recuperar el correlativo de contrato RRHH(franklin.espinoza) 14/07/2021*****************************/
    function recuperarNumeroContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_uo_funcionario_ime';// nombre procedimiento almacenado
        $this->transaccion='RH_NUM_CONTRATO_GET';//nombre de la transaccion
        $this->tipo_procedimiento='IME';//tipo de transaccion

        $this->setParametro('id_uo_funcionario','id_uo_funcionario','integer');
        $this->setParametro('momento','momento','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('nro_contrato','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();
        //var_dump($this->consulta);exit;
        $this->ejecutarConsulta();
        return $this->respuesta;
    }
    /*****************************Recuperar el correlativo de contrato RRHH(franklin.espinoza) 14/07/2021*****************************/

}
?>