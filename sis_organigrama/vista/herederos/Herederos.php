<?php
/**
 *@package pXP
 *@file gen-Herederos.php
 *@author  (franklin.espinoza)
 *@date 16-07-2021 14:16:29
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Herederos=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.Herederos.superclass.constructor.call(this,config);

                this.store.baseParams.id_funcionario = this.maestro.id_funcionario;
                this.init();
                this.iniciarEventos();
                this.load({params:{start:0, limit:this.tam_pag}})
            },
            fwidth: '90%',
            fheight: '70%',
            bsave : false,
            btest : false,
            onButtonNew : function () {
                //this.store.baseParams.id_funcionario = this.maestro.id_funcionario;
                Phx.vista.Herederos.superclass.onButtonNew.call(this);
                this.Cmp.id_funcionario.setValue(this.maestro.id_funcionario);
            },
            onButtonEdit: function(){
                //this.store.baseParams.id_funcionario = this.maestro.id_funcionario;
                Phx.vista.Herederos.superclass.onButtonEdit.call(this);
            },

            iniciarEventos: function(){

                //begin
                this.getComponente('genero').on('select',function (combo, record, index ) {
                    if(combo.value == 'varon'){
                        this.getComponente('nacionalidad').setValue('BOLIVIANO');
                    }else{
                        this.getComponente('nacionalidad').setValue('BOLIVIANA');
                    }
                }, this);

                /*this.getComponente('fecha_nacimiento').on('beforerender',function (combo) {
                    var fecha_actual = new Date();
                    fecha_actual.setMonth(fecha_actual.getMonth() - 216);
                    this.getComponente('fecha_nacimiento').setMaxValue(fecha_actual);
                }, this);*/

                this.getComponente('discapacitado').on('select',function (combo, record, index ) {
                    if(combo.value == 'si'){
                        this.getComponente('carnet_discapacitado').setVisible(true);
                    }else{
                        this.getComponente('carnet_discapacitado').setVisible(false);
                    }
                }, this);

                this.getComponente('id_persona').on('select',function(c,record,n){

                    this.getComponente('nombre').setValue(record.data.nombre);
                    this.getComponente('ap_paterno').setValue(record.data.ap_paterno);
                    this.getComponente('ap_materno').setValue(record.data.ap_materno);
                    this.getComponente('fecha_nacimiento').setValue(record.data.fecha_nacimiento);
                    this.getComponente('genero').setValue(record.data.genero);
                    this.getComponente('nacionalidad').setValue(record.data.nacionalidad);
                    this.getComponente('id_lugar').setValue(record.data.id_lugar);
                    this.getComponente('id_lugar').setRawValue(record.data.nombre_lugar);

                    this.getComponente('ci').setValue(record.data.ci);
                    this.getComponente('id_tipo_doc_identificacion').setValue(record.data.id_tipo_doc_identificacion);
                    this.getComponente('expedicion').setValue(record.data.expedicion);
                    this.getComponente('estado_civil').setValue(record.data.estado_civil);
                    this.getComponente('discapacitado').setValue(record.data.discapacitado);
                    this.getComponente('carnet_discapacitado').setValue(record.data.carnet_discapacitado);

                    this.getComponente('direccion').setValue(record.data.direccion);
                    this.getComponente('correo').setValue(record.data.correo);
                    this.getComponente('celular1').setValue(record.data.celular1);
                    this.getComponente('celular2').setValue(record.data.celular2);
                    this.getComponente('telefono1').setValue(record.data.telefono1);
                    this.getComponente('telefono2').setValue(record.data.telefono2);

                },this);
            },

            Grupos: [
                {
                    layout: 'column',
                    //bodyStyle: 'padding-right:10px;',
                    labelWidth: 80,
                    labelAlign: 'top',
                    border: false,
                    items: [
                        {
                            columnWidth: .25,
                            border: false,
                            layout: 'fit',
                            bodyStyle: 'padding-right:10px;',
                            items: [
                                {
                                    xtype: 'fieldset',
                                    title: 'DATOS HEREDERO',

                                    autoHeight: true,
                                    items: [
                                        {
                                            layout: 'form',
                                            anchor: '100%',
                                            //bodyStyle: 'padding-right:10px;',
                                            border: false,
                                            padding: '0 5 0 5',
                                            //bodyStyle: 'padding-left:5px;',
                                            id_grupo: 1,
                                            items: []
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            xtype: 'fieldset',
                            title: 'PERSONA',
                            layout: 'column',
                            columnWidth: .73,
                            border: true,
                            //bodyStyle: 'padding-right:10px;',
                            padding: '0 10 0 10',
                            items: [
                                {
                                    columnWidth: .33,
                                    border: false,
                                    layout: 'fit',
                                    bodyStyle: 'padding-right:10px;',
                                    items: [
                                        {
                                            xtype: 'fieldset',
                                            title: 'DATOS IDENTIFICACIÓN',

                                            autoHeight: true,
                                            items: [
                                                {
                                                    layout: 'form',
                                                    anchor: '100%',
                                                    //bodyStyle: 'padding-right:10px;',
                                                    border: false,
                                                    padding: '0 5 0 5',
                                                    //bodyStyle: 'padding-left:5px;',
                                                    id_grupo: 2,
                                                    items: []
                                                }
                                            ]
                                        }
                                    ]
                                },
                                {
                                    columnWidth: .33,
                                    border: false,
                                    layout: 'fit',
                                    bodyStyle: 'padding-right:10px;',
                                    items: [
                                        {
                                            xtype: 'fieldset',
                                            title: 'DATOS CIVILES',

                                            autoHeight: true,
                                            items: [
                                                {
                                                    layout: 'form',
                                                    anchor: '100%',
                                                    //bodyStyle: 'padding-right:10px;',
                                                    border: false,
                                                    padding: '0 5 0 5',
                                                    //bodyStyle: 'padding-left:5px;',
                                                    id_grupo: 3,
                                                    items: []
                                                }
                                            ]
                                        }
                                    ]
                                },
                                {
                                    columnWidth: .34,
                                    border: false,
                                    layout: 'fit',
                                    bodyStyle: 'padding-right:10px;',
                                    items: [
                                        {
                                            xtype: 'fieldset',
                                            title: 'DATOS DE UBICACIÓN',

                                            autoHeight: true,
                                            items: [
                                                {
                                                    layout: 'form',
                                                    anchor: '100%',
                                                    //bodyStyle: 'padding-right:10px;',
                                                    border: false,
                                                    padding: '0 5 0 5',
                                                    //bodyStyle: 'padding-left:5px;',
                                                    id_grupo: 4,
                                                    items: []
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ],
            Atributos:[
                /****************************************************HEREDERO****************************************************/
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_herederos'
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
                        name: 'benefactor',
                        fieldLabel: 'Benefactor',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 250,
                        maxLength:64,
                        renderer: function (value, p, record){
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                        }
                    },
                    type:'TextField',
                    filters:{pfiltro:'vf.desc_funcionario2',type:'string'},
                    bottom_filter : true,
                    id_grupo:1,
                    grid:true,
                    form:false
                },

                {
                    config:{
                        name:'id_persona',
                        origen:'PERSONA',
                        tinit:true,
                        allowBlank: true,
                        fieldLabel:'Nombre Heredero',
                        gdisplayField:'desc_person',//mapea al store del grid
                        anchor: '100%',
                        gwidth:200,
                        store: new Ext.data.JsonStore({
                            url: '../../sis_seguridad/control/Persona/listarPersona',
                            id: 'id_persona',
                            root: 'datos',
                            sortInfo:{
                                field: 'nombre_completo1',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_persona','nombre_completo1','ci','tipo_documento','num_documento','expedicion','nombre','ap_paterno','ap_materno',
                                'correo','celular1','telefono1','telefono2','celular2',{name:'fecha_nacimiento', type: 'date', dateFormat:'Y-m-d'},
                                'genero','direccion','id_lugar', 'estado_civil', 'discapacitado', 'carnet_discapacitado','nacionalidad', 'nombre_lugar','id_tipo_doc_identificacion'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {par_filtro:'p.nombre_completo1#p.ci', es_funcionario:'si'}
                        }),
                        renderer:function (value, p, record){return String.format('<div style="color: green; font-weight: bold;">{0}</div>', record.data['desc_person']);},
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><b>{nombre_completo1}</b></p>',
                            '</div><p><b>CI:</b> <span style="color: green;">{ci} {expedicion}</span></p>',
                            '</div></tpl>'
                        ]),
                    },
                    type:'ComboRec',
                    id_grupo:1,
                    bottom_filter : true,
                    filters:{
                        pfiltro:'person.nombre_completo2',
                        type:'string'
                    },

                    grid:true,
                    form:true
                },

                {
                    config:{
                        name: 'parentesco',
                        fieldLabel: 'Parentesco',
                        allowBlank:true,
                        emptyText:'Parentesco...',

                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['heredero'],
                        editable: false,
                        hidden : true,
                        value: 'heredero'

                    },
                    type:'ComboBox',
                    id_grupo:1,
                    filters:{pfiltro:'here.parentesco',type:'string'},
                    grid:true,
                    form:true
                },

                {
                    config:{
                        name: 'edad',
                        fieldLabel: 'Edad',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'NumberField',
                    filters:{pfiltro:'here.edad',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                /****************************************************HEREDERO****************************************************/
                /****************************************************PERSONA****************************************************/
                {
                    config:{
                        fieldLabel: "Nombre",
                        gwidth: 130,
                        name: 'nombre',
                        allowBlank:false,
                        maxLength:150,
                        minLength:2,
                        anchor:'100%',
                        msgTarget: 'side'
                    },
                    type:'TextField',
                    filters:{type:'string'},
                    //bottom_filter : true,
                    id_grupo:2,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Apellido Paterno",
                        gwidth: 130,
                        name: 'ap_paterno',
                        allowBlank:true,
                        maxLength:150,

                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{pfiltro:'p.apellido_paterno',type:'string'},
                    //bottom_filter : true,
                    id_grupo:2,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Apellido Materno",
                        gwidth: 130,
                        name: 'ap_materno',
                        allowBlank:true,
                        maxLength:150,
                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{pfiltro:'p.apellido_materno',type:'string'},//p.apellido_paterno
                    //bottom_filter : true,
                    id_grupo:2,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Fecha de Nacimiento",
                        gwidth: 120,
                        name: 'fecha_nacimiento',
                        allowBlank:false,
                        maxLength:100,
                        minLength:1,
                        format:'d/m/Y',
                        anchor:'100%',
                        msgTarget: 'side',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{type:'date'},
                    id_grupo:2,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        name:'genero',
                        fieldLabel:'Genero',
                        allowBlank:true,
                        emptyText:'Genero...',

                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['varon','mujer']

                    },
                    type:'ComboBox',
                    id_grupo:2,
                    filters:{
                        type: 'list',
                        options: ['varon','mujer']
                    },
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Nacionalidad",
                        gwidth: 120,
                        name: 'nacionalidad',
                        allowBlank:true,
                        maxLength:200,
                        minLength:1,
                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{type:'string'},
                    //bottom_filter : true,
                    id_grupo:2,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        name: 'id_lugar',
                        fieldLabel: 'Lugar Nacimiento',
                        allowBlank: true,
                        emptyText:'Lugar...',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_parametros/control/Lugar/listarLugar',
                                id: 'id_lugar',
                                root: 'datos',
                                sortInfo:{
                                    field: 'nombre',
                                    direction: 'ASC'
                                },
                                totalProperty: 'total',
                                fields: ['id_lugar','id_lugar_fk','codigo','nombre','tipo','sw_municipio','sw_impuesto','codigo_largo'],
                                // turn on remote sorting
                                remoteSort: true,
                                baseParams:{par_filtro:'lug.nombre',es_regional:'si'}
                            }),
                        valueField: 'id_lugar',
                        displayField: 'nombre',
                        gdisplayField:'nombre_lugar',
                        hiddenName: 'id_lugar',
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:50,
                        queryDelay:500,
                        anchor:"100%",
                        gwidth:150,
                        minChars:2,
                        renderer:function (value, p, record){return String.format('{0}', record.data['nombre_lugar']);}
                    },
                    type:'ComboBox',
                    filters:{pfiltro:'lug.nombre',type:'string'},
                    id_grupo:2,
                    grid:false,
                    form:true
                },

                {
                    config:{
                        name:'id_tipo_doc_identificacion',
                        fieldLabel:'Tipo Documento',
                        allowBlank:false,
                        emptyText:'Seleccione una opción',
                        msgTarget: 'side',
                        store:new Ext.data.JsonStore(
                            {
                                url: '../../sis_seguridad/control/Persona/listarDocumentoIdentificacion',
                                id: 'id_tipo_doc_identificacion',
                                root: 'datos',
                                sortInfo:{
                                    field: 'nombre',
                                    direction: 'ASC'
                                },
                                totalProperty: 'total',
                                fields: ['id_tipo_doc_identificacion','nombre', 'descripcion'],
                                // turn on remote sorting
                                remoteSort: true,
                                baseParams:{par_filtro:'nombre#descripcion'}
                            }),
                        valueField: 'id_tipo_doc_identificacion',
                        displayField: 'nombre',
                        gdisplayField:'nombre',
                        hiddenName: 'id_tipo_doc_identificacion',
                        forceSelection : true,
                        typeAhead : false,
                        triggerAction : 'all',
                        lazyRender : true,
                        mode : 'remote',
                        pageSize : 10,
                        queryDelay : 1000,
                        anchor : '100%',
                        gwidth : 250,
                        minChars : 2,
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['tipo_documento']);
                        },
                        enableMultiSelect : false,
                        resizable: true,
                        tpl: new Ext.XTemplate([
                            '<tpl for=".">',
                            '<div class="x-combo-list-item">',
                            '<div class="awesomecombo-item {checked}">',
                            '<p><b>Nombre: {nombre}</b></p>',
                            '</div><p><b>Descripción: </b> <span style="color: green;">{descripcion}</span></p>',
                            '</div></tpl>'
                        ])
                    },
                    type:'AwesomeCombo',
                    id_grupo:3,
                    filters:{
                        type: 'string',
                        pfiltro:'td.nombre'
                    },
                    grid:false,
                    form:true
                },

                {
                    config:{
                        fieldLabel: "Nro. Documento",
                        gwidth: 120,
                        name: 'ci',
                        allowBlank:false,
                        maxLength:20,
                        minLength:1,
                        msgTarget: 'side',
                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{pfiltro:'person.ci', type:'string'},
                    id_grupo:3,
                    bottom_filter : false,
                    grid:true,
                    form:true
                },

                {
                    config:{
                        name:'expedicion',
                        fieldLabel:'Expedido en',
                        allowBlank:true,
                        emptyText:'Expedido en...',

                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['CB','LP','BN','CJ','PT','CH','TJ','SC','OR','OTRO']

                    },
                    type:'ComboBox',
                    id_grupo:3,
                    filters:{
                        type: 'list',
                        options: ['CB','LP','BN','CJ','PT','CH','TJ','SC','OR','OTRO'],
                    },
                    grid:false,
                    form:true
                },
                {
                    config:{
                        name:'estado_civil',
                        fieldLabel:'Estado Civil',
                        allowBlank:true,
                        emptyText:'Estado...',

                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['soltero','casado','divorciado','viudo']

                    },
                    type:'ComboBox',
                    id_grupo:3,
                    filters:{
                        type: 'list',
                        options: ['soltero','casado','divorciado','viudo']
                    },
                    grid:false,
                    form:true
                },


                {
                    config:{
                        name:'discapacitado',
                        fieldLabel:'Discapacitado',
                        allowBlank:true,
                        emptyText:'Discapacitado...',

                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['no','si']

                    },
                    type:'ComboBox',
                    id_grupo:3,
                    filters:{
                        type: 'list',
                        options:['no','si']
                    },
                    grid:false,
                    form:true
                },

                {
                    config:{
                        fieldLabel: "Carnet Discapacitado",
                        gwidth: 120,
                        name: 'carnet_discapacitado',
                        allowBlank:true,
                        maxLength:100,
                        minLength:1,
                        anchor:'100%',
                        hidden:true
                    },
                    type:'TextField',
                    filters:{type:'string'},
                    bottom_filter : false,
                    id_grupo:3,
                    grid:false,
                    form:true
                },

                {
                    config:{
                        name: 'telefono_ofi',
                        fieldLabel: "Telf. Oficina",
                        gwidth: 120,
                        allowBlank:true,
                        maxLength:50,
                        minLength:1,
                        anchor:'100%',
                        renderer: function (value, p, record){
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                        }
                    },
                    type:'TextField',
                    filters:{type:'string'},
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        fieldLabel: "Teléfono 1",
                        gwidth: 120,
                        name: 'telefono1',
                        allowBlank:true,
                        maxLength:100,
                        minLength:1,
                        anchor:'100%'
                    },
                    type:'NumberField',
                    filters:{type:'string'},
                    id_grupo:4,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Celular 1",
                        gwidth: 120,
                        name: 'celular1',
                        allowBlank:true,

                        maxLength:100,
                        minLength:1,
                        anchor:'100%'
                    },
                    type:'NumberField',
                    filters:{type:'string'},
                    id_grupo:4,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Correo",
                        gwidth: 120,
                        name: 'correo',
                        allowBlank:true,
                        vtype:'email',
                        maxLength:50,
                        minLength:1,
                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{
                        pfiltro: 'person.correo',
                        type:'string'
                    },
                    id_grupo:4,
                    bottom_filter : false,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Telefono 2",
                        gwidth: 120,
                        name: 'telefono2',
                        allowBlank:true,
                        maxLength:15,
                        minLength:5,
                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{type:'string'},
                    id_grupo:4,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Celular 2",
                        gwidth: 120,
                        name: 'celular2',
                        allowBlank:true,
                        maxLength:15,
                        minLength:5,
                        anchor:'100%'
                    },
                    type:'TextField',
                    filters:{type:'string'},
                    id_grupo:4,
                    grid:false,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Dirección",
                        gwidth: 80,
                        name: 'direccion',
                        allowBlank:true,
                        maxLength:10000,
                        minLength:5,
                        anchor:'100%'
                    },
                    type:'TextArea',
                    filters:{type:'string'},
                    id_grupo:4,
                    grid:false,
                    form:true
                },
                /****************************************************PERSONA****************************************************/
                /****************************************************INFORMACION REGISTRO****************************************************/
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
                    filters:{pfiltro:'here.estado_reg',type:'string'},
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
                        name: 'fecha_reg',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'here.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'here.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
                /****************************************************INFORMACION REGISTRO****************************************************/
            ],
            tam_pag:50,
            title:'Herederos',
            ActSave:'../../sis_organigrama/control/Herederos/insertarHerederos',
            ActDel:'../../sis_organigrama/control/Herederos/eliminarHerederos',
            ActList:'../../sis_organigrama/control/Herederos/listarHerederos',
            id_store:'id_herederos',
            fields: [
                /*******************************HEREDERO*******************************/
                {name:'id_herederos', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'nombres', type: 'string'},
                {name:'apellido_paterno', type: 'string'},
                {name:'apellido_materno', type: 'string'},
                {name:'parentesco', type: 'string'},
                {name:'edad', type: 'numeric'},
                {name:'nro_documento', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'benefactor', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                /*******************************HEREDERO*******************************/
                /*******************************PERSONA*******************************/
                {name:'nombre', type: 'string'},
                {name:'ap_paterno', type: 'string'},
                {name:'ap_materno', type: 'string'},
                {name:'fecha_nacimiento', type: 'date',dateFormat:'Y-m-d'},
                {name:'genero', type: 'string'},
                {name:'nacionalidad', type: 'string'},
                {name:'id_lugar', type: 'numeric'},
                {name:'id_tipo_doc_identificacion', type: 'numeric'},
                {name:'ci', type: 'string'},
                {name:'expedicion', type: 'string'},
                {name:'estado_civil', type: 'string'},
                {name:'discapacitado', type: 'string'},
                {name:'telefono1', type: 'string'},
                {name:'celular1', type: 'string'},
                {name:'correo', type: 'string'},
                {name:'telefono2', type: 'string'},
                {name:'celular2', type: 'string'},
                {name:'direccion', type: 'string'},
                {name:'desc_person', type: 'string'},
                {name:'id_persona', type: 'numeric'}
                /*******************************PERSONA*******************************/

            ],
            sortInfo:{
                field: 'id_herederos',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true
        }
    )
</script>
