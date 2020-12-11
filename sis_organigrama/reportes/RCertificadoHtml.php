<?php
require_once(dirname(__FILE__) . '/../../lib/tcpdf/tcpdf_barcodes_2d.php');
class RCertificadoHtml{
    var $html;
    function generarHtml ($datos) {

        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        if ($datos['genero'] == 'Sr'){
            $tipo = 'del interesado';
            $gen = 'el';
            $tra = 'trabajor';
            $tipol = 'al interesado';
        }else{
            $tipo = 'de la interesada';
            $gen = 'la';
            $tra = 'trabajadora';
            $tipol = 'a la interesada';

        }

        //$fecha = date("d/m/Y");
        $fecha = $datos['fecha_solicitud'];

        if ($fecha >= '2019-12-18'){
            $firma_gerente = '../../../sis_organigrama/media/firma_eduardo_degadillo_poepsel.png';
            $w = 300;
            $h = 140;
            $cargo = 'Gerente Administrativo Financiero';
            $jefe = $datos['nuevo_jefe'];
            $gen_gerente = 'El suscrito';
            $siglas = 'JDP';
            $firma_responsable = $datos['nuevo_jefe'];
        }else{
            $firma_gerente = '../../../sis_organigrama/media/firma.png';
            $cargo = 'Jefe de Recursos Humanos';
            $w = 160;
            $h = 120;
            $jefe = $datos['jefa_recursos'];
            $gen_gerente = 'La suscrita';
            $siglas = 'GAG';
            $firma_responsable = $datos['jefa_recursos'];
        }


        $cadena = 'Numero Tramite: '.$datos['nro_tramite']."\n".'Fecha Solicitud: '.$datos['fecha_solicitud']."\n".'Funcionario: '.$datos['nombre_funcionario']."\n".'Firmado Por: '.$firma_responsable."\n".'Emitido Por: '.$datos['fun_imitido'];
        $barcodeobj = new TCPDF2DBarcode($cadena, 'QRCODE,M');



            $this->html.='<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
					   "http://www.w3.org/TR/html4/strict.dtd">
					<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
						<title>&nbsp;&nbsp;</title>
						<meta name="author" content="kplian">
					  <link rel="stylesheet" href="../../../sis_ventas_facturacion/control/print.css" type="text/css" media="print" charset="utf-8">
					</head>
					<body>
		<br>
		<br><br><br>
';
        if ($datos['tipo_certificado'] =='General') {
            $this->html .= '
<br>
<br>
<br>';
        }
        $this->html.='<table style="width: 100%;" border="0" >
<tbody>
<tr>
<td style="width: 160px;">&nbsp;</td>
<td><p style="text-align: center;"> <FONT FACE="Century Gothic" SIZE=4 ><u><b>CERTIFICADO</b></u></FONT></p></td>
<td style="width: 50px;">&nbsp;</td>
</tr>
<tr>
<td >&nbsp;</td>
<td><p style="text-align: justify"> <FONT FACE="Century Gothic" style="font-size: 12pt;" >'.$gen_gerente.' Lic. '.$jefe.' <b>'.$cargo.'</b> de la Empresa Pública Nacional Estratégica "Boliviana de Aviación - BoA", a solicitud '.$tipo.'</FONT></p>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td><FONT FACE="Century Gothic" SIZE=3><b>CERTIFICA:</b></FONT></td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td><p style="text-align: justify"><FONT FACE="Century Gothic" style="font-size: 12pt;" >Que, de la revisión de la carpeta que cursa en el Departamento de Recursos Humanos, se evidencia que '.$gen.' <b>'.$datos['genero'].'. '.$datos['nombre_funcionario'].'</b> con C.I. '.$datos['ci'].' '.$datos['expedicion'].', ingresó a la Empresa Pública Nacional Estratégica "Boliviana de Aviación - BoA"
         el '.$this->obtenerFechaEnLetra($datos['fecha_contrato']).', y actualmente ejerce el cargo de <b>'.$datos['nombre_cargo'].', con Nº de item '.$datos['nro_item'].'</b>, dependiente de la '.$datos['nombre_unidad'].', con una remuneración mensual de Bs. '.number_format($datos['haber_basico'],2,",",".") .'.- ('.$datos['haber_literal'].' Bolivianos).</FONT></p>
</td>
<td>&nbsp;</td>
</tr>';
        if (($datos['tipo_certificado'] =='Con viáticos de los últimos tres meses') ||
		($datos['tipo_certificado'] =='Con viáticos de los últimos tres meses(Factura)')) {
            $this->html .= '<tr>
<td>&nbsp;</td>
<td align="justify">
<FONT FACE="Century Gothic" style="font-size: 12pt;">Asimismo a solicitud expresa se informa que '.$gen.' '.$tra.' ha percibido en los últimos tres meses por concepto de viáticos un promedio mensual de '.number_format($datos['importe_viatico'],2,",",".").'.- ('.$datos['literal_importe_viatico'].' Bolivianos) aclarándose que el <b>Viático</b> es la suma que reconoce la empresa a la persona comisionada, <b>para cubrir gastos del viaje.</b></FONT>
</td>
<td>&nbsp;</td>
</tr>';
        }

        $this->html.='<tr>
<td>&nbsp;</td>
<td align="justify"><FONT FACE="Century Gothic" style="font-size: 12pt;">Es cuanto se certifica, para fines de derecho que convengan '.$tipol.'.<br><br>Cochabamba, '.$this->obtenerFechaEnLetra($datos['fecha_solicitud']).'.</FONT>
<br>
<table style="width: 100%;" border="0">
<tr style="height: 80px;">
<td align="center"> <img src = "../../../reportes_generados/'.$this->codigoQr ($cadena,$datos['nro_tramite']).'" align= "right " width="100" height="90" title="impreso"/></td>
<td><FONT FACE="Century Gothic" SIZE=1 >'.$siglas.'/'.$datos['iniciales'].'<br/>Cc/Arch</FONT><td>';
if ($fecha > '2020-12-04'){
  $this->html.='<td></td>';
}else{
  $this->html.='<td align="center"  ><img src = "'.$firma_gerente.'" align= "right " width="'.$w.'" height="'.$h.'" title="impreso"/></td>';
}
$this->html.='
</tr>
</table>
</td>
<td>&nbsp;</td>
</tr>
</tbody>
</table>

<script language="VBScript">
						Sub Print()
						       OLECMDID_PRINT = 6
						       OLECMDEXECOPT_DONTPROMPTUSER = 2
						       OLECMDEXECOPT_PROMPTUSER = 1
						       call WB.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER,1)
						End Sub
						document.write "<object ID="WB" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></object>"
</script>

						<script type="text/javascript">
						setTimeout(function(){
							 self.print();

							}, 1000);

						setTimeout(function(){
							 self.close();
							}, 2000);
						</script>

</body>
</html>';


            return  $this->html;
    }
    function fechaLiteral($va){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $fecha = strftime("%d de %B de %Y", strtotime($va));
        return $fecha;
    }
    function obtenerFechaEnLetra($fecha){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $dia= date("d", strtotime($fecha));
        $anno = date("Y", strtotime($fecha));
        $mes = array('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');
        $mes = $mes[(date('m', strtotime($fecha))*1)-1];
        return $dia.' de '.$mes.' del '.$anno;
    }
    function codigoQr ($cadena,$ruta){
        $barcodeobj = new TCPDF2DBarcode($cadena, 'QRCODE,M');

        $png = $barcodeobj->getBarcodePngData($w = 8, $h = 8, $color = array(0, 0, 0));
        $im = imagecreatefromstring($png);
        if ($im !== false) {
            header('Content-Type: image/png');
            imagepng($im, dirname(__FILE__) . "/../../../reportes_generados/".$ruta.".png");
            imagedestroy($im);
        } else {
            echo 'An error occurred.';
        }
        $url = $ruta.".png";
        return $url;
    }
}
?>
