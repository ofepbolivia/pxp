<?php
/**
 *@package pXP
 *@file gen-UoContratoAnexo.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 13:16:48
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
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
    Phx.vista.UoContratoAnexo=Ext.extend(Phx.gridInterfaz,{
            viewConfig: {
                stripeRows: false,
                getRowClass: function(record) {
                    return "x-selectable";
                }
            },
            constructor:function(config){
                this.maestro=config;
                //llama al constructor de la clase padre
                Phx.vista.UoContratoAnexo.superclass.constructor.call(this,config);
                this.store.baseParams.id_uo = this.maestro.id_uo;
                this.init();
                this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_uo_contrato_anexo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name:'id_uo',
                        hiddenName: 'UO',
                        origen:'UO',
                        fieldLabel:'UO',
                        gdisplayField:'nombre_unidad',//mapea al store del grid
                        gwidth:300,
                        emptyText:'Elija una opción...',
                        //anchor: '50%',
                        width: 260,
                        listWidth:'260',
                        baseParams: {estado_reg: 'activo'},
                        allowBlank:false,
                        msgTarget: 'side',
                        renderer:function (value, p, record){return String.format('{0}', record.data['nombre_unidad']);}
                    },
                    type:'ComboRec',
                    id_grupo:1,
                    filters:{
                        pfiltro:'uo.codigo#uo.nombre_unidad',
                        type:'string'
                    },
                    grid:true,
                    form:true
                },
                {
                    config: {
                        name: 'id_tipo_contrato',
                        fieldLabel: 'Tipo Contrato',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        msgTarget: 'side',
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
                        gdisplayField: 'contrato',
                        hiddenName: 'id_tipo_contrato',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        //anchor: '100%',
                        width: 260,
                        gwidth: 120,
                        minChars: 2,
                        renderer : function(value, p, record) {
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', record.data['contrato']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'tipcon.nombre',type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config : {
                        name:'id_tipo_documento_contrato',
                        fieldLabel: 'Tipo Anexo',
                        currencyChar: ' ',
                        resizable:true,
                        allowBlank:true,
                        gwidth: 100,
                        msgTarget: 'side',
                        emptyText:'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_organigrama/control/TipoDocumentoContrato/listarTipoDocumentoContrato',
                            id: 'id_tipo_documento_contrato',
                            root: 'datos',
                            sortInfo:{
                                field: 'id_tipo_documento_contrato',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_tipo_documento_contrato','tipo','tipo_detalle'],
                            remoteSort: true,
                            baseParams: {par_filtro:'descripcion',tipo:'anexo'}
                        }),
                        enableMultiSelect:true,
                        valueField: 'id_tipo_documento_contrato',
                        displayField: 'tipo_detalle',
                        gdisplayField: 'anexo',
                        hiddenName: 'tipo_anexo',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode:'remote',
                        pageSize:10,
                        width: 260,
                        listWidth: 260,
                        queryDelay:1000,
                        renderer:function (value, p, record){
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', record.data['anexo']);
                        }
                    },
                    type : 'ComboBox',
                    id_grupo: 1,
                    form : true,
                    grid: true
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
                    filters:{pfiltro:'uo_ca.estado_reg',type:'string'},
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
                    filters:{pfiltro:'uo_ca.fecha_reg',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'uo_ca.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'uo_ca.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'uo_ca.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],

            onButtonNew : function () {
                Phx.vista.UoContratoAnexo.superclass.onButtonNew.call(this);
                /*this.Cmp.id_uo.setValue(this.maestro.id_uo);
                this.Cmp.id_uo.setRawValue(this.maestro.nombre_unidad);*/
                console.log('this.nombreVista', this.nombreVista);
                if(this.nombreVista != 'listadoContratoAnexo' /*&&  this.nombreVista != undefined*/) {
                    this.Cmp.id_uo.store.load({
                        params: {start: 0, limit: this.tam_pag}, scope: this, callback: function (param, op, suc) {
                            this.Cmp.id_uo.disable();
                            this.Cmp.id_uo.setValue(this.maestro.id_uo);
                            this.Cmp.id_uo.setRawValue(this.maestro.nombre_unidad);
                            this.Cmp.id_uo.collapse();
                            this.Cmp.id_tipo_contrato.focus(false, 5);
                        }
                    });
                    this.Cmp.id_uo.setRawValue(this.maestro.nombre_unidad);
                }
            },

            onButtonEdit: function(){
                Phx.vista.UoContratoAnexo.superclass.onButtonEdit.call(this);
                if(this.nombreVista != 'listadoContratoAnexo'){
                    this.Cmp.id_uo.disable();
                }
            },

            tam_pag:50,
            title:'Uo Contrato Anexo',
            ActSave:'../../sis_organigrama/control/UoContratoAnexo/insertarUoContratoAnexo',
            ActDel:'../../sis_organigrama/control/UoContratoAnexo/eliminarUoContratoAnexo',
            ActList:'../../sis_organigrama/control/UoContratoAnexo/listarUoContratoAnexo',
            id_store:'id_uo_contrato_anexo',
            fields: [
                {name:'id_uo_contrato_anexo', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'id_uo', type: 'numeric'},
                {name:'id_tipo_documento_contrato', type: 'numeric'},
                {name:'id_tipo_contrato', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'anexo', type: 'string'},
                {name:'contrato', type: 'string'},
                {name:'nombre_unidad', type: 'string'}

            ],
            sortInfo:{
                field: 'id_uo_contrato_anexo',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true
        }
    )
</script>