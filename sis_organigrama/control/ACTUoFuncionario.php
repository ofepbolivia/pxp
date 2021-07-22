<?php
/***
Nombre: ACTUoFuncionario.php
Proposito: Clase de Control para recibir los parametros enviados por los archivos
de la Vista para envio y ejecucion de los metodos del Modelo referidas a la tabla tuo_funcionario
Autor:	Kplian
Fecha:	01/07/2010
 */

require_once(dirname(__FILE__).'/../reportes/RModeloContratoRRHHPDF.php');

class ACTUoFuncionario extends ACTbase{

    function listarUoFuncionario(){

        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','FUNCIO.desc_funcionario1');
        $this->objParam->defecto('dir_ordenacion','asc');

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        if ($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte=new Reporte($this->objParam, $this);
            $this->res=$this->objReporte->generarReporteListado('MODUoFuncionario','listarUoFuncionario');
        }
        else {
            //obtiene el parametro nodo enviado por la vista
            $id_uo=$this->objParam->getParametro('id_uo');
            $this->objParam->addParametro('id_uo',$id_uo);
            //$this->objParam->addParametro('id_subsistema',$id_subsistema);
            $this->objFunSeguridad=$this->create('MODUoFuncionario');
            //ejecuta el metodo de lista funcionarios a travez de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->listarUoFuncionario($this->objParam);

        }
        //imprime respuesta en formato JSON para enviar lo a la interface (vista)
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function guardarUoFuncionario(){

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        $this->objFunSeguridad=$this->create('MODUoFuncionario');

        //preguntamos si se debe insertar o modificar
        if($this->objParam->insertar('id_uo_funcionario')){
            //$json = "http://172.17.45.127/GeneradorUsuario/Home/Generar?idEmpleadoENDE=".$this->objParam->getParametro('id_funcionario');
            //$jsonfile = file_get_contents($json);
            //ejecuta el metodo de insertar de la clase MODFuncionario a travez
            //de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->insertarUoFuncionario($this->objParam);
        }
        else{
            //ejecuta el metodo de modificar funcionario de la clase MODFuncionario a travez
            //de la intefaz objetoFunSeguridad
            $this->res=$this->objFunSeguridad->modificarUoFuncionario($this->objParam);
        }

        //imprime respuesta en formato JSON
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    function eliminarUoFuncionario(){

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        $this->objFunSeguridad=$this->create('MODUoFuncionario');
        $this->res=$this->objFunSeguridad->eliminarUoFuncionario($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }

    function listarAsignacionFuncionario(){

        // parametros de ordenacion por defecto
        $this->objParam->defecto('ordenacion','FUNCIO.desc_funcionario1');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('tipo') != ''){
            $this->objParam->addFiltro("UOFUNC.tipo = ''".$this->objParam->getParametro('tipo')."''");
        }

        if ($this->objParam->getParametro('id_funcionario') != ''){
            $this->objParam->addFiltro("UOFUNC.id_funcionario = ".$this->objParam->getParametro('id_funcionario'));
        }



        //$this->objParam->addParametro('id_subsistema',$id_subsistema);
        $this->objFunSeguridad=$this->create('MODUoFuncionario');
        //ejecuta el metodo de lista funcionarios a travez de la intefaz objetoFunSeguridad
        $this->res=$this->objFunSeguridad->listarAsignacionFuncionario($this->objParam);

        //imprime respuesta en formato JSON para enviar lo a la interface (vista)
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    /****************************************Reporte Modelo Contrato RRHH(franklin.espinoza) 14/07/2021**************************************/
    function reporteModeloContrato (){
        $this->objFunc=$this->create('MODUoFuncionario');
        $dataSource=$this->objFunc->reporteModeloContrato();
        $this->dataSource=$dataSource->getDatos();


        $nombreArchivo = uniqid(md5(session_id()).'[Contrato - RRHH]').'.pdf';
        $this->objParam->addParametro('orientacion','P');
        $this->objParam->addParametro('tamano','Legal');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $this->objReporte = new RModeloContratoRRHHPDF($this->objParam);
        $this->objReporte->setDatos($this->dataSource);
        $this->objReporte->generarReporte();
        $this->objReporte->output($this->objReporte->url_archivo,'F');


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado', 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    /****************************************Reporte Modelo Contrato RRHH(franklin.espinoza) 14/07/2021**************************************/

    /*****************************Recuperar el correlativo de contrato RRHH(franklin.espinoza) 14/07/2021*****************************/
    function recuperarNumeroContrato(){

        //crea el objetoFunSeguridad que contiene todos los metodos del sistema de seguridad
        $this->objFunSeguridad=$this->create('MODUoFuncionario');
        $this->res=$this->objFunSeguridad->recuperarNumeroContrato($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
    /*****************************Recuperar el correlativo de contrato RRHH(franklin.espinoza) 14/07/2021*****************************/
}

?>