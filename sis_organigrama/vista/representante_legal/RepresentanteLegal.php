<?php
/**
 *@package pXP
 *@file gen-RepresentateLegal.php
 *@author  (franklin.espinoza)
 *@date 19-07-2021 12:11:06
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.RepresentanteLegal=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.RepresentanteLegal.superclass.constructor.call(this,config);
                this.init();
                this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_representante_legal'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config: {
                        name: 'id_funcionario',
                        fieldLabel: 'Representante',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        msgTarget:'side',
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
                        gdisplayField: 'desc_representante',
                        tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario1}</p><p style="color: green">{nombre_cargo}<br>{email_empresa}</p><p style="color:green">{oficina_nombre} - {lugar_nombre}</p></div></tpl>',
                        hiddenName: 'id_funcionario_denunciado',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        //anchor: '100%',
                        width: 260,
                        gwidth: 250,
                        minChars: 2,
                        resizable:true,
                        listWidth:'260',
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['desc_representante']);
                        }
                    },
                    type: 'TrigguerCombo',
                    id_grupo:3,
                    filters:{
                        pfiltro:'fu.desc_funcionario1',
                        type:'string'
                    },
                    bottom_filter:true,
                    grid: true,
                    form: true
                },
                {
                    config:{
                        msgTarget:'side',
                        name: 'nro_resolucion',
                        fieldLabel: 'Nro. Resolución',
                        allowBlank: false,
                        //anchor: '80%',
                        width: 260,
                        gwidth: 150,
                        maxLength:32
                    },
                    type:'TextField',
                    filters:{pfiltro:'rep_leg.nro_resolucion',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_resolucion',
                        fieldLabel: 'Fecha Resolución',
                        allowBlank: false,
                        msgTarget:'side',
                        width: 177,
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'rep_leg.fecha_resolucion',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_ini',
                        fieldLabel: 'Fecha Inicio',
                        allowBlank: false,
                        msgTarget:'side',
                        width: 177,
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'rep_leg.fecha_ini',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_fin',
                        fieldLabel: 'Fecha Fin',
                        allowBlank: true,
                        msgTarget:'side',
                        width: 177,
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'rep_leg.fecha_fin',type:'date'},
                    id_grupo:1,
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
                    filters:{pfiltro:'rep_leg.estado_reg',type:'string'},
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
                    filters:{pfiltro:'rep_leg.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'rep_leg.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'rep_leg.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'rep_leg.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Representante Legal',
            ActSave:'../../sis_organigrama/control/RepresentanteLegal/insertarRepresentanteLegal',
            ActDel:'../../sis_organigrama/control/RepresentanteLegal/eliminarRepresentanteLegal',
            ActList:'../../sis_organigrama/control/RepresentanteLegal/listarRepresentanteLegal',
            id_store:'id_representante_legal',
            fields: [
                {name:'id_representante_legal', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'nro_resolucion', type: 'string'},
                {name:'fecha_resolucion', type: 'date',dateFormat:'Y-m-d'},
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
                {name:'desc_representante', type: 'string'}

            ],
            sortInfo:{
                field: 'id_representante_legal',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true
        }
    )
</script>