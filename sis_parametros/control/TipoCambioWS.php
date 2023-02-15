<?php
if(empty($_SESSION["_WS_TIPO_CAMBIO_SERV"])){
    include(dirname(__FILE__).'/../../lib/DatosGenerales.php');
    include(dirname(__FILE__)."/../../lib/lib_modelo/conexion.php");
}
$cone = new conexion();
$link = $cone->conectarpdo();
$sql = "select tc.fecha from param.ttipo_cambio tc where tc.fecha = '".date('Y-m-d')."'";
$consulta = $link->query($sql);
$consulta->execute();
$tipo_cambio = $consulta->fetchAll(PDO::FETCH_ASSOC);
if(count($tipo_cambio)==0){
    $url=$_SESSION["_WS_TIPO_CAMBIO_SERV"].'/api/c/'.$_SESSION["_WS_TIPO_CAMBIO_TOKEN"];
    $ch=curl_init($url);
    $options=array(CURLOPT_RETURNTRANSFER=>true,CURLOPT_HTTPHEADER=>array('Accept: application/json'),CURLOPT_SSL_VERIFYPEER=>false,);
    curl_setopt_array($ch,$options);
    $response=curl_exec($ch);
    curl_close($ch);
    $cmp=json_decode($response,true);
    $fecha="'".substr($cmp[3],0,4).'-'.substr($cmp[3],5,2).'-'.substr($cmp[3],8,2)."'";
    $id_bs = 1;
    $id_dolar = 2;
    $id_ufv = 3;
    $query="INSERT INTO param.ttipo_cambio (id_usuario_reg, estado_reg, id_moneda, fecha, oficial, compra, venta, observaciones) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $link->prepare($query)->execute([1,'activo',$id_bs, $fecha, 1, 1, 1, 'Web Service OFEP']);
    $link->prepare($query)->execute([1,'activo',$id_dolar, $fecha, $cmp[1], $cmp[0], $cmp[1], 'Web Service OFEP']);
    $link->prepare($query)->execute([1,'activo',$id_ufv, $fecha, $cmp[2], $cmp[2], $cmp[2], 'Web Service OFEP']);
}