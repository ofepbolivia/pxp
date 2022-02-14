<?php

class RDocumentosRHDXls
{
    private $docexcel;
    private $objWriter;
    private $nombre_archivo;
    private $hoja;
    private $columnas=array();
    private $fila;
    private $celdas=array();

    private $indice, $m_fila, $titulo;
    private $swEncabezado=0; //variable que define si ya se imprimi� el encabezado
    private $objParam;
    public  $url_archivo;

    var $datos_titulo;
    var $datos_detalle;
    var $ancho_hoja;
    var $gerencia;
    var $numeracion;
    var $ancho_sin_totales;
    var $cantidad_columnas_estaticas;
    var $s1;
    var $t1;
    var $tg1;
    var $total;
    var $datos_entidad;
    var $datos_periodo;
    var $ult_codigo_partida;
    var $ult_concepto;



    function __construct(CTParametro $objParam){
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

        $this->docexcel->setActiveSheetIndex(0);

        $this->docexcel->getActiveSheet()->setTitle($this->objParam->getParametro('titulo_archivo'));

        $this->celdas=array(0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
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

    function imprimeDatos(){

        $header = $this->objParam->getParametro('headers');
        $headers = json_decode($header[0]['headers']);
        $datos = $this->objParam->getParametro('datos');

        //var_dump($datos);exit;

        $columnas = 0;

        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array('rgb' => '4682b4')
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );

        $styleVacio = array(

            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'FA8072'
                )
            )
        );


        $this->docexcel->getActiveSheet()->mergeCells('A1:A2');
        $this->docexcel->getActiveSheet()->mergeCells('B1:B2');
        $this->docexcel->getActiveSheet()->mergeCells('C1:C2');
        $this->docexcel->getActiveSheet()->mergeCells('D1:D2');
        $this->docexcel->getActiveSheet()->mergeCells('E1:E2');
        $this->docexcel->getActiveSheet()->mergeCells('F1:F2');
        $this->docexcel->getActiveSheet()->mergeCells('G1:G2');

        /*************************************Cabecera*****************************************/
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[0])->setWidth(7);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'Nro');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[1])->setWidth(40);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,1,'GERENCIA');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[2])->setWidth(40);

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,1,'REGIONAL');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[2])->setWidth(20);

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,1,'NOMBRE Y APELLIDO');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[3])->setWidth(30);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,1,'CI');

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'CARGO');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[3])->setWidth(30);

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,1,'FECHA NACIMIENTO');
        $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[3])->setWidth(30);

        $column = 6;
        $headers_size = 0;
        $codigo = '';
        $inicio = 5;
        $fin = 5;
        $column_count = 0;
        $headers_range = array();

        foreach ($headers as $value){
            foreach ($value as $val){

                $column +=1 ;
                $headers_size = count($val->campos);

                if($headers_size == 1){
                    $inicio = $column; $fin = $column;
                }else{
                    $inicio = $column; $fin = $column + ($headers_size-1);
                }

                $headers_range[$val->codigo] = array("inicio" => $inicio, "fin" => $fin);

                $this->docexcel->getActiveSheet()->mergeCells($this->celdas[$inicio] . '1:' . $this->celdas[$fin] . '1');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($column, 1, $val->nombre);

                foreach( $val->campos as $clave ){
                    $clave_decode = json_decode($clave);//var_dump($clave_decode);
                    $this->docexcel->getActiveSheet()->getColumnDimension($this->celdas[$column])->setWidth(20);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($column, 2, $clave_decode->clave);
                    if ($headers_size > 1 and $column < $fin) {
                        $column +=1;
                    }
                }
                $codigo = $val->codigo;
            }
        }
        $this->docexcel->getActiveSheet()->getStyle('A1:'.$this->celdas[$column].'2')->applyFromArray($styleTitulos);
        $range_end = $this->celdas[$column];
        /*************************************Fin Cabecera*****************************************/

        $fila = 3;
        $contador = 1;
        $tamano = count($datos)+2;
        $this->docexcel->getActiveSheet()->freezePaneByColumnAndRow(0,3);

        $column = 7;
        $codigo = '';
        $duplicado = '';
        /***********************************Detalle***********************************************/

        foreach($datos as $value) {

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,$contador);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,$value['gerencia']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$value['lugar']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$value['desc_funcionario']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila,$value['ci']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila,$value['cargo']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila,DateTime::createFromFormat('Y-m-d', $value['fecha_nacimiento'])->format('d/m/Y'));

            $file_content = json_decode($value['documento'])->files;

            if ($file_content != null ) {
                foreach ($headers_range as $code => $range) { //Cabeceras
                    foreach ($file_content as $files) {//campos documento
                        if ($files->codigo == $code) {

                            $column = $range['inicio'];
                            if($files->campos != null) {
                                $duplicado = '';
                                foreach ($files->campos as $campo) {//columnas

                                    $valor = json_decode($campo);
                                    $valor = $valor->valor;

                                    if ($this->checkDate(substr($valor, 0, 10))) {
                                        $valor = date_format(date_create($valor), 'd/m/Y');
                                    }

                                    if($valor == $duplicado && $duplicado!=''){
                                        continue;
                                    }

                                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($column, $fila, $valor);
                                    $column += 1;

                                    $duplicado = $valor;
                                }
                            }else{
                                continue;
                            }

                        } else {
                            for ($i = $column; $i <= $range['fin']; $i++) {//columnas
                                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($column, $fila, "sin registrar");
                                $column += 1;
                            }
                        }
                        $codigo = $files->codigo;
                    }
                }
                $fila++;
                $contador++;
            }else{
                $this->docexcel->getActiveSheet()->getStyle("A$fila:".$range_end."$fila")->applyFromArray($styleVacio);
                $fila++;
                $contador++;
                continue;
            }
        }
        /************************************************Fin Detalle***********************************************/
    }

    public function addHoja($name,$index){
        $this->docexcel->createSheet($index)->setTitle($name);
        $this->docexcel->setActiveSheetIndex($index);
        return $this->docexcel;
    }

    function checkDate($date) {
        if (date('Y-m-d', strtotime($date)) == $date) {
            return true;
        } else {
            return false;
        }
    }


    function generarReporte(){

        $this->imprimeDatos();

        //echo $this->nombre_archivo; exit;
        // Set active sheet index to the first sheet, so Excel opens this as the first sheet
        $this->docexcel->setActiveSheetIndex(0);
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);


    }


}

?>