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
		this.load({params:{start:0, limit:this.tam_pag}})
	},
    
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
				name: 'ci',
				fieldLabel: 'CI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5,
				readOnly:true,
			},
				type:'TextField',
				filters:{pfiltro:'tele.ci',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'equipo_computacion',
				fieldLabel: 'Equipo de Computación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
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
				fieldLabel: 'Tipo de Uso',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
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
				fieldLabel: 'Cuenta con Internet',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100

			},
				type:'TextField',
				filters:{pfiltro:'tele.cuenta_con_internet',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'zona_domicilio',
				fieldLabel: 'Zona domicilio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'tele.zona_domicilio',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'transporte_particular',
				fieldLabel: 'Transporte Particular',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.transporte_particular',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'tipo_transporte',
				fieldLabel: 'Tipo Transporte',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'tele.tipo_transporte',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'placa',
				fieldLabel: 'Placa',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'tele.placa',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

    ],
	tam_pag:50,
	title:'Registros',
	ActList:'../../sis_organigrama/control/Teletrabajo/listarTeletrabajo',
	id_store:'id_teletrabajo',
	fields: [
		{name:'id_teletrabajo', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'ci', type: 'string'},
		{name:'equipo_computacion', type: 'string'},
		{name:'tipo_de_uso', type: 'string'},
		{name:'cuenta_con_internet', type: 'string'},
		{name:'zona_domicilio', type: 'string'},
		{name:'transporte_particular', type: 'string'},
		{name:'tipo_transporte', type: 'string'},
		{name:'placa', type: 'string'}
	],
	sortInfo:{
		field: 'id_teletrabajo',
		direction: 'DESC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
