<?php
/**
 *@package pXP
 *@file DeptoMoneda.php
 *@author  Maylee Perez Pastor
 *@date 15-10-2019 18:26:47
 *@description Archivo con la interfaz de moneda que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.DeptoMoneda=Ext.extend(Phx.gridInterfaz,{
        autoLoad :false,
        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.DeptoMoneda.superclass.constructor.call(this,config);
            this.bloquearMenus();
            this.init();
            if(Phx.CP.getPagina(this.idContenedorPadre)){
                var dataMaestro=Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
                if(dataMaestro){
                    this.onEnablePanel(this,dataMaestro)
                }
            }

            this.iniciarEventos();

            // this.store.baseParams.id_depto=this.maestro.id_depto;
            // this.load({params:{start:0, limit:50}})
        },

        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_depto_moneda'
                },
                type:'Field',
                form:true
            },

            {
                config:{
                    name: 'id_depto',
                    labelSeparator:'',
                    anchor: '80%',
                    inputType:'hidden',
                    maxLength:4
                },
                type:'Field',
                form:true
            },
            {
                config: {
                    name: 'id_moneda',
                    origen: 'MONEDA',
                    allowBlank: false,
                    fieldLabel: 'Moneda',
                    gdisplayField: 'moneda', //mapea al store del grid
                    gwidth: 100,
                    anchor: '90%',

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
                        baseParams:{par_filtro: 'moneda#codigo', filtrar: 'no'}
                    }),
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['moneda']);
                    }
                },
                type: 'ComboRec',
                id_grupo: 0,
                filters: {
                    pfiltro: 'mon.moneda',
                    type: 'string'
                },
                grid: true,
                form: true
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
                filters:{pfiltro:'depusu.estado_reg',type:'string'},
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
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y h:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'depusu.fecha_reg',type:'date'},
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
                filters:{pfiltro:'depusu.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],

        title:'Moneda por Depto',
        ActSave:'../../sis_parametros/control/DeptoMoneda/insertarDeptoMoneda',
        ActDel:'../../sis_parametros/control/DeptoMoneda/eliminarDeptoMoneda',
        ActList:'../../sis_parametros/control/DeptoMoneda/listarDeptoMoneda',
        id_store:'id_depto_moneda',
        fields: [
            {name:'id_depto_moneda', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'id_depto', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date', dateFormat:'Y-m-d H:i:s'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date', dateFormat:'Y-m-d H:i:s'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'id_moneda', type: 'numeric'},
            {name:'moneda', type: 'string'},
            {name:'codigo', type: 'string'}
        ],
        sortInfo:{
            field: 'id_depto_moneda',
            direction: 'ASC'
        },
        bdel:true,
        bsave:true,

        onReloadPage:function(m){


            this.maestro=m;
            this.Atributos[1].valorInicial=this.maestro.id_depto;


            // this.Atributos.config['id_subsistema'].setValue(this.maestro.id_subsistema);

            if(m.id != 'id'){
                //   this.grid.getTopToolbar().enable();
                //	 this.grid.getBottomToolbar().enable();
//alert("entra aqui"+ console.log(this.maestro.id_depto));
                this.store.baseParams={id_depto:this.maestro.id_depto};
                this.load({params:{start:0, limit:50}})

            }
            else{//alert("else");
                this.grid.getTopToolbar().disable();
                this.grid.getBottomToolbar().disable();
                this.store.removeAll();

            }


        }

    })
</script>

