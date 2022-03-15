<?php
class REtramitesAprobados extends  ReportePDF{
    var $datos ;
    var $ancho_hoja;
    var $gerencia;
    var $numeracion;
    var $ancho_sin_totales;
    var $cantidad_columnas_estaticas;
        var $codigo;

    function Header() {
        $this->Ln(3);        
        $this->SetMargins(3, 53, 5,false);        
		$fecha_ini = $this->objParam->getParametro('fecha_ini');
        $fecha_fin = $this->objParam->getParametro('fecha_fin');
        $codigo_sistema = $this->objParam->getParametro('sistema_rep');
        $funcionario_aprobador = $this->objParam->getParametro('funcionario_repo');        
        $cont = explode(",", $codigo_sistema);  
        $array_sistemas = array 
        (
            "todos" => "Todos",
            "v_org" => "Organigrama", 
            "v_adq" => "Adquiciciones", 
            "v_obl" => "Obligaciones De Pago", 
            "v_alm" => "Almacenes", 
            "v_kaf" => "Activos Fijos",
            "v_ctr" => "Contratos", 
            "v_pls" => "Planilla De Sueldos",
            "v_fea" => "Fondos En Avance",
            "v_prs" => "Presupuestos", 
            "v_sdc" => "Sistema De Contabilidad", 
            "v_gro" => "Gestion De Reclamos Odeco",
            "v_gsm" => "Gestion Materiales"
        );
        $sistema = '[';
        foreach ($array_sistemas as $key => $value) {            
            if (in_array($key , $cont)) {
                $sistema = $sistema.$value.', ';
            }
        }  
                
        $sistema = substr($sistema, 0, -2);                          
        $sistema = $sistema.']';                 

        (count($cont) > 1)?$titulo_sistema='<span style="color:black;">SISTEMAS: </span>'.$sistema: $titulo_sistema='<span style="color:black;">SISTEMA: </span>'.$sistema;
        //cabecera del reporte
        $this->Image(dirname(__FILE__).'/../../lib/imagenes/logos/logo.jpg', 16,5,40,20);
        $this->ln(5);        
        $this->SetFont('','B', 20);
        $this->SetTextColor(43,	67,	100);
        $this->Cell(0,5,"\t\t\t"."TRÁMITES APROBADOS POR FUNCIONARIO",0,1,'C');        
        $this->SetFont('','B', 11);
        $this->Cell(0,5,"DEL: ".$fecha_ini."                       AL: ".$fecha_fin, 0,1,'C');
        $this->Ln(4);  
        
        $tbl = '<table border="0" style="font-size: 10pt;"> 
                <tr>
                    <td width="100%"><span style="color:black;">FUNCIONARIO: </span>'.$funcionario_aprobador.'</td>                    
                </tr>
                <tr>                    
                    <td width="100%" height="35px">'.$titulo_sistema.'</td>
                </tr>
                </table>
                ';
        
        $this->writeHTML ($tbl); 
        $this->Ln(-1);        
        $this->generarCabecera();        

    }
    function generarCabecera(){
        
        $this->SetFont('','B',9);     
        $this->tablewidthsHD=array(8,42,30,34,50,34,34,25,15);
        $this->tablealignsHD=array('C','C','C','C','C','C','C','C','C');
        $this->tablenumbersHD=array(0,0,0,0,0,0,0,0,0);
        $this->tablebordersHD=array('TBL','TBL','TBL','TBL','TBL','TBL','TBL','TBL','TBLR');
        $this->tabletextcolorHD=array();
        //array(219, 163, 63),array(219, 163, 63),array(219, 163, 63),array(219, 163, 63),array(219, 163, 63)
        //,array(219, 163, 63),array(219, 163, 63),array(219, 163, 63));         
        $RowArray = array(
                        's0' => 'N°',
                        's1' => 'TRAMITE',
                        's2' => 'FECHA',   
                        's3' => 'SOLICITANTE',        
                        's4' => 'JUSTIFICACIÓN',
                        's5' => 'PROVEEDOR',            
                        's6' => 'PROVEIDO',            
                        's7' => 'IMPORTE',
                        's8' => 'MONEDA');
                                 
         $this->MultiRowHeader($RowArray,false,1);
    }

    function setDatos($datos) {
        $this->datos = $datos;    
        //var_dump($this->datos);exit;                         
    }
    function generarReporte() {
        
        $this->AddPage();        
        $this->SetMargins(3, 0, 5,false);
        $this->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);        
        $this->Ln(-0.05);
        $indice = 1;
        
        foreach( $this->datos as $record){            
            
            $this->SetFont('','',6);
            $this->tableborders=array('LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB','LRTB');
            $this->tablewidths=array(8,42,30,34,50,34,34,25,15);
            $this->tablealigns=array('L','L','L','L','L', 'L','L','R','C');
            $this->tablenumbers=array(0,0,0,0,0,0,0,0,0);
            $veces_repetido_estado =  ($record['contador_estados'] > 1)?"  Repetido: ".$record['contador_estados']:'';
            $RowArray = array(
                       's0' => $indice,
                       's1' =>  $record["nro_tramite"]."  ".$veces_repetido_estado."\n".'EstadoAnt: '. $record["anterior_estado"]."\n"."EstadoSig: ".$record['seguiente_estado'],
                       's2' => "\n".'Inicio:  '.date("d/m/Y H:i:s", strtotime($record["fecha_ini"])). "\n". 'Fin: '."\t\t\t\t".date("d/m/Y H:i:s", strtotime($record["fecha_fin"])),
                       's3' => $record['solicitante'],
                       's4' => $record['justificacion'],
                       's5' => $record['proveedor'],
                       's6' => $record['proveido'],
                       's7' => "\n".number_format($record['importe'], 2, ",", "."),
                       's8' => "\n".$record['moneda']
                        );
            $this-> MultiRow($RowArray,false,1);
            $indice = $indice + 1;                        
        } 

    }

}
?>
