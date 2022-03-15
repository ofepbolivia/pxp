<?php
/**
*@package pXP
*@file gen-UsuarioGrupoEp.php
*@author  (admin)
*@ate 22-04-2013 15:53:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UsuarioRol=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UsuarioRol.superclass.constructor.call(this,config);
		this.init();
        //si la interface es pestanha este código es para iniciar
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else {
             this.bloquearMenus();
          }
        },

        Atributos:[
            {
        //configuracion del componente
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
				 labelSeparator:'',
				 inputType:'hidden',
				 name: 'id_usuario_rol'
		 },
		 type:'Field',
		 form:true
			},
		 	 {
             config : {
                 name : 'id_usuario',
                 fieldLabel : 'Usuario',
                 allowBlank : false,
                 gwidth: 100,
                 emptyText : 'Usuario...',
                 store : new Ext.data.JsonStore({
                     url : '../../sis_seguridad/control/Usuario/listarUsuario',
                     id : 'id_usuario',
                     root : 'datos',
                     sortInfo : {
                         field : 'cuenta',
                         direction : 'ASC'
                     },
                     totalProperty : 'total',
                     fields : ['id_usuario', 'cuenta', 'desc_person'],
                     remoteSort : true,
                     baseParams : {
                         par_filtro : 'USUARI.cuenta#PERSON.nombre_completo2'
                     }
                 }),
                 tpl : '<tpl for="."><div class="x-combo-list-item"><p>Cuenta: {cuenta}</p><p>Nombre: {desc_person}</p></div></tpl>',
                 valueField : 'id_usuario',
                 displayField : 'cuenta',
                 gdisplayField : 'cuenta',
                 hiddenName : 'id_usuario',
                 forceSelection : true,
                 typeAhead : true,
                 triggerAction : 'all',
                 lazyRender : true,
                 mode : 'remote',
                 pageSize : 10,
							   resizable:true,
								 listWidth: '280',
                 queryDelay : 1000,
                 minChars : 2
             },
             type : 'ComboBox',
             id_grupo : 0,
             filters : {
                 pfiltro : 'car.nombre_cargo#p.nombre_completo1',
                 type : 'string'
             },
             bottom_filter:true,
             grid : false,
             form : true
         },
         {
        config:{
            name: 'nombre',
            fieldLabel: 'Nombre',
            allowBlank: true,
            anchor: '80%',
            gwidth: 200,
            maxLength:100

        },
        type:'TextField',
        grid:true,
        form:false
			},
				{
			 config:{
					 name: 'cargo',
					 fieldLabel: 'Cargo',
					 allowBlank: true,
					 anchor: '80%',
					 gwidth: 200,
					 maxLength:100

			 },
			 type:'TextField',
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
	 				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
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
		}
	    ],
    tam_pag:50,
	title:'Usuario Rol',
	ActSave:'../../sis_seguridad/control/UsuarioRol/guardarUsuarioRol',
	ActDel:'../../sis_seguridad/control/UsuarioRol/eliminarUsuarioRol',
  ActList:'../../sis_seguridad/control/Rol/listarRolUsuario',
	id_store:'id_usuario_rol',
	fields: [
		{name:'id_rol', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'cargo', type: 'string'},
		{name:'fecha_reg',type: 'date', dateFormat: 'Y-m-d'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_reg_hora', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_rol', type: 'numeric'},

	],
    sortInfo:{
        field: 'nombre',
        direction: 'ASC'
    },
    bdel:true,
    bsave:false,
    bnew:true,
    bedit:false,
	onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_rol:this.maestro.id_rol};
        this.load({params: {start: 0, limit: 50}});
    },
    loadValoresIniciales: function () {
        this.Cmp.id_rol.setValue(this.maestro.id_rol);
        Phx.vista.UsuarioRol.superclass.loadValoresIniciales.call(this);
    },
		onButtonNew: function() {
		  this.window.setSize(500, 200);
			Phx.vista.UsuarioRol.superclass.onButtonNew.call(this);
		},

	}
)
</script>
