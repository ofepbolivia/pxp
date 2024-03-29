<?php
class RInformacionRapidaRRHHXls{
    private $docexcel;
    private $objWriter;
    private $numero;
    private $equivalencias=array();
    private $objParam;
    var $datos_detalle;
    var $datos_titulo;
    public  $url_archivo;
    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        //ini_set('memory_limit','512M');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");


        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
            9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
            18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
            26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
            34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
            42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
            50=>'AY',51=>'AZ',
            52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
            60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
            68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
            76=>'BY',77=>'BZ');

    }

    public function addHoja($name,$index){
        //$index = $this->docexcel->getSheetCount();
        //echo($index);
        $this->docexcel->createSheet($index)->setTitle($name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function imprimeCabecera() {

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(30);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(25);

        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(25);

        $this->docexcel->getActiveSheet()->setCellValue('A1','Nro');
        $this->docexcel->getActiveSheet()->setCellValue('B1','NOMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('C1','CI');
        $this->docexcel->getActiveSheet()->setCellValue('D1','FECHA DE NAC.');

        $this->docexcel->getActiveSheet()->setCellValue('E1','GERENCIA');
        $this->docexcel->getActiveSheet()->setCellValue('F1','OFICINA');
        $this->docexcel->getActiveSheet()->setCellValue('G1','LUGAR');
        $this->docexcel->getActiveSheet()->setCellValue('H1','SEXO');

        $this->docexcel->getActiveSheet()->setCellValue('I1','CARGO');
        $this->docexcel->getActiveSheet()->setCellValue('J1','FECHA DE ING.');
        $this->docexcel->getActiveSheet()->setCellValue('K1','CELULAR/TELEFONO');

        $this->docexcel->getActiveSheet()->setCellValue('L1','CUA/NUA');
        $this->docexcel->getActiveSheet()->setCellValue('M1','AFP');
        $this->docexcel->getActiveSheet()->setCellValue('N1','PROFESION');
        $this->docexcel->getActiveSheet()->setCellValue('O1','CONTRATO');
        $this->docexcel->getActiveSheet()->setCellValue('P1','HABER BASICO');
        $this->docexcel->getActiveSheet()->setCellValue('Q1','LICENCIA');
        $this->docexcel->getActiveSheet()->setCellValue('R1','NRO. CUENTA');

    }

    function generarDatos(){
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );

        $styleTitulos2 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '0066CC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '626eba'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )

            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '3287c1'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ));

        $index = 0;
        $this->addHoja('Inf. General',$index);

        $numero = 1;
        $fila = 2;
        $datos = $this->objParam->getParametro('datos');//var_dump($datos);exit;
        //subtotales
        $estacion = '';
        $contadorCostoGrupo = 0;
        $contadorCostoTotal = 0;
        $this->imprimeCabecera();

        //$numberFormat = '#,#0.##;[Red]-#,#0.##';
        $numberFormat = '#,##0.00';
        $cant_datos = count($datos);
        $cont_total = 1;
        $fila_total = 1;



        $color_pestana = array('ff0000','1100ff','55ff00','3ba3ff','ff4747','697dff','78edff','ba8cff',
            'ff80bb','ff792b','ffff5e','52ff97','bae3ff','ffaf9c','bfffc6','b370ff','ffa8b4','7583ff','9aff17','ff30c8');
        $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,2);
        $this->docexcel->getActiveSheet()->getStyle('A1:R1')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A1:R1')->applyFromArray($styleTitulos3);
        $profesion = null;
        $contrato = null;
        foreach ($datos as $value) {

            $profesion = json_decode($value['profesion'])->files;
            if( $profesion == null){
                $profesion = 'sin registrar';
            }else{
                $profesion = $profesion[0]->campos;
                $profesion = json_decode(trim($profesion[2],'"'))->valor;
            }

            $contrato = json_decode($value['contrato'])->files;
            if( $contrato == null){
                $contrato = 'sin registrar';
            }else{
                $contrato = $contrato[0]->campos;
                $contrato = json_decode(trim($contrato[0],'"'))->valor;
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $numero);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['funcionario']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['ci']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, date_format(date_create($value['fecha_nacimiento']), 'd/m/Y'));

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['gerencia']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['nombre_oficina']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['nombre_lugar']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['genero']);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['cargo']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, date_format(date_create($value['fecha_ingreso']), 'd/m/Y'));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['telefonos']);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['afp']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['institucion']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $profesion);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $fila, $contrato);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, number_format($value['haber_basico'],2));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16, $fila, $value['licencia']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17, $fila, (string)$value['nro_cuenta']);

            $fila++;
            $numero++;
        }

        $index++;
        /*PAGOS QUE NO ESTAN EN ATC*/
        $this->addHoja('Inf. Específica',$index);
        $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,2);
        $this->docexcel->getActiveSheet()->getStyle('A1:G1')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A1:G1')->applyFromArray($styleTitulos3);

        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);

        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);


        $this->docexcel->getActiveSheet()->setCellValue('A1','Nro');
        $this->docexcel->getActiveSheet()->setCellValue('B1','Apellido Paterno');
        $this->docexcel->getActiveSheet()->setCellValue('C1','Apellido Materno');
        $this->docexcel->getActiveSheet()->setCellValue('D1','Nombre');
        $this->docexcel->getActiveSheet()->setCellValue('E1','Teléfono Oficina');
        $this->docexcel->getActiveSheet()->setCellValue('F1','Correo Institucional');
        $this->docexcel->getActiveSheet()->setCellValue('G1','Correo Personal');

        $numero = 1;
        $fila = 2;
        foreach ($datos as $value) {

            if( $value['correo_personal'] == null || $value['correo_personal'] == ''){
                $correo_personal = 'No Tiene';
            }else{
                $correo_personal = $value['correo_personal'];
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $numero);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['apellido_paterno']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['apellido_materno']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['nombre']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['telefono_oficina']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['correo_institucional']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $correo_personal);

            $fila++;
            $numero++;
        }

    }

    function obtenerFechaEnLetra($fecha){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $dia= date("d", strtotime($fecha));
        $anno = date("Y", strtotime($fecha));
        // var_dump()
        $mes = array('Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre');
        $mes = $mes[(date('m', strtotime($fecha))*1)-1];
        return $dia.' de '.$mes.' del '.$anno;
    }
    function generarReporte(){
        $this->generarDatos();
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>