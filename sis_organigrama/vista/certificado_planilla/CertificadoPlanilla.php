<?php
/**
*@package pXP
*@file gen-CertificadoPlanilla.php
*@author  (MMV)
*@date 24-07-2017 14:48:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CertificadoPlanilla = {
        require: '../../../sis_organigrama/vista/certificado_planilla/Certificado.php',
        requireclase: 'Phx.vista.Certificado',
        title: 'Certificado',
        nombreVista: 'CertificadoPlanilla',
        constructor: function (config) {
            this.Atributos.unshift({
                config: {
                    name: 'control',
                    fieldLabel: 'Impreso',
                    allowBlank: true,
                    anchor: '50%',
                    gwidth: 80,
                    maxLength: 3,
                    renderer: function (value) {
                        var checked = '';
                        if (value == 'si') {
                            checked = 'checked';
                        }
                        return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:40px;width:40px;" type="checkbox"  {0}></div>', checked);

                    }
                },
                type: 'TextField',
                filters: {pfiltro: 'planc.impreso', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: false
            });
            this.Atributos[this.getIndAtributo('impreso')].grid=false;
            Phx.vista.CertificadoPlanilla.superclass.constructor.call(this, config);
            this.grid.addListener('cellclick', this.oncellclick,this);
            this.store.baseParams={tipo_interfaz:this.nombreVista};
            this.store.baseParams.pes_estado = 'borrador';
            this.load({params:{start:0, limit:this.tam_pag}});
            this.getBoton('ant_estado').setVisible(false);
            this.getBoton('btnImprimir').setVisible(false);
            this.finCons = true;
        },
        gruposBarraTareas:[
            {name:'borrador',title:'<H1 align="center"><i class="fa fa-list-ul"></i> Borrador</h1>',grupo:0,height:0},
            {name:'emitido',title:'<H1 align="center"><i class="fa fa-list-ul"></i> Emitido</h1>',grupo:2,height:0},
            {name:'anulado',title:'<H1 align="center"><i class="fa fa-list-ul"></i> Anulado</h1>',grupo:3,height:0}
        ],

        actualizarSegunTab: function(name, indice){
            if(this.finCons){
                this.store.baseParams.pes_estado = name;
                if(name == 'emitido' ){
                    this.getBoton('ant_estado').setVisible(true);
                }else{
                    this.getBoton('ant_estado').setVisible(false);
                }
                this.load({params:{start:0, limit:this.tam_pag}});
            }
        },
        beditGroups: [0,2],
        bdelGroups:  [0,2],
        bactGroups:  [0,2,3],
        bexcelGroups: [0,2,3],
        oncellclick : function(grid, rowIndex, columnIndex, e) {
            var record = this.store.getAt(rowIndex),
                fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
            if(fieldName == 'control') {
                this.cambiarRevision(record);
            }
        },
        cambiarRevision: function(record){
            Phx.CP.loadingShow();
            var d = record.data;
            Ext.Ajax.request({
                url:'../../sis_organigrama/control/CertificadoPlanilla/controlImpreso',
                params:{ id_certificado_planilla: d.id_certificado_planilla},
                success: this.successRevision,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
            this.reload();
        },
        successRevision: function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.CertificadoPlanilla.superclass.preparaMenu.call(this,n);

            if( data['impreso'] ==  'no'){
                this.getBoton('btnImprimir').enable();
                this. enableTabDetalle();
            }
            return tb;
        },

        liberaMenu:function(){
            var tb = Phx.vista.CertificadoPlanilla.superclass.liberaMenu.call(this);
            if(tb){
                this.getBoton('btnImprimir').disable();
            }
            return tb;
        }
    }
</script>
