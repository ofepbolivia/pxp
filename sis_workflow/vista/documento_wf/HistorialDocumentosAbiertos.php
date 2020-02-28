<?php
/**
 *@package pXP
 *@file HistorialDocumentosAbiertos.php.php
 *@author  (Breydi vasquez pacheco)
 *@date 20/02/2020
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.HistorialDocumentosAbiertos=Ext.extend(Phx.gridInterfaz,{

        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.HistorialDocumentosAbiertos.superclass.constructor.call(this,config);
            this.init();

            var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
            if(dataPadre){
                this.onEnablePanel(this, dataPadre);
            }
            else
            {
                this.bloquearMenus();
            }
            this.grid.addListener('cellclick', this.oncellclick,this);
        },

        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_documento_abierto'
                },
                type:'Field',
                form:true
            },

            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_documento_wf'
                },
                type:'Field',
                form:true
            },
            {
                config:{
                    name: 'url',
                    fieldLabel: 'Doc. Digital',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 65,
                    scope: this,
                    renderer:function (value, p, record){

                        if(record.data['url'] != '') {
                            return "<div style='text-align:center'><img border='0' style='-webkit-user-select:auto;cursor:pointer;' title='Abrir Documento' src = '../../../lib/imagenes/icono_awesome/open.png' align='center' width='30' height='30'></div>";
                        }
                        else if (record.data['action'] != '') {
                            return "<div style='text-align:center'><img border='0' style='-webkit-user-select:auto;cursor:pointer;' title='Vista Previa Documento Generado' src = '../../../lib/imagenes/icono_awesome/open.png' align='center' width='30' height='30'></div>";
                        }
                    },
                },
                type:'Checkbox',
                filters:{pfiltro:'dwf.chequeado',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'historico',
                    fieldLabel: 'Historico',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 70,
                    renderer: function(value, p, record) {
                        return  '<div style="font-weight: bold; text-align: center;padding-top: 5px;font-size: 12px;">'+record.data['historico']+'</div>';
                    }
                },
                type:'TextField',
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'desc_funcionario2',
                    fieldLabel: 'Funcionario',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 200,
                    renderer: function(value, p, record) {
                        return  '<div style="font-weight: bold;text-align: center;padding-top: 5px;">'+record.data['desc_funcionario2']+'</div>';
                    }
                },
                type:'TextField',
                filters:{pfiltro:'carl.desc_funcionario2',type:'string'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'descripcion_cargo',
                    fieldLabel: 'Cargo',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 200,
                    renderer: function(value, p, record) {
                        return  '<div style="font-weight: bold;text-align: center;padding-top: 5px;">'+record.data['descripcion_cargo']+'</div>';
                    }
                },
                type:'TextField',
                filters:{pfiltro:'carl.descripcion_cargo',type:'string'},
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'desc_uo',
                        fieldLabel: 'UO',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 230,
                    renderer: function(value, p, record) {
                        return  '<div style="font-weight: bold;text-align: center;padding-top: 5px;font-size: 12px;">'+record.data['desc_uo']+'</div>';
                    }
                },
                type:'TextField',
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'usr_reg',
                    fieldLabel: 'Creado por',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100
                },
                type:'NumberField',
                filters:{pfiltro:'usu1.cuenta',type:'string'},
                id_grupo:0,
                grid:false,
                form:false
            },
            {
                config:{
                    name: 'fecha_reg',
                    fieldLabel: 'Fecha creación',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 120,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                },
                type:'DateField',
                filters:{pfiltro:'dop.fecha_reg',type:'date'},
                id_grupo:0,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Historial Documentos O',
        ActList:'../../sis_workflow/control/DocumentoWf/listarDocumentsOpens',
        id_store:'id_documento_abierto',
        fields: [
            {name:'id_documento_abierto', type: 'numeric'},
            {name:'id_documento_wf', type: 'numeric'},
            {name:'id_documento_historico_wf', type: 'numeric'},
            {name:'historico', type: 'string'},
            {name:'url', type: 'string'},
            {name:'extension', type: 'string'},
            {name:'action', type: 'string'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'descripcion_cargo', type: 'string'},
            {name:'desc_funcionario2', type: 'string'},
            {name:'desc_uo', type: 'string'},
            {name:'id_proceso_wf', type: 'numeric'},
        ],
        sortInfo:{
            field: 'id_documento_abierto',
            direction: 'DESC'
        },
        bnew: false,
        bdel: false,
        bsave: false,
        btest: false,
        bedit: false,

        onReloadPage:function(m){
            this.maestro=m;
            this.store.baseParams={id_documento_wf:this.maestro.id_documento_wf};
            this.load({params:{start:0, limit:50}})
        },

        loadValoresIniciales:function()
        {
            Phx.vista.TipoDocumento.superclass.loadValoresIniciales.call(this);
        },
        oncellclick : function(grid, rowIndex, columnIndex) {
            var record = this.store.getAt(rowIndex),
            fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

            if (fieldName == 'url') {
                if(record.data['extension'].length!=0) {

                    //Escaneados
                    var data = "id=" + record.data['id_documento_wf'];
                    data += "&extension=" + record.data['extension'];
                    data += "&sistema=sis_workflow";
                    data += "&clase=DocumentoWf";
                    data += "&url="+record.data['url'];
                    window.open('../../../lib/lib_control/CTOpenFile.php?' + data);

                }else if (record.data['action'] != '' ) {
                    //Reportes/Formularios
                    Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url:'../../'+record.data.action,
                        params:{'id_proceso_wf':record.data.id_proceso_wf, 'action':record.data.action},
                        success: this.successExport,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    });
                }
            }
        }

    })
</script>

