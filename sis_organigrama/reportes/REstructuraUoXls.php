<?php

//fRnk: nuevo reporte Estructura UO HR01765-2024
class REstructuraUoXls
{
    private $docexcel;
    private $objWriter;
    private $objParam;
    public $url_archivo;

    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/" . $this->objParam->getParametro('nombre_archivo');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize' => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);
        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator($_SESSION['_TITULO_SIS_CORTO'])
            ->setLastModifiedBy($_SESSION['_TITULO_SIS_CORTO'])
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "' . $this->objParam->getParametro('titulo_archivo'))
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");
        $this->docexcel->setActiveSheetIndex(0);
    }

    function imprimeDatos()
    {
        $this->docexcel->getActiveSheet()->setTitle('Estructura Organizacional');
        $sheet = $this->docexcel->getActiveSheet();
        $datos = $this->objParam->getParametro('datos');
        $this->createSheet($sheet, $datos, 'T');
    }

    function createSheet($sheet, $datos, $type)
    {
        $sharedStyle1 = new PHPExcel_Style();
        $sheet->setCellValue('A2', 'ESTRUCTURA ORGANIZACIONAL');
        $first = 4;
        $sheet->setCellValue('A' . $first, 'GRUPO')
            ->setCellValue('B' . $first, 'SUBGRUPO')
            ->setCellValue('C' . $first, 'DESCRIPCIÓN')
            ->getStyle('A' . $first . ':C' . $first)->getFont()->setBold(true);
        $sharedStyle1->applyFromArray(
            array('fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array('argb' => 'FFFFFFFF')//FFCCFFCC
            ),
                'borders' => array(
                    'top' => array('style' => PHPExcel_Style_Border::BORDER_THIN),
                    'bottom' => array('style' => PHPExcel_Style_Border::BORDER_THIN),
                    'right' => array('style' => PHPExcel_Style_Border::BORDER_THIN)
                )
            ));
        $styleTitle = array(
            'font' => array(
                'bold' => true,
                'size' => 11,
                'name' => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleHeaderTable = array(
            'font' => array(
                'bold' => true,
                'color' => array(
                    'rgb' => 'ffffff'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '2B579A'
                )
            )
        );
        $ar = array();
        foreach ($datos as $record) {
            $ar[] = array($record['grupo'], $record['subgrupo'], $record['nombre_unidad']);
        }
        $sheet->fromArray($ar, null, 'A' . ($first + 1));
        $sheet->getColumnDimension('B')->setWidth(15);
        $sheet->getColumnDimension('C')->setWidth(70);
        $sheet->getStyle('A1:A2')->applyFromArray($styleTitle);
        $sheet->getStyle('A' . $first . ':C' . ($first))->applyFromArray($styleHeaderTable);
    }

    function generarReporte()
    {
        $this->docexcel->setActiveSheetIndex(0);
        $this->imprimeDatos();
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);
    }
}

?>