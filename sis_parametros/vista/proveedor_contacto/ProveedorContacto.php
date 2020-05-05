<?php
/**
 *@package pXP
 *@file gen-ProveedorContacto.php
 *@author  Maylee Perez pastor
 *@date 30-03-2020 20:07:41
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ProveedorContacto=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.ProveedorContacto.superclass.constructor.call(this,config);
                this.init();


               /* this.Cmp.id_proveedor_alkym.on('change', function (cmp, rec) {
                    console.log('llega cmp', cmp)
                    console.log('llega rec', rec)
                    // this.Cmp.nombre_pais.setValue(rec.data.nombre);
                }, this);*/
            },

            Atributos:[

                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_proveedor_contacto'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_proveedor'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'tipo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_proveedor_alkym'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_alkym_proveedor_contacto'
                    },
                    type:'Field',
                    form:true
                },

                {
                    config:{
                        name: 'nombre_contacto',
                        fieldLabel: 'Contacto',
                        allowBlank: false,
                        style: 'text-transform:uppercase;',
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:30
                    },
                    type:'TextField',
                    filters:{pfiltro:'pcontac.nombre_contacto',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config: {
                        name: 'ci',
                        fieldLabel: 'CI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        allowDecimals: false,
                        maxLength: 100
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'pcontac.ci', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },{
                    config: {
                        name: 'telefono',
                        fieldLabel: 'Teléfono',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        allowDecimals: false,
                        maxLength: 100
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'pcontac.telefono', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fax',
                        fieldLabel: 'Fax',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 30
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'pcontac.fax', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config:{
                        name: 'area',
                        fieldLabel: 'Área',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:30
                    },
                    type:'TextField',
                    filters:{pfiltro:'pcontac.area',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config: {
                        name: 'email',
                        fieldLabel: 'Correo',
                        allowBlank: true,
                        anchor: '80%',
                        vtype: 'email',
                        gwidth: 100,
                        maxLength: 50
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'pcontac.email', type: 'string'},
                    id_grupo: 1,
                    grid: false,
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
                    filters:{pfiltro:'pcontac.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:false,
                    form:false
                },


               /* {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: '',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'nc.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'nc.usuario_ai',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },*/
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
                    filters:{pfiltro:'pcontac.fecha_reg',type:'date'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'pcontac.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:60,
            title:'Proveedor - Contactos',
            ActSave:'../../sis_parametros/control/ProveedorContacto/insertarProveedorContactos',
            ActDel:'../../sis_parametros/control/ProveedorContacto/eliminarProveedorContactos',
            ActList:'../../sis_parametros/control/ProveedorContacto/listarProveedorContactos',
            id_store:'id_proveedor_contacto',
            fields: [
                {name:'id_proveedor_contacto', type: 'numeric'},
                {name:'id_proveedor', type: 'numeric'},
                {name:'nombre_contacto', type: 'string'},
                {name:'telefono', type: 'string'},
                {name:'fax', type: 'string'},
                {name:'area', type: 'string'},
                {name:'email', type: 'string'},
                {name:'estado_reg', type: 'string'},
                /*{name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},*/
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'ci', type: 'string'},

                {name:'id_proveedor_alkym', type: 'numeric'}

            ],
            sortInfo:{
                field: 'id_proveedor_contacto',
                direction: 'ASC'
            },

            onReloadPage:function(m){
                this.maestro=m;
                console.log('llegam', this.maestro.id_proveedor)
                this.Atributos[11].valorInicial=this.maestro.id_proveedor;
               // console.log('llegam2', this.Atributos[7].valorInicial)
                console.log('llegam2', this.Atributos[9].valorInicial)
                this.store.baseParams={id_proveedor:this.maestro.id_proveedor};
                console.log('llegam3',  this.store.baseParams.id_proveedor)
                this.load({params:{start:0, limit:this.tam_pag}})
            },
            onButtonEdit: function () {

                Phx.vista.ProveedorContacto.superclass.onButtonEdit.call(this);
                console.log('llegamedit this', this)
                this.Cmp.id_proveedor.setValue(this.maestro.id_proveedor);
                this.Cmp.tipo.setValue(this.maestro.tipo);
                this.Cmp.id_proveedor_alkym.setValue(this.maestro.id_proveedor_alkym);

            },
            onButtonNew: function () {

                Phx.vista.ProveedorContacto.superclass.onButtonNew.call(this);
                console.log('llegam this', this)
                this.Cmp.id_proveedor.setValue(this.maestro.id_proveedor);
                this.Cmp.tipo.setValue(this.maestro.tipo);
                this.Cmp.id_proveedor_alkym.setValue(this.maestro.id_proveedor_alkym);

            },

            bdel:true,
            bsave:true
        }
    )
</script>

