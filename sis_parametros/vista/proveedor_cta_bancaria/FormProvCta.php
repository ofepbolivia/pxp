<?php
/**
 * @package pXP
 * @file    formProvCta.php
 * @author  Maylee Perez Pastor
 * @date    13-06-2019
 * @description permite mostrar formulario de registro de cuentas de dest.
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormProvCta = Ext.extend(Phx.frmInterfaz, {
        ActSave: '../../sis_parametros/control/ProveedorCtaBancaria/insertarProveedorCtaBancaria',
        layout: 'fit',
        breset: false,
        bcancel: true,
        autoScroll: false,
        labelSubmit: '<i class="fa fa-check"></i> Guardar',
        constructor: function (config) {

            this.maestro = config;
            //console.log('formulario',config, record);
            Phx.vista.FormProvCta.superclass.constructor.call(this, config);
            this.init();
        },

        Atributos: [
            {
                //configuracion del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_proveedor_cta_bancaria'
                },
                type: 'Field',
                form: true
            },
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
                config: {
                    name: 'nro_cuenta',
                    fieldLabel: 'Nro Cuenta',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 30
                },
                type: 'TextField',
                filters: {pfiltro: 'pctaban.nro_cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'id_banco_beneficiario',
                    fieldLabel: 'Banco Beneficiario',
                    allowBlank: false,
                    tinit: true,
                    origen: 'INSTITUCION',
                    gdisplayField: 'banco_beneficiario',
                    anchor: '80%',
                    gwidth: 100,
                    // maxLength:100,
                    baseParams: {es_banco: 'si'},
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['banco_beneficiario']);
                    }

                },
                type: 'ComboRec',
                filters: {pfiltro: 'instben.banco_beneficiario', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'swift_big',
                    fieldLabel: 'Swift/Big',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 10
                },
                type: 'TextField',
                filters: {pfiltro: 'pctaban.swift_big', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'fw_aba_cta',
                    fieldLabel: 'Fw/Aba/Cta',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 15
                },
                type: 'TextField',
                filters: {pfiltro: 'pctaban.fw_aba_cta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'banco_intermediario',
                    fieldLabel: 'Banco Intermediario',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 100
                },
                type: 'TextField',
                filters: {pfiltro: 'pctaban.banco_intermediario', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'estado_cta',
                    fieldLabel: 'Estado Cta.',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    typeAhead: true,
                    triggerAction: 'all',
                    selectOnFocus: true,
                    mode: 'local',
                    emptyText: 'Estado Cta...',
                    store: new Ext.data.ArrayStore({
                        fields: ['ID', 'valor'],
                        data: [
                            ['activo', 'Activo'],
                            ['inactivo', 'Inactivo'],
                        ]
                    }),
                    valueField: 'valor',
                    displayField: 'valor'
                },
                type: 'ComboBox',
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'estado_reg',
                    fieldLabel: 'Estado Reg.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 10
                },
                type: 'TextField',
                filters: {pfiltro: 'pctaban.estado_reg', type: 'string'},
                id_grupo: 1,
                grid: false,
                form: false
            },
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_proveedor'
                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    name: 'id_usuario_ai',
                    fieldLabel: '',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'pctaban.id_usuario_ai', type: 'numeric'},
                id_grupo: 1,
                grid: false,
                form: false
            },
            {
                config: {
                    name: 'usuario_ai',
                    fieldLabel: 'Funcionaro AI',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 300
                },
                type: 'TextField',
                filters: {pfiltro: 'pctaban.usuario_ai', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y H:i:s') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'pctaban.fecha_reg', type: 'date'},
                id_grupo: 1,
                grid: false,
                form: false
            },
            {
                config: {
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'usu1.cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'usr_mod',
                    fieldLabel: 'Modificado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength: 4
                },
                type: 'Field',
                filters: {pfiltro: 'usu2.cuenta', type: 'string'},
                id_grupo: 1,
                grid: true,
                form: false
            },
            {
                config: {
                    name: 'fecha_mod',
                    fieldLabel: 'Fecha Modif.',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat('d/m/Y H:i:s') : ''
                    }
                },
                type: 'DateField',
                filters: {pfiltro: 'pctaban.fecha_mod', type: 'date'},
                id_grupo: 1,
                grid: true,
                form: false
            }
        ],
        title: 'Clientes',

        onSubmit:function(o){
            var record = Phx.CP.getPagina(this.maestro.id_padre).getSelectedData();
            console.log('enviar info', this.Cmp.nro_cuenta.getValue(),record);
            this.Cmp.id_proveedor.setValue(record.id_proveedor);
            Phx.vista.FormProvCta.superclass.onSubmit.call(this,o);
        },

        successSave:function(resp)
        {
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            Phx.CP.getPagina(this.maestro.id_padre).cargarCuenta(reg.ROOT.datos.nro_cuenta, this.Cmp.nro_cuenta.getValue());
            Phx.CP.loadingHide();
            this.close();
            this.onDestroy();

        },


        successName: function (resp) {
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

        },

        getValues: function () {
            var resp = {
                id_proveedor: this.recor.id_proveedor,
                nro_cuenta: this.Cmp.nro_cuenta.getValue(),
                id_banco_beneficiario: this.Cmp.id_banco_beneficiario.getValue(),
                swift_big: this.Cmp.swift_big.getValue(),
                fw_aba_cta: this.Cmp.fw_aba_cta.getValue(),
                banco_intermediario: this.Cmp.banco_intermediario.getValue(),
                estado_cta: this.Cmp.estado_cta.getValue(),

            };

            return resp;
        }
    });
</script>
