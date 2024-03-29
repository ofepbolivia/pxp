<?php
/**
 *@package pXP
 *@file gen-CargoPresupuesto.php
 *@author  (admin)
 *@date 15-01-2014 13:05:35
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CargoPresupuesto=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                //llama al constructor de la clase padre
                this.initButtons=[this.cmbGestion];
                Phx.vista.CargoPresupuesto.superclass.constructor.call(this,config);
                this.init();
                var that = this;
                this.cmbGestion.on('select',function () {

                    this.load({params:{start:0, limit:this.tam_pag,id_cargo:this.maestro.id_cargo,id_gestion:this.cmbGestion.getValue()}});
                    this.Cmp.id_centro_costo.store.baseParams.id_gestion = this.cmbGestion.getValue();
                    this.Cmp.id_centro_costo.modificado = true;

                },this);

                /*this.cmbGestion.store.load({params:{start:0, limit:this.tam_pag}, scope:this,callback: function (arr,op,suc) {
                        //console.log('presupuestos:  ',arr);
                        this.cmbGestion.setValue(arr[0].data.id_gestion);
                        this.Cmp.id_centro_costo.store.baseParams.id_gestion = this.cmbGestion.getValue();
                        this.Cmp.id_centro_costo.modificado = true;
                }});*/

                this.cmbGestion.store.load({params:{start:0, limit:this.tam_pag}, scope:this,callback: function (arr,op,suc) {
                        current_year = (new Date()).getFullYear();
                        let index;
                        arr.forEach(function(rec, ind){
                            if (rec.data.gestion == current_year){
                                index = ind;
                            }
                        });
                        this.cmbGestion.setValue(arr[index].data.id_gestion);
                        this.Cmp.id_centro_costo.store.baseParams.id_gestion = arr[index].data.id_gestion;
                        this.Cmp.id_centro_costo.modificado = true;
                }});

            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_cargo_presupuesto'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_cargo'
                    },
                    type:'Field',
                    form:true
                },

                {
                    config:{
                        name:'id_centro_costo',
                        origen:'CENTROCOSTO',
                        fieldLabel: 'Centro de Costos',
                        emptyText : 'Centro Costo...',
                        allowBlank:false,
                        anchor: '63.5%',
                        listWidth: '345',
                        gwidth:300,
                        baseParams:{filtrar:'grupo_ep'},
                        displayField: 'codigo_cc',
                        gdisplayField: 'desc_centro_costo',
                        msgTarget:'side',
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b style="color: green;">{codigo_cc}</b></p><p>Gestion: {gestion}</p><p>Reg: {nombre_regional}</p><p>Fin.: {nombre_financiador}</p><p>Proy.: {nombre_programa}</p><p>Act.: {nombre_actividad}</p><p>UO: {nombre_uo}</p></div></tpl>',
                        renderer:function(value, p, record){return String.format('<div style="color: green; font-weight: bold;">{0}</div>', record.data['desc_centro_costo']);}

                    },
                    type:'ComboRec',
                    id_grupo:0,
                    form:true,
                    grid:true
                },

                {
                    config:{
                        name: 'nombre_actividad',
                        fieldLabel: 'Programa',
                        allowBlank: true,
                        gwidth: 100,
                        maxLength:10,
                        renderer:function(value, p, record){return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);}
                    },
                    type:'TextField',
                    filters:{pfiltro:'cc.nombre_actividad',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },

                {
                    config:{
                        name: 'codigo_categoria',
                        fieldLabel: 'Categoria Programática',
                        allowBlank: true,
                        gwidth: 180,
                        maxLength:10,
                        renderer:function(value, p, record){return String.format('<div style="color: green; font-weight: bold;">{0}</div>', value);}
                    },
                    type:'TextField',
                    filters:{pfiltro:'cp.codigo_categoria',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },

                {
                    config:{
                        name:'id_ot',
                        fieldLabel: 'Orden Trabajo',
                        sysorigen:'sis_contabilidad',
                        origen:'OT',
                        allowBlank:false,
                        gwidth:200,
                        listWidth: '345',
                        baseParams:{par_filtro:'desc_orden#motivo_orden#codigo'},
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden']);}

                    },
                    type:'ComboRec',
                    id_grupo:0,
                    filters:{pfiltro:'ot.motivo_orden#ot.desc_orden#ot.codigo',type:'string'},
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'porcentaje',
                        fieldLabel: 'Porcentaje',
                        allowBlank: false,
                        anchor: '40%',
                        gwidth: 100,
                        maxLength:3
                    },
                    type:'NumberField',
                    filters:{pfiltro:'carpre.porcentaje',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_ini',
                        fieldLabel: 'Fecha Aplicación',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 150,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'carpre.fecha_ini',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_fin',
                        fieldLabel: 'Fecha Finalización',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'carpre.fecha_fin',type:'date'},
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
                    filters:{pfiltro:'carpre.estado_reg',type:'string'},
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
                    type:'NumberField',
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
                    filters:{pfiltro:'carpre.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'carpre.fecha_mod',type:'date'},
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
                    type:'NumberField',
                    filters:{pfiltro:'usu2.cuenta',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Presupuesto Asignado por Cargo',
            ActSave:'../../sis_organigrama/control/CargoPresupuesto/insertarCargoPresupuesto',
            ActDel:'../../sis_organigrama/control/CargoPresupuesto/eliminarCargoPresupuesto',
            ActList:'../../sis_organigrama/control/CargoPresupuesto/listarCargoPresupuesto',
            id_store:'id_cargo_presupuesto',
            fields: [
                {name:'id_cargo_presupuesto', type: 'numeric'},
                {name:'id_ot', type: 'numeric'},
                {name:'desc_orden', type: 'string'},
                {name:'id_cargo', type: 'numeric'},
                {name:'id_gestion', type: 'numeric'},
                {name:'id_centro_costo', type: 'numeric'},
                {name:'desc_centro_costo', type: 'string'},
                {name:'porcentaje', type: 'numeric'},
                {name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
                {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
                {name:'estado_reg', type: 'string'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'nombre_actividad', type: 'string'},
                {name:'codigo_categoria', type: 'string'}

            ],
            sortInfo:{
                field: 'id_cargo_presupuesto',
                direction: 'ASC'
            },
            bdel:true,
            bedit:true,
            bsave:false,
            onReloadPage:function(m){
                this.maestro=m;
                this.load({params:{start:0, limit:this.tam_pag,id_cargo:this.maestro.id_cargo,id_gestion:this.cmbGestion.getValue(),id_uo:this.maestro.id_uo, id_funcionario:this.maestro.id_funcionario}});
            },
            loadValoresIniciales:function()
            {
                this.Cmp.id_cargo.setValue(this.maestro.id_cargo);
                Phx.vista.CargoPresupuesto.superclass.loadValoresIniciales.call(this);
            },

            cmbGestion:new Ext.form.ComboBox({
                fieldLabel: 'Gestion',
                allowBlank: true,
                emptyText:'Gestion...',
                store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_parametros/control/Gestion/listarGestion',
                        id: 'id_gestion',
                        root: 'datos',
                        sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                        },
                        totalProperty: 'total',
                        fields: ['id_gestion','gestion'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'gestion'}
                    }),
                valueField: 'id_gestion',
                triggerAction: 'all',
                displayField: 'gestion',
                hiddenName: 'id_gestion',
                mode:'remote',
                pageSize:50,
                queryDelay:500,
                listWidth:'280',
                width:80
            }),
        }
    )
</script>

