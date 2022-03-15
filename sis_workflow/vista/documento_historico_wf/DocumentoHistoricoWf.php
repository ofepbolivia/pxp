<?php
/**
*@package pXP
*@file gen-DocumentoHistoricoWf.php
*@author  (admin)
*@date 04-12-2014 20:11:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DocumentoHistoricoWf=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DocumentoHistoricoWf.superclass.constructor.call(this,config);
		this.init();
		this.grid.addListener('cellclick',this.oncellclick,this);  
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_documento_historico_wf'
			},
			type:'Field',
			form:true 
		},
		
		{
			config:{
				name: 'version',
				fieldLabel: 'Versión',
				allowBlank: true,
				anchor: '80%',
				gwidth: 50,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'dhw.version',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                fieldLabel: "Archivo",
                gwidth: 60,
                inputType:'file',
                name: 'archivo',
                buttonText: '',   
                maxLength:150,
                anchor:'100%',
                renderer:function (value, p, record){  
                            if(record.data['url'].length!=0) {                                
                                return  String.format('{0}',"<div style='text-align:center'><a target=_blank align='center' width='70' height='70'>Abrir</a></div>");
                            }
                        },  
                buttonCfg: {
                    iconCls: 'upload-icon'
                }
            },
            type:'Field',
            sortable:false,
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'dhw.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
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
				filters:{pfiltro:'dhw.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Histórico',
	ActSave:'../../sis_workflow/control/DocumentoHistoricoWf/insertarDocumentoHistoricoWf',
	ActDel:'../../sis_workflow/control/DocumentoHistoricoWf/eliminarDocumentoHistoricoWf',
	ActList:'../../sis_workflow/control/DocumentoHistoricoWf/listarDocumentoHistoricoWf',
	id_store:'id_documento_historico_wf',
	fields: [
		{name:'id_documento_historico_wf', type: 'numeric'},
		{name:'id_documento', type: 'numeric'},
		{name:'url', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'url_old', type: 'string'},
		{name:'version', type: 'numeric'},
		{name:'vigente', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'extension'
		
	],
	sortInfo:{
		field: 'id_documento_historico_wf',
		direction: 'ASC'
	},

    taskOne: function(record) {
        var data = "id=" + record.data['id_documento_wf'];
        data += "&extension=" + record.data['extension'];
        data += "&sistema=sis_workflow";
        data += "&clase=DocumentoWf";
        data += "&url="+record.data['url'];
        //return  String.format('{0}',"<div style='text-align:center'><a target=_blank href = '../../../lib/lib_control/CTOpenFile.php?"+ data+"' align='center' width='70' height='70'>Abrir</a></div>");
        window.open('../../../lib/lib_control/CTOpenFile.php?' + data);
    },
    taskTwo: function(record){
        
        Ext.Ajax.request({
            url : '../../sis_workflow/control/DocumentoWf/insertarRegistroOpenDoc',
            params : {
                id_documento_historico_wf  : record.data.id_documento_historico_wf,
                id_documento_wf	           : record.data.id_documento,
                historico                  : 'si',
                id_proceso_wf              : null,
                id_tipo_documento          : null,
                url                        : record.data.url,
                extension                  : record.data.extension,
                action                     : null
            },
            success : function (resp) {
                var reg = Ext.decode(Ext.util.Format.trim(resp.responseText));
                if(!reg.ROOT.error) {
                    this.reload();
                }
            },
            failure : this.conexionFailure,
            timeout : this.timeout,
            scope : this
        });
    },
	oncellclick : function(grid, rowIndex, columnIndex, e) {
	    var record = this.store.getAt(rowIndex);  // Get the Record
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name

        //Modificado por Breydi vasquez 20/02/2020

	    if (fieldName == 'archivo' && record.data['url'].length!=0) {
            var that = this;
            async function main() {
                try {
                    await Promise.all([that.taskOne(record), that.taskTwo(record)]);
                } catch (error) {
                    alert(error + ' Comuniquece con el Departamento de Sistemas');
                }
            }
            main();
	    }
	    // fin breydi vasquez
		
	},
	onReloadPage:function(m){
		
       this.maestro=m;
       this.store.baseParams={id_documento_wf:this.maestro.id_documento_wf};
       this.load({params:{start:0, limit:50}});
       
       
     },
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false
	}
)
</script>
		
		