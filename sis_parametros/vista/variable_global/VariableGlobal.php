<?php
/**
*@package pXP
*@file gen-VariableGlobal.php
*@author  (ismael.valdivia)
*@date 12-05-2021 12:56:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.VariableGlobal=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.VariableGlobal.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});

    this.bbar.el.dom.style.background='linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%)';
    this.tbar.el.dom.style.background='linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%)';
    this.grid.body.dom.firstChild.firstChild.lastChild.style.background='linear-gradient(to bottom, rgba(254,255,232,1) 0%,rgba(214,219,191,1) 100%)';
    this.grid.body.dom.firstChild.firstChild.firstChild.firstChild.style.background='linear-gradient(to bottom, rgba(242,246,248,1) 0%,rgba(216,225,231,1) 50%,rgba(181,198,208,1) 51%,rgba(224,239,249,1) 100%)'



	},

  onButtonEdit:function () {
    Phx.vista.VariableGlobal.superclass.onButtonEdit.call(this);
    this.window.items.items[0].body.dom.style.background = 'linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%)';

  },

  onButtonNew:function () {
    Phx.vista.VariableGlobal.superclass.onButtonNew.call(this);
    this.window.items.items[0].body.dom.style.background = 'linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%)';

  },


	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_variable_global'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'variable',
				fieldLabel: 'Nombre Variable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
			},
				type:'TextField',
				filters:{pfiltro:'varglo.variable',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
        bottom_filter: true
		},
		{
			config:{
				name: 'valor',
				fieldLabel: 'Valor',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
			},
				type:'TextField',
				filters:{pfiltro:'varglo.valor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true,
        bottom_filter: true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '80%',
				gwidth: 600,
			},
				type:'TextField',
				filters:{pfiltro:'varglo.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		}
	],
	tam_pag:50,
	title:'Variables Globales',
	ActSave:'../../sis_parametros/control/VariableGlobal/insertarVariableGlobal',
	ActDel:'../../sis_parametros/control/VariableGlobal/eliminarVariableGlobal',
	ActList:'../../sis_parametros/control/VariableGlobal/listarVariableGlobal',
	id_store:'id_variable_global',
	fields: [
		{name:'id_variable_global', type: 'numeric'},
		{name:'variable', type: 'string'},
		{name:'valor', type: 'string'},
		{name:'descripcion', type: 'string'},

	],
	sortInfo:{
		field: 'id_variable_global',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
  btest:false
	}
)
</script>
