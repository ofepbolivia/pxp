<?php
/**
 *@package      BoA
 *@file         BaseOperativa.php
 *@author       (franklin.espinoza)
 *@date         11-08-2021 09:16:06
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.BaseOperativa=Ext.extend(Phx.gridInterfaz,{

        constructor:function(config){
            this.maestro=config; console.log('this.maestro', this.maestro);
            //llama al constructor de la clase padre
            Phx.vista.BaseOperativa.superclass.constructor.call(this,config);

            this.store.baseParams.id_funcionario = this.maestro.id_funcionario;
            this.init();
            this.load({params:{start:0, limit:50}});
            this.iniciarEventos();
        },

        successSave:function(resp){
            Phx.vista.BaseOperativa.superclass.successSave.call(this,resp);
            var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT.datos;
            console.log('successSave', objRes);
            Ext.Msg.show({
                title: 'Información',
                msg: '<b>'+objRes[0].Message+'</b>',
                buttons: Ext.Msg.OK,
                width: 512,
                icon: Ext.Msg.INFO
            });
        },

        /*successSave:function(resp){
            Phx.vista.BaseOperativa.superclass.successSave.call(this,resp);
            var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT.datos;

            Ext.Msg.show({
                title: 'Información',
                msg: '<b>'+objRes[0].Message+'</b>',
                buttons: Ext.Msg.OK,
                width: 512,
                icon: Ext.Msg.INFO
            });
        },*/

        successDel:function(resp){
            Phx.vista.BaseOperativa.superclass.successDel.call(this,resp);
            var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT.datos;
            Ext.Msg.show({
                title: 'Información',
                msg: '<b>'+objRes[0].Message+'</b>',
                buttons: Ext.Msg.OK,
                width: 512,
                icon: Ext.Msg.INFO
            });
        },

        Atributos:[

            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_funcionario_oficina'
                },
                type:'Field',
                form:true
            },

            {
                config:{
                    msgTarget:'side',
                    name : 'fecha_ini',
                    fieldLabel : 'Desde',
                    allowBlank : false,
                    width : 177,
                    gwidth : 100,
                    //editable:false,
                    //disabled:true,
                    format : 'd/m/Y',
                    renderer:function (value,p,record){
                        return value?'<span style="color: #00B167;">'+value.dateFormat('d/m/Y')+'</span>':''
                    }
                },
                type:'DateField',
                id_grupo:0,
                grid:true,
                form:true
            },

            {
                config:{
                    msgTarget:'side',
                    name: 'fecha_fin',
                    fieldLabel: 'Hasta',
                    allowBlank: false,
                    width : 177,
                    gwidth: 100,
                    //editable:false,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){
                        return value?'<span style="color: #00B167;">'+value.dateFormat('d/m/Y')+'</span>':''
                    }
                },
                type:'DateField',
                id_grupo:0,
                grid:true,
                form:true
            },


            {
                config: {
                    msgTarget:'side',
                    name: 'id_funcionario',
                    fieldLabel: 'Funcionario',
                    allowBlank: false,
                    disabled:true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_organigrama/control/Funcionario/listarFuncionarioCargo',
                        id: 'id_funcionario',
                        root: 'datos',
                        sortInfo: {
                            field: 'desc_funcionario1',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_funcionario','desc_funcionario1','email_empresa','nombre_cargo','lugar_nombre','oficina_nombre'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'FUNCAR.desc_funcionario1'}
                    }),
                    valueField: 'id_funcionario',
                    displayField: 'desc_funcionario1',
                    gdisplayField: 'funcionario',
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario1}</p><p style="color: green">{nombre_cargo}<br>{email_empresa}</p><p style="color:green">{oficina_nombre} - {lugar_nombre}</p></div></tpl>',
                    hiddenName: 'id_funcionario',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    width: 250,
                    gwidth: 250,
                    minChars: 2,
                    resizable:true,
                    listWidth:'250',
                    renderer: function (value, p, record) {
                        return String.format('<span style="color: #00B167;">{0}</span>', record.data['funcionario']);
                    }
                },
                type: 'ComboBox',
                id_grupo:0,
                filters:{
                    pfiltro:'vf.desc_funcionario2',
                    type:'string'
                },
                bottom_filter:true,
                grid: true,
                form: true
            },

            {
                config:{
                    name: 'id_oficina',
                    fieldLabel: 'Base Operativa',
                    allowBlank: false,
                    emptyText:'Oficina...',
                    tinit:true,
                    resizable:true,
                    tasignacion:true,
                    tname:'id_oficina',
                    tdisplayField:'nombre',
                    turl:'../../../sis_organigrama/vista/oficina/Oficina.php',
                    ttitle:'Oficinas',
                    width: 200,
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
                    width: 250,
                    listWidth:'250',
                    gwidth:300,
                    minChars:2,
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{codigo}</p><p>{nombre}</p><p>{nombre_lugar}</p> </div></tpl>',
                    renderer:function (value, p, record){return String.format('<span style="color: #FF8F85;">{0}</span>', record.data['nombre_oficina']);},
                    msgTarget: 'side'
                },
                type:'ComboBox',
                filters:{pfiltro:'ofi.nombre',type:'string'},
                id_grupo:0,
                grid:true,
                form:true
            },

            {
                config: {
                    name: 'lugar',
                    fieldLabel: 'Lugar',
                    allowBlank: true,
                    gwidth: 200,
                    maxLength: 4
                },
                type: 'TextField',
                filters: {pfiltro: 'lug.nombre', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: false
            },

            {
                config:{
                    msgTarget:'side',
                    name: 'observaciones',
                    fieldLabel: 'Observaciones',
                    allowBlank: false,
                    gwidth: 150,
                    width: 250,
                    maxLength:2046,
                    renderer : function(value, p, record) {
                        return String.format('<b><span style="color: #FF8F85;">{0}</span></b>', value);
                    }

                },
                type:'TextArea',
                id_grupo:0,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
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
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'cargo.fecha_reg',type:'date'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
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
                    gwidth: 100,
                    maxLength:4
                },
                type:'NumberField',
                filters:{pfiltro:'usu2.cuenta',type:'string'},
                id_grupo:0,
                grid:true,
                form:false
            },

            {
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'tipo_reg'
                },
                type:'Field',
                form:true

            }
        ],
        bodyStyle: 'padding:0 10px 0;',
        fwidth: '40%',
        fheight : '45%',
        tam_pag:50,
        title:'Base Operativa',
        ActSave:'../../sis_organigrama/control/FuncionarioOficina/insertarFuncionarioOficina',
        ActDel:'../../sis_organigrama/control/FuncionarioOficina/eliminarFuncionarioOficina',
        ActList:'../../sis_organigrama/control/FuncionarioOficina/listarFuncionarioOficina',
        id_store:'id_funcionario_oficina',
        fields: [
            {name:'id_funcionario_oficina', type: 'numeric'},
            {name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
            {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
            {name:'id_funcionario', type: 'numeric'},
            {name:'id_oficina', type: 'numeric'},
            {name:'usuario', type: 'string'},
            {name:'observaciones', type: 'string'},

            {name:'estado_reg', type: 'string'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'id_cargo', type: 'numeric'},

            {name:'nombre_oficina', type: 'string'},
            {name:'funcionario', type: 'string'},
            {name:'lugar', type: 'string'}
        ],
        sortInfo:{
            field: 'id_funcionario_oficina',
            direction: 'ASC'
        },
        bdel:false,
        bsave:false,
        bedit:false,
        bnew:true,
        iniciarEventos : function() {
            //inicio de eventos
        },

        preparaMenu:function()
        {
            //this.getBoton('btnCostos').enable();
            Phx.vista.BaseOperativa.superclass.preparaMenu.call(this);
        },

        liberaMenu:function()
        {
            Phx.vista.BaseOperativa.superclass.liberaMenu.call(this);
        },

        onButtonEdit : function () {
            Phx.vista.BaseOperativa.superclass.onButtonEdit.call(this);
            this.Cmp.tipo_reg.setValue('edit');
        },
        onButtonNew : function () {
            Phx.vista.BaseOperativa.superclass.onButtonNew.call(this);
            this.Cmp.tipo_reg.setValue('new');
            this.Cmp.id_funcionario.setValue(this.maestro.id_funcionario);
            this.Cmp.id_funcionario.setRawValue(this.maestro.acefalo);
        },
        successSave:function(resp){
            Phx.vista.BaseOperativa.superclass.successSave.call(this,resp);
            var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText)).ROOT;
            console.log('detalle', objRes.detalle);
            console.log('datos', objRes.datos);
            Ext.Msg.show({
                title: 'Información',
                msg: '<b>'+objRes.detalle.mensaje+'</b>',
                buttons: Ext.Msg.OK,
                width: 512,
                icon: Ext.Msg.INFO
            });
        }
    });
</script>