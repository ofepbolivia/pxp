<?php
/**
*@package pXP
*@file UsuarioRol.php
*@author KPLIAN (admin)
*@date 14-02-2011
*@description  Vista para asociar roles a usuarios
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>

Phx.vista.usuario_rol=function(config){

var ds_rol =new Ext.data.JsonStore({

				url: '../../sis_seguridad/control/Rol/listarRol',
				id: 'id_rol',
				root: 'datos',
				sortInfo:{
					field: 'rol',
					direction: 'ASC'
				},
				totalProperty: 'total',
				fields: ['id_rol','rol','descripcion'],
				// turn on remote sorting
				remoteSort: true,
				baseParams:{par_filtro:'rol'}

			});


function render_id_rol(value, p, record){return String.format('{0}', record.data['rol']);}
var FormatoVista=function (value,p,record){return value?value.dateFormat('d/m/Y'):''}

	this.Atributos=[
	{
		//configuraci�n del componente
		config:{
			labelSeparator:'',
			inputType:'hidden',
			name: 'id_usuario_rol'

		},
		type:'Field',
		form:true

	},{
		//configuraci�n del componente
		config:{
			labelSeparator:'',
			inputType:'hidden',
			name: 'id_usuario'

		},
		type:'Field',
		form:true

	},{
			config:{
				name:'id_rol',
				fieldLabel:'Rol',
				allowBlank:false,
				emptyText:'Rol...',
				store:ds_rol,
				valueField: 'id_rol',
				displayField: 'rol',
				hiddenName: 'id_rol',
				forceSelection:true,
				typeAhead: true,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:220,
				gwidth:220,
				//minListWidth:'200',
				renderer:render_id_rol
			},
			type:'ComboBox',
			id_grupo:0,
			filters:{	pfiltro:'rol',
						type:'string'
					},
			grid:true,
			//bottom_filter:true,
			form:true
	},
	 {
		config:{
			fieldLabel: "Descripcion",
			gwidth: 130,
			name: 'descripcion'
		},
		type:'TextArea',
		filters:{type:'string'},
		grid:true,
		form:false
	},
	{
		config:{
			fieldLabel: "Subsistema",
			gwidth: 130,
			name: 'nombre'
		},
		type:'TextField',
		filters:{type:'string'},
		grid:true,
		form:false
	},
	{
		config:{
				fieldLabel: "Fecha Reg Completa",
				gwidth: 130,
				name:'fecha_reg_hora',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{type:'date'},
			grid:true,
			form:false
	},
	{
			config: {
					name: 'estado_reg',
					fieldLabel: 'Estado Reg.',
					allowBlank: false,
					anchor: '100%',
					gwidth: 100
			},
			type: 'TextField',
			id_grupo: 0,
			grid: true,
			form: false
	},
	{
			config:{
					name: 'usr_reg',
					fieldLabel: 'Creado por',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100
			},
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
	},
	{
		config:{
				fieldLabel: "Fecha Reg",
				gwidth: 110,
				name:'fecha_reg',
				renderer:FormatoVista
			},
			type:'DateField',
			filters:{type:'date'},
			grid:true,
			form:false
	},
	{
			config:{
					name: 'usr_mod',
					fieldLabel: 'Modificado por',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100
			},
			type:'NumberField',
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
					anchor: '100%',
					gwidth: 120,
					format: 'd/m/Y',
					renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'USUARI.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
	},
	];

	Phx.vista.usuario_rol.superclass.constructor.call(this,config);
	this.init();

	// this.grid.getTopToolbar().disable();
	// this.grid.getBottomToolbar().disable();

}

Ext.extend(Phx.vista.usuario_rol,Phx.gridInterfaz,{
	tabEnter:true,
	title:'Usuario',
	ActSave:'../../sis_seguridad/control/UsuarioRol/guardarUsuarioRol',
	ActDel:'../../sis_seguridad/control/UsuarioRol/eliminarUsuarioRol',
	ActList:'../../sis_seguridad/control/UsuarioRol/listarUsuarioRol',
	id_store:'id_usuario_rol',
	fields: [
	'id_usuario_rol','id_rol',
	'rol',
	'descripcion',
	{name:'fecha_reg',type: 'date', dateFormat: 'Y-m-d'},
	{name:'usr_reg', type: 'string'},
	{name:'usr_mod', type: 'string'},
	{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
	{name:'fecha_reg_hora', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
	'nombre','estado_reg'],
	sortInfo:{
		field: 'rol',
		direction: 'ASC'
	},
	bdel:true,//boton para eliminar
	bsave:false,//boton para eliminar
	bedit:false,//boton para editar


	loadValoresIniciales:function(){
		Phx.vista.usuario_rol.superclass.loadValoresIniciales.call(this);
	    this.getComponente('id_usuario').setValue(this.maestro.id_usuario);
	},

	onReloadPage:function(m){
		this.maestro=m;
		this.store.baseParams={id_usuario:this.maestro.id_usuario,tipo_estado:'activo'};
		this.load({params:{start:0, limit:50}})

	},
	reload:function(p){
	    Phx.CP.getPagina(this.idContenedorPadre).reload()
	},
	gruposBarraTareas:[
		{name:  'activo', title: '<h1 style="text-align: center; color: #00B167;">ACTIVOS</h1>',grupo: 0, height: 0} ,
		{name: 'inactivo', title: '<h1 style="text-align: center; color: #FF8F85;">INACTIVOS</h1>', grupo: 1, height: 1},
		],
	actualizarSegunTab: function(name, indice){

		if (this.maestro!=undefined){
				this.store.baseParams={id_usuario:this.maestro.id_usuario,tipo_estado:name};
				this.load({params:{start:0, limit:this.tam_pag}});
	    }
		},
    bnewGroups: [0],
    bdelGroups:  [0],
    bactGroups:  [0,1],
    bexcelGroups: [0,1],
})
</script>
