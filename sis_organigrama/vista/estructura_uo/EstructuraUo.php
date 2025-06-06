<?php
/**
 * @package pXP
 * @file EstructuraUO.php
 * @author KPLIAN (admin)
 * @date 14-02-2011
 * @description  Vista para registrar las estructura de las Unidades Organizacionales
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.EstructuraUo = function (config) {
        this.Atributos = [
            //Primera posicion va el identificador de nodo
            {
                // configuracion del componente (el primero siempre es el
                // identificador)
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_estructura_uo'

                },
                type: 'Field',
                form: true
            },

            {
                // configuracion del componente (el primero siempre es el
                // identificador)
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_uo'

                },
                type: 'Field',
                form: true
            },
            //En segunda posicion siempre va el identificador del nodo padre
            {
                // configuracin del componente
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_uo_padre'

                },
                type: 'Field',
                form: true
            },
            {
                config: {
                    fieldLabel: "Código",
                    gwidth: 120,
                    name: 'codigo',
                    allowBlank: false,
                    anchor: '100%'

                },
                type: 'Field',
                id_grupo: 0,
                form: true
            },

            {
                config: {
                    name: 'id_nivel_organizacional',
                    fieldLabel: 'Nivel Organizacional',
                    allowBlank: false,
                    emptyText: 'Nivel...',
                    store: new Ext.data.JsonStore(
                        {
                            url: '../../sis_organigrama/control/NivelOrganizacional/listarNivelOrganizacional',
                            id: 'id_nivel_organizacional',
                            root: 'datos',
                            sortInfo: {
                                field: 'numero_nivel',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_nivel_organizacional', 'numero_nivel', 'nombre_nivel'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams: {par_filtro: 'nivorg.numero_nivel#nivorg.nombre_nivel'}
                        }),
                    valueField: 'id_nivel_organizacional',
                    displayField: 'nombre_nivel',
                    gdisplayField: 'nombre_nivel',
                    hiddenName: 'id_nivel_organizacional',
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 50,
                    queryDelay: 500,
                    anchor: "100%",
                    gwidth: 150,
                    minChars: 2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{numero_nivel}</p><p>{nombre_nivel}</p></div></tpl>',
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['nombre_nivel']);
                    }
                },
                type: 'ComboBox',
                filters: {pfiltro: 'ofi.nombre', type: 'string'},
                id_grupo: 0,
                grid: true,
                form: true
            },

            {
                config: {
                    fieldLabel: "Nombre",
                    gwidth: 120,
                    name: 'nombre_unidad',
                    allowBlank: false,
                    anchor: '100%'

                },
                type: 'TextField',
                id_grupo: 0,
                form: true
            },
            {
                config: {
                    fieldLabel: "Descripción",
                    gwidth: 120,
                    name: 'descripcion',
                    allowBlank: false,
                    anchor: '100%'
                },
                type: 'Field',
                id_grupo: 0,
                form: true
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
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['nombre']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 1,
                filters: {pfiltro: 'tcargo.nombre', type: 'string'},
                grid: true,
                form: true
            },

            /*{
                config:{
                    fieldLabel: "Cargo",
                    gwidth: 120,
                    name: 'nombre_cargo',
                    allowBlank:false,
                    anchor:'100%'

                },
                type:'TextField',
                id_grupo:0,
                form:true
            },*/
            {
                config: {
                    fieldLabel: "Cargo Individual",
                    gwidth: 120,
                    name: 'cargo_individual',
                    allowBlank: false,
                    anchor: '100%',
                    typeAhead: true,
                    allowBlank: false,
                    triggerAction: 'all',
                    emptyText: 'Seleccione una opcion...',
                    selectOnFocus: true,
                    mode: 'local',
                    /*store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['si','si'],
                            ['no','no']]

                    }),*/
                    store: ['si', 'no'],
                    valueField: 'ID'

                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            },

            {
                config: {
                    name: 'presupuesta',
                    fieldLabel: 'Presupuesta',
                    typeAhead: true,
                    allowBlank: false,
                    triggerAction: 'all',
                    emptyText: 'Seleccione una opcion...',
                    selectOnFocus: true,
                    mode: 'local',
                    store: ['si', 'no'],
                    /*store:new Ext.data.ArrayStore({
                        fields: ['ID', 'valor'],
                        data :	[['si','si'],
                                ['no','no']]

                        }),*/
                    valueField: 'ID',
                    width: 150,

                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            },
            {
                config: {
                    name: 'nodo_base',
                    fieldLabel: 'Nodo Base',
                    typeAhead: true,
                    allowBlank: false,
                    triggerAction: 'all',
                    emptyText: 'Seleccione Opcion...',
                    selectOnFocus: true,
                    mode: 'local',
                    /*store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['si','si'],
                            ['no','no']]

                    }),*/
                    store: ['si', 'no'],
                    valueField: 'ID',
                    displayField: 'valor',
                    width: 150,
                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            },
            {
                config: {
                    name: 'correspondencia',
                    fieldLabel: 'Correspondencia',
                    typeAhead: true,
                    allowBlank: false,
                    triggerAction: 'all',
                    emptyText: 'Seleccione Opcion...',
                    selectOnFocus: true,
                    mode: 'local',
                    /*store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['si','si'],
                            ['no','no']]

                    }),*/
                    store: ['si', 'no'],
                    valueField: 'ID',
                    displayField: 'valor',
                    width: 150,
                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            }
            ,
            {
                config: {
                    name: 'gerencia',
                    fieldLabel: 'Gerencia',
                    typeAhead: true,
                    allowBlank: false,
                    triggerAction: 'all',
                    emptyText: 'Seleccione Opcion...',
                    selectOnFocus: true,
                    mode: 'local',
                    /*store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :	[['si','si'],
                            ['no','no']]

                    }),*/
                    store: ['si', 'no'],
                    valueField: 'ID',
                    displayField: 'valor',
                    width: 150,

                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            },
            {
                config: {
                    fieldLabel: "Prioridad",
                    gwidth: 120,
                    name: 'prioridad',
                    allowBlank: true,
                    anchor: '100%'

                },
                type: 'TextField',
                id_grupo: 0,
                form: true
            },
            {
                config: {
                    fieldLabel: "Centro Costo",
                    gwidth: 120,
                    name: 'desc_tcc',
                    allowBlank: true,
                    anchor: '100%',
                    disabled: true,
                    style: {fontWeight: 'bolder', color: 'red'}
                },
                type: 'TextField',
                id_grupo: 2,
                form: true
            },
            {
                config: {
                    fieldLabel: "Categoria",
                    gwidth: 120,
                    name: 'codigo_categoria',
                    allowBlank: true,
                    anchor: '100%',
                    disabled: true,
                    style: {fontWeight: 'bolder', color: 'red'}
                },
                type: 'TextField',
                id_grupo: 2,
                form: true
            }
        ];

        Phx.vista.EstructuraUo.superclass.constructor.call(this, config);
        /*this.addButton('btnReporteFun',	{
                text: 'Funcionarios',
                //iconCls: 'bchecklist',
                disabled: false,
                handler: this.onBtnReporteFun,
                tooltip: '<b>Funcionarios</b><br/>Listado de funcionarios por unidad organizacional'
            }
        );*/

        this.addButton('btnCargo', {
                text: 'Items',
                iconCls: 'bcargo',
                disabled: false,
                handler: this.onBtnCargos,
                tooltip: '<b>Cargos</b><br/>Listado de cargos por unidad organizacional'
            }
        );

        this.addButton('btnAnexo', {
                text: 'Contrato Anexo',
                iconCls: 'bmoney',
                disabled: false,
                handler: this.onBtnContratoAnexo,
                tooltip: '<b>Anexo</b><br/>Listado de Anexos por UO.'
            }
        );
        //fRnk: adicionado reporte, req. d) HR01765-2024
        this.addButton('exp_menu', {
            text: 'Exportar', iconCls: 'bexport', disabled: false, tooltip: '<b>Permite exportar el organigrama</b>',
            menu: {
                items: [
                    {
                        text: 'PDF', handler: this.expReport, scope: this, argument: {tipo: 'pdf'}
                    }, {
                        text: 'CSV', handler: this.expReport, scope: this, argument: {tipo: 'xls'}
                    }
                ]
            }
        });
        //coloca elementos en la barra de herramientas
        this.tbar.add('->');
        this.tbar.add(' Filtrar:');
        this.tbar.add(this.datoFiltro);
        this.tbar.add('Inactivos:');
        this.tbar.add(this.checkInactivos);
        //de inicio bloqueamos el botono nuevo
        //this.tbar.items.get('b-new-'+this.idContenedor).disable()
        this.init();
        this.loaderTree.baseParams = {id_subsistema: this.id_subsistema};
        this.rootVisible = false;
        this.iniciarEventos();
    }

    Ext.extend(Phx.vista.EstructuraUo, Phx.arbInterfaz, {
            datoFiltro: new Ext.form.Field({
                allowBlank: true,
                enableKeyEvents: true,
                width: 150
            }),
            checkInactivos: new Ext.form.Checkbox({
                width: 25
            }),
            title: 'Unidad Organizacional',
            ActSave: '../../sis_organigrama/control/EstructuraUo/guardarEstructuraUo',
            ActDel: '../../sis_organigrama/control/EstructuraUo/eliminarEstructuraUo',
            ActList: '../../sis_organigrama/control/EstructuraUo/listarEstructuraUo',
            ActDragDrop: '../../sis_organigrama/control/EstructuraUo/procesarDragDrop',
            //id_store : 'id_uo',
            enableDD: true,
            expanded: false,
            fheight: '75%',
            fwidth: '70%',
            textRoot: 'Estructura Organizacional',
            id_nodo: 'id_uo',
            id_nodo_p: 'id_uo_padre',
            idNodoDD: 'id_uo',
            idOldParentDD: 'id_uo_padre',
            idTargetDD: 'id_uo',
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
                'nodo_base', 'correspondencia', 'gerencia', 'prioridad'],
            sortInfo: {
                field: 'id',
                direction: 'ASC'
            },

            onNodeDrop: function (o) {
                Ext.Msg.show({
                    title: 'ORGANIGRAMA ERP',
                    msg: '<b style="color: red;">Esta segur@ de realizar el Cambio de Unidad Organizacional.</b>',
                    fn: function (btn) {
                        if (btn == 'ok') {
                            this.ddParams = {
                                tipo_nodo: o.dropNode.attributes.tipo_nodo
                            };
                            this.idTargetDD = 'id_uo';
                            if (o.dropNode.attributes.tipo_nodo == 'raiz' || o.dropNode.attributes.tipo_nodo == 'hijo') {
                                this.idNodoDD = 'id_uo';
                                this.idOldParentDD = 'id_uo_padre';
                            } else if (o.dropNode.attributes.tipo_nodo == 'item') {
                                this.idNodoDD = 'id_item';
                                this.idOldParentDD = 'id_p';
                            }

                            Phx.vista.EstructuraUo.superclass.onNodeDrop.call(this, o);
                        }
                    },
                    buttons: Ext.Msg.OKCANCEL,
                    width: 350,
                    maxWidth: 500,
                    icon: Ext.Msg.WARNING,
                    scope: this
                });
            },
            onButtonAct: function () {
                this.sm.clearSelections();
                var dfil = this.datoFiltro.getValue();
                var dcheck = this.checkInactivos.getValue();

                if (dfil && dfil != '') {
                    if (dcheck) {
                        this.loaderTree.baseParams = {filtro: 'activo', criterio_filtro_arb: dfil, p_activos: 'no'};
                    } else {
                        this.loaderTree.baseParams = {filtro: 'activo', criterio_filtro_arb: dfil};
                    }
                    this.root.reload();
                } else {
                    this.loaderTree.baseParams = {filtro: 'inactivo', criterio_filtro_arb: ''};
                    this.root.reload();
                }
            },

            /*onBtnReporteFun: function(){
                var node = this.sm.getSelectedNode();
                var data = node.attributes;
                Phx.CP.loadWindows('../../../sis_organigrama/vista/estructura_uo/RepFuncionarioUo.php',
                        'Funcionarios',
                        {
                            width:1000,
                            height:600
                        },
                        data,
                        this.idContenedor,
                        'RepFuncionarioUo'
                );
            },	*/

            onBtnCargos: function () {
                var node = this.sm.getSelectedNode();
                var data = node.attributes;
                Phx.CP.loadWindows('../../../sis_organigrama/vista/cargo/Cargo.php',
                    'Items por Unidad',
                    {
                        width: 1000,
                        height: 600
                    },
                    data,
                    this.idContenedor,
                    'Cargo'
                );
            },

            onBtnContratoAnexo: function () {
                var node = this.sm.getSelectedNode();
                var data = node.attributes;
                console.log('node', data);
                Phx.CP.loadWindows('../../../sis_organigrama/vista/uo_contrato_anexo/UoContratoAnexo.php',
                    'UO Anexos',
                    {
                        width: 1000,
                        height: 600
                    },
                    data,
                    this.idContenedor,
                    'UoContratoAnexo'
                );
            },

            //sobrecarga prepara menu
            preparaMenu: function (n) {
                this.getBoton('btnCargo').enable();
                Phx.vista.EstructuraUo.superclass.preparaMenu.call(this, n);
            },
            liberaMenu: function () {
                this.getBoton('btnCargo').disable();
                Phx.vista.EstructuraUo.superclass.liberaMenu.call(this);
            },
            /*Sobre carga boton new */
            onButtonNew: function () {
                var nodo = this.sm.getSelectedNode();
                Ext.Ajax.request({
                    url: '../../sis_organigrama/control/Cargo/loadCargoPresupuesto',
                    params: {
                        id_uo: nodo.id
                    },
                    success: function (resp) {
                        var reg = (Ext.decode(Ext.util.Format.trim(resp.responseText))).ROOT.datos;
                        this.Cmp.desc_tcc.setValue(reg.desc_tcc);
                        this.Cmp.codigo_categoria.setValue(reg.codigo_categoria);
                    },
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
                Phx.vista.EstructuraUo.superclass.onButtonNew.call(this);
                //this.getComponente('id_uo_padre').setValue('');
                //this.getComponente('nivel').setValue((nodo.attributes.nivel*1)+1);
            },

            /*Sobre carga boton EDIT */
            onButtonEdit: function () {
                var nodo = this.sm.getSelectedNode();
                console.log('onButtonEdit', nodo);
                //this.getComponente('nivel').setValue((nodo.attributes.nivel*1)+1);

                /*if(nodo.attributes.tipo_dato=='interface'){
                    console.log(this.getComponente('nombre'))
                    //componente 5 y tipo_dato son el mismo
                    this.getComponente('tipo_dato').disable();
                    this.Componentes[5].setValue('interface');
                    this.getComponente('ruta_archivo').enable();
                    this.getComponente('icono').enable();
                    this.getComponente('clase_vista').enable();
                }
                else{

                    this.getComponente('tipo_dato').enable();
                    this.getComponente('ruta_archivo').disable();
                    this.getComponente('icono').disable();
                    this.getComponente('clase_vista').disable();
                }	*/

                Ext.Ajax.request({
                    url: '../../sis_organigrama/control/Cargo/loadCargoPresupuesto',
                    params: {
                        id_uo: nodo.id
                    },
                    success: function (resp) {
                        var reg = (Ext.decode(Ext.util.Format.trim(resp.responseText))).ROOT.datos;
                        this.Cmp.desc_tcc.setValue(reg.desc_tcc);
                        this.Cmp.codigo_categoria.setValue(reg.codigo_categoria);
                    },
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
                Phx.vista.EstructuraUo.superclass.onButtonEdit.call(this);
            },

            //estable el manejo de eventos del formulario
            iniciarEventos: function () {
                console.log(this.datoFiltro);
                this.datoFiltro.on('specialkey', function (field, e) {
                    if (e.getKey() == e.ENTER) {
                        this.onButtonAct();
                    }
                }, this)

                /*this.getComponente('tipo_dato').on('beforeselect',function(combo,record,index){
                    if(record.json[0]=='interface'){

                        this.getComponente('ruta_archivo').enable();
                        this.getComponente('icono').enable();
                        this.getComponente('clase_vista').enable();
                    }
                    else{
                        this.getComponente('ruta_archivo').disable();
                        this.getComponente('icono').disable();
                        this.getComponente('clase_vista').disable();
                    }
                },this)*/
            },
            /*
             * south:{ url:'../../sis_legal/vista/representante/representante.php',
             * title:'Representante', height:200 },
             */
            expReport: function (resp) {
                //fRnk: nuevo reporte HR01765-2024
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_organigrama/control/EstructuraUo/listarEstructuraUoExp',
                    params: {tipo: resp.argument.tipo},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            tabsouth: [
                {
                    url: '../../../sis_organigrama/vista/uo_funcionario/UOFuncionario.php',
                    title: 'Asignacion de Funcionarios a Unidad',
                    height: '50%',
                    cls: 'uo_funcionario'
                },
                {
                    url: '../../../sis_organigrama/vista/uo_funcionario_ope/UoFuncionarioOpe.php',
                    title: 'Asignaciones Operativas',
                    qtip: 'Cuando el funcionario funcionalmente tiene otra dependencia diferente a la jerárquica',
                    height: '50%',
                    cls: 'UoFuncionarioOpe'
                }

            ],
            bdel: true,// boton para eliminar
            bsave: false,// boton para eliminar
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
                        },
                        {
                            bodyStyle: 'padding-right:10px;',
                            items: [
                                {
                                    xtype: 'fieldset',
                                    title: '<b style="color: green;">DATOS PRESUPUESTO<b>',
                                    autoHeight: true,
                                    items: [],
                                    id_grupo: 2
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