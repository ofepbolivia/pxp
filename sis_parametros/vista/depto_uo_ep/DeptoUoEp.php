<?php
/**
*@package pXP
*@file gen-DeptoUoEp.php
*@author  (admin)
*@date 03-06-2013 15:15:03
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.DeptoUoEp=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.DeptoUoEp.superclass.constructor.call(this,config);
		
		this.addButton('add_ep',{text:'Todas las EP\'s', iconCls: 'blist',disabled:true,handler:this.sinc_ep,tooltip: '<b>EP\'s</b><br/>Adicionar todas las EP\'s '});
        this.addButton('add_uo',{text:'Todas las UO\'s', iconCls: 'blist',disabled:true,handler:this.sinc_uo,tooltip: '<b>EP\'s</b><br/>Adicionar todas las UO\'s '});
        
		
		
		this.init();
		this.bloquearMenus();
		if(Phx.CP.getPagina(this.idContenedorPadre)){
         var dataMaestro=Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
         if(dataMaestro){ 
            this.onEnablePanel(this,dataMaestro)
            }
         }
		
		
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_depto_uo_ep'
			},
			type:'Field',
			form:true 
		},
		{ config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_depto'
        
            },
            type:'Field',
            form:true 
            
       },
		{
            config:{
                name:'id_uo',
                origen:'UO',
                fieldLabel:'Unidad',
                baseParams:{presupuesta:'si'},
                allowBlank:true,
                gdisplayField:'desc_uo',//mapea al store del grid
                gwidth:280,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}     },
                type:'ComboRec',
                id_grupo:0,
                filters:{   
                        pfiltro:'nombre_unidad',
                        type:'string'
                    },

            bottom_filter: true,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'estado_reg_uo',
                fieldLabel: 'Estado Unidad',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            //filters:{pfiltro:'estado_reg_uo',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
            config:{
                    name:'id_ep',
                    origen:'EP',
                    fieldLabel:'EP',
                    allowBlank:true,
                    gdisplayField:'ep',//mapea al store del grid
                    gwidth:200,
                    renderer:function (value, p, record){return String.format('{0}', record.data['ep']);}
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'ep',type:'string'},
            grid:true,
            form:true
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
			filters:{pfiltro:'due.estado_reg',type:'string'},
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
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'due.fecha_reg',type:'date'},
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
			filters:{pfiltro:'due.fecha_mod',type:'date'},
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
		}
	],
	
	title:'DEPTO, UO, EP',
	ActSave:'../../sis_parametros/control/DeptoUoEp/insertarDeptoUoEp',
	ActDel:'../../sis_parametros/control/DeptoUoEp/eliminarDeptoUoEp',
	ActList:'../../sis_parametros/control/DeptoUoEp/listarDeptoUoEp',
	id_store:'id_depto_uo_ep',
	fields: [
		{name:'id_depto_uo_ep', type: 'numeric'},
		{name:'id_uo', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_ep', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'ep','desc_uo',
        'estado_reg_uo'
		
	],
	sortInfo:{
		field: 'id_depto_uo_ep',
		direction: 'DESC'
	},
	
	sinc_ep:function(){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_parametros/control/DeptoUoEp/sincUoEp',
                params:{'id_depto':this.maestro.id_depto, 'config':'ep'},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
   },
   sinc_uo:function(){
           Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_parametros/control/DeptoUoEp/sincUoEp',
                params:{'id_depto':this.maestro.id_depto, 'config':'uo'},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
   },
   
    successSinc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                alert(reg.ROOT.datos.msg)
                
            }else{
                alert('ocurrio un error durante el proceso')
            }
            this.reload();
    },
	
	
	bdel:true,
	bsave:true
	,
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_depto:this.maestro.id_depto};
      
        this.load({params:{start:0, limit:this.tam_pag}})
    },
	loadValoresIniciales:function(){
        Phx.vista.DeptoUoEp.superclass.loadValoresIniciales.call(this);
        this.Cmp.id_depto.setValue(this.maestro.id_depto);
    }
   }
)
</script>
		
		