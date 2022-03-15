<script>
/**
*@package pXP
*@file FormRepTramiteXFuncionario.php
*@author  (breydi vasquez)
*@date 15-04-2020
*@description Archivo con filtros para sacar reporte de tramites aprobados por funcionario
*/
Phx.vista.FormRepTramiteXFuncionario = Ext.extend(Phx.frmInterfaz, {

        constructor : function(config) {
			Phx.vista.FormRepTramiteXFuncionario.superclass.constructor.call(this, config);
			this.init();
            var fecha = new Date();
            Ext.Ajax.request({
                url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                params:{fecha:fecha.getDate()+'/'+(fecha.getMonth()+1)+'/'+fecha.getFullYear()},
                success:function(resp){
                    var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                    this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
                    this.Cmp.id_gestion.setRawValue(reg.ROOT.datos.anho);  
                    this.Cmp.fecha_ini.setValue('01/01/'+reg.ROOT.datos.anho);
                    this.Cmp.fecha_fin.setValue('31/12/'+reg.ROOT.datos.anho);	                  
                },
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });            
						
			this.iniciarEventos();
		},

		Atributos : [
        {            
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'funcionario_repo'
            },
            type:'Field',
            form:true 
        },            
		{
            config:{
                name:'id_gestion',
                fieldLabel:'Gestión',
                allowBlank:true,
                emptyText:'Gestión...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_parametros/control/Gestion/listarGestion',
                         id: 'id_gestion',
                         root: 'datos',
                         sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion','moneda','codigo_moneda'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
                    }),
                valueField: 'id_gestion',
                displayField: 'gestion',        
                hiddenName: 'id_gestion',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:5,
                queryDelay:1000,
                listWidth:200,
                resizable:true,
				width:150
                
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'gestion',
                        type:'string'
                    },
            grid:true,
            form:true
        },
        {
            config:{
                    name: 'fecha_ini',
                    fieldLabel: 'Desde',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150,                
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
		},
		{
            config:{
                    name: 'fecha_fin',
                    fieldLabel: 'Hasta',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
        },        
        {
            config: {
                    name: 'id_usuario',
                    fieldLabel: 'Solicitante',
                    allowBlank: false,
                    emptyText: 'Elija una opción...',
                    qtip:'Funcionario que registra el Reclamo en el ERP, se rellena por Defecto.',
                    store: new Ext.data.JsonStore({
                        //url: '../../sis_organigrama/control/Funcionario/listarFuncionarioCargo',
                        url: '../../sis_workflow/control/NumTramite/listarFuncionarioCuentas',
                        id: 'id_usuario',
                        root: 'datos',
                        sortInfo: {
                            field: 'desc_funcionario1',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_usuario', 'id_funcionario','desc_funcionario1','email_empresa','nombre_cargo','lugar_nombre','oficina_nombre', 'cuenta'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'funulc.desc_funcionario1'}
                    }),
                    valueField: 'id_usuario',
                    displayField: 'desc_funcionario1',
                    gdisplayField: 'desc_funcionario1',//corregit materiaesl
                    tpl:'<tpl for="."><div class="x-combo-list-item" style="color: black"><p><b>{desc_funcionario1}</b></p><p style="color: #80251e">{nombre_cargo}<br>{email_empresa}</p><p style="color:green">{oficina_nombre} - {lugar_nombre}</p><p style="font-weight:bold;color:#3328B3;">Cuenta Usuario: {cuenta}</p></div></tpl>',
                    hiddenName: 'id_usuario',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 20,
                    queryDelay: 1000,
                    anchor: '100%',
                    width: 250,                    
                    minChars: 2,
                    resizable:true,
                    listWidth:'270',
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['desc_funcionario1']);
                    }
                },
                type: 'ComboBox',
                bottom_filter:true,
                id_grupo:0,
                filters:{
                    pfiltro:'fun.desc_funcionario1',
                    type:'string'
                },
            grid: true,
            form: true
        },
        {
                config : {
                    name : 'sistema_rep',
                    fieldLabel : 'Sistema',
                    qtip:'Seleccione el/los sistemas/s para su reporte',
                    allowBlank : true,
                    triggerAction : 'all',
                    lazyRender : true,
                    anchor: '100%',
                    gwidth: 250,
                    mode : 'local',
                    emptyText:'sistema...',
                    store: new Ext.data.ArrayStore({
                        id: '',
                        fields: [
                            'key',
                            'value'
                        ],
                        data: [
                            ['todos', 'Todos'],
                            ['v_org', 'Organigrama'], 
                            ['v_adq', 'Adquiciciones'], 
                            ['v_obl', 'Obligaciones De Pago'], 
                            ['v_alm', 'Almacenes'], 
                            ['v_kaf', 'Activos Fijos'],
                            ['v_ctr', 'Contratos'], 
                            ['v_pls', 'Planilla De Sueldos'],
                            ['v_fea', 'Fondos En Avance'],
                            ['v_prs', 'Presupuestos'], 
                            ['v_sdc', 'Sistema De Contabilidad'], 
                            ['v_gro', 'Gestion De Reclamos Odeco'],
                            ['v_gsm', 'Gestion Materiales']

                        ]
                    }),
                    valueField: 'key',
                    displayField: 'value',                    
                    enableMultiSelect:true
                },
                type : 'AwesomeCombo',
                id_grupo : 1,
                form : true,
                grid : true
            },               
		],
		
		
        topBar : true,
		botones : false,
        tipo : 'reporte',
        clsSubmit : 'bprint',
        labelSubmit : 'Generar',
		title : 'Tramite x funcionario',		
        tooltipSubmit : '<b>Reporte Tramites Aprobado por Funcionario</b>',
		ActSave : '../../sis_workflow/control/NumTramite/reporteTramiteXFuncionario',
		
		Grupos : [{
			layout : 'column',
            bodyStyle: 'padding: 5px;',
			items : [{
				xtype : 'fieldset',
				layout : 'form',
				border : true,
				title : 'Datos para el reporte',
				bodyStyle : 'padding:0 10px 0;',
				columnWidth : '500px',
				items : [],
				id_grupo : 0,
				collapsible : true
			}]
		}],

		iniciarEventos:function(){        		            
            
            // captura gestion evento de seleccion
            this.Cmp.id_gestion.on('select', function(o, r) {                                                
                this.Cmp.fecha_ini.setValue('01/01/'+r.data.gestion);
                this.Cmp.fecha_fin.setValue('31/12/'+r.data.gestion);	                                                 
            }, this);
            
            this.Cmp.sistema_rep.getStore().each(function(rec){                                                
                   if (rec.data.key == 'todos'){
                        this.Cmp.sistema_rep.checkRecord(rec);                                         
                   }
		    }, this);

            this.Cmp.id_usuario.on('select', function(o, r) {
                this.Cmp.funcionario_repo.setRawValue(r.data.desc_funcionario1);
                
            }, this);
            
            Ext.Ajax.request({
                url:'../../sis_workflow/control/NumTramite/usuarioAdminTF', 
                params:{data:''},              
                success:function(resp){
                    var reg =  Ext.decode(Ext.util.Format.trim(resp.responseText));
                    console.log('value=> ',reg);                    
                    this.Cmp.id_usuario.setValue(reg.ROOT.datos.id_usuario);	                  
                    this.Cmp.id_usuario.setRawValue(reg.ROOT.datos.funcionario);
                    this.Cmp.funcionario_repo.setRawValue(reg.ROOT.datos.funcionario);

                    reg.ROOT.datos.admin == 0 && this.Cmp.id_usuario.setDisabled(true);                                        
                },
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            }); 
		}       
	
})
</script>