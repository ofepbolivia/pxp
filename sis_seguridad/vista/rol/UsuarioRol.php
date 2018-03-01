<?php
/**
*@package pXP
*@file gen-UsuarioGrupoEp.php
*@author  (admin)
*@ate 22-04-2013 15:53:08
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UsuarioRol=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UsuarioRol.superclass.constructor.call(this,config);
		this.init();
        //si la interface es pestanha este código es para iniciar
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else {
             this.bloquearMenus();
          }
        },

        Atributos:[
            {
        //configuracion del componente
        config:{
            labelSeparator:'',
            inputType:'hidden',
            name: 'id_rol'
        },
        type:'Field',
        form:true
         },
         {
        config:{
            name: 'nombre',
            fieldLabel: 'Nombre',
            allowBlank: true,
            anchor: '80%',
            gwidth: 200,
            maxLength:100

        },
        type:'TextField',
        grid:true,
        form:false
        }
	    ],
    tam_pag:50,
	title:'Usuario Rol',
    ActList:'../../sis_seguridad/control/Rol/listarRolUsuario',
	id_store:'nombre',
	fields: [
		{name:'id_rol', type: 'numeric'},
		{name:'nombre', type: 'string'}

	],
    sortInfo:{
        field: 'nombre',
        direction: 'ASC'
    },
    bdel:false,
    bsave:false,
    bnew:false,
    bedit:false,
	onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_rol:this.maestro.id_rol};
        this.load({params: {start: 0, limit: 50}});
    },
    loadValoresIniciales: function () {
        this.Cmp.id_rol.setValue(this.maestro.id_rol);
        Phx.vista.UsuarioRol.superclass.loadValoresIniciales.call(this);
    }


	}
)
</script>
