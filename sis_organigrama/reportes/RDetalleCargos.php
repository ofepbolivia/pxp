<?php
//Adalid: reporte de DETALLE DE CARGOS HR01218-2025

class RDetalleCargos extends ReportePDF
{
    var $dataMaster = array();
    var $ancho_hoja;
    var $unidad;
    var $numeracion;
    var $ancho_sin_totales;
    var $posY;

    function datosHeader($maestro)
    {
        $this->ancho_hoja = $this->getPageWidth() - PDF_MARGIN_LEFT - PDF_MARGIN_RIGHT - 10;
        $this->dataMaster = $maestro;
    }

    function setUnidad($unidad)
    {
        $this->unidad = $unidad;
    }

    function Header()
    {
        $content = '<table border="0.5" cellpadding="1" style="font-size: 11px">
            <tr>
                <td style="width: 23%; color: #444444;" rowspan="2">
                    &nbsp;<img  style="width: 120px;" src="./../../../lib/' . $_SESSION['_DIR_LOGO'] . '" alt="Logo">
                </td>		
                <td style="width: 52%; color: #444444;text-align: center" rowspan="2">
                   <b style="font-size: 14px">DETALLE DE CARGOS<br>UNIDAD: '.$this->unidad.'</b>
                </td>
                <td style="width: 25%; color: #444444; text-align: left;height: 30px">&nbsp;&nbsp;<b>Revisión:</b> 1</td>
            </tr>
            <tr>
                <td style="width: 25%; color: #444444; text-align: left;">&nbsp;&nbsp;<b>Página:</b> ' . $this->getAliasNumPage() . ' de ' . $this->getAliasNbPages() . '</td>
            </tr>
        </table>';
        $this->writeHTML($content, false, false, true, false, '');
    }

    function generarReporte() {
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetFontSize(7);
        $html = '<table border="0.5" cellpadding="2" cellspacing="0">';
        $html .= '<tr style="background-color: #cccccc;font-size: 10px;text-align: center;vertical-align: middle;">
                    <td width="5%"><b>N°</b></td>
                    <td width="15%"><b>CÓDIGO</b></td>
                    <td width="12%"><b>FECHA DE ASIGNACION</b></td>
                    <td width="35%" style="vertical-align: middle;"><b>FUNCIONARIO</b></td>
                    <td width="10%"><b>ITEM</b></td>
                    <td width="13%"><b>N° DOCUMENTO DE ASIGNACIÓN</b></td>
                    <td width="10%"><b>ESTADO FUNCIONAL</b></td></tr>';
        if (is_array($this->dataMaster) && count($this->dataMaster) > 0) {
            $cantidad = 1;
            foreach ($this->dataMaster as $row) {
                $html .= '<tr>';
                $html .= '<td>' . $cantidad . '</td>';
                $html .= '<td>' . $row['codigo'] . '</td>';
                $html .= '<td align="center">' . date('d/m/Y', strtotime($row['fecha_asignacion'])) . '</td>';
                $html .= '<td>' . $row['desc_funcionario1'] . '</td>';
                $html .= '<td>' . $row['item'] . '</td>';
                $html .= '<td>' . $row['nro_documento_asignacion'] . '</td>';
                $html .= '<td>' . $row['estado_funcional'] . '</td>';
                //$html .= '<td align="right">' . number_format($row['haber_basico'], 2, ',', '.') . '</td>';
                $html .= '</tr>';
                $cantidad++;
            }
        } else {
            $html .= '<tr>';
            $html .= '<td colspan="7" align="center" height="30"><p>No hay registros</p></td>';
            $html .= '</tr>';
        }
        $html .= '</table>';
        $this->writeHTML($html, false, false, true, false, '');
        $this->Ln(10);
    }

    function Footer()
    {
        $this->setY(-15);
        $ormargins = $this->getOriginalMargins();
        $this->SetTextColor(0, 0, 0);
        //set style for cell border
        $line_width = 0.85 / $this->getScaleFactor();
        $this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
        $this->Ln(2);
        $cur_y = $this->GetY();
        //$this->Cell($ancho, 0, 'Generado por XPHS', 'T', 0, 'L');
        $this->Cell($ancho, 0, 'Usuario: ' . $_SESSION['_LOGIN'], '', 0, 'L');
        $pagenumtxt = 'Página' . ' ' . $this->getAliasNumPage() . ' de ' . $this->getAliasNbPages();
        $this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
        $this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
        $this->Ln();
        $fecha_rep = date("d-m-Y H:i:s");
        $this->Cell($ancho, 0, "Fecha : " . $fecha_rep, '', 0, 'L');
        $this->Ln($line_width);
        $this->Ln();
    }
}

?>