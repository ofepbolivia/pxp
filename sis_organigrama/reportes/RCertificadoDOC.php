<?php
require_once(dirname(__FILE__) . '/../../lib/tcpdf/tcpdf_barcodes_2d.php');
require_once(dirname(__FILE__) . '/../../lib/PHPWord-master/src/PhpWord/Autoloader.php');
\PhpOffice\PhpWord\Autoloader::register();
Class RCertificadoDOC {

    private $dataSource;
    var $lista;
    public function datosHeader( $dataSource) {
        $this->dataSource = $dataSource;
        //var_dump($this->dataSource);exit;
    }

    function write($fileName) {
        if ($this->dataSource[0]['genero'] == 'Sr'){
            $tipo = 'del interesado';
            $gen = 'el';
            $tipol = 'al interesado';
            $tra = 'trabajor';
        }else{
            $gen = 'la';
            $tipo = 'de la interesada';
            $tipol = 'a la interesada';
            $tra = 'trabajadora';
        }

        //$fecha = date("d/m/Y");
        $fecha = $this->dataSource[0]['fecha_solicitud'];

        if(($this->dataSource[0]['tipo_certificado'] =='Con viáticos de los últimos tres meses') ||
		($this->dataSource[0]['tipo_certificado'] =='Con viáticos de los últimos tres meses(Factura)')){
            if ($fecha >= '2020-12-04'){
              $templateProcessor = new \PhpOffice\PhpWord\TemplateProcessor(dirname(__FILE__).'/cer_viatico.docx');
              $firma_resonsable = $this->dataSource[0]['jefa_recursos'];
            }else if($fecha >= '2019-12-18' and $fecha <= '2020-12-04'){
                $templateProcessor = new \PhpOffice\PhpWord\TemplateProcessor(dirname(__FILE__).'/cer_viatico_gen.docx');
                $firma_resonsable = $this->dataSource[0]['nuevo_jefe'];
            }else{
                $templateProcessor = new \PhpOffice\PhpWord\TemplateProcessor(dirname(__FILE__).'/cer_viatico.docx');
                $firma_resonsable = $this->dataSource[0]['jefa_recursos'];
            }

        }else{
            if ($fecha >= '2020-12-04'){
                $templateProcessor = new \PhpOffice\PhpWord\TemplateProcessor(dirname(__FILE__).'/cer_general.docx');
                $firma_resonsable = $this->dataSource[0]['jefa_recursos'];
            }else if($fecha >= '2019-12-18' and $fecha <= '2020-12-04'){
                $templateProcessor = new \PhpOffice\PhpWord\TemplateProcessor(dirname(__FILE__).'/cer_general_gen.docx');
                $firma_resonsable = $this->dataSource[0]['nuevo_jefe'];
            }else{
                $templateProcessor = new \PhpOffice\PhpWord\TemplateProcessor(dirname(__FILE__).'/cer_general.docx');
                $firma_resonsable = $this->dataSource[0]['jefa_recursos'];
            }

        }

        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $templateProcessor->setValue('JEFA_RECURSOS', $this->dataSource[0]['jefa_recursos']);
        $templateProcessor->setValue('NUEVO_JEFE', $this->dataSource[0]['nuevo_jefe']);
        $templateProcessor->setValue('INTERESADO', $tipo);
        $templateProcessor->setValue('LA', $gen);
        $templateProcessor->setValue('INTERESADA', $tipol);
        $templateProcessor->setValue('GENERO', $this->dataSource[0]['genero']);
        $templateProcessor->setValue('NOMBRE_FUNCIONARIO', $this->dataSource[0]['nombre_funcionario']);
        $templateProcessor->setValue('CI', $this->dataSource[0]['ci']);
        $templateProcessor->setValue('EXPEDIDO', $this->dataSource[0]['expedicion']);
        $templateProcessor->setValue('FECHA_CONTRATO', $this->fechaLiteral($this->dataSource[0]['fecha_contrato']));
        $templateProcessor->setValue('NOMBRE_CARGO', $this->dataSource[0]['nombre_cargo']);
        $templateProcessor->setValue('GERENCIA', $this->dataSource[0]['nombre_unidad']);
        $templateProcessor->setValue('MONTO', number_format($this->dataSource[0]['haber_basico'],2,",","."));
        $templateProcessor->setValue('INICIALES', $this->dataSource[0]['iniciales']);
        $templateProcessor->setValue('LITERAL', $this->dataSource[0]['haber_literal']);
        $templateProcessor->setValue('FECHA_SOLICITUD', $this->obtenerFechaEnLetra($this->dataSource[0]['fecha_solicitud']));
        if(($this->dataSource[0]['tipo_certificado'] =='Con viáticos de los últimos tres meses') ||
		($this->dataSource[0]['tipo_certificado'] =='Con viáticos de los últimos tres meses(Factura)')){
            $templateProcessor->setValue('TRABAJADORA', $tra);
            $templateProcessor->setValue('VIATICO', number_format($this->dataSource[0]['importe_viatico'],2,",","."));
            $templateProcessor->setValue('VIATICO_LITERAL', $this->dataSource[0]['literal_importe_viatico']);

        }
        $cadena = 'Numero Tramite: '.$this->dataSource[0]['nro_tramite']."\n".'Fecha Solicitud: '.$this->dataSource[0]['fecha_solicitud']."\n".'Funcionario: '.$this->dataSource[0]['nombre_funcionario']."\n".'Firmado Por: '.$firma_resonsable."\n".'Emitido Por: '.$this->dataSource[0]['fun_imitido'];
        if($this->dataSource[0]['estado'] == 'emitido') {
            $templateProcessor->setImg('QR', array('src' => $this->codigoQr($cadena, $this->dataSource[0]['nro_tramite']), 'swh' => '90'));
        }else{
            $templateProcessor->setValue('QR', ' ');

        }
        $templateProcessor->saveAs($fileName);

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
        //var_dump(dirname(__FILE__) . "/../../reportes_generados/".$ruta.".png");exit;
        $url =  dirname(__FILE__) . "/../../../reportes_generados/".$ruta.".png";
        return $url;
    }
}

?>
