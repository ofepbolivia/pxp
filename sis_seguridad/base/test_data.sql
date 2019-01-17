/*
*	Author: BOA
*	Date: 01-01-2019
*	Description: Test data
*/

-------------------------------------------
--- FRH  ---
-------------------------------------------

-- Persona





/* Data for the 'segu.ttipo_documento' table */

INSERT INTO segu.ttipo_documento ("id_tipo_documento", "nombre", "descripcion", "fecha_reg", "estado_reg")
VALUES (1, E'CI', E'Cédula de Identidad', E'2018-11-12 09:33:05', E'activo');

INSERT INTO segu.ttipo_documento ("id_tipo_documento", "nombre", "descripcion", "fecha_reg", "estado_reg")
VALUES (2, E'NIT', E'Numero de Identificación Tributaria\r\n', E'2018-11-12 09:33:33', E'activo');

INSERT INTO segu.ttipo_documento ("id_tipo_documento", "nombre", "descripcion", "fecha_reg", "estado_reg")
VALUES (5, E'Pasaporte', E'Pasaporte', E'2018-11-12 09:34:59', E'activo');


-----------
--- GSS ---
-----------

--usuarios

/*INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (21, NULL, E'maria.echavarria', E'154de1763043a7b0e2ed667b0aab469e', E'2013-12-31', E'2012-07-25', E'xtheme-aero.css', NULL, 8426, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (16, NULL, E'kbarrancos', E'154de1763043a7b0e2ed667b0aab469e', E'2018-12-31', E'2012-05-22', E'xtheme-aero.css', NULL, 8439, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (39, NULL, E'angela.correa', E'154de1763043a7b0e2ed667b0aab469e', E'2013-12-31', E'2012-09-21', E'xtheme-aero.css', NULL, 8443, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (20, NULL, E'claudia.guzman', E'154de1763043a7b0e2ed667b0aab469e', E'2013-12-31', E'2012-07-25', E'xtheme-aero.css', NULL, 8445, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (17, NULL, E'htapia', E'154de1763043a7b0e2ed667b0aab469e', E'2018-12-31', E'2012-05-22', E'xtheme-aero.css', NULL, 8446, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (49, NULL, E'karin.soto', E'bff71ae74af09afe9d392da8966e7a09', E'2018-12-31', E'2013-01-14', E'xtheme-aero.css', NULL, 8447, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (50, NULL, E'eliana.cruz', E'b9e771cfc340797b1b831f9dcf13220e', E'2018-12-31', E'2013-01-14', E'xtheme-aero.css', NULL, 8448, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (22, NULL, E'jose.lobaton', E'154de1763043a7b0e2ed667b0aab469e', E'2013-12-31', E'2012-08-03', E'xtheme-aero.css', NULL, 9004, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (51, NULL, E'francisco', E'117735823fadae51db091c7d63e60eb0', E'2013-08-30', E'2013-04-30', E'xtheme-blue.css', NULL, 8791, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (52, NULL, E'guido', E'a3c4b614a1f072e0f968c2712a36323f', E'2013-07-31', E'2013-04-30', E'xtheme-blue.css', NULL, 8727, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (53, NULL, E'miguel', E'9eb0c9605dc81a68731f61b3e0838937', E'2013-07-31', E'2013-04-30', E'xtheme-gray.css', NULL, 8477, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (54, NULL, E'roger', E'b911af807c2df88d671bd7004c54c1c2', E'2013-06-25', E'2013-04-30', E'xtheme-blue.css', NULL, 8716, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (55, NULL, E'marco', E'f5888d0bb58d611107e11f7cbc41c97a', E'2013-07-31', E'2013-04-30', E'xtheme-gray.css', NULL, 8466, E'activo', E'local');

INSERT INTO segu.tusuario ("id_usuario", "id_clasificador", "cuenta", "contrasena", "fecha_caducidad", "fecha_reg", "estilo", "contrasena_anterior", "id_persona", "estado_reg", "autentificacion")
VALUES (56, NULL, E'rocio', E'325daa03a34823cef2fc367c779561ba', E'2013-08-31', E'2013-04-30', E'xtheme-gray.css', NULL, 8415, E'activo', E'local');*/

---------------------
--- USUARIO-GRUPO-EP
--------------------

/*INSERT INTO segu.tusuario_grupo_ep ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_grupo_ep", "id_usuario", "id_grupo")
VALUES (1, NULL, E'2013-05-08 15:19:05.586', NULL, E'activo', 1, 51, 1);*/

/*=============================================================== DATOS BASE (f.e.a) =================================================================*/

/* Data for the 'segu.trol' table */

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (1, E'Administrador', E'2011-05-17', E'activo', E'Administrador', NULL, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (2, E'Administrador Almacenes', E'2014-02-01', E'activo', E'Administrador Almacenes', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (3, NULL, E'2014-02-01', E'activo', E'Asistente de Almacenes', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (4, E'solicita items de almacenes', E'2014-02-01', E'activo', E'Solicitante de Almacenes', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (5, E'visto bueno solicitud de almacen', E'2014-02-01', E'activo', E'Visto Bueno Solicitud Almacen', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (6, E'almacenero se ocupa de registrar los items que ingresan', E'2014-02-01', E'activo', E'Almacenero', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (7, E'Interface de Solicitud de Compra,  directos y secretarias', E'2014-02-03', E'activo', E'ADQ - Solicitud de Compra', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (8, E'Visto Bueno Solicitud de Compras', E'2014-02-03', E'activo', E'ADQ - Visto Bueno Sol', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (9, E'Visto bueno orden de compra cotizacion', E'2014-02-03', E'activo', E'ADQ - Visto Bueno OC/COT', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (10, E'Visto Bueno devengaos o pagos', E'2014-02-03', E'inactivo', E'ADQ - Visto Bueno DEV/PAG', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (11, E'Resposnable de Adquisiciones', E'2014-02-03', E'activo', E'ADQ. RESP ADQ', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (12, E'ADQ - Aux Adquisiciones', E'2014-02-03', E'activo', E'ADQ - Aux Adquisiciones', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (13, E'Presolicitudes de Compra', E'2014-02-03', E'activo', E'ADQ - Presolicitud de Compra', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (14, E'Registro de Proveedores', E'2014-02-03', E'activo', E'ADQ - Registro Proveedores', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (15, E'Visto bueno presolicitudes de compra', E'2014-02-03', E'activo', E'ADQ - VioBo Presolicitud', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (16, E'Consolidador de presolicitudes de Compra', E'2014-02-03', E'activo', E'ADQ - Consolidaro Presolicitudes', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (17, E'Visto Bueno de plan de PAgos', E'2014-02-03', E'inactivo', E'OP - VoBo Plan de PAgos', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (18, E'Visto Bueno plan de pagos', E'2014-02-03', E'activo', E'OP - VoBo Plan de Pagos', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (19, E'Interface de Obligaciones de Pago, directamente sobre la interface de tesoreria', E'2014-02-03', E'activo', E'OP - Obligaciones de PAgo', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (20, E'Relación Contable Concepto Gasto', E'2014-02-04', E'inactivo', E'Relación Contable Concepto Gasto', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (21, E'CONTA-Rleacion contable concepto gatos', E'2014-02-04', E'inactivo', E'CONTA-Rleacion contable concepto gatos', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (22, E'CONTA- Relación Contable Concepto Gasto', E'2014-02-04', E'activo', E'CONTA- Relación Contable Concepto Gasto', 10, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (23, E'Rol para ingreso de relaciones de proveedores con Auxiliar Contable', E'2014-02-17', E'activo', E'CONTA - Relacion Proveedor - Cuenta Contable', 10, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (24, E'Registra salidas de almacenes', E'2014-02-21', E'activo', E'ALM - Asistente de Almacenes', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (25, E'ingreso a Reportes', E'2014-02-21', E'activo', E'ALM - Consulta', 6, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (26, E'Pagos de servicios que no requieren proceso', E'2014-03-25', E'activo', E'OP - Pagos Directos de Servicios', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (27, E'Para el Encargado de habilitar los preingreso y enviarlos al modulo de activos fijos', E'2014-03-25', E'activo', E'ADQ - Preingreso AF', 7, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (28, E'Cierre de proceso con finalizacion de documentos', E'2014-03-25', E'activo', E'OP - Cierre de Proceso', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (29, E'PXP-Rol inicial', E'2014-03-28', E'activo', E'PXP-Rol inicial', 0, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (30, E'Registro de Cuenta Bancaria', E'2014-03-31', E'activo', E'OP - Cuenta Bancaria', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (31, E'Para registrar relaciones contables con cuenta bancaria', E'2014-04-01', E'activo', E'CONTA - Relacion cuenta Bancaria', 10, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (32, E'Rol para relaciones contables', E'2014-04-01', E'activo', E'CONTA - Relaciones contables ELACIONES CONTABLES', 10, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (33, E'Rol pra edicion modiificacion o configuracion de plantilla de docuemntos contables ', E'2014-04-01', E'activo', E'CONTA - Plantilla de Documentos', 10, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (34, E'OP - Solicitudes de Pago Recurrente (Con Contrato)', E'2014-06-12', E'activo', E'OP - Solicitudes de Pago Directas', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (35, E'Registro de Servicios Telefónicos', E'2014-07-29', E'activo', E'Registro de Servicios', 15, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (36, E'Registro de Números Corporativos', E'2014-07-29', E'activo', E'Registro de Números Corporativos', 15, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (37, E'Asignación de Números Corporativos', E'2014-07-29', E'activo', E'Asignación de Números Corporativos', 15, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (38, E'Registro de Consumo Corporativo', E'2014-07-29', E'activo', E'Registro de Consumo Corporativo', 15, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (39, E'Lectura de la interfaz de planillas', E'2014-08-08', E'activo', E'PLANI - Planillas Lectura', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (40, E'ORGA - Registro de Cuentas de Servicios ', E'2014-08-12', E'activo', E'ORGA - Registro de Cuentas de Servicios ', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (41, E'VoBo procesos de WF', E'2014-08-18', E'activo', E'WF - VoBo', 5, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (42, E'OP - VoBo Pago Contabilidad', E'2014-09-01', E'activo', E'OP - VoBo Pago Contabilidad', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (43, E'OP -Visto Bueno Contabilidad', E'2014-09-03', E'activo', E'OP -Visto Bueno Contabilidad', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (44, E'Solo para consulta de documentos ', E'2014-09-03', E'activo', E'OP - Revision Documentos', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (45, E'Visto buenos fondos en avances', E'2014-09-12', E'activo', E'OP -VoBo Fondos en Avance', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (46, E'Las asistentes pueden revisar los vistobuenos pendientes de sus asistidos', E'2014-09-18', E'activo', E'ADQ - VoBo Solicitud (Asistentes)', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (47, E'OP - VoBo Ppagos (Asistentes)', E'2014-09-18', E'activo', E'OP - VoBo Ppagos (Asistentes)', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (48, E'ADQ - VoBo Presupuestos', E'2014-09-22', E'activo', E'ADQ - VoBo Presupuestos', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (49, E'Rol para consulta de obligacionens de pago, necesita estar en el departamento de contabilidad', E'2014-09-23', E'activo', E'OP - Plan de Pagos Consulta', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (50, E'PAra consulta de solicitudes de compra', E'2014-09-30', E'activo', E'ADQ - Consulta Solicitudes ', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (51, E'OP - Reporte Pagos X Concepto', E'2014-10-24', E'activo', E'OP - Reporte Pagos X Concepto', 11, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (52, NULL, E'2014-11-04', E'activo', E'ORGA - Asignar interinos', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (53, E'PLANI- Registro de Planillas', E'2014-11-24', E'activo', E'PLANI- Registro de Planillas', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (54, E'Accesso a la interface de solicitudes de pago para contabilidad', E'2014-12-02', E'activo', E'OP - Solicitud OP (Conta)', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (55, E'OP -Consulta de solicitudes de pago', E'2014-12-02', E'activo', E'OP -Consulta de solicitudes de pago', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (56, E'OP - Depositos y Cheques', E'2014-12-26', E'activo', E'OP - Depositos y Cheques', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (57, E'OP - Libro de Bancos', E'2014-12-26', E'activo', E'OP - Libro de Bancos', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (58, E'OP - Consulta Libro Bancos', E'2014-12-26', E'activo', E'OP - Consulta Libro Bancos', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (59, E'OP - VoBo Obligación de Pago (Presupuestos)', E'2015-01-06', E'activo', E'OP - VoBo Obligación de Pago (Presupuestos)', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (60, E'ADQ- VoBo Solicitudes de  Compras (Presupuestos)', E'2015-01-15', E'activo', E'ADQ- VoBo Sol Compras (Presupuestos)', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (61, E'AF - Preingreso Activos ERP 1', E'2015-01-26', E'activo', E'AF - Preingreso Activos', 14, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (62, E'ADQ - Reporte Ejecución Presupuestaria', E'2015-02-19', E'activo', E'ADQ - Reporte Ejecución Presupuestaria', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (63, E'Listado de Contratos Finalizados', E'2015-03-17', E'inactivo', E'CONTFIN', 16, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (64, NULL, E'2015-03-17', E'activo', E'LEG- Contrato Finalizado', 16, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (65, E'Reportes de Planillas', E'2015-03-26', E'activo', E'PLANI - Reportes Planillas', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (66, E'ORGA- Consulta Estructura Organizacional', E'2015-03-30', E'activo', E'ORGA- Consulta Estructura Organizacional', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (67, E'Cierre y Apertura del periodo de obligaciones de pago', E'2015-04-06', E'activo', E'OP - Periodo Obligaciones de Pago', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (68, E'Solo coonsulta', E'2015-05-06', E'activo', E'ADQ - VoBo Presupuestos Consulta', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (69, NULL, E'2015-05-08', E'activo', E'LEG-Abogado', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (70, NULL, E'2015-05-08', E'activo', E'LEG-Gerencia', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (71, NULL, E'2015-05-08', E'activo', E'LEG - Jefe Legal', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (72, NULL, E'2015-05-08', E'activo', E'LEG-Digitalizacion', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (73, NULL, E'2015-05-08', E'activo', E'LEG-Firma Contraparte', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (74, NULL, E'2015-05-08', E'activo', E'LEG-Firma RPC', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (75, NULL, E'2015-05-08', E'activo', E'LEG-Firma GAF', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (76, E'ADQ - Visto Bueno Poa', E'2015-05-08', E'activo', E'ADQ - VoBo Poa', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (77, NULL, E'2015-05-08', E'activo', E'LEG-Solicitante', 16, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (78, E'OP - Pago unico (Sin contrato)', E'2015-05-09', E'activo', E'OP - Pago unico (Sin contrato)', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (79, NULL, E'2015-05-18', E'activo', E'LEG-Revision', 16, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (80, NULL, E'2015-06-05', E'activo', E'LEG-Firma comercial', 16, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (81, E'OP - Pago sin Presupuesto', E'2015-08-20', E'activo', E'OP - Pago sin Presupuesto', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (82, E'CONTA- OT Oficina', E'2015-10-09', E'activo', E'CONTA- OT Oficina', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (83, E'Obligaciones de Pago', E'2015-12-09', E'activo', E'ADQ- Obligaciones de Pago', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (84, E'Devoluciones', E'2015-12-30', E'activo', E'DECR-Devoluciones', 17, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (85, E'CONTA - Bancarización Compras', E'2016-01-26', E'activo', E'CONTA - Bancarización Compras', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (86, E'CONTA - Bancarización Ventas', E'2016-01-26', E'activo', E'CONTA - Bancarización Ventas', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (87, E'Reporte libro de compras estandar y NCD', E'2016-04-22', E'activo', E'CONTA - Libro de Compras', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (88, E'Pagos Sin Facturas Asociadas', E'2016-05-09', E'activo', E'OP - Pagos Sin Facturas Asociadas', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (89, E'CD - Solicitud de Fondos en Avance', E'2016-06-20', E'activo', E'CD - Solicitud de Fondos en Avance', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (90, E'CD - VoBo Tesoreria', E'2016-06-20', E'activo', E'CD - VoBo Tesoreria', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (91, E'CD - VoBo Cuenta Documentada', E'2016-06-20', E'activo', E'CD - VoBo Cuenta Documentada', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (92, NULL, E'2016-07-04', E'activo', E'CAJA - Cajero', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (93, NULL, E'2016-07-04', E'activo', E'CAJA - Solicitud Creacion Caja', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (94, NULL, E'2016-07-04', E'activo', E'CAJA - VoBo Creacion Caja', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (95, E'ORGA - Consulta Funcionarios', E'2016-07-06', E'activo', E'ORGA - Consulta Funcionarios', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (96, E'PRE - Administrador de presupuestos', E'2016-07-08', E'activo', E'PRE - Administrador de presupuestos', 8, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (97, E'CONTA - Revisor Documentos Fiscales', E'2016-07-08', E'activo', E'CONTA - Revisor Documentos Fiscales', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (98, E'CONTA - Administrador Documentos Fiscales', E'2016-07-08', E'activo', E'CONTA - Administrador Documentos Fiscales', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (99, E'CONTA - Consulta documentos Fiscales', E'2016-07-08', E'activo', E'CONTA - Consulta documentos Fiscales', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (100, E'CONTA - Bancarización Compras (CONSULTA)', E'2016-07-11', E'activo', E'CONTA - Bancarización Compras (CONSULTA)', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (101, E'Generación del comprobante contable en funcion a la solicitud', E'2016-07-20', E'activo', E'CAJA - Contabilidad', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (102, E'Solicitud de efectivo a caja chica', E'2016-07-20', E'activo', E'CAJA - Solicitud de efectivo', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (103, NULL, E'2016-07-20', E'inactivo', E'CAJA - VoBo Creación de Caja', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (104, E'Visto Bueno Facturas Rendicion', E'2016-07-20', E'activo', E'CAJA - VoBo Facturas Rendicion', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (105, E'Visto Bueno Fondos', E'2016-07-20', E'activo', E'CAJA - VoBo Fondos', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (106, E'VoBo Rendiciones Caja Presupuestos', E'2016-07-20', E'activo', E'CAJA - VoBo Rend Presup', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (107, E'CAJA - VoBo Rend/Repo Cajas', E'2016-07-20', E'activo', E'CAJA - VoBo Rend/Repo Cajas', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (108, E'VoBo Solicitud de Efectivo', E'2016-07-20', E'activo', E'CAJA - VoBo Solicitud de Efectivo', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (109, E'PRE - Formulacion', E'2016-08-02', E'activo', E'PRE - Formulacion', 8, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (110, E'CD - Consulta Fondos en Avance', E'2016-08-04', E'activo', E'CD - Consulta Fondos en Avance', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (111, E'CD - VoBo Cuenta Documentada Central', E'2016-08-17', E'activo', E'CD - VoBo Cuenta Documentada Central', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (112, E'PLANI-Reporte Planilla Actualizada', E'2016-10-04', E'activo', E'PLANI-Reporte Planilla Actualizada', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (113, NULL, E'2016-10-06', E'activo', E'CONTA - Libro Diario', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (114, NULL, E'2016-11-07', E'activo', E'Reporte Fondos Avance', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (115, E'Dotacion Ropa de Trabajo', E'2016-11-10', E'activo', E'ALM - Dotaciones', 6, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (116, E'CONTA - Administrador', E'2016-11-17', E'activo', E'CONTA - Administrador', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (117, E'sd\nd\nf', E'2016-11-17', E'inactivo', E'asdf', 14, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (118, E'OBINGRESOS - Reporte Nit Razon', E'2016-11-18', E'activo', E'OBINGRESOS - Reporte Nit Razon', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (119, E'PARAM - Grupo de EP', E'2016-11-24', E'activo', E'PARAM - Grupo de EP', 2, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (120, NULL, E'2016-11-24', E'activo', E'SEGU - Usuarios y Grupo EPs', 1, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (121, NULL, E'2016-11-25', E'activo', E'Reporte Procesos', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (122, E'OBINGRESOS-Reportes Depositos', E'2016-11-29', E'activo', E'OBINGRESOS-Reportes Depositos', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (123, E'PRE - Conceptos de Gasto / Autorizaciones', E'2016-11-29', E'activo', E'PRE - Conceptos de Gasto / Autorizaciones', 8, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (124, E'Conceptos de gastos po gestion', E'2016-12-01', E'activo', E'PARAM - ConceptosGastosGestion', 2, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (125, E'GM - Solicitante de Materiales ', E'2017-01-08', E'activo', E'GM - Solicitante de Materiales ', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (126, E'GM - Visto Bueno ', E'2017-01-08', E'activo', E'GM - Visto Bueno ', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (127, E'GM -  Auxiliar Abastecimientos ', E'2017-01-08', E'activo', E'GM -  Auxiliar Abastecimientos  ', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (128, E'GM - Consulta de Solicitudes ', E'2017-01-08', E'activo', E'GM - Consulta de Solicitudes ', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (129, E'GM - Solicitante', E'2017-01-08', E'inactivo', E'GM - Solicitante', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (130, E'GM - Visto Bueno Solicitud', E'2017-01-08', E'inactivo', E'GM - Visto Bueno Solicitud', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (131, E'GM - Abastecimientos', E'2017-01-08', E'inactivo', E'GM - Abastecimientos', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (132, E'GM - Auxiliar Abastecimientos', E'2017-01-08', E'inactivo', E'GM - Auxiliar Abastecimientos', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (133, E'CONTA - Cajero', E'2017-01-09', E'inactivo', E'CONTA - Cajero', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (134, E'CONTA - Contador', E'2017-01-09', E'activo', E'CONTA - Contador', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (135, E'Procesos iniciados adjudicados ejecutados', E'2017-01-09', E'activo', E'ADQ - Reporte Iniciados Adjudicados Ejecutados', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (136, E'OP - VoBo Costos', E'2017-01-11', E'activo', E'OP - VoBo Costos', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (137, E'CONTA - Registro Facturas Comisiones', E'2017-01-12', E'activo', E'CONTA - Registro Facturas Comisiones', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (138, E'GM - Cotización y Compra ', E'2017-01-12', E'activo', E'GM - Cotización y Compra ', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (139, E'OBINGRESOS - Modificaciones Venta Web', E'2017-01-13', E'activo', E'OBINGRESOS - Modificaciones Venta Web', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (140, NULL, E'2017-01-16', E'activo', E'CONTA - Plan de cuentas', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (141, E'BANCOS - Extracto Bancario', E'2017-01-16', E'activo', E'BANCOS - Extracto Bancario', 21, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (142, E'AF-Reportes ERP 1', E'2017-01-20', E'activo', E'AF-Reportes', 14, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (143, E'REC - Administrador Reclamos', E'2017-01-27', E'activo', E'REC - Administrador Reclamos', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (144, E'REC - Especialista SAC', E'2017-01-27', E'activo', E'REC - Especialista SAC', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (145, E'REC - Parametros Generales', E'2017-01-27', E'activo', E'REC - Parametros Generales', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (146, E'REC - Tecnico SAC', E'2017-01-27', E'activo', E'REC - Tecnico SAC', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (147, E'REC - Responsable SAC', E'2017-01-27', E'activo', E'REC - Responsable SAC', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (148, E'REC - Legal SAC', E'2017-01-27', E'activo', E'REC - Legal SAC', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (149, E'REC - OperadorOdeco SAC', E'2017-01-27', E'activo', E'REC - OperadorOdeco SAC', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (150, E'Consultas Auditoria Interna', E'2017-02-01', E'activo', E'Consultas Auditoria Interna', 1, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (151, E'Consultas Auditoria Externa', E'2017-02-01', E'activo', E'Consultas Auditoria Externa', 1, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (152, E'PLANI-Reporte de Movimientos', E'2017-02-06', E'activo', E'PLANI-Reporte de Movimientos', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (153, E'CD - Ampliacion Fondos en Avance', E'2017-02-08', E'activo', E'CD - Ampliacion Fondos en Avance', 20, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (154, E'GM - Almacenes', E'2017-02-10', E'activo', E'GM - Almacenes', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (155, E'PRE - Relacionar partida con presupuestos', E'2017-02-17', E'activo', E'PRE - Relacionar partida con presupuestos', 8, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (156, E'Reporte presupuestos', E'2017-02-20', E'activo', E'PRE - Reportes Presupuestos', 8, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (157, E'OBINGRESOS-Registro Depositos', E'2017-03-01', E'activo', E'OBINGRESOS-Registro Depositos', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (158, E'OP - VoBo Plan de Pagos (Presupuestos)', E'2017-03-01', E'activo', E'OP - VoBo Plan de Pagos (Presupuestos)', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (159, NULL, E'2017-03-03', E'inactivo', E'PLA - Generar Reporte Planilla', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (160, E'PARAM - Consulta Grupo EP y Usuarios', E'2017-03-06', E'activo', E'PARAM - Consulta Grupo EP y Usuarios', 2, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (161, E'COS - Clasificador de Costos', E'2017-03-07', E'activo', E'COS - Clasificador de Costos', 28, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (162, E'VEF - Vendedor', E'2017-03-17', E'activo', E'VEF - Vendedor', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (163, E'VEF - Cajero', E'2017-03-17', E'activo', E'VEF - Cajero', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (164, E'REC - Consulta de reclamos', E'2017-04-04', E'activo', E'REC - Consulta de reclamos', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (165, E'CONTA - Reportes', E'2017-04-04', E'activo', E'CONTA - Reportes', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (166, E'GM - Gestor Aduanero', E'2017-04-10', E'activo', E'GM - Gestor Aduanero', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (167, NULL, E'2017-04-21', E'activo', E'webfirma', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (168, E'CONTA-Bancarizacion-bloquear-desbloquear', E'2017-05-26', E'activo', E'CONTA-Bancarizacion-bloquear-desbloquear', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (169, E'Ampliación días de rendición caja chica', E'2017-06-07', E'activo', E'CAJA - Ampliación Caja Chica', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (170, NULL, E'2017-06-16', E'activo', E'CONTA - Libro Diario (Consulta)', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (171, E'CONTA - Validador Documentos', E'2017-06-22', E'activo', E'CONTA - Validador Documentos', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (172, E'CVPN - Solicitante Conexión', E'2017-06-26', E'activo', E'CVPN - Solicitante Conexión', 29, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (173, E'CVPN - VoBo Sol. Conexión', E'2017-06-26', E'activo', E'CVPN - VoBo Sol. Conexión', 29, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (174, E'CONTA - Resolución 101700000014', E'2017-07-03', E'activo', E'CONTA - Resolución 101700000014', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (175, E'PRE - Consulta Presupuestos', E'2017-07-06', E'activo', E'PRE - Consulta Presupuestos', 8, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (176, E'RestColas para conectarse  con el touch y panel', E'2017-08-03', E'activo', E'RestColas', 30, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (177, E'COUNTER COLAS', E'2017-08-03', E'activo', E'COUNTER COLAS', 30, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (178, E'GM - Visto Bueno Comité ', E'2017-08-14', E'activo', E'GM - Visto Bueno Comité ', 22, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (179, E'ORGA - Certificados de Trabajo', E'2017-08-18', E'activo', E'ORGA - Certificados de Trabajo', 4, 1);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (180, E'VENT - Administrador Sistema de Ventas', E'2017-08-18', E'activo', E'VENT - Administrador Sistema de Ventas', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (181, E'OBINGRESOS-Portal Corporativo', E'2017-09-11', E'activo', E'OBINGRESOS-Portal Corporativo', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (182, E'SIGEP - Clasificadores', E'2017-09-15', E'activo', E'SIGEP - Clasificadores', 32, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (183, E'CONTA - Consulta de Entregas', E'2017-09-19', E'activo', E'CONTA - Consulta de Entregas', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (184, E'AF - Administrador', E'2017-09-21', E'activo', E'AF - Administrador', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (185, E'AF - Auxiliar Activos Fijos', E'2017-09-21', E'activo', E'AF - Auxiliar Activos Fijos', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (186, E'AF - Auxiliar Activos TI', E'2017-09-21', E'activo', E'AF - Auxiliar Activos TI', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (187, E'AF - Responsable Activos TI', E'2017-09-21', E'activo', E'AF - Responsable Activos TI', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (188, E'AF - Consulta Parametros', E'2017-09-21', E'activo', E'AF - Consulta Parametros', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (189, E'VEF - Counter', E'2017-09-22', E'activo', E'VEF - Counter', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (190, E'VEF - Tesoreria', E'2017-09-22', E'activo', E'VEF - Tesoreria', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (191, E'VEF - Cajero CTO', E'2017-10-04', E'inactivo', E'VEF - Cajero CTO', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (192, E'Eliminar Rol', E'2017-10-04', E'inactivo', E'VEF - Cajero CTO', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (193, E'ORGA - Certificados Emitidos', E'2017-10-13', E'activo', E'ORGA - Certificados Emitidos', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (194, E'AF - Búsqueda de Activos', E'2017-10-18', E'activo', E'AF - Búsqueda de Activos', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (195, E'VEF - Dosificaciónes', E'2017-10-20', E'activo', E'VEF - Dosificaciónes', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (197, E'ORGA - Documentos Funcionarios', E'2017-10-23', E'activo', E'ORGA - Archivos Adjuntos', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (198, E'OBING-upload depositos', E'2017-11-21', E'activo', E'OBING-upload depositos', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (199, E'POA - Objetivos', E'2017-12-26', E'activo', E'POA - Objetivos', 24, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (200, NULL, E'2017-12-27', E'activo', E'COLAS-Admin', 30, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (201, E'OBINGRESOS-Portal lectura', E'2018-01-03', E'activo', E'OBINGRESOS-Portal lectura', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (202, E'OP - Pagos Gestiones Anteriores', E'2018-01-08', E'activo', E'OP - Pagos Gestiones Anteriores', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (203, E'OBINGRESOS-Admin Portal Corporativo', E'2018-01-23', E'activo', E'OBINGRESOS-Admin Portal Corporativo', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (204, E'ORGA - Presuesto Cargo', E'2018-02-16', E'activo', E'ORGA - Presuesto Cargo', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (205, E'ADQ - Consulta 400, 500', E'2018-03-05', E'activo', E'ADQ - Consulta 400, 500', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (206, E'PLANI - VoBo RRHH Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo RRHH Planilla', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (207, E'PLANI - VoBo POA Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo POA Planilla', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (208, E'PLANI - VoBo SUP Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo SUP Planilla', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (209, E'PLANI - VoBo PRESU Planilla', E'2018-03-15', E'activo', E'PLANI - VoBo PRESU Planilla', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (210, E'REC - Clientes', E'2018-04-03', E'activo', E'REC - Clientes', 23, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (211, E'ORGA - Responsable de Correos', E'2018-04-26', E'activo', E'ORGA - Responsable de Correos', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (212, E'Consulta de provedores', E'2018-05-02', E'activo', E'ADQ - Consulta de Proveedores', 7, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (213, E'OBINGRESOS - Consulta Boletas de Garantia', E'2018-05-02', E'activo', E'OBINGRESOS - Consulta Boletas de Garantia', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (214, E'ORGA - Ficha Personal', E'2018-05-03', E'activo', E'ORGA - Ficha Personal', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (215, E'ORGA - Evaluación de Desempeño', E'2018-05-22', E'activo', E'ORGA - Evaluación de Desempeño', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (216, E'CONTA - Comprobantes ERP vs SIGEP', E'2018-05-28', E'activo', E'CONTA - Comprobantes ERP vs SIGEP', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (217, E'PARAM-REGISTRO-DE-PERSONA', E'2018-06-01', E'inactivo', E'PARAM-REGISTRO-DE-PERSONA', 2, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (218, E'SEGU - Registro de persona', E'2018-06-01', E'activo', E'SEGU-REGISTRO-DE-PERSONA', 1, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (219, E'OP - Pago de Compras en el Exterior', E'2018-06-04', E'activo', E'OP - Pago de Compras en el Exterior', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (220, E'ORGA - Gestión Personal', E'2018-06-13', E'activo', E'ORGA - Gestión Personal', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (221, E'ORGA - Consulta Presupuesto por Cargo', E'2018-06-20', E'activo', E'ORGA - Consulta Presupuesto por Cargo', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (222, E'AF - Consulta Clasificador de Activos', E'2018-06-25', E'activo', E'AF - Consulta Clasificador de Activos', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (223, E'ORGA - Cumpleaños BoA', E'2018-06-28', E'activo', E'ORGA - Cumpleaños BoA', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (224, E'ORGA - Edición Memo Desempeño', E'2018-07-02', E'activo', E'ORGA - Edición Memo Desempeño', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (225, E'PLANI - Configuración Parametros', E'2018-07-09', E'activo', E'PLANI - Configuración Parametros', 13, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (226, E'VEF - Consulta Ventas', E'2018-07-10', E'activo', E'VEF - Consulta Ventas', 25, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (227, E'OP - VoBo Obligacion Pago', E'2018-07-12', E'activo', E'OP - VoBo Obligacion Pago', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (228, E'ALM - Responsable Almacen TI', E'2018-08-20', E'activo', E'ALM - Responsable Almacen TI', 6, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (229, E'KAF - Modificar AF Pasantes', E'2018-09-25', E'activo', E'KAF - Modificar AF Pasantes', 33, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (230, E'OBINGRESOS-Administrador Acm', E'2018-10-11', E'activo', E'OBINGRESOS-Administrador Acm', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (231, E'OBINGRESOS-Operador Acm', E'2018-10-11', E'activo', E'OBINGRESOS-Operador Acm', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (232, E'ORGA - Registro Funcionarios', E'2018-10-17', E'activo', E'ORGA - Registro Funcionarios', 4, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (233, E'OBINGRESOS-Consulta Acm', E'2018-10-25', E'activo', E'OBINGRESOS-Consulta Acm', 19, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (234, E'PARAM - Registrar Tipos de Cambio', E'2018-12-01', E'activo', E'PARAM - Registrar Tipos de Cambio', 2, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (235, E'CONTA - Auxiliares', E'2018-12-05', E'activo', E'CONTA - Auxiliares', 10, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (236, E'TES - Pago BOA REP', E'2018-12-26', E'activo', E'TES - Pago BOA REP', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (237, E'TES - Pago de Procesos Manuales', E'2019-01-07', E'activo', E'TES - Pago de Procesos Manuales', 11, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (238, E'AF - Interfaz Principal', E'2019-01-11', E'activo', E'AF - Interfaz Principal', 14, NULL);

INSERT INTO segu.trol ("id_rol", "descripcion", "fecha_reg", "estado_reg", "rol", "id_subsistema", "modificado")
VALUES (239, E'VEF - Viajero Interno', E'2019-01-14', E'activo', E'VEF - Viajero Interno', 25, NULL);