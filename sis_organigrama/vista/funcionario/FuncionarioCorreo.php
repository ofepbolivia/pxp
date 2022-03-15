<?php
/**
 *@package pXP
 *@file Funcionario.php
 *@author KPLIAN (admin)
 *@date 14-02-2011
 *@description  Vista para registrar los datos de un funcionario
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FuncionarioCorreo=Ext.extend(Phx.gridInterfaz,{

        constructor: function(config) {
            this.maestro = config;

            Phx.vista.FuncionarioCorreo.superclass.constructor.call(this,config);
            this.store.baseParams.estado_func = 'todos';
            this.init();


            /*this.load({params:{start:0, limit:50}});*/

            this.addButton('reporte', {
                text: 'Reporte Correos',
                iconCls: 'bfolder',
                disabled: false,
                grupo: [0,1,2],
                handler: this.reporte,
                style: 'background-color: white !important; background-image: none;',
                tooltip: '<b>Reporte Correos</b><br><b>Nos muestra un formulario para generar reporte de los correos de la empresa<br> por estación o todas las oficinas.</br>'
            });

            this.addButton('alta_baja', {
                text: '<b style="color: blue; font-size: 10pt;">Altas y Bajas</b>',
                iconCls: 'bcargo',

                disabled: false,
                handler: this.altasBajas,
                tooltip: '<b>Altas y Bajas</b><br><b>Permite visualizar las altas y bajas de los Funcionarios.</b>',
                grupo: [0,1,2]
            });
        },
        bnewGroups:[],
        beditGroups:[0,1,2],
        bdelGroups:[],
        bactGroups:[0,1,2],
        bexcelGroups:[0,1,2],
        btestGroups:[],

        gruposBarraTareas: [
            {name:  'sin_correo', title: '<h1 style="text-align: center; color: #FF8F85;">SIN CORREOS</h1>',grupo: 0, height: 0} ,
            {name: 'con_correo', title: '<h1 style="text-align: center; color: #00B167;">CON CORREOS</h1>', grupo: 1, height: 1},
            {name: 'inactivo', title: '<h1 style="text-align: center; color: #4682B4;">BAJA</h1>', grupo: 2, height: 1},
        ],

        actualizarSegunTab: function(name, indice){
            this.store.baseParams.correo_func = name;
            this.load({params: {start: 0, limit: 50}});
        },

        onButtonEdit:function() {

            Phx.vista.FuncionarioCorreo.superclass.onButtonEdit.call(this);

            this.Cmp.estado_correo.setVisible(false);
            this.Cmp.estado_correo.setValue('modificar_correo');

        },

        onSubmit: function (o,x, force) {
            Phx.vista.FuncionarioCorreo.superclass.onSubmit.call(this, o);
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
                        columnWidth: .99,
                        border: false,
                        layout: 'fit',
                        bodyStyle: 'padding-right:10px;',
                        items: [
                            {
                                xtype: 'fieldset',
                                title: 'DATOS FUNCIONARIO',

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
                    }
                ]
            }
        ],

        Atributos:[
            {
                // configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_funcionario'
                },
                type:'Field',
                form:true

            },

            {
                // configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'estado_correo',
                    id_grupo:1
                },
                type:'Field',
                form:true

            },

            {
                config:{
                    name:'id_persona',
                    origen:'PERSONA',
                    tinit:true,
                    allowBlank: true,
                    fieldLabel:'Nombre Persona',
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
                            'genero','direccion','id_lugar', 'estado_civil', 'discapacitado', 'carnet_discapacitado','nacionalidad', 'nombre_lugar'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro:'p.nombre_completo1#p.ci', es_funcionario:'si'}
                    }),
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_person']);},
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
                    pfiltro:'PERSON.nombre_completo2',
                    type:'string'
                },

                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Foto",
                    gwidth: 130,
                    inputType:'file',
                    name: 'foto',
                    //allowBlank:true,
                    buttonText: '',
                    maxLength:150,
                    anchor:'100%',
                    renderer:function (value, p, record){
                        if(record.data.nombre_archivo != '' || record.data.extension!='')
                            return String.format('{0}', "<div style='text-align:center'><img src = './../../../uploaded_files/sis_parametros/Archivo/" + record.data.nombre_archivo + "."+record.data.extension+"' align='center' width='70' height='70'/></div>");
                        else
                            return String.format('{0}', "<div style='text-align:center'><img src = '../../../lib/imagenes/NoPerfilImage.jpg' align='center' width='70' height='70'/></div>");
                    },
                    buttonCfg: {
                        iconCls: 'upload-icon'
                    }
                },
                type:'Field',
                sortable:false,
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    fieldLabel: "Correo Empresarial",
                    gwidth: 140,
                    name: 'email_empresa',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    vtype: 'email',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'FUNCIO.email_empresa',type:'string'},
                id_grupo:1,
                bottom_filter : true,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'fecha_asignacion',
                    fieldLabel: 'Fecha Asignación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    renderer:function (value,p,record){
                        valor = value?value.dateFormat('d/m/Y'):''
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', valor);
                    }
                },
                type:'DateField',
                filters:{pfiltro:'tuo.fecha_asignacion',type:'date'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'fecha_finalizacion',
                    fieldLabel: 'Fecha Finalización',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 110,
                    style: 'background-image: none; color:green;',
                    renderer:function (value,p,record){
                        valor = value?value.dateFormat('d/m/Y'):''
                        return String.format('<div style="color: red; font-weight: bold;">{0}</div>', valor);
                    }
                },
                type:'DateField',
                filters:{pfiltro:'tuo.fecha_finalizacion',type:'date'},
                id_grupo:0,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Código",
                    gwidth: 120,
                    name: 'codigo',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: black; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'FUNCIO.codigo',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'id_biometrico',
                    fieldLabel: 'ID Biométrico',
                    allowBlank: true,
                    anchor: '100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    gwidth: 100,
                    maxLength:15,
                    //hidden:true,
                    renderer: function (value, p, record){
                        return String.format('<div style="color: black; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'NumberField',
                bottom_filter : true,
                filters:{pfiltro:'FUNCIO.id_biometrico',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },

            //PERSONA
            {
                config:{
                    fieldLabel: "Nombre",
                    gwidth: 130,
                    name: 'nombre',
                    allowBlank:false,
                    maxLength:150,
                    minLength:2,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                //bottom_filter : true,
                id_grupo:1,
                grid:false,
                form:false
            },
            {
                config:{
                    fieldLabel: "Apellido Paterno",
                    gwidth: 130,
                    name: 'ap_paterno',
                    allowBlank:false,
                    maxLength:150,

                    anchor:'100%'
                },
                type:'TextField',
                filters:{pfiltro:'p.apellido_paterno',type:'string'},
                //bottom_filter : true,
                id_grupo:2,
                grid:false,
                form:false
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
                form:false
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
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{type:'date'},
                id_grupo:2,
                grid:true,
                form:false
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
                    store:['masculino','femenino']

                },
                type:'ComboBox',
                id_grupo:2,
                filters:{
                    type: 'list',
                    options: ['masculino','femenino']
                },
                grid:true,
                form:false
            },
            {
                config:{
                    fieldLabel: "Nacionalidad",
                    gwidth: 120,
                    name: 'nacionalidad',
                    allowBlank:false,
                    maxLength:200,
                    minLength:1,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                //bottom_filter : true,
                id_grupo:2,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'id_lugar',
                    fieldLabel: 'Lugar Nacimiento',
                    allowBlank: false,
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
                grid:true,
                form:false
            },

            {
                config:{
                    name:'tipo_documento',
                    fieldLabel:'Tipo Documento',
                    allowBlank:true,
                    emptyText:'Tipo Doc...',

                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['documento_identidad','pasaporte']

                },
                type:'ComboBox',
                id_grupo:3,
                filters:{
                    type: 'list',
                    options: ['documento_identidad','pasaporte'],
                },
                grid:true,
                valorInicial:'documento_identidad',
                form:false
            },
            {
                config:{
                    fieldLabel: "Nro. Documento",
                    gwidth: 120,
                    name: 'ci',
                    allowBlank:false,
                    maxLength:20,
                    minLength:1,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{pfiltro:'PERSON.ci',
                    type:'string'},
                id_grupo:3,
                bottom_filter : true,
                grid:true,
                form:false
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
                grid:true,
                //valorInicial:'expedicion',
                form:false
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
                grid:true,
                form:false
            },


            {
                config:{
                    name:'discapacitado',
                    fieldLabel:'Discapacitado',
                    allowBlank:false,
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
                grid:true,
                form:false
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
                bottom_filter : true,
                id_grupo:3,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Antiguedad Anterior (meses)",
                    gwidth: 120,
                    name: 'antiguedad_anterior',
                    allowBlank:true,
                    maxLength:3,
                    minLength:1,
                    anchor:'100%'
                },
                type:'NumberField',
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    name: 'telefono_ofi',
                    fieldLabel: "Telf. Oficina",
                    gwidth: 120,
                    allowBlank:true,
                    maxLength:50,
                    minLength:1,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    fieldLabel: "Interno",
                    gwidth: 120,
                    name: 'interno',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Fecha de Ingreso",
                    gwidth: 120,
                    name: 'fecha_ingreso',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    format:'d/m/Y',
                    anchor:'100%',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name:'es_tutor',
                    fieldLabel:'Es Tutor',
                    allowBlank:true,
                    emptyText:'Es Tutor...',

                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']

                },
                type:'ComboBox',
                id_grupo:1,
                filters:{
                    type: 'list',
                    options: ['si','no'],
                },
                grid:true,
                valorInicial:'no',
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
                grid:true,
                form:false
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
                grid:true,
                form:false
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
                grid:true,
                form:false
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
                grid:true,
                form:false
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
                grid:true,
                form:false
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
                    format:'d/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y h:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'ins.fecha_reg',type:'date'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name:'estado_reg',
                    fieldLabel:'Estado',
                    allowBlank:true,
                    emptyText:'Estado...',

                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    valueField: 'estado_reg',
                    store:['activo','inactivo']

                },
                type:'ComboBox',
                id_grupo:1,
                filters:{
                    type: 'list',
                    pfiltro:'FUNCIO.estado_reg',
                    dataIndex: 'size',
                    options: ['activo','inactivo'],
                },
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
                type:'TextField',
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
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y h:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'ins.fecha_mod',type:'date'},
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
                type:'TextField',
                filters:{pfiltro:'usu2.cuenta',type:'string'},
                id_grupo:0,
                grid:true,
                form:false
            }


        ],


        title:'Funcionarios',
        ActSave:'../../sis_organigrama/control/Funcionario/guardarFuncionario',
        ActDel:'../../sis_organigrama/control/Funcionario/eliminarFuncionario',
        ActList:'../../sis_organigrama/control/Funcionario/listarFuncionario',
        id_store:'id_funcionario',
        fields: [
            {name:'id_funcionario'},
            {name:'id_persona'},
            {name:'id_lugar', type: 'numeric'},
            {name:'desc_person',type:'string'},
            {name:'genero',type:'string'},
            {name:'estado_civil',type:'string'},
            {name:'nombre_lugar',type:'string'},
            {name:'nacionalidad',type:'string'},
            {name:'discapacitado',type:'string'},
            {name:'carnet_discapacitado',type:'string'},
            {name:'codigo',type:'string'},
            {name:'antiguedad_anterior',type:'numeric'},

            {name:'estado_reg', type: 'string'},

            {name:'ci', type:'string'},
            {name:'documento', type:'string'},
            {name:'correo', type:'string'},
            {name:'celular1'},
            {name:'telefono1'},
            {name:'email_empresa'},
            'interno',
            {name:'fecha_ingreso', type: 'date', dateFormat:'Y-m-d'},
            {name:'fecha_nacimiento', type: 'date', dateFormat:'Y-m-d'},
            {name:'fecha_reg', type: 'date', dateFormat:'Y-m-d'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_mod', type: 'date', dateFormat:'Y-m-d'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            'telefono_ofi',
            'horario1',
            'horario2',
            'horario3',
            'horario4',
            {name:'id_biometrico', type: 'numeric'},
            {name:'nombre_archivo', type: 'string'},
            {name:'extension', type: 'string'},
            'telefono2',
            'celular2',
            'nombre',
            'ap_paterno',
            'ap_materno',
            'tipo_documento',
            'expedicion',
            'direccion',
            'es_tutor',
            {name:'fecha_asignacion', type: 'date', dateFormat:'Y-m-d'},
            {name:'fecha_finalizacion', type: 'date', dateFormat:'Y-m-d'},
            'nombre_cargo',
            'nombre_oficina',
            'nombre_lugar_ofi'
        ],
        sortInfo:{
            field: 'PERSON.nombre_completo2',
            direction: 'ASC'
        },

        bsave:false,
        fwidth: '30%',
        fheight: '30%',


        preparaMenu:function() {

            //this.getBoton('reporte').enable();
            Phx.vista.FuncionarioCorreo.superclass.preparaMenu.call(this);
        },
        liberaMenu:function() {

            //this.getBoton('reporte').disable();
            Phx.vista.FuncionarioCorreo.superclass.liberaMenu.call(this);
        },

        reporte: function () {

            Phx.CP.loadWindows('../../../sis_organigrama/vista/reporte/CorreosEmpBoa.php',
                'Reporte Correo Funcionarios',
                {
                    width: '50%',
                    height: '50%'
                }, {}, this.idContenedor, 'CorreosEmpBoa');

        },
        altasBajas: function () {
            var rec = this.getSelectedData();
            Phx.CP.loadWindows('../../../sis_organigrama/vista/funcionario/AltasBajasFuncionario.php',
                'Altas y Bajas',
                {
                    width: '80%',
                    height: '100%'
                }, rec, this.idContenedor, 'AltasBajasFuncionario');

        }
    });
</script>