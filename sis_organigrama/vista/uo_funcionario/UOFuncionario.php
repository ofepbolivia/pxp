<?php
/**
*@package pXP
*@file UOFuncionario.php
*@author KPLIAN (admin)
*@date 14-02-2011
*@description  Vista para asociar los funcionarios a su correspondiente Unidad Organizacional
*/
include_once('../../media/styles.php');
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.uo_funcionario=Ext.extend(Phx.gridInterfaz,{


    viewConfig: {
        autoFill: true,
        getRowClass: function (record) {
            current_date = new Date();

            if (record.data.tipo == 'funcional') {
                return 'funcional';
            } else if (record.data.tipo == 'oficial' && record.data.fecha_finalizacion < current_date && record.data.fecha_finalizacion != null) {
                return 'baja';
            } else {
                return 'alta';
            }
        }
    },

    Atributos:[
		{
			// configuracion del componente
			config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_uo_funcionario'
	
			},
			
			type:'Field',
			form:true 
			
		},
		{	config:{
				labelSeparator:'',
				inputType:'hidden',
				name: 'id_uo'
		
			},
			type:'Field',
			form:true 
			
		},		
		 {
			config:{
				fieldLabel: "Codigo",
				gwidth: 130,
				name: 'codigo',
				allowBlank:false,	
				maxLength:150,
				minLength:5,
				anchor:'100%'
			},
			type:'TextField',
			filters:{pfiltro:'FUNCIO.codigo',type:'string'},
			id_grupo:0,
			grid:true,
			form:false
		},

        {
            config:{
                name: 'tipo',
                fieldLabel: 'Tipo Asignación',
                allowBlank: false,
                emptyText:'Tipo...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                anchor: '100%',
                gwidth: 200,
                store:['oficial','funcional']
            },
            type:'ComboBox',
            filters:{
                type: 'list',
                options: ['oficial','funcional'],
            },
            id_grupo:0,
            grid:true,
            form:true
        },

        {
            config:{
                fieldLabel: "Fecha Asignación",
                name: 'fecha_asignacion',
                allowBlank: false,
                //anchor: '100%',
                width: 177,
                gwidth: 150,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'UOFUNC.fecha_asignacion',
                type:'date'
            },
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                fieldLabel: "Fecha Finalización",
                name: 'fecha_finalizacion',
                allowBlank: true,
                width: 177,
                gwidth: 150,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'UOFUNC.fecha_finalizacion',
                type:'date'
            },
            id_grupo:0,
            grid:true,

            form:true
        },

		  {
   			config:{
       		    name:'id_funcionario',
   				origen:'FUNCIONARIO',
   				gwidth: 350,
   				fieldLabel:'Funcionario',
   				allowBlank:false,
   				tinit:true,  				
   				valueField: 'id_funcionario',
   			    gdisplayField: 'desc_funcionario1',
                url: '../../sis_organigrama/control/Funcionario/listarSinAsignacionFuncionario',
                tpl: new Ext.XTemplate([
                    '<tpl for=".">',
                    '<div class="x-combo-list-item">',
                    '<div class="awesomecombo-item {checked}">',
                    '<p><b style="color: #51adff;">{desc_person}</b></p>',
                    '</div><p><b>Codigo: </b> <span style="color: green;">{codigo}</span> </p>',
                    '<p><b>CI: </b> <span style="color: green;">{ci}</span></p>',
                    '</div></tpl>'
                ]),
      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario1']);}
       	     },
   			type:'ComboRec',//ComboRec
   			id_grupo:0,
   			filters:{
   			    pfiltro:'funcio.desc_funcionario1',
				type:'string'
			},
            bottom_filter: true,
   			grid:true,
   			form:true
   	      },
   	      
   	      {
			config: {
				name: 'id_cargo',
				fieldLabel: 'Item a Asignar',
				allowBlank: false,
				tinit:true,
   			    resizable:true,
   			    tasignacion:true,
   			    tname:'id_cargo',
		        tdisplayField:'nombre',   				
   				turl:'../../../sis_organigrama/vista/cargo/Cargo.php',
	   			ttitle:'Cargos',
	   			tconfig:{width:'80%',height:'90%'},
	   			tdata:{},
	   			tcls:'Cargo',
	   			pid:this.idContenedor,
				emptyText: 'Cargo...',
				store: new Ext.data.JsonStore({
					url: '../../sis_organigrama/control/Cargo/listarCargo',
					id: 'id_cargo',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_cargo', 'nombre', 'codigo','tipo_contrato','identificador','codigo_tipo_contrato','haber_basico','nombre_escala'],
					remoteSort: true,
					baseParams: {par_filtro: 'cargo.nombre#cargo.codigo'}
				}),
				valueField: 'id_cargo',
				displayField: 'nombre',
				gdisplayField: 'desc_cargo',
				hiddenName: 'id_cargo',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				//tpl:'<tpl for="."><div class="x-combo-list-item"><p>Id: {identificador}--{codigo_tipo_contrato}</p><p>{codigo}</p><p>{nombre}</p> </div></tpl>',
                tpl: new Ext.XTemplate([
                    '<tpl for=".">',
                    '<div class="x-combo-list-item">',
                    '<div class="awesomecombo-item {checked}">',
                    '<p><b style="color: #51adff;">{nombre}</b></p>',
                    '</div><p><b>Item: </b> <span style="color: green;">{codigo}</span>   <b>Contrato: </b><span style="color: green;">{codigo_tipo_contrato}</span></p>',
                    '<p><b>Identificador: </b> <span style="color: green;">{identificador}</span></p>',
                    '<p><b>Escala: </b> <span style="color: green;">{nombre_escala}</span></p>',
                    '<p><b>Haber B.: </b><span style="color: green;">{haber_basico}</span></p>',
                    '</div></tpl>'
                ]),
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_cargo']);
				}
			},
			type: 'TrigguerCombo',
			id_grupo: 0,
			filters: {pfiltro: 'cargo.nombre#cargo.codigo#cargo.id_cargo',type: 'string'},
			grid: true,
			form: true
		},

		{
			config:{
				name: 'nro_documento_asignacion',
				fieldLabel: 'N° Memo de Asignación',
				allowBlank: true,
				anchor: '100%',
				gwidth: 200,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'UOFUNC.nro_documento_asignacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
		config:{
			fieldLabel: "Fecha Memo de Asignación",
			name: 'fecha_documento_asignacion',
   		    allowBlank: true,
			anchor: '100%',
			gwidth: 150,
			format: 'd/m/Y', 
			renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
		},
		type:'DateField',
		filters:{
		    pfiltro:'UOFUNC.fecha_documento_asignacion',
            type:'date'
        },
        id_grupo:1,
		grid:true,		
		form:true
	},

        {
            config:{
                name: 'certificacion_presupuestaria',
                fieldLabel: 'N° Certificación Presupuestaria',
                allowBlank: true,
                anchor: '100%',
                gwidth: 200,
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'UOFUNC.certificacion_presupuestaria',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },

        {
            config:{
                name: 'codigo_ruta',
                fieldLabel: 'Codigo Referencia/Ruta',
                allowBlank: true,
                anchor: '100%',
                gwidth: 200,
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'UOFUNC.codigo_ruta',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },

       	{
			config:{
				fieldLabel: "CI",
				gwidth: 130,
				name: 'ci',
				allowBlank:false,	
				maxLength:150,
				minLength:5,
				anchor:'100%'
			},
			type:'TextField',
			filters:{pfiltro:'FUNCIO.ci',type:'string'},
			id_grupo:0,
			grid:true,
			form:false
		},	

	
	{
			config:{
				name: 'observaciones_finalizacion',
				fieldLabel: 'Motivo Finalización',
				allowBlank: false,
				emptyText:'Motivo...',
	       		typeAhead: true,
	       		triggerAction: 'all',
	       		lazyRender:true,
	       		mode: 'local',
				gwidth: 150,
                anchor:'100%',
				store:['ampliacion','cambio_partida','desistimiento','fallecimiento','fin contrato','jubilacion','promocion','retiro','renuncia', 'renuncia_tacita' ,'transferencia', 'desvinculación']
			},
				type:'ComboBox',
				filters:{	
	       		         type: 'list',
	       				 options: ['ampliacion','cambio_partida','desistimiento','fallecimiento','fin contrato','jubilacion','promocion','retiro','renuncia','renuncia_tacita','transferencia', 'desvinculación'],
	       		 	},
				id_grupo:0,
				grid:true,
				form:true
		},

        {
            config:{
                name: 'estado_funcional',
                fieldLabel: 'Estado Funcional',
                allowBlank: false,
                emptyText:'Estado...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                gwidth: 100,
                anchor:'100%',
                store:['activo','inactivo']
            },
            type:'ComboBox',
            filters:{
                type: 'list',
                options: ['ampliacion','cambio_partida'],
            },
            id_grupo:0,
            grid:true,
            form:true
        },


        {
			config:{
				name:'estado_reg',
				fieldLabel:'Estado',				
				gwidth:115,			
				
			},
			type:'ComboBox',
			grid:true,			
			form:false,
            grid:true
		}
		],

    Grupos: [
        {
            layout: 'column',
            border: false,
            labelAlign: 'top',
            defaults: {
                border: false
            },

            items: [
                {
                    bodyStyle: 'padding-right:10px;',
                    items: [

                        {
                            xtype: 'fieldset',
                            title: '<b style="color: green;">DATOS DE ASIGNACIÓN<b>',
                            autoHeight: true,
                            items: [],
                            id_grupo: 0
                        }

                    ]
                },
                {
                    bodyStyle: 'padding-right:10px;',
                    items: [
                        {
                            xtype: 'fieldset',
                            title: '<b style="color: green;">DOCUMENTOS DE ASIGNACIÓN<b>',
                            autoHeight: true,
                            items: [],
                            id_grupo: 1
                        }
                    ]
                }

            ]
        }
    ],

	title:'Asignar Cargo',
	fheight:'70%',
	fwidth:'40%',
	ActSave:'../../sis_organigrama/control/UoFuncionario/GuardarUoFuncionario',
	ActDel:'../../sis_organigrama/control/UoFuncionario/EliminarUoFuncionario',
	ActList:'../../sis_organigrama/control/UoFuncionario/ListarUoFuncionario',
	id_store:'id_uo_funcionario',
	fields: ['id_uo_funcionario',
             'id_uo',
             'id_funcionario',
             'codigo',
             'ci',
             'id_cargo',
             'desc_cargo',
             'observaciones_finalizacion',
             'nro_documento_asignacion',
             {name:'fecha_documento_asignacion', type: 'date',dateFormat:'Y-m-d'},
             'tipo',
             'desc_funcionario1',
             'desc_person',
             'num_doc',
             {name:'fecha_asignacion', type: 'date',dateFormat:'Y-m-d'},
             'estado_reg',
             {name:'fecha_finalizacion', type: 'date',dateFormat:'Y-m-d'},
             'fecha_reg',
             'fecha_mod',
             'USUREG',
             'USUMOD','correspondencia','codigo_ruta','estado_funcional','certificacion_presupuestaria','nombre_escala','haber_basico'],
	sortInfo:{
		field: 'desc_funcionario1',
		direction: 'ASC',
	},	
	onButtonNew:function(){ //this.window.items.items[0].body.dom.style.background = 'linear-gradient(45deg, #a7cfdf 0%,#a7cfdf 100%,#23538a 100%)';
		this.Cmp.id_funcionario.store.setBaseParam('tipo','oficial');
        this.Cmp.id_cargo.store.setBaseParam('tipo','oficial');
		//llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
		this.mostrarComponente(this.Cmp.id_cargo);
		this.mostrarComponente(this.Cmp.id_funcionario);
		this.mostrarComponente(this.Cmp.fecha_asignacion);
		this.mostrarComponente(this.Cmp.tipo);
		//this.mostrarComponente(this.Cmp.estado_funcional);
		//this.ocultarComponente(this.Cmp.fecha_finalizacion);

		this.ocultarComponente(this.Cmp.observaciones_finalizacion);
		Phx.vista.uo_funcionario.superclass.onButtonNew.call(this);
		//seteamos un valor fijo que vienen de la vista maestro para id_gui 
		
		
	},onButtonEdit:function(){
		//llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
		this.ocultarComponente(this.Cmp.id_cargo);
		this.ocultarComponente(this.Cmp.id_funcionario);
		//this.ocultarComponente(this.Cmp.fecha_asignacion);
		this.ocultarComponente(this.Cmp.tipo);
		this.mostrarComponente(this.Cmp.fecha_finalizacion);
		//this.mostrarComponente(this.Cmp.estado_funcional);
		this.getComponente('fecha_finalizacion').visible=true;

		Phx.vista.uo_funcionario.superclass.onButtonEdit.call(this);

        this.getComponente('fecha_asignacion').setMinValue(new Date(2007,12,31));

		if (this.Cmp.fecha_finalizacion.getValue() == '' || this.Cmp.fecha_finalizacion.getValue() == undefined || this.Cmp.fecha_finalizacion.getValue() == null) {
			this.Cmp.observaciones_finalizacion.reset();
			this.Cmp.observaciones_finalizacion.allowBlank = true;
			this.ocultarComponente(this.Cmp.observaciones_finalizacion);
		} else {
			this.Cmp.observaciones_finalizacion.allowBlank = false;
			this.mostrarComponente(this.Cmp.observaciones_finalizacion);
		}
	},
	
	/*funcion corre cuando el padre cambia el nodo maestero*/
	onReloadPage:function(m){       
		this.maestro=m;
		this.Atributos[1].valorInicial=this.maestro.id_uo;
		this.Cmp.id_cargo.tdata.id_uo = this.maestro.id_uo;
		this.Cmp.id_funcionario.tdata.id_uo = this.maestro.id_uo;
		this.Cmp.id_cargo.store.setBaseParam('id_uo',this.maestro.id_uo);
		this.Cmp.id_funcionario.store.setBaseParam('id_uo',this.maestro.id_uo);
 
       if(m.id != 'id'){	

		this.store.baseParams={id_uo:this.maestro.id_uo};
		this.load({params:{start:0, limit:50}})
       
       }
       else{
    	 this.grid.getTopToolbar().disable();
   		 this.grid.getBottomToolbar().disable(); 
   		 this.store.removeAll(); 
    	   
       }


	},
	loadValoresIniciales:function()
    {	
        this.Cmp.tipo.setValue('oficial');  
        this.Cmp.tipo.fireEvent('select',this.Cmp.tipo);     
        Phx.vista.uo_funcionario.superclass.loadValoresIniciales.call(this);
    },
	iniciarEventos : function () {
		this.Cmp.id_cargo.on('focus',function () {
			if (this.Cmp.fecha_asignacion.getValue() == '' || this.Cmp.fecha_asignacion.getValue() == undefined) {
				alert('Debe seleccionar la fecha de asignación');
				return false;
			} else {
				return true;
			}
			
		},this);
				
		this.Cmp.id_funcionario.on('focus',function () {
			if (this.Cmp.fecha_asignacion.getValue() == '' || this.Cmp.fecha_asignacion.getValue() == undefined) {
				alert('Debe seleccionar la fecha de asignación');
				return false;
			} else {
				return true;
			}
			
		},this);

		this.Cmp.tipo.on('select', function () {
			//Agregar al base params de funcionario y cargo
			this.Cmp.id_funcionario.store.setBaseParam('tipo',this.Cmp.tipo.getValue());
			this.Cmp.id_cargo.store.setBaseParam('tipo',this.Cmp.tipo.getValue());
			this.Cmp.id_cargo.tdata.tipo = this.Cmp.tipo.getValue();
			this.Cmp.id_funcionario.tdata.tipo = this.Cmp.tipo.getValue();
			
		},this);

        this.getComponente('fecha_finalizacion').on('beforerender',function (combo) {
            var fecha_actual = new Date();
            fecha_actual.setMonth(fecha_actual.getMonth());
            //this.getComponente('fecha_finalizacion').setMinValue(new Date(fecha_actual.getFullYear(),fecha_actual.getMonth()-1,1));
        }, this);
		
		this.Cmp.fecha_finalizacion.on('blur', function () {
			//Habilitar y obligar a llenar observaciones de finalizacion si la fecha no es null
			if (this.Cmp.fecha_finalizacion.getValue() == '' || this.Cmp.fecha_finalizacion.getValue() == undefined) {
				this.Cmp.observaciones_finalizacion.reset();
				this.Cmp.observaciones_finalizacion.allowBlank = true;
				this.ocultarComponente(this.Cmp.observaciones_finalizacion);
			} else {
				this.Cmp.observaciones_finalizacion.allowBlank = false;
				this.mostrarComponente(this.Cmp.observaciones_finalizacion);
			}
			
		},this);

        this.getComponente('fecha_asignacion').on('beforerender',function (combo) {
            var fecha_actual = new Date();
            fecha_actual.setMonth(fecha_actual.getMonth());
            //this.Cmp.fecha_asignacion.setValue(new Date(fecha_actual.getFullYear(),fecha_actual.getMonth(),1));
            //this.getComponente('fecha_asignacion').setMinValue(new Date(fecha_actual.getFullYear(),fecha_actual.getMonth(),1));
        }, this);

		this.Cmp.fecha_asignacion.on('blur', function () {
			this.Cmp.id_cargo.store.setBaseParam('fecha',this.Cmp.fecha_asignacion.getValue().dateFormat('d/m/Y'));
			this.Cmp.id_funcionario.store.setBaseParam('fecha',this.Cmp.fecha_asignacion.getValue().dateFormat('d/m/Y'));
			this.Cmp.id_cargo.tdata.fecha = this.Cmp.fecha_asignacion.getValue().dateFormat('d/m/Y');
			this.Cmp.id_funcionario.tdata.fecha = this.Cmp.fecha_asignacion.getValue().dateFormat('d/m/Y');
			this.Cmp.id_funcionario.modificado = true;
			this.Cmp.id_cargo.modificado = true;			
		},this);
		
		this.Cmp.id_cargo.on('select', function (c,r,i) {
			if (r.data) {
				var data = r.data;
			} else {
				var data = r;
			}			
			//Mostrar fecha de finalizacion y obligar a llenar si no es de planta si es limpiar fecha_finalizacion, ocultar y habilitar null
			if(data.codigo_tipo_contrato == 'PLA') {
				this.Cmp.fecha_finalizacion.reset();
				this.Cmp.fecha_finalizacion.allowBlank = true;
				this.ocultarComponente(this.Cmp.fecha_finalizacion);
			} else {
				this.Cmp.fecha_finalizacion.allowBlank = false;
				this.mostrarComponente(this.Cmp.fecha_finalizacion);
			}
			
		},this);

        this.Cmp.estado_funcional.on('render', function(cmb){
            var store = cmb.getStore();
            var fila= cmb.getStore(0).getAt(0);//selecciono primera fila
            cmb.setValue(fila.data.field1);//ingreso el value del combo


        }, this);
		
		
	},
	
	constructor: function(config){
		// configuracion del data store		
		this.maestro=config.maestro;		
		//this.Atributos[1].valorInicial=this.maestro.id_gui;
		Phx.vista.uo_funcionario.superclass.constructor.call(this,config);
		txt_fecha_fin=this.getComponente('fecha_finalizacion');
        //this.grid.topToolbar.el.dom.style.background="#89CBE0";

		this.init();
		//this.tbar.el.dom.style.background='#5fe0f7';

		this.iniciarEventos();
		//deshabilita botones
		this.grid.getTopToolbar().disable();
		this.grid.getBottomToolbar().disable();	

	},
	
	bdel:true,// boton para eliminar
	bsave:false,// boton para eliminar
	// sobre carga de funcion
	preparaMenu:function(tb){
		// llamada funcion clace padre
		Phx.vista.uo_funcionario.superclass.preparaMenu.call(this,tb)
	}
	

  }
)
</script>