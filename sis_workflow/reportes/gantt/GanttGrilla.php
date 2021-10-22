<?php
/**
*@package pXP
*@file gen-Acm.php
*@author  (jrivera)
*@date 05-09-2018 20:34:32
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

include_once ('../../media/styles.php');
header("content-type: text/javascript; charset=UTF-8");
?>

<style>
.proceso_estado_wf_grilla {
    background-color: #65DA74;
		color: red;
}
.fin_proceso_wf {
    background-color: yellow;
}

</style>

<script>
Phx.vista.GanttGrilla=Ext.extend(Phx.gridInterfaz,{

	viewConfig: {
			//stripeRows: false,
			autoFill: false,
			getRowClass: function (record) {

					if (record.json.tipo == 'proceso') {
						return 'proceso_estado_wf_grilla';
					}
					if(/*(record.json.disparador == 'no' && record.json.estado_reg == 'activo') ||*/ record.json.tipo =='estado_final'){
	 			 		return 'fin_proceso_wf';
	 			 }
			},
			listener: {
					render: this.createTooltip
			},

	},

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.GanttGrilla.superclass.constructor.call(this,config);
		this.init();
    var that = this;
		this.iniciarEventos();

    this.store.baseParams.id_proceso_wf = that.id_proceso_wf;
		this.store.baseParams.orden = "grilla";


		this.load({params:{start:0, limit:this.tam_pag}})
	},



	Atributos:[

		{
			config:{
				name: 'nombre',
				fieldLabel: 'Estado Proceso',
				allowBlank: false,
				anchor: '100%',
				gwidth: 700,
				maxLength:10,
				renderer: function (value, p, record) {

					var prefijo = '';
					var desc_principal = '';

					if (record.json.tipo == 'estado' || record.json.tipo == 'obs' || record.json.tipo == 'estado_final') {
						prefijo = '';
					}

					if(record.json.tipo == 'obs'){
				  	desc_principal=(prefijo+'  -> OBS: '+record.json.nombre);
				  }
				  else{
				  	desc_principal=(prefijo+record.json.nombre);
				  }


					if (record.json.etapa != '' && record.json.etapa != null) {
						desc_principal = ' '+record.json.etapa+' <b style="color:#001095">['+desc_principal+']</b>';
					}

					if (record.json.tipo == 'proceso') {
						desc_principal = desc_principal+"\n"+record.json.descripcion;
					}

					if(record.json.nombre_usuario_ai != '' && record.json.nombre_usuario_ai != 'NULL'){
							desc_principal = desc_principal+' <b>(por AI: '+record.json.nombre_usuario_ai+')</b>' ;
					}
					else if(record.json.cuenta !='' && record.json.cuenta != null){
						 desc_principal = desc_principal+' <b>(por: '+record.json.cuenta+')</b>' ;
					}

					if((record.json.disparador == 'no' && record.json.estado_reg == 'activo') || record.json.tipo =='estado_final'){
	 			 		desc_principal = '<b style="color:red;">'+desc_principal+'</b>';
	 			 }


					if (record.json.tipo == 'proceso') {
						return '<b style="font-size:14px;">'+desc_principal+'</b>'
					} else {

						//if (record.json.descripcion != '') {
						//	return '<span style="font-size:12px; margin-left: 20px;">-'+desc_principal+'</span><br><table style="margin-left:35px;"><tbody><tr><td><b>OBSERVACIONES:</b></td></tr><tr><td style="padding-left:15px;"><b>*</b> '+record.json.descripcion+'</td></tr></tbody></table>';
						//} else {
							return '<span style="font-size:12px; margin-left: 20px;">-'+desc_principal+'</span>';
					//	}


					}

				}
			},
				type:'TextField',
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},
    {
			config:{
				name: 'funcionario',
				fieldLabel: 'Responsable',
				allowBlank: false,
				anchor: '100%',
				gwidth: 250,
				maxLength:10,
				renderer: function (value, p, record) {
					var responsable = '';
					  responsable = ((record.data.funcionario != '' && record.data.funcionario != null)?record.data.funcionario:record.json.depto);
						responsable = (responsable == '' || responsable == null)?record.json.cuenta:responsable;
					if (record.json.tipo != 'proceso') {
						return '<span style="text-transform:uppercase;">'+responsable+'</span>'
					}

				}
			},
				type:'TextField',
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},

    {
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: false,
				anchor: '100%',
				gwidth: 500,
				maxLength:10,
				renderer: function (value, p, record) {
					return '<table style="margin-left:35px;"><tbody><tr><td style="padding-left:15px;">'+record.json.descripcion+'</td></tr></tbody></table>';
				}
			},
				type:'TextField',
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},
    {
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Inicio',
				allowBlank: false,
				anchor: '100%',
				gwidth: 120,
        format: 'd/m/Y',
        renderer:function (value,p,record){
					if (record.json.tipo != 'proceso') {
						return value?value.dateFormat('d/m/Y H:i:s'):''
					}
				}
			},
				type:'DateField',
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},
    {
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: false,
				anchor: '100%',
				gwidth: 120,
        format: 'd/m/Y',
				renderer:function (value,p,record){
					if (record.json.tipo != 'proceso') {
						return (record.data.fecha_fin != null)?record.data.fecha_fin.dateFormat('d/m/Y H:i:s'):record.data.fecha_ini.dateFormat('d/m/Y H:i:s');

					}
				}
			},
				type:'DateField',
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},
    {
			config:{
				name: 'duracion',
				fieldLabel: 'Duración',
				allowBlank: false,
				anchor: '100%',
				gwidth: 100,
				maxLength:10,
				galign: 'right',
				renderer:function (value,p,record){
					if (record.json.tipo != 'proceso') {
						var fecha_inicial = new Date(record.data.fecha_ini);
						var fecha_final = new Date((record.data.fecha_fin != null)?record.data.fecha_fin:record.data.fecha_ini);

						var day_as_milliseconds = 86400000;

						var diferencia_fechas = fecha_final - fecha_inicial;

						var diferencia_calculada = (diferencia_fechas / 86400000).toFixed(0);

						console.log( diferencia_calculada );
						return diferencia_calculada + ' días';
					}
				}
			},
				type:'TextField',
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},
	],
	tam_pag:50,
	title:'Diagrama de Gantt',
	//ActSave:'../../sis_obingresos/control/Acm/insertarAcm',
	//ActDel:'../../sis_obingresos/control/Acm/eliminarAcm',
	ActList:'../../sis_workflow/control/ProcesoWf/diagramaGanttGrilla',
//id_store:'id_acm',
	fields: [
    {name:'nombre', type: 'string'},
    {name:'fecha_ini', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
    {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'funcionario', type: 'string'},


	],


	bdel:false,
	bsave:false,
    bnew:false,
    bedit:false,
    btest:false,
		bexcel:false,


	}
)
</script>
