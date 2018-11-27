<?php
/**
 *@package pXP
 *@file Persona.php
 *@author KPLIAN (JRR)
 *@date 14-02-2011
 *@description  Vista para regitro de datos de persona
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.persona=Ext.extend(Phx.gridInterfaz,{
        //tabEnter:true,
        Atributos:[
            {
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_persona'

                },
                type:'Field',
                form:true ,
                id_grupo:1

            },
            {
                config:{
                    fieldLabel: "Nombre",
                    gwidth: 130,
                    name: 'nombre',
                    allowBlank:false,
                    maxLength:150,
                    minLength:2,
                    anchor:'100%',
                    style:'text-transform:uppercase;',
                    qtip:'Nombres y Apellido solo Mayusculas'
                },
                type:'TextField',
                filters:{pfiltro:'p.nombre',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    hidden:true,
                    name: 'nombre_completo1',
                },
                type:'TextField',
                filters:{pfiltro:'per.nombre_completo1',type:'string'},
                bottom_filter : true,
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
                    style:'text-transform:uppercase;',
                    anchor:'100%'

                },
                type:'TextField',
                filters:{pfiltro:'p.apellido_paterno',type:'string'},
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    fieldLabel: "Apellido Materno",
                    gwidth: 130,
                    name: 'ap_materno',
                    allowBlank:true,
                    maxLength:150,
                    anchor:'100%',
                    style:'text-transform:uppercase;'
                },
                type:'TextField',
                filters:{pfiltro:'p.apellido_materno',type:'string'},//p.apellido_paterno
                bottom_filter : true,
                id_grupo:1,
                grid:true,
                form:true
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
                        var momentoActual = new Date();

                        var hora = momentoActual.getHours();
                        var minuto = momentoActual.getMinutes();
                        var segundo = momentoActual.getSeconds();

                        hora_actual = hora+":"+minuto+":"+segundo;



                        //return  String.format('{0}',"<div style='text-align:center'><img src = ../../control/foto_persona/"+ record.data['foto']+"?"+record.data['nombre_foto']+hora_actual+" align='center' width='70' height='70'/></div>");
                        var splittedArray = record.data['foto'].split('.');
                        if (splittedArray[splittedArray.length - 1] != "") {
                            return  String.format('{0}',"<div style='text-align:center'><img src = '../../control/foto_persona/ActionArmafoto.php?nombre="+ record.data['foto']+"&asd="+hora_actual+"' align='center' width='70' height='70'/></div>");
                        } else {
                            return  String.format('{0}',"<div style='text-align:center'><img src = '../../../lib/imagenes/NoPerfilImage.jpg' align='center' width='70' height='70'/></div>");
                        }

                    },
                    buttonCfg: {
                        iconCls: 'upload-icon'
                    }
                },
                //type:'FileUploadField',
                type:'Field',
                sortable:false,
                //filters:{type:'string'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'fecha_nacimiento',
                    fieldLabel: 'Fecha Nacimiento',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 80,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                //filters:{pfiltro:'p.fecha_nacimiento',type:'date'},
                filters:{type:'date'},
                id_grupo:1,
                grid:false,
                form:true
            },

            {
                config:{
                    name:'genero',
                    fieldLabel:'Genero',
                    allowBlank:true,
                    emptyText:'Genero...',

                    typeAhead:true,
                    triggerAction:'all',
                    lazyRender:true,
                    mode:'local',
                    store:['Varon','Mujer']
                },
                type:'ComboBox',
                id_grupo:1,
                grid:false,
                form:true
            },
            {
                config:{
                    name:'direccion',
                    fieldLabel: "Direccion",
                    gwidth: 80,
                    allowBlank:true,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:2,
                grid:false,
                form:true
            },
            {
                config:{
                    fieldLabel: 'Nacionalidad',
                    gwidth: 80,
                    name: 'nacionalidad',
                    allowBlank:true,
                    maxLength:15,
                    minLength:5,
                    anchor:'100%',
                    defecto:'Boliviana'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:1,
                grid:false,
                form:true
            },
            {
                config:{
                    name: 'id_lugar',
                    fieldLabel: 'Lugar Nacimiento',
                    allowBlank: true,
                    emptyText:'Lugar...',
                    resizable:true,
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
                            fields: ['id_lugar','nombre'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{tipos:"''departamento'',''pais'',''localidad''",par_filtro:'nombre'}
                        }),
                    valueField: 'id_lugar',
                    displayField: 'nombre',
                    gdisplayField:'lugar',
                    hiddenName: 'id_lugar',
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    anchor:"100%",
                    gwidth:220,
                    forceSelection:true,
                    minChars:2,
                    renderer:function (value, p, record){return String.format('{0}', record.data['lugar']);}
                },
                type:'ComboBox',
                filters:{pfiltro:'lu.nombre',type:'string'},
                id_grupo:1,
                grid:false,
                form:true
            },

            {
                config:{
                    name:'id_tipo_doc_identificacion',
                    fieldLabel:'Tipo Documento',
                    allowBlank:false,
                    emptyText:'Seleccione una opción',

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
                grid:true,
                form:true
            },

            {
                config:{
                    fieldLabel: 'Nro Documento',
                    gwidth: 100,
                    name: 'ci',
                    allowBlank:false,
                    maxLength:15,
                    minLength:5,
                    anchor:'100%'

                },
                type:'TextField',
                filters:{pfiltro:'p.ci',type:'string'},
                id_grupo:3,
                grid:true,
                form:true,
                bottom_filter:true

            },
            {
                config:{
                    name:'expedicion',
                    fieldLabel:'Expedido En',
                    allowBlank:false,
                    emptyText:'Expedido En...',

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
                    name:'estado_civil',
                    fieldLabel:'Estado Civil',
                    allowBlank:true,
                    emptyText:'Estado civil...',

                    typeAhead:true,
                    triggerAction:'all',
                    lazyRender:true,
                    mode:'local',
                    store:['SOLTERO/A','CASADO','VIUDO','DIVORCIADO','CONVIVIENTE']
                },
                type:'ComboBox',
                id_grupo:3,
                grid:false,
                form:true
            },
            {
                config:{
                    name:'discapacitado',
                    fieldLabel:'Discapacitado',
                    allowBlank:true,
                    emptyText:'Discapacitado...',
                    style:'text-transform:uppercase;',
                    typeAhead:true,
                    triggerAction:'all',
                    lazyRender:true,
                    mode:'local',
                    value: 'NO',
                    store:['SI','NO']
                },
                type:'ComboBox',
                valorInicial:'NO',
                id_grupo:3,
                grid:false,
                form:true
            },
            {
                config:{
                    fieldLabel: 'Nro Carnet Discapacitado',
                    gwidth: 100,
                    name: 'carnet_discapacitado',
                    allowBlank:true,
                    maxLength:15,
                    minLength:5,
                    anchor:'100%',
                    hidden:true
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:3,
                grid:false,
                form:true
            },

            {
                config:{
                    fieldLabel: "Telefono",
                    gwidth: 120,
                    name: 'telefono1',
                    allowBlank:true,
                    maxLength:15,
                    minLength:5,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:2,
                grid:true,
                form:true
            },
            {
                config:{
                    fieldLabel: "Celular",
                    gwidth: 120,
                    name: 'celular1',
                    allowBlank:true,
                    maxLength:15,
                    minLength:5,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:2,
                grid:true,
                form:true
            },
            {
                config:{
                    fieldLabel: "Correo",
                    gwidth: 150,
                    name: 'correo',
                    allowBlank:true,
                    vtype:'email',
                    maxLength:100,
                    minLength:5,
                    anchor:'100%'
                },
                type:'TextField',
                filters:{type:'string'},
                id_grupo:2,
                grid:true,
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
                id_grupo:2,
                grid:true,
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
                id_grupo:2,
                grid:true,
                form:true
            }
        ],
        Grupos: [
            {
                layout: 'column',
                border: false,
                defaults: {
                    border: false
                },
                items: [{
                    bodyStyle: 'padding-right:5px;',
                    items: [{
                        xtype: 'fieldset',
                        title: 'Datos Personales',
                        autoHeight: true,
                        items: [],
                        id_grupo:1
                    }]
                },
                    {
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Civiles',
                            autoHeight: true,
                            items:[],
                            id_grupo:3
                        }]
                    },
                    {
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos de Ubicacion',
                            autoHeight: true,
                            items: [],
                            id_grupo:2
                        }]
                    }]
            }
        ],

        //fileUpload:true,
        title:'Persona',
        ActSave:'../../sis_seguridad/control/Persona/guardarPersona',
        ActDel:'../../sis_seguridad/control/Persona/eliminarPersona',
        ActList:'../../sis_seguridad/control/Persona/listarPersonaFoto',
        id_store:'id_persona',
        fields: [
            {name:'id_persona',type:'numeric'},
            {name:'nombre', type: 'string'},
            {name:'id_tipo_doc_identificacion', type: 'numeric'},
            {name:'tipo_documento', type: 'string'},
            {name:'expedicion', type: 'string'},
            {name:'ap_paterno', type: 'string'},
            {name:'ap_materno', type: 'string'},
            {name:'nombre_completo1', type:'string'},
            {name:'ci', type: 'string'},
            {name:'correo', type: 'string'},
            {name:'celular1',type:'string'},
            {name:'telefono1',type:'string'},
            {name:'telefono2',type:'string'},
            {name:'celular2',type:'string'},
            {name:'foto'},


            {name:'genero',type:'string'},
            {name:'direccion',type:'string'},
            {name:'id_lugar',type:'string'},
            {name:'lugar', type: 'string'},
            {name:'estado_civil',type:'string'},
            {name:'nacionalidad',type:'string'},
            {name:'discapacitado',type:'string'},
            {name:'carnet_discapacitado',type:'string'},
            {name:'fecha_nacimiento',type:'date',dateFormat:'Y-m-d'}
        ],
        sortInfo:{
            field: 'id_persona',
            direction: 'ASC'
        },
        //bdel:(Phx.CP.config_ini.sis_integracion=='ENDESIS')?false:true,
        bsave:(Phx.CP.config_ini.sis_integracion=='ENDESIS')?false:true,
        //bnew:(Phx.CP.config_ini.sis_integracion=='ENDESIS')?false:true,
        //bedit:(Phx.CP.config_ini.sis_integracion=='ENDESIS')?false:true,


        fheight: 450,
        fwidth: 1050,

        /*onButtonNew: function() {
            Phx.vista.persona.superclass.onButtonNew.call(this);
                this.Cmp.nombre.enable();
                this.Cmp.ap_paterno.enable();
                this.Cmp.ap_materno.enable();
        },
        onButtonEdit:function () {

            Phx.vista.persona.superclass.onButtonEdit.call(this);
            this.Cmp.nombre.disable();
            this.Cmp.ap_paterno.disable();
            this.Cmp.ap_materno.disable();
            //this.Cmp.id_lugar=datos.lugar;


        },	*/

        onButtonEdit:function(){
            Phx.vista.persona.superclass.onButtonEdit.call(this);
            var val = this.getComponente('discapacitado').value;
            var carnet =this.getComponente('carnet_discapacitado');

            if(val =='SI'){
                carnet.setVisible(true);
            }else{
                carnet.setVisible(false);
            }
        },

        // sobre carga de funcion
        preparaMenu:function(tb){
            // llamada funcion clace padre
            Phx.vista.persona.superclass.preparaMenu.call(this,tb)
            this.getBoton('aSubirFoto').enable();
            //this.getBoton('x').enable();
        },

        liberaMenu:function(tb){
            // llamada funcion clace padre
            Phx.vista.persona.superclass.liberaMenu.call(this,tb)
            this.getBoton('aSubirFoto').disable();
            //this.getBoton('x').disable();

        },

        /*
         * Grupos:[{
         *
         * xtype:'fieldset', border: false, //title: 'Checkbox Groups', autoHeight:
         * true, layout: 'form', items:[], id_grupo:0 }],
         */

        constructor: function(config){
            // configuracion del data store
            Phx.vista.persona.superclass.constructor.call(this,config);

            this.addButton('archivo', {
                argument: {imprimir: 'archivo'},
                text: '<i class="fa fa-thumbs-o-up fa-2x"></i> archivo', /*iconCls:'' ,*/
                disabled: false,
                handler: this.archivo
            });


            this.init();

            this.getComponente('genero').on('select',function (combo, record, index ) {
                if(combo.value == 'Varon'){
                    this.getComponente('nacionalidad').setValue('BOLIVIANO');
                }else{
                    this.getComponente('nacionalidad').setValue('BOLIVIANA');
                }
            }, this);
            this.getComponente('fecha_nacimiento').on('beforerender',function (combo) {
                var fecha_actual = new Date();
                fecha_actual.setMonth(fecha_actual.getMonth() - 220);
                this.getComponente('fecha_nacimiento').setMaxValue(fecha_actual);
            }, this);

            this.getComponente('discapacitado').on('select',function (combo, record, index ) {
                if(combo.value == 'SI'){
                    this.getComponente('carnet_discapacitado').setVisible(true);
                }
                else{
                    this.getComponente('carnet_discapacitado').setVisible(false);
                }
            }, this);
            // this.addButton('my-boton',{disabled:false,handler:myBoton,tooltip:
            // '<b>My Boton</b><br/>Icon only button with tooltip'});
            this.load({params:{start:0, limit:50}})
            //agregamos boton para mostrar ventana hijo
            this.addButton('aSubirFoto',{name:'subirFoto',text:'Subir Foto',iconCls: 'baddphoto',disabled:true,handler:this.SubirFoto,tooltip: '<b>Subir Foto</b><br/>Permite actualizar la foto de la persona'});

        },
        SubirFoto(){
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_seguridad/vista/persona/subirFotoPersona.php',
                'Subir foto',
                {
                    modal:true,
                    width:400,
                    height:150
                },rec.data,this.idContenedor,'subirFotoPersona')
        },

        archivo : function (){



            var rec = this.getSelectedData();

            //enviamos el id seleccionado para cual el archivo se deba subir
            rec.datos_extras_id = rec.id_persona;
            //enviamos el nombre de la tabla
            rec.datos_extras_tabla = 'tpersona';
            //enviamos el codigo ya que una tabla puede tener varios archivos diferentes como ci,pasaporte,contrato,slider,fotos,etc
            rec.datos_extras_codigo = 'ci_persona';

            //esto es cuando queremos darle una ruta personalizada
            //rec.datos_extras_ruta_personalizada = './../../../uploaded_files/favioVideos/videos/';

            Phx.CP.loadWindows('../../../sis_parametros/vista/archivo/Archivo.php',
                'Archivo',
                {
                    width: 900,
                    height: 400
                }, rec, this.idContenedor, 'Archivo');

        },


        //f.e.a(eventos recientes)
        //begin



    })
</script>