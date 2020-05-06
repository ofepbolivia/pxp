<?php
/**
 * @package pXP
 * @file Proveedor.php
 * @author  Rensi Arteaga Copari(KPLIAN)
 * @date 01-03-2013 10:44:58
 * @description, registro de susuarios desde el sistema de parametros
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.proveedor = Ext.extend(Phx.gridInterfaz, {

        register: '',
        tipo: '',
        fheight: 780,
        fwidth: 840,
        Grupos: [
            {
                layout: 'column',
                border: false,
                defaults: {
                    border: false
                },
                items: [{
                    items: [{
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Principales',
                            autoHeight: true,
                            items: [],
                            id_grupo: 0
                        }]
                    },
                    {
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Internacionales-BUE',
                            autoHeight: true,
                            items: [],
                            id_grupo: 3
                        }]
                    },
                    {
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Alkym',
                            autoHeight: true,
                            items: [],
                            id_grupo: 4
                        }]
                    }
                    ]

                },
                {
                    bodyStyle: 'padding-left:5px;',
                    items: [{
                        xtype: 'fieldset',
                        title: 'Datos Persona',
                        autoHeight: true,
                        items: [],
                        id_grupo: 1
                    }]
                },
                {
                    bodyStyle: 'padding-left:5px;',
                    items: [{
                        xtype: 'fieldset',
                        title: 'Datos Institución',
                        autoHeight: true,
                        items: [],
                        id_grupo: 2
                    }]
                }]
            }
        ],

        constructor: function (config) {
            this.maestro = config.maestro;
            //llama al constructor de la clase padre
            this.initButtons = [this.cmbProveedor];
            Phx.vista.proveedor.superclass.constructor.call(this, config);
            this.store.lastOptions = {};
            this.init();


            this.cmbProveedor.on('select', this.capturaFiltros, this);
            this.iniciarEventos();
            this.cmbProveedor.fireEvent('select');

            this.addButton('btnbeneficiario', {
                //grupo: [0],
                text: 'Beneficiario',
                iconCls: 'btag_accept',
                disabled: false,
                handler:this.onSigepRequest,
                tooltip: '<b>Beneficiario</b><br/>Adiciona el ID beneficiario desde el Sigep con el Documento de Identidad o Nit'
            });

        },

        capturaFiltros: function (combo, record, index) {
            this.tipo = this.cmbProveedor.getValue();
            this.store.baseParams = {tipo: this.cmbProveedor.getValue(), tipo_interfaz: this.nombreVista};

            this.load({params: {start: 0, limit: 50}});
        },
        agregarArgsExtraSubmit: function () {
            //Inicializa el objeto de los argumentos extra
            this.argumentExtraSubmit = {};
            this.argumentExtraSubmit.register = this.register;
            //this.argumentExtraSubmit.tipo=this.tipo;

        },
        iniciarEventos: function () {
            Phx.vista.proveedor.superclass.iniciarEventos.call()

            this.ocultarGrupo(3);
            this.ocultarGrupo(4);
            this.ocultarComponente(this.getComponente('contacto'));

            //(may) modificacion grupo de campos segun el tipo
            this.getComponente('tipo').on('select', function (c, r, n) {

                if (r.data.codigo == 'general' || r.data.codigo == 'General' || r.data.codigo == '') {
                    //this.ocultarComponente(datos.dnrp);
                    console.log('llegamnew6',r.data.codigo);
                    this.ocultarGrupo(4);

                }else{
                    this.mostrarGrupo(4);

                }

                this.ocultarComponente(this.getComponente('contacto'));

            }, this);
            //(may) modificacion grupo de campos segun el id_lugar
            this.getComponente('id_lugar').on('select', function (cmp, rec, indice) {
                //id_lugar 1 Bolivia
                //id_lugar 97 BUE
                if (rec.data.id_lugar != 97 || rec.data.id_lugar == '') {
                    this.ocultarGrupo(3);
                }else{
                    this.mostrarGrupo(3);
                }
            }, this);

            this.getComponente('id_persona').on('select', function (c, r, n) {

                if (this.register != 'update') {
                    this.getComponente('rotulo_comercial').setValue(r.data.nombre_completo1);
                }


                //this.getComponente('nombre').setDisabled(true);
                this.getComponente('nombre_persona').setDisabled(true);
                this.getComponente('apellido_paterno').setDisabled(true);
                this.getComponente('apellido_materno').setDisabled(true);
                this.getComponente('ci').setValue(r.data.ci);
                //this.getComponente('nombre').setValue(r.data.nombre);
                this.getComponente('nombre_persona').setValue(r.data.nombre);
                this.getComponente('apellido_paterno').setValue(r.data.ap_paterno);
                this.getComponente('fecha_nacimiento').setValue(r.data.fecha_nacimiento);
                this.getComponente('direccion').setValue(r.data.direccion);
                this.getComponente('genero').setValue(r.data.genero);
                this.getComponente('apellido_materno').setValue(r.data.ap_materno);
                this.getComponente('correo').setValue(r.data.correo);
                this.getComponente('celular1').setValue(r.data.celular1);
                this.getComponente('celular2').setValue(r.data.celular2);
                this.getComponente('telefono1').setValue(r.data.telefono1);
                this.getComponente('telefono2').setValue(r.data.telefono2);
                this.getComponente('casilla').setValue(r.data.casilla);
                this.register = 'before_registered';
            }, this);


            this.getComponente('id_institucion').on('select', function (c, r, n) {
                if (this.register != 'update') {
                    this.getComponente('rotulo_comercial').setValue(r.data.nombre);
                }

                console.log('datos institucion', r.data)

                this.Cmp.nit.setValue(r.data.doc_id); //recupera el nit de la institucion

                this.Cmp.nombre_institucion.setDisabled(true);
                this.Cmp.nombre_institucion.setValue(r.data.nombre);
                this.Cmp.doc_id.setValue(r.data.doc_id);
                this.Cmp.codigo_institucion.setValue(r.data.codigo);
                this.Cmp.casilla.setValue(r.data.casilla);
                this.Cmp.telefono1_institucion.setValue(r.data.telefono1);
                this.Cmp.telefono2_institucion.setValue(r.data.telefono2);
                this.Cmp.celular1_institucion.setValue(r.data.celular1);
                this.Cmp.celular2_institucion.setValue(r.data.celular2);
                this.Cmp.fax.setValue(r.data.fax);
                this.Cmp.email1_institucion.setValue(r.data.email1);
                this.Cmp.email2_institucion.setValue(r.data.email2);
                this.Cmp.pag_web.setValue(r.data.pag_web);
                this.Cmp.observaciones.setValue(r.data.observaciones);
                this.Cmp.direccion_institucion.setValue(r.data.direccion);
                this.Cmp.codigo_banco.setValue(r.data.codigo_banco);

                this.register = 'before_registered';
            }, this);

            //may
            console.log('log 1', this.getComponente('id_lugar'))
            console.log('log 2', this.getComponente('id_lugar_fk'))
            //09-03_2020 (may) filtro para campo departamento segun el pais
            this.getComponente('id_lugar').on('select', function (cmp, rec, indice) {
                this.Cmp.id_lugar_fk.reset();
                this.Cmp.id_lugar_fk.store.baseParams.id_lugar_fk = rec.data.id_lugar;
                this.Cmp.id_lugar_fk.modificado = true;
            }, this);

            //09-03_2020 (may) filtro para campo ciudad segun el departamento
            this.Cmp.id_lugar_fk.on('select', function (cmp, rec, indice) {
                this.Cmp.id_lugar_fk2.reset();
                this.Cmp.id_lugar_fk2.store.baseParams.id_lugar_fk = rec.data.id_lugar;
                this.Cmp.id_lugar_fk2.modificado = true;
            }, this);

            //02-04-2020 (may) filtro segun el tipo de proveedor
          /*  this.getComponente('tipo') = 'General' ({

                //this.getComponente('nombre').setDisabled(true);
                this.getComponente('ccorreo').setDisabled(true);
                this.getComponente('dnrp').setDisabled(true);
                this.getComponente('ingr_bruto').setDisabled(true);
                this.getComponente('id_moneda').setDisabled(true);
                this.getComponente('tipo_habilitacion').setDisabled(true);
                this.getComponente('motivo_habilitacion').setDisabled(true);
                this.register = 'before_registered';
            }, this);*/

           /*  if (this.Cmp.tipo.getValue() == 'persona') {
            //if (this.cmbProveedor.getValue() == 'General') {
             };*/



        },
        Atributos: [
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_proveedor'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_proveedor_alkym'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_alkym_proveedor'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'nombre_dinamico'
                },
                type: 'Field',
                form: true
            },{
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'nombre_pais'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'nombre_departamento'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'nombre_ciudad'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'direccion_dinamico'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'correo_dinamico'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'correo_dinamico2'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'fax_dinamico'
                },
                type: 'Field',
                form: true
            },

            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'pagweb_dinamico'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'observaciones_dinamico'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'doc_ci'
                },
                type: 'Field',
                form: true
            },
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'cod_moneda'
                },
                type: 'Field',
                form: true
            },

            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'telefono_dinamico'
                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    name: 'nro_tramite',
                    fieldLabel: 'N# Trámite',
                    gwidth: 180
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.nro_tramite', type: 'string'},
                grid: true,
                form: false
            },
            {


                config: {
                    name: 'estado',
                    fieldLabel: 'Estado',
                    gwidth: 110
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.estado', type: 'string'},
                grid: true,
                form: false
            },

            {
                config: {
                    name: 'tipo',
                    qtip: 'Tipo de proveedor',
                    fieldLabel: 'Tipo',
                    resizable: true,
                    allowBlank: true,
                    emptyText: 'Seleccione un catálogo...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/Catalogo/listarCatalogoCombo',
                        id: 'id_catalogo',
                        root: 'datos',
                        sortInfo: {
                            field: 'orden',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_catalogo', 'codigo', 'descripcion'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {
                            par_filtro: 'descripcion',
                            cod_subsistema: 'PARAM',
                            catalogo_tipo: 'tproveedor_tipo'
                        }
                    }),
                    enableMultiSelect: true,
                    valueField: 'codigo',
                    displayField: 'descripcion',
                    gdisplayField: 'tipo',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 10,
                    queryDelay: 1000,
                    //width:180,
                    anchor: "100%",
                    minChars: 2
                },
                type: 'ComboBox',
                filters: {pfiltro: 'provee.tipo', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true
            },

            {


                config: {
                    name: 'nombre_proveedor',
                    fieldLabel: 'Nombre Proveedor',
                    gwidth: 180
                },
                type: 'TextField',
                filters: {pfiltro: 'instit.nombre#person.nombre_completo1', type: 'string'},
                grid: true,
                form: false
            },

            {
                config: {
                    name: 'id_persona',
                    fieldLabel: 'Persona',
                    anchor: '100%',
                    tinit: false,
                    allowBlank: true,
                    origen: 'PERSONAV2',
                    gdisplayField: 'nombre_completo1',
                    baseParams: {no_es_proveedor: 'si'},
                    gwidth: 200,
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['nombre_completo1']);
                    }

                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {pfiltro: 'person.nombre_completo1', type: 'string'},
                grid: false,
                form: true,
                bottom_filter: true
            },
            {
                config: {
                    name: 'id_institucion',
                    fieldLabel: 'Institución',
                    anchor: '100%',
                    tinit: false,
                    allowBlank: true,
                    origen: 'INSTITUCION',
                    gdisplayField: 'nombre',
                    gwidth: 200,
                    baseParams: {no_es_proveedor: 'si'},
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['nombre']);
                    }

                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {pfiltro: 'instit.nombre', type: 'string'},
                grid: false,
                form: true,
                bottom_filter: true
            },
            {
                config: {
                    name: 'rotulo_comercial',
                    fieldLabel: 'Rótulo Comercial',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    style: 'text-transform:uppercase;',
                    qtip: 'Rótulo Comercial / Razón Social',
                    maxLength: 150
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.rotulo_comercial', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true,
                bottom_filter: true
            },
            {
                config: {
                    name: 'nit',
                    fieldLabel: 'NIT / CUIT',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.nit', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true,
                bottom_filter: true
            },


            {
                config: {
                    name: 'codigo',
                    fieldLabel: 'Código ERP',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50,
                    readOnly: true
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.codigo', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true,
                bottom_filter: true
            },

            {
                config: {
                    name: 'num_proveedor',
                    fieldLabel: 'Número de Proveedor',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 100,
                    //readOnly :true,
                    style: 'color : blue;'
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.num_proveedor', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true,
                bottom_filter: true
            },

            {
                config: {
                    name: 'numero_sigma',
                    fieldLabel: 'Num.Sigma',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.numero_sigma', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true
            },
            {
                config:{
                    name: 'id_beneficiario',
                    fieldLabel: 'ID Beneficiario',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength:15,
                    renderer : function(value, p, record) {
                        return String.format('<b style="color: green">{0}</b>', record.data['id_beneficiario']);
                    }
                },
                type:'TextField',
                filters:{pfiltro:'provee.id_beneficiario',type:'string'},
                id_grupo:0,
                grid:true,
                form:false,
                bottom_filter : true
            },

            {
                config: {
                    name: 'ci',
                    fieldLabel: 'CI',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'person.ci', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: false
            },


            {
                config: {
                    name: 'pais',
                    fieldLabel: 'País',
                    allowBlank: true,
                    anchor: '90%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 0,
                grid: false,
                form: false
            },

            {
                config: {
                    name: 'id_lugar',
                    fieldLabel: 'País',
                    allowBlank: true,
                    emptyText: 'Lugar...',
                    store: new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Lugar/listarLugar',
                            id: 'id_lugar',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_lugar', 'id_lugar_fk', 'codigo', 'nombre', 'tipo', 'sw_municipio', 'sw_impuesto', 'codigo_largo'],
                            // turn on remote sorting
                            remoteSort: true,
                            //baseParams:{tipos:"''departamento'',''pais'',''localidad''",par_filtro:'nombre'}
                            baseParams: {tipos: "''pais''", par_filtro: 'nombre'}
                        }),
                    valueField: 'id_lugar',
                    displayField: 'nombre',
                    gdisplayField: 'lugar',
                    hiddenName: 'id_lugar',
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 50,
                    queryDelay: 500,
                    anchor: "100%",
                    gwidth: 220,
                    forceSelection: true,
                    minChars: 2,
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['lugar']);
                    }
                },
                type: 'ComboBox',
                filters: {pfiltro: 'lug.nombre', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'id_lugar_fk',
                    fieldLabel: 'Departamento / Provincia',
                    allowBlank: true,
                    emptyText: 'Lugar...',
                    qtip: 'Depto, Provincia, Estado',
                    store: new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Lugar/listarLugar',
                            id: 'id_lugar',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_lugar', 'id_lugar_fk', 'codigo', 'nombre', 'tipo', 'sw_municipio', 'sw_impuesto', 'codigo_largo'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {tipos: "''departamento'', ''provincia'' ", par_filtro: 'nombre'}
                        }),
                    valueField: 'id_lugar',
                    displayField: 'nombre',
                    gdisplayField: 'lugar_depto',
                    hiddenName: 'id_lugar',
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 50,
                    queryDelay: 500,
                    anchor: "100%",
                    gwidth: 220,
                    forceSelection: true,
                    minChars: 2,
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['lugar_depto']);
                    }
                },
                type: 'ComboBox',
                filters: {pfiltro: 'lug.nombre', type: 'string'},
                id_grupo: 0,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'id_lugar_fk2',
                    fieldLabel: 'Ciudad',
                    allowBlank: true,
                    emptyText: 'Lugar...',
                    store: new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Lugar/listarLugar',
                            id: 'id_lugar',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_lugar', 'id_lugar_fk', 'codigo', 'nombre', 'tipo', 'sw_municipio', 'sw_impuesto', 'codigo_largo'],
                            // turn on remote sorting
                            remoteSort: true,
                            // baseParams:{tipos:"''departamento'',''pais'',''localidad''",par_filtro:'nombre'}
                            baseParams: {tipos: "''ciudad'', ''localidad'', ''Barrio''", par_filtro: 'nombre'}
                        }),
                    valueField: 'id_lugar',
                    displayField: 'nombre',
                    gdisplayField: 'lugar_ciudad',
                    hiddenName: 'id_lugar',
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 50,
                    queryDelay: 500,
                    anchor: "100%",
                    gwidth: 220,
                    forceSelection: true,
                    minChars: 2,
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['lugar_ciudad']);
                    }
                },
                type: 'ComboBox',
                filters: {pfiltro: 'lug.nombre', type: 'string'},
                id_grupo: 0,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'contacto',
                    fieldLabel: 'Contacto',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 150
                },
                type: 'TextField',
                id_grupo: 0,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'condicion',
                    fieldLabel: 'Condición Frente al IVA',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    typeAhead: true,
                    triggerAction: 'all',
                    mode: 'local',
                    store: ['Responsable Inscripto', 'Monotributo', 'Exento']
                },
                type: 'ComboBox',
                filters: {pfiltro: 'provee.condicion', type: 'string'},
                id_grupo: 3,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'actividad',
                    fieldLabel: 'Actividad',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    typeAhead: true,
                    triggerAction: 'all',
                    mode: 'local',
                    store: ['Administrativo', 'Operativa', 'Bienes', 'Comercial']
                },
                type: 'ComboBox',
                filters: {pfiltro: 'provee.actividad', type: 'string'},
                id_grupo: 3,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'codigo_alkym',
                    fieldLabel: 'Código Alkym',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50,
                    style: 'color : green;'
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.codigo_alkym', type: 'string'},
                id_grupo: 4,
                grid: true,
                form: true,
                bottom_filter: true
            },
            {
                config: {
                    name: 'ccorreo',
                    fieldLabel: 'CCorreo',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 30
                },
                type: 'TextField',
                id_grupo: 4,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'dnrp',
                    fieldLabel: 'DNRP',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 150
                },
                type: 'TextField',
                id_grupo: 4,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'ingreso_bruto',
                    currencyChar: ' ',
                    allowNegative: false,
                    fieldLabel: 'Ingresos Brutos',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 1245186
                },
                type: 'MoneyField',
                //filters: {pfiltro: 'plapa.monto', type: 'numeric'},
                id_grupo: 4,
                grid: true,
                form: true
            },


            {
                config: {
                    name: 'id_moneda',
                    origen: 'MONEDA',
                    allowBlank: true,
                    fieldLabel: 'Moneda',
                    gdisplayField: 'moneda', //mapea al store del grid
                    gwidth: 100,
                    anchor: '100%',

                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/Moneda/listarMoneda',
                        id: 'id_moneda',
                        root: 'datos',
                        sortInfo: {
                            field: 'moneda',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_moneda', 'moneda', 'codigo', 'tipo_moneda', 'codigo_internacional'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro: 'moneda#codigo', filtrar: 'no'}
                    }),
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['moneda']);
                    }
                },
                type: 'ComboRec',
                id_grupo: 4,
                filters: {
                    pfiltro: 'moneda',
                    type: 'string'
                },
                grid: true,
                form: true
            },

            {
                config: {
                    name: 'tipo_habilitacion',
                    fieldLabel: 'Tipo Habilitación',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    typeAhead: true,
                    triggerAction: 'all',
                    mode: 'local',
                    store: ['si', 'no']
                },
                type: 'ComboBox',
                filters: {pfiltro: 'tipo_habilitacion', type: 'string'},
                id_grupo: 4,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'motivo_habilitacion',
                    fieldLabel: 'Motivo Habilitación',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 150
                },
                type: 'TextField',
                id_grupo: 4,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'desc_dir_proveedor',
                    fieldLabel: 'Dirección',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 200,
                    maxLength: 50
                },
                type: 'Field',
                filters: {pfiltro: 'instit.direccion#person.direccion', type: 'string'},
                id_grupo: 2,
                grid: true,
                form: false
            },

            {
                config: {
                    //name: 'nombre',
                    name: 'nombre_persona',
                    fieldLabel: 'Nombre',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                //filters:{pfiltro:'per.nombre',type:'string'},
                filters: {pfiltro: 'person.nombre_persona', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'apellido_paterno',
                    fieldLabel: 'Primer Apellido',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'per.apellido_paterno', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'apellido_materno',
                    fieldLabel: 'Segundo Apellido',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'per.apellido_materno', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'ci',
                    fieldLabel: 'CI',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 18
                },
                type: 'NumberField',
                filters: {pfiltro: 'per.ci', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'correo',
                    fieldLabel: 'Correo',
                    allowBlank: true,
                    anchor: '100%',
                    vtype: 'email',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.codigo', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'pag_web_persona',
                    fieldLabel: 'Página web',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 1,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'celular1',
                    fieldLabel: 'Celular1',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'per.celular1', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'celular2',
                    fieldLabel: 'Celular2',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                filters: {pfiltro: 'per.celular2', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    //name: 'casilla',
                    name: 'codigo_telf',
                    fieldLabel: 'Código Télefono',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                //type:'NumberField',
                id_grupo: 1,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'telefono1',
                    fieldLabel: 'Teléfono 1',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    allowDecimals: false,
                    maxLength: 20
                },
                type: 'TextField',
                filters: {pfiltro: 'per.telefono1', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'telefono2',
                    fieldLabel: 'Teléfono 2',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 20
                },
                type: 'TextField',
                filters: {pfiltro: 'per.telefono2', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'fax_persona',
                    fieldLabel: 'Fax',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 30
                },
                type: 'TextField',
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'genero',
                    fieldLabel: 'Género',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    typeAhead: true,
                    triggerAction: 'all',
                    mode: 'local',
                    store: ['varon', 'mujer']
                },
                type: 'ComboBox',
                filters: {pfiltro: 'per.genero', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'fecha_nacimiento',
                    fieldLabel: 'Fecha Nacimiento',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'per.fecha_nacimiento', type: 'date'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'direccion',
                    fieldLabel: 'Dirección',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 200
                },
                type: 'TextField',
                filters: {pfiltro: 'per.direccion', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'observaciones_persona',
                    fieldLabel: 'Observaciones',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'doc_id',
                    fieldLabel: 'Documento Id',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'NumberField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'codigo_institucion',
                    qtip: 'Sigla de la institución',
                    fieldLabel: 'SIGLA',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            }
            ,
            {
                config: {
                    name: 'nombre_institucion',
                    fieldLabel: 'Nombre',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 100
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'direccion_institucion',
                    fieldLabel: 'Dirección',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 200
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'casilla',
                    fieldLabel: 'Casilla',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'NumberField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            /* {
                 config:{
                     name: 'codigo_telf',
                     fieldLabel: 'Código Télefono',
                     allowBlank: true,
                     anchor: '100%',
                     gwidth: 100,
                     maxLength:50
                 },
                 type:'NumberField',
                 id_grupo:1,
                 grid:false,
                 form:true
             },*/
            {
                config: {
                    name: 'codigo_telf_institucion',
                    fieldLabel: 'Código Télefono',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'NumberField',
                id_grupo: 2,
                grid: false,
                form: true
            },


            {
                config: {
                    name: 'telefono1_institucion',
                    fieldLabel: 'Telefono 1',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 20
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'telefono2_institucion',
                    fieldLabel: 'Telefono 2',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 20
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'celular1_institucion',
                    fieldLabel: 'Celular 1',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 15
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'celular2_institucion',
                    fieldLabel: 'Celular 2',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 15
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'fax',
                    fieldLabel: 'Fax',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 15
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'email1_institucion',
                    fieldLabel: 'Email 1',
                    allowBlank: true,
                    anchor: '100%',
                    vtype: 'email',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'email2_institucion',
                    fieldLabel: 'Email 2',
                    allowBlank: true,
                    anchor: '100%',
                    vtype: 'email',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'pag_web',
                    fieldLabel: 'Página web',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'observaciones',
                    fieldLabel: 'Observaciones',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'codigo_externo',
                    fieldLabel: 'Código Externo',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 150
                },
                type: 'TextField',
                id_grupo: 4,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'codigo_fabricante',
                    fieldLabel: 'Código Fabricante',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 150
                },
                type: 'TextField',
                id_grupo: 4,
                grid: false,
                form: true
            },
            /*
            {
                   config:{
                           name:'id_persona',
                           fieldLabel: 'Persona',
                           anchor: '100%',
                           tinit:true,
                           allowBlank:false,
                           origen:'PERSONA',
                           gdisplayField:'nombre_completo1',
                           gwidth:200,
                           renderer:function (value, p, record){return String.format('{0}', record.data['nombre_completo1']);}

                         },
                   type:'ComboRec',
                   id_grupo:2,
                   filters:{pfiltro:'person.nombre_completo1',type:'string'},
                   grid:true,
                   form:true
               },*/
            {
                config: {
                    name: 'codigo_banco',
                    fieldLabel: 'Codigo Banco',
                    allowBlank: true,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 50
                },
                type: 'TextField',
                id_grupo: 2,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: false,
                    anchor: '100%',
                    gwidth: 100,
                    maxLength: 10
                },
                type: 'TextField',
                filters: {pfiltro: 'provee.estado_reg', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
                    anchor: '90%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'NumberField',
                filters: {pfiltro: 'usu1.cuenta', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha Registro',
                    allowBlank: false,
                    anchor: '90%',
                    gwidth: 100,
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'provee.fecha_reg', type: 'date'},
                id_grupo: 0,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'usr_mod',
                    fieldLabel: 'Modificado por',
                    allowBlank: true,
                    anchor: '90%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'NumberField',
                filters: {pfiltro: 'usu2.cuenta', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_mod',
                    fieldLabel: 'Fecha Modif.',
                    allowBlank: true,
                    anchor: '90%',
                    gwidth: 100,
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'provee.fecha_mod', type: 'date'},
                id_grupo: 0,
                grid: true,
                form: false
            }

        ],
        title: 'Proveedores',
        ActSave: '../../sis_parametros/control/Proveedor/insertarProveedor',
        ActDel: '../../sis_parametros/control/Proveedor/eliminarProveedor',
        ActList: '../../sis_parametros/control/Proveedor/listarProveedorV2',
        id_store: 'id_proveedor',
        fields: [
            {name: 'id_proveedor', type: 'numeric'},
            {name: 'nombre_ciudad', type: 'string'},
            {name: 'id_persona', type: 'numeric'},
            {name: 'codigo', type: 'string'},
            {name: 'numero_sigma', type: 'string'},
            {name: 'tipo', type: 'string'},
            {name: 'estado_reg', type: 'string'},
            {name: 'id_institucion', type: 'numeric'},
            {name: 'id_usuario_reg', type: 'numeric'},
            {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d'},
            {name: 'id_usuario_mod', type: 'numeric'},
            {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d'},
            {name: 'usr_reg', type: 'string'},
            {name: 'usr_mod', type: 'string'},
            {name: 'nombre_completo1', type: 'string'},
            {name: 'nombre', type: 'string'},
            {name: 'nit', type: 'string'},
            {name: 'id_lugar', type: 'string'},
            {name: 'lugar', type: 'string'},
            {name: 'pais', type: 'string'},
            {name: 'rotulo_comercial', type: 'string'},
            {name: 'nombre_proveedor', type: 'string'}, 'ci', 'desc_dir_proveedor', 'contacto',
            'id_proceso_wf', 'id_estado_wf', 'nro_tramite', 'estado',

            {name: 'condicion', type: 'string'},
            {name: 'actividad', type: 'string'},
            'num_proveedor',

            'nombre_persona',
            'apellido_paterno',
            'apellido_materno',
            'codigo_telf',
            'codigo_telf_institucion',

            {name: 'id_lugar_fk', type: 'numeric'},
            {name: 'id_lugar_fk2', type: 'numeric'},

            'id_moneda',
            'moneda',
            'dnrp',
            'ingreso_bruto',
            'tipo_habilitacion',
            'motivo_habilitacion',
            'codigo_alkym',
            'ccorreo',
            'codigo_externo',
            'codigo_fabricante',
            'fax_persona',
            'pag_web_persona',
            'observaciones_persona',
            'id_proveedor_alkym',

            'telefono1',
            'direccion',
            'correo',
            'direccion_institucion',
            'email1_institucion',
            'email2_institucion',
            'telefono1_institucion',
            'fax',
            'pag_web',
            'observaciones',

            'lugar_depto',
            'lugar_ciudad',
            {name:'id_beneficiario', type: 'string'}
        ],

        arrayDefaultColumHidden: ['estado'],


        iniTramite: function () {
            var rec = this.sm.getSelected();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_parametros/control/Proveedor/iniciarTramite',
                params: {
                    id_proveedor: rec.data.id_proveedor
                },
                success: this.successRep,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });


        },

        cmbProveedor: new Ext.form.ComboBox({
            grupo: [0, 1, 2, 3],
            name: 'proveedor',
            fieldLabel: 'Proveedor',
            allowBlank: false,
            emptyText: 'Proveedor...',
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            value: 'persona',
            mode: 'local',
            width: 100,
            store: ['institucion', 'persona']
        }),

        sortInfo: {
            field: 'id_proveedor',
            direction: 'ASC'
        },
        bdel: true,
        bsave: false,


        onButtonNew: function () {
            Phx.vista.proveedor.superclass.onButtonNew.call(this);
            this.getComponente('id_institucion').disable();
            this.getComponente('id_persona').disable();
            this.Cmp.id_persona.store.baseParams.no_es_proveedor = 'si';
            this.Cmp.id_institucion.store.baseParams.no_es_proveedor = 'si';
            this.Cmp.id_institucion.modificado = true;
            this.Cmp.id_persona.modificado = true;

            this.ocultarGrupo(1);
            this.ocultarGrupo(2);
            this.ocultarGrupo(3);
            this.ocultarGrupo(4);





         /*  if (datos.tipo == 'General' || datos.tipo == 'general') {
                console.log('llegamnew6',datos);
                this.ocultarComponente(this.getComponente('ccorreo'));
                this.ocultarComponente(this.getComponente('dnrp'));
                this.ocultarComponente(this.getComponente('ingr_bruto'));
                this.ocultarComponente(this.getComponente('id_moneda'));
                this.ocultarComponente(this.getComponente('tipo_habilitacion'));
                this.ocultarComponente(this.getComponente('motivo_habilitacion'));
            }
*/

            if (this.cmbProveedor.getValue() === 'persona') {


                this.getComponente('id_persona').enable();
                this.mostrarComponente(this.getComponente('id_persona'));
                this.ocultarComponente(this.getComponente('id_institucion'));
                this.resetGroup(1);
                this.unblockGroup(1);
                this.mostrarGrupo(1);
                this.ocultarGrupo(2);
                this.getComponente('nombre_institucion').allowBlank = true;
                //this.getComponente('nombre').allowBlank = false;
                this.getComponente('apellido_paterno').allowBlank = false;
                //this.getComponente('id_institucion').allowBlank=true;
                //this.getComponente('id_persons').allowBlank=false;
                this.getComponente('id_institucion').reset();
                this.getComponente('id_institucion').disable();
                this.register = 'no_registered';

               /* this.Cmp.direccion.on('change', function (cmp, rec) {
                    this.Cmp.direccion_dinamico.setValue(rec);
                   // console.log("aqui dire persona",this.Cmp.direccion_dinamico.getValue());
                }, this);*/

                // //(may) campos para guardar en el Alkym
                //direccion
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('recper recdata', rec.data)
                    this.Cmp.direccion_dinamico.setValue( rec.data.direccion);

                    this.Cmp.direccion.on('change', function (cmp, rec) {
                        this.Cmp.direccion_dinamico.setValue(rec);
                    }, this);
                }, this);
                //correo
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('rec2 recdata', rec.data.correo)
                    this.Cmp.correo_dinamico.setValue( rec.data.correo);

                    this.Cmp.correo.on('change', function (cmp, rec) {
                        this.Cmp.correo_dinamico.setValue(rec);
                    }, this);
                }, this);
                //nombre
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    this.Cmp.nombre_dinamico.setValue(rec.data.nombre_completo1);
                }, this);
                //telefono
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('recper2 recdata', rec.data)
                    this.Cmp.telefono_dinamico.setValue( rec.data.telefono1);

                    this.Cmp.telefono1.on('change', function (cmp, rec) {
                        this.Cmp.telefono_dinamico.setValue(rec);
                    }, this);
                }, this);
                //fax
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('recper2 recdata', rec.data)
                    this.Cmp.fax_dinamico.setValue( rec.data.fax);

                    this.Cmp.fax_persona.on('change', function (cmp, rec) {
                        this.Cmp.fax_dinamico.setValue(rec);
                    }, this);
                }, this);
                //pagweb
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.pagweb_dinamico.setValue( rec.data.pag_web);

                    this.Cmp.pag_web_persona.on('change', function (cmp, rec) {
                        this.Cmp.pagweb_dinamico.setValue(rec);
                    }, this);
                }, this);
                //observaciones
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.observaciones_dinamico.setValue( rec.data.observaciones);

                    this.Cmp.observaciones_persona.on('change', function (cmp, rec) {
                        this.Cmp.observaciones_dinamico.setValue(rec);
                    }, this);
                }, this);
                //ci
                this.Cmp.id_persona.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.doc_ci.setValue( rec.data.ci);

                    this.Cmp.ci.on('change', function (cmp, rec) {
                        this.Cmp.doc_ci.setValue(rec);
                    }, this);
                }, this);



            } else {
                this.getComponente('id_institucion').enable();

                this.ocultarComponente(this.getComponente('id_persona'));
                this.mostrarComponente(this.getComponente('id_institucion'));
                this.resetGroup(2);
                this.unblockGroup(2);
                this.mostrarGrupo(2);
                this.ocultarGrupo(1);
                this.getComponente('nombre_institucion').allowBlank = false;
                //this.getComponente('nombre').allowBlank = true;
                this.getComponente('apellido_paterno').allowBlank = true;
                this.getComponente('apellido_materno').allowBlank = true;
                //this.getComponente('id_persona').allowBlank=true;
                this.getComponente('id_persona').reset();
                this.getComponente('id_persona').disable();
                this.register = 'no_registered';


               /* this.Cmp.direccion_institucion.on('change', function (cmp, rec) {
                    this.Cmp.direccion_dinamico.reset();
                    this.Cmp.direccion_dinamico.setValue(rec);
                    console.log("aqui dire institucion",this.Cmp.direccion_dinamico.getValue());
                }, this);*/
                //direccion
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    this.Cmp.direccion_dinamico.setValue( rec.data.direccion);

                    this.Cmp.direccion_institucion.on('change', function (cmp, rec) {
                        this.Cmp.direccion_dinamico.setValue(rec);
                    }, this);
                }, this);
                //correo 1
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    this.Cmp.correo_dinamico.setValue( rec.data.email1);

                    this.Cmp.email1_institucion.on('change', function (cmp, rec) {
                        this.Cmp.correo_dinamico.setValue(rec);
                    }, this);
                }, this);
                //nombre
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    this.Cmp.nombre_dinamico.setValue(rec.data.nombre);
                }, this);
                //correo 2
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.correo_dinamico2.setValue( rec.data.email2);

                    this.Cmp.email2_institucion.on('change', function (cmp, rec) {
                        this.Cmp.correo_dinamico2.setValue(rec);
                    }, this);
                }, this);
                //telefono
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.telefono_dinamico.setValue( rec.data.telefono1);

                    this.Cmp.telefono1_institucion.on('change', function (cmp, rec) {
                        this.Cmp.telefono_dinamico.setValue(rec);
                    }, this);
                }, this);
                //fax
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.fax_dinamico.setValue( rec.data.fax);

                    this.Cmp.fax.on('change', function (cmp, rec) {
                        this.Cmp.fax_dinamico.setValue(rec);
                    }, this);
                }, this);
                //pagweb
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.pagweb_dinamico.setValue( rec.data.pag_web);

                    this.Cmp.pag_web.on('change', function (cmp, rec) {
                        this.Cmp.pagweb_dinamico.setValue(rec);
                    }, this);
                }, this);
                //observaciones
                this.Cmp.id_institucion.on('select', function (cmp, rec) {
                    console.log('recinti2 recdata', rec.data)
                    this.Cmp.observaciones_dinamico.setValue( rec.data.observaciones);

                    this.Cmp.observaciones.on('change', function (cmp, rec) {
                        this.Cmp.observaciones_dinamico.setValue(rec);
                    }, this);
                }, this);


            }


            //},this);
            //jrr:provisionalmente se ocultan estos campos
            //this.ocultarComponente(this.getComponente('codigo_institucion'));
            this.ocultarComponente(this.getComponente('codigo_banco'));
            //
            //(may)  campos para guardar en el Alkym
            this.Cmp.id_lugar.on('select', function (cmp, rec) {
                this.Cmp.nombre_pais.setValue(rec.data.nombre);
            }, this);
            this.Cmp.id_lugar_fk.on('select', function (cmp, rec) {
                this.Cmp.nombre_departamento.setValue(rec.data.nombre);
            }, this);
            this.Cmp.id_lugar_fk2.on('select', function (cmp, rec) {
                this.Cmp.nombre_ciudad.setValue(rec.data.nombre);
            }, this);
            //moneda
            this.Cmp.id_moneda.on('select', function (cmp, rec) {
                //console.log('r recdatacod', rec.data.codigo_internacional)
                this.Cmp.cod_moneda.setValue( rec.data.codigo_internacional);
            }, this);

        },

        onButtonEdit: function () {
            this.Cmp.id_persona.store.baseParams.no_es_proveedor = '';
            this.Cmp.id_institucion.store.baseParams.no_es_proveedor = '';
            this.Cmp.id_persona.store.baseParams.query = '';
            this.Cmp.id_institucion.store.baseParams.query = '';

            this.register = 'update';

            datos = this.sm.getSelected().data;
            Phx.vista.proveedor.superclass.onButtonEdit.call(this); //sobrecarga enable select


            //(may) modificacion grupo de campos segun el tipo
            if (datos.tipo == 'General' || datos.tipo == 'general' || datos.tipo == '') {
                this.ocultarGrupo(4);

            }else{
                this.mostrarGrupo(4);
            }

            this.ocultarComponente(this.getComponente('contacto'));

            //(may) modificacion grupo de campos segun el id_lugar
            //id_lugar 1 Bolivia
            //id_lugar 97 BUE
            if (datos.id_lugar != 97 || datos.id_lugar == '') {
                this.ocultarGrupo(3);
            }else{
                this.mostrarGrupo(3);
            }


            if (datos.id_persona != '' && datos.id_persona != undefined) {
                //this.ocultarComponente(this.getComponente('id_institucion'));
                var cmbPer = this.getComponente('id_persona');
                //cmbPer.enable();
                cmbPer.getStore().setBaseParam('id_persona', cmbPer.getValue());
                cmbPer.getStore().load({
                    params: cmbPer.getParams(),

                    callback: function (r) {
                        if (r.length > 0) {
                            cmbPer.setValue(r[0].data.id_persona);
                            cmbPer.fireEvent('select', cmbPer, r[0]);
                        }

                    }, scope: this
                });
                cmbPer.getStore().setBaseParam('id_persona', '');

                //this.getComponente('id_institucion').allowBlank=true;
                this.getComponente('id_institucion').reset();
                this.mostrarComponente(this.getComponente('id_persona'));
                this.ocultarComponente(this.getComponente('id_institucion'));

                //  this.getComponente('nombre').setValue(datos.nombre);

                this.mostrarGrupo(1);
                this.ocultarGrupo(2);
                this.unblockGroup(1);
                this.getComponente('nombre_institucion').allowBlank = true;

                //27-02-2020 (may) se comenta porque no debe modificarsenombre y apellidos
                //this.getComponente('nombre').allowBlank = false;
                //this.getComponente('apellido_paterno').allowBlank = false;
                this.getComponente('nombre_persona').allowBlank = true;
                this.getComponente('apellido_paterno').allowBlank = true;
                this.getComponente('apellido_materno').allowBlank = true;

                // this.getComponente('nombre').setDisabled(true);
                this.getComponente('nombre_persona').setDisabled(true);
                this.getComponente('apellido_paterno').setDisabled(true);
                this.getComponente('apellido_materno').setDisabled(true);


                console.log('llega datos',datos )
                //direccion
                this.Cmp.direccion_dinamico.setValue(datos.direccion);
                this.Cmp.direccion.on('change', function (cmp, rec) {
                    this.Cmp.direccion_dinamico.setValue(rec);
                }, this);
                //correo
                this.Cmp.correo_dinamico.setValue(datos.correo);
                this.Cmp.correo.on('change', function (cmp, rec) {
                    this.Cmp.correo_dinamico.setValue(rec);
                }, this);
                //nombre
                this.Cmp.nombre_dinamico.setValue(datos.nombre_completo1);
                //telefono
                this.Cmp.telefono_dinamico.setValue(datos.telefono1);
                this.Cmp.telefono1.on('change', function (cmp, rec) {
                    this.Cmp.telefono_dinamico.setValue(rec);
                }, this);
                //fax
                this.Cmp.fax_dinamico.setValue(datos.fax_persona);
                this.Cmp.fax_persona.on('change', function (cmp, rec) {
                    this.Cmp.fax_dinamico.setValue(rec);
                }, this);
                //pagweb
                this.Cmp.pagweb_dinamico.setValue(datos.pag_web_persona);
                this.Cmp.pag_web_persona.on('change', function (cmp, rec) {
                    this.Cmp.pagweb_dinamico.setValue(rec);
                }, this);
                //observaciones
                this.Cmp.observaciones_dinamico.setValue(datos.observaciones_persona);
                this.Cmp.observaciones_persona.on('change', function (cmp, rec) {
                    this.Cmp.observaciones_dinamico.setValue(rec);
                }, this);
                //ci
                this.Cmp.doc_ci.setValue(datos.ci);
                this.Cmp.ci.on('change', function (cmp, rec) {
                    this.Cmp.doc_ci.setValue(rec);
                }, this);

            } else {

                //this.getComponente('id_persona').allowBlank=true;
                var cmbIns = this.getComponente('id_institucion');
                //cmbIns.enable();
                cmbIns.getStore().setBaseParam('id_institucion', cmbIns.getValue());
                cmbIns.getStore().load({
                    params: cmbIns.getParams(),
                    callback: function (r) {
                        if (r.length > 0) {
                            cmbIns.setValue(r[0].data.id_institucion);
                            cmbIns.fireEvent('select', cmbIns, r[0]);
                        }

                    }, scope: this
                });
                cmbIns.getStore().setBaseParam('id_institucion', '');
                this.getComponente('id_persona').reset();
                this.ocultarComponente(this.getComponente('id_persona'));
                this.mostrarComponente(this.getComponente('id_institucion'));
                this.mostrarGrupo(2);
                this.ocultarGrupo(1);
                this.unblockGroup(2);
                this.getComponente('nombre_institucion').allowBlank = false;
               // this.getComponente('nombre').allowBlank = true;
                this.getComponente('apellido_paterno').allowBlank = true;


                //(may) modificacion campos para guardar en el Alkym
                //direccion
                this.Cmp.direccion_dinamico.setValue(datos.direccion_institucion);
                this.Cmp.direccion_institucion.on('change', function (cmp, rec) {
                    this.Cmp.direccion_dinamico.setValue(rec);
                }, this);
                //correo 1
                this.Cmp.correo_dinamico.setValue(datos.email1_institucion);
                this.Cmp.email1_institucion.on('change', function (cmp, rec) {
                    this.Cmp.correo_dinamico.setValue(rec);
                }, this);
                //nombre
                this.Cmp.nombre_dinamico.setValue(datos.nombre_proveedor);
                //correo 2
                this.Cmp.correo_dinamico2.setValue(datos.email2_institucion);
                this.Cmp.email2_institucion.on('change', function (cmp, rec) {
                    this.Cmp.correo_dinamico2.setValue(rec);
                }, this);
                //telefono
                this.Cmp.telefono_dinamico.setValue(datos.telefono1_institucion);
                this.Cmp.telefono1_institucion.on('change', function (cmp, rec) {
                    this.Cmp.telefono_dinamico.setValue(rec);
                }, this);
                //fax
                this.Cmp.fax_dinamico.setValue(datos.fax);
                this.Cmp.fax.on('change', function (cmp, rec) {
                    this.Cmp.fax_dinamico.setValue(rec);
                }, this);
                //pagweb
                this.Cmp.pagweb_dinamico.setValue(datos.pag_web);
                this.Cmp.pag_web.on('change', function (cmp, rec) {
                    this.Cmp.pagweb_dinamico.setValue(rec);
                }, this);
                //observaciones
                this.Cmp.observaciones_dinamico.setValue(datos.observaciones);
                this.Cmp.observaciones.on('change', function (cmp, rec) {
                    this.Cmp.observaciones_dinamico.setValue(rec);
                }, this);

            }
            this.getComponente('id_persona').disable();
            this.getComponente('id_institucion').disable();
            //jrr:provisionalmente se ocultan estos campos
            //this.ocultarComponente(this.getComponente('codigo_institucion'));
            this.ocultarComponente(this.getComponente('codigo_banco'));
            //

            //(may) modificacion campos para guardar en el Alkym
            this.Cmp.id_lugar.on('select', function (cmp, rec) {
                this.Cmp.nombre_pais.setValue(rec.data.nombre);
            }, this);
            this.Cmp.id_lugar_fk.on('select', function (cmp, rec) {
                this.Cmp.nombre_departamento.setValue(rec.data.nombre);
            }, this);
            this.Cmp.id_lugar_fk2.on('select', function (cmp, rec) {
                this.Cmp.nombre_ciudad.setValue(rec.data.nombre);
            }, this);
            //moneda
            this.Cmp.id_moneda.on('select', function (cmp, rec) {
                //console.log('redi recdatacod', rec.data.codigo_internacional)
                this.Cmp.cod_moneda.setValue( rec.data.codigo_internacional);
            }, this);



        },


        tabeast: [
            {
                url: '../../../sis_parametros/vista/proveedor_cta_bancaria/ProveedorCtaBancaria.php',
                title: 'Cta Bancaria',
                width: '50%',
                cls: 'ProveedorCtaBancaria',
                params: {nombre_tabla: 'param.tproveedor', tabla_id: 'id_proveedor'}
            },
            {
                url: '../../../sis_parametros/vista/proveedor_contacto/ProveedorContacto.php',
                title: 'Contactos',
                width: '50%',
                cls: 'ProveedorContacto',
                params: {nombre_tabla: 'param.tproveedor', tabla_id: 'id_proveedor'}
            }
        ],

        // fheight: '95%',
        // fwidth: '95%',


        antEstado: function (res) {
            var rec = this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
                'Estado de Wf',

                {
                    modal: true,
                    width: 450,
                    height: 250
                }, {data: rec.data, estado_destino: res.argument.estado}, this.idContenedor, 'AntFormEstadoWf',
                {
                    config: [{
                        event: 'beforesave',
                        delegate: this.onAntEstado,
                    }],
                    scope: this
                });
        },

        onAntEstado: function (wizard, resp) {
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url: '../../sis_parametros/control/Proveedor/anteriorEstadoProveedor',
                params: {
                    id_proceso_wf: resp.id_proceso_wf,
                    id_estado_wf: resp.id_estado_wf,
                    obs: resp.obs,
                    estado_destino: resp.estado_destino
                },
                argument: {wizard: wizard},
                success: this.successWizard,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });

        },

        fin_registro: function (a, b, forzar_fin, paneldoc) {
            var d = this.sm.getSelected().data;
            this.mostrarWizard(this.sm.getSelected());
        },

        mostrarWizard: function (rec) {
            var configExtra = [],
                obsValorInicial;

            console.log('rec.data', rec.data)
            this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                'Estado de Wf',
                {
                    modal: true,
                    width: 700,
                    height: 450
                }, {
                    configExtra: configExtra,
                    data: {
                        id_estado_wf: rec.data.id_estado_wf,
                        id_proceso_wf: rec.data.id_proceso_wf,
                        id_proveedor: rec.data.id_proveedor,
                        fecha_ini: rec.data.fecha_tentativa

                    },
                    obsValorInicial: obsValorInicial,
                }, this.idContenedor, 'FormEstadoWf',
                {
                    config: [{
                        event: 'beforesave',
                        delegate: this.onSaveWizard,

                    },
                        {
                            event: 'requirefields',
                            delegate: function () {
                                this.onButtonEdit();
                                this.window.setTitle('Registre los campos antes de pasar al siguiente estado');
                                this.formulario_wizard = 'si';
                            }

                        }],

                    scope: this
                });
        },
        onSaveWizard: function (wizard, resp) {
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_parametros/control/Proveedor/siguienteEstadoProveedor',
                params: {

                    id_proveedor: wizard.data.id_proveedor,
                    id_proceso_wf_act: resp.id_proceso_wf_act,
                    id_estado_wf_act: resp.id_estado_wf_act,
                    id_tipo_estado: resp.id_tipo_estado,
                    id_funcionario_wf: resp.id_funcionario_wf,
                    id_depto_wf: resp.id_depto_wf,
                    obs: resp.obs,
                    json_procesos: Ext.util.JSON.encode(resp.procesos)
                },
                success: this.successWizard,
                failure: this.conexionFailure, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
                argument: {wizard: wizard},
                timeout: this.timeout,
                scope: this
            });
        },
        successWizard: function (resp) {
            Phx.CP.loadingHide();
            resp.argument.wizard.panel.destroy()
            this.reload();
        },


        successRep: function (resp) {
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if (!reg.ROOT.error) {
                this.reload();
                if (reg.ROOT.datos.observaciones) {
                    alert(reg.ROOT.datos.observaciones)
                }

            } else {
                alert('Ocurrió un error durante el proceso')
            }
        },

        loadCheckDocumentosSolWf: function () {
            var rec = this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                'Documentos del Proceso',
                {
                    width: '90%',
                    height: 500
                },
                rec.data,
                this.idContenedor,
                'DocumentoWf'
            )
        },
        onOpenObs: function () {
            var rec = this.sm.getSelected();

            var data = {
                id_proceso_wf: rec.data.id_proceso_wf,
                id_estado_wf: rec.data.id_estado_wf,
                num_tramite: rec.data.num_tramite
            }

            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                'Observaciones del WF',
                {
                    width: '80%',
                    height: '70%'
                },
                data,
                this.idContenedor,
                'Obs'
            )
        },
        diagramGantt: function () {
            var data = this.sm.getSelected().data.id_proceso_wf;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                params: {'id_proceso_wf': data},
                success: this.successExport,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },

        onSigepRequest:function(){
            Phx.CP.loadingShow();
            var resp = this.sm.getSelected().data;
            resp.sigep_adq='vbsigepadq';
            console.log('Grid de Proveedor:',resp);
            Ext.Ajax.request({
                url: '../../sis_sigep/control/SigepAdq/consultaBeneficiario',
                params: {
                    id_proveedor: resp.id_proveedor,
                },
                success: this.successReg,
                failure: this.failureCheck, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
                //argument: {wizard: wizard},
                timeout: this.timeout,
                scope: this
            });

        },
        successReg:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            console.log('successReg',reg.ROOT.datos);
            var proveedor=reg.ROOT;
            var service_code = 'BENEF';
            Ext.Ajax.request({
                url: '../../sis_sigep/control/SigepAdq/registrarService',
                params: {
                    list: JSON.stringify(proveedor),
                    service_code: service_code
                },
                success: this.successProc,
                failure: this.failureCheck, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
                //argument: {wizard: wizard},
                timeout: this.timeout,
                scope: this
            });
            if(!reg.ROOT.error){
                this.reload();
            }
        },
        successProc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            console.log('successProc;',reg);
            var rest = reg.ROOT.datos;
            //var proveedor = reg.ROOT.datos.id_proveedor;
            Ext.Ajax.request({
                url: '../../sis_sigep/control/SigepAdq/statusC31',
                params: {
                    id_service_request: rest.id_service_request,
                    id_proveedor: rest.id_proveedor
                },
                success: this.successSta,
                failure: this.failureCheck, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
                //argument: {wizard: wizard},
                timeout: this.timeout,
                scope: this
            });
            if(!reg.ROOT.error){
                this.reload();
            }
        },
        successSta:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            console.log('successSta;',reg);
            var rest = reg.ROOT.datos;
            //var proveedor = reg.ROOT.datos.id_proveedor;
            Ext.Ajax.request({
                url: '../../sis_sigep/control/SigepAdq/registrarBeneficiario',
                params: {
                    id_proveedor: rest.id_proveedor,
                    id_beneficiario: rest.id_beneficiario
                },
                success: this.successAll,
                failure: this.failureCheck, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
                //argument: {wizard: wizard},
                timeout: this.timeout,
                scope: this
            });
            this.reload();
            if(reg.ROOT.datos.error){
                //Ext.Msg.alert('ERROR SIGEP!', reg.ROOT.datos.error);
                Ext.Msg.show({
                    title: 'ERROR SIGEP!', //<- el título del diálogo
                    msg: reg.ROOT.datos.error,
                    icon: Ext.Msg.ERROR, // <- un ícono de error
                    width: 400,
                    buttons: Ext.Msg.OK, //<- Botones de SI y NO
                    fn: this.callback //<- la función que se ejecuta cuando se da clic
                });
                this.reload();
            }
        },


    })
</script>	
