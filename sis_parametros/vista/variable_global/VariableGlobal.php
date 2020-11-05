<?php
/**
*@package pXP
*@file gen-VariableGlobal.php
*@author  (admin)
*@date 24-01-2020 19:50:15
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
		this.load({params:{start:0, limit:this.tam_pag}})
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
				fieldLabel: 'variable',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'varg.variable',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'valor',
				fieldLabel: 'valor',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'varg.valor',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 800,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'varg.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		}
	],
	tam_pag:50,	
	title:'Variable Gobal',
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
	bsave:true
	}
)
</script>
		
		