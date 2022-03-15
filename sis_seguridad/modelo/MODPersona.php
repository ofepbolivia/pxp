<?php
/***
Nombre: 	MODPersona.php
Proposito: Clase de Modelo, que contiene la definicion y llamada a funciones especificas relacionadas
a la tabla tpersona del esquema SEGU
Autor:		Kplian
Fecha:		04/06/2011
 */
class MODPersona extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);

    }

    function listarPersona(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_sel';// nombre procedimiento almacenado
        $this->transaccion='SEG_PERSON_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //defino varialbes que se captran como retornod e la funcion
        $this->captura('id_persona','integer');
        $this->captura('ap_materno','varchar');
        $this->captura('ap_paterno','varchar');
        $this->captura('nombre','varchar');
        $this->captura('nombre_completo1','text');
        $this->captura('nombre_completo2','text');
        $this->captura('ci','varchar');
        $this->captura('correo','varchar');
        $this->captura('celular1','varchar');
        $this->captura('num_documento','integer');
        $this->captura('telefono1','varchar');
        $this->captura('telefono2','varchar');
        $this->captura('celular2','varchar');
        $this->captura('fecha_nacimiento','date');
        $this->captura('genero','varchar');
        $this->captura('direccion','varchar');
        $this->captura('tipo_documento','varchar');
        $this->captura('expedicion','varchar');
        $this->captura('id_tipo_doc_identificacion','integer');
        $this->captura('nacionalidad','varchar');
        $this->captura('id_lugar','integer');
        $this->captura('discapacitado','varchar');
        $this->captura('nombre_lugar','varchar');



        //Ejecuta la funcion
        $this->armarConsulta();
        //var_dump($this->consulta());exit;
        $this->ejecutarConsulta();


        return $this->respuesta;

    }

    function listarPersonaFoto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_sel';// nombre procedimiento almacenado
        $this->transaccion='SEG_PERSONMIN_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion


        //Definicion de la lista del resultado del query

        //creamos variables de sesion para descargar la fotos
        $_SESSION["FOTO"]=array();

        //defino varialbes que se captran como retornod e la funcion
        $this->captura('id_persona','integer');
        $this->captura('ap_materno','varchar');
        $this->captura('ap_paterno','varchar');
        $this->captura('nombre','varchar');
        $this->captura('nombre_completo1','text');
        $this->captura('nombre_completo2','text');
        $this->captura('ci','varchar');
        $this->captura('correo','varchar');
        $this->captura('celular1','varchar');
        $this->captura('num_documento','integer');
        $this->captura('telefono1','varchar');
        $this->captura('telefono2','varchar');
        $this->captura('celular2','varchar');
        $this->captura('extension','varchar');
        $this->captura('tipo_documento','varchar');
        $this->captura('expedicion','varchar');


        //nombre varialbe de envio, tipo dato, columna que serra el nombre foto retorno, ruta para guardar archivo, crear miniatura, almacenar en sesion, nombre variale sesion

        $this->captura('foto','bytea','id_persona','extension','sesion','foto');
        //$this->captura('foto','bytea','id_persona','extension','archivo','../../sis_seguridad/control/foto_persona/');
        //$this->captura('foto','bytea','id_persona','extension','archivo','./');

        $this->captura('direccion','varchar');
        $this->captura('carnet_discapacitado','varchar');
        $this->captura('nacionalidad','varchar');
        $this->captura('genero','varchar');
        $this->captura('estado_civil','varchar');
        $this->captura('discapacitado','varchar');
        $this->captura('fecha_nacimiento','date');
        $this->captura('id_lugar','integer');
        $this->captura('lugar','varchar');
        $this->captura('id_tipo_doc_identificacion','integer');

        //Ejecuta la funcion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;

    }

    function obtenerPersonaFoto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_sel';// nombre procedimiento almacenado
        $this->transaccion='SEG_OPERFOT_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);


        $this->setParametro('id_usuario','id_usuario','integer');
        //defino varialbes que se captran como retornod e la funcion
        $this->captura('id_persona','integer');
        $this->captura('nombre_archivo','varchar');//15/11/2019
        $this->captura('extension','varchar');
        //nombre varialbe de envio, tipo dato, columna que serra el nombre foto retorno, ruta para guardar archivo, crear miniatura, almacenar en sesion, nombre variale sesion
        // $this->captura('foto','bytea','id_persona','extension','sesion','foto');
       //15/11/2019 $this->captura('foto','bytea','id_persona','extension','archivo','../../sis_seguridad/control/foto_persona/');
        //$this->captura('foto','bytea','id_persona','extension','archivo','./');


        //Ejecuta la funcion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        return $this->respuesta;

    }


    function insertarPersona(){

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_ime';// nombre procedimiento almacenado
        $this->transaccion='SEG_PERSON_INS';//nombre de la transaccion
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //Define los parametros para la funcion
        $this->setParametro('nombre','nombre','varchar');
        $this->setParametro('ap_materno','ap_materno','varchar');
        $this->setParametro('ap_paterno','ap_paterno','varchar');
        $this->setParametro('ci','ci','varchar');
        $this->setParametro('correo','correo','varchar');
        $this->setParametro('celular1','celular1','varchar');
        $this->setParametro('telefono1','telefono1','varchar');
        $this->setParametro('telefono2','telefono2','varchar');
        $this->setParametro('celular2','celular2','varchar');
        $this->setParametro('id_tipo_doc_identificacion','id_tipo_doc_identificacion','integer');
        $this->setParametro('expedicion','expedicion','varchar');
        $this->setParametro('fecha_nacimiento','fecha_nacimiento','date');
        $this->setParametro('genero','genero','varchar');
        $this->setParametro('direccion','direccion','varchar');
        $this->setParametro('id_lugar','id_lugar','int4');
        //$this->setParametro('lugar','lugar','varchar');
        $this->setParametro('estado_civil','estado_civil','varchar');
        $this->setParametro('nacionalidad','nacionalidad','varchar');
        $this->setParametro('discapacitado','discapacitado','varchar');
        $this->setParametro('carnet_discapacitado','carnet_discapacitado','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();

        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function modificarPersona(){

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_ime';// nombre procedimiento almacenado
        $this->transaccion='SEG_PERSON_MOD';//nombre de la transaccion
        $this->tipo_procedimiento='IME';//tipo de transaccion


        //apartir del tipo  del archivo obtiene la extencion



        //Define los parametros para la funcion
        $this->setParametro('id_persona','id_persona','int4');
        $this->setParametro('ap_materno','ap_materno','varchar');
        $this->setParametro('ap_paterno','ap_paterno','varchar');
        $this->setParametro('nombre','nombre','varchar');
        $this->setParametro('ci','ci','varchar');
        $this->setParametro('correo','correo','varchar');
        $this->setParametro('celular1','celular1','varchar');
        $this->setParametro('telefono1','telefono1','varchar');
        $this->setParametro('telefono2','telefono2','varchar');
        $this->setParametro('celular2','celular2','varchar');

        $this->setParametro('id_tipo_doc_identificacion','id_tipo_doc_identificacion','integer');
        $this->setParametro('expedicion','expedicion','varchar');

        $this->setParametro('fecha_nacimiento','fecha_nacimiento','date');
        $this->setParametro('genero','genero','varchar');
        $this->setParametro('direccion','direccion','varchar');
        $this->setParametro('id_lugar','id_lugar','int4');
        //$this->setParametro('lugar','lugar','varchar');
        $this->setParametro('estado_civil','estado_civil','varchar');
        $this->setParametro('nacionalidad','nacionalidad','varchar');
        $this->setParametro('discapacitado','discapacitado','varchar');
        $this->setParametro('carnet_discapacitado','carnet_discapacitado','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();

        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function eliminarPersona(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='segu.ft_persona_ime';
        $this->transaccion='SEG_PERSON_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_persona','id_persona','integer');
        //Ejecuta la instruccion
        $this->armarConsulta();

        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function subirFotoPersona(){

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_ime';// nombre procedimiento almacenado
        $this->transaccion='SEG_UPFOTOPER_MOD';//nombre de la transaccion
        $this->tipo_procedimiento='IME';//tipo de transaccion

        //apartir del tipo  del archivo obtiene la extencion
        $ext = pathinfo($this->arregloFiles['foto']['name']);
        $this->arreglo['extension']= $ext['extension'];

        //Define los parametros para la funcion
        $this->setParametro('id_persona','id_persona','integer');
        $this->setParametro('extension','extension','varchar');
        $this->setParametro('foto','foto','bytea',false,1024,true);
        //$this->setParametro('foto','foto','bytea',false,1024,false,array("csv"));


        //Ejecuta la instruccion
        $this->armarConsulta();

        $this->ejecutarConsulta();
        return $this->respuesta;
    }

    function listarDocumentoIdentificacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_sel';// nombre procedimiento almacenado
        $this->transaccion='SEG_PER_DOC_IDE_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        //defino varialbes que se captran como retornod e la funcion
        $this->captura('id_tipo_doc_identificacion','integer');
        $this->captura('nombre','varchar');
        $this->captura('descripcion','text');
        $this->captura('fecha_reg','date');
        $this->captura('estado_reg','varchar');

        //Ejecuta la funcion
        $this->armarConsulta();
        //echo $this->consulta;exit;
        $this->ejecutarConsulta();
        return $this->respuesta;

    }
    function listarPersonaV2(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='segu.ft_persona_sel';// nombre procedimiento almacenado
        $this->transaccion='SEG_PERSONV2_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //defino varialbes que se captran como retornod e la funcion
        $this->captura('id_persona','integer');
        $this->captura('ap_materno','varchar');
        $this->captura('ap_paterno','varchar');
        $this->captura('nombre','varchar');
        $this->captura('nombre_completo1','text');
        $this->captura('nombre_completo2','text');
        $this->captura('ci','varchar');
        $this->captura('correo','varchar');
        $this->captura('celular1','varchar');
        $this->captura('num_documento','integer');
        $this->captura('telefono1','varchar');
        $this->captura('telefono2','varchar');
        $this->captura('celular2','varchar');
        $this->captura('fecha_nacimiento','date');
        $this->captura('genero','varchar');
        $this->captura('direccion','varchar');
        $this->captura('tipo_documento','varchar');
        $this->captura('expedicion','varchar');
        $this->captura('id_tipo_doc_identificacion','integer');
        $this->captura('nacionalidad','varchar');
        $this->captura('id_lugar','integer');
        $this->captura('discapacitado','varchar');
        $this->captura('nombre_lugar','varchar');

        $this->captura('fax','varchar');
        $this->captura('pag_web','varchar');
        $this->captura('observaciones','varchar');



        //Ejecuta la funcion
        $this->armarConsulta();
        //var_dump($this->consulta());exit;
        $this->ejecutarConsulta();


        return $this->respuesta;

    }

}
?>