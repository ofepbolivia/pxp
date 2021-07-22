<?php
/**
 *@package pXP
 *@file gen-TipoDocumentoContrato.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 16:12:10
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TipoDocumentoContrato=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.TipoDocumentoContrato.superclass.constructor.call(this,config);
                this.init();
                this.load({params:{start:0, limit:this.tam_pag}})
            },
            fwidth: '95%',
            fheight: '95%',
            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_tipo_documento'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'tipo',
                        fieldLabel: 'Tipo Documento',
                        allowBlank: false,
                        emptyText:'Tipo...',
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        width: 177,
                        gwidth: 150,
                        msgTarget:'side',
                        store:['contrato', 'anexo'],
                        renderer : function(value, p, record) {
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                        }
                    },
                    type:'ComboBox',
                    filters:{
                        type: 'list',
                        options: ['contrato', 'anexo']
                    },
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'tipo_detalle',
                        fieldLabel: 'Nombre Doc.',
                        allowBlank: false,
                        width: 177,
                        gwidth: 200,
                        maxLength:32,
                        renderer : function(value, p, record) {
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);
                        }
                    },
                    type:'TextField',
                    filters:{pfiltro:'tip_dc.tipo',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_ini',
                        fieldLabel: 'Activo Desde',
                        allowBlank: false,
                        width: 177,
                        msgTarget:'side',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'tip_dc.fecha_ini',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_fin',
                        fieldLabel: 'Activo Hasta',
                        allowBlank: true,
                        width: 177,
                        msgTarget:'side',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'tip_dc.fecha_fin',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                /*{
                    config : {
                        name:'tipo',
                        fieldLabel: 'Tipo Documento',
                        currencyChar: ' ',
                        resizable:true,
                        allowBlank:true,
                        gwidth: 100,
                        msgTarget: 'side',
                        emptyText:'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/Catalogo/listarCatalogoCombo',
                            id: 'id_catalogo',
                            root: 'datos',
                            sortInfo:{
                                field: 'orden',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_catalogo','codigo','descripcion'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {par_filtro:'descripcion',cod_subsistema:'ORGA',catalogo_tipo:'tuo_contrato_anexo'}
                        }),
                        enableMultiSelect:true,
                        valueField: 'id_catalogo',
                        displayField: 'descripcion',
                        gdisplayField: 'anexo',
                        hiddenName: 'tipo',
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
                            return String.format('<div style="color: green; font-weight: bold;">{0}</div>', record.data['tipo_documento']);
                        }
                    },
                    type : 'ComboBox',
                    id_grupo: 1,
                    form : true,
                    grid: true
                },*/
                {
                    config: {
                        name: 'contenido',
                        fieldLabel: 'Contenido',
                        allowBlank: false,
                        //anchor: '100%',
                        qtip: 'Definimos un Documento Formateado',
                        gwidth: 200,
                        height: '600',
                        msgTarget:'side',
                        CKConfig: {

                        }

                    },
                    type: 'CKEditor',
                    filters: {pfiltro: 'tip_dc.contenido', type: 'string'},
                    id_grupo: 1,
                    grid: false,
                    form: true,
                    bottom_filter: true
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
                    filters:{pfiltro:'tip_dc.estado_reg',type:'string'},
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
                    filters:{pfiltro:'tip_dc.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'tip_dc.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'tip_dc.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'tip_dc.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Tipo Documento Contrato',
            ActSave:'../../sis_organigrama/control/TipoDocumentoContrato/insertarTipoDocumentoContrato',
            ActDel:'../../sis_organigrama/control/TipoDocumentoContrato/eliminarTipoDocumentoContrato',
            ActList:'../../sis_organigrama/control/TipoDocumentoContrato/listarTipoDocumentoContrato',
            id_store:'id_tipo_documento',
            fields: [
                {name:'id_tipo_documento', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'tipo', type: 'string'},
                {name:'tipo_detalle', type: 'string'},
                {name:'contenido', type: 'string'},
                {name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
                {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'tipo_documento', type: 'string'}


            ],
            sortInfo:{
                field: 'id_tipo_documento_contrato',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true
        }
    )
</script>