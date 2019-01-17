/********************************************I-DAT-RCM-SEGU-0-15/01/2013********************************************/
/*
*	Author: RAC
*	Date: 21/12/2012
*	Description: Build the menu definition and the composition
*/


/*

Para  definir la la metadata, menus, roles, etc

1) sincronize ls funciones y procedimientos del sistema
2)  verifique que la primera linea de los datos sea la insercion del sistema correspondiente
3)  exporte los datos a archivo SQL (desde la interface de sistema en sis_seguridad),
    verifique que la codificacion  se mantenga en UTF8 para no distorcionar los caracteres especiales
4)  remplaze los sectores correspondientes en este archivo en su totalidad:  (el orden es importante)
                             menu,
                             funciones,
                             procedimietnos

*/




INSERT INTO segu.tsubsistema (id_subsistema, codigo, nombre, fecha_reg, prefijo, estado_reg, nombre_carpeta, id_subsis_orig)
VALUES (0, 'PXP', 'FRAMEWORK', '2011-11-23', 'PXP', 'activo', 'FRAMEWORK', NULL);

INSERT INTO segu.tsubsistema ( codigo, nombre, fecha_reg, prefijo, estado_reg, nombre_carpeta, id_subsis_orig)
VALUES ('SEGU', 'Sistema de Seguridad', '2009-11-02', 'SG', 'activo', 'seguridad', NULL);




INSERT INTO segu.tgui ("id_gui", "nombre", "descripcion", "fecha_reg", "codigo_gui", "visible", "orden_logico", "ruta_archivo", "nivel", "icono", "id_subsistema", "clase_vista", "estado_reg", "modificado")
VALUES (0, E'SISTEMA', E'NODO RAIZ', E'2009-09-08', E'SISTEMA', E'si', 1, NULL, 0, NULL, 0, E'NODO RAIZ', E'activo', 1);




-------------------------------------
--DEFINICION DE INTERFACES
-----------------------------------
select pxp.f_insert_tgui ('SEGU', 'Seguridad', 'SEGU', 'si', 1, '', 1, '../../../lib/imagenes/segu32x32.png', 'Seguridad', 'SEGU');

select pxp.f_insert_tgui ('Interfaces', 'Gestion de interfaces por subsistema', 'GUISUB', 'no', 1, '/', 4, '', 'gui', 'SEGU');
select pxp.f_insert_tgui ('Procedimientos Gui', 'Asignacion de procedimientos por interfaz', 'PROGUI', 'no', 1, 'procedimiento_gui.js', 5, '', 'procedimiento_gui', 'SEGU');
select pxp.f_insert_tgui ('funciones', 'funciones', 'funciones', 'no', 2, 'funciones.js', 4, '', 'funciones', 'SEGU');
select pxp.f_insert_tgui ('Personas', 'Personas', 'Personas', 'si', 1, 'sis_seguridad/vista/reportes/persona.js', 3, '', 'repPersona', 'SEGU');
select pxp.f_insert_tgui ('Persona', 'persona', 'per', 'si', 7, 'sis_seguridad/vista/persona/Persona.php', 3, '', 'persona', 'SEGU');
select pxp.f_insert_tgui ('Usuario', 'usuario', 'USUARI', 'si', 2, 'sis_seguridad/vista/usuario/Usuario.php', 3, '', 'usuario', 'SEGU');
select pxp.f_insert_tgui ('Rol', 'rol', 'RROOLL', 'si', 3, 'sis_seguridad/vista/rol/Rol.php', 3, '', 'rol', 'SEGU');
select pxp.f_insert_tgui ('Clasificador', 'clasificador', 'CLASIF', 'si', 3, 'sis_seguridad/vista/clasificador/Clasificador.php', 3, '', 'clasificador', 'SEGU');
select pxp.f_insert_tgui ('Sistema', 'subsistema', 'SISTEM', 'si', 5, 'sis_seguridad/vista/subsistema/Subsistema.php', 3, '', 'Subsistema', 'SEGU');
select pxp.f_insert_tgui ('Libreta', 'Libreta', 'LIB', 'si', 100, 'sis_seguridad/vista/libreta_her/LibretaHer.php', 3, '', 'LibretaHer', 'SEGU');
select pxp.f_insert_tgui ('Procesos', '', 'PROCSEGU', 'si', 2, '', 2, '', '', 'SEGU');
select pxp.f_insert_tgui ('Parametros', '', 'o', 'si', 1, '', 2, '', '', 'SEGU');
select pxp.f_insert_tgui ('Interfaces por sistema', 'gui', '', 'no', 1, 'sis_seguridad/vista/gui/gui.js', 3, '', 'gui', 'SEGU');
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'RepSeg', 'si', 3, '', 2, '', '', 'SEGU');

select pxp.f_insert_tgui ('Estructura Dato', 'Estructura Dato', 'ESTDAT', 'no', 4, 'sis_seguridad/vista/estructura_dato/EstructuraDato.php', 3, '', 'estructura_dato', 'SEGU');

select pxp.f_insert_tgui ('Tipo Documento', 'tipo_documento', 'TIPDOC', 'si', 7, 'sis_seguridad/vista/tipo_documento/TipoDocumento.php', 3, '', 'tipo_documento', 'SEGU');
select pxp.f_insert_tgui ('Patrones de Eventos', 'Patrones de Eventos', 'PATROEVE', 'si', 8, 'sis_seguridad/vista/patron_evento/PatronEvento.php', 4, '', 'patron_evento', 'SEGU');
select pxp.f_insert_tgui ('Log', 'log', 'LOG', 'no', 4, 'sis_seguridad/vista/log/Log.php', 3, '', 'log', 'SEGU');
select pxp.f_insert_tgui ('Horarios de Trabajo', 'Horarios de Trabajo', 'HORTRA', 'si', 9, 'sis_seguridad/vista/horario_trabajo/HorarioTrabajo.php', 3, '', 'horario_trabajo', 'SEGU');
select pxp.f_insert_tgui ('Monitoreo y Análisis de Bitácoras', 'Herramienta para hacer seguimiento a eventos del sistema', 'MONANA', 'si', 6, '', 3, '', '', 'SEGU');
select pxp.f_insert_tgui ('Monitoreo', 'Monitoreo', 'MONITOR', 'si', 1, '', 4, '', '', 'SEGU');
select pxp.f_insert_tgui ('Análisis de Bitácoras', 'Análisis de Bitácoras', 'ANABIT', 'si', 2, '', 4, '', '', 'SEGU');
select pxp.f_insert_tgui ('Bloqueos', 'Bloqueos', 'BLOMON', 'si', 3, 'sis_seguridad/vista/bloqueo/Bloqueo.php', 4, '', 'bloqueo', 'SEGU');
select pxp.f_insert_tgui ('Notificaciones', 'Notificaciones', 'NOTMON', 'si', 4, 'sis_seguridad/vista/notificacion/Notificacion.php', 4, '', 'notificacion', 'SEGU');
select pxp.f_insert_tgui ('Monitor de Sistema', 'Monitor de Sistema', 'MONSIS', 'si', 1, 'sis_seguridad/vista/monitor_sistema/MonitorSistema.php', 5, '', 'monitor_sistema', 'SEGU');
select pxp.f_insert_tgui ('Monitor de Uso de Recursos', 'Monitor de Uso de Recursos', 'MONUSREC', 'si', 2, 'sis_seguridad/vista/monitor_recursos/MonitorRecursos.php', 4, '', 'monitor_recursos', 'SEGU');
select pxp.f_insert_tgui ('Monitor de Actividades en BD', 'Monitor de Actividades en BD', 'MONBD', 'si', 3, 'sis_seguridad/vista/monitor_bd/MonitorBD.php', 5, '', 'monitor_bd', 'SEGU');
select pxp.f_insert_tgui ('Monitor de Objetos de BD', 'Monitor de Objetos de BD', 'MONOJBD', 'si', 4, 'sis_seguridad/vista/monitor_objetos/MonitorObjetos.php', 5, '', 'monitor_objetos', 'SEGU');
select pxp.f_insert_tgui ('Bitácoras de Sistema', 'Bitácoras de Sistema', 'BITSIS', 'si', 1, 'sis_seguridad/vista/bitacora_sistema/BitacoraSistema.php', 5, '', 'bitacora_sistema', 'SEGU');
select pxp.f_insert_tgui ('Bitácoras de BD', 'Bitácoras de BD', 'BITBD', 'si', 2, 'sis_seguridad/vista/bitacora_bd/BitacoraBD.php', 5, '', 'bitacora_bd', 'SEGU');
select pxp.f_insert_tgui ('Trabajo Fuera de Horario', 'Trabajo Fuera de Horario', 'TRAHOR', 'si', 3, 'sis_seguridad/vista/fuera_horario/FueraHorario.php', 5, '', 'fuera_horario', 'SEGU');
select pxp.f_insert_testructura_gui ('SEGU', 'SISTEMA');
select pxp.f_insert_testructura_gui ('PROGUI', 'GUISUB');
select pxp.f_insert_testructura_gui ('funciones', 'SISTEM');
select pxp.f_insert_testructura_gui ('GUISUB', 'SISTEM');
select pxp.f_insert_testructura_gui ('PROCSEGU', 'SEGU');
select pxp.f_insert_testructura_gui ('o', 'SEGU');
select pxp.f_insert_testructura_gui ('RepSeg', 'SEGU');
select pxp.f_insert_testructura_gui ('MONANA', 'PROCSEGU');
select pxp.f_insert_testructura_gui ('RROOLL', 'PROCSEGU');
select pxp.f_insert_testructura_gui ('USUARI', 'PROCSEGU');
select pxp.f_insert_testructura_gui ('', 'PROCSEGU');
select pxp.f_insert_testructura_gui ('SISTEM', 'PROCSEGU');
select pxp.f_insert_testructura_gui ('LOG', 'PROCSEGU');
select pxp.f_insert_testructura_gui ('HORTRA', 'o');
select pxp.f_insert_testructura_gui ('PATROEVE', 'o');


select pxp.f_insert_testructura_gui ('ESTDAT', 'o');
select pxp.f_insert_testructura_gui ('CLASIF', 'o');


select pxp.f_insert_testructura_gui ('per', 'o');
select pxp.f_insert_testructura_gui ('TIPDOC', 'o');

select pxp.f_insert_testructura_gui ('Personas', 'RepSeg');
select pxp.f_insert_testructura_gui ('NOTMON', 'MONANA');
select pxp.f_insert_testructura_gui ('BLOMON', 'MONANA');
select pxp.f_insert_testructura_gui ('ANABIT', 'MONANA');
select pxp.f_insert_testructura_gui ('MONITOR', 'MONANA');
select pxp.f_insert_testructura_gui ('MONOJBD', 'MONITOR');
select pxp.f_insert_testructura_gui ('MONBD', 'MONITOR');
select pxp.f_insert_testructura_gui ('MONUSREC', 'MONITOR');
select pxp.f_insert_testructura_gui ('MONSIS', 'MONITOR');
select pxp.f_insert_testructura_gui ('TRAHOR', 'ANABIT');
select pxp.f_insert_testructura_gui ('BITBD', 'ANABIT');
select pxp.f_insert_testructura_gui ('BITSIS', 'ANABIT');


----------------------------------------------
--  DEF DE FUNCIONES
--------------------------------------------------


select pxp.f_insert_tfuncion ('segu.ft_usuario_proyecto_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_importar_menu', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_subsistema_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_subsistema_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_procedimiento_gui_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_rol_procedimiento_gui_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_grant_all_privileges', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_rol_sel', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_menu_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_regional_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_procedimiento_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_rol_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_bloqueo_notificacion_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_gui_rol_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_rol_procedimiento_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_log', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_sesion_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_validar_usuario_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_estructura_dato_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_libreta_her_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_regional_ime', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_libreta_her_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_procedimiento_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_gui_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_estructura_gui_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_clasificador_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_estructura_gui_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_procedimiento_gui_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_verif_eliminado', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_funcion_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_proyecto_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_funcion_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_get_id_usuario', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_rol_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_actividad_sel', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_tipo_documento_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_estructura_dato_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_patron_evento_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_monitorear_recursos', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_gui_ime', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.f_actualizar_log_bd', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_horario_trabajo_sel', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_patron_evento_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_clasificador_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_actividad_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_primo_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_gui_rol_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_actualizar_sesion', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_rol_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_persona_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_log_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_sesion_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_permiso_rol', 'Funcion para tabla     ', 'SEGU');

select pxp.f_insert_tfuncion ('segu.ft_monitor_bd_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_horario_trabajo_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_persona_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_configurar_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_bloqueo_notificacion_ime', 'Funcion para tabla     ', 'SEGU');



---------------------------------
--DEF DE PROCEDIMIETOS
---------------------------------



select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_ELI', '	Inactiva el subsistema selecionado
', 'si', '', '', 'segu.ft_subsistema_ime');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_MOD', '	Modifica el subsistema seleccionada
', 'si', '', '', 'segu.ft_subsistema_ime');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_INS', '	Inserta Subsistemas
', 'si', '', '', 'segu.ft_subsistema_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_CONT', '	Contar usuarios activos de sistema
', 'si', '', '', 'segu.ft_usuario_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_SEL', '	Listar usuarios activos de sistema
', 'si', '', '', 'segu.ft_usuario_sel');
select pxp.f_insert_tprocedimiento ('SEG_VALUSU_SEL', '	consulta los datos del usario segun contrasena y login
', 'si', '', '', 'segu.ft_usuario_sel');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_CONT', '	Contar  los subsistemas registrados del sistema
', 'si', '', '', 'segu.ft_subsistema_sel');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_SEL', '	Listado de los subsistemas registradas del sistema
', 'si', '', '', 'segu.ft_subsistema_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_ELI', '	Elimina Procedimiento_Gui
', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_MOD', '	Modifica Procedimiento_Gui
', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_INS', '	Inserta Procedimiento_Gui
', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_CONT', '	Cuenta Procesos por Gui y Rol
', 'si', '', '', 'segu.ft_rol_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPROLPROGUI_SEL', '	Listado de rol_procedimiento_gui de un subsistema para exportar
', 'si', '', '', 'segu.ft_rol_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_ROLPROGUI_SEL', '	Selecciona Procesos por Gui y Rol
', 'si', '', '', 'segu.ft_rol_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_CONT', '	cuenta los roles activos que corresponden al usuario
', 'si', '', '', 'segu.ft_usuario_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_SEL', '	Lista los roles activos que corresponden al usuario
', 'si', '', '', 'segu.ft_usuario_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_MENU_SEL', '	Arma el menu que aparece en la parte izquierda
                de la pantalla del sistema
', 'si', '', '', 'segu.ft_menu_sel');


select pxp.f_insert_tprocedimiento ('SEG_PROCED_ELI', '	Elimina Procedimiento
', 'si', '', '', 'segu.ft_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_MOD', '	Modifica Procedimiento
', 'si', '', '', 'segu.ft_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_INS', '	Inserta Procedimiento
', 'si', '', '', 'segu.ft_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_ELI', '	Eliminar Usuarios
', 'si', '', '', 'segu.ft_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_MOD', '	Modifica datos de  usuario
', 'si', '', '', 'segu.ft_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_INS', '	Inserta usuarios
', 'si', '', '', 'segu.ft_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_ELI', '	retira  el rol asignado a un uusario
', 'si', '', '', 'segu.ft_usuario_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_MOD', '	modifica roles de usuario
', 'si', '', '', 'segu.ft_usuario_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_INS', '	funcion para insertar usuario
', 'si', '', '', 'segu.ft_usuario_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_BLOQUE_CONT', '	Contar registros de bloqueos del sistema
', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_BLOQUE_SEL', '	Listado de bloqueos del sistema
', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_NOTI_CONT', '	Contar registros de notificaciones de enventos del sistema
', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_NOTI_SEL', '	Listado del notificacion de eventos del sistema
', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUIROL_CONT', '	Contar las interfaces con privilegios sobre procedimientos
', 'si', '', '', 'segu.ft_gui_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPGUIROL_SEL', '	Listado de gui_rol de un subsistema para exportar
', 'si', '', '', 'segu.ft_gui_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUIROL_SEL', '	Listado de interfaces con privilegios sobre procedimientos
', 'si', '', '', 'segu.ft_gui_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_ELI', '	elimina Rol Procedimiento gui
', 'si', '', '', 'segu.ft_rol_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_MOD', '	modifica Rol Procedimiento gui
', 'si', '', '', 'segu.ft_rol_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_INS', '	Inserta Rol Procedimiento gui
', 'si', '', '', 'segu.ft_rol_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_SESION_CONT', '	Contar  las sesiones activas en el sistema
', 'si', '', '', 'segu.ft_sesion_sel');
select pxp.f_insert_tprocedimiento ('SEG_SESION_SEL', '	Listado de las sesiones activas en el sistema
', 'si', '', '', 'segu.ft_sesion_sel');
select pxp.f_insert_tprocedimiento ('SEG_VALUSU_SEG', '	verifica si el login y contgrasena proporcionados son correctos
                esta funcion es especial porque corre con el usario generico de conexion
                que solo tiene el privilegio de correr esta funcion
', 'si', '', '', 'segu.ft_validar_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_CONT', '	Cuenta Estructura dato
', 'si', '', '', 'segu.ft_estructura_dato_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_SEL', '	Selecciona Estructura dato
', 'si', '', '', 'segu.ft_estructura_dato_sel');
select pxp.f_insert_tprocedimiento ('SG_LIB_CONT', '	Conteo de registros
 	', 'si', '', '', 'segu.ft_libreta_her_sel');
select pxp.f_insert_tprocedimiento ('SG_LIB_SEL', '	Consulta de datos
 	', 'si', '', '', 'segu.ft_libreta_her_sel');


select pxp.f_insert_tprocedimiento ('SG_LIB_ELI', '	Eliminacion de registros
 	', 'si', '', '', 'segu.ft_libreta_her_ime');
select pxp.f_insert_tprocedimiento ('SG_LIB_MOD', '	Modificacion de registros
 	', 'si', '', '', 'segu.ft_libreta_her_ime');
select pxp.f_insert_tprocedimiento ('SG_LIB_INS', '	Insercion de registros
 	', 'si', '', '', 'segu.ft_libreta_her_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROCECMB_CONT', '	Cuenta Procedimientos para el listado
                del combo en la vista de procedimiento_gui
', 'si', '', '', 'segu.ft_procedimiento_sel');

select pxp.f_insert_tprocedimiento ('SEG_PROCECMB_SEL', '	Selecciona Procedimientos para el listado
                del combo en la vista de procedimiento_gui
', 'si', '', '', 'segu.ft_procedimiento_sel');

select pxp.f_insert_tprocedimiento ('SEG_PROCE_CONT', '	Cuenta Procedimientos
', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCE_SEL', '	Listado de Procedimientos
', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_CONT', '	Cuenta Procedimientos para agregar al listado del arbol
', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPPROC_SEL', '	Listado de procedimiento de un subsistema para exportar
', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_SEL', '	Selecciona Procedimientos para agregar al listado del arbol
', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUI_CONT', '	Listado de guis de un subsistema para exportar
', 'si', '', '', 'segu.ft_gui_sel');

select pxp.f_insert_tprocedimiento ('SEG_EXPGUI_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUI_SEL', '	Listado de interfaces en formato de arbol
', 'si', '', '', 'segu.ft_gui_sel');

select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_ELI', '	Elimina Estructura gui
', 'si', '', '', 'segu.ft_estructura_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_MOD', '	Modifica Estructura gui
', 'si', '', '', 'segu.ft_estructura_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_INS', '	Inserta Estructura gui
', 'si', '', '', 'segu.ft_estructura_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_CONT', '	Cuenta Clasificador
', 'si', '', '', 'segu.ft_clasificador_sel');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_SEL', '	Selecciona Clasificador
', 'si', '', '', 'segu.ft_clasificador_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_CONT', '	Cuenta Estructura gui
', 'si', '', '', 'segu.ft_estructura_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPESTGUI_SEL', '	Listado de estructura_gui de un subsistema para exportar
', 'si', '', '', 'segu.ft_estructura_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_SEL', '	Selecciona Estructura gui
', 'si', '', '', 'segu.ft_estructura_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_CONT', '	Cuenta procedimientos de una interfaz dada
', 'si', '', '', 'segu.ft_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPPROCGUI_SEL', '	Listado de procedimiento_gui de un subsistema para exportar
', 'si', '', '', 'segu.ft_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_SEL', '	Lista procedimientos de una interfaz dada
', 'si', '', '', 'segu.ft_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_SINCFUN_MOD', '	Este proceso busca todas las funciones de base de datos para el esquema seleccionado
                las  introduce en la tabla de fucniones luego revisa el cuerpo de la funcion
                y saca los codigos de procedimiento y sus descripciones
', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_ELI', '	Inactiva las funcion selecionada
', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_MOD', '	Modifica la funcion seleccionada
', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_INS', '	Inserta Funciones
', 'si', '', '', 'segu.ft_funcion_ime');


select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_CONT', '	Contar  funciones registradas del sistema
', 'si', '', '', 'segu.ft_funcion_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPFUN_SEL', '	Listado de funciones de un subsistema para exportar
', 'si', '', '', 'segu.ft_funcion_sel');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_SEL', '	Listado de funciones registradas del sistema
', 'si', '', '', 'segu.ft_funcion_sel');

select pxp.f_insert_tprocedimiento ('SEG_ROL_CONT', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_ROL_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_rol_sel');


select pxp.f_insert_tprocedimiento ('SEG_TIPDOC_CONT', '	Contar  los procedimeintos de BD registradas del sistema
', 'si', '', '', 'segu.ft_tipo_documento_sel');
select pxp.f_insert_tprocedimiento ('SEG_TIPDOC_SEL', '	Listado de los procedimientos de BD
', 'si', '', '', 'segu.ft_tipo_documento_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_ELI', '	Elimina Estructura Dato
', 'si', '', '', 'segu.ft_estructura_dato_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_MOD', '	Modifica Estructura Dato
', 'si', '', '', 'segu.ft_estructura_dato_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_INS', '	Inserta Estructura Dato
', 'si', '', '', 'segu.ft_estructura_dato_ime');

select pxp.f_insert_tprocedimiento ('SEG_PATEVE_ELI', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_patron_evento_ime');
select pxp.f_insert_tprocedimiento ('SEG_PATEVE_MOD', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_patron_evento_ime');
select pxp.f_insert_tprocedimiento ('SEG_PATEVE_INS', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_patron_evento_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUI_ELI', '	Inactiva la interfaz del arbol seleccionada
', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUI_MOD', '	Modifica la interfaz del arbol seleccionada
', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUI_INS', '	Inserta interfaces en el arbol
', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUIDD_IME', '	Inserta interfaces en el arbol
', 'si', '', '', 'segu.ft_gui_ime');

select pxp.f_insert_tprocedimiento ('SEG_HORTRA_CONT', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_horario_trabajo_sel');
select pxp.f_insert_tprocedimiento ('SEG_HORTRA_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_horario_trabajo_sel');

select pxp.f_insert_tprocedimiento ('SEG_PATEVE_CONT', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_patron_evento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PATEVE_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_patron_evento_sel');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_ELI', '	Elimina Clasificacion
', 'si', '', '', 'segu.ft_clasificador_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_MOD', '	Modifica Clasificacion
', 'si', '', '', 'segu.ft_clasificador_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_INS', '	Inserta Actividades
', 'si', '', '', 'segu.ft_clasificador_ime');

select pxp.f_insert_tprocedimiento ('SEG_PRIMO_CONT', '	cuenta el listado de numeros primos
', 'si', '', '', 'segu.ft_primo_sel');
select pxp.f_insert_tprocedimiento ('SEG_PRIMO_SEL', '	listado de numeros primo
', 'si', '', '', 'segu.ft_primo_sel');
select pxp.f_insert_tprocedimiento ('SEG_OBTEPRI_SEL', '	Obtienen un numero primo segun indice
                el indice se obtiene en el servidor web randomicamente
', 'si', '', '', 'segu.ft_primo_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUIROL_INS', '	Modifica los permisos del un rol ID_ROL sobre un  tipo TIPO
', 'si', '', '', 'segu.ft_gui_rol_ime');

select pxp.f_insert_tprocedimiento ('SEG_ROL_ELI', '	Elimina Rol
', 'si', '', '', 'segu.ft_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROL_MOD', '	Modifica Rol
', 'si', '', '', 'segu.ft_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROL_INS', '	Inserta Rol
', 'si', '', '', 'segu.ft_rol_ime');

select pxp.f_insert_tprocedimiento ('SEG_PERSONMIN_CONT', '	Cuenta Personas con foto
', 'si', '', '', 'segu.ft_persona_sel');

select pxp.f_insert_tprocedimiento ('SEG_PERSONMIN_SEL', '	Selecciona Personas + fotografia
', 'si', '', '', 'segu.ft_persona_sel');

select pxp.f_insert_tprocedimiento ('SEG_PERSON_CONT', '	Cuenta Personas
', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_SEL', '	Selecciona Personas
', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGHOR_CONT', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGHOR_SEL', '	Contar  los eventos fuera de horario de trabajo
', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOG_CONT', '	Lista eventos del sistema sucedidos fuera de horarios de trabajo
', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOG_SEL', '	Contar  los eventos del sistema registrados
', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGMON_CONT', '	Contar registros del monitor de enventos del sistema(Actualiza eventos de BD)
', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGMON_SEL', '	Listado del monitoreo de eventos del  XPH sistema
', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_SESION_MOD', '	Modifica la una variable de sesion
', 'si', '', '', 'segu.ft_sesion_ime');
select pxp.f_insert_tprocedimiento ('SEG_SESION_INS', '	registra sesiones  de un usuario
', 'si', '', '', 'segu.ft_sesion_ime');

select pxp.f_insert_tprocedimiento ('SEG_MONREC_SEL', '	Monitorear recursos usados por el sistema
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONIND_CONT', '	Contar registros del monitor de objetos de bd (indices)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONIND_SEL', '	Listado de registros del monitor de objetos de bd (Indices)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONFUN_CONT', '	Contar registros del monitor de objetos de bd (funciones)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONFUN_SEL', '	Listado de registros del monitor de objetos de bd (Funciones)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONTAB_CONT', '	Contar registros del monitor de objetos de bd (Tablas)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONTAB_SEL', '	Listado de registros del monitor de objetos de bd (Tablas)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONESQ_CONT', '	Contar registros del monitor de objetos de bd (Esquemas)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONESQ_SEL', '	Listado de registros del monitor de objetos de bd (Esquemas)
', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_HORTRA_ELI', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_horario_trabajo_ime');
select pxp.f_insert_tprocedimiento ('SEG_HORTRA_MOD', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_horario_trabajo_ime');
select pxp.f_insert_tprocedimiento ('SEG_HORTRA_INS', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_horario_trabajo_ime');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_ELI', '	Elimina Persona
', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SEG_UPFOTOPER_MOD', '	Modifica la foto de la persona
', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_MOD', '	Modifica Persona
', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_INS', '	Inserta Persona
', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SG_CONF_MOD', '	Configuración de cuenta de usuario
 	', 'si', '', '', 'segu.ft_configurar_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESBLONO_MOD', '	Cambia el estado de notificacion y bloqueos
', 'si', '', '', 'segu.ft_bloqueo_notificacion_ime');






-------------------------------------------
-------------------------------------------
-------------------------------------------

---------------------------
-- Data for table segu.tclasificador (OID = 307111) (LIMIT 0,4)
------------------------------------
INSERT INTO segu.tclasificador ( codigo, descripcion, prioridad, fecha_reg, estado_reg)
VALUES ('ASE', 'ALTO SECRETO', 1, '2019-01-01', 'activo');

INSERT INTO segu.tclasificador (codigo, descripcion, prioridad, fecha_reg, estado_reg)
VALUES ('SEC', 'SECRETO', 2, '2019-01-01', 'activo');

INSERT INTO segu.tclasificador (codigo, descripcion, prioridad, fecha_reg, estado_reg)
VALUES ('PRI', 'PRIVADA', 4, '2019-08-01', 'activo');

INSERT INTO segu.tclasificador (codigo, descripcion, prioridad, fecha_reg, estado_reg)
VALUES ('PUB', 'PUBLICO', 3, '2019-09-10', 'activo');


------------------------------------------------
-- DDEF DE USUARIO INICIAL ADMINISTRADOR
------------------------------------------------------


INSERT INTO segu.tpersona (id_usuario_reg, id_usuario_mod, fecha_reg, fecha_mod, estado_reg, nombre, apellido_paterno, apellido_materno, ci, correo, celular1, num_documento, telefono1, telefono2, celular2, foto, extension, genero, fecha_nacimiento, direccion)
VALUES (1, NULL, NULL, NULL, NULL, 'ADMINISTRADOR', 'DEL SISTEMA', '', '', '', NULL, NULL, NULL, NULL, NULL, '', 'jpg', NULL, NULL, NULL);

--
-- Data for table segu.tusuario (OID = 305814) (LIMIT 0,1)
--
INSERT INTO segu.tusuario ( id_clasificador, cuenta, contrasena, fecha_caducidad, fecha_reg, estilo, contrasena_anterior, id_persona, estado_reg, autentificacion)
VALUES (1, 'admin', 'admin', '2020-01-31', '2011-05-10', 'xtheme-access.css', 'f1290186a5d0b1ceab27f4e77c0c5d68', 1, 'activo', 'local');

--
-- Data for table segu.trol (OID = 307211) (LIMIT 0,1)
--
INSERT INTO segu.trol (descripcion, fecha_reg, estado_reg, rol, id_subsistema)
VALUES ('Administrador', '2011-05-17', 'activo', 'Administrador', NULL);

--
-- Data for table segu.tusuario_rol (OID = 307268) (LIMIT 0,1)
--
INSERT INTO segu.tusuario_rol (id_rol, id_usuario, fecha_reg, estado_reg)
VALUES (1, 1, '2011-05-17', 'activo');


-------------------------------------
--  DEF DE NUMEROS PRIMOS PARA RSA
-------------------------------


INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1, 961772029);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (2, 961772047);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (3, 961772057);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (4, 961772087);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (5, 961772111);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (6, 961772131);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (7, 961772159);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (8, 961772167);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (9, 961772171);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (10, 961772173);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (11, 961772183);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (12, 961772213);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (13, 961772249);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (14, 961772261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (15, 961772281);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (16, 961772309);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (17, 961772323);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (18, 961772341);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (19, 961772351);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (20, 961772401);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (21, 961772417);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (22, 961772429);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (23, 961772431);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (24, 961772459);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (25, 961772479);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (26, 961772519);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (27, 961772521);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (28, 961772563);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (29, 961772573);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (30, 961772593);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (31, 961772639);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (32, 961772653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (33, 961772659);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (34, 961772677);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (35, 961772681);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (36, 961772689);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (37, 961772699);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (38, 961772717);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (39, 961772729);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (40, 961772741);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (41, 961772753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (42, 961772759);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (43, 961772839);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (44, 961772863);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (45, 961772869);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (46, 961772879);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (47, 961772897);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (48, 961772921);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (49, 961772963);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (50, 961773013);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (51, 961773067);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (52, 961773073);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (53, 961773091);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (54, 961773119);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (55, 961773151);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (56, 961773157);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (57, 961773167);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (58, 961773199);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (59, 961773223);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (60, 961773247);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (61, 961773251);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (62, 961773271);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (63, 961773277);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (64, 961773287);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (65, 961773289);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (66, 961773299);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (67, 961773347);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (68, 961773353);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (69, 961773377);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (70, 961773383);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (71, 961773403);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (72, 961773443);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (73, 961773473);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (74, 961773479);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (75, 961773493);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (76, 961773499);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (77, 961773529);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (78, 961773551);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (79, 961773569);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (80, 961773581);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (81, 961773583);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (82, 961773587);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (83, 961773601);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (84, 961773607);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (85, 961773731);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (86, 961773751);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (87, 961773781);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (88, 961773889);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (89, 961773899);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (90, 961773913);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (91, 961773937);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (92, 961773949);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (93, 961774013);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (94, 961774027);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (95, 961774043);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (96, 961774057);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (97, 961774061);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (98, 961774063);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (99, 961774069);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (100, 961774127);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (101, 961774153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (102, 961774157);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (103, 961774211);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (104, 961774223);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (105, 961774267);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (106, 961774273);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (107, 961774313);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (108, 961774381);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (109, 961774397);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (110, 961774403);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (111, 961774409);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (112, 961774447);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (113, 961774459);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (114, 961774487);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (115, 961774493);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (116, 961774523);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (117, 961774537);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (118, 961774553);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (119, 961774571);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (120, 961774577);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (121, 961774603);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (122, 961774607);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (123, 961774657);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (124, 961774669);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (125, 961774687);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (126, 961774703);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (127, 961774717);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (128, 961774741);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (129, 961774769);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (130, 961774787);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (131, 961774829);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (132, 961774859);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (133, 961774873);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (134, 961774901);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (135, 961774939);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (136, 961774951);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (137, 961774967);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (138, 961774981);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (139, 961775011);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (140, 961775063);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (141, 961775081);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (142, 961775099);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (143, 961775123);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (144, 961775179);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (145, 961775197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (146, 961775203);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (147, 961775239);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (148, 961775251);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (149, 961775257);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (150, 961775263);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (151, 961775267);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (152, 961775293);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (153, 961775317);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (154, 961775359);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (155, 961775369);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (156, 961775377);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (157, 961775387);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (158, 961775393);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (159, 961775411);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (160, 961775449);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (161, 961775489);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (162, 961775501);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (163, 961775509);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (164, 961775569);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (165, 961775587);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (166, 961775597);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (167, 961775603);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (168, 961775623);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (169, 961775627);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (170, 961775641);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (171, 961775653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (172, 961775671);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (173, 961775677);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (174, 961775693);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (175, 961775701);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (176, 961775707);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (177, 961775747);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (178, 961775753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (179, 961775791);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (180, 961775849);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (181, 961775851);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (182, 961775887);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (183, 961775917);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (184, 961775921);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (185, 961775977);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (186, 961775987);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (187, 961776061);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (188, 961776091);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (189, 961776131);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (190, 961776133);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (191, 961776157);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (192, 961776161);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (193, 961776163);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (194, 961776197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (195, 961776217);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (196, 961776251);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (197, 961776253);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (198, 961776269);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (199, 961776281);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (200, 961776289);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (201, 961776307);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (202, 961776311);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (203, 961776317);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (204, 961776331);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (205, 961776367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (206, 961776379);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (207, 961776383);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (208, 961776419);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (209, 961776421);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (210, 961776443);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (211, 961776449);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (212, 961776469);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (213, 961776481);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (214, 961776521);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (215, 961776559);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (216, 961776587);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (217, 961776593);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (218, 961776617);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (219, 961776659);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (220, 961776667);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (221, 961776689);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (222, 961776703);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (223, 961776709);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (224, 961776727);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (225, 961776749);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (226, 961776791);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (227, 961776799);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (228, 961776847);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (229, 961776857);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (230, 961776919);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (231, 961776943);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (232, 961777021);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (233, 961777043);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (234, 961777067);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (235, 961777079);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (236, 961777109);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (237, 961777111);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (238, 961777123);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (239, 961777129);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (240, 961777151);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (241, 961777153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (242, 961777181);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (243, 961777211);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (244, 961777217);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (245, 961777237);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (246, 961777277);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (247, 961777291);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (248, 961777339);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (249, 961777351);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (250, 961777367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (251, 961777381);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (252, 961777391);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (253, 961777417);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (254, 961777441);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (255, 961777451);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (256, 961777459);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (257, 961777493);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (258, 961777507);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (259, 961777529);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (260, 961777541);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (261, 961777589);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (262, 961777711);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (263, 961777717);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (264, 961777723);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (265, 961777753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (266, 961777783);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (267, 961777807);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (268, 961777811);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (269, 961777813);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (270, 961777823);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (271, 961777829);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (272, 961777841);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (273, 961777871);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (274, 961777897);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (275, 961777903);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (276, 961777937);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (277, 961777969);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (278, 961777981);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (279, 961778023);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (280, 961778087);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (281, 961778093);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (282, 961778101);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (283, 961778137);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (284, 961778159);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (285, 961778161);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (286, 961778171);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (287, 961778173);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (288, 961778267);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (289, 961778269);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (290, 961778273);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (291, 961778357);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (292, 961778387);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (293, 961778429);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (294, 961778453);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (295, 961778471);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (296, 961778473);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (297, 961778483);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (298, 961778509);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (299, 961778527);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (300, 961778563);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (301, 961778581);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (302, 961778593);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (303, 961778599);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (304, 961778659);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (305, 961778681);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (306, 961778693);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (307, 961778717);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (308, 961778743);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (309, 961778749);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (310, 961778761);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (311, 961778773);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (312, 961778789);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (313, 961778801);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (314, 961778827);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (315, 961778837);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (316, 961778843);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (317, 961778891);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (318, 961778897);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (319, 961778899);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (320, 961778911);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (321, 961778921);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (322, 961778929);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (323, 961778941);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (324, 961778957);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (325, 961778977);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (326, 961778989);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (327, 961779011);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (328, 961779043);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (329, 961779197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (330, 961779241);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (331, 961779257);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (332, 961779263);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (333, 961779361);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (334, 961779367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (335, 961779383);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (336, 961779397);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (337, 961779421);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (338, 961779463);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (339, 961779493);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (340, 961779547);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (341, 961779571);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (342, 961779587);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (343, 961779613);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (344, 961779647);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (345, 961779649);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (346, 961779683);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (347, 961779719);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (348, 961779727);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (349, 961779757);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (350, 961779769);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (351, 961779787);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (352, 961779823);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (353, 961779857);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (354, 961779859);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (355, 961779883);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (356, 961779893);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (357, 961779901);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (358, 961779911);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (359, 961779977);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (360, 961779997);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (361, 961780007);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (362, 961780031);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (363, 961780069);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (364, 961780073);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (365, 961780081);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (366, 961780087);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (367, 961780153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (368, 961780187);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (369, 961780189);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (370, 961780199);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (371, 961780231);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (372, 961780289);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (373, 961780291);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (374, 961780297);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (375, 961780349);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (376, 961780367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (377, 961780373);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (378, 961780387);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (379, 961780433);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (380, 961780439);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (381, 961780483);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (382, 961780507);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (383, 961780517);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (384, 961780529);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (385, 961780541);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (386, 961780577);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (387, 961780591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (388, 961780607);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (389, 961780619);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (390, 961780637);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (391, 961780639);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (392, 961780643);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (393, 961780649);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (394, 961780663);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (395, 961780669);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (396, 961780709);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (397, 961780711);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (398, 961780723);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (399, 961780733);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (400, 961780739);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (401, 961780769);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (402, 961780777);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (403, 961780789);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (404, 961780823);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (405, 961780837);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (406, 961780847);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (407, 961780867);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (408, 961780879);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (409, 961780907);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (410, 961780951);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (411, 961780987);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (412, 961780991);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (413, 961781003);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (414, 961781017);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (415, 961781021);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (416, 961781039);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (417, 961781053);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (418, 961781063);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (419, 961781077);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (420, 961781131);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (421, 961781147);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (422, 961781153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (423, 961781167);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (424, 961781173);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (425, 961781189);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (426, 961781203);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (427, 961781207);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (428, 961781213);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (429, 961781251);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (430, 961781263);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (431, 961781279);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (432, 961781281);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (433, 961781291);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (434, 961781297);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (435, 961781299);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (436, 961781323);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (437, 961781347);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (438, 961781371);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (439, 961781389);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (440, 961781393);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (441, 961781411);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (442, 961781413);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (443, 961781419);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (444, 961781453);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (445, 961781503);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (446, 961781537);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (447, 961781609);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (448, 961781621);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (449, 961781627);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (450, 961781641);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (451, 961781659);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (452, 961781669);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (453, 961781671);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (454, 961781683);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (455, 961781687);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (456, 961781719);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (457, 961781741);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (458, 961781771);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (459, 961781819);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (460, 961781861);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (461, 961781879);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (462, 961781911);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (463, 961781921);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (464, 961781923);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (465, 961781939);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (466, 961781941);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (467, 961781963);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (468, 961781983);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (469, 961782023);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (470, 961782047);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (471, 961782061);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (472, 961782067);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (473, 961782079);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (474, 961782097);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (475, 961782139);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (476, 961782167);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (477, 961782193);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (478, 961782209);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (479, 961782229);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (480, 961782271);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (481, 961782277);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (482, 961782287);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (483, 961782301);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (484, 961782317);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (485, 961782359);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (486, 961782377);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (487, 961782383);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (488, 961782389);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (489, 961782391);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (490, 961782431);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (491, 961782433);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (492, 961782439);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (493, 961782443);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (494, 961782449);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (495, 961782473);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (496, 961782509);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (497, 961782517);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (498, 961782529);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (499, 961782539);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (500, 961782583);

--
-- Data for table segu.segu.tprimo (OID = 307189) (LIMIT 500,500)
--
INSERT INTO segu.tprimo (id_primo, numero)
VALUES (501, 961782589);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (502, 961782611);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (503, 961782629);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (504, 961782637);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (505, 961782643);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (506, 961782649);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (507, 961782671);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (508, 961782733);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (509, 961782737);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (510, 961782751);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (511, 961782817);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (512, 961782821);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (513, 961782823);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (514, 961782853);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (515, 961782859);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (516, 961782863);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (517, 961782937);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (518, 961783003);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (519, 961783049);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (520, 961783087);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (521, 961783127);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (522, 961783129);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (523, 961783133);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (524, 961783159);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (525, 961783169);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (526, 961783171);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (527, 961783181);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (528, 961783189);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (529, 961783201);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (530, 961783213);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (531, 961783219);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (532, 961783237);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (533, 961783261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (534, 961783271);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (535, 961783297);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (536, 961783327);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (537, 961783343);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (538, 961783349);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (539, 961783351);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (540, 961783357);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (541, 961783369);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (542, 961783379);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (543, 961783393);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (544, 961783411);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (545, 961783441);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (546, 961783469);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (547, 961783507);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (548, 961783519);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (549, 961783531);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (550, 961783549);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (551, 961783631);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (552, 961783643);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (553, 961783723);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (554, 961783729);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (555, 961783777);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (556, 961783783);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (557, 961783807);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (558, 961783817);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (559, 961783843);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (560, 961783871);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (561, 961783873);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (562, 961783903);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (563, 961783931);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (564, 961783969);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (565, 961783973);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (566, 961783981);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (567, 961783987);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (568, 961784017);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (569, 961784051);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (570, 961784071);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (571, 961784137);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (572, 961784143);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (573, 961784167);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (574, 961784177);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (575, 961784203);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (576, 961784227);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (577, 961784267);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (578, 961784279);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (579, 961784287);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (580, 961784293);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (581, 961784309);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (582, 961784323);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (583, 961784339);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (584, 961784347);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (585, 961784371);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (586, 961784407);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (587, 961784419);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (588, 961784431);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (589, 961784441);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (590, 961784459);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (591, 961784479);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (592, 961784497);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (593, 961784521);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (594, 961784543);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (595, 961784557);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (596, 961784573);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (597, 961784581);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (598, 961784591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (599, 961784599);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (600, 961784627);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (601, 961784633);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (602, 961784647);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (603, 961784653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (604, 961784671);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (605, 961784687);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (606, 961784729);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (607, 961784737);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (608, 961784753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (609, 961784773);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (610, 961784777);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (611, 961784833);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (612, 961784849);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (613, 961784861);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (614, 961784869);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (615, 961784881);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (616, 961784899);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (617, 961784903);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (618, 961784909);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (619, 961784927);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (620, 961784953);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (621, 961785007);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (622, 961785049);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (623, 961785061);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (624, 961785103);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (625, 961785119);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (626, 961785151);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (627, 961785169);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (628, 961785173);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (629, 961785191);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (630, 961785197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (631, 961785221);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (632, 961785239);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (633, 961785269);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (634, 961785281);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (635, 961785317);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (636, 961785359);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (637, 961785367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (638, 961785379);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (639, 961785427);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (640, 961785431);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (641, 961785463);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (642, 961785467);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (643, 961785481);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (644, 961785497);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (645, 961785499);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (646, 961785527);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (647, 961785547);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (648, 961785563);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (649, 961785569);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (650, 961785577);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (651, 961785637);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (652, 961785653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (653, 961785661);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (654, 961785691);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (655, 961785701);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (656, 961785703);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (657, 961785763);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (658, 961785767);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (659, 961785787);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (660, 961785793);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (661, 961785817);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (662, 961785889);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (663, 961785941);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (664, 961785961);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (665, 961785973);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (666, 961785983);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (667, 961785991);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (668, 961785997);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (669, 961786027);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (670, 961786043);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (671, 961786057);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (672, 961786109);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (673, 961786127);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (674, 961786141);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (675, 961786157);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (676, 961786187);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (677, 961786261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (678, 961786277);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (679, 961786291);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (680, 961786313);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (681, 961786349);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (682, 961786379);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (683, 961786391);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (684, 961786393);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (685, 961786409);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (686, 961786417);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (687, 961786433);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (688, 961786447);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (689, 961786457);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (690, 961786481);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (691, 961786523);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (692, 961786531);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (693, 961786571);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (694, 961786583);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (695, 961786591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (696, 961786627);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (697, 961786691);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (698, 961786697);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (699, 961786729);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (700, 961786739);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (701, 961786751);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (702, 961786757);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (703, 961786801);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (704, 961786909);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (705, 961786921);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (706, 961786927);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (707, 961786937);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (708, 961786949);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (709, 961786963);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (710, 961786981);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (711, 961786993);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (712, 961786999);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (713, 961787017);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (714, 961787027);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (715, 961787051);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (716, 961787089);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (717, 961787137);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (718, 961787147);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (719, 961787153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (720, 961787171);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (721, 961787209);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (722, 961787219);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (723, 961787221);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (724, 961787243);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (725, 961787263);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (726, 961787269);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (727, 961787279);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (728, 961787363);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (729, 961787377);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (730, 961787413);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (731, 961787473);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (732, 961787503);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (733, 961787521);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (734, 961787591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (735, 961787609);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (736, 961787641);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (737, 961787647);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (738, 961787653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (739, 961787663);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (740, 961787677);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (741, 961787681);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (742, 961787707);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (743, 961787737);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (744, 961787753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (745, 961787777);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (746, 961787789);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (747, 961787807);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (748, 961787819);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (749, 961787821);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (750, 961787831);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (751, 961787839);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (752, 961787887);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (753, 961787899);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (754, 961787917);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (755, 961787933);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (756, 961787947);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (757, 961787977);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (758, 961787993);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (759, 961788001);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (760, 961788017);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (761, 961788019);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (762, 961788049);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (763, 961788071);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (764, 961788089);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (765, 961788167);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (766, 961788169);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (767, 961788173);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (768, 961788187);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (769, 961788193);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (770, 961788199);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (771, 961788203);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (772, 961788229);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (773, 961788239);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (774, 961788241);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (775, 961788253);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (776, 961788257);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (777, 961788259);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (778, 961788329);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (779, 961788367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (780, 961788371);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (781, 961788409);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (782, 961788431);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (783, 961788463);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (784, 961788467);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (785, 961788491);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (786, 961788497);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (787, 961788533);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (788, 961788587);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (789, 961788599);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (790, 961788601);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (791, 961788613);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (792, 961788623);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (793, 961788637);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (794, 961788661);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (795, 961788689);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (796, 961788727);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (797, 961788731);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (798, 961788743);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (799, 961788757);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (800, 961788781);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (801, 961788803);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (802, 961788809);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (803, 961788847);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (804, 961788881);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (805, 961788899);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (806, 961788983);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (807, 961789007);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (808, 961789019);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (809, 961789021);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (810, 961789099);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (811, 961789121);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (812, 961789163);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (813, 961789181);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (814, 961789187);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (815, 961789219);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (816, 961789243);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (817, 961789249);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (818, 961789261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (819, 961789289);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (820, 961789313);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (821, 961789319);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (822, 961789327);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (823, 961789337);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (824, 961789343);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (825, 961789351);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (826, 961789363);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (827, 961789391);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (828, 961789393);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (829, 961789417);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (830, 961789429);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (831, 961789441);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (832, 961789453);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (833, 961789469);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (834, 961789483);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (835, 961789537);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (836, 961789567);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (837, 961789571);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (838, 961789579);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (839, 961789583);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (840, 961789613);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (841, 961789627);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (842, 961789639);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (843, 961789649);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (844, 961789651);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (845, 961789667);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (846, 961789691);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (847, 961789711);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (848, 961789721);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (849, 961789793);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (850, 961789799);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (851, 961789837);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (852, 961789847);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (853, 961789853);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (854, 961789903);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (855, 961789921);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (856, 961789957);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (857, 961789967);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (858, 961789979);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (859, 961789991);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (860, 961790087);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (861, 961790101);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (862, 961790107);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (863, 961790129);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (864, 961790143);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (865, 961790197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (866, 961790237);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (867, 961790239);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (868, 961790261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (869, 961790267);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (870, 961790273);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (871, 961790299);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (872, 961790359);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (873, 961790369);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (874, 961790371);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (875, 961790383);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (876, 961790387);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (877, 961790399);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (878, 961790411);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (879, 961790429);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (880, 961790443);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (881, 961790483);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (882, 961790497);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (883, 961790509);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (884, 961790519);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (885, 961790537);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (886, 961790569);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (887, 961790581);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (888, 961790591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (889, 961790633);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (890, 961790663);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (891, 961790671);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (892, 961790677);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (893, 961790719);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (894, 961790857);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (895, 961790867);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (896, 961790873);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (897, 961790891);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (898, 961790897);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (899, 961790899);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (900, 961790911);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (901, 961790957);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (902, 961790971);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (903, 961790981);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (904, 961791011);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (905, 961791029);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (906, 961791043);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (907, 961791071);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (908, 961791073);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (909, 961791137);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (910, 961791143);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (911, 961791157);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (912, 961791163);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (913, 961791169);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (914, 961791197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (915, 961791199);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (916, 961791203);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (917, 961791211);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (918, 961791223);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (919, 961791241);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (920, 961791287);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (921, 961791307);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (922, 961791319);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (923, 961791353);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (924, 961791359);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (925, 961791361);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (926, 961791421);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (927, 961791427);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (928, 961791433);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (929, 961791451);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (930, 961791463);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (931, 961791487);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (932, 961791517);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (933, 961791539);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (934, 961791553);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (935, 961791581);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (936, 961791599);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (937, 961791601);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (938, 961791619);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (939, 961791629);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (940, 961791659);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (941, 961791661);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (942, 961791679);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (943, 961791797);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (944, 961791821);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (945, 961791877);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (946, 961791889);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (947, 961791893);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (948, 961791947);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (949, 961791977);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (950, 961791979);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (951, 961792003);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (952, 961792031);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (953, 961792033);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (954, 961792159);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (955, 961792177);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (956, 961792207);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (957, 961792213);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (958, 961792229);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (959, 961792241);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (960, 961792261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (961, 961792277);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (962, 961792283);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (963, 961792313);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (964, 961792339);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (965, 961792343);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (966, 961792361);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (967, 961792367);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (968, 961792387);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (969, 961792399);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (970, 961792439);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (971, 961792477);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (972, 961792523);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (973, 961792529);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (974, 961792543);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (975, 961792549);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (976, 961792583);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (977, 961792589);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (978, 961792591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (979, 961792609);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (980, 961792613);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (981, 961792621);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (982, 961792661);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (983, 961792669);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (984, 961792723);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (985, 961792751);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (986, 961792753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (987, 961792757);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (988, 961792759);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (989, 961792781);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (990, 961792789);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (991, 961792813);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (992, 961792823);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (993, 961792849);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (994, 961792873);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (995, 961792891);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (996, 961792943);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (997, 961792987);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (998, 961792999);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (999, 961793009);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1000, 961793017);

--
-- Data for table segu.segu.tprimo (OID = 307189) (LIMIT 1000,230)
--
INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1001, 961793099);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1002, 961793113);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1003, 961793123);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1004, 961793137);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1005, 961793153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1006, 961793159);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1007, 961793171);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1008, 961793221);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1009, 961793237);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1010, 961793249);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1011, 961793267);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1012, 961793269);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1013, 961793291);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1014, 961793311);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1015, 961793351);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1016, 961793353);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1017, 961793387);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1018, 961793389);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1019, 961793419);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1020, 961793423);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1021, 961793431);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1022, 961793449);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1023, 961793473);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1024, 961793501);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1025, 961793531);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1026, 961793537);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1027, 961793549);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1028, 961793551);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1029, 961793579);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1030, 961793603);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1031, 961793611);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1032, 961793617);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1033, 961793627);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1034, 961793641);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1035, 961793647);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1036, 961793687);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1037, 961793689);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1038, 961793713);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1039, 961793743);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1040, 961793753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1041, 961793773);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1042, 961793797);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1043, 961793803);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1044, 961793827);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1045, 961793831);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1046, 961793837);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1047, 961793849);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1048, 961793881);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1049, 961793891);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1050, 961793923);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1051, 961793933);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1052, 961793939);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1053, 961793951);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1054, 961793977);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1055, 961793983);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1056, 961793993);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1057, 961794007);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1058, 961794011);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1059, 961794017);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1060, 961794049);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1061, 961794073);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1062, 961794083);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1063, 961794131);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1064, 961794139);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1065, 961794149);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1066, 961794157);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1067, 961794181);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1068, 961794203);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1069, 961794209);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1070, 961794247);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1071, 961794257);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1072, 961794283);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1073, 961794311);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1074, 961794343);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1075, 961794413);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1076, 961794451);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1077, 961794521);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1078, 961794569);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1079, 961794571);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1080, 961794593);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1081, 961794607);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1082, 961794643);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1083, 961794653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1084, 961794683);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1085, 961794689);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1086, 961794707);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1087, 961794709);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1088, 961794719);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1089, 961794721);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1090, 961794727);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1091, 961794731);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1092, 961794751);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1093, 961794781);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1094, 961794797);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1095, 961794833);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1096, 961794853);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1097, 961794881);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1098, 961794923);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1099, 961794943);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1100, 961794961);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1101, 961794971);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1102, 961794973);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1103, 961795013);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1104, 961795019);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1105, 961795069);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1106, 961795099);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1107, 961795123);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1108, 961795189);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1109, 961795193);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1110, 961795199);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1111, 961795223);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1112, 961795249);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1113, 961795253);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1114, 961795259);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1115, 961795283);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1116, 961795291);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1117, 961795297);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1118, 961795327);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1119, 961795337);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1120, 961795339);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1121, 961795361);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1122, 961795363);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1123, 961795369);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1124, 961795381);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1125, 961795397);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1126, 961795423);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1127, 961795441);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1128, 961795453);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1129, 961795487);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1130, 961795493);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1131, 961795517);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1132, 961795529);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1133, 961795543);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1134, 961795559);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1135, 961795591);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1136, 961795609);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1137, 961795613);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1138, 961795619);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1139, 961795631);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1140, 961795633);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1141, 961795651);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1142, 961795657);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1143, 961795673);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1144, 961795687);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1145, 961795699);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1146, 961795727);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1147, 961795763);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1148, 961795829);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1149, 961795867);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1150, 961795873);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1151, 961795883);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1152, 961795897);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1153, 961795907);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1154, 961795931);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1155, 961795943);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1156, 961795957);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1157, 961795963);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1158, 961795981);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1159, 961796009);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1160, 961796023);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1161, 961796041);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1162, 961796057);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1163, 961796123);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1164, 961796137);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1165, 961796149);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1166, 961796153);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1167, 961796219);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1168, 961796237);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1169, 961796257);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1170, 961796261);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1171, 961796279);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1172, 961796293);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1173, 961796371);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1174, 961796377);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1175, 961796401);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1176, 961796413);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1177, 961796453);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1178, 961796501);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1179, 961796519);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1180, 961796551);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1181, 961796617);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1182, 961796621);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1183, 961796653);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1184, 961796657);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1185, 961796677);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1186, 961796711);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1187, 961796723);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1188, 961796741);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1189, 961796753);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1190, 961796761);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1191, 961796789);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1192, 961796791);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1193, 961796809);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1194, 961796831);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1195, 961796837);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1196, 961796839);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1197, 961796851);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1198, 961796881);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1199, 961796887);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1200, 961796909);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1201, 961796933);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1202, 961796951);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1203, 961796971);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1204, 961796987);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1205, 961797007);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1206, 961797013);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1207, 961797029);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1208, 961797037);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1209, 961797059);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1210, 961797071);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1211, 961797077);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1212, 961797079);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1213, 961797107);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1214, 961797121);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1215, 961797139);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1216, 961797149);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1217, 961797197);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1218, 961797217);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1219, 961797247);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1220, 961797283);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1221, 961797293);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1222, 961797299);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1223, 961797301);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1224, 961797323);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1225, 961797329);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1226, 961797341);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1227, 961797349);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1228, 961797379);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1229, 961797401);

INSERT INTO segu.tprimo (id_primo, numero)
VALUES (1230, 961797407);

--
-- Data for sequence segu.primo_id_primo_seq (OID = 307053)
--
SELECT pg_catalog.setval('segu.tprimo_id_primo_seq', 1230, true);

--RAC  5 de noviembre 2012
select pxp.f_insert_tgui ('Alertas', 'Alertas', 'ALERTA', 'si', 9, 'sis_parametros/vista/alarma/AlarmaFuncionario.php', 1, '', 'AlarmaFuncionario', 'PXP');
select pxp.f_insert_tgui ('Configurar', 'Configurar', 'CONFIG', 'si', 13, 'sis_seguridad/vista/configurar/Configurar.php', 1, '', 'Configurar', 'PXP');
select pxp.f_insert_testructura_gui ('ALERTA', 'SISTEMA');
select pxp.f_insert_testructura_gui ('CONFIG', 'SISTEMA');



/********************************************F-DAT-RCM-SEGU-0-15/01/2013********************************************/

/********************************************I-DAT-JRR-SEGU-0-02/02/2013**********************************************/
select pxp.f_delete_tgui ('GUISUB');
select pxp.f_delete_tgui ('PROGUI');
select pxp.f_delete_tgui ('funciones');
select pxp.f_delete_tgui ('');
select pxp.f_delete_tgui ('LOG');
/********************************************F-DAT-JRR-SEGU-0-02/02/2013**********************************************/

/********************************************I-DAT-RCM-SEGU-0-17/01/2014**********************************************/
select pxp.f_insert_tgui ('Tablas migradas ENDESIS', 'Listado de las tablas que se migran de ENDESIS', 'TBLMIG', 'si', 3, 'sis_seguridad/vista/tabla_migrar/TablaMigrar.php', 3, '', 'TablaMigrar', 'SEGU');

select pxp.f_insert_testructura_gui ('TBLMIG', 'o');
/********************************************F-DAT-RCM-SEGU-0-17/01/2014**********************************************/

/*******************************************I-DAT-JRR-SEGU-0-25/04/2014***********************************************/

select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'per.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 4, '', 'subirFotoPersona', 'SEGU');
select pxp.f_insert_tgui ('Personas', 'Personas', 'USUARI.1', 'no', 0, 'sis_seguridad/vista/persona/Persona.php', 4, '', 'persona', 'SEGU');
select pxp.f_insert_tgui ('Roles', 'Roles', 'USUARI.2', 'no', 0, 'sis_seguridad/vista/usuario_rol/UsuarioRol.php', 4, '', 'usuario_rol', 'SEGU');
select pxp.f_insert_tgui ('EP\', 'EP\', 'USUARI.3', 'no', 0, 'sis_seguridad/vista/usuario_grupo_ep/UsuarioGrupoEp.php', 4, '', ',
          width:400,
          cls:', 'SEGU');
select pxp.f_insert_tgui ('Subir foto', 'Subir foto', 'USUARI.1.1', 'no', 0, 'sis_seguridad/vista/persona/subirFotoPersona.php', 5, '', 'subirFotoPersona', 'SEGU');
select pxp.f_insert_tgui ('Procedimientos', 'Procedimientos', 'RROOLL.1', 'no', 0, 'sis_seguridad/vista/gui_rol/GuiRol.php', 4, '', 'gui_rol', 'SEGU');
select pxp.f_insert_tgui ('Funcion', 'Funcion', 'SISTEM.1', 'no', 0, 'sis_seguridad/vista/funcion/Funcion.php', 4, '', 'funcion', 'SEGU');
select pxp.f_insert_tgui ('Interfaces', 'Interfaces', 'SISTEM.2', 'no', 0, 'sis_seguridad/vista/gui/Gui.php', 4, '', 'gui', 'SEGU');
select pxp.f_insert_tgui ('Procedimientos', 'Procedimientos', 'SISTEM.1.1', 'no', 0, 'sis_seguridad/vista/procedimiento/Procedimiento.php', 5, '', 'procedimiento', 'SEGU');
select pxp.f_insert_tgui ('Procedimientos', 'Procedimientos', 'SISTEM.2.1', 'no', 0, 'sis_seguridad/vista/procedimiento_gui/ProcedimientoGui.php', 5, '', 'procedimiento_gui', 'SEGU');
select pxp.f_insert_tgui ('Tablas', 'Tablas', 'MONOJBD.1', 'no', 0, 'sis_seguridad/vista/monitor_objetos/MonitorObjetosTabla.php', 6, '', 'monitor_objetos_tabla', 'SEGU');
select pxp.f_insert_tgui ('Funciones', 'Funciones', 'MONOJBD.2', 'no', 0, 'sis_seguridad/vista/monitor_objetos/MonitorObjetosFuncion.php', 6, '', 'monitor_objetos_funcion', 'SEGU');
select pxp.f_insert_tgui ('Indices', 'Indices', 'MONOJBD.1.1', 'no', 0, 'sis_seguridad/vista/monitor_objetos/MonitorObjetosIndice.php', 7, '', 'monitor_objetos_indice', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_ep_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_programa_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_tfuncion', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_trol', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_actividad_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_ep_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_tabla_migrar_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_tabla_migrar_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_programa_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_tprocedimiento', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_tipo_comunicacion_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_trol_procedimiento_gui', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_tipo_comunicacion_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_tgui', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_proyecto_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_tprocedimiento_gui', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_proyecto_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_testructura_gui', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_regional_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_grupo_ep_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_regional_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ftrig_tgui_rol', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_actividad_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_usuario_grupo_ep_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_video_ime', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.ft_video_sel', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tfuncion ('segu.f_insertar_rol_pxp', 'Funcion para tabla     ', 'SEGU');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_ELI', 'Inactiva el subsistema selecionado', 'si', '', '', 'segu.ft_subsistema_ime');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_MOD', 'Modifica el subsistema seleccionada', 'si', '', '', 'segu.ft_subsistema_ime');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_INS', 'Inserta Subsistemas', 'si', '', '', 'segu.ft_subsistema_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_CONT', 'Contar usuarios activos de sistema', 'si', '', '', 'segu.ft_usuario_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_SEL', 'Listar usuarios activos de sistema', 'si', '', '', 'segu.ft_usuario_sel');
select pxp.f_insert_tprocedimiento ('SEG_VALUSU_SEL', 'consulta los datos del usario segun contrasena y login', 'si', '', '', 'segu.ft_usuario_sel');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_CONT', 'Contar  los subsistemas registrados del sistema', 'si', '', '', 'segu.ft_subsistema_sel');
select pxp.f_insert_tprocedimiento ('SEG_SUBSIS_SEL', 'Listado de los subsistemas registradas del sistema', 'si', '', '', 'segu.ft_subsistema_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_ELI', 'Elimina Procedimiento_Gui', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_MOD', 'Modifica Procedimiento_Gui', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_INS', 'Inserta Procedimiento_Gui', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_CONT', 'Cuenta Procesos por Gui y Rol', 'si', '', '', 'segu.ft_rol_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPROLPROGUI_SEL', 'Listado de rol_procedimiento_gui de un subsistema para exportar', 'si', '', '', 'segu.ft_rol_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_ROLPROGUI_SEL', 'Selecciona Procesos por Gui y Rol', 'si', '', '', 'segu.ft_rol_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_CONT', 'cuenta los roles activos que corresponden al usuario', 'si', '', '', 'segu.ft_usuario_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_SEL', 'Lista los roles activos que corresponden al usuario', 'si', '', '', 'segu.ft_usuario_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_MENU_SEL', 'Arma el menu que aparece en la parte izquierda
                de la pantalla del sistema', 'si', '', '', 'segu.ft_menu_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_ELI', 'Elimina Procedimiento', 'si', '', '', 'segu.ft_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_MOD', 'Modifica Procedimiento', 'si', '', '', 'segu.ft_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_INS', 'Inserta Procedimiento', 'si', '', '', 'segu.ft_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_ELI', 'Eliminar Usuarios', 'si', '', '', 'segu.ft_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_MOD', 'Modifica datos de  usuario', 'si', '', '', 'segu.ft_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUARI_INS', 'Inserta usuarios', 'si', '', '', 'segu.ft_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_ELI', 'retira  el rol asignado a un uusario', 'si', '', '', 'segu.ft_usuario_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_MOD', 'modifica roles de usuario', 'si', '', '', 'segu.ft_usuario_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUROL_INS', 'funcion para insertar usuario', 'si', '', '', 'segu.ft_usuario_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_BLOQUE_CONT', 'Contar registros de bloqueos del sistema', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_BLOQUE_SEL', 'Listado de bloqueos del sistema', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_NOTI_CONT', 'Contar registros de notificaciones de enventos del sistema', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_NOTI_SEL', 'Listado del notificacion de eventos del sistema', 'si', '', '', 'segu.ft_bloqueo_notificacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUIROL_CONT', 'Contar las interfaces con privilegios sobre procedimientos', 'si', '', '', 'segu.ft_gui_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPGUIROL_SEL', 'Listado de gui_rol de un subsistema para exportar', 'si', '', '', 'segu.ft_gui_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUIROL_SEL', 'Listado de interfaces con privilegios sobre procedimientos', 'si', '', '', 'segu.ft_gui_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_ELI', 'elimina Rol Procedimiento gui', 'si', '', '', 'segu.ft_rol_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_MOD', 'modifica Rol Procedimiento gui', 'si', '', '', 'segu.ft_rol_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROLPRO_INS', 'Inserta Rol Procedimiento gui', 'si', '', '', 'segu.ft_rol_procedimiento_ime');
select pxp.f_insert_tprocedimiento ('SEG_SESION_CONT', 'Contar  las sesiones activas en el sistema', 'si', '', '', 'segu.ft_sesion_sel');
select pxp.f_insert_tprocedimiento ('SEG_SESION_SEL', 'Listado de las sesiones activas en el sistema', 'si', '', '', 'segu.ft_sesion_sel');
select pxp.f_insert_tprocedimiento ('SEG_VALUSU_SEG', 'verifica si el login y contgrasena proporcionados son correctos
                esta funcion es especial porque corre con el usario generico de conexion
                que solo tiene el privilegio de correr esta funcion', 'si', '', '', 'segu.ft_validar_usuario_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_CONT', 'Cuenta Estructura dato', 'si', '', '', 'segu.ft_estructura_dato_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_SEL', 'Selecciona Estructura dato', 'si', '', '', 'segu.ft_estructura_dato_sel');
select pxp.f_insert_tprocedimiento ('SG_LIB_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_libreta_her_sel');
select pxp.f_insert_tprocedimiento ('SG_LIB_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_libreta_her_sel');
select pxp.f_insert_tprocedimiento ('SG_LIB_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_libreta_her_ime');
select pxp.f_insert_tprocedimiento ('SG_LIB_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_libreta_her_ime');
select pxp.f_insert_tprocedimiento ('SG_LIB_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_libreta_her_ime');
select pxp.f_insert_tprocedimiento ('SEG_PROCECMB_CONT', 'Cuenta Procedimientos para el listado
                del combo en la vista de procedimiento_gui', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCECMB_SEL', 'Selecciona Procedimientos para el listado
                del combo en la vista de procedimiento_gui', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCE_CONT', 'Cuenta Procedimientos', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCE_SEL', 'Listado de Procedimientos', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_CONT', 'Cuenta Procedimientos para agregar al listado del arbol', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPPROC_SEL', 'Listado de procedimiento de un subsistema para exportar', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROCED_SEL', 'Selecciona Procedimientos para agregar al listado del arbol', 'si', '', '', 'segu.ft_procedimiento_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUI_CONT', 'Listado de guis para sincronizar', 'si', '', '', 'segu.ft_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPGUI_SEL', 'Lista de datos para el manual', 'si', '', '', 'segu.ft_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUI_SEL', 'Listado de interfaces en formato de arbol', 'si', '', '', 'segu.ft_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_ELI', 'Elimina Estructura gui', 'si', '', '', 'segu.ft_estructura_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_MOD', 'Modifica Estructura gui', 'si', '', '', 'segu.ft_estructura_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_INS', 'Inserta Estructura gui', 'si', '', '', 'segu.ft_estructura_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_CONT', 'Cuenta Clasificador', 'si', '', '', 'segu.ft_clasificador_sel');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_SEL', 'Selecciona Clasificador', 'si', '', '', 'segu.ft_clasificador_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_CONT', 'Cuenta Estructura gui', 'si', '', '', 'segu.ft_estructura_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPESTGUI_SEL', 'Listado de estructura_gui de un subsistema para exportar', 'si', '', '', 'segu.ft_estructura_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTGUI_SEL', 'Selecciona Estructura gui', 'si', '', '', 'segu.ft_estructura_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_CONT', 'Cuenta procedimientos de una interfaz dada', 'si', '', '', 'segu.ft_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPPROCGUI_SEL', 'Listado de procedimiento_gui de un subsistema para exportar', 'si', '', '', 'segu.ft_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUI_SEL', 'Lista procedimientos de una interfaz dada', 'si', '', '', 'segu.ft_procedimiento_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_SINCFUN_MOD', 'Este proceso busca todas las funciones de base de datos para el esquema seleccionado
                las  introduce en la tabla de fucniones luego revisa el cuerpo de la funcion
                y saca los codigos de procedimiento y sus descripciones', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_ELI', 'Inactiva las funcion selecionada', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_MOD', 'Modifica la funcion seleccionada', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_INS', 'Inserta Funciones', 'si', '', '', 'segu.ft_funcion_ime');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_CONT', 'Contar  funciones registradas del sistema', 'si', '', '', 'segu.ft_funcion_sel');
select pxp.f_insert_tprocedimiento ('SEG_EXPFUN_SEL', 'Listado de funciones de un subsistema para exportar', 'si', '', '', 'segu.ft_funcion_sel');
select pxp.f_insert_tprocedimiento ('SEG_FUNCIO_SEL', 'Listado de funciones registradas del sistema', 'si', '', '', 'segu.ft_funcion_sel');
select pxp.f_insert_tprocedimiento ('SEG_ROL_SEL', 'Listado de gui_rol de un subsistema para exportar', 'si', '', '', 'segu.ft_rol_sel');
select pxp.f_insert_tprocedimiento ('SEG_TIPDOC_CONT', 'Contar  los procedimeintos de BD registradas del sistema', 'si', '', '', 'segu.ft_tipo_documento_sel');
select pxp.f_insert_tprocedimiento ('SEG_TIPDOC_SEL', 'Listado de los procedimientos de BD', 'si', '', '', 'segu.ft_tipo_documento_sel');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_ELI', 'Elimina Estructura Dato', 'si', '', '', 'segu.ft_estructura_dato_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_MOD', 'Modifica Estructura Dato', 'si', '', '', 'segu.ft_estructura_dato_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESTDAT_INS', 'Inserta Estructura Dato', 'si', '', '', 'segu.ft_estructura_dato_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUI_ELI', 'Inactiva la interfaz del arbol seleccionada', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUI_MOD', 'Modifica la interfaz del arbol seleccionada', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUI_INS', 'Inserta interfaces en el arbol', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUIDD_IME', 'Inserta interfaces en el arbol', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_ELI', 'Elimina Clasificacion', 'si', '', '', 'segu.ft_clasificador_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_MOD', 'Modifica Clasificacion', 'si', '', '', 'segu.ft_clasificador_ime');
select pxp.f_insert_tprocedimiento ('SEG_CLASIF_INS', 'Inserta Actividades', 'si', '', '', 'segu.ft_clasificador_ime');
select pxp.f_insert_tprocedimiento ('SEG_PRIMO_CONT', 'cuenta el listado de numeros primos', 'si', '', '', 'segu.ft_primo_sel');
select pxp.f_insert_tprocedimiento ('SEG_PRIMO_SEL', 'listado de numeros primo', 'si', '', '', 'segu.ft_primo_sel');
select pxp.f_insert_tprocedimiento ('SEG_OBTEPRI_SEL', 'Obtienen un numero primo segun indice
                el indice se obtiene en el servidor web randomicamente', 'si', '', '', 'segu.ft_primo_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUIROL_INS', 'Modifica los permisos del un rol ID_ROL sobre un  tipo TIPO', 'si', '', '', 'segu.ft_gui_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROL_ELI', 'Elimina Rol', 'si', '', '', 'segu.ft_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROL_MOD', 'Modifica Rol', 'si', '', '', 'segu.ft_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_ROL_INS', 'Inserta Rol', 'si', '', '', 'segu.ft_rol_ime');
select pxp.f_insert_tprocedimiento ('SEG_PERSONMIN_CONT', 'Cuenta Personas con foto', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_PERSONMIN_SEL', 'Selecciona Personas + fotografia', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_CONT', 'Cuenta Personas', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_SEL', 'Selecciona Personas', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGHOR_SEL', 'Contar  los eventos fuera de horario de trabajo', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOG_CONT', 'Lista eventos del sistema sucedidos fuera de horarios de trabajo', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOG_SEL', 'Contar  los eventos del sistema registrados', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGMON_CONT', 'Contar registros del monitor de enventos del sistema(Actualiza eventos de BD)', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_LOGMON_SEL', 'Listado del monitoreo de eventos del  XPH sistema', 'si', '', '', 'segu.ft_log_sel');
select pxp.f_insert_tprocedimiento ('SEG_SESION_MOD', 'Modifica la una variable de sesion', 'si', '', '', 'segu.ft_sesion_ime');
select pxp.f_insert_tprocedimiento ('SEG_SESION_INS', 'registra sesiones  de un usuario', 'si', '', '', 'segu.ft_sesion_ime');
select pxp.f_insert_tprocedimiento ('SEG_MONREC_SEL', 'Monitorear recursos usados por el sistema', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONIND_CONT', 'Contar registros del monitor de objetos de bd (indices)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONIND_SEL', 'Listado de registros del monitor de objetos de bd (Indices)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONFUN_CONT', 'Contar registros del monitor de objetos de bd (funciones)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONFUN_SEL', 'Listado de registros del monitor de objetos de bd (Funciones)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONTAB_CONT', 'Contar registros del monitor de objetos de bd (Tablas)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONTAB_SEL', 'Listado de registros del monitor de objetos de bd (Tablas)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONESQ_CONT', 'Contar registros del monitor de objetos de bd (Esquemas)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_MONESQ_SEL', 'Listado de registros del monitor de objetos de bd (Esquemas)', 'si', '', '', 'segu.ft_monitor_bd_sel');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_ELI', 'Elimina Persona', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SEG_UPFOTOPER_MOD', 'Modifica la foto de la persona', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_MOD', 'Modifica Persona', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SEG_PERSON_INS', 'Inserta Persona', 'si', '', '', 'segu.ft_persona_ime');
select pxp.f_insert_tprocedimiento ('SG_CONF_MOD', 'Configuración de cuenta de usuario', 'si', '', '', 'segu.ft_configurar_ime');
select pxp.f_insert_tprocedimiento ('SEG_ESBLONO_MOD', 'Cambia el estado de notificacion y bloqueos', 'si', '', '', 'segu.ft_bloqueo_notificacion_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUREG_SEL', 'lista las regionales del usuario', 'si', '', '', 'segu.ft_usuario_regional_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUREG_CONT', 'cuenta las regionales del usuario', 'si', '', '', 'segu.ft_usuario_regional_sel');
select pxp.f_insert_tprocedimiento ('SG_ESP_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_ep_ime');
select pxp.f_insert_tprocedimiento ('SG_ESP_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_ep_ime');
select pxp.f_insert_tprocedimiento ('SG_ESP_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_ep_ime');
select pxp.f_insert_tprocedimiento ('SG_PROGRA_INS', 'Inserci?n de registros', 'si', '', '', 'segu.ft_programa_ime');
select pxp.f_insert_tprocedimiento ('SG_PROGRA_MOD', 'Modificaci?n de registros', 'si', '', '', 'segu.ft_programa_ime');
select pxp.f_insert_tprocedimiento ('SG_PROGRA_ELI', 'Eliminaci?n de registros', 'si', '', '', 'segu.ft_programa_ime');
select pxp.f_insert_tprocedimiento ('SEG_GUISINC_IME', 'Inserta una interfaz desde la utilidad de soncronizacion', 'si', '', '', 'segu.ft_gui_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUACT_SEL', 'lista las actividades por usuario', 'si', '', '', 'segu.ft_usuario_actividad_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUACT_CONT', 'Contar  las actividades por usuario', 'si', '', '', 'segu.ft_usuario_actividad_sel');
select pxp.f_insert_tprocedimiento ('SG_ACT_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_actividad_sel');
select pxp.f_insert_tprocedimiento ('SG_ACT_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_actividad_sel');
select pxp.f_insert_tprocedimiento ('SG_ESP_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_ep_sel');
select pxp.f_insert_tprocedimiento ('SG_ESP_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_ep_sel');
select pxp.f_insert_tprocedimiento ('SG_TBLMIG_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_tabla_migrar_ime');
select pxp.f_insert_tprocedimiento ('SG_TBLMIG_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_tabla_migrar_ime');
select pxp.f_insert_tprocedimiento ('SG_TBLMIG_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_tabla_migrar_ime');
select pxp.f_insert_tprocedimiento ('SEG_OPERFOT_SEL', 'Selecciona Personas + fotografia', 'si', '', '', 'segu.ft_persona_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUACT_INS', 'Relaciona actividades con usuario', 'si', '', '', 'segu.ft_usuario_actividad_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUACT_MOD', 'Modifica la relacion de  actividades con usuario', 'si', '', '', 'segu.ft_usuario_actividad_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUACT_ELI', 'Inactivacion de la relacion de  actividades con usuario', 'si', '', '', 'segu.ft_usuario_actividad_ime');
select pxp.f_insert_tprocedimiento ('SG_TBLMIG_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_tabla_migrar_sel');
select pxp.f_insert_tprocedimiento ('SG_TBLMIG_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_tabla_migrar_sel');
select pxp.f_insert_tprocedimiento ('SG_PROGRA_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_programa_sel');
select pxp.f_insert_tprocedimiento ('SG_PROGRA_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_programa_sel');
select pxp.f_insert_tprocedimiento ('SG_TICOM_SEL', 'Consulta de datos', 'si', '', '', 'segu.f_tipo_comunicacion_sel');
select pxp.f_insert_tprocedimiento ('SG_TICOM_CONT', 'Conteo de registros', 'si', '', '', 'segu.f_tipo_comunicacion_sel');
select pxp.f_insert_tprocedimiento ('SEG_PROGUISINC_MOD', 'Sincroniza la relacion de las transacciones con las interfaces', 'si', '', '', 'segu.ft_procedimiento_gui_ime');
select pxp.f_insert_tprocedimiento ('SG_TICOM_INS', 'Insercion de registros', 'si', '', '', 'segu.f_tipo_comunicacion_ime');
select pxp.f_insert_tprocedimiento ('SG_TICOM_MOD', 'Modificacion de registros', 'si', '', '', 'segu.f_tipo_comunicacion_ime');
select pxp.f_insert_tprocedimiento ('SG_TICOM_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.f_tipo_comunicacion_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUPRO_SEL', 'lista las proyectos por usuario', 'si', '', '', 'segu.ft_usuario_proyecto_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUPRO_CONT', 'contar proyectos por usuario', 'si', '', '', 'segu.ft_usuario_proyecto_sel');
select pxp.f_insert_tprocedimiento ('SG_PROY_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_proyecto_sel');
select pxp.f_insert_tprocedimiento ('SG_PROY_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_proyecto_sel');
select pxp.f_insert_tprocedimiento ('SEG_GETGUI_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_GUISINC_SEL', 'Listado de guis de un subsistema para exportar', 'si', '', '', 'segu.ft_gui_sel');
select pxp.f_insert_tprocedimiento ('SEG_USUPRO_INS', 'Relaciona proyectos con usuario', 'si', '', '', 'segu.ft_usuario_proyecto_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUPRO_MOD', 'Modifica la relacion de proyectos con usuario', 'si', '', '', 'segu.ft_usuario_proyecto_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUPRO_ELI', 'Inactiva la relacion de proyectos con usuario', 'si', '', '', 'segu.ft_usuario_proyecto_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUREG_INS', 'Relaciona una regional al usuario', 'si', '', '', 'segu.ft_usuario_regional_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUREG_MOD', 'Modifica la relacion una regional y un  usuario', 'si', '', '', 'segu.ft_usuario_regional_ime');
select pxp.f_insert_tprocedimiento ('SEG_USUREG_ELI', 'Inactiva la relacion de una regional y un  usuario', 'si', '', '', 'segu.ft_usuario_regional_ime');
select pxp.f_insert_tprocedimiento ('SG_PROY_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_proyecto_ime');
select pxp.f_insert_tprocedimiento ('SG_PROY_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_proyecto_ime');
select pxp.f_insert_tprocedimiento ('SG_PROY_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_proyecto_ime');
select pxp.f_insert_tprocedimiento ('SEG_REGION_INS', 'Inserta Regional', 'si', '', '', 'segu.ft_regional_ime');
select pxp.f_insert_tprocedimiento ('SEG_REGION_MOD', 'Modifica Regional', 'si', '', '', 'segu.ft_regional_ime');
select pxp.f_insert_tprocedimiento ('SEG_REGION_ELI', 'Elimina Regional', 'si', '', '', 'segu.ft_regional_ime');
select pxp.f_insert_tprocedimiento ('SG_UEP_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_usuario_grupo_ep_sel');
select pxp.f_insert_tprocedimiento ('SG_UEP_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_usuario_grupo_ep_sel');
select pxp.f_insert_tprocedimiento ('SG_ACT_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_actividad_ime');
select pxp.f_insert_tprocedimiento ('SG_ACT_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_actividad_ime');
select pxp.f_insert_tprocedimiento ('SG_ACT_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_actividad_ime');
select pxp.f_insert_tprocedimiento ('SEG_EXPROL_SEL', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_rol_sel');
select pxp.f_insert_tprocedimiento ('SG_UEP_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_usuario_grupo_ep_ime');
select pxp.f_insert_tprocedimiento ('SG_UEP_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_usuario_grupo_ep_ime');
select pxp.f_insert_tprocedimiento ('SG_UEP_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_usuario_grupo_ep_ime');
select pxp.f_insert_tprocedimiento ('SEG_LISTUSU_SEG', 'CODIGO NO DOCUMENTADO', 'si', '', '', 'segu.ft_validar_usuario_ime');
select pxp.f_insert_tprocedimiento ('SG_TUTO_INS', 'Insercion de registros', 'si', '', '', 'segu.ft_video_ime');
select pxp.f_insert_tprocedimiento ('SG_TUTO_MOD', 'Modificacion de registros', 'si', '', '', 'segu.ft_video_ime');
select pxp.f_insert_tprocedimiento ('SG_TUTO_ELI', 'Eliminacion de registros', 'si', '', '', 'segu.ft_video_ime');
select pxp.f_insert_tprocedimiento ('SG_TUTO_SEL', 'Consulta de datos', 'si', '', '', 'segu.ft_video_sel');
select pxp.f_insert_tprocedimiento ('SG_TUTO_CONT', 'Conteo de registros', 'si', '', '', 'segu.ft_video_sel');

select pxp.f_insert_trol ('PXP-Rol inicial', 'PXP-Rol inicial', 'PXP');

/*******************************************F-DAT-JRR-SEGU-0-25/04/2014***********************************************/

/*******************************************I-DAT-RAC-SEGU-0-25/05/2017***********************************************/

select pxp.f_insert_tgui ('<i class="fa fa-users fa-2x"></i> SEGURIDAD', 'Seguridad', 'SEGU', 'si', 1, '', 1, '', 'Seguridad', 'SEGU');

/*******************************************F-DAT-RAC-SEGU-0-25/05/2017***********************************************/


/*******************************************I-DAT-FEA-SEGU-0-17/01/2019***********************************************/

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES
  (1, E'Administrador', E'2011-05-17', E'activo', E'Administrador', NULL, NULL),
  (2, E'Administrador Almacenes', E'2014-02-01', E'activo', E'Administrador Almacenes', 6, 1),
  (3, NULL, E'2014-02-01', E'activo', E'Asistente de Almacenes', 6, 1),
  (4, E'solicita items de almacenes', E'2014-02-01', E'activo', E'Solicitante de Almacenes', 6, 1),
  (5, E'visto bueno solicitud de almacen', E'2014-02-01', E'activo', E'Visto Bueno Solicitud Almacen', 6, 1),
  (6, E'almacenero se ocupa de registrar los items que ingresan', E'2014-02-01', E'activo', E'Almacenero', 6, 1),
  (7, E'Interface de Solicitud de Compra,  directos y secretarias', E'2014-02-03', E'activo', E'ADQ - Solicitud de Compra', 7, 1),
  (8, E'Visto Bueno Solicitud de Compras', E'2014-02-03', E'activo', E'ADQ - Visto Bueno Sol', 7, 1),
  (9, E'Visto bueno orden de compra cotizacion', E'2014-02-03', E'activo', E'ADQ - Visto Bueno OC/COT', 7, 1),
  (10, E'Visto Bueno devengaos o pagos', E'2014-02-03', E'inactivo', E'ADQ - Visto Bueno DEV/PAG', 7, NULL),
  (11, E'Resposnable de Adquisiciones', E'2014-02-03', E'activo', E'ADQ. RESP ADQ', 7, 1),
  (12, E'ADQ - Aux Adquisiciones', E'2014-02-03', E'activo', E'ADQ - Aux Adquisiciones', 7, 1),
  (13, E'Presolicitudes de Compra', E'2014-02-03', E'activo', E'ADQ - Presolicitud de Compra', 7, 1),
  (14, E'Registro de Proveedores', E'2014-02-03', E'activo', E'ADQ - Registro Proveedores', 7, 1),
  (15, E'Visto bueno presolicitudes de compra', E'2014-02-03', E'activo', E'ADQ - VioBo Presolicitud', 7, 1),
  (16, E'Consolidador de presolicitudes de Compra', E'2014-02-03', E'activo', E'ADQ - Consolidaro Presolicitudes', 7, 1),
  (17, E'Visto Bueno de plan de PAgos', E'2014-02-03', E'inactivo', E'OP - VoBo Plan de PAgos', 7, NULL),
  (18, E'Visto Bueno plan de pagos', E'2014-02-03', E'activo', E'OP - VoBo Plan de Pagos', 11, 1),
  (19, E'Interface de Obligaciones de Pago, directamente sobre la interface de tesoreria', E'2014-02-03', E'activo', E'OP - Obligaciones de PAgo', 11, 1),
  (20, E'Relación Contable Concepto Gasto', E'2014-02-04', E'inactivo', E'Relación Contable Concepto Gasto', 10, NULL),
  (21, E'CONTA-Rleacion contable concepto gatos', E'2014-02-04', E'inactivo', E'CONTA-Rleacion contable concepto gatos', 10, NULL),
  (22, E'CONTA- Relación Contable Concepto Gasto', E'2014-02-04', E'activo', E'CONTA- Relación Contable Concepto Gasto', 10, 1),
  (23, E'Rol para ingreso de relaciones de proveedores con Auxiliar Contable', E'2014-02-17', E'activo', E'CONTA - Relacion Proveedor - Cuenta Contable', 10, 1),
  (24, E'Registra salidas de almacenes', E'2014-02-21', E'activo', E'ALM - Asistente de Almacenes', 6, 1),
  (25, E'ingreso a Reportes', E'2014-02-21', E'activo', E'ALM - Consulta', 6, 1),
  (26, E'Pagos de servicios que no requieren proceso', E'2014-03-25', E'activo', E'OP - Pagos Directos de Servicios', 11, 1),
  (27, E'Para el Encargado de habilitar los preingreso y enviarlos al modulo de activos fijos', E'2014-03-25', E'activo', E'ADQ - Preingreso AF', 7, 1),
  (28, E'Cierre de proceso con finalizacion de documentos', E'2014-03-25', E'activo', E'OP - Cierre de Proceso', 11, 1),
  (29, E'PXP-Rol inicial', E'2014-03-28', E'activo', E'PXP-Rol inicial', 0, 1),
  (30, E'Registro de Cuenta Bancaria', E'2014-03-31', E'activo', E'OP - Cuenta Bancaria', 11, 1),
  (31, E'Para registrar relaciones contables con cuenta bancaria', E'2014-04-01', E'activo', E'CONTA - Relacion cuenta Bancaria', 10, 1),
  (32, E'Rol para relaciones contables', E'2014-04-01', E'activo', E'CONTA - Relaciones contables ELACIONES CONTABLES', 10, 1),
  (33, E'Rol pra edicion modiificacion o configuracion de plantilla de docuemntos contables ', E'2014-04-01', E'activo', E'CONTA - Plantilla de Documentos', 10, 1),
  (34, E'OP - Solicitudes de Pago Recurrente (Con Contrato)', E'2014-06-12', E'activo', E'OP - Solicitudes de Pago Directas', 11, NULL),
  (35, E'Registro de Servicios Telefónicos', E'2014-07-29', E'activo', E'Registro de Servicios', 15, 1),
  (36, E'Registro de Números Corporativos', E'2014-07-29', E'activo', E'Registro de Números Corporativos', 15, 1),
  (37, E'Asignación de Números Corporativos', E'2014-07-29', E'activo', E'Asignación de Números Corporativos', 15, 1),
  (38, E'Registro de Consumo Corporativo', E'2014-07-29', E'activo', E'Registro de Consumo Corporativo', 15, 1),
  (39, E'Lectura de la interfaz de planillas', E'2014-08-08', E'activo', E'PLANI - Planillas Lectura', 13, NULL),
  (40, E'ORGA - Registro de Cuentas de Servicios ', E'2014-08-12', E'activo', E'ORGA - Registro de Cuentas de Servicios ', 4, NULL),
  (41, E'VoBo procesos de WF', E'2014-08-18', E'activo', E'WF - VoBo', 5, 1),
  (42, E'OP - VoBo Pago Contabilidad', E'2014-09-01', E'activo', E'OP - VoBo Pago Contabilidad', 11, 1),
  (43, E'OP -Visto Bueno Contabilidad', E'2014-09-03', E'activo', E'OP -Visto Bueno Contabilidad', 11, 1),
  (44, E'Solo para consulta de documentos ', E'2014-09-03', E'activo', E'OP - Revision Documentos', 11, 1),
  (45, E'Visto buenos fondos en avances', E'2014-09-12', E'activo', E'OP -VoBo Fondos en Avance', 11, 1),
  (46, E'Las asistentes pueden revisar los vistobuenos pendientes de sus asistidos', E'2014-09-18', E'activo', E'ADQ - VoBo Solicitud (Asistentes)', 7, NULL),
  (47, E'OP - VoBo Ppagos (Asistentes)', E'2014-09-18', E'activo', E'OP - VoBo Ppagos (Asistentes)', 11, 1),
  (48, E'ADQ - VoBo Presupuestos', E'2014-09-22', E'activo', E'ADQ - VoBo Presupuestos', 7, NULL),
  (49, E'Rol para consulta de obligacionens de pago, necesita estar en el departamento de contabilidad', E'2014-09-23', E'activo', E'OP - Plan de Pagos Consulta', 11, 1),
  (50, E'PAra consulta de solicitudes de compra', E'2014-09-30', E'activo', E'ADQ - Consulta Solicitudes ', 7, NULL),
  (51, E'OP - Reporte Pagos X Concepto', E'2014-10-24', E'activo', E'OP - Reporte Pagos X Concepto', 11, 1),
  (52, NULL, E'2014-11-04', E'activo', E'ORGA - Asignar interinos', 4, NULL),
  (53, E'PLANI- Registro de Planillas', E'2014-11-24', E'activo', E'PLANI- Registro de Planillas', 13, NULL),
  (54, E'Accesso a la interface de solicitudes de pago para contabilidad', E'2014-12-02', E'activo', E'OP - Solicitud OP (Conta)', 11, NULL),
  (55, E'OP -Consulta de solicitudes de pago', E'2014-12-02', E'activo', E'OP -Consulta de solicitudes de pago', 11, NULL),
  (56, E'OP - Depositos y Cheques', E'2014-12-26', E'activo', E'OP - Depositos y Cheques', 11, NULL),
  (57, E'OP - Libro de Bancos', E'2014-12-26', E'activo', E'OP - Libro de Bancos', 11, NULL),
  (58, E'OP - Consulta Libro Bancos', E'2014-12-26', E'activo', E'OP - Consulta Libro Bancos', 11, NULL),
  (59, E'OP - VoBo Obligación de Pago (Presupuestos)', E'2015-01-06', E'activo', E'OP - VoBo Obligación de Pago (Presupuestos)', 11, NULL),
  (60, E'ADQ- VoBo Solicitudes de  Compras (Presupuestos)', E'2015-01-15', E'activo', E'ADQ- VoBo Sol Compras (Presupuestos)', 7, NULL),
  (61, E'AF - Preingreso Activos ERP 1', E'2015-01-26', E'activo', E'AF - Preingreso Activos', 14, NULL),
  (62, E'ADQ - Reporte Ejecución Presupuestaria', E'2015-02-19', E'activo', E'ADQ - Reporte Ejecución Presupuestaria', 7, NULL),
  (63, E'Listado de Contratos Finalizados', E'2015-03-17', E'inactivo', E'CONTFIN', 16, NULL),
  (64, NULL, E'2015-03-17', E'activo', E'LEG- Contrato Finalizado', 16, NULL),
  (65, E'Reportes de Planillas', E'2015-03-26', E'activo', E'PLANI - Reportes Planillas', 13, NULL),
  (66, E'ORGA- Consulta Estructura Organizacional', E'2015-03-30', E'activo', E'ORGA- Consulta Estructura Organizacional', 4, NULL),
  (67, E'Cierre y Apertura del periodo de obligaciones de pago', E'2015-04-06', E'activo', E'OP - Periodo Obligaciones de Pago', 11, NULL),
  (68, E'Solo coonsulta', E'2015-05-06', E'activo', E'ADQ - VoBo Presupuestos Consulta', 7, NULL),
  (69, NULL, E'2015-05-08', E'activo', E'LEG-Abogado', 16, 1),
  (70, NULL, E'2015-05-08', E'activo', E'LEG-Gerencia', 16, 1),
  (71, NULL, E'2015-05-08', E'activo', E'LEG - Jefe Legal', 16, 1),
  (72, NULL, E'2015-05-08', E'activo', E'LEG-Digitalizacion', 16, 1),
  (73, NULL, E'2015-05-08', E'activo', E'LEG-Firma Contraparte', 16, 1),
  (74, NULL, E'2015-05-08', E'activo', E'LEG-Firma RPC', 16, 1),
  (75, NULL, E'2015-05-08', E'activo', E'LEG-Firma GAF', 16, 1),
  (76, E'ADQ - Visto Bueno Poa', E'2015-05-08', E'activo', E'ADQ - VoBo Poa', 7, NULL),
  (77, NULL, E'2015-05-08', E'activo', E'LEG-Solicitante', 16, 1),
  (78, E'OP - Pago unico (Sin contrato)', E'2015-05-09', E'activo', E'OP - Pago unico (Sin contrato)', 11, NULL),
  (79, NULL, E'2015-05-18', E'activo', E'LEG-Revision', 16, NULL),
  (80, NULL, E'2015-06-05', E'activo', E'LEG-Firma comercial', 16, NULL),
  (81, E'OP - Pago sin Presupuesto', E'2015-08-20', E'activo', E'OP - Pago sin Presupuesto', 11, NULL),
  (82, E'CONTA- OT Oficina', E'2015-10-09', E'activo', E'CONTA- OT Oficina', 10, NULL),
  (83, E'Obligaciones de Pago', E'2015-12-09', E'activo', E'ADQ- Obligaciones de Pago', 7, NULL),
  (84, E'Devoluciones', E'2015-12-30', E'activo', E'DECR-Devoluciones', 17, NULL),
  (85, E'CONTA - Bancarización Compras', E'2016-01-26', E'activo', E'CONTA - Bancarización Compras', 10, NULL),
  (86, E'CONTA - Bancarización Ventas', E'2016-01-26', E'activo', E'CONTA - Bancarización Ventas', 10, NULL),
  (87, E'Reporte libro de compras estandar y NCD', E'2016-04-22', E'activo', E'CONTA - Libro de Compras', 10, NULL),
  (88, E'Pagos Sin Facturas Asociadas', E'2016-05-09', E'activo', E'OP - Pagos Sin Facturas Asociadas', 11, NULL),
  (89, E'CD - Solicitud de Fondos en Avance', E'2016-06-20', E'activo', E'CD - Solicitud de Fondos en Avance', 20, NULL),
  (90, E'CD - VoBo Tesoreria', E'2016-06-20', E'activo', E'CD - VoBo Tesoreria', 20, NULL),
  (91, E'CD - VoBo Cuenta Documentada', E'2016-06-20', E'activo', E'CD - VoBo Cuenta Documentada', 20, NULL),
  (92, NULL, E'2016-07-04', E'activo', E'CAJA - Cajero', 11, NULL),
  (93, NULL, E'2016-07-04', E'activo', E'CAJA - Solicitud Creacion Caja', 11, NULL),
  (94, NULL, E'2016-07-04', E'activo', E'CAJA - VoBo Creacion Caja', 11, NULL),
  (95, E'ORGA - Consulta Funcionarios', E'2016-07-06', E'activo', E'ORGA - Consulta Funcionarios', 4, NULL),
  (96, E'PRE - Administrador de presupuestos', E'2016-07-08', E'activo', E'PRE - Administrador de presupuestos', 8, NULL),
  (97, E'CONTA - Revisor Documentos Fiscales', E'2016-07-08', E'activo', E'CONTA - Revisor Documentos Fiscales', 10, NULL),
  (98, E'CONTA - Administrador Documentos Fiscales', E'2016-07-08', E'activo', E'CONTA - Administrador Documentos Fiscales', 10, NULL),
  (99, E'CONTA - Consulta documentos Fiscales', E'2016-07-08', E'activo', E'CONTA - Consulta documentos Fiscales', 10, NULL),
  (100, E'CONTA - Bancarización Compras (CONSULTA)', E'2016-07-11', E'activo', E'CONTA - Bancarización Compras (CONSULTA)', 10, NULL),
  (101, E'Generación del comprobante contable en funcion a la solicitud', E'2016-07-20', E'activo', E'CAJA - Contabilidad', 11, NULL),
  (102, E'Solicitud de efectivo a caja chica', E'2016-07-20', E'activo', E'CAJA - Solicitud de efectivo', 11, NULL),
  (103, NULL, E'2016-07-20', E'inactivo', E'CAJA - VoBo Creación de Caja', 11, NULL),
  (104, E'Visto Bueno Facturas Rendicion', E'2016-07-20', E'activo', E'CAJA - VoBo Facturas Rendicion', 11, NULL),
  (105, E'Visto Bueno Fondos', E'2016-07-20', E'activo', E'CAJA - VoBo Fondos', 11, NULL),
  (106, E'VoBo Rendiciones Caja Presupuestos', E'2016-07-20', E'activo', E'CAJA - VoBo Rend Presup', 11, NULL),
  (107, E'CAJA - VoBo Rend/Repo Cajas', E'2016-07-20', E'activo', E'CAJA - VoBo Rend/Repo Cajas', 11, NULL),
  (108, E'VoBo Solicitud de Efectivo', E'2016-07-20', E'activo', E'CAJA - VoBo Solicitud de Efectivo', 11, NULL),
  (109, E'PRE - Formulacion', E'2016-08-02', E'activo', E'PRE - Formulacion', 8, NULL),
  (110, E'CD - Consulta Fondos en Avance', E'2016-08-04', E'activo', E'CD - Consulta Fondos en Avance', 20, NULL),
  (111, E'CD - VoBo Cuenta Documentada Central', E'2016-08-17', E'activo', E'CD - VoBo Cuenta Documentada Central', 20, NULL),
  (112, E'PLANI-Reporte Planilla Actualizada', E'2016-10-04', E'activo', E'PLANI-Reporte Planilla Actualizada', 13, NULL),
  (113, NULL, E'2016-10-06', E'activo', E'CONTA - Libro Diario', 10, NULL),
  (114, NULL, E'2016-11-07', E'activo', E'Reporte Fondos Avance', 20, NULL),
  (115, E'Dotacion Ropa de Trabajo', E'2016-11-10', E'activo', E'ALM - Dotaciones', 6, NULL),
  (116, E'CONTA - Administrador', E'2016-11-17', E'activo', E'CONTA - Administrador', 10, NULL),
  (117, E'sd\nd\nf', E'2016-11-17', E'inactivo', E'asdf', 14, NULL),
  (118, E'OBINGRESOS - Reporte Nit Razon', E'2016-11-18', E'activo', E'OBINGRESOS - Reporte Nit Razon', 19, NULL),
  (119, E'PARAM - Grupo de EP', E'2016-11-24', E'activo', E'PARAM - Grupo de EP', 2, NULL),
  (120, NULL, E'2016-11-24', E'activo', E'SEGU - Usuarios y Grupo EPs', 1, NULL),
  (121, NULL, E'2016-11-25', E'activo', E'Reporte Procesos', 7, NULL),
  (122, E'OBINGRESOS-Reportes Depositos', E'2016-11-29', E'activo', E'OBINGRESOS-Reportes Depositos', 19, NULL),
  (123, E'PRE - Conceptos de Gasto / Autorizaciones', E'2016-11-29', E'activo', E'PRE - Conceptos de Gasto / Autorizaciones', 8, NULL),
  (124, E'Conceptos de gastos po gestion', E'2016-12-01', E'activo', E'PARAM - ConceptosGastosGestion', 2, NULL),
  (125, E'GM - Solicitante de Materiales ', E'2017-01-08', E'activo', E'GM - Solicitante de Materiales ', 22, NULL),
  (126, E'GM - Visto Bueno ', E'2017-01-08', E'activo', E'GM - Visto Bueno ', 22, NULL),
  (127, E'GM -  Auxiliar Abastecimientos ', E'2017-01-08', E'activo', E'GM -  Auxiliar Abastecimientos  ', 22, NULL),
  (128, E'GM - Consulta de Solicitudes ', E'2017-01-08', E'activo', E'GM - Consulta de Solicitudes ', 22, NULL),
  (129, E'GM - Solicitante', E'2017-01-08', E'inactivo', E'GM - Solicitante', 22, NULL),
  (130, E'GM - Visto Bueno Solicitud', E'2017-01-08', E'inactivo', E'GM - Visto Bueno Solicitud', 22, NULL),
  (131, E'GM - Abastecimientos', E'2017-01-08', E'inactivo', E'GM - Abastecimientos', 22, NULL),
  (132, E'GM - Auxiliar Abastecimientos', E'2017-01-08', E'inactivo', E'GM - Auxiliar Abastecimientos', 22, NULL),
  (133, E'CONTA - Cajero', E'2017-01-09', E'inactivo', E'CONTA - Cajero', 10, NULL),
  (134, E'CONTA - Contador', E'2017-01-09', E'activo', E'CONTA - Contador', 10, NULL),
  (135, E'Procesos iniciados adjudicados ejecutados', E'2017-01-09', E'activo', E'ADQ - Reporte Iniciados Adjudicados Ejecutados', 7, NULL),
  (136, E'OP - VoBo Costos', E'2017-01-11', E'activo', E'OP - VoBo Costos', 11, NULL),
  (137, E'CONTA - Registro Facturas Comisiones', E'2017-01-12', E'activo', E'CONTA - Registro Facturas Comisiones', 10, NULL),
  (138, E'GM - Cotización y Compra ', E'2017-01-12', E'activo', E'GM - Cotización y Compra ', 22, NULL),
  (139, E'OBINGRESOS - Modificaciones Venta Web', E'2017-01-13', E'activo', E'OBINGRESOS - Modificaciones Venta Web', 19, NULL),
  (140, NULL, E'2017-01-16', E'activo', E'CONTA - Plan de cuentas', 10, NULL),
  (141, E'BANCOS - Extracto Bancario', E'2017-01-16', E'activo', E'BANCOS - Extracto Bancario', 21, NULL),
  (142, E'AF-Reportes ERP 1', E'2017-01-20', E'activo', E'AF-Reportes', 14, NULL),
  (143, E'REC - Administrador Reclamos', E'2017-01-27', E'activo', E'REC - Administrador Reclamos', 23, NULL),
  (144, E'REC - Especialista SAC', E'2017-01-27', E'activo', E'REC - Especialista SAC', 23, NULL),
  (145, E'REC - Parametros Generales', E'2017-01-27', E'activo', E'REC - Parametros Generales', 23, NULL),
  (146, E'REC - Tecnico SAC', E'2017-01-27', E'activo', E'REC - Tecnico SAC', 23, NULL),
  (147, E'REC - Responsable SAC', E'2017-01-27', E'activo', E'REC - Responsable SAC', 23, NULL),
  (148, E'REC - Legal SAC', E'2017-01-27', E'activo', E'REC - Legal SAC', 23, NULL),
  (149, E'REC - OperadorOdeco SAC', E'2017-01-27', E'activo', E'REC - OperadorOdeco SAC', 23, NULL),
  (150, E'Consultas Auditoria Interna', E'2017-02-01', E'activo', E'Consultas Auditoria Interna', 1, NULL),
  (151, E'Consultas Auditoria Externa', E'2017-02-01', E'activo', E'Consultas Auditoria Externa', 1, NULL),
  (152, E'PLANI-Reporte de Movimientos', E'2017-02-06', E'activo', E'PLANI-Reporte de Movimientos', 13, NULL),
  (153, E'CD - Ampliacion Fondos en Avance', E'2017-02-08', E'activo', E'CD - Ampliacion Fondos en Avance', 20, NULL),
  (154, E'GM - Almacenes', E'2017-02-10', E'activo', E'GM - Almacenes', 22, NULL),
  (155, E'PRE - Relacionar partida con presupuestos', E'2017-02-17', E'activo', E'PRE - Relacionar partida con presupuestos', 8, NULL),
  (156, E'Reporte presupuestos', E'2017-02-20', E'activo', E'PRE - Reportes Presupuestos', 8, NULL),
  (157, E'OBINGRESOS-Registro Depositos', E'2017-03-01', E'activo', E'OBINGRESOS-Registro Depositos', 19, NULL),
  (158, E'OP - VoBo Plan de Pagos (Presupuestos)', E'2017-03-01', E'activo', E'OP - VoBo Plan de Pagos (Presupuestos)', 11, NULL),
  (159, NULL, E'2017-03-03', E'inactivo', E'PLA - Generar Reporte Planilla', 13, NULL),
  (160, E'PARAM - Consulta Grupo EP y Usuarios', E'2017-03-06', E'activo', E'PARAM - Consulta Grupo EP y Usuarios', 2, NULL),
  (161, E'COS - Clasificador de Costos', E'2017-03-07', E'activo', E'COS - Clasificador de Costos', 28, NULL),
  (162, E'VEF - Vendedor', E'2017-03-17', E'activo', E'VEF - Vendedor', 25, NULL),
  (163, E'VEF - Cajero', E'2017-03-17', E'activo', E'VEF - Cajero', 25, NULL),
  (164, E'REC - Consulta de reclamos', E'2017-04-04', E'activo', E'REC - Consulta de reclamos', 23, NULL),
  (165, E'CONTA - Reportes', E'2017-04-04', E'activo', E'CONTA - Reportes', 10, NULL),
  (166, E'GM - Gestor Aduanero', E'2017-04-10', E'activo', E'GM - Gestor Aduanero', 22, NULL),
  (167, NULL, E'2017-04-21', E'activo', E'webfirma', 4, NULL),
  (168, E'CONTA-Bancarizacion-bloquear-desbloquear', E'2017-05-26', E'activo', E'CONTA-Bancarizacion-bloquear-desbloquear', 10, NULL),
  (169, E'Ampliación días de rendición caja chica', E'2017-06-07', E'activo', E'CAJA - Ampliación Caja Chica', 11, NULL),
  (170, NULL, E'2017-06-16', E'activo', E'CONTA - Libro Diario (Consulta)', 10, NULL),
  (171, E'CONTA - Validador Documentos', E'2017-06-22', E'activo', E'CONTA - Validador Documentos', 10, NULL),
  (172, E'CVPN - Solicitante Conexión', E'2017-06-26', E'activo', E'CVPN - Solicitante Conexión', 29, NULL),
  (173, E'CVPN - VoBo Sol. Conexión', E'2017-06-26', E'activo', E'CVPN - VoBo Sol. Conexión', 29, NULL),
  (174, E'CONTA - Resolución 101700000014', E'2017-07-03', E'activo', E'CONTA - Resolución 101700000014', 10, NULL),
  (175, E'PRE - Consulta Presupuestos', E'2017-07-06', E'activo', E'PRE - Consulta Presupuestos', 8, NULL),
  (176, E'RestColas para conectarse  con el touch y panel', E'2017-08-03', E'activo', E'RestColas', 30, NULL),
  (177, E'COUNTER COLAS', E'2017-08-03', E'activo', E'COUNTER COLAS', 30, NULL),
  (178, E'GM - Visto Bueno Comité ', E'2017-08-14', E'activo', E'GM - Visto Bueno Comité ', 22, NULL),
  (179, E'ORGA - Certificados de Trabajo', E'2017-08-18', E'activo', E'ORGA - Certificados de Trabajo', 4, 1),
  (180, E'VENT - Administrador Sistema de Ventas', E'2017-08-18', E'activo', E'VENT - Administrador Sistema de Ventas', 25, NULL),
  (181, E'OBINGRESOS-Portal Corporativo', E'2017-09-11', E'activo', E'OBINGRESOS-Portal Corporativo', 19, NULL),
  (182, E'SIGEP - Clasificadores', E'2017-09-15', E'activo', E'SIGEP - Clasificadores', 32, NULL),
  (183, E'CONTA - Consulta de Entregas', E'2017-09-19', E'activo', E'CONTA - Consulta de Entregas', 10, NULL),
  (184, E'AF - Administrador', E'2017-09-21', E'activo', E'AF - Administrador', 33, NULL),
  (185, E'AF - Auxiliar Activos Fijos', E'2017-09-21', E'activo', E'AF - Auxiliar Activos Fijos', 33, NULL),
  (186, E'AF - Auxiliar Activos TI', E'2017-09-21', E'activo', E'AF - Auxiliar Activos TI', 33, NULL),
  (187, E'AF - Responsable Activos TI', E'2017-09-21', E'activo', E'AF - Responsable Activos TI', 33, NULL),
  (188, E'AF - Consulta Parametros', E'2017-09-21', E'activo', E'AF - Consulta Parametros', 33, NULL),
  (189, E'VEF - Counter', E'2017-09-22', E'activo', E'VEF - Counter', 25, NULL),
  (190, E'VEF - Tesoreria', E'2017-09-22', E'activo', E'VEF - Tesoreria', 25, NULL),
  (191, E'VEF - Cajero CTO', E'2017-10-04', E'inactivo', E'VEF - Cajero CTO', 19, NULL),
  (192, E'Eliminar Rol', E'2017-10-04', E'inactivo', E'VEF - Cajero CTO', 25, NULL),
  (193, E'ORGA - Certificados Emitidos', E'2017-10-13', E'activo', E'ORGA - Certificados Emitidos', 4, NULL),
  (194, E'AF - Búsqueda de Activos', E'2017-10-18', E'activo', E'AF - Búsqueda de Activos', 33, NULL),
  (195, E'VEF - Dosificaciónes', E'2017-10-20', E'activo', E'VEF - Dosificaciónes', 25, NULL),
  (197, E'ORGA - Documentos Funcionarios', E'2017-10-23', E'activo', E'ORGA - Archivos Adjuntos', 4, NULL),
  (198, E'OBING-upload depositos', E'2017-11-21', E'activo', E'OBING-upload depositos', 19, NULL),
  (199, E'POA - Objetivos', E'2017-12-26', E'activo', E'POA - Objetivos', 24, NULL),
  (200, NULL, E'2017-12-27', E'activo', E'COLAS-Admin', 30, NULL),
  (201, E'OBINGRESOS-Portal lectura', E'2018-01-03', E'activo', E'OBINGRESOS-Portal lectura', 19, NULL),
  (202, E'OP - Pagos Gestiones Anteriores', E'2018-01-08', E'activo', E'OP - Pagos Gestiones Anteriores', 11, NULL),
  (203, E'OBINGRESOS-Admin Portal Corporativo', E'2018-01-23', E'activo', E'OBINGRESOS-Admin Portal Corporativo', 19, NULL),
  (204, E'ORGA - Presuesto Cargo', E'2018-02-16', E'activo', E'ORGA - Presuesto Cargo', 4, NULL),
  (205, E'ADQ - Consulta 400, 500', E'2018-03-05', E'activo', E'ADQ - Consulta 400, 500', 7, NULL),
  (206, E'PLANI - VoBo RRHH Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo RRHH Planilla', 13, NULL),
  (207, E'PLANI - VoBo POA Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo POA Planilla', 13, NULL),
  (208, E'PLANI - VoBo SUP Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo SUP Planilla', 13, NULL),
  (209, E'PLANI - VoBo PRESU Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo PRESU Planilla', 13, NULL),
  (210, E'REC - Clientes', E'2018-04-03', E'activo', E'REC - Clientes', 23, NULL),
  (211, E'ORGA - Responsable de Correos', E'2018-04-26', E'activo', E'ORGA - Responsable de Correos', 4, NULL),
  (212, E'Consulta de provedores', E'2018-05-02', E'activo', E'ADQ - Consulta de Proveedores', 7, NULL),
  (213, E'OBINGRESOS - Consulta Boletas de Garantia', E'2018-05-02', E'activo', E'OBINGRESOS - Consulta Boletas de Garantia', 19, NULL),
  (214, E'ORGA - Ficha Personal', E'2018-05-03', E'activo', E'ORGA - Ficha Personal', 4, NULL),
  (215, E'ORGA - Evaluación de Desempeño', E'2018-05-22', E'activo', E'ORGA - Evaluación de Desempeño', 4, NULL),
  (216, E'CONTA - Comprobantes ERP vs SIGEP', E'2018-05-28', E'activo', E'CONTA - Comprobantes ERP vs SIGEP', 10, NULL),
  (217, E'PARAM-REGISTRO-DE-PERSONA', E'2018-06-01', E'inactivo', E'PARAM-REGISTRO-DE-PERSONA', 2, NULL),
  (218, E'SEGU - Registro de persona', E'2018-06-01', E'activo', E'SEGU-REGISTRO-DE-PERSONA', 1, NULL),
  (219, E'OP - Pago de Compras en el Exterior', E'2018-06-04', E'activo', E'OP - Pago de Compras en el Exterior', 11, NULL),
  (220, E'ORGA - Gestión Personal', E'2018-06-13', E'activo', E'ORGA - Gestión Personal', 4, NULL),
  (221, E'ORGA - Consulta Presupuesto por Cargo', E'2018-06-20', E'activo', E'ORGA - Consulta Presupuesto por Cargo', 4, NULL),
  (222, E'AF - Consulta Clasificador de Activos', E'2018-06-25', E'activo', E'AF - Consulta Clasificador de Activos', 33, NULL),
  (223, E'ORGA - Cumpleaños BoA', E'2018-06-28', E'activo', E'ORGA - Cumpleaños BoA', 4, NULL),
  (224, E'ORGA - Edición Memo Desempeño', E'2018-07-02', E'activo', E'ORGA - Edición Memo Desempeño', 4, NULL),
  (225, E'PLANI - Configuración Parametros', E'2018-07-09', E'activo', E'PLANI - Configuración Parametros', 13, NULL),
  (226, E'VEF - Consulta Ventas', E'2018-07-10', E'activo', E'VEF - Consulta Ventas', 25, NULL),
  (227, E'OP - VoBo Obligacion Pago', E'2018-07-12', E'activo', E'OP - VoBo Obligacion Pago', 11, NULL),
  (228, E'ALM - Responsable Almacen TI', E'2018-08-20', E'activo', E'ALM - Responsable Almacen TI', 6, NULL),
  (229, E'KAF - Modificar AF Pasantes', E'2018-09-25', E'activo', E'KAF - Modificar AF Pasantes', 33, NULL),
  (230, E'OBINGRESOS-Administrador Acm', E'2018-10-11', E'activo', E'OBINGRESOS-Administrador Acm', 19, NULL),
  (231, E'OBINGRESOS-Operador Acm', E'2018-10-11', E'activo', E'OBINGRESOS-Operador Acm', 19, NULL),
  (232, E'ORGA - Registro Funcionarios', E'2018-10-17', E'activo', E'ORGA - Registro Funcionarios', 4, NULL),
  (233, E'OBINGRESOS-Consulta Acm', E'2018-10-25', E'activo', E'OBINGRESOS-Consulta Acm', 19, NULL),
  (234, E'PARAM - Registrar Tipos de Cambio', E'2018-12-01', E'activo', E'PARAM - Registrar Tipos de Cambio', 2, NULL),
  (235, E'CONTA - Auxiliares', E'2018-12-05', E'activo', E'CONTA - Auxiliares', 10, NULL),
  (236, E'TES - Pago BOA REP', E'2018-12-26', E'activo', E'TES - Pago BOA REP', 11, NULL),
  (237, E'TES - Pago de Procesos Manuales', E'2019-01-07', E'activo', E'TES - Pago de Procesos Manuales', 11, NULL),
  (238, E'AF - Interfaz Principal', E'2019-01-11', E'activo', E'AF - Interfaz Principal', 14, NULL),
  (239, E'VEF - Viajero Interno', E'2019-01-14', E'activo', E'VEF - Viajero Interno', 25, NULL);


/*******************************************F-DAT-FEA-SEGU-0-17/01/2019***********************************************/