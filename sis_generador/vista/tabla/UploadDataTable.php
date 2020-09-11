<?php
/**
 *@package pXP
 *@file    ReporteGlobalAF.php
 *@author  Franklin Espinoza Alvarez
 *@date    23-01-2018
 *@description Archivo con la interfaz para generación de reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.UploadDataTable = Ext.extend(Phx.frmInterfaz, {


        constructor : function(config) {
            Phx.vista.UploadDataTable.superclass.constructor.call(this, config);
            this.esquema = undefined;
            this.addButton('upload_file',
                {
                    grupo:[0],
                    text:'Subir Codigos RC-IVA',
                    iconCls: 'bupload',
                    disabled:false,
                    handler:this.onFormUpload,
                    tooltip: '<b>Cargar archivo con codigos RC-IVA</b>'
                }
            );
            this.init();
            this.iniciarEventos();
        },

        iniciarEventos : function(){

            this.Cmp.id_subsistema.on('select',function (s,r,i){
                this.Cmp.tabla.reset();
                this.Cmp.tabla.modificado = true;
                this.Cmp.tabla.store.setBaseParam('esquema', r.data.codigo);
            }, this);

            this.Cmp.tabla.on('select',function (s,r,i){ console.log('r.data', r.data);
                this.Cmp.columna.reset();
                this.Cmp.columna.modificado = true;
                this.Cmp.columna.store.setBaseParam('esquema', r.data.nombre_esquema);
                this.Cmp.columna.store.setBaseParam('tabla', r.data.nombre);
                this.esquema = r.data.nombre_esquema;
            }, this);



        },
        onFormUpload: function(){

            this.objWizard = Phx.CP.loadWindows('../../../sis_generador/vista/tabla/formUploadDataTable.php',
                'Upload File Data Table',
                {
                    modal: true,
                    width: 450,
                    height: 150,
                    resizable:false,
                    maximizable:false
                },
                {
                    data: {
                        action : this.Cmp.accion.getValue(),
                        table: this.esquema+'.'+this.Cmp.tabla.getValue(),
                        columns: this.Cmp.columna.getValue()

                    }
                },
                this.idContenedor,
                'formUploadDataTable'
            );
        },


        Atributos : [

            {
                config:{
                    name: 'id_subsistema',
                    origen:'SUBSISTEMA',
                    tinit:false,
                    fieldLabel: 'Sistema',
                    gdisplayField:'desc_subsistema',//mapea al store del grid
                    allowBlank: false,
                    msgTarget: 'side',
                    gwidth: 200,
                    width:280,
                    listWidth:280,
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_subsistema']);}
                },
                type:'ComboRec',
                filters:{pfiltro:'subsis.nombre',type:'string'},
                id_grupo:0,
                grid:true,
                form:true
            },

            {
                config:{
                    name:'tabla',
                    fieldLabel:'Tabla',
                    allowBlank:false,
                    emptyText:'Tabla...',
                    msgTarget: 'side',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_generador/control/Tabla/listarTablaCombo',
                        id: 'oid_tabla',
                        root: 'datos',
                        sortInfo:{
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['oid_tabla','nombre', 'nombre_esquema'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'c.relname'}
                    }),
                    valueField: 'nombre',
                    displayField: 'nombre',
                    gdisplayField:'nombre',
                    hiddenName: 'nombre',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:280,
                    gwidth:220,
                    minChars:2,
                    listWidth:280
                },
                type:'ComboBox',
                id_grupo:0,
                filters:{
                    pfiltro:'tabla.nombre',
                    type:'string'
                },

                grid:true,
                form:true
            },

            {
                config : {
                    name : 'columna',
                    fieldLabel : 'Columnas',
                    allowBlank : false,
                    emptyText : 'Columnas...',
                    msgTarget: 'side',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_generador/control/Columna/listarNameColumnsTable',
                        id: 'dtd_identifier',
                        root: 'datos',
                        fields: ['dtd_identifier','udt_name','column_name', 'name_type'],
                        totalProperty: 'total',
                        sortInfo: {
                            field: 'dtd_identifier',
                            direction: 'ASC'
                        },
                        baseParams:{par_filtro:'col.dtd_identifier#col.column_name'}
                    }),
                    tpl: new Ext.XTemplate([
                        '<tpl for=".">',
                        '<div class="x-combo-list-item">',
                        '<div class="awesomecombo-item {checked}">',
                        '<p><b>Id: {dtd_identifier}</b></p>',
                        '</div><p><b>Nombre: </b> <span style="color: green;">{column_name}</span></p>',
                        '</div></tpl>'
                    ]),
                    valueField: 'name_type',
                    displayField: 'column_name',
                    forceSelection: false,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    minChars: 2,
                    width : 280,
                    enableMultiSelect: true
                },

                type : 'AwesomeCombo',
                id_grupo : 0,
                grid : true,
                form : true
            },

            {
                config:{
                    name: 'accion',
                    fieldLabel: 'Tipo Acción',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    gwidth: 200,
                    width : 280,
                    store:['insert','update','truncate']
                },
                type:'ComboBox',
                filters:{
                    type: 'list',
                    options: ['insert','update','truncate'],
                },
                id_grupo:0,
                grid:true,
                form:true
            }

        ],
        title : 'Upload Data Table',
        ActSave : '../../sis_planillas/control/Reporte/reporteGeneralPlanilla',
        timeout : 1500000,
        topBar : true,
        botones : false,
        labelSubmit : 'Imprimir',
        tooltipSubmit : '<b>Estimado usuario</b><br>Eliga los campos necesario e imprima su reporte.',
        //fileUpload:false,
        onSubmit:function(o){
            Phx.vista.UploadDataTable.superclass.onSubmit.call(this,o);
        },
        bsubmit: false,
        tipo : 'reporte',
        clsSubmit : 'bprint',

        Grupos : [{
            layout : 'column',
            labelAlign: 'top',
            border : false,
            autoScroll: true,
            items : [
                {
                    columnWidth: .5,
                    border: false,
                    //split: true,
                    layout: 'anchor',
                    autoScroll: true,
                    autoHeight: true,
                    collapseFirst : false,
                    collapsible: false,
                    anchor: '100%',
                    items:[
                        {
                            anchor: '100%',
                            bodyStyle: 'padding-right:5px;',
                            autoHeight: true,
                            border: false,
                            items:[
                                {
                                    xtype: 'fieldset',
                                    layout: 'form',
                                    border: true,
                                    title: 'Eliga un tipo de Reporte',
                                    //bodyStyle: 'padding: 5px 10px 10px 10px;',

                                    items: [],
                                    id_grupo: 0
                                }
                            ]
                        }
                    ]
                }
            ]
        }]
    });
</script>