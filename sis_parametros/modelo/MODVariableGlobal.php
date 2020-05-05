[Ayer 3:20 p.m.] Ismael Ramiro Valdivia Aranibar

<?php
/**
 * @package pXP
 * @file gen-MODVariableGlobal.php
 * @author  (admin)
 * @date 30-04-2020 14:38:58
 * @description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */


class MODVariableGlobal extends MODbase
{
    function conexionAlkym()
    {
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento = 'param.ft_get_variables_globales_sel';
        $this->transaccion = 'PARAM_GET_VG_SEL';
        $this->tipo_procedimiento = 'SEL';
        $this->setCount(false);


        $this->setParametro('variable_global', 'variable_global', 'varchar');
        //Definicion de la lista del resultado del query
        $this->captura('variable_obtenida', 'varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();


        //Devuelve la respuesta
        return $this->respuesta;
    }
}


?>