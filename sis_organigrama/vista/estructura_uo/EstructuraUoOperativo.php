<?php
/**
 *@package pXP
 *@file EstructuraUO.php
 *@author KPLIAN (admin)
 *@date 14-02-2011
 *@description  Vista para registrar las estructura de las Unidades Organizacionales
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.EstructuraUoOperativo=function(config){

        this.Atributos =[
            //Primera posicion va el identificador de nodo
            {
                // configuracion del componente (el primero siempre es el
                // identificador)
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_estructura_uo'

                },
                type:'Field',
                form:true

            },

            {
                // configuracion del componente (el primero siempre es el
                // identificador)
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_uo'

                },
                type:'Field',
                form:true

            },
            //En segunda posicion siempre va el identificador del nodo padre
            {
                // configuracin del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name:'id_uo_padre_operativo'

                },
                type:'Field',
                form:true

            },
            {
                config:{
                    fieldLabel: "Código",
                    gwidth: 120,
                    name: 'codigo',
                    allowBlank:false,
                    anchor:'100%'

                },
                type:'Field',
                id_grupo:0,
                form:true
            },

            {
                config:{
                    name: 'id_nivel_organizacional',
                    fieldLabel: 'Nivel Organizacional',
                    allowBlank: false,
                    emptyText:'Nivel...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_organigrama/control/NivelOrganizacional/listarNivelOrganizacional',
                            id: 'id_nivel_organizacional',
                            root: 'datos',
                            sortInfo:{
                                field: 'numero_nivel',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_nivel_organizacional','numero_nivel','nombre_nivel'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'nivorg.numero_nivel#nivorg.nombre_nivel'}
                        }),
                    valueField: 'id_nivel_organizacional',
                    displayField: 'nombre_nivel',
                    gdisplayField:'nombre_nivel',
                    hiddenName: 'id_nivel_organizacional',
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    anchor:"100%",
                    gwidth:150,
                    minChars:2,
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{numero_nivel}</p><p>{nombre_nivel}</p></div></tpl>',
                    renderer:function (value, p, record){return String.format('{0}', record.data['nombre_nivel']);}
                },
                type:'ComboBox',
                filters:{pfiltro:'ofi.nombre',type:'string'},
                id_grupo:0,
                grid:true,
                form:true
            },

            {
                config:{
                    fieldLabel: "Nombre",
                    gwidth: 120,
                    name: 'nombre_unidad',
                    allowBlank:false,
                    anchor:'100%'

                },
                type:'TextField',
                id_grupo:0,
                form:true
            },
            {
                config:{
                    fieldLabel: "Descripción",
                    gwidth: 120,
                    name: 'descripcion',
                    allowBlank:false,
                    anchor:'100%'
                },
                type:'Field',
                id_grupo:0,
                form:true
            },

            {
                config: {
                    name: 'nombre_cargo',
                    fieldLabel: 'Cargo',
                    allowBlank: false,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_organigrama/control/TemporalCargo/listarTemporalCargo',
                        id: 'id_temporal_cargo',
                        root: 'datos',
                        sortInfo: {
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_temporal_cargo', 'nombre'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'cargo.nombre'}
                    }),
                    valueField: 'nombre',
                    displayField: 'nombre',
                    gdisplayField: 'nombre',
                    hiddenName: 'nombre',
                    forceSelection: false,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '100%',
                    gwidth: 200,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['nombre']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 1,
                filters: {pfiltro: 'tcargo.nombre',type: 'string'},
                grid: true,
                form: true
            },
            {
                config:{
                    fieldLabel: "Cargo Individual",
                    gwidth: 120,
                    name: 'cargo_individual',
                    allowBlank:false,
                    anchor:'100%',
                    typeAhead: true,
                    allowBlank:false,
                    triggerAction: 'all',
                    emptyText:'Seleccione una opcion...',
                    selectOnFocus:true,
                    mode:'local',
                    store:['si','no'],
                    valueField:'ID'

                },
                type:'ComboBox',
                id_grupo:1,
                form:true
            },

            {   config:{
                    name:'presupuesta',
                    fieldLabel:'Presupuesta',
                    typeAhead: true,
                    allowBlank:false,
                    triggerAction: 'all',
                    emptyText:'Seleccione una opcion...',
                    selectOnFocus:true,
                    mode:'local',
                    store:['si','no'],
                    valueField:'ID',
                    width:150,

                },
                type:'ComboBox',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name:'nodo_base',
                    fieldLabel:'Nodo Base',
                    typeAhead: true,
                    allowBlank:false,
                    triggerAction: 'all',
                    emptyText:'Seleccione Opcion...',
                    selectOnFocus:true,
                    mode:'local',
                    store:['si','no'],
                    valueField:'ID',
                    displayField:'valor',
                    width:150,

                },
                type:'ComboBox',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    name:'correspondencia',
                    fieldLabel:'Correspondencia',
                    typeAhead: true,
                    allowBlank:false,
                    triggerAction: 'all',
                    emptyText:'Seleccione Opcion...',
                    selectOnFocus:true,
                    mode:'local',
                    store:['si','no'],
                    valueField:'ID',
                    displayField:'valor',
                    width:150,

                },
                type:'ComboBox',
                id_grupo:1,
                form:true
            }
            ,
            {
                config:{
                    name:'gerencia',
                    fieldLabel:'Gerencia',
                    typeAhead: true,
                    allowBlank:false,
                    triggerAction: 'all',
                    emptyText:'Seleccione Opcion...',
                    selectOnFocus:true,
                    mode:'local',
                    store:['si','no'],
                    valueField:'ID',
                    displayField:'valor',
                    width:150,

                },
                type:'ComboBox',
                id_grupo:1,
                form:true
            },
            {
                config:{
                    fieldLabel: "Prioridad",
                    gwidth: 120,
                    name: 'prioridad',
                    allowBlank:true,
                    anchor:'100%'

                },
                type:'TextField',
                id_grupo:0,
                form:true
            },
        ];

        Phx.vista.EstructuraUoOperativo.superclass.constructor.call(this,config);

        this.addButton('btnCargo',	{
                text: 'Items',
                iconCls: 'bcargo',
                disabled: false,
                handler: this.onBtnCargos,
                tooltip: '<b>Cargos</b><br/>Listado de cargos por unidad organizacional'
            }
        );

        //coloca elementos en la barra de herramientas
        this.tbar.add('->');
        this.tbar.add(' Filtrar:');
        this.tbar.add(this.datoFiltro);
        this.tbar.add('Inactivos:');
        this.tbar.add(this.checkInactivos);

        //de inicio bloqueamos el botono nuevo
        //this.tbar.items.get('b-new-'+this.idContenedor).disable()


        this.init();

        this.loaderTree.baseParams={id_subsistema:this.id_subsistema};
        this.rootVisible=false;
        this.iniciarEventos();


    }


    Ext.extend(Phx.vista.EstructuraUoOperativo,Phx.arbInterfaz,{
            datoFiltro:new Ext.form.Field({
                allowBlank:true,
                enableKeyEvents : true,
                width: 150}),
            checkInactivos:new Ext.form.Checkbox({
                width: 25}),
            title:'Unidad Organizacional',
            ActList:'../../sis_organigrama/control/EstructuraUo/listarEstructuraUoOperativo',
            ActDragDrop:'../../sis_organigrama/control/EstructuraUo/procesarDragDropOperativo',
            //id_store : 'id_uo',
            enableDD:true,
            expanded:false,

            fheight:'75%',
            fwidth:'70%',
            textRoot:'Estructura Organizacional',
            id_nodo:'id_uo',
            id_nodo_p:'id_uo_padre_operativo',
            idNodoDD : 'id_uo',
            idOldParentDD : 'id_uo_padre_operativo',
            idTargetDD : 'id_uo',
            fields: [
                'id', //identificador unico del nodo (concatena identificador de tabla con el tipo de nodo)
                      //porque en distintas tablas pueden exitir idetificadores iguales
                'tipo_meta',
                'id_nivel_organizacional',
                'nombre_nivel',
                'tipo_meta',
                'id_estructura_uo',
                'id_uo',
                'id_uo_padre',
                'codigo',
                'descripcion',
                'nombre_unidad',
                'nombre_cargo',
                'presupuesta',
                'nodo_base','correspondencia','gerencia','prioridad', 'id_uo_padre_operativo',],
            sortInfo:{
                field: 'id',
                direction:'ASC'
            },

            onNodeDrop : function(o) {
                this.ddParams = {
                    tipo_nodo : o.dropNode.attributes.tipo_nodo
                };
                this.idTargetDD = 'id_uo';
                if (o.dropNode.attributes.tipo_nodo == 'raiz' || o.dropNode.attributes.tipo_nodo == 'hijo') {
                    this.idNodoDD = 'id_uo';
                    this.idOldParentDD = 'id_uo_padre_operativo';
                } else if(o.dropNode.attributes.tipo_nodo == 'item') {
                    this.idNodoDD = 'id_item';
                    this.idOldParentDD = 'id_p';
                }
                Phx.vista.EstructuraUoOperativo.superclass.onNodeDrop.call(this, o);
            },
            onButtonAct:function(){

                this.sm.clearSelections();
                var dfil = this.datoFiltro.getValue();
                var dcheck = this.checkInactivos.getValue();

                if(dfil && dfil!=''){
                    if (dcheck) {
                        this.loaderTree.baseParams={filtro:'activo',criterio_filtro_arb:dfil, p_activos : 'no'};
                    } else {
                        this.loaderTree.baseParams={filtro:'activo',criterio_filtro_arb:dfil};
                    }
                    this.root.reload();
                }
                else
                {
                    this.loaderTree.baseParams={filtro:'inactivo',criterio_filtro_arb:''};
                    this.root.reload();
                }
            },


            onBtnCargos: function(){
                var node = this.sm.getSelectedNode();
                var data = node.attributes;
                Phx.CP.loadWindows('../../../sis_organigrama/vista/cargo/Cargo.php',
                    'Items por Unidad',
                    {
                        width:1000,
                        height:600
                    },
                    data,
                    this.idContenedor,
                    'Cargo'
                );
            },


            //sobrecarga prepara menu
            preparaMenu:function(n) {
                this.getBoton('btnCargo').enable();
                Phx.vista.EstructuraUoOperativo.superclass.preparaMenu.call(this,n);
            },
            liberaMenu : function () {
                this.getBoton('btnCargo').disable();
                Phx.vista.EstructuraUoOperativo.superclass.liberaMenu.call(this);
            },
            /*Sobre carga boton new */
            onButtonNew:function(){
                var nodo = this.sm.getSelectedNode();
                Phx.vista.EstructuraUoOperativo.superclass.onButtonNew.call(this);
                //this.getComponente('id_uo_padre').setValue('');
                //this.getComponente('nivel').setValue((nodo.attributes.nivel*1)+1);
            },

            /*Sobre carga boton EDIT */
            onButtonEdit:function(){

                var nodo = this.sm.getSelectedNode();

                Phx.vista.EstructuraUoOperativo.superclass.onButtonEdit.call(this);
            },



            //estable el manejo de eventos del formulario
            iniciarEventos:function(){

                console.log(this.datoFiltro);
                this.datoFiltro.on('specialkey',function(field, e){
                    if (e.getKey() == e.ENTER) {
                        this.onButtonAct();
                    }
                },this)

            },

            tabsouth:[
                {
                    url:'../../../sis_organigrama/vista/uo_funcionario/UOFuncionario.php',
                    title:'Asignacion de Funcionarios a Unidad',
                    height:'50%',
                    cls:'uo_funcionario'
                },
                {
                    url:'../../../sis_organigrama/vista/uo_funcionario_ope/UoFuncionarioOpe.php',
                    title:'Asignaciones Operativas',
                    qtip: 'Cuando el funcionario funcionalmente tiene otra dependencia diferente a la jerárquica',
                    height:'50%',
                    cls:'UoFuncionarioOpe'
                }

            ],

            bdel:false,// boton para eliminar
            bsave:false,// boton para eliminar
            bedit: false,
            bnew: false,
            btest: false,
            //DEFINIE LA ubicacion de los datos en el formulario


            Grupos: [
                {
                    layout: 'column',
                    border: false,
                    labelAlign: 'top',
                    defaults: {
                        border: false
                    },

                    items: [
                        {
                            bodyStyle: 'padding-right:10px;',
                            items: [

                                {
                                    xtype: 'fieldset',
                                    title: '<b style="color: green;">DATOS UO<b>',
                                    autoHeight: true,
                                    items: [],
                                    id_grupo: 0

                                }

                            ],
                            columnWidth: .5
                        },
                        {
                            bodyStyle: 'padding-right:10px;',
                            items: [
                                {
                                    xtype: 'fieldset',
                                    title: '<b style="color: green;">DATOS CARGO<b>',
                                    autoHeight: true,
                                    items: [],
                                    id_grupo: 1
                                }
                            ],
                            columnWidth: .5
                        }

                    ]
                }
            ]



        }
    )
</script>