<?php
/**
*@package pXP
*@file gen-Teletrabajo.php
*@author  (José Mita)
*@date 21-06-2016 10:11:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Teletrabajo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Teletrabajo.superclass.constructor.call(this,config);
		this.init();

		this.addButton('aprobar', {
				text: 'Aprobar Solicitud',
				iconCls: 'bok',
				disabled: false,
				handler: this.aprobarSolicitud,
				//tooltip: '<b>Adjuntar Archivo</b><br><b>Nos permite adjuntar documentos de un funcionario.</b>',
				grupo: [0]
		});

		this.addButton('rechazar', {
				text: 'Rechazar Solicitud',
				iconCls: 'bwrong',
				disabled: false,
				handler: this.rechazarSolicitud,
				//tooltip: '<b>Adjuntar Archivo</b><br><b>Nos permite adjuntar documentos de un funcionario.</b>',
				grupo: [0]
		});

		this.addButton('archivo', {
				text: 'Adjuntar Archivo',
				iconCls: 'bfolder',
				disabled: false,
				handler: this.archivo,
				tooltip: '<b>Adjuntar Archivo</b><br><b>Nos permite adjuntar documentos de un funcionario.</b>',
				grupo: [0,1,2]
		});

		this.finCons = true;
		this.store.baseParams.pes_estado = 'borrador';
		this.load({params:{start:0, limit:this.tam_pag}});
	},

	preparaMenu:function() {
		this.getBoton('archivo').enable();
		this.getBoton('aprobar').enable();
		this.getBoton('rechazar').enable();
		Phx.vista.Teletrabajo.superclass.preparaMenu.call(this);
	},
	liberaMenu:function() {
		this.getBoton('archivo').disable();
		this.getBoton('aprobar').disable();
		this.getBoton('rechazar').disable();
		Phx.vista.Teletrabajo.superclass.liberaMenu.call(this);
	},

	aprobarSolicitud: function () {
		var rec=this.sm.getSelected();
		var simple = new Ext.FormPanel({
		 labelWidth: 75, // label settings here cascade unless overridden
		 frame:true,
		 bodyStyle:'padding:5px 5px 0; background:linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%);',
		 width: 330,
		 height:100,
		 defaultType: 'textfield',
		 items: [
									 new Ext.form.TextArea({
											 name: 'observaciones',
											 msgTarget: 'title',
											 fieldLabel: 'Observación',
											 allowBlank: false,
											 width: 200,
											 maxLength:50
									 }),
							]

					});
			this.aprobar_formulario = simple;
			var aprobar = 'si';
			var win = new Ext.Window({
				title: '<h1 style="height:20px; font-size:15px;"><img src="../../../lib/imagenes/ball_green.png" height="20px" style="float:left;"> <p style="margin-left:30px;">Aprobar Solicitud<p></h1>', //the title of the window
				width:350,
				height:200,
				//closeAction:'hide',
				modal:true,
				plain: true,
				items:simple,
				buttons: [{
										text:'<i class="fa fa-floppy-o fa-lg"></i> Guardar',
										scope:this,
										handler: function(){
												this.guardar(win,aprobar);
										}
								},{
										text: '<i class="fa fa-times-circle fa-lg"></i> Cancelar',
										handler: function(){
												win.hide();
										}
								}]

			});
			win.show();
			//this.aprobar_formulario.items.items[0].setValue(rec.data.excento);

	},

	rechazarSolicitud: function () {
		var rec=this.sm.getSelected();
		var simple = new Ext.FormPanel({
		 labelWidth: 75, // label settings here cascade unless overridden
		 frame:true,
		 bodyStyle:'padding:5px 5px 0; background:linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%);',
		 width: 330,
		 height:100,
		 defaultType: 'textfield',
		 items: [
									 new Ext.form.TextArea({
											 name: 'observaciones',
											 msgTarget: 'title',
											 fieldLabel: 'Observación',
											 allowBlank: false,
											 width: 200,
											 maxLength:50
									 }),
							]

					});
			this.aprobar_formulario = simple;
			var aprobar = 'no';
			var win = new Ext.Window({
				title: '<h1 style="height:20px; font-size:15px;"><img src="../../../lib/imagenes/ball_red.png" height="20px" style="float:left;"> <p style="margin-left:30px;">Rechazar Solicitud<p></h1>', //the title of the window
				width:350,
				height:200,
				//closeAction:'hide',
				modal:true,
				plain: true,
				items:simple,
				buttons: [{
										text:'<i class="fa fa-floppy-o fa-lg"></i> Guardar',
										scope:this,
										handler: function(){
												this.guardar(win,aprobar);
										}
								},{
										text: '<i class="fa fa-times-circle fa-lg"></i> Cancelar',
										handler: function(){
												win.hide();
										}
								}]

			});
			win.show();
			//this.aprobar_formulario.items.items[0].setValue(rec.data.excento);

	},

	guardar : function(win,aprobar){
		var rec=this.sm.getSelected();
		console.log("llega aqui para guardar datos",aprobar);
		Ext.Ajax.request({
				url : '../../sis_organigrama/control/Teletrabajo/evaluarFormulario',
				params : {
					'id_teletrabajo' : rec.data.id_teletrabajo,
					'estado_solicitud' : aprobar,
					'observaciones': this.aprobar_formulario.items.items[0].getValue()
				},
				success : this.successExportHtml,
				failure : this.conexionFailure,
				timeout : this.timeout,
				scope : this
			});
		win.hide();
		this.reload();
		/**********************************************************************/
	},


	archivo: function () {

			var rec = this.getSelectedData();
			console.log("aqui llega el dato",rec);
			//enviamos el id seleccionado para cual el archivo se deba subir
			rec.datos_extras_id = rec.id_teletrabajo;
			//enviamos el nombre de la tabla
			rec.datos_extras_tabla = 'orga.tformulario_teletrabajo';
			//enviamos el codigo ya que una tabla puede tener varios archivos diferentes como ci,pasaporte,contrato,slider,fotos,etc
			rec.datos_extras_codigo = '';

			//esto es cuando queremos darle una ruta personalizada
			//rec.datos_extras_ruta_personalizada = './../../../uploaded_files/favioVideos/videos/';

			Phx.CP.loadWindows('../../../sis_parametros/vista/archivo/Archivo.php',
					'Archivo',
					{
							width: '80%',
							height: '80%'
					}, rec, this.idContenedor, 'Archivo');

	},

	gruposBarraTareas:[
			{name:'borrador',title:'<H1 align="center" style="color:#E85C00; font-size:12px;"><i style="font-size:15px;" class="fa fa-pencil-square"></i> Borrador</h1>',grupo:0,height:0},
			{name:'aprobados',title:'<H1 align="center" style="color:#00AD1F; font-size:12px;"><i style="font-size:15px;" class="fa fa-check-circle"></i> Aprobados</h1>',grupo:1,height:0},
			{name:'rechazados',title:'<H1 align="center" style="color:red; font-size:12px;"><i style="font-size:15px;" class="fa fa-times-circle"></i> Rechazados</h1>',grupo:2,height:0},

	],


	actualizarSegunTab: function(name, indice){
			if(this.finCons){
					this.store.baseParams.pes_estado = name;
					if (name == 'aprobados') {
						this.cm.setHidden(16, false);
						this.cm.setHidden(17, false);
					}
					if (name == 'rechazados') {
						this.cm.setHidden(16, false);
						this.cm.setHidden(17, false);
					}
					if (name == 'borrador') {
						this.cm.setHidden(16, true);
						this.cm.setHidden(17, true);
					}
					this.load({params:{start:0, limit:this.tam_pag}});
			}
	},

	bactGroups:  [0,1,2],
	bexcelGroups: [0,1,2],

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_teletrabajo'
			},
			type:'Field',
			form:true
		},

        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_funcionario'
            },
            type:'Field',
            form:true
        },

		{
			config:{
				name: 'apellido_paterno',
				fieldLabel: 'Apellido Paterno',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:5,
				readOnly:true,
			},
				type:'TextField',
				filters:{pfiltro:'per.apellido_paterno',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:false
		},{
			config:{
				name: 'apellido_materno',
				fieldLabel: 'Apellido Materno',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:5,
				readOnly:true,
			},
				type:'TextField',
				filters:{pfiltro:'per.apellido_materno',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre(s)',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:5,
				readOnly:true,
			},
				type:'TextField',
				filters:{pfiltro:'per.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				bottom_filter:true,
				form:false
		},
		{
			config:{
				name: 'ci',
				fieldLabel: 'C.I',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.ci',type:'string'},
				id_grupo:1,
				grid:true,
				bottom_filter:true,
				form:false
		},

		{
			config:{
				name: 'expedicion',
				fieldLabel: 'Expedición',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'per.expedicion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

		{
			config:{
				name: 'nombre_cargo',
				fieldLabel: 'Cargo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250

			},
				type:'TextField',
				filters:{pfiltro:'car.nombre_cargo',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'cambio_modalidad',
				fieldLabel: 'Modalidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tele.cambio_modalidad',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'dias_asistencia_fisica',
				fieldLabel: 'Días de Asistencia Física',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.dias_asistencia_fisica',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'motivo_solicitud',
				fieldLabel: 'Motivo de la Solicitud',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200
			},
				type:'TextField',
				filters:{pfiltro:'tele.motivo_solicitud',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'desc_motivo_solicitud',
				fieldLabel: 'Descripción del motivo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.desc_motivo_solicitud',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'equipo_computacion',
				fieldLabel: 'Cuenta con equipo de computación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 180,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.equipo_computacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'tipo_de_uso',
				fieldLabel: 'Uso del equipo de computación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 180,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.tipo_de_uso',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'cuenta_con_internet',
				fieldLabel: 'Cuenta con internet',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.cuenta_con_internet',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'gerencia',
				fieldLabel: 'Gerencia',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				bottom_filter:true,
				maxLength:5
			},
				type:'TextField',
				//filters:{pfiltro:'gerencia',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha de Registro',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.fecha_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'estado_solicitud',
				fieldLabel: 'Aprobado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.estado_solicitud',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.observaciones',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

    ],
	tam_pag:50,
	title:'Registros',
	ActList:'../../sis_organigrama/control/Teletrabajo/listarTeletrabajo',
	ActDel:'../../sis_organigrama/control/Teletrabajo/eliminarTeletrabajo',
	id_store:'id_teletrabajo',
	fields: [
		{name:'id_teletrabajo', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'apellido_paterno', type: 'string'},
		{name:'apellido_materno', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'ci', type: 'string'},
		{name:'expedicion', type: 'string'},
		{name:'nombre_cargo', type: 'string'},
		{name:'cambio_modalidad', type: 'string'},
		{name:'dias_asistencia_fisica', type: 'string'},
		{name:'motivo_solicitud', type: 'string'},
		{name:'desc_motivo_solicitud', type: 'string'},
		{name:'equipo_computacion', type: 'string'},
		{name:'tipo_de_uso', type: 'string'},
		{name:'cuenta_con_internet', type: 'string'},
		{name:'gerencia', type: 'string'},
		{name:'fecha_reg', type: 'string'},
		{name:'estado_solicitud', type: 'string'},
		{name:'observaciones', type: 'string'},
	],
	sortInfo:{
		field: 'apellido_paterno',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	bedit:false,
	bnew:false,
	btest:false,
	}
)
</script>
