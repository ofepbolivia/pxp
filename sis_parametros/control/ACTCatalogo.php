<?php
/**
 * @package pXP
 * @file gen-ACTCatalogo.php
 * @author  (admin)
 * @date 16-11-2012 17:01:40
 * @description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTCatalogo extends ACTbase
{

    function listarCatalogo()
    {
        $this->objParam->defecto('ordenacion', 'id_catalogo');
        $this->objParam->defecto('dir_ordenacion', 'asc');

        if ($this->objParam->getParametro('catalogoTipo') != '') {
            $this->objParam->addFiltro("cattip.nombre = ''" . $this->objParam->getParametro('catalogoTipo') . "''");
        }

        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODCatalogo', 'listarCatalogo');
        } else {
            $this->objFunc = $this->create('MODCatalogo');
            $this->res = $this->objFunc->listarCatalogo();
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarCatalogo()
    {
        $this->objFunc = $this->create('MODCatalogo');
        if ($this->objParam->insertar('id_catalogo')) {
            $this->res = $this->objFunc->insertarCatalogo();
        } else {
            $this->res = $this->objFunc->modificarCatalogo();
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarCatalogo()
    {
        $this->objFunc = $this->create('MODCatalogo');
        $this->res = $this->objFunc->eliminarCatalogo();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarCatalogoCombo()
    {//fRnk: ver nos quedamos aquí
        //{"start":"0","limit":"200","sort":"codigo","dir":"ASC","cod_subsistema":"PARAM","catalogo_tipo":"autorizaciones_concepto","query":""}
        $this->objParam->defecto('ordenacion', 'id_catalogo');
        $this->objParam->defecto('dir_ordenacion', 'asc');
        //Verifica los filtros enviados de la vista
        if ($this->objParam->getParametro('catalogo_tipo') != '') {
            $cond = $this->objParam->getParametro('catalogo_tipo');
            $this->objParam->addFiltro("cattip.nombre = ''$cond''");
        }
        if ($this->objParam->getParametro('cod_subsistema') != '') {
            $cond = $this->objParam->getParametro('cod_subsistema');
            $this->objParam->addFiltro("subsis.codigo = ''$cond''");
        }
        /*Aumentando para filtrar por la descipcion*/
        if ($this->objParam->getParametro('filtro_descripcion') != '') {
            $cond = $this->objParam->getParametro('filtro_descripcion');
            $this->objParam->addFiltro("cat.descripcion = ''$cond''");
        }
        /*******************************************/

        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODCatalogo', 'listarCatalogoCombo');
        } else {
            $this->objFunc = $this->create('MODCatalogo');
            $this->res = $this->objFunc->listarCatalogoCombo();
        }
        //echo var_dump($this->res);exit();
        /*Aqui para poner todos los puntos de ventas*/
        // 23-03-2021 (ismael valdivia)
        if ($this->objParam->getParametro('_adicionar') != '') {

            $respuesta = $this->res->getDatos();


            array_unshift($respuesta, array(
                'codigo' => 'TODOS',
                'descripcion' => 'TODOS'));
            //var_dump($respuesta);
            $this->res->setDatos($respuesta);
        }
        /********************************************/


        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listadoCatalogoCodigo()
    {

        if ($this->objParam->getParametro('codigo') != '') {
            $cond = $this->objParam->getParametro('codigo');
            $this->objParam->addFiltro("cat.codigo = ''$cond''");
        }

        $this->objFunc = $this->create('MODCatalogo');
        $this->res = $this->objFunc->listarCatalogoCombo();
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>
