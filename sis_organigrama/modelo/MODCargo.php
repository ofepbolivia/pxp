<?php
/**
 *@package pXP
 *@file gen-MODCargo.php
 *@author  (admin)
 *@date 14-01-2014 19:16:06
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */
include_once(dirname(__FILE__).'/../../lib/lib_modelo/ConexionSqlServer.php');
class MODCargo extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarCargo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_cargo_sel';
        $this->transaccion='OR_CARGO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('fecha','fecha','date');
        $this->setParametro('id_uo','id_uo','integer');
        $this->setParametro('presupuesto','presupuesto','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('id_cargo','int4');
        $this->captura('id_uo','int4');
        $this->captura('id_tipo_contrato','int4');
        $this->captura('id_lugar','int4');
        $this->captura('id_temporal_cargo','int4');
        $this->captura('id_escala_salarial','int4');
        $this->captura('codigo','varchar');
        $this->captura('nombre','varchar');
        $this->captura('fecha_ini','date');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_fin','date');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('nombre_tipo_contrato','varchar');
        $this->captura('nombre_escala','varchar');
        $this->captura('nombre_oficina','varchar');
        $this->captura('acefalo','varchar');
        $this->captura('id_oficina','int4');
        $this->captura('identificador','int4');
        $this->captura('codigo_tipo_contrato','varchar');
        $this->captura('haber_basico','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();//var_dump($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


    function listarCargoAcefalo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_cargo_sel';
        $this->transaccion='OR_CARGOACE_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);


        $this->setParametro('fecha','fecha','date');


        //Definicion de la lista del resultado del query
        $this->captura('cargo','varchar');
        $this->captura('lugar','varchar');
        $this->captura('gerencia','varchar');
        $this->captura('cantidad','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarCargo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='OR_CARGO_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');
        $this->setParametro('id_oficina','id_oficina','int4');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_temporal_cargo','id_temporal_cargo','int4');
        $this->setParametro('id_escala_salarial','id_escala_salarial','int4');
        $this->setParametro('codigo','codigo','varchar');
        //$this->setParametro('nombre','nombre','varchar');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('fecha_fin','fecha_fin','date');

        /*********************************presupuesto*********************************/
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('id_centro_costo','id_centro_costo','int4');
        $this->setParametro('id_ot','id_ot','int4');
        $this->setParametro('porcentaje','porcentaje','numeric');
        $this->setParametro('fecha_ini_cc','fecha_ini_cc','date');
        $this->setParametro('fecha_fin_cc','fecha_fin_cc','date');
        /*********************************presupuesto*********************************/

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarCargo(){

        $id_cargo = $this->objParam->getParametro('id_cargo');
        $id_oficina = $this->objParam->getParametro('id_oficina');
        $organigrama = $this->objParam->getParametro('id_uo');
        $contrato = $this->objParam->getParametro('id_tipo_contrato');
        $nroitem = $this->objParam->getParametro('codigo');
        $cargo = $this->objParam->getParametro('id_temporal_cargo');
        $escala = $this->objParam->getParametro('id_escala_salarial');
        $fecha_ini = $this->objParam->getParametro('fecha_ini');
        $fecha_fin = $this->objParam->getParametro('fecha_fin');


        $usuario = $_SESSION["ss_id_funcionario"];
        $cone = new conexion();
        $link = $cone->conectarpdo();
        $sql = "
            select tuo.id_uo_funcionario idende, tuo.id_funcionario idempleado, tc.id_cargo iditem, tuo.nro_documento_asignacion resolucion, 
            tuo.fecha_asignacion fechainicio, tuo.fecha_finalizacion fechafin, tuo.fecha_documento_asignacion aprobado, tuo.estado_reg estado, 
            tc.id_oficina, tc.nombre
            from orga.tcargo tc
            inner join orga.tuo_funcionario tuo on tuo.id_cargo = tc.id_cargo
            where tc.id_cargo = $id_cargo and coalesce(tuo.fecha_finalizacion,'31/12/9999'::date) >= current_date     
        ";
        $stmt = $link->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result){
            if($result['id_oficina'] != $id_oficina) {

                $conex = "
                    select tv.valor
                    from pxp.variable_global tv
                    where tv.variable = 'cadena_db_sql_2'
                ";
                $stmt = $link->prepare($conex);
                $stmt->execute();
                $conex = $stmt->fetch(PDO::FETCH_ASSOC);

                $param_conex = explode(',', $conex['valor']);

                $base = "
                    select tl.codigo base, tl.id_lugar, tl.nombre lugar
                    from orga.toficina tof
                    inner join param.tlugar tl on tl.id_lugar = tof.id_lugar
                    where tof.id_oficina = $id_oficina
                ";
                $stmt = $link->prepare($base);
                $stmt->execute();
                $base = $stmt->fetch(PDO::FETCH_ASSOC);
                //var_dump('$base',$base);
                $initial = "
                    select tp.nombre
                    from orga.ttemporal_cargo tp
                    where tp.id_temporal_cargo = $cargo
                ";
                $stmt = $link->prepare($initial);
                $stmt->execute();
                $initial = $stmt->fetch(PDO::FETCH_ASSOC);

                $words = explode(' ', $initial['nombre']);
                $initial = "";
                foreach($words as $Word){
                    if ($Word[0] == strtoupper($Word[0]))
                        $initial.=$Word[0];
                }

                $conexion = new ConexionSqlServer($param_conex[0], $param_conex[2], $param_conex[3], $param_conex[1]);
                $conn = $conexion->conectarSQL();

                @mssql_query(utf8_decode("exec Ende_Item 'UPD', $id_cargo, $organigrama, $contrato, '$nroitem', $cargo, $escala, '$initial', ".$base['id_lugar'].", '".$base['lugar']."', '".$fecha_ini."', '".$fecha_fin."';"), $conn);
                @mssql_query(utf8_decode("exec Ende_HistorialCargo 'UPD', ".$result['idende'].", ".$result['idempleado'].", ".$result['iditem'].", '".$result['resolucion']."', '".$result['fechainicio']."', '".$result['fechafin']."', $usuario, '".$result['aprobado']."', '".$result['estado']."', $id_oficina, '".$base['base']."';"), $conn);

                $conexion->closeSQL();
                if (false) {
                    $data = array(
                        "id_funcionario" => $result['idempleado'],
                        "usuario" => $_SESSION["_LOGIN"] ? $_SESSION["_LOGIN"] : 'erp'
                    );

                    $json_data = json_encode($data);
                    $s = curl_init();
                    curl_setopt($s, CURLOPT_URL, 'http://sms.obairlines.bo/servplanificacion/servPlanificacion.svc/ValidarcambiosHistorialCargoItem');//skbproduccion, skbpruebas
                    curl_setopt($s, CURLOPT_POST, true);
                    curl_setopt($s, CURLOPT_POSTFIELDS, $json_data);
                    curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
                    curl_setopt($s, CURLOPT_CONNECTTIMEOUT, 20);
                    curl_setopt($s, CURLOPT_HTTPHEADER, array(
                            'Content-Type: application/json',
                            'Content-Length: ' . strlen($json_data))
                    );
                    $_out = curl_exec($s);
                    $status = curl_getinfo($s, CURLINFO_HTTP_CODE);
                    if (!$status) {
                        throw new Exception("No se pudo conectar con el Servicio");
                    }
                    curl_close($s);
                    $res = json_decode($_out);

                    //var_dump('$response', $res);
                }
            }
        }

        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='OR_CARGO_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cargo','id_cargo','int4');
        $this->setParametro('id_tipo_contrato','id_tipo_contrato','int4');
        $this->setParametro('id_oficina','id_oficina','int4');
        $this->setParametro('id_temporal_cargo','id_temporal_cargo','int4');
        $this->setParametro('id_escala_salarial','id_escala_salarial','int4');
        $this->setParametro('codigo','codigo','varchar');
        //$this->setParametro('nombre','nombre','varchar');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('fecha_fin','fecha_fin','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarCargo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='OR_CARGO_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_cargo','id_cargo','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarPresupuestoCargo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='orga.ft_cargo_sel';
        $this->transaccion='OR_PRE_CARGO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(true);
        //$this->setParametro('tipo','tipo','varchar');
        //$this->setParametro('fecha','fecha','date');
        //$this->setParametro('id_uo','id_uo','integer');
        $this->setParametro('presupuesto','presupuesto','varchar');
        $this->setParametro('activo','activo','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','int4');
        $this->captura('id_cargo','int4');
        $this->captura('id_uo','int4');
        $this->captura('id_tipo_contrato','int4');
        $this->captura('id_lugar','int4');
        $this->captura('id_temporal_cargo','int4');
        $this->captura('id_escala_salarial','int4');
        $this->captura('codigo','varchar');
        $this->captura('cargo','varchar');
        $this->captura('fecha_ini','date');
        $this->captura('estado_reg','varchar');
        $this->captura('fecha_fin','date');

        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('nombre_tipo_contrato','varchar');
        $this->captura('nombre_escala','varchar');
        $this->captura('nombre_oficina','varchar');
        $this->captura('acefalo','varchar');
        $this->captura('id_oficina','int4');
        $this->captura('identificador','varchar');
        $this->captura('codigo_tipo_contrato','varchar');
        $this->captura('desc_func','varchar');
        $this->captura('fecha_asignacion','date');
        $this->captura('fecha_finalizacion','date');

        $this->captura('desc_tcc','varchar');
        $this->captura('codigo_categoria','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();//echo($this->consulta);exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    //(franklin.espinoza) 27/12/2019
    function clonarPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='OR_CARGO_CLONAR';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_gestion','id_gestion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta(); //echo $this->consulta; exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    //(franklin.espinoza) 05/08/2021
    /**************************************************PRESUPUESTO**************************************************/
    function loadCargoPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='orga.ft_cargo_ime';
        $this->transaccion='OR_LOAD_CAR_PRE';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_uo','id_uo','int4');

        //Ejecuta la instruccion
        $this->armarConsulta(); //echo $this->consulta; exit;
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    /**************************************************PRESUPUESTO**************************************************/
}
?>