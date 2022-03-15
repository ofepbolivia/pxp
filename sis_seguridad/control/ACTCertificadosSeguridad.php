<?php
/**
*@package pXP
*@file gen-ACTCertificadosSeguridad.php
*@author  (breydi.vasquez)
*@date 03-11-2021 15:36:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');

class ACTCertificadosSeguridad extends ACTbase{    
			
	function listarCertificadosSeguridad(){
		$this->objParam->defecto('ordenacion','id_certificado_seguridad');

		$this->objParam->defecto('dir_ordenacion','asc');

		// Filtros		
		$this->objParam->getParametro('cers_estado') != '' && $this->objParam->addFiltro("cers.estado = ''". $this->objParam->getParametro('cers_estado')."''");


		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCertificadosSeguridad','listarCertificadosSeguridad');
		} else{
			$this->objFunc=$this->create('MODCertificadosSeguridad');
			
			$this->res=$this->objFunc->listarCertificadosSeguridad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarCertificadosSeguridad(){
		$this->objFunc=$this->create('MODCertificadosSeguridad');	
		if($this->objParam->insertar('id_certificado_seguridad')){
			$this->res=$this->objFunc->insertarCertificadosSeguridad($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarCertificadosSeguridad($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarCertificadosSeguridad(){
		$this->objFunc=$this->create('MODCertificadosSeguridad');	
		$this->res=$this->objFunc->eliminarCertificadosSeguridad($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function enviarNotificacionCertificados(){

		//obtiene direcciones de envio
		$this->objFunc=$this->create('MODCertificadosSeguridad');
		$this->res=$this->objFunc->obtenerDatosCertificados($this->objParam);

		$json = $this->res->getDatos();
		$json = json_decode($json[0]['jsondata']);
		// var_dump($json->data);exit;
		if ($json->data != null) {
			
			foreach ($json->data as $value) {

				$data_mail = '';
				$data_mail.= '<!DOCTYPE html>'.
				'<html lang="en">'.
				'<head>'.
				'<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'.
				'<meta name="viewport" content="width=device-width">'.
				'</head>'.
				'<body>'.
					'<div id="email" style="width:600px;margin: auto;background:white;">'.
						'<table role="presentation" border="0" width="100%">'.
							'<tr>'.
								'<td bgcolor="#EAF0F6" align="justify" style="padding: 30px 30px;">'.
								'<b>Estimad@ </b> '.$value->desc_funcionario.'<br><br>'.				
								'Le informamos que el certificado de seguridad con nro de serie: <b>'.$value->nro_serie.'</b> se encuentra a <span style="color:red;font-weight:bold;">'.$value->dias_anticipacion_alerta.'</span> dias de su vencimiento. '.
								'A continuacion se detalla la informacion del certificado :<br><br>'.
								'<table border="0"  cellspacing="15" style="text-align: justify;">'.
								'<tr>'.
								'<th align="left">Titular Certificado:</th>'.
								'<td>'.$value->titular_certificado.'</td>'.
								'<th align="left">IP Servidor:</th>'.
								'<td>'.$value->ip_servidor.'</td>'.
								'</tr>'.						  
								'<tr>'.
								'<th align="left">Entidad Certificadora:</th>'.
								'<td>'.$value->entidad_certificadora.'</td>'.
								'<th align="left">Fecha emision:</th>'.
								'<td>'.$value->fecha_emision.'</td>'.
								'</tr>'.						  
								'<tr>'.
								'<th align="left">Tipo certificado:</th>'.
								'<td>'.$value->tipo_certificado.'</td>'.
								'<th align="left">Fecha vencimiento:</th>'.
								'<td>'.$value->fecha_vencimiento.'</td>'.
								'</tr>'.
								'<tr>'.
								'<th align="left">Observaciones:</th>'.
								'<td colspan=3>'.$value->observaciones.'</td>'.
								'</tr>'.
								'</table>'.								
								'Favor tomar en nota.<br>'.
								'-------------------------------------<br><br>'.                
								'</td>'.
								'</tr>'.
							'</table>'.     
						'</div>'.
					  '</body>'.
				'</html>';

				$correo=new CorreoExterno();				
				$correo->addDestinatario($value->email_resp);

				if(!empty($value->email_cc)){
					foreach ($value->email_cc as $email) {						
						$correo->addCC($email);
					}					
				}				
				//asunto
				$correo->setAsunto('Notificacion de Vencimiento Certificado de Seguridad');
				//cuerpo mensaje
				$correo->setMensaje($data_mail);
				$correo->setTitulo('Notificacion de Vencimiento Certificado de Seguridad');
				$correo->setDefaultPlantilla();				
				$resp=$correo->enviarCorreo();
				
		   		if($resp=='OK'){			   
					$this->objParam->addParametro('notificado', 'si');
					$this->objParam->addParametro('id_certificado_seguridad', $value->id_certificado_seguridad);
					$this->objFunc1=$this->create('MODCertificadosSeguridad');					
					$this->resOk=$this->objFunc1->actuEstadoNotificacion($this->objParam);
				}
			}
			echo 'notificaciones enviadas';exit;
		}else {
			echo 'notificacion sin informacion para enviar';exit;
		}
   }	

   function siguienteEstado() {
	   $this->objFunc=$this->create('MODCertificadosSeguridad');
	   $this->res=$this->objFunc->siguienteEstado($this->objParam);
	   $this->res->imprimirRespuesta($this->res->generarJson());
   }

   function anteriorEstado() {
	   $this->objFunc=$this->create('MODCertificadosSeguridad');
	   $this->res=$this->objFunc->anteriorEstado($this->objParam);
	   $this->res->imprimirRespuesta($this->res->generarJson());
   }
			
}

?>