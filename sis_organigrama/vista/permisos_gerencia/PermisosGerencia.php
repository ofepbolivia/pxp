<?php
/**
*@package pXP
*@file gen-PermisosGerencia.php
*@author  (Ismael Valdivia)
*@date 26/08/2020 10:10:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>

Phx.vista.PermisosGerencia=Ext.extend(Phx.gridInterfaz,{
	constructor:function(config){
		//this.initButtons=[this.etiqueta_ini, this.cmbGerencia];
		this.maestro=config.maestro;
		Phx.vista.PermisosGerencia.superclass.constructor.call(this,config);
		this.init();
    this.iniciarEventos();

	},
    Atributos:[
        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_autorizacion'
            },
            type:'Field',
            form:true
        },
				{
					config: {
						name: 'id_funcionario',
						fieldLabel: 'Funcionario',
						allowBlank: false,
						emptyText: 'Elija una opción...',
						store: new Ext.data.JsonStore({
		                    url: '../../sis_organigrama/control/Funcionario/listarFuncionarioCargo',
		                    id: 'id_cargo',
		                    root: 'datos',
		                    sortInfo: {
		                        field: 'descripcion_cargo',
		                        direction: 'ASC'
		                    },
		                    totalProperty: 'total',
		                    fields: ['id_cargo', 'nombre','desc_funcionario1','id_funcionario','descripcion_cargo','id_cargo'],
		                    remoteSort: true,
		                    baseParams: {par_filtro: 'descripcion_cargo#desc_funcionario1#desc_funcionario2'}
		                }),
            tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{descripcion_cargo}</b></p><p>{desc_funcionario1}</p> </div></tpl>',
            valueField: 'id_funcionario',
						displayField: 'desc_funcionario1',
						gdisplayField: 'desc_funcionario1',
						hiddenName: 'id_funcionario',
						forceSelection: true,
						typeAhead: false,
						triggerAction: 'all',
						lazyRender: true,
						mode: 'remote',
						pageSize: 15,
						queryDelay: 1000,
						anchor: '100%',
						gwidth: 250,
						minChars: 2,
						renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario1']);}

					},
					type: 'ComboBox',
					id_grupo: 0,
					filters: {pfiltro: 'fun.desc_funcionario1',type: 'string'},
					grid: true,
					bottom_filter:true,
					form: true
				},
				{
            config:{
                name: 'nombre_cargo',
                fieldLabel: 'Cargo Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:10
            },
            type:'TextField',
            filters:{pfiltro:'fun.nombre_cargo',type:'string'},
						bottom_filter:true,
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'id_gerencia',
                fieldLabel: 'Gerencias',
                allowBlank: true,
                emptyText: 'Elija las Gerencias...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_organigrama/control/PermisosGerencia/listarGerencias',
                    id: 'id_uo',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre_unidad',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_uo', 'nombre_unidad'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'uo.nombre_unidad#uo.id_uo'}
                }),
                valueField: 'id_uo',
                displayField: 'nombre_unidad',
								forceSelection: true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                minChars: 2,
                anchor: '100%',
                gwidth: 230,
								enableMultiSelect: true,

								renderer:function(value, p, record){return String.format('{0}', record.data['nombres_gerencias']);}


            },
            type: 'AwesomeCombo',
            id_grupo: 0,
						// filters: {pfiltro: 'uo.nombre_cargo',type: 'string'},
						// bottom_filter:true,
            form: true,
            grid:true,
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
            filters:{pfiltro:'uo.estado_reg',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },

        {
            config:{
                name: 'id_usuario_ai',
                fieldLabel: '',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'uo.id_usuario_ai',type:'numeric'},
            id_grupo:1,
            grid:false,
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
            filters:{pfiltro:'uo.fecha_reg',type:'date'},
            id_grupo:1,
            grid:true,
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
            filters:{pfiltro:'uo.usuario_ai',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
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
                name: 'fecha_mod',
                fieldLabel: 'Fecha Modif.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
            },
            type:'DateField',
            filters:{pfiltro:'uo.fecha_mod',type:'date'},
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
        }
    ],
	tam_pag:50,
	title:'Dosificación',
	ActSave:'../../sis_organigrama/control/PermisosGerencia/insertarPermisosGerencia',
	ActDel:'../../sis_organigrama/control/PermisosGerencia/eliminarPermisosGerencia',
	ActList:'../../sis_organigrama/control/PermisosGerencia/listarPermisosGerencias',
	id_store:'id_autorizacion',
	fields: [
		{name:'id_autorizacion', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
    {name:'id_gerencia', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'nombres_gerencias', type: 'string'},
		{name:'desc_funcionario1', type: 'string'},
		{name:'nombre_cargo', type: 'string'},

	],
	sortInfo:{
		field: 'id_autorizacion',
		direction: 'DESC'
	},
	bdel:true,
	bsave:true,
    fheight:'50%',
    fwidth:'50%',

    iniciarEventos :  function () {

      this.load({params:{start:0, limit:this.tam_pag}});
    },

		// etiqueta_ini : new Ext.form.Label({
		// 		name: 'etiqueta_ini',
		// 		grupo: [0,1],
		// 		fieldLabel: 'Gerencia:',
		// 		text: 'Gerencia:',
		// 		//style: {color: 'green', font_size: '12pt'},
		// 		readOnly:true,
		// 		anchor: '150%',
		// 		gwidth: 150,
		// 		format: 'd/m/Y',
		// 		hidden : false,
		// 		style: 'font-size: 170%; font-weight: bold; background-image: none;color: green;'
		// }),
		// cmbGerencia: new Ext.form.ComboBox({
		// 		fieldLabel: 'Gerencia',
		// 		grupo:[0,1,2],
		// 		allowBlank: true,
		// 		blankText:'Seleccione Gerencia',
		// 		emptyText:'Seleccione Gerencia........',
		// 		name:'id_uo',
		// 		store:new Ext.data.JsonStore(
		// 				{
		// 						url: '../../sis_organigrama/control/PermisosGerencia/listarGerenciasPermitidas',
		// 						id: 'id_uo',
		// 						root: 'datos',
		// 						sortInfo:{
		// 								field: 'nombre_unidad',
		// 								direction: 'ASC'
		// 						},
		// 						totalProperty: 'total',
		// 						fields: ['id_uo','codigo','descripcion','id_funcionario','defecto'],
		// 						// turn on remote sorting
		// 						remoteSort: true,
		// 						baseParams:{par_filtro:'uo.descripcion#uo.codigo'}
		// 				}),
		// 		valueField: 'id_uo',
		// 		tpl:'<tpl for="."><div class="x-combo-list-item"><p><font color="blue"><b>{descripcion}</b></font></p><p><b>Codigo: <font color="red">{codigo}</font></b></p><p><b>id_funcionario: <font color="red">{id_funcionario}</font></b></p><p><b>defecto: <font color="red">{defecto}</font></b></p></div></tpl>',
		// 		triggerAction: 'all',
		// 		displayField: 'descripcion',
		// 		hiddenName: 'id_uo',
		// 		mode:'remote',
		// 		pageSize:10,
		// 		queryDelay:500,
		// 		listWidth:'280',
		// 		width:220
		//
		// }),
	}
)
</script>
