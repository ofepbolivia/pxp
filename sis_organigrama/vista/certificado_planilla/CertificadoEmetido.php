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
       this.tbarItems = ['-',this.cmbGestion,'-'];
            Phx.vista.CertificadoEmetido.superclass.constructor.call(this, config);
            Ext.Ajax.request({
                url: '../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                params: {fecha: new Date()},
                success: function (resp) {
                    var reg = Ext.decode(Ext.util.Format.trim(resp.responseText));
                    this.cmbGestion.setValue(reg.ROOT.datos.anho);
                    this.cmbGestion.setRawValue(reg.ROOT.datos.anho);                    
                    // this.load({params: {start: 0, limit: this.tam_pag}});
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });             
            this.cmbGestion.on('select',this.capturarEventos, this);
            this.store.baseParams={tipo_interfaz:this.nombreVista};
            var date = new Date();
            this.store.baseParams.gestion = date.getFullYear();
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
        cmbGestion: new Ext.form.ComboBox({
            fieldLabel: 'Gestion',
            allowBlank: false,
            emptyText: 'Gestion...',
            blankText: 'Año',
            store: new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Gestion/listarGestion',
                    id: 'id_gestion',
                    root: 'datos',
                    sortInfo: {
                        field: 'gestion',
                        direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion', 'gestion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {par_filtro: 'gestion'}
                }),
            valueField: 'gestion',
            triggerAction: 'all',
            displayField: 'gestion',
            hiddenName: 'id_gestion',
            mode: 'remote',
            pageSize: 5,
            queryDelay: 500,
            listWidth: '280',
            width: 80
        }),          
    // cmbGestion : new Ext.form.ComboBox({
    //     name:'gestion',
    //     store:['2022', '2021', '2020', '2019','2018','2017','2016','2015','2014','2013','2012','2011','2010','2009','2008','2007','2006','2005','2004'],
    //     typeAhead: true,
    //     value: '2022',
    //     mode: 'local',
    //     triggerAction: 'all',
    //     emptyText:'Géstion...',
    //     selectOnFocus:true,
    //     width:135,
    // }),
    capturarEventos: function () {
        this.store.baseParams.gestion=this.cmbGestion.getValue();
        this.load({params:{start:0, limit:this.tam_pag}});
    },

        bnew:false,
        bedit:false,
        bdel:false
    }
</script>
