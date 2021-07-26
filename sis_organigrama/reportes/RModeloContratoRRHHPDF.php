<?php
// Extend the TCPDF class to create custom MultiRow
class RModeloContratoRRHHPDF extends  ReportePDF {
    var $datos_titulo;
    var $datos_detalle;
    var $ancho_hoja;
    var $gerencia;
    var $numeracion;
    var $ancho_sin_totales;
    var $cantidad_columnas_estaticas;

    function setDatos($datos) {
        $this->datos = $datos;
        //var_dump($this->datos);exit;
    }

    function Header() {
        $this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg',84,7,40,20);
        $this->ln(5);
        $this->SetFont('times','B',12);
        /*$this->Cell(0,5,"CONTRATO INDIVIDUAL DE TRABAJO",0,1,'C');
        $this->Cell(0,5,'OB.GL.CL.___.2021',0,1,'C');*/

    }

    function Footer() {
        $this->setY(-15);
        $ormargins = $this->getOriginalMargins();
        $this->SetTextColor(0, 0, 0);
        //set style for cell border
        $line_width = 0.85 / $this->getScaleFactor();
        $this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
        $this->Ln(2);
        $this->Cell($ancho, 0, '', '', 0, 'L');
        $pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
        $this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
        $this->Ln();
        $this->Ln($line_width);
        $this->Ln();
    }

    function generarReporte() {
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->writeHTML($this->datos[0]['contrato']);
        $this->AddPage();
        $this->writeHTML ($this->datos[0]['anexo']);
    }
}
?>