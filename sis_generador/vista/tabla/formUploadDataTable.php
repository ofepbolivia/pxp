<?php
/**
 *@package pXP
 *@file    SolModPresupuesto.php
 *@author  Rensi Arteaga Copari
 *@date    30-01-2014
 *@description permites subir archivos a la tabla de documento_sol
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.formUploadDataTable=Ext.extend(Phx.frmInterfaz,{
        ActSave:'../../sis_generador/control/Tabla/uploadCsvDataTable',

        constructor:function(config){
            this.maestro = config;
            Phx.vista.formUploadDataTable.superclass.constructor.call(this,config);
            this.init();
        },

        Atributos:[
            {
                config:{
                    fieldLabel: "Documento (archivo csv separado por ;)",
                    gwidth: 130,
                    inputType:'file',
                    name: 'archivo',
                    labelStyle: 'color:red;font-weight:bold;',
                    buttonText: '',
                    maxLength:150,
                    width:400
                    //anchor:'100%'
                },
                type:'Field',
                form:true,
                id_grupo:0
            }
        ],
        title:'Upload Data Table',
        fileUpload:true,
        fields: [],

        onSubmit:function(o){
            console.log('enviando datos',this.maestro.data.action,this.maestro.data.table,this.maestro.data.columns);
            this.argumentExtraSubmit = {
                'action': this.maestro.data.action,
                'table': this.maestro.data.table,
                'columns': this.maestro.data.columns
            };

            Phx.vista.formUploadDataTable.superclass.onSubmit.call(this,o);
        },

        successSave:function(resp){
            Phx.CP.loadingHide();
            this.close();
        },
        Grupos: [
            {
                layout: 'column',
                border: false,
                labelAlign: 'top',
                labelWidth: 150,

                defaults: {
                    border: false
                },

                items: [
                    {
                        bodyStyle: 'padding-right:10px;',
                        items: [
                            {
                                xtype: 'fieldset',
                                title: '',
                                autoHeight: true,
                                items: [],
                                id_grupo: 0
                            }
                        ]
                    }
                ]
            }
        ]
    });
</script>