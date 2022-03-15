<?php
/**
*@package pXP
*@file RolUsuario.php
*@author Grover (GVC)
*@date 14-02-2011
*@description  Vista para desplegar rolesde usaurio
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>

Phx.vista.rol=function(config){

var ds_subsistema =new Ext.data.JsonStore({

				url: '../../sis_seguridad/control/Subsistema/listarSubsistema',
				id: 'id_subsistema',
				root: 'datos',
				sortInfo:{
					field: 'nombre',
					direction: 'ASC'
				},
				totalProperty: 'total',
				fields: ['id_subsistema','nombre'],
				// turn on remote sorting
				remoteSort: true,
				baseParams:{par_filtro:'nombre'}
			});


function render_id_subsistema(value, p, record){return String.format('{0}', record.data['desc_subsis']);}
var FormatoVista=function (value,p,record){return value?value.dateFormat('d/m/Y'):''}

	this.Atributos=[
	{
		//configuraci�n del componente
		config:{
			labelSeparator:'',
			inputType:'hidden',
			name: 'id_rol'

		},
		type:'Field',
		form:true

	},
	 {
		config:{
			fieldLabel: "Nombre",
			gwidth: 200,
			name: 'rol',
			allowBlank:false,
			maxLength:100,
			minLength:1,/*aumentar el minimo*/
			anchor:'80%'

		},
		type:'TextField',
		filters:{type:'string'},
		id_grupo:0,
		bottom_filter:true,
		grid:true,
		form:true
	},
	 {
		config:{
			fieldLabel: "Descripcion",
			gwidth: 300,
			name: 'descripcion',
			allowBlank:true,
			maxLength:100,
			minLength:1,/*aumentar el minimo*/
			anchor:'80%'

		},
		type:'TextArea',

		filters:{type:'string'},
		id_grupo:0,
		 bottom_filter:true,
		grid:true,
		form:true
	},{
			config:{
				name:'id_subsistema',
				fieldLabel:'Subsistema',
				allowBlank:false,
				emptyText:'Subsistema...',
				store:ds_subsistema,
				valueField: 'id_subsistema',
				displayField: 'nombre',
				gdisplayField:'desc_subsis',

				hiddenName: 'id_subsistema',

				forceSelection:true,
				typeAhead: true,
    			triggerAction: 'all',
    			lazyRender:true,
				mode:'remote',
				pageSize:50,
				queryDelay:500,
				width:220,
				gwidth:220,
				minChars:2,
				renderer:render_id_subsistema
			},
			type:'ComboBox',
			id_grupo:0,
			filters:{
		        pfiltro:'subsis.nombre',
				type:'string'
			},

			grid:true,
			form:true
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

	Phx.vista.rol.superclass.constructor.call(this,config);
	this.init();

	/*this.addButton('Procedimiento',{handler:hijo,disabled:false,tooltip: '<b>Procedimiento</b><br/>'});

		function hijo(){
			_CP.loadWindows('../../../sis_seguridad/vista/rol_procedimiento/rol_procedimiento.php','Rol Procedimiento',{width:800,height:500},this.sm.getSelected().data,this.idContenedor);
		}*/

	this.load({params:{start:0, limit:50}})



}

Ext.extend(Phx.vista.rol,Phx.gridInterfaz,{
	tabEnter:true,
	title:'Usuario',
	ActSave:'../../sis_seguridad/control/Rol/guardarRol',
	ActDel:'../../sis_seguridad/control/Rol/eliminarRol',
	ActList:'../../sis_seguridad/control/Rol/listarRol',
	id_store:'id_rol',
	fheight:'70%',
	fwidth:'420',
	fields: [
	{name:'id_rol'},
	{name:'rol', type: 'string'},
	{name:'descripcion', type: 'string'},
	{name:'id_subsistema'},
	{name:'desc_subsis', type: 'string'},
	{name:'fecha_reg',type: 'date', dateFormat: 'Y-m-d'},
	{name:'usr_reg', type: 'string'},
	{name:'usr_mod', type: 'string'},
	{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
	{name:'fecha_reg_hora', type: 'date',dateFormat:'Y-m-d H:i:s.u'},

		],
	sortInfo:{
		field: 'rol',
		direction: 'ASC'
	},
	bdel:true,//boton para eliminar
	bsave:false,//boton para eliminar

	/*east:{
		  url:'../../../sis_seguridad/vista/gui_rol/GuiRol.php',
		  title:'Procedimientos',
		  width:400,
		  cls:'gui_rol'
		 },*/

	tabeast:[
		{
			url:'../../../sis_seguridad/vista/gui_rol/GuiRol.php',
			title:'Procedimientos',
			width:400,
			cls:'gui_rol'
		},
		{
			url:'../../../sis_seguridad/vista/rol/UsuarioRol.php',
			title:'Usuarios',
			width:400,
			cls:'UsuarioRol'
		}
	],

	//sobre carga de funcion
	preparaMenu:function(tb){
		//llamada funcion clace padre
		Phx.vista.rol.superclass.preparaMenu.call(this,tb)
	}



})
</script>
