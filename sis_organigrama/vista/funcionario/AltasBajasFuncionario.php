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

<style type="text/css" rel="stylesheet">
    .x-selectable,
    .x-selectable * {
        -moz-user-select: text !important;
        -khtml-user-select: text !important;
        -webkit-user-select: text !important;
    }

    .x-grid-row td,
    .x-grid-summary-row td,
    .x-grid-cell-text,
    .x-grid-hd-text,
    .x-grid-hd,
    .x-grid-row,

    .x-grid-row,
    .x-grid-cell,
    .x-unselectable
    {
        -moz-user-select: text !important;
        -khtml-user-select: text !important;
        -webkit-user-select: text !important;
    }
</style>

<script>
    Phx.vista.AltasBajasFuncionario=Ext.extend(Phx.gridInterfaz,{
        viewConfig: {
            stripeRows: false,
            getRowClass: function(record) {
                return "x-selectable";
            }
        },
        constructor: function(config) {
            this.maestro = config;

            Phx.vista.AltasBajasFuncionario.superclass.constructor.call(this,config);

            this.current_date = new Date();
            this.diasMes = [31, new Date(this.current_date.getFullYear(), 2, 0).getDate(), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            //var fecha_i = new Date((current_date.getMonth()+1)+'/'+'01'+'/'+current_date.getFullYear());
            //var fecha_i = new Date(current_date.getFullYear(),current_date.getMonth(),1);
            //var fecha_f = new Date(current_date.getFullYear(),current_date.getMonth()+1,0);
            console.log('this.diasMes',this.diasMes);

            this.etiqueta_ini = new Ext.form.Label({
                name: 'etiqueta_ini',
                grupo: [0,1],
                fieldLabel: 'Fecha Inicio:',
                text: 'Fecha Inicio:',
                //style: {color: 'green', font_size: '12pt'},
                readOnly:true,
                anchor: '150%',
                gwidth: 150,
                format: 'd/m/Y',
                hidden : false,
                style: 'font-size: 170%; font-weight: bold; background-image: none;color: green;'
            });
            this.fecha_ini = new Ext.form.DateField({
                name: 'fecha_ini',
                grupo: [0,1],
                fieldLabel: 'Fecha',
                allowBlank: false,
                anchor: '60%',
                gwidth: 100,
                format: 'd/m/Y',
                hidden : false,
                disabled:false
            });

            this.etiqueta_fin = new Ext.form.Label({
                name: 'etiqueta_fin',
                grupo: [0,1],
                fieldLabel: 'Fecha Fin',
                text: 'Fecha Fin:',
                //style: {color: 'red', font_size: '12pt'},
                readOnly:true,
                anchor: '150%',
                gwidth: 150,
                format: 'd/m/Y',
                hidden : false,
                style: 'font-size: 170%; font-weight: bold; background-image: none; color: red;'
            });
            this.fecha_fin = new Ext.form.DateField({
                name: 'fecha_fin',
                grupo: [0,1],
                fieldLabel: 'Fecha',
                allowBlank: false,
                anchor: '60%',
                gwidth: 100,
                format: 'd/m/Y',
                hidden : false,
                disabled:false
            });

            /*this.fecha_i = new Date(this.current_date.getFullYear(),this.current_date.getMonth(),1);
            this.fecha_f = new Date(this.current_date.getFullYear(),this.current_date.getMonth()+1,0);
            this.fecha_ini.setValue(this.fecha_i);
            this.fecha_fin.setValue(this.fecha_f);*/

            this.tbar.addField(this.etiqueta_ini);
            this.tbar.addField(this.fecha_ini);
            this.tbar.addField(this.etiqueta_fin);
            this.tbar.addField(this.fecha_fin);
            this.iniciarEventos();
            this.bandera_alta = 0;
            this.bandera_baja = 0;

            this.init();
            //this.store.baseParams.estado_func = 'altas';
            //this.store.baseParams.fecha_ini = this.fecha_ini.getValue();
            //this.store.baseParams.fecha_fin = this.fecha_fin.getValue();
            //this.load({params:{start:0, limit:50}});
        },
        bactGroups:[0,1],
        bexcelGroups:[0,1],
        gruposBarraTareas: [
            {name:  'altas', title: '<h1 style="text-align: center; color: green;"><i class="fa fa-user fa-2x" aria-hidden="true"></i>ALTAS</h1>',grupo: 0, height: 0} ,
            {name: 'bajas', title: '<h1 style="text-align: center; color: red;"><i class="fa fa-user-times fa-2x" aria-hidden="true"></i>BAJAS</h1>', grupo: 1, height: 1}
        ],
        iniciarEventos: function(){
            /*this.fecha_ini.on('select', function () {
                this.val_funcionario = this.Cmp.id_funcionario_recepcion.getRawValue();
            },this);*/

            this.fecha_fin.on('select', function (combo,rec,index) {


                this.store.baseParams.fecha_ini = this.fecha_ini.getValue();
                this.store.baseParams.fecha_fin = this.fecha_fin.getValue();
                console.log('select',this.tabtbar.getActiveTab().name, this.tabtbar.getActiveTab().grupo, this.tabtbar.get(0), this.tabtbar.get(1),this.tabtbar.getActiveTab());
                /*if (this.tabtbar.getActiveTab().name = 'bajas'){
                    this.actualizarSegunTab('alta',0);console.log('entra',this.tabtbar.getActiveTab().name);
                    //this.tabtbar.setActiveTab('altas',0);
                    //this.store.baseParams.estado_func = 'altas';
                }*/

                if(this.tabtbar.getActiveTab().name == 'bajas'){
                    console.log('bajasbajasbajasbajasbajas')

                    //this.tabtbar.get(0).enable();
                    //this.tabtbar.setActiveTab(0);
                    this.store.baseParams.estado_func = 'bajas';
                    var fecha = this.fecha_fin.getValue();
                    this.current_date = new Date(fecha.getFullYear(),fecha.getMonth()+1,1);
                }else{
                    this.store.baseParams.estado_func = 'altas';
                    this.current_date = this.store.baseParams.fecha_fin;
                }

                this.load({params: {start: 0, limit: 50}});
            },this);
        },
        actualizarSegunTab: function(name, indice){

            if(name == 'altas' ){
                console.log('current_date', this.current_date.getFullYear(),this.current_date.getMonth());
                this.fecha_ini.setValue(new Date(this.current_date.getFullYear(),this.current_date.getMonth(),1));
                this.fecha_fin.setValue(new Date(this.current_date.getFullYear(),this.current_date.getMonth()+1,0));
                this.bandera_alta = 1;
            }else if(name == 'bajas' ){
                this.fecha_ini.setValue(new Date(this.current_date.getFullYear(),this.current_date.getMonth()-1,1));
                this.fecha_fin.setValue(new Date(this.current_date.getFullYear(),this.current_date.getMonth(),0));
                this.bandera_baja = 1;
            }

            this.store.baseParams.estado_func = name;
            this.store.baseParams.fecha_ini = this.fecha_ini.getValue();
            this.store.baseParams.fecha_fin = this.fecha_fin.getValue();

            this.load({params: {start: 0, limit: 50}});
        },


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
                config:{
                    fieldLabel: "Desc. Niv. Salarial",
                    gwidth: 200,
                    name: 'desc_nivel_salarial',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'tca.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Desc. Cargo/Puesto",
                    gwidth: 200,
                    name: 'nombre_cargo',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'tca.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:true
            },

            {
                config:{
                    name:'id_persona',
                    origen:'PERSONA',
                    tinit:true,
                    allowBlank: true,
                    fieldLabel:'Apellidos y Nombres',
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
                    renderer:function (value, p, record){return String.format('<b style="color: orangered">{0}</b>', record.data['desc_person']);},
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
                form:true
            },

            {
                config:{
                    fieldLabel: "Foto",
                    gwidth: 110,
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
                    fieldLabel: "Haber Basico",
                    gwidth: 100,
                    name: 'haber_basico',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'NumberField',
                filters:{pfiltro:'tca.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Bono Antiguedad",
                    gwidth: 100,
                    name: 'bono_antiguedad',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'NumberField',
                filters:{pfiltro:'tca.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Bono Frontera",
                    gwidth: 100,
                    name: 'bono_frontera',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'NumberField',
                filters:{pfiltro:'tca.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    fieldLabel: "Total Ganado",
                    gwidth: 100,
                    name: 'total_ganado',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'NumberField',
                filters:{pfiltro:'tca.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "Fecha Ingreso",
                    gwidth: 100,
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
                form:true
            },
            {
                config:{
                    fieldLabel: "Contrato",
                    gwidth: 100,
                    name: 'nombre_contrato',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'tcon.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    fieldLabel: "C.I.",
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
                grid:true,
                //valorInicial:'expedicion',
                form:true
            },


            {
                config:{
                    fieldLabel: "Oficina",
                    gwidth: 200,
                    name: 'nombre_oficina',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'tof.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:false
            },

            {
                config:{
                    name: 'fecha_asignacion',
                    fieldLabel: 'Fecha Asignación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
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
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'tuo.fecha_finalizacion',type:'date'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    fieldLabel: "Motivo Finalización",
                    gwidth: 110,
                    name: 'motivo_fin',
                    allowBlank:true,
                    maxLength:100,
                    minLength:1,
                    anchor:'100%',
                    disabled: true,
                    style: 'color: blue; background-color: orange;',
                    renderer: function (value, p, record){
                        return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'tuo.observaciones_finalizacion',type:'string'},
                bottom_filter : true,
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
                    renderer: function (value, p, record){
                        return String.format('<div style="color: steelblue; font-weight: bold;">{0}</div>', value);
                    }
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:1,
                bottom_filter : true,
                grid:true,
                form:true
            }
        ],
        title:'Altas y Bajas',
        ActList:'../../sis_organigrama/control/Funcionario/listarAltasBajas',
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
            'nombre_lugar_ofi',
            'desc_nivel_salarial',
            'haber_basico',
            'bono_antiguedad',
            'bono_frontera',
            'total_ganado',
            'motivo_fin',
            'nombre_contrato',
        ],
        sortInfo:{
            field: 'PERSON.nombre_completo2',
            direction: 'ASC'
        },
        bedit:false,
        bnew:false,
        bdel:false,
        bsave:false,
        fwidth: '90%',
        fheight: '95%'
    });
</script>
