<?php
/**
 *@package pXP
 *@file gen-CertificadoEmetido.php
 *@author  (MMV)
 *@date 24-07-2017 14:48:34
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CertificadoEmetido = {
        require: '../../../sis_organigrama/vista/certificado_planilla/Certificado.php',
        requireclase: 'Phx.vista.Certificado',
        title: 'CertificadoPlanilla',
        nombreVista: 'CertificadoEmitido',
        constructor: function (config) {

            Phx.vista.CertificadoEmetido.superclass.constructor.call(this, config);
            this.store.baseParams={tipo_interfaz:this.nombreVista};
            this.load({params:{start:0, limit:this.tam_pag}});

        },


        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.CertificadoEmetido.superclass.preparaMenu.call(this,n);

            if( data['impreso'] ==  'no'){
                this.getBoton('btnImprimir').enable();
                this. enableTabDetalle();
            }
            return tb;
        },

        liberaMenu:function(){
            var tb = Phx.vista.CertificadoEmetido.superclass.liberaMenu.call(this);
            if(tb){
                this.getBoton('btnImprimir').disable();
                this.getBoton('btnChequeoDocumentosWf').setVisible(false);
                this.getBoton('ant_estado').setVisible(false);
                this.getBoton('sig_estado').setVisible(false);

            }
            return tb;
        },

        bnew:false,
        bedit:false,
        bdel:false
    }
</script>