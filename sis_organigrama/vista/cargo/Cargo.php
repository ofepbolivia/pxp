<?php
/**
 *@package pXP
 *@file gen-Cargo.php
 *@author  (admin)
 *@date 14-01-2014 19:16:06
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Cargo=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){

                this.maestro=config;
                //llama al constructor de la clase padre
                Phx.vista.Cargo.superclass.constructor.call(this,config);
                this.loadValoresIniciales();
                this.init();
                this.iniciarEventos();
                this.addButton('btnCostos',
                    {
                        text: 'Centros de Costo',
                        iconCls: 'blist',
                        disabled: true,
                        handler: this.onBtnCostos,
                        tooltip: 'Centros de Costo asociados al cargo'
                    }
                );
                this.store.baseParams.id_uo = this.maestro.id_uo;
                if (this.maestro.fecha) {
                    this.store.baseParams.fecha = this.maestro.fecha;
                }
                if (this.maestro.tipo) {
                    this.store.baseParams.tipo = this.maestro.tipo;
                }
                this.load({params:{start:0, limit:50}});
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_cargo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_uo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        fieldLabel: 'Identificador',
                        name: 'identificador'
                    },
                    type:'Field',
                    form:false,
                    filters:{pfiltro:'cargo.id_cargo',type:'numeric'},
                    grid:true
                },
                {
                    config:{
                        name: 'acefalo',
                        fieldLabel: 'ACEFALO',
                        anchor: '100%',
                        gwidth: 200,
                        renderer: function(value, p, record) {
                            if (record.data['acefalo'] == 'ACEFALO') {
                                return String.format('{0}', '<font color="green">ACEFALO</font>');
                            }else{
                                return String.format('{0}', '<font color="green">'+record.data['acefalo']+'</font>');
                            }
                        }
                    },
                    type:'TextField',
                    id_grupo: 0,
                    grid:true,
                    form:false
                },
                {
                    config: {
                        name: 'id_tipo_contrato',
                        fieldLabel: 'Tipo Contrato',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_organigrama/control/TipoContrato/listarTipoContrato',
                            id: 'id_tipo_contrato',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_tipo_contrato', 'nombre', 'codigo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'tipcon.nombre#tipcon.codigo'}
                        }),
                        valueField: 'id_tipo_contrato',
                        displayField: 'nombre',
                        gdisplayField: 'nombre_tipo_contrato',
                        hiddenName: 'id_tipo_contrato',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '100%',
                        gwidth: 120,
                        minChars: 2,
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['nombre_tipo_contrato']);
                        },
                        msgTarget: 'side'
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'tipcon.nombre',type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config:{
                        name: 'id_oficina',
                        fieldLabel: 'Oficina',
                        allowBlank: false,
                        emptyText:'Oficina...',
                        tinit:true,
                        resizable:true,
                        tasignacion:true,
                        tname:'id_oficina',
                        tdisplayField:'nombre',
                        turl:'../../../sis_organigrama/vista/oficina/Oficina.php',
                        ttitle:'Oficinas',
                        tconfig:{width:'80%',height:'90%'},
                        tdata:{},
                        tcls:'Oficina',
                        pid:this.idContenedor,
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_organigrama/control/Oficina/listarOficina',
                                id: 'id_oficina',
                                root: 'datos',
                                sortInfo:{
                                    field: 'nombre',
                                    direction: 'ASC'
                                },
                                totalProperty: 'total',
                                fields: ['id_oficina','nombre','codigo','nombre_lugar'],
                                // turn on remote sorting
                                remoteSort: true,
                                baseParams:{par_filtro:'ofi.nombre#ofi.codigo#lug.nombre'}
                            }),
                        valueField: 'id_oficina',
                        displayField: 'nombre',
                        gdisplayField:'nombre_oficina',
                        hiddenName: 'id_oficina',
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:50,
                        queryDelay:500,
                        anchor:"100%",
                        gwidth:150,
                        minChars:2,
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><p>{nombre}</p><p>{nombre_lugar}</p> </div></tpl>',
                        renderer:function (value, p, record){return String.format('{0}', record.data['nombre_oficina']);},
                        msgTarget: 'side'
                    },
                    type:'TrigguerCombo',
                    filters:{pfiltro:'ofi.nombre',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config: {
                        name: 'id_temporal_cargo',
                        fieldLabel: 'Nombre Cargo',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_organigrama/control/TemporalCargo/listarTemporalCargo',
                            id: 'id_temporal_cargo',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_temporal_cargo', 'nombre'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'cargo.nombre'}
                        }),
                        valueField: 'id_temporal_cargo',
                        displayField: 'nombre',
                        gdisplayField: 'nombre',
                        hiddenName: 'id_temporal_cargo',
                        forceSelection: false,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '100%',
                        gwidth: 200,
                        minChars: 2,
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['nombre']);
                        },
                        msgTarget: 'side'
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'tcargo.nombre',type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_escala_salarial',
                        fieldLabel: 'Escala Salarial',
                        allowBlank: false,
                        tinit:true,
                        resizable:true,
                        tasignacion:true,
                        tname:'id_escala_salarial',
                        tdisplayField:'nombre',
                        turl:'../../../sis_organigrama/vista/escala_salarial/EscalaSalarial.php',
                        ttitle:'Escalas Salariales',
                        tconfig:{width:'80%',height:'90%'},
                        tdata:{},
                        tcls:'EscalaSalarial',
                        pid:this.idContenedor,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_organigrama/control/EscalaSalarial/listarEscalaSalarial',
                            id: 'id_escala_salarial',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_escala_salarial', 'nombre', 'codigo','haber_basico','tipo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'escsal.haber_basico#escsal.nombre#escsal.codigo'}
                        }),
                        valueField: 'id_escala_salarial',
                        displayField: 'nombre',
                        gdisplayField: 'nombre_escala',
                        hiddenName: 'id_escala_salarial',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '100%',
                        gwidth: 200,
                        minChars: 2,
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p style="color: darkmagenta"><b>Nombre:</b> {nombre} <b>Codigo:</b> {codigo}</p><p style="color:darkgreen"><b>Tipo: </b>{tipo}</p><p style="color: red"><b>Haber Basico: </b> {haber_basico}</p> </div></tpl>',
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['nombre_escala']);
                        },
                        msgTarget: 'side'
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'escsal.nombre',type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config:{
                        name: 'haber_basico',
                        fieldLabel: 'Haber Basico',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:20,
                        msgTarget: 'side'
                    },
                    type:'TextField',
                    filters:{pfiltro:'escsal.haber_basico',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:false,
                    bottom_filter : false
                },
                {
                    config:{
                        name: 'codigo',
                        fieldLabel: 'Item/contrato',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:20,
                        msgTarget: 'side'
                    },
                    type:'TextField',
                    filters:{pfiltro:'cargo.codigo',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:true,
                    bottom_filter : true
                },
                {
                    config:{
                        name: 'fecha_ini',
                        fieldLabel: 'Habilitado Desde',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
                        msgTarget: 'side'
                    },
                    type:'DateField',
                    filters:{pfiltro:'cargo.fecha_ini',type:'date'},
                    id_grupo:0,
                    grid:true,
                    form:true
                },

                {
                    config:{
                        name: 'fecha_fin',
                        fieldLabel: 'Habilitado Hasta',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''},
                        msgTarget: 'side'
                    },
                    type:'DateField',
                    filters:{pfiltro:'cargo.fecha_fin',type:'date'},
                    id_grupo:0,
                    grid:true,
                    form:true
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
                    filters:{pfiltro:'cargo.estado_reg',type:'string'},
                    id_grupo:0,
                    grid:true,
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
                    filters:{pfiltro:'cargo.fecha_reg',type:'date'},
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
                    type:'NumberField',
                    filters:{pfiltro:'usu1.cuenta',type:'string'},
                    id_grupo:0,
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
                    filters:{pfiltro:'cargo.fecha_mod',type:'date'},
                    id_grupo:0,
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
                    type:'NumberField',
                    filters:{pfiltro:'usu2.cuenta',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:false
                },
                /**************************************************PRESUPUESTO**************************************************/
                {
                    config:{
                        name:'id_gestion',
                        fieldLabel: 'Gestion',
                        allowBlank: false,
                        msgTarget: 'side',
                        emptyText:'Gestion...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_parametros/control/Gestion/listarGestion',
                                id: 'id_gestion',
                                root: 'datos',
                                sortInfo:{
                                    field: 'gestion',
                                    direction: 'DESC'
                                },
                                totalProperty: 'total',
                                fields: ['id_gestion','gestion'],
                                // turn on remote sorting
                                remoteSort: true,
                                baseParams:{par_filtro:'gestion'}
                            }),
                        valueField: 'id_gestion',
                        triggerAction: 'all',
                        displayField: 'gestion',
                        hiddenName: 'id_gestion',
                        mode:'remote',
                        pageSize:50,
                        queryDelay:500,
                        listWidth:'240',
                        width:240
                    },
                    type: 'ComboBox',
                    id_grupo: 1,
                    filters: {pfiltro: 'gestion',type: 'string'},
                    grid: false,
                    form: true
                },
                {
                    config:{
                        name:'id_centro_costo',
                        origen:'CENTROCOSTO',
                        fieldLabel: 'Centro de Costos',
                        emptyText : 'Centro Costo...',
                        allowBlank:false,
                        msgTarget: 'side',
                        anchor: '100%',
                        listWidth: null,
                        gwidth:300,
                        baseParams:{filtrar:'grupo_ep'},
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b style="color: green;">{codigo_cc}</b></p><p>Gestion: {gestion}</p><p>Reg: {nombre_regional}</p><p>Fin.: {nombre_financiador}</p><p>Proy.: {nombre_programa}</p><p>Act.: {nombre_actividad}</p><p>UO: {nombre_uo}</p><p style="color: green"><b>Categoria: {categoria}</b></p></div></tpl>',
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_centro_costo']);}

                    },
                    type:'ComboRec',
                    id_grupo:1,
                    form:true,
                    grid:false
                },
                {
                    config:{
                        name:'id_ot',
                        fieldLabel: 'Orden Trabajo',
                        sysorigen:'sis_contabilidad',
                        origen:'OT',
                        allowBlank:false,
                        gwidth:200,
                        anchor: '100%',
                        msgTarget: 'side',
                        listWidth: null,
                        baseParams:{par_filtro:'desc_orden#motivo_orden#codigo'},
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden']);}

                    },
                    type:'ComboRec',
                    id_grupo:1,
                    filters:{pfiltro:'ot.motivo_orden#ot.desc_orden#ot.codigo',type:'string'},
                    grid:false,
                    form:true
                },
                {
                    config:{
                        name: 'porcentaje',
                        fieldLabel: 'Porcentaje',
                        allowBlank: false,
                        width:177,
                        gwidth: 100,
                        maxLength:3,
                        msgTarget: 'side'
                    },
                    type:'NumberField',
                    filters:{pfiltro:'carpre.porcentaje',type:'numeric'},
                    id_grupo:1,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_ini_cc',
                        fieldLabel: 'Fecha Aplicación',
                        allowBlank: false,
                        //anchor: '80%',
                        width: 177,
                        gwidth: 150,
                        format: 'd/m/Y',
                        msgTarget: 'side',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'carpre.fecha_ini',type:'date'},
                    id_grupo:1,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_fin_cc',
                        fieldLabel: 'Fecha Finalización',
                        allowBlank: true,
                        //anchor: '80%',
                        width: 177,
                        gwidth: 150,
                        format: 'd/m/Y',
                        msgTarget: 'side',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'carpre.fecha_fin',type:'date'},
                    id_grupo:1,
                    grid:false,
                    form:true
                }
                /**************************************************PRESUPUESTO**************************************************/
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
                            columnWidth: .50,
                            border: false,
                            layout: 'fit',
                            bodyStyle: 'padding-right:10px;',
                            items: [

                                {
                                    xtype: 'fieldset',
                                    title: '<b style="color: green;">DATOS ITEM<b>',
                                    autoHeight: true,
                                    items: [],
                                    id_grupo: 0
                                }

                            ]
                        },
                        {
                            columnWidth: .50,
                            border: false,
                            layout: 'fit',
                            bodyStyle: 'padding-right:10px;',
                            items: [
                                {
                                    xtype: 'fieldset',
                                    title: '<b style="color: green;">DATOS PRESUPUESTO<b>',
                                    autoHeight: true,
                                    items: [],
                                    id_grupo: 1
                                }
                            ]
                        }
                    ]
                }
            ],
            fwidth: 800,
            fheight: 500,
            tam_pag:50,
            title:'Cargo',
            ActSave:'../../sis_organigrama/control/Cargo/insertarCargo',
            ActDel:'../../sis_organigrama/control/Cargo/eliminarCargo',
            ActList:'../../sis_organigrama/control/Cargo/listarCargo',
            id_store:'id_cargo',
            fields: [
                {name:'id_cargo', type: 'numeric'},
                {name:'id_uo', type: 'numeric'},
                {name:'id_tipo_contrato', type: 'numeric'},
                {name:'id_lugar', type: 'numeric'},
                {name:'id_oficina', type: 'numeric'},
                {name:'id_temporal_cargo', type: 'numeric'},
                {name:'id_escala_salarial', type: 'numeric'},
                {name:'codigo', type: 'string'},
                {name:'nombre', type: 'string'},
                {name:'nombre_tipo_contrato', type: 'string'},
                {name:'codigo_tipo_contrato', type: 'string'},
                {name:'nombre_escala', type: 'string'},
                {name:'nombre_oficina', type: 'string'},
                {name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
                {name:'estado_reg', type: 'string'},
                {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'acefalo', type: 'string'},
                {name:'identificador', type: 'numeric'},
                {name:'haber_basico', type: 'numeric'}

            ],
            sortInfo:{
                field: 'id_cargo',
                direction: 'ASC'
            },
            bdel:true,
            bsave:false,

            bedit:true,
            iniciarEventos : function() {
                //inicio de eventos
                this.Cmp.id_tipo_contrato.on('select',function(x,rec,z){

                    if (rec.data.codigo == 'PLA') {
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.Cmp.fecha_fin.allowBlank = true;
                    } else {
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.Cmp.fecha_fin.allowBlank = false;
                    }

                },this);
                this.Cmp.fecha_ini.on('select',function(com, date){
                    this.Cmp.fecha_ini_cc.setValue(date);
                },this);
                //this.Cmp.fecha_ini_cc.setValue(this.Cmp.fecha_ini.getValue) ;
            },
            loadValoresIniciales:function()
            {	//console.log('this.maestro', this.maestro.nombre_cargo);
                this.Cmp.id_uo.setValue(this.maestro.id_uo);
                //this.Cmp.nombre.setValue(this.maestro.nombre_cargo);
                Phx.vista.Cargo.superclass.loadValoresIniciales.call(this);
            },
            preparaMenu:function()
            {
                this.getBoton('btnCostos').enable();
                Phx.vista.Cargo.superclass.preparaMenu.call(this);
            },
            liberaMenu:function()
            {
                this.getBoton('btnCostos').disable();
                Phx.vista.Cargo.superclass.liberaMenu.call(this);
            },

            onButtonEdit : function () {
                //this.ocultarComponente(this.Cmp.id_escala_salarial);
                this.ocultarComponente(this.Cmp.id_tipo_contrato);

                /***********************presupuesto************************/
                this.ocultarComponente(this.Cmp.id_gestion);
                this.ocultarComponente(this.Cmp.id_centro_costo);
                this.ocultarComponente(this.Cmp.id_ot);
                this.ocultarComponente(this.Cmp.porcentaje);
                this.ocultarComponente(this.Cmp.fecha_ini_cc);
                this.ocultarComponente(this.Cmp.fecha_fin_cc);
                /***********************presupuesto************************/

                Phx.vista.Cargo.superclass.onButtonEdit.call(this);
            },
            onButtonNew : function () {
                this.mostrarComponente(this.Cmp.id_escala_salarial);
                this.mostrarComponente(this.Cmp.id_tipo_contrato);

                /***********************presupuesto************************/
                this.mostrarComponente(this.Cmp.id_gestion);
                this.mostrarComponente(this.Cmp.id_centro_costo);
                this.mostrarComponente(this.Cmp.id_ot);
                this.mostrarComponente(this.Cmp.porcentaje);
                this.mostrarComponente(this.Cmp.fecha_ini_cc);
                this.mostrarComponente(this.Cmp.fecha_fin_cc);
                /***********************presupuesto************************/

                Ext.Ajax.request({
                    url:'../../sis_organigrama/control/Cargo/loadCargoPresupuesto',
                    params:{
                        id_uo : this.maestro.id_uo
                    },
                    success:function(resp){
                        var reg =  (Ext.decode(Ext.util.Format.trim(resp.responseText))).ROOT.datos;
                        console.log('loadCargoPresupuesto',reg);

                        //this.Cmp.id_gestion.setValue(reg.id_gestion);
                        this.Cmp.id_gestion.store.load({params:{start:0, limit:this.tam_pag}, scope:this,callback: function (arr,op,suc) {
                                this.Cmp.id_gestion.setValue(reg.id_gestion);
                            }
                        });
                        this.Cmp.id_centro_costo.store.baseParams.id_gestion = reg.id_gestion;
                        this.Cmp.id_centro_costo.store.baseParams.id_uo = reg.id_uo;

                        this.Cmp.id_centro_costo.store.load({params:{start:0, limit:this.tam_pag}, scope:this,callback: function (arr,op,suc) {
                                this.Cmp.id_centro_costo.setValue(reg.id_centro_costo);
                            }
                        });
                    },
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });

                Phx.vista.Cargo.superclass.onButtonNew.call(this);
            },
            south:{
                url:'../../../sis_organigrama/vista/cargo_presupuesto/CargoPresupuesto.php',
                title:'Asignación de Presupuesto por Cargo',
                height:'50%',
                cls:'CargoPresupuesto'
            },onBtnCostos: function(){
                var rec = {maestro: this.sm.getSelected().data}

                Phx.CP.loadWindows('../../../sis_organigrama/vista/cargo_centro_costo/CargoCentroCosto.php',
                    'Centros de Costo Asignados por Cargo',
                    {
                        width:700,
                        height:450
                    },
                    rec,
                    this.idContenedor,
                    'CargoCentroCosto');
            }
        }
    )
</script>