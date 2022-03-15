<?php
class RCertificadoPDF extends  ReportePDF{
    function Header() {
        $this->ln(35);
        //$img_file = dirname(__FILE__).'/../media/direcciones.jpg';
        //$img_agua = dirname(__FILE__).'/../media/marcaAgua.jpg';

        //$this->Image($img_file, 7, 10, 90, 500, '', '', '', false, 300, '', false, false, 0);
       // $this->Image($img_agua, 130, 150, 80, 80, '', '', '', false, 300, '', false, false, 0);
        if ($this->datos[0]['genero'] == 'Sr'){
            $tipo = 'del interesado';
        }else{
            $tipo = 'de la interesada';
        }

        $fecha = $this->datos[0]['fecha_solicitud'];

        if ($fecha > '2020-12-04'){
          $firma_gerente = '/../media/firma.png';
          $cargo = 'Jefe Departamento Talento Humano';
          $w = 160;
          $h = 120;
          $jefe = $this->datos[0]['jefa_recursos'];
          $gen_gerente = 'La suscrita';
          $siglas = 'GAG';
          $firma_responsable = $this->datos[0]['jefa_recursos'];
        }else if ($fecha >= '2019-12-18' and $fecha <= '2020-12-04') {
          $firma_gerente = '../../../sis_organigrama/media/firma_eduardo_degadillo_poepsel.png';
          $w = 300;
          $h = 140;
          $cargo = 'Gerente Administrativo Financiero';
          $jefe = $datos['nuevo_jefe'];
          $gen_gerente = 'El suscrito';
          $siglas = 'JDP';
          $firma_responsable = $datos['nuevo_jefe'];
        }else{
            $firma_gerente = '/../media/firma.png';
            $cargo = 'Jefe de Recursos Humanos';
            $w = 160;
            $h = 120;
            $jefe = $this->datos[0]['jefa_recursos'];
            $gen_gerente = 'La suscrita';
            $siglas = 'GAG';
            $firma_responsable = $this->datos[0]['jefa_recursos'];
        }

        $this->SetFont('times', '', 15);
        $html = '<p align="center"><b><u>CERTIFICADO</u></b></p>';
        $this->writeHTML($html);
        $cabecera = '<p style="font-family:Century Gothic, serif; font-style:italic;text-align: justify">'.$gen_gerente.' Lic. '.$jefe.' <b>'.$cargo.'</b> de la Empresa Pública Nacional Estratégica "Boliviana de Aviación - BoA", a solicitud '.$tipo.'</p>';
        $this->ln(10);
        $this->SetFont('times', '', 13);
        $this->writeHTML($cabecera);
    }
    public function Footer()
    {
        $fecha_f= $this->datos[0]['fecha_solicitud'];
        if ($fecha_f > '2020-12-04'){
          $firma_gerente_f = '/../media/firma.png';
          $siglas = 'GAG';
          $firma_responsable_f = $this->datos[0]['nuevo_jefe'];
        }else if ($fecha_f >= '2019-12-18' and $fecha_f <= '2020-12-04') {
            $firma_gerente_f = '/../media/firma_eduardo_degadillo_poepsel.png';
            $siglas = 'JDP';
            $firma_responsable_f = $this->datos[0]['nuevo_jefe'];
        }else{
            $firma_gerente_f = '/../media/firma.png';
            $siglas = 'GAG';
            $firma_responsable_f = $this->datos[0]['nuevo_jefe'];
        }
        $this->SetY(-15);
        $this->SetFont('helvetica', 'I', 6);
        $this->Cell(0, 0, $siglas.'/'.$this->datos[0]['iniciales'], 0, 1, 'L');
        $this->Cell(0, 0, 'Cc/Arch', 0, 0, 'L');
        $html = 'Numero Tramite: '.$this->datos[0]['nro_tramite']."\n".'Fecha Solicitud: '.$this->datos[0]['fecha_solicitud']."\n".'Funcionario: '.$this->datos[0]['nombre_funcionario']."\n".'Firmado Por: '.$firma_responsable_f."\n".'Emitido Por: '.$this->datos[0]['fun_imitido'];
        $style = array(
            'border' => 2,
            'vpadding' => 'auto',
            'hpadding' => 'auto',
            'fgcolor' => array(0,0,0),
            'bgcolor' => false, //array(255,255,255)
            'module_width' => 1, // width of a single module in points
            'module_height' => 1 // height of a single module in points
        );
        if($this->datos[0]['estado'] == 'emitido') {
            $this->write2DBarcode($html, 'QRCODE,M', 160, 210, 30, 30, $style, 'N');
            $this->Image(dirname(__FILE__) .$firma_gerente_f, 98, 220, 35, 35, '', '', '', false, 300, '', false, false, 0);
        }

    }
    function setDatos($datos) {
        $this->datos = $datos;
    }
    function reporteGeneral(){
        if ($this->datos[0]['genero'] == 'Sr'){
            $gen = 'el';
            $tra = 'trabajor';
            $tipol = 'al interesado';
        }else{
            $gen = 'la';
            $tra = 'trabajadora';
            $tipol = 'a la interesada';
        }
        $this->ln(45);
        $this->SetFont('', '', 13);
        $html = '<p ><b>CERTIFICA:</b></p>';
        $this->writeHTML($html);
        $this->ln(8);
        $this->SetFont('', '', 13);
        $item = '';

        if (intval($this->datos[0]['nro_item']) > 0 ){
          $item = ' con Nº de ítem '.$this->datos[0]['nro_item'];
        }
        $cuerpo = '<p style="font-family:Century Gothic, serif; font-style:italic;text-align: justify">Que, de la revisión de la carpeta que cursa en el Departamento de Recursos Humanos, se evidencia que '.$gen.' <b>'.$this->datos[0]['genero'].'. '.$this->datos[0]['nombre_funcionario'].'</b> con C.I. '.$this->datos[0]['ci'].' '.$this->datos[0]['expedicion'].', ingresó a la Empresa Pública Nacional Estratégica "Boliviana de Aviación - BoA"
         el '.$this->fechaLiteral($this->datos[0]['fecha_contrato']).', y actualmente ejerce el cargo de <b>'.$this->datos[0]['nombre_cargo'].$item.'</b>, dependiente de la '.$this->datos[0]['nombre_unidad'].', con una remuneración mensual de Bs. '.number_format($this->datos[0]['haber_basico'],2,",",".") .'.- ('.$this->datos[0]['haber_literal'].' Bolivianos). </p><br>';
        $this->writeHTML($cuerpo);
        $viaticos='<p style="font-family:Century Gothic, serif; font-style:italic;text-align: justify">Asimismo a solicitud expresa se informa que '.$gen.' '.$tra.' ha percibido en los últimos tres meses por concepto de viáticos un promedio mensual de '.number_format($this->datos[0]['importe_viatico'],2,",",".").'.- ('.$this->datos[0]['literal_importe_viatico'].' Bolivianos) aclarándose que el <b>Viático</b> es la suma que reconoce la empresa a la persona comisionada, <b>para cubrir gastos del viaje.</b></p><br>';
        if (($this->datos[0]['tipo_certificado'] =='Con viáticos de los últimos tres meses')||
			($this->datos[0]['tipo_certificado'] =='Con viáticos de los últimos tres meses(Factura)')) {
            $this->writeHTML($viaticos);
        }
        $fecha='<p style="font-family:Century Gothic, serif; font-style:italic;text-align: justify">Es cuando se certifica, para fines de derecho que convengan '.$tipol.'.</p><p style="font-family:Century Gothic, serif; font-style:italic;text-align: justify">Cochabamba '.$this->obtenerFechaEnLetra($this->datos[0]['fecha_solicitud']).'.</p>';
        $this->writeHTML($fecha);

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
    function generarReporte() {
        $this->SetMargins(50,40,25);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(50,40,25);
        $this->reporteGeneral();
    }
}
?>
