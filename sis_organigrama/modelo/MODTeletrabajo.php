<?php
/**
 * @package pXP
 * @file MODTeletrabajo.php
 *@author  (Ismael Valdivia)
 *@date 26-05-2020 21:00
 *@description Servicio para Formulario de Teletrabajo
 */

class MODTeletrabajo extends MODbase
{
    function ConsultaFuncionarioTeletrabajo()
    {
          $this->procedimiento = 'orga.ft_teletrabajo_sel';
          $this->transaccion = 'ORGA_CONS_TELTRA_SEL';
          $this->tipo_procedimiento = 'SEL';//tipo de transaccion
          $this->setCount(false);
          $this->setParametro('ci', 'ci', 'varchar');

          //Definicion de la lista del resultado del query
          $this->captura('id_funcionario', 'integer');
          $this->captura('apellido_paterno', 'varchar');
          $this->captura('apellido_materno', 'varchar');
          $this->captura('nombre', 'varchar');
          $this->captura('ci', 'varchar');
          $this->captura('expedicion', 'varchar');
          $this->captura('direccion', 'varchar');
          $this->captura('nombre_cargo', 'varchar');
          $this->captura('gerencia', 'varchar');
          $this->captura('registrado', 'varchar');
          //Ejecuta la instruccion
          $this->armarConsulta();
          $this->ejecutarConsulta();

          //Devuelve la respuesta
          return $this->respuesta;
    }

    function InsertarFuncionarioTeleTrabajo()
    {
          $this->procedimiento = 'orga.ft_teletrabajo_ime';
          $this->transaccion = 'ORGA_INS_TELTRA_IME';
          $this->tipo_procedimiento = 'IME';//tipo de transaccion

          $this->setParametro('id_funcionario', 'id_funcionario', 'integer');
          $this->setParametro('ci', 'ci', 'varchar');
          $this->setParametro('equipo_computacion', 'equipo_computacion', 'varchar');
          $this->setParametro('tipo_de_uso', 'tipo_de_uso', 'varchar');
          $this->setParametro('cuenta_con_internet', 'cuenta_con_internet', 'varchar');
          $this->setParametro('zona_domicilio', 'zona_domicilio', 'text');
          $this->setParametro('transporte_particular', 'transporte_particular', 'varchar');
          $this->setParametro('tipo_transporte', 'tipo_transporte', 'varchar');
          $this->setParametro('placa', 'placa', 'varchar');

          //Ejecuta la instruccion
          $this->armarConsulta();
          $this->ejecutarConsulta();
          //var_dump("aqui entra",$this->respuesta);
          //Devuelve la respuesta
          return $this->respuesta;
    }


}

?>
