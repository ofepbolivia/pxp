<?php
/**
 *@package pXP
 *@file BoaFile.php
 *@author  Ismael Ramiro Valdivia
 *@date 28-08-2020 13:20:34
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>

    function resizeIframe(obj) {
        obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
    }

    Ext.define('Phx.vista.BoaFile',{
        extend: 'Ext.util.Observable',

        constructor: function(config) {
            var me = this;
            Ext.apply(this, config);
            var me = this;
            this.callParent(arguments);


            this.panel = Ext.getCmp(this.idContenedor);

            var newIndex = 3;



            this.reportPanel = new Ext.Panel({
                id: 'reportPanel',
                width: '100%',
                height: '100%',
                /*renderTo: Ext.get('principal'),*/
                region:'center',
                margins: '5 0 5 5',
                layout: 'fit',
                autoScroll : true,
                items: [{
                    xtype: 'box',
                    width: '100%',
                    height: '100%',
                    autoEl: {
                        tag: 'iframe',
                        src: 'http://erp.obairlines.bo/boa-file/',
                    }}]
            });


            this.Border = new Ext.Container({
                layout:'border',
                id:'principal',
                items:[this.reportPanel]
            });

            this.panel.add(this.Border);
            this.panel.doLayout();
            this.addEvents('init');

        }

    });
</script>
