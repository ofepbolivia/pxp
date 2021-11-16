<?php
/**
*@package pXP
*@file gen-CertificadosSeguridad.php
*@author  (breydi.vasquez)
*@date 03-11-2021 15:36:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<style>
.no_enviado {	    
    background-color: #F7DC6F;
    color: #090;
}
.enviado {
    background-color: #bdffb2;
	color: #090;
}
</style>
<script>
Phx.vista.CertificadosSeguridad=Ext.extend(Phx.gridInterfaz,{

	viewConfig: {
			// stripeRows: false,
			// autoFill: true,
            getRowClass: function (record) {

				if (record.data.estado_notificacion == 'no_enviado') {
					return 'no_enviado';
				} else if (record.data.estado_notificacion == 'enviado') {
	 			 	return 'enviado';
	 			 }
			}
	},

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CertificadosSeguridad.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos()
		this.store.baseParams.cers_estado = 'borrador';
		this.load({params:{start:0, limit:this.tam_pag}})

		// buttons
		this.addButton('ant_estado',{
			grupo: [1],
			argument: {estado: 'anterior'},
			text: 'Anterior',
			iconCls: 'batras',
			disabled: true,
			handler: this.antEstado,
			tooltip: '<b>Volver al Anterior Estado</b>'
		});

		this.addButton('sig_estado',{
			grupo: [0,1],
			text:'Siguiente',
			iconCls: 'badelante',
			disabled:true,
			handler:this.sigEstado,
			tooltip: '<b>Pasar al Siguiente Estado</b>'
		});

		this.addButton('btnChequeoDocumentosWf',{
			text: 'Documentos',
			grupo: [0,1,2],
			iconCls: 'bchecklist',
			disabled: true,
			handler: this.loadCheckDocumentosRecWf,
			tooltip: '<b>Documentos del Reclamo</b><br/>Subir los documetos requeridos en el Reclamo seleccionado.'
		});
		this.addButton('diagrama_gantt',{
			grupo:[0,1,2],
			text:'Gant',
			iconCls: 'bgantt',
			disabled:true,
			handler: this.diagramGantt,
			tooltip: '<b>Diagrama Gantt de proceso macro</b>'
		});				

		this.getBoton('ant_estado').setVisible(false)
		this.finCons=true      
	},
			
	gruposBarraTareas:[
            {name:'borrador',title:'<H1 align="center"><i class="fa fa-list-ul"></i> Borrador</h1>',grupo:0,height:0},
            {name:'pendiente',title:'<H1 align="center"><i class="fa fa-list-ul"></i> Pendiente Aprobacion</h1>',grupo:1,height:0, width: 450},
            {name:'finalizado',title:'<H1 align="center"><i class="fa fa-list-ul"></i> Finalizado</h1>',grupo:2,height:0}
    ],			

	actualizarSegunTab: function(name, indice){		
		if (this.finCons) {			
			this.store.baseParams.cers_estado = name
			if (name == 'pendiente') {
				this.getBoton('ant_estado').setVisible(true)
			} else {
				this.getBoton('ant_estado').setVisible(false)
			}
			this.load({params:{start:0, limit:this.tam_pag}})
		}
	},

	beditGroups: [0],
	bdelGroups:  [0],
	bactGroups:  [0,1,2],
	bexcelGroups: [0,1,2],		

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_certificado_seguridad'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'estado_notificacion',
				fieldLabel: 'Estado Notificacion.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 110,
				renderer: function (value, p, record) {
					if (record.data['estado_notificacion'] == 'enviado')
						return '<b>ENVIADO</b>'
					else
						return '<b>NO ENVIADO</b>';
				},
			},
				type:'TextField',
				filters:{pfiltro:'cers.estado_notificacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false,
				bottom_filter:true
		},		
        {
            config:{
                name: 'id_titular_certificado',
                fieldLabel: 'Titular Certificado',
                allowBlank: false,
                
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/Catalogo/listadoCatalogoCodigo',
                            id : 'id_catalogo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'descripcion',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_catalogo','codigo', 'descripcion'],
                            remoteSort: true,
                            baseParams:{par_filtro:'descripcion',codigo:'titular_certificado'}
                }),
               valueField: 'id_catalogo',
               displayField: 'descripcion',
               gdisplayField: 'titular_certificado',
               hiddenName: 'id_catalogo',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               tpl:'<tpl for="."><div class="x-combo-list-item"><span style="color:green;font-weight:bold;">{descripcion}</span></div></tpl>',
               listWidth:300,
               resizable:true,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               anchor:'60%',
               gwidth:100,
               minChars:1			   

            },
            type:'ComboBox',
            id_grupo:1,
            form:true,
            grid:true
        },		
		// {
		// 	config:{
		// 		name: 'titular_certificado',
		// 		fieldLabel: 'Titular Certificado',
		// 		allowBlank: false,
		// 		anchor: '60%',
		// 		gwidth: 100
		// 	},
		// 		type:'TextField',
		// 		filters:{pfiltro:'cers.titular_certificado',type:'string'},
		// 		id_grupo:1,
		// 		grid:true,
		// 		form:true
		// },
        {
            config:{
                name: 'id_entidad_certificadora',
                fieldLabel: 'Entidad Certificadora',
                allowBlank: false,
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/Catalogo/listadoCatalogoCodigo',
                            id : 'id_catalogo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'descripcion',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_catalogo','codigo', 'descripcion'],
                            remoteSort: true,
                            baseParams:{par_filtro:'descripcion',codigo:'entidad_certificado'}
                }),
               valueField: 'id_catalogo',
               displayField: 'descripcion',
               gdisplayField: 'entidad_certificadora',
               hiddenName: 'id_catalogo',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               tpl:'<tpl for="."><div class="x-combo-list-item"><span style="color:green;font-weight:bold;">{descripcion}</span></div></tpl>',
               listWidth:300,
               resizable:true,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               anchor:'60%',
               gwidth:100,
               minChars:1			   

            },
            type:'ComboBox',
            id_grupo:1,
            form:true,
            grid:true
        },		
		// {
		// 	config:{
		// 		name: 'entidad_certificadora',
		// 		fieldLabel: 'Entidad Certificadora',
		// 		allowBlank: false,
		// 		anchor: '60%',
		// 		gwidth: 120
		// 	},
		// 		type:'TextField',
		// 		filters:{pfiltro:'cers.entidad_certificadora',type:'string'},
		// 		id_grupo:1,
		// 		grid:true,
		// 		form:true
		// },
		{
			config:{
				name: 'nro_serie',
				fieldLabel: 'N° Serie',
				allowBlank: true,
				anchor: '60%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'cers.nro_serie',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter:true
		},
		{
			config:{
				name: 'fecha_emision',
				fieldLabel: 'Fecha Emision',
				allowBlank: false,
				anchor: '30%',
				gwidth: 120,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cers.fecha_emision',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_vencimiento',
				fieldLabel: 'Fecha Vencimiento',
				allowBlank: false,
				anchor: '30%',
				gwidth: 120,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cers.fecha_vencimiento',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'notificacion_vencimiento',
				fieldLabel: 'Notificacion Vencimiento',
				allowBlank: true,
				anchor: '30%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cers.notificacion_vencimiento',type:'date'},
				id_grupo:1,
				grid:false,
				form:false
		},		
        {
            config:{
                name: 'id_tipo_certificado',
                fieldLabel: 'Tipo Certificado',
                allowBlank: false,                
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/Catalogo/listadoCatalogoCodigo',
                            id : 'id_catalogo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'descripcion',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_catalogo','codigo', 'descripcion'],
                            remoteSort: true,
                            baseParams:{par_filtro:'descripcion',codigo:'tipo_certificado'}
                }),
               valueField: 'id_catalogo',
               displayField: 'descripcion',
               gdisplayField: 'tipo_certificado',
               hiddenName: 'id_catalogo',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               tpl:'<tpl for="."><div class="x-combo-list-item"><span style="color:green;font-weight:bold;">{descripcion}</span></div></tpl>',
               listWidth:300,
               resizable:true,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               anchor:'60%',
               gwidth:100,
               minChars:1			   

            },
            type:'ComboBox',
            id_grupo:1,
            form:true,
            grid:true
        },		
		// {
		// 	config:{
		// 		name: 'tipo_certificado',
		// 		fieldLabel: 'Tipo Certificado',
		// 		allowBlank: true,
		// 		anchor: '60%',
		// 		gwidth: 100,
		// 		maxLength:50
		// 	},
		// 		type:'TextField',
		// 		filters:{pfiltro:'cers.tipo_certificado',type:'string'},
		// 		id_grupo:1,
		// 		grid:true,
		// 		form:true,
		// 		bottom_filter:true
		// },
		{
			config:{
				name: 'clave_publica',
				fieldLabel: 'Clave Publica',
				allowBlank: true,
				anchor: '60%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'cers.clave_publica',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'ip_servidor',
				fieldLabel: 'IP Servidor',
				allowBlank: true,
				anchor: '60%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'cers.ip_servidor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter:true
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '60%',
				gwidth: 160
			},
				type:'TextArea',
				filters:{pfiltro:'cers.observaciones',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter:true
		},
		{
			config:{
				name: 'area_de_uso',
				fieldLabel: 'Area De Uso',
				allowBlank: true,
				anchor: '60%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'cers.area_de_uso',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
				bottom_filter:true
		},
		{
			config:{
				name: 'dias_anticipacion_alerta',
				fieldLabel: 'Dias Anticipacion Alerta',
				allowBlank: true,
				anchor: '60%',
				gwidth: 100,
			},
				type:'NumberField',
				filters:{pfiltro:'cers.dias_anticipacion_alerta',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
            config:{
                name:'id_funcionario_resp',
                origen:'FUNCIONARIO',
                tinit: false,
                qtip: 'Funcionario responsable  de certificados de seguridad.',
                fieldLabel:'Funcionario Resp.',
                allowBlank: false,
                gwidth: 200,
                valueField: 'id_funcionario',
                gdisplayField:'desc_funcionario',//mapea al store del grid
                anchor: '60%',
                gwidth: 200,
				listWidth:'350',
                baseParams: {estado_func:'todos'},
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
             },
            type:'ComboRec',
            id_grupo:0,
            filters:{
                pfiltro:'FUN.desc_funcionario1::varchar',
                type:'string'
            },

            grid:true,
            form:true,
			bottom_filter:true
        },		
        {
			config: {
				name: 'id_funcionario_cc',
				fieldLabel: 'Con Copia a',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_organigrama/control/Funcionario/listarFuncionarioCargo',
					id: 'id_funcionario',
					root: 'datos',
					sortInfo: {
						field: 'desc_funcionario1',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_funcionario','desc_funcionario1','email_empresa'],
					remoteSort: true,
					baseParams: {par_filtro: 'FUNCAR.desc_funcionario1'}
				}),
				valueField: 'id_funcionario',
				displayField: 'desc_funcionario1',
				gdisplayField: 'desc_funcionario1',
				tpl:'<tpl for="."><div class="x-combo-list-item"><div class="awesomecombo-item {checked}"><p><b>{desc_funcionario1}</b></p></div><p><b>Email: </b> <span style="color: green;">{email_empresa}</span></p></div></tpl>',
				hiddenName: 'id_funcionario',
				forceSelection:true,
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				gwidth:260,
				minChars:2,
				anchor:'60%',
				listWidth:'350',
				enableMultiSelect:true,
				renderer:function(value, p, record){
					return '<div><p><b>'+record.data['email_cc'].replace(/,/g,", ")+'</b></p>'+
                                '<p><p></div>';
				}
			},
			type: 'AwesomeCombo',
			id_grupo:0,
			grid: true,
			form: true
        },				
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu1.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},		
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cers.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
				type:'TextField',
				filters:{pfiltro:'cers.estado_reg',type:'string'},
				id_grupo:1,
				grid:false,
				form:false
		},		
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'cers.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'cers.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'cers.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,
	fheight:'75%',
	title:'Certificados Seguridad',
	ActSave:'../../sis_seguridad/control/CertificadosSeguridad/insertarCertificadosSeguridad',
	ActDel:'../../sis_seguridad/control/CertificadosSeguridad/eliminarCertificadosSeguridad',
	ActList:'../../sis_seguridad/control/CertificadosSeguridad/listarCertificadosSeguridad',
	id_store:'id_certificado_seguridad',
	fields: [
		{name:'id_certificado_seguridad', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'titular_certificado', type: 'string'},
		{name:'entidad_certificadora', type: 'string'},
		{name:'nro_serie', type: 'string'},
		{name:'fecha_emision', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_vencimiento', type: 'date',dateFormat:'Y-m-d'},
		{name:'tipo_certificado', type: 'string'},
		{name:'clave_publica', type: 'string'},
		{name:'ip_servidor', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'notificacion_vencimiento', type: 'date',dateFormat:'Y-m-d'},
		{name:'area_de_uso', type: 'string'},
		{name:'dias_anticipacion_alerta', type: 'numeric'},
		{name:'id_funcionario_resp', type: 'numeric'},
		{name:'desc_funcionario', type: 'string'},		
		{name:'id_funcionario_cc', type: 'string'},
		{name:'email_cc', type:'string'},
		{name:'estado_notificacion', type:'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_titular_certificado', type: 'numeric'},
		{name:'id_entidad_certificadora', type: 'numeric'},
		{name:'id_tipo_certificado', type: 'numeric'},
		
	],
	sortInfo:{
		field: 'id_certificado_seguridad',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	btest:false,
	//  Functions
	onButtonNew:function(){
		Phx.vista.CertificadosSeguridad.superclass.onButtonNew.call(this);
		this.Cmp.fecha_emision.setValue(new Date())
	},

	iniciarEventos:function(){
		console.log('Cmp',this.Cmp);		
	},

	// functions 
	preparaMenu:function(n){
		var data = this.getSelectedData();		
		Phx.vista.CertificadosSeguridad.superclass.preparaMenu.call(this,n);
		this.getBoton('diagrama_gantt').enable();
		this.getBoton('sig_estado').enable();
		this.getBoton('ant_estado').enable();

		if (data['estado_notificacion'] == 'enviado') {
			this.getBoton('edit').disable();
			this.getBoton('del').disable();
		}else{
			this.getBoton('edit').enable();
			this.getBoton('del').enable();
		}
	},

	liberaMenu:function(){
		var tb = Phx.vista.CertificadosSeguridad.superclass.liberaMenu.call(this);
		if(tb){
			this.getBoton('ant_estado').disable();
			this.getBoton('sig_estado').disable();
			this.getBoton('btnChequeoDocumentosWf').setDisabled(false);
			this.getBoton('diagrama_gantt').disable();
		}
		return tb
	},	

	diagramGantt: function(){
			var data=this.sm.getSelected().data.id_proceso_wf;
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
				params:{'id_proceso_wf':data},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});
	},

	loadCheckDocumentosRecWf:function() {
		var rec=this.sm.getSelected();
						
		rec.data.nombreVista = this.nombreVista;
		Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
			'Chequear documento del WF',
			{
				width:'90%',
				height:500
			},
			rec.data,
			this.idContenedor,
			'DocumentoWf'
		);                                            
	},

	sigEstado: function() {
		var rec = this.sm.getSelected();	
		this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
			'Estado de Wf',
			{
				modal: true,
				width: 700,
				height: 450
			},
			{
				data: {
					id_estado_wf: rec.data.id_estado_wf,
					id_proceso_wf: rec.data.id_proceso_wf,
					factura:       rec.data.factura,
					tipo_certificado:  rec.data.tipo_certificado                                                 
				}
			}, this.idContenedor, 'FormEstadoWf',
			{
				config: [{
					event: 'beforesave',
					delegate: this.onSaveWizard
				}],
				scope: this
			}
		);
		
	},

	onSaveWizard:function(wizard,resp){ 				        	
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));                
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_seguridad/control/CertificadosSeguridad/siguienteEstado',
			params:{
				id_proceso_wf_act:  resp.id_proceso_wf_act,
				id_estado_wf_act:   resp.id_estado_wf_act,
				id_tipo_estado:     resp.id_tipo_estado,
				// id_funcionario_wf:  resp.id_funcionario_wf,
				// id_depto_wf:        resp.id_depto_wf,
				obs:                resp.obs,
				json_procesos:      Ext.util.JSON.encode(resp.procesos),
				// tipo_certificado:	wizard.data.tipo_certificado                                 
				
			},
			success:function (resp) {
				Phx.CP.loadingHide();
				resp.argument.wizard.panel.destroy();
				this.reload();
			},
			failure: this.conexionFailure,
			argument:{wizard:wizard},
			timeout:this.timeout,
			scope:this
		});
	},

	antEstado:function(res){
		var rec=this.sm.getSelected();
		Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
			'Estado de Wf',
			{
				modal:true,
				width:450,
				height:250
			}, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
			{
				config:[{
					event:'beforesave',
					delegate: this.onAntEstado
				}
				],
				scope:this
			})
	},

	onAntEstado: function(wizard,resp){
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_seguridad/control/CertificadosSeguridad/anteriorEstado',
			params:{
				id_proceso_wf: resp.id_proceso_wf,
				id_estado_wf:  resp.id_estado_wf,
				id_proceso_wf_act:  resp.id_proceso_wf_act,
				obs: resp.obs,
				// estado_destino: resp.estado_destino
			},
			argument:{wizard:wizard},
			success:function (resp) {
				Phx.CP.loadingHide();
				resp.argument.wizard.panel.destroy();
				this.reload();
			},
			failure: this.conexionFailure,
			timeout:this.timeout,
			scope:this
		});
	},	
	


})
</script>
		
		