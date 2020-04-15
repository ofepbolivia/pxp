/***********************************I-SCP-FRH-WF-0-15/02/2013****************************************/


CREATE TABLE wf.ttipo_proceso (
  id_tipo_proceso   SERIAL NOT NULL, 
  id_tipo_estado   int4, 
  id_proceso_macro int4 NOT NULL, 
  nombre           varchar(200), 
  tabla            varchar(100), 
  columna_llave    varchar(150), 
  codigo           varchar(5),
  
  inicio VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  CONSTRAINT uk_codigo UNIQUE(codigo),
  CONSTRAINT uk_tipo_proceso_tipo_estado UNIQUE(id_tipo_proceso,id_tipo_estado),
  PRIMARY KEY (id_tipo_proceso)) INHERITS (pxp.tbase);
  
  
CREATE TABLE wf.ttipo_estado (
  id_tipo_estado   SERIAL NOT NULL, 
  id_tipo_proceso int4, 
  codigo		  varchar(100),
  nombre_estado   varchar(150),
  inicio          varchar(2), 
  disparador      varchar(2), 
  fin          varchar(2), 
  tipo_asignacion varchar(50),
  nombre_func_list varchar(255),
  depto_asignacion varchar(50) DEFAULT 'ninguno'::character varying NOT NULL,
  nombre_depto_func_list varchar(255),
  obs             text,
  alerta VARCHAR(3) DEFAULT 'no'::character varying NOT NULL, 
  pedir_obs VARCHAR(3) DEFAULT 'no'::character varying NOT NULL, 
  PRIMARY KEY (id_tipo_estado)) INHERITS (pxp.tbase); 
  
  
CREATE TABLE wf.testructura_estado (
  id_estructura_estado  SERIAL NOT NULL, 
  id_tipo_estado_padre  int4 NOT NULL, 
  id_tipo_estado_hijo   int4 NOT NULL, 
  prioridad             int4, 
  regla                 varchar(1000), 
  PRIMARY KEY (id_estructura_estado)) INHERITS (pxp.tbase);
  
  
CREATE TABLE wf.testado_wf (
  id_estado_wf           SERIAL NOT NULL, 
  id_estado_anterior int4, 
  id_tipo_estado     int4 NOT NULL, 
  id_proceso_wf         int4 NOT NULL, 
  id_funcionario     int4, 
  fecha              timestamp, 
  id_depto           int4,
  tipo_cambio 		 VARCHAR(20) NOT NULL DEFAULT 'siguiente'::varchar,
  obs TEXT DEFAULT ''::text NOT NULL, 
   id_alarma INTEGER[], 
  PRIMARY KEY (id_estado_wf)) INHERITS (pxp.tbase);
  
  
CREATE TABLE wf.tnum_tramite (
  id_num_tramite    SERIAL NOT NULL, 
  id_proceso_macro int4 NOT NULL, 
  id_gestion       int4 NOT NULL, 
  num_siguiente    int4, 
  PRIMARY KEY (id_num_tramite)) INHERITS (pxp.tbase);
     
  
CREATE TABLE wf.tcolumna (
  id_columna       SERIAL NOT NULL, 
  id_tipo_proceso int4 NOT NULL, 
  nombre          varchar(150), 
  tipo_dato       varchar(100), 
  orden           int4, 
  PRIMARY KEY (id_columna)) INHERITS (pxp.tbase);
  
  
CREATE TABLE wf.tcolumna_valor (
  id_columna_valor  SERIAL NOT NULL, 
  id_columna       int4 NOT NULL, 
  id_proceso_wf       int4 NOT NULL, 
  valor            varchar(300), 
  PRIMARY KEY (id_columna_valor)) INHERITS (pxp.tbase);
    
  
CREATE TABLE wf.tproceso_wf (
  id_proceso_wf       SERIAL NOT NULL, 
  id_tipo_proceso int4 NOT NULL, 
  id_estado_wf_prev int4,
  nro_tramite     varchar, 
  valor_cl        int8, 
  id_persona INTEGER, 
  id_institucion INTEGER,
  fecha_ini DATE DEFAULT now() NOT NULL, 
  tipo_ini VARCHAR(30) DEFAULT 'persona'::character varying NOT NULL,    
  PRIMARY KEY (id_proceso_wf)) INHERITS (pxp.tbase);
  
  
  
  
CREATE TABLE wf.tproceso_macro (
  id_proceso_macro  SERIAL NOT NULL, 
  id_subsistema    int4, 
  codigo           varchar(10) UNIQUE, 
  nombre           varchar(200), 
  inicio           varchar(2), 
  PRIMARY KEY (id_proceso_macro)) INHERITS (pxp.tbase);
  
/*****************************F-SCP-FRH-WF-0-15/02/2013**********************************************/


/***********************************I-SCP-FRH-WF-0-18/02/2013****************************************/

CREATE TABLE wf.tfuncionario_tipo_estado (
  id_funcionario_tipo_estado  SERIAL NOT NULL, 
  id_tipo_estado             int4 NOT NULL,
  id_funcionario             int4,   
  id_depto                   int4,
  id_labores_tipo_proceso    int4,  
  PRIMARY KEY (id_funcionario_tipo_estado)) INHERITS (pxp.tbase); 
  
  CREATE TABLE wf.tlabores_tipo_proceso (
  id_labores_tipo_proceso  SERIAL NOT NULL, 
  id_tipo_proceso         int4 NOT NULL, 
  nombre                  varchar(50), 
  codigo                  varchar(15) UNIQUE, 
  descripcion             varchar(255), 
  PRIMARY KEY (id_labores_tipo_proceso)) INHERITS (pxp.tbase);

/***********************************F-SCP-FRH-WF-0-18/02/2013****************************************/

/***********************************I-SCP-RAC-WF-0-18/09/2013****************************************/

ALTER TABLE wf.tproceso_wf
  ADD COLUMN descripcion VARCHAR(250);
  
/***********************************F-SCP-RAC-WF-0-18/09/2013****************************************/



/***********************************I-SCP-RAC-WF-0-03/12/2013****************************************/

ALTER TABLE wf.ttipo_proceso
  ALTER COLUMN codigo TYPE VARCHAR(10) COLLATE pg_catalog."default";

/***********************************F-SCP-RAC-WF-0-03/12/2013****************************************/



/***********************************I-SCP-RAC-WF-0-15/01/2014****************************************/

CREATE TABLE wf.ttipo_documento(
    id_tipo_documento SERIAL NOT NULL,
    id_tipo_proceso int4 NOT NULL,
    id_proceso_macro int4 NOT NULL,
    codigo varchar(25),
    nombre varchar(255),
    descripcion text,
    action  varchar,
    tipo VARCHAR(30) DEFAULT 'escaneado'::character varying NOT NULL, 
    PRIMARY KEY (id_tipo_documento)) INHERITS (pxp.tbase);


 
CREATE TABLE wf.ttipo_documento_estado(
    id_tipo_documento_estado SERIAL NOT NULL,
    id_tipo_documento int4 NOT NULL,
    id_tipo_proceso int4 NOT NULL,
    id_tipo_estado int4 NOT NULL,
    momento varchar(255),
    PRIMARY KEY (id_tipo_documento_estado))INHERITS (pxp.tbase);


CREATE TABLE wf.tdocumento_wf(
    id_documento_wf SERIAL NOT NULL,
    id_tipo_documento serial NOT NULL,
    id_proceso_wf serial NOT NULL,
    num_tramite varchar(200),
    momento varchar(255),
    nombre_tipo_doc varchar(200),
    nombre_doc varchar(200),
    chequeado varchar(10),
    url varchar(200),
    extencion varchar(5),
    obs text,
    PRIMARY KEY (id_documento_wf)) INHERITS (pxp.tbase);


--------------- SQL ---------------

ALTER TABLE wf.tproceso_wf
  ADD COLUMN codigo_proceso VARCHAR(150) DEFAULT '' NOT NULL;
  

ALTER TABLE wf.tproceso_wf
  ALTER COLUMN codigo_proceso DROP DEFAULT;


COMMENT ON COLUMN wf.tproceso_wf.codigo_proceso
IS 'es un codigo que permite identifica al proceso origen de manrea univoca, por ejemplo nuro de solicitud de compra, orden de compra, o numero de cuota, etc';


--------------- SQL ---------------

--------------- SQL ---------------

ALTER TABLE wf.tproceso_wf
  ALTER COLUMN descripcion TYPE VARCHAR(1000) COLLATE pg_catalog."default";


ALTER TABLE wf.tproceso_wf
  ALTER COLUMN codigo_proceso TYPE VARCHAR(350) COLLATE pg_catalog."default";


/***********************************F-SCP-RAC-WF-0-15/01/2014****************************************/


/***********************************I-SCP-RAC-WF-0-16/01/2014****************************************/


--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN id_estado_ini INTEGER;

COMMENT ON COLUMN wf.tdocumento_wf.id_estado_ini
IS 'hace referencia al estado donde se creo el documento';


/***********************************F-SCP-RAC-WF-0-16/01/2014****************************************/



/***********************************I-SCP-RAC-WF-0-18/01/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  RENAME COLUMN extencion TO extension;


/***********************************F-SCP-RAC-WF-0-18/01/2014****************************************/



/***********************************I-SCP-RAC-WF-0-12/02/2014****************************************/


ALTER TABLE wf.ttipo_documento_estado
  ADD COLUMN tipo_busqueda VARCHAR(12) DEFAULT 'superior' NOT NULL;

COMMENT ON COLUMN wf.ttipo_documento_estado.tipo_busqueda
IS 'superior o inferior, define la forma de buscar el documento';



/***********************************F-SCP-RAC-WF-0-12/02/2014****************************************/



/***********************************I-SCP-RAC-WF-0-17/02/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN chequeado_fisico VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN wf.tdocumento_wf.chequeado_fisico
IS 'identifica los documentos que se tienen fisicamente';

--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN momento_fisico VARCHAR(30) DEFAULT 'verificar' NOT NULL;

COMMENT ON COLUMN wf.tdocumento_wf.momento_fisico
IS 'verificar o exigir documentos fisicos';


/***********************************F-SCP-RAC-WF-0-17/02/2014****************************************/



/***********************************I-SCP-RAC-WF-0-21/02/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN id_usuario_upload INTEGER;

--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN fecha_upload TIMESTAMP WITHOUT TIME ZONE;
  
/***********************************F-SCP-RAC-WF-0-22/02/2014****************************************/



/***********************************I-SCP-RAC-WF-0-25/03/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_proceso
  ADD COLUMN funcion_validacion_wf VARCHAR(200);

COMMENT ON COLUMN wf.ttipo_proceso.funcion_validacion_wf
IS 'Nombre de la funcion de validacion, esta funcion retorna falso o verdadero. Sirve para decidir si el proceso se inia o no (ejemplo preingresos de almaces o aactivos fijos al relaizar compras)';

--------------- SQL ---------------

ALTER TABLE wf.ttipo_proceso
  ADD COLUMN tipo_disparo VARCHAR(40);

COMMENT ON COLUMN wf.ttipo_proceso.tipo_disparo
IS 'obligatorio -> define si el proceso se dispara siempre, opcional -> (el usuario decide), opcional_automatico (se revisa la funcion de validacion), bandeja -> el proceso queda pendiente en una bandeja de espera';


--------------- SQL ---------------

ALTER TABLE wf.ttipo_proceso
  ADD COLUMN descripcion VARCHAR;

COMMENT ON COLUMN wf.ttipo_proceso.descripcion
IS 'campo que describe el tipo de proceso';

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN descripcion VARCHAR;  

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN plantilla_mensaje VARCHAR;

COMMENT ON COLUMN wf.ttipo_estado.plantilla_mensaje
IS 'plantilla de mensajes para el envio de alertas';

--------------- SQL ---------------

COMMENT ON COLUMN wf.ttipo_estado.obs
IS 'Este campo se utiliza para adicionar comodines que pueden ser utile en el proceso. Por ejemplo sirve para identificar que partidas son revisadas por los vistos buenos de almancenes y activos fijos';

/***********************************F-SCP-RAC-WF-0-25/03/2014****************************************/


/***********************************I-SCP-RAC-WF-0-15/04/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN plantilla_mensaje_asunto VARCHAR(500);

ALTER TABLE wf.ttipo_estado
  ALTER COLUMN plantilla_mensaje_asunto SET DEFAULT 'Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})';

--------------- SQL ---------------

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ALTER COLUMN plantilla_mensaje SET DEFAULT '<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>'::character varying;

COMMENT ON COLUMN wf.ttipo_estado.plantilla_mensaje
IS 'rirve para personalizar la el correo que me manda al cambiar el estado, los valor de la plantilla se recuperar de la table referenciada en tipo_proceso';


/***********************************F-SCP-RAC-WF-0-15/04/2014****************************************/



/***********************************I-SCP-RAC-WF-0-29/04/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_proceso
  ADD COLUMN codigo_llave VARCHAR(200);

COMMENT ON COLUMN wf.ttipo_proceso.codigo_llave
IS 'Este codigo permite identificar en tiempode ejecucion la anturaleza del proceso, pro ejemeplo, existe para procesos de Obligacion de pago, esto nos permite identificar que son obligaciones de pago y no ingresos a almacenes';


/***********************************F-SCP-RAC-WF-0-29/04/2014****************************************/

/*******************************************I-SCP-JRR-WF-0-07/05/2014*************************************/

CREATE TABLE wf.ttabla (
  id_tabla SERIAL NOT NULL,
  id_tipo_proceso INTEGER NOT NULL, 
  bd_nombre_tabla VARCHAR(100) NOT NULL,
  bd_codigo_tabla VARCHAR(25) NOT NULL, 
  bd_descripcion TEXT, 
  bd_scripts_extras TEXT, 
  vista_tipo VARCHAR(30) NOT NULL, 
  vista_posicion VARCHAR(50), 
  vista_id_tabla_maestro INTEGER,
  vista_campo_ordenacion VARCHAR(100),
  vista_dir_ordenacion VARCHAR(4),  
  vista_campo_maestro VARCHAR(50),
  vista_scripts_extras	TEXT,
  menu_nombre VARCHAR(100), 
  menu_icono VARCHAR(100), 
  menu_codigo VARCHAR(25),
  ejecutado VARCHAR(2) DEFAULT 'no' NOT NULL,
  script_ejecutado VARCHAR(2) DEFAULT 'no' NOT NULL,
  PRIMARY KEY(id_tabla)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN wf.ttabla.vista_id_tabla_maestro
IS 'la tabla qu es maestro en caso de que sea detalle';

COMMENT ON COLUMN wf.ttabla.vista_campo_maestro
IS 'el campo del maestro en caso de ser detalle';

COMMENT ON COLUMN wf.ttabla.vista_scripts_extras
IS 'En este campo debe registrarse un json con los metodos que se desean sobrescribir de la clase';

COMMENT ON COLUMN wf.ttabla.bd_scripts_extras
IS 'En este campo se puede definir llaves foraneas, indices, triggers, funciones y otros que puedan ser necesarios para la tabla';


CREATE TABLE wf.ttipo_columna (
  id_tipo_columna SERIAL NOT NULL,
  id_tabla INTEGER NOT NULL, 
  bd_nombre_columna VARCHAR(100) NOT NULL,
  bd_tipo_columna VARCHAR(100) NOT NULL,
  bd_descripcion_columna TEXT,
  bd_tamano_columna VARCHAR(5),  
  bd_campos_adicionales TEXT, 
  bd_joins_adicionales TEXT,
  bd_formula_calculo TEXT, 
  grid_sobreescribe_filtro TEXT,  
  grid_campos_adicionales TEXT,
  form_tipo_columna VARCHAR(100) NOT NULL,
  form_label VARCHAR(100), 
  form_es_combo VARCHAR(2), 
  form_combo_rec VARCHAR(50), 
  form_sobreescribe_config TEXT, 
  ejecutado VARCHAR(2) DEFAULT 'no' NOT NULL,
  PRIMARY KEY(id_tipo_columna)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

COMMENT ON COLUMN wf.ttipo_columna.bd_campos_adicionales
IS 'el formato es : "nombre_columna nombre_modelo tipo" separados por comas por cada campo adicional';

COMMENT ON COLUMN wf.ttipo_columna.grid_campos_adicionales
IS 'el formato es : "nombre tipo formato" separados por comas por cada campo adicional';

COMMENT ON COLUMN wf.ttipo_columna.form_sobreescribe_config
IS 'sobreescribir el config de una columna en la vista, debe ser un objeto de tipo json {}';

COMMENT ON COLUMN wf.ttipo_columna.grid_sobreescribe_filtro
IS 'sobreescribir el filtro de una columna en la vista, debe ser un objeto de tipo json {}';


CREATE TABLE wf.tcolumna_estado (
  id_columna_estado SERIAL NOT NULL,
  id_tipo_columna INTEGER NOT NULL,
  id_tipo_estado INTEGER NOT NULL, 
  momento VARCHAR(100) NOT NULL,   
  PRIMARY KEY(id_columna_estado)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/*******************************************F-SCP-JRR-WF-0-07/05/2014*************************************/



/*******************************************I-SCP-RAC-WF-0-15/05/2014*************************************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN cargo_depto VARCHAR(200)[];

COMMENT ON COLUMN wf.ttipo_estado.cargo_depto
IS 'este campo recibe los cargo del depto que reciben la alerta, si no tiene valores se les manda  todos';


/*******************************************F-SCP-RAC-WF-0-15/05/2014*************************************/
 

/***********************************I-SCP-RCM-WF-0-05/05/2014****************************************/
CREATE TABLE wf.ttipo_componente (
  id_tipo_componente SERIAL,
  codigo VARCHAR(50) UNIQUE,
  nombre VARCHAR(100),
  CONSTRAINT pk_ttipo_componente__id_tipo_componente PRIMARY KEY(id_tipo_componente)
) INHERITS (pxp.tbase);

COMMENT ON TABLE wf.ttipo_componente
IS 'Almacena los tipos de componente disponibles para la generación de formularios dinámicos';

COMMENT ON COLUMN wf.ttipo_componente.id_tipo_componente
IS 'Identificador de la tabla';

COMMENT ON COLUMN wf.ttipo_componente.codigo
IS 'Codigo unico que representa al componente';

COMMENT ON COLUMN wf.ttipo_componente.nombre
IS 'Nombre descriptivo del componente';

CREATE TABLE wf.ttipo_propiedad (
  id_tipo_propiedad SERIAL,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  tipo_dato VARCHAR(30) NOT NULL,
  CONSTRAINT pk_tipo_propiedad_id_tipo_propiedad PRIMARY KEY(id_tipo_propiedad)
) INHERITS (pxp.tbase);

COMMENT ON TABLE wf.ttipo_propiedad
IS 'Almacena los tipos de propiedad generales que podrán ser relacionados a los tipos de componente';

COMMENT ON COLUMN wf.ttipo_propiedad.id_tipo_propiedad
IS 'Identificador de la tabla';

COMMENT ON COLUMN wf.ttipo_propiedad.codigo
IS 'Codigo unico que representa al tipo de propiedad';

COMMENT ON COLUMN wf.ttipo_propiedad.nombre
IS 'Nombre descriptivo del tipo de propiedad';

COMMENT ON COLUMN wf.ttipo_propiedad.tipo_dato
IS 'Tipo de dato por defecto para el valor del tipo de propiedad';

CREATE TABLE wf.ttipo_comp_tipo_prop (
  id_tipo_comp_tipo_prop SERIAL,
  id_tipo_propiedad INTEGER NOT NULL,
  id_tipo_componente INTEGER NOT NULL,
  obligatorio VARCHAR(2) NOT NULL,
  tipo_dato VARCHAR(40) NOT NULL,
  CONSTRAINT pk_tipo_comp_tipo_prop__id_tipo_comp_tipo_prop PRIMARY KEY(id_tipo_comp_tipo_prop)
) INHERITS (pxp.tbase)
;

COMMENT ON TABLE wf.ttipo_comp_tipo_prop
IS 'Almacena los tipos de propiedad para cada tipo de componente';

COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.id_tipo_comp_tipo_prop
IS 'Identificador de la tabla';

COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.id_tipo_propiedad
IS 'Llave foranea de la tabla wf.ttipo_propiedad';

COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.id_tipo_componente
IS 'Llave foranea de la tabla wf.ttipo_componente';

COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.obligatorio
IS 'Define si el registro del valor del tipo de propiedad sera obligatorio';

COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.tipo_dato
IS 'Tipo de dato para el valor del tipo de propiedad';

/***********************************F-SCP-RCM-WF-0-05/05/2014****************************************/


/***********************************I-SCP-JRR-WF-0-23/05/2014****************************************/
ALTER TABLE wf.ttabla
  ADD COLUMN vista_estados_new VARCHAR(100)[];
  
ALTER TABLE wf.ttabla
  ADD COLUMN vista_estados_delete VARCHAR(100)[];

/***********************************F-SCP-JRR-WF-0-23/05/2014****************************************/

/***********************************I-SCP-RCM-WF-0-22/05/2014****************************************/
CREATE TABLE wf.tcatalogo (
  id_catalogo SERIAL,
  id_proceso_macro integer not null,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  CONSTRAINT pk_tcatalogo__id_catalogo PRIMARY KEY(id_catalogo)
) INHERITS (pxp.tbase);

COMMENT ON TABLE wf.tcatalogo
IS 'Los catálogos se refieren a dominios de datos limitados, que podrán ser utilizados por los formularios
dinámicos del workflow por proceso macro';

COMMENT ON COLUMN wf.tcatalogo.id_catalogo
IS 'Identificador de la cabecera de Catalogos de WF';

COMMENT ON COLUMN wf.tcatalogo.id_proceso_macro
IS 'Llave foránea de la tabla wf.tproceso_macro';

COMMENT ON COLUMN wf.tcatalogo.codigo
IS 'Código único (llave alterna) para nombrar al Catálogo';

COMMENT ON COLUMN wf.tcatalogo.nombre
IS 'Nombre del catálogo';

CREATE TABLE wf.tcatalogo_valor (
  id_catalogo_valor SERIAL,
  fk_id_catalogo_valor integer,
  id_catalogo integer not null,
  codigo VARCHAR(50) NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  orden smallint not null,
  CONSTRAINT pk_tcatalogo_valor__id_catalogo_valor PRIMARY KEY(id_catalogo_valor)
) INHERITS (pxp.tbase);

COMMENT ON TABLE wf.tcatalogo_valor
IS 'Valores definidos en el catálogo (o dominio) creado';

COMMENT ON COLUMN wf.tcatalogo_valor.id_catalogo_valor
IS 'Identificador de la tabla';

COMMENT ON COLUMN wf.tcatalogo_valor.id_catalogo_valor
IS 'Relación recursiva para registro de datos jerárquicos (árbol)';

COMMENT ON COLUMN wf.tcatalogo_valor.id_catalogo
IS 'Llave foránea del maestro de la tabla wf.tcatalogo';

COMMENT ON COLUMN wf.tcatalogo_valor.codigo
IS 'Código único (llave alterna) de los valores del catálogo';

COMMENT ON COLUMN wf.tcatalogo_valor.nombre
IS 'Nombre de los valores del catálogo';

COMMENT ON COLUMN wf.tcatalogo_valor.orden
IS 'Orden de despliegue de los valores del catálogo';
/***********************************F-SCP-RCM-WF-0-22/05/2014****************************************/


/***********************************I-SCP-RCM-WF-0-09/06/2014****************************************/



CREATE TABLE wf.ttipo_proceso_origen (
  id_tipo_proceso_origin SERIAL, 
  id_tipo_estado INTEGER NOT NULL, 
  id_tipo_proceso INTEGER NOT NULL, 
  tipo_disparo VARCHAR NOT NULL, 
  funcion_validacion_wf TEXT, 
  id_proceso_macro INTEGER, 
  CONSTRAINT ttipo_proceso_origen_pkey PRIMARY KEY(id_tipo_proceso_origin)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

ALTER TABLE wf.ttipo_proceso_origen
  ALTER COLUMN id_tipo_proceso_origin SET STATISTICS 0;

ALTER TABLE wf.ttipo_proceso_origen
  ALTER COLUMN id_tipo_estado SET STATISTICS 0;

ALTER TABLE wf.ttipo_proceso_origen
  ALTER COLUMN id_tipo_proceso SET STATISTICS 0;

ALTER TABLE wf.ttipo_proceso_origen
  ALTER COLUMN funcion_validacion_wf SET STATISTICS 0;

ALTER TABLE wf.ttipo_proceso_origen
  ALTER COLUMN id_proceso_macro SET STATISTICS 0;

COMMENT ON COLUMN wf.ttipo_proceso_origen.tipo_disparo
IS 'obligatorio -> define si el proceso se dispara siempre, opcional -> (el usuario decide), opcional_automatico (se revisa la funcion de validacion), bandeja -> el proceso queda pendiente en una bandeja de espera';

COMMENT ON COLUMN wf.ttipo_proceso_origen.funcion_validacion_wf
IS 'tuncion de validacion o regla a ser evaluada';

COMMENT ON COLUMN wf.ttipo_proceso_origen.id_proceso_macro
IS 'ee utiliza para filtrar los tipo_estado disaradores que se muestran';



/***********************************F-SCP-RCM-WF-0-09/06/2014****************************************/



/***********************************I-SCP-JRR-WF-0-20/06/2014****************************************/

ALTER TABLE wf.ttabla
  ALTER COLUMN vista_campo_maestro TYPE VARCHAR(75);

/***********************************F-SCP-JRR-WF-0-20/06/2014****************************************/


/***********************************I-SCP-RAC-WF-0-24/06/2014****************************************/

ALTER TABLE wf.tfuncionario_tipo_estado
  ADD COLUMN regla VARCHAR;


/***********************************F-SCP-RAC-WF-0-24/06/2014****************************************/


/***********************************I-SCP-RAC-WF-1-24/06/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_documento_estado
  ADD COLUMN regla VARCHAR;
  
/***********************************F-SCP-RAC-WF-1-24/06/2014****************************************/
  
  
  
/***********************************I-SCP-RAC-WF-1-04/08/2014****************************************/
 
ALTER TABLE wf.ttipo_estado
  ADD COLUMN mobile VARCHAR(10) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN wf.ttipo_estado.mobile
IS 'si o no, se muestra en el la interface de vobowf,  solo es conveniente las interfaces que solo necesitas ir adelante o atras';
  
/***********************************F-SCP-RAC-WF-1-04/08/2014****************************************/
  
 
 
  
/***********************************I-SCP-RAC-WF-2-04/08/2014****************************************/
 --------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN funcion_inicial VARCHAR(150); 
  
COMMENT ON COLUMN wf.ttipo_estado.funcion_inicial
IS 'esta funcion correo cuando  el flujo continua sobre este estado';  
  
  --------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN funcion_regreso VARCHAR(200);

COMMENT ON COLUMN wf.ttipo_estado.funcion_regreso
IS 'esta funcion correo cuando  el flujo retrocede hacia este estado';

/***********************************F-SCP-RAC-WF-1-04/08/2014****************************************/


/***********************************I-SCP-RAC-WF-1-12/08/2014****************************************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN acceso_directo_alerta VARCHAR;

COMMENT ON COLUMN wf.ttipo_estado.acceso_directo_alerta
IS 'direccion de la interface que se manda dentro la alerta de este estado';

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN nombre_clase_alerta VARCHAR(40);

COMMENT ON COLUMN wf.ttipo_estado.nombre_clase_alerta
IS 'nombre de la clase que se ejecuta en el acceso directo de la clase';

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN parametros_ad VARCHAR DEFAULT '{}' NOT NULL;

COMMENT ON COLUMN wf.ttipo_estado.parametros_ad
IS 'parametros en formato JSON que se mandan al acceso directo';

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN tipo_noti VARCHAR(40) DEFAULT 'notificacion' NOT NULL;

COMMENT ON COLUMN wf.ttipo_estado.tipo_noti
IS 'tipo de alerta';

--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN titulo_alerta VARCHAR(50);

ALTER TABLE wf.ttipo_estado
  ALTER COLUMN titulo_alerta SET DEFAULT '';

COMMENT ON COLUMN wf.ttipo_estado.titulo_alerta
IS 'Titulo que se muestra en la alerta';

/***********************************F-SCP-RAC-WF-1-12/08/2014****************************************/



/***********************************I-SCP-JRR-WF-0-12/08/2014****************************************/

ALTER TABLE wf.tproceso_macro
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttipo_proceso
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttabla
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttipo_estado
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttipo_columna
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttipo_documento
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttipo_documento_estado
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.tcolumna_estado
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.testructura_estado
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.tlabores_tipo_proceso
  ADD COLUMN modificado INTEGER;


ALTER TABLE wf.ttipo_proceso_origen
  ADD COLUMN modificado INTEGER;
  
ALTER TABLE wf.tcolumna_estado
  ADD COLUMN regla VARCHAR;
  
/***********************************F-SCP-JRR-WF-0-12/08/2014****************************************/





/***********************************I-SCP-RAC-WF-0-14/08/2014****************************************/
--------------- SQL ---------------

ALTER TABLE wf.ttipo_proceso
  ADD COLUMN funcion_disparo_wf VARCHAR(100);

COMMENT ON COLUMN wf.ttipo_proceso.funcion_disparo_wf
IS 'Esta funcion sirve para colocar logija adicional depues de un disparo de proceso, ejemplo al dispara la obligacion de pago es necesario copiar el detalle de la cotizacion y copiarlo al detallle de la obligacion';

/***********************************F-SCP-RAC-WF-0-14/08/2014****************************************/

/***********************************I-SCP-RAC-WF-0-20/08/2014****************************************/
CREATE TABLE wf.tplantilla_correo (		
id_plantilla_correo	serial not null,	
id_tipo_estado	integer	not null,
codigo_plantilla	varchar(50)	not null,
plantilla	text,	
correos	varchar[] not null,
documentos	varchar[],
regla	text,
CONSTRAINT tplantilla_correo_pkey PRIMARY KEY(id_plantilla_correo)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-RAC-WF-0-20/08/2014****************************************/

/***********************************I-SCP-JRR-WF-0-29/08/2014****************************************/

ALTER TABLE wf.tfuncionario_tipo_estado
  ADD COLUMN modificado INTEGER;

/***********************************F-SCP-JRR-WF-0-29/08/2014****************************************/

/***********************************I-SCP-JRR-WF-1-29/08/2014****************************************/

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN modificado INTEGER;

/***********************************F-SCP-JRR-WF-1-29/08/2014****************************************/

/***********************************I-SCP-JRR-WF-1-03/09/2014****************************************/

CREATE TABLE wf.ttipo_estado_rol (
  id_tipo_estado_rol SERIAL NOT NULL,
  id_tipo_estado INTEGER NOT NULL,
  id_rol INTEGER NOT NULL,      
  PRIMARY KEY(id_tipo_estado_rol)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

/***********************************F-SCP-JRR-WF-1-03/09/2014****************************************/

/***********************************I-SCP-RAC-WF-1-23/09/2014****************************************/


--------------- SQL ---------------

ALTER TABLE wf.tproceso_wf
  ADD COLUMN revisado_asistente VARCHAR(4);

ALTER TABLE wf.tproceso_wf
  ALTER COLUMN revisado_asistente SET DEFAULT 'no';
  

--------------- SQL ---------------

ALTER TABLE wf.tproceso_wf
  ADD COLUMN prioridad INTEGER DEFAULT 2 NOT NULL;

COMMENT ON COLUMN wf.tproceso_wf.prioridad
IS 'los numeros mas bajos representan prioridades mayores';

CREATE TABLE wf.tobs (
  id_obs SERIAL, 
  titulo VARCHAR NOT NULL, 
  descripcion VARCHAR NOT NULL, 
  id_funcionario_resp INTEGER, 
  estado VARCHAR(20) DEFAULT 'abierto'::character varying, 
  fecha_fin TIMESTAMP(6) WITHOUT TIME ZONE, 
  desc_fin VARCHAR,
  CONSTRAINT tobs_pkey PRIMARY KEY(id_obs)
) INHERITS (pxp.tbase)
WITHOUT OIDS;

--------------- SQL ---------------

ALTER TABLE wf.tobs
  ADD COLUMN num_tramite VARCHAR(500) NOT NULL;
  
  --------------- SQL ---------------

ALTER TABLE wf.tobs
  ADD COLUMN id_estado_wf INTEGER NOT NULL;
/***********************************F-SCP-RAC-WF-1-23/09/2014****************************************/


/***********************************I-SCP-RAC-WF-1-25/11/2014****************************************/
--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN admite_obs VARCHAR(30) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN wf.ttipo_estado.admite_obs
IS 'no o si, define si permite registrar observaciones en este estado';

/***********************************F-SCP-RAC-WF-1-25/11/2014****************************************/

/*****************************I-SCP-RAC-WF-0-24/11/2014*************/
--------------- SQL ---------------

ALTER TABLE wf.tobs
  ADD COLUMN id_alarma INTEGER;

COMMENT ON COLUMN wf.tobs.id_alarma
IS 'referencia a la alarma creada por la observacion';

/*****************************F-SCP-RAC-WF-0-24/11/2014*************/


/*****************************I-SCP-RAC-WF-0-04/12/2014*************/

--------------- SQL ---------------

CREATE TABLE wf.tdocumento_historico_wf (
  id_documento_historico_wf SERIAL,
  id_documento INTEGER,
  version INTEGER,
  PRIMARY KEY(id_documento_historico_wf)
) INHERITS (pxp.tbase)
;

ALTER TABLE wf.tdocumento_historico_wf
  OWNER TO postgres;
  
 --------------- SQL ---------------

ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN vigente VARCHAR(4) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN wf.tdocumento_historico_wf.vigente
IS 'si o no, lo no vigentes son versiones anteriores';
  
--------------- SQL ---------------

ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN url_old VARCHAR;
  
  --------------- SQL ---------------

ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN url VARCHAR;
  
  --------------- SQL ---------------

ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN extension VARCHAR(5);
  

 
/*****************************F-SCP-RAC-WF-0-04/12/2014*************/


/*****************************I-SCP-RAC-WF-0-09/01/2015*************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_documento
  ADD COLUMN solo_lectura VARCHAR(4) DEFAULT 'no' NOT NULL;


COMMENT ON COLUMN wf.ttipo_documento.solo_lectura
IS 'los campos  de solo lectura se copia por base de datos,  y no deben ser cambiados por los usuarios';


ALTER TABLE wf.tdocumento_wf
  ADD COLUMN id_proceso_wf_ori INTEGER;

COMMENT ON COLUMN wf.tdocumento_wf.id_proceso_wf_ori
IS 'para alguno documentos copiados, como los contratos en OP, toma el pvalor del proceso wf original para que nos sirva para direccionar a los otros documentos del tramite original';

--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN nro_tramite_ori VARCHAR;

COMMENT ON COLUMN wf.tdocumento_wf.nro_tramite_ori
IS 'por rendimiento copiamos el nro_tramite';


--------------- SQL ---------------

ALTER TABLE wf.tdocumento_wf
  ADD COLUMN id_documento_wf_ori INTEGER;
/*****************************F-SCP-RAC-WF-0-09/01/2015*************/


/*****************************I-SCP-JRR-WF-0-15/01/2015*************/

ALTER TABLE wf.ttipo_columna
  ADD COLUMN bd_prioridad INTEGER;
  
ALTER TABLE wf.ttipo_columna
  ADD COLUMN form_grupo INTEGER;

/*****************************F-SCP-JRR-WF-0-15/01/2015*************/


/*****************************I-SCP-JRR-WF-0-29/01/2015*************/


ALTER TABLE wf.tdocumento_wf
  ADD COLUMN accion_pendiente VARCHAR(15);
  
ALTER TABLE wf.tdocumento_wf
  ADD COLUMN fecha_firma VARCHAR(25);
  
ALTER TABLE wf.tdocumento_wf
  ADD COLUMN usuario_firma VARCHAR(50);
  
ALTER TABLE wf.tdocumento_wf
  ADD COLUMN datos_firma JSON;
  
ALTER TABLE wf.tdocumento_wf
  ADD COLUMN hash_firma varchar(50);
  
ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN fecha_firma VARCHAR(25);
  
ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN usuario_firma VARCHAR(50);
  
ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN datos_firma JSON;
  
ALTER TABLE wf.tdocumento_historico_wf
  ADD COLUMN hash_firma varchar(50);

/*****************************F-SCP-JRR-WF-0-29/01/2015*************/

/*****************************I-SCP-RCM-WF-0-08/02/2015*************/

ALTER TABLE wf.ttipo_columna
  ADD COLUMN bd_campos_subconsulta TEXT;

/*****************************F-SCP-RCM-WF-0-08/02/2015*************/

/*****************************I-SCP-JRR-WF-0-24/02/2015*************/
ALTER TABLE wf.tplantilla_correo
  ADD COLUMN asunto VARCHAR(255);

/*****************************F-SCP-JRR-WF-0-24/02/2015*************/

/*****************************I-SCP-JRR-WF-0-25/02/2015*************/
ALTER TABLE wf.ttipo_estado_rol
  ADD COLUMN modificado INTEGER;

/*****************************F-SCP-JRR-WF-0-25/02/2015*************/


/*****************************I-SCP-RAC-WF-0-20/03/2015*************/

--------------- SQL ---------------

CREATE TABLE wf.tcategoria_documento (
  id_categoria_documento INTEGER NOT NULL,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  nombre VARCHAR,
  PRIMARY KEY(id_categoria_documento)
) INHERITS (pxp.tbase)
;

ALTER TABLE wf.tcategoria_documento
  OWNER TO postgres;

COMMENT ON COLUMN wf.tcategoria_documento.codigo
IS 'identifica el documento y se almacenes en el array  categoria_documento en la interface de tipo_documento_wf';


--------------- SQL ---------------

CREATE SEQUENCE wf.tcategoria_documento_id_categoria_documento_seq
MAXVALUE 2147483647;

ALTER TABLE wf.tcategoria_documento
  ALTER COLUMN id_categoria_documento TYPE INTEGER;

ALTER TABLE wf.tcategoria_documento
  ALTER COLUMN id_categoria_documento SET DEFAULT nextval('wf.tcategoria_documento_id_categoria_documento_seq'::text);

--------------- SQL ---------------

ALTER TABLE wf.ttipo_documento
  ADD COLUMN categoria_documento VARCHAR(60)[];

COMMENT ON COLUMN wf.ttipo_documento.categoria_documento
IS 'este campo sirve para idetoficar a que caterorias pertenece un tipo de documento';


--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN etapa VARCHAR(150);

COMMENT ON COLUMN wf.ttipo_estado.etapa
IS 'Este es un texto que sirve hacer menos abstrato el nombre de los estados,  por lo general barrios estado pueden pertener a una misma etapa, este cmapo tiene que aprece en el diagrama gantt y en grilla';

/*****************************F-SCP-RAC-WF-0-20/03/2015*************/


/*****************************I-SCP-RAC-WF-0-26/03/2015*************/

--------------- SQL ---------------

ALTER TABLE wf.ttipo_documento
  ADD COLUMN orden NUMERIC DEFAULT 1 NOT NULL;

COMMENT ON COLUMN wf.ttipo_documento.orden
IS 'numero para ordenar los documentos por importancion los mas importantes necesitan numeros mas bajos';

/*****************************F-SCP-RAC-WF-0-26/03/2015*************/

/*****************************I-SCP-JRR-WF-0-27/03/2015*************/

ALTER TABLE wf.tcategoria_documento
  ADD COLUMN modificado INTEGER;

/*****************************F-SCP-JRR-WF-0-27/03/2015*************/


/*****************************I-SCP-JRR-WF-0-06/04/2015*************/
ALTER TABLE wf.ttipo_documento
  ALTER COLUMN orden TYPE NUMERIC(4,2);

/*****************************F-SCP-JRR-WF-0-06/04/2015*************/


/*****************************I-SCP-JRR-WF-0-08/04/2015*************/

--------------- SQL ---------------

ALTER TABLE wf.testructura_estado
  ADD COLUMN bucle VARCHAR(2) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN wf.testructura_estado.bucle
IS 'identifica si la arista ocaciona un bucle, este campo se registra de manera automatica el momento de insetar la arista';


/*****************************F-SCP-JRR-WF-0-08/04/2015*************/


/*****************************I-SCP-JRR-WF-0-10/04/2015*************/


--------------- SQL ---------------

ALTER TABLE wf.ttipo_estado
  ADD COLUMN grupo_doc VARCHAR;

COMMENT ON COLUMN wf.ttipo_estado.grupo_doc
IS 'aca se almacena la configuracion gruposBarraTareas  que va en la interface de documentos para definir que categorias pueden verse desde esta interface.';

/*****************************F-SCP-JRR-WF-0-10/04/2015*************/



/*****************************I-SCP-RCM-WF-0-16/03/2015*************/
ALTER TABLE wf.ttipo_documento
  ADD COLUMN nombre_vista varchar(70);

ALTER TABLE wf.ttipo_documento
  ADD COLUMN nombre_archivo_plantilla text;  
  
ALTER TABLE wf.ttipo_documento
  ADD COLUMN esquema_vista VARCHAR(10);  
/*****************************F-SCP-RCM-WF-0-16/03/2015*************/


/*****************************I-SCP-RCM-WF-0-15/04/2015*************/
ALTER TABLE wf.tdocumento_wf
  ADD COLUMN demanda VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN wf.tdocumento_wf.demanda
IS 'documento insertado por demanda si o no, por defecto es no';

/*****************************F-SCP-RCM-WF-0-15/04/2015*************/



/*****************************I-SCP-RCM-WF-0-16/04/2015*************/


--------------- SQL ---------------

ALTER TABLE wf.tproceso_macro
  ADD COLUMN grupo_doc VARCHAR;

COMMENT ON COLUMN wf.tproceso_macro.grupo_doc
IS 'aca se almacena la configuracion gruposBarraTareas  que va en la interface de documentos para definir que categorias pueden verse desde esta interface.';

/*****************************F-SCP-RCM-WF-0-16/04/2015*************/



/*****************************I-SCP-RCM-WF-0-30/04/2015*************/


--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN requiere_acuse VARCHAR(4) DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN wf.tplantilla_correo.requiere_acuse
IS 'si l aplantilla requiere acuse el correo se manda con un link donde la persona que recibe tendra que confirma su aceptación';


--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN url_acuse VARCHAR;

COMMENT ON COLUMN wf.tplantilla_correo.url_acuse
IS 'indeitifca la URL que se coloca en el link del correo para que la persona que recibe acepte,   puede ser un servidor dintinto, en un dmz';

--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN mensaje_acuse VARCHAR;

COMMENT ON COLUMN wf.tplantilla_correo.mensaje_acuse
IS 'depues de precinar el link del acuse se muestra este mensaje,';


--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN mensaje_link_acuse VARCHAR;

COMMENT ON COLUMN wf.tplantilla_correo.mensaje_link_acuse
IS 'mensjae que a antes del link de acuse de recibo';

--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN mandar_automaticamente VARCHAR(5) DEFAULT 'si' NOT NULL;

COMMENT ON COLUMN wf.tplantilla_correo.mandar_automaticamente
IS 'se manda el correo de manera automatica al llegar a este estado o espera la confirmación para enviar';
/*****************************F-SCP-RCM-WF-0-30/04/2015*************/

/*****************************I-SCP-GSS-WF-0-05/05/2015*************/

ALTER TABLE wf.testado_wf
  ADD COLUMN verifica_documento VARCHAR(2);

ALTER TABLE wf.testado_wf
  ALTER COLUMN verifica_documento SET DEFAULT 'si';
  
/*****************************F-SCP-GSS-WF-0-05/05/2015*************/



/*****************************I-SCP-RAC-WF-0-07/05/2015*************/

--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN funcion_acuse_recibo VARCHAR;

COMMENT ON COLUMN wf.tplantilla_correo.funcion_acuse_recibo
IS 'esta funcion se ejecuta cuando se recibe el acuse de recibo';

--------------- SQL ---------------

ALTER TABLE wf.tplantilla_correo
  ADD COLUMN funcion_creacion_correo VARCHAR;

COMMENT ON COLUMN wf.tplantilla_correo.funcion_creacion_correo
IS 'esta funcion se ejecuta despude se insertar la alerta';

/*****************************F-SCP-RAC-WF-0-07/05/2015*************/



/*****************************I-SCP-RAC-WF-0-25/05/2015*************/

--------------- SQL ---------------

ALTER TABLE wf.tproceso_wf
  ADD COLUMN id_tipo_estado_wfs INTEGER[];

COMMENT ON COLUMN wf.tproceso_wf.id_tipo_estado_wfs
IS 'almacenes el historico de tipo de estado por lo que va pansado el flujo, se utiliza para saber cuanto veces paso por un mismo estado';

/*****************************F-SCP-RAC-WF-0-25/05/2015*************/

/*****************************I-SCP-JRR-WF-0-03/06/2015*************/

ALTER TABLE wf.ttipo_estado
  ADD COLUMN id_tipo_estado_anterior INTEGER;

/*****************************F-SCP-JRR-WF-0-03/06/2015*************/

/*****************************I-SCP-JRR-WF-0-20/02/2016*************/

ALTER TABLE wf.ttipo_columna
  ADD COLUMN transacciones_permiso VARCHAR(250);

/*****************************F-SCP-JRR-WF-0-20/02/2016*************/



/****************************I-SCP-RCM-WF-0-24/03/2016*************/
ALTER TABLE wf.ttipo_estado
  ADD COLUMN icono VARCHAR(50);

COMMENT ON COLUMN wf.ttipo_estado.icono
IS 'Icono para representar al estado';
/****************************F-SCP-RCM-WF-0-24/03/2016*************/

/****************************I-SCP-JRR-WF-0-24/05/2016*************/
ALTER TABLE wf.tobs
  ALTER COLUMN id_funcionario_resp SET NOT NULL;
/****************************F-SCP-JRR-WF-0-24/05/2016*************/

/*****************************I-SCP-JRR-WF-0-30/08/2016*************/

ALTER TABLE wf.ttipo_columna
  ADD COLUMN orden INTEGER;

/*****************************F-SCP-JRR-WF-0-30/08/2016*************/

/*****************************I-SCP-AKFG-WF-0-21/11/2019*************/


--funciones

COMMENT ON FUNCTION wf.f_get_codigo_estado(p_id_tipo_estado integer)
IS 'funcion que recupera el codigo de la tabla wf.ttipo_estado apartir del id_tipo_estado';
COMMENT ON FUNCTION wf.f_gant_wf(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'funcion que consulta el diagrama gant del WF';
COMMENT ON FUNCTION wf.f_gant_wf_recursiva(p_id_proceso_wf integer, p_id_estado_wf integer, p_id_usuario integer, p_id_padre integer, p_id_anterior integer)
IS 'funcion que responde a la solicitud de la funcion wf.f_gant_wf que consulta el diagrama gant';
COMMENT ON FUNCTION wf.f_gant_wf_recursiva_dinamico(p_id_proceso_wf integer, p_id_estado_wf integer, p_id_usuario integer, p_id_padre integer, p_id_anterior integer)
IS 'funcion que responde a la solicitud de la funcion wf.f_gant_wf que consulta el diagrama gant;';
COMMENT ON FUNCTION wf.f_funcionario_wf_sel(p_id_usuario integer, p_id_tipo_estado integer, p_fecha date, p_id_estado_wf integer, p_count boolean, p_limit integer, p_start integer, p_filtro varchar, p_id_depto_wf integer)
IS 'funcion que lista a los funcionarios que correponden al estado del work flow		';
COMMENT ON FUNCTION wf.f_evaluar_regla_wf(p_id_usuario integer, p_id_proceso_wf integer, p_plantilla text, p_id_tipo_estado_actual integer, p_id_estado_anterior integer, p_obs text)
IS 'funcion que procesa la regla de la arista de una plantilla,  regresa como resultado FALSE or TRUE';
COMMENT ON FUNCTION wf.f_encontrar_proceso_wf(p_id_tipo_proceso integer, p_id_estado_wf integer, p_tipo_busqueda varchar)
IS 'Encuentra recursivamente el proceso_wf correpondiente con el tipo_proceso que entra como parametro,
a partir del p_id_estado_wf introducido	';
COMMENT ON FUNCTION wf.f_depto_wf_sel(p_id_usuario integer, p_id_tipo_estado integer, p_fecha date, p_id_estado_wf integer, p_count boolean, p_limit integer, p_start integer, p_filtro varchar)
IS 'funcion que lista los departamentos que correponden al estado del work flow';
COMMENT ON FUNCTION wf.f_cancela_proceso_wf(p_codigo_anulado varchar, p_id_proceso_wf integer, p_id_usuario integer, p_obs text)
IS 'Anula procesos de WF, cambia al estado solicitado y verifica
si los procesos disparados si existen esten anualdos';
COMMENT ON FUNCTION wf.f_buscar_estado_procesos_disparados(p_id_proceso_wf integer, p_id_estado_wf_act integer, out ps_id_proceso_wf integer [], out ps_id_estado_actual integer [], out ps_codigo_estado varchar [], out ps_nombre_proceso varchar [])
IS 'funcion que busca recursivamente los estados indicados dentro de los procesos disparados';
COMMENT ON FUNCTION wf.f_get_numero_tramite(p_codigo_proceso varchar, p_id_gestion integer, p_id_usuario integer)
IS 'Devuelve un nuemero de correlativo a partir del Codigo, Numero siguiente y Gestion';
COMMENT ON FUNCTION wf.f_import_ttipo_proceso(p_accion varchar, p_codigo varchar, p_codigo_tipo_estado varchar, p_codigo_tipo_proceso_estado varchar, p_codigo_pm varchar, p_nombre varchar, p_tabla varchar, p_columna_llave varchar, p_inicio varchar, p_funcion_validacion varchar, p_tipo_disparo varchar, p_descripcion varchar, p_codigo_llave varchar, p_funcion_disparo_wf varchar)
IS 'funcion que actuializa, inserta o inactiva un proceso de la tabla wf.ttipo_proceso';
COMMENT ON FUNCTION wf.f_import_ttipo_estado_rol(p_accion varchar, p_codigo_tipo_proceso varchar, p_codigo_tipo_estado varchar, p_codigo_rol varchar)
IS 'funcion que actuializa, inserta o inactiva un estado_rol de la tabla wf.ttipo_estado_rol';
COMMENT ON FUNCTION wf.f_import_ttipo_estado(p_accion varchar, p_codigo varchar, p_codigo_tipo_proceso varchar, p_nombre_estado varchar, p_inicio varchar, p_disparador varchar, p_fin varchar, p_tipo_asignacion varchar, p_nombre_func_list varchar, p_depto_asignacion varchar, p_nombre_depto_func_list varchar, p_obs text, p_alerta varchar, p_pedir_obs varchar, p_descripcion varchar, p_plantilla_mensaje varchar, p_plantilla_mensaje_asunto varchar, p_cargo_depto text, p_mobile varchar, p_funcion_inicial varchar, p_funcion_regreso varchar, p_acceso_directo_alerta varchar, p_nombre_clase_alerta varchar, p_tipo_noti varchar, p_titulo_alerta varchar, p_parametros_ad varchar, p_codigo_estado_anterior varchar)
IS 'funcion que actuializa, inserta o inactiva un tipo de estado de la tabla wf.ttipo_estado';
COMMENT ON FUNCTION wf.f_import_ttipo_documento_estado(p_accion varchar, p_codigo_tipo_documento varchar, p_codigo_tipo_proceso varchar, p_codigo_tipo_estado varchar, p_codigo_tipo_proceso_externo varchar, p_momento varchar, p_tipo_busqueda varchar, p_regla varchar)
IS 'funcion que actuializa, inserta o inactiva un estado de documento de la tabla wf.ttipo_documento_estado';
COMMENT ON FUNCTION wf.f_import_ttabla(p_accion varchar, p_codigo_tabla varchar, p_codigo_tipo_proceso varchar, p_nombre_tabla varchar, p_descripcion text, p_scripts_extras text, p_vista_tipo varchar, p_vista_posicion varchar, p_vista_codigo_tabla_maestro varchar, p_vista_campo_ordenacion varchar, p_vista_dir_ordenacion varchar, p_vista_campo_maestro varchar, p_vista_scripts_extras text, p_menu_nombre varchar, p_menu_icono varchar, p_menu_codigo varchar, p_vista_estados_new text, p_vista_estados_delete text)
IS 'funcion que actuializa, inserta o inactiva una tabla de la tablawf.ttabla';
COMMENT ON FUNCTION wf.f_import_ttipo_documento(p_accion varchar, p_codigo varchar, p_codigo_tipo_proceso varchar, p_nombre varchar, p_descripcion text, p_action varchar, p_tipo_documento varchar, p_orden numeric, p_categoria_documento varchar [])
IS 'funcion que actuializa, inserta o inactiva un tipo de documento de la tabla wf.ttipo_documento';
COMMENT ON FUNCTION wf.f_import_ttipo_columna(p_accion varchar, p_nombre_columna varchar, p_codigo_tabla varchar, p_codigo_tipo_proceso varchar, p_tipo_columna varchar, p_descripcion text, p_tamano varchar, p_campos_adicionales text, p_joins_adicionales text, p_formula_calculo text, p_grid_sobreescribe_filtro text, p_grid_campos_adicionales text, p_form_tipo_columna varchar, p_form_label varchar, p_form_es_combo varchar, p_form_combo_rec varchar, p_form_sobreescribe_config text, p_bd_prioridad integer, p_form_grupo integer)
IS 'funcion que actuializa, inserta o inactiva un tipo de un tipo columna de la tabla wf.ttipo_columna';
COMMENT ON FUNCTION wf.f_import_tproceso_macro(p_accion varchar, p_codigo varchar, p_codigo_subsistema varchar, p_nombre varchar, p_inicio varchar)
IS 'funcion que actuializa, inserta o inactiva un tipo de un proceso macro de la tabla wf.tproceso_macro';
COMMENT ON FUNCTION wf.f_import_tplantilla_correo(p_accion varchar, p_codigo varchar, p_codigo_tipo_estado varchar, p_codigo_tipo_proceso varchar, p_regla text, p_plantilla text, p_correos text, p_asunto varchar)
IS 'funcion que actuializa, inserta o inactiva un tipo de plantilla correo de la tabla wf.tplantilla_correo';
COMMENT ON FUNCTION wf.f_import_tlabores_tipo_proceso(p_accion varchar, p_codigo varchar, p_codigo_tipo_proceso varchar, p_nombre varchar, p_descripcion varchar)
IS ' funcion que actuializa, inserta o inactiva un tipo de tipo proceso labores de la tabla wf.tlabores_tipo_proceso';
COMMENT ON FUNCTION wf.f_import_tfuncionario_tipo_estado(p_accion varchar, p_codigo_tipo_estado varchar, p_codigo_tipo_proceso varchar, p_ci varchar, p_codigo_depto varchar, p_regla varchar)
IS 'funcion que actuializa, inserta o inactiva un funcionario tipo de la tabla wf.tfuncionario_tipo_estado';
COMMENT ON FUNCTION wf.f_import_testructura_estado(p_accion varchar, p_codigo_estado_padre varchar, p_codigo_estado_hijo varchar, p_codigo_tipo_proceso varchar, p_prioridad integer, p_regla varchar)
IS 'funcion que actuializa, inserta o inactiva una estructura estado de la tabla wf.testructura_estado';
COMMENT ON FUNCTION wf.f_import_tcolumna_estado(p_accion varchar, p_nombre_tipo_columna varchar, p_codigo_tabla varchar, p_codigo_tipo_proceso varchar, p_codigo_tipo_estado varchar, p_momento varchar, p_regla varchar)
IS 'funcion que actuializa, inserta o inactiva una columna estado de la tabla wf.tcolumna_estado';
COMMENT ON FUNCTION wf.f_import_tcategoria_documento(p_accion varchar, p_codigo varchar, p_nombre varchar)
IS 'funcion que actuializa, inserta o inactiva una categoria documento estado de la tabla wf.tcategoria_documento';
COMMENT ON FUNCTION wf.f_obtener_tipo_estado_inicial_del_tipo_proceso(p_id_tipo_proceso integer, out ps_id_tipo_estado integer, out ps_codigo_estado varchar)
IS 'esta funcion permite obtener el siguiente estado o  el anterior dentro del WF';
COMMENT ON FUNCTION wf.f_obtener_estado_wf(p_id_proceso_wf integer, p_id_estado_wf integer, p_id_tipo_estado integer, p_operacion varchar, p_id_usuario integer, out ps_id_tipo_estado integer [], out ps_codigo_estado varchar [], out ps_disparador varchar [], out ps_regla varchar [], out ps_prioridad integer [])
IS 'esta funcion permite obtener el siguiente estado o  el anterior dentro del WF';
COMMENT ON FUNCTION wf.f_obtener_estado_tipo_proceso(p_codigo_subsistema varchar, p_codigo_tipo_proceso varchar, p_estado_actual varchar, p_nodo varchar, out p_estado varchar [], out p_bandera varchar [], out p_prioridad varchar [], out p_reglas varchar [])
IS 'funcion que Devuelve:
un array varchar (ESTADO)
un array varchar bandera (BANDERA)
un array prioridad (PRIORIDAD)
un array reglas (REGLAS)
Recive:
codigo_subsistema,
codigo_tipo_proceso,
estado_actual -> NULL o nombre_estado
nodo -> siguiente o anterior';
COMMENT ON FUNCTION wf.f_obtener_estado_segun_log_wf(p_id_estado_wf integer, p_id_tipo_estado integer, out ps_id_funcionario integer, out ps_id_usuario_reg integer, out ps_id_depto integer, out ps_codigo_estado varchar, out ps_id_estado_wf_ant integer)
IS 'esta funcion permite obtener el estado_wf   correpondiente al parametro id_tipo_estado,
segun registro del log del WF para el parametros id_estado_wf,
(busca recursivamente en el los hasta encontra el tipo_estado)';
COMMENT ON FUNCTION wf.f_obtener_estado_ant_log_wf(p_id_estado_wf integer, out ps_id_tipo_estado integer, out ps_id_funcionario integer, out ps_id_usuario_reg integer, out ps_id_depto integer, out ps_codigo_estado varchar, out ps_id_estado_wf_ant integer)
IS 'funcion que permite obtener el estado anterior  del proceso segun  registro de log del WF';
COMMENT ON FUNCTION wf.f_obtener_diparador_predecesor_proceso(p_codigo_tipo_proceso varchar, p_nombre_estado varchar, p_bandera varchar, out p_proceso varchar [], out p_estado varchar [])
IS 'funcion que Devuelve:
array varchar PROCESO, con listado de codigos de proceso disparado
array varchar ESTADO,  con lisatdo de nombres de estado';
COMMENT ON FUNCTION wf.f_obtener_cadena_tipos_estados_anteriores_wf(p_id_tipo_estado integer, out ps_id_tipo_estado integer [], out ps_codigo_estado varchar [])
IS 'esta funcion permite obtener el siguiente estado o  el anterior dentro del WF';
COMMENT ON FUNCTION wf.f_modificar_momento_documento_wf(p_id_usuario_reg integer, p_id_proceso_wf integer, p_momento varchar, p_codigo_documento varchar)
IS 'funcion que devuelve un numero de correlativo a partir del Codigo, Numero siguiente y Gestion';
COMMENT ON FUNCTION wf.f_inserta_documento_wf(p_id_usuario_reg integer, p_id_proceso_wf integer, p_id_estado_wf integer)
IS 'funcion que devuelve un numero de correlativo a partir del Codigo, Numero siguiente y Gestion';
COMMENT ON FUNCTION wf.f_insert_ttipo_proceso(par_nombre_tipo_estado varchar, par_nombre varchar, par_codigo varchar, par_tabla varchar, par_columna_llave varchar, par_estado_reg varchar, par_inicio varchar, par_cod_proceso_macro varchar)
IS 'funcion de insercion o actualizacion de un tipo de proceso en la tabla wf.ttipo_proceso
a partir de codigo inicio';
COMMENT ON FUNCTION wf.f_insert_ttipo_estado(par_codigo varchar, par_nombre_estado varchar, par_inicio varchar, par_disparador varchar, par_fin varchar, par_tipo_asignacion varchar, par_nombre_func_list varchar, par_depto_asignacion varchar, par_nombre_depto_func_list varchar, par_obs text, par_estado_reg varchar, par_codigo_proceso varchar, par_tipos_proceso text)
IS 'funcion de insercion de un tipo de estado en la tabla wf.ttipo_estado a partir del nombre_estado';
COMMENT ON FUNCTION wf.f_insert_tproceso_macro(par_codigo varchar, par_nombre varchar, par_inicio varchar, par_estado_reg varchar, par_subsistema varchar)
IS 'funcion de insercion o actualizacion de un proceso macro en la tabla wf.tproceso_macro a partir de un nombre par_nombre';
COMMENT ON FUNCTION wf.f_insert_testructura_estado(par_codigo_tipo_estado_padre varchar, par_codigo_proceso_estado_padre varchar, par_codigo_tipo_estado_hijo varchar, par_codigo_proceso_estado_hijo varchar, par_prioridad integer, par_regla varchar, par_estado_reg varchar)
IS 'funcion de insercion de una estructura estado en la tabla wf.testructura_estado
a partir par_codigo_proceso_estado_padre y par_codigo_proceso_estado_hijo';
COMMENT ON FUNCTION wf.f_inicia_tramite(p_id_usuario_reg integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_gestion integer, p_codigo_tipo_proceso varchar, p_id_funcionario integer, p_id_depto integer, p_descripcion varchar, p_codigo_proceso varchar, p_nro_tramite_custom varchar, out ps_num_tramite varchar, out ps_id_proceso_wf integer, out ps_id_estado_wf integer, out ps_codigo_estado varchar)
IS 'funcion que devuelve un numero de correlativo a partir del Codigo, Numero siguiente y Gestion';
COMMENT ON FUNCTION wf.f_import_ttipo_proceso_origen(p_accion varchar, p_codigo_tipo_proceso varchar, p_codigo_pm varchar, p_codigo_tipo_proceso_origen varchar, p_codigo_tipo_estado varchar, p_tipo_disparo varchar, p_funcion_validacion_wf text)
IS 'funcion de insercion, actualizacion o inactivo de la tabla wf.ttipo_proceso_origen';
COMMENT ON FUNCTION wf.f_verifica_observaciones(p_id_usuario_reg integer, p_id_estado_wf integer)
IS 'verifica si el estado del wf del que quiere salir tiene observaciones pendientes no cerradas y activas';
COMMENT ON FUNCTION wf.f_verifica_documento(p_id_usuario_reg integer, p_id_estado_wf integer)
IS 'Verifica que tipos de coumentos estan relacionados con el estado indicado, y controla si debe ser exigido';
COMMENT ON FUNCTION wf.f_valida_cambio_estado(p_id_estado_wf integer, p_momento varchar, p_id_tipo_estado integer, p_id_usuario integer)
IS 'funcion que valida el cambio de estado de un proceso en el workflow a partir del p_id_estado_wf y p_id_tipo_estado';
COMMENT ON FUNCTION wf.f_tipo_dato_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_dato';
COMMENT ON FUNCTION wf.f_tipo_dato_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_dato';
COMMENT ON FUNCTION wf.f_tiene_observaciones(p_id_estado_wf integer)
IS 'funcion que verifica si un proceso tiene observaciones en el workflow';
COMMENT ON FUNCTION wf.f_test(p_id_usuario integer, p_id_proceso_wf integer)
IS 'funcion que solo valida si el WF funciona';
COMMENT ON FUNCTION wf.f_registra_proceso_disparado_wf(p_id_usuario_reg integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_estado_wf_dis integer, p_id_funcionario integer, p_id_depto integer, p_descripcion varchar, p_codigo_tipo_proceso varchar, p_codigo_proceso_wf varchar, out ps_id_proceso_wf integer, out ps_id_estado_wf integer, out ps_codigo_estado varchar, out ps_nro_tramite varchar)
IS 'funcion que registra y devuelve un numero de correlativo a partir del Codigo, Numero siguiente y Gestion
de un proceso que se dispara';
COMMENT ON FUNCTION wf.f_registra_gui_tabla(p_codigo_proceso varchar, p_nombre_proceso varchar, p_codigo_estado varchar, p_nombre_estado varchar, p_roles text)
IS 'funcion que registra o actualiza una gui_tabla en la tabla segu.tgui
segun el codigo de un tipo de proceso de la tabla wf.ttipo_proceso';
COMMENT ON FUNCTION wf.f_registra_estado_wf(p_id_tipo_estado_siguiente integer, p_id_funcionario integer, p_id_estado_wf_anterior integer, p_id_proceso_wf integer, p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_depto integer, p_obs text, p_acceso_directo varchar, p_clase varchar, p_parametros varchar, p_tipo varchar, p_titulo varchar)
IS 'funcion que devuelve el estado de la tabla wf.ttipo_estado:
ID del estado actual o -1 si los parametros introduciodos no son correctos.

Recibe:
estado_proceso -> nombre del estado actual
id_funcionario
id_estado_wf --> id_estado anterior
id_proceso_wf --> permite reconocer univocamente un proceso';
COMMENT ON FUNCTION wf.f_proceso_wf_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tproceso_wf';
COMMENT ON FUNCTION wf.f_proceso_wf_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tproceso_wf';
COMMENT ON FUNCTION wf.f_procesar_plantilla(p_id_usuario integer, p_id_proceso_wf integer, p_plantilla text, p_id_tipo_estado_actual integer, p_id_estado_anterior integer, p_obs text, p_id_funcionario_actual integer, p_id_depto_actual integer)
IS ' Esta funcion puede generalizarce para procesar no solamente plantilla de correo , sino tambien plantilla de formulario
 Se utilizara tambien para las procesar las plantillas de las arreglas en las aristas
 en la funcion  wf.f_obtener_estado_wf() ';
COMMENT ON FUNCTION wf.f_priorizar_documento(p_id_proceso_wf integer, p_id_usuario integer, p_id_tipo_documento integer, p_direccion varchar)
IS 'Devuelve 0 sis e pririza ascendentemente y corresponde priorizar
        1 si se prioriza ascendentemente y no corresponde priorizar
        9 si se prioriza descendentemente y corresponde priorizar
        8 si se prioriza descendentemente y no corresponde priorizar ';
COMMENT ON FUNCTION wf.f_obtener_tipos_procesos(p_nombre_tipo_estado varchar)
IS 'funcion que obtiene los tipo de proceso de wf.ttipo_proceso a partir del tipo estado de wf.ttipo_proceso
en la columna nombre_estado (p_nombre_tipo_estado)';
COMMENT ON FUNCTION wf.ft_plantilla_correo_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tplantilla_correo';
COMMENT ON FUNCTION wf.ft_plantilla_correo_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tplantilla_correo';
COMMENT ON FUNCTION wf.ft_obs_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tobs';
COMMENT ON FUNCTION wf.ft_obs_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tobs';
COMMENT ON FUNCTION wf.ft_num_tramite_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tnum_tramite';
COMMENT ON FUNCTION wf.ft_num_tramite_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tnum_tramite';
COMMENT ON FUNCTION wf.ft_labores_tipo_proceso_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tlabores_tipo_proceso';
COMMENT ON FUNCTION wf.ft_labores_tipo_proceso_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tlabores_tipo_proceso';
COMMENT ON FUNCTION wf.ft_funcionario_tipo_estado_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tfuncionario_tipo_estado';
COMMENT ON FUNCTION wf.ft_funcionario_tipo_estado_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tfuncionario_tipo_estado';
COMMENT ON FUNCTION wf.ft_estructura_estado_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.testructura_estado';
COMMENT ON FUNCTION wf.ft_estructura_estado_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.testructura_estado';
COMMENT ON FUNCTION wf.ft_documento_wf_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tdocumento_wf';
COMMENT ON FUNCTION wf.ft_documento_wf_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tdocumento_wf';
COMMENT ON FUNCTION wf.ft_documento_historico_wf_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tdocumento_historico_wf';
COMMENT ON FUNCTION wf.ft_columna_estado_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tcolumna_estado';
COMMENT ON FUNCTION wf.ft_columna_estado_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tcolumna_estado';
COMMENT ON FUNCTION wf.ft_categoria_documento_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tcategoria_documento';
COMMENT ON FUNCTION wf.ft_categoria_documento_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.tcategoria_documento';
COMMENT ON FUNCTION wf.ft_bitacoras_procesos_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.tbitacotas_procesos';
COMMENT ON FUNCTION wf.ft_tipo_estado_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_estado';
COMMENT ON FUNCTION wf.ft_tipo_estado_rol_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_estado_rol';
COMMENT ON FUNCTION wf.ft_tipo_estado_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_estado';
COMMENT ON FUNCTION wf.ft_tipo_documento_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_documento';
COMMENT ON FUNCTION wf.ft_tipo_documento_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_documento';
COMMENT ON FUNCTION wf.ft_tipo_documento_estado_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_documento_estado';
COMMENT ON FUNCTION wf.ft_tipo_documento_estado_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_documento_estado';
COMMENT ON FUNCTION wf.ft_tipo_componente_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_componente';
COMMENT ON FUNCTION wf.ft_tipo_componente_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_componente';
COMMENT ON FUNCTION wf.ft_tipo_comp_tipo_prop_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_comp_tipo_prop';
COMMENT ON FUNCTION wf.ft_tipo_comp_tipo_prop_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_comp_tipo_prop';
COMMENT ON FUNCTION wf.ft_tipo_columna_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_columna';
COMMENT ON FUNCTION wf.ft_tipo_columna_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_columna';
COMMENT ON FUNCTION wf.ft_tabla_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttabla';
COMMENT ON FUNCTION wf.ft_tabla_instancia_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttabla_instancia';
COMMENT ON FUNCTION wf.ft_tabla_instancia_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS ' Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla autogenerada del workflow';
COMMENT ON FUNCTION wf.ft_tabla_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttabla';
COMMENT ON FUNCTION wf.ft_proceso_macro_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.proceso_macro';
COMMENT ON FUNCTION wf.ft_proceso_macro_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.proceso_macro';
COMMENT ON FUNCTION wf.ftrig_ttipo_proceso_origen()
IS 'funcion que devuelve un trigger de la tabla ttipo_proceso_origen';
COMMENT ON FUNCTION wf.ftrig_ttipo_proceso()
IS 'funcion que devuelve un trigger de la tabla ttipo_proceso';
COMMENT ON FUNCTION wf.ftrig_ttipo_estado_rol()
IS 'funcion que devuelve un trigger de la tabla ttipo_estado_rol';
COMMENT ON FUNCTION wf.ftrig_ttipo_estado()
IS 'funcion que devuelve un trigger de la tabla ttipo_estado';
COMMENT ON FUNCTION wf.ftrig_ttipo_documento_estado()
IS 'funcion que devuelve un trigger de la tabla ttipo_documento_estado';
COMMENT ON FUNCTION wf.ftrig_ttipo_documento()
IS 'funcion que devuelve un trigger de la tabla ttipo_documento';
COMMENT ON FUNCTION wf.ftrig_ttipo_columna()
IS 'funcion que devuelve un trigger de la tabla ttipo_columna';
COMMENT ON FUNCTION wf.ftrig_ttabla()
IS 'funcion que devuelve un trigger de la tabla ttabla';
COMMENT ON FUNCTION wf.ftrig_tproceso_macro()
IS 'funcion que devuelve un trigger de la tabla tproceso_macro';
COMMENT ON FUNCTION wf.ftrig_tplantilla_correo()
IS 'funcion que devuelve un trigger de la tabla tplantilla_correo';
COMMENT ON FUNCTION wf.ftrig_tobs()
IS 'funcion que devuelve un trigger de la tabla tobs';
COMMENT ON FUNCTION wf.ftrig_tlabores_tipo_proceso()
IS 'funcion que devuelve un trigger de la tabla tlabores_tipo_proceso';
COMMENT ON FUNCTION wf.ftrig_tfuncionario_tipo_estado()
IS 'funcion que devuelve un trigger de la tabla tfuncionario_tipo_estado';
COMMENT ON FUNCTION wf.ftrig_testructura_estado()
IS 'funcion que devuelve un trigger de la tabla testructura_estado';
COMMENT ON FUNCTION wf.ftrig_tcolumna_estado()
IS 'funcion que devuelve un trigger de la tabla tcolumna_estado';
COMMENT ON FUNCTION wf.ftrig_tcategoria_documento()
IS 'funcion que devuelve un trigger de la tabla tcategoria_documento';
COMMENT ON FUNCTION wf.ft_tipo_propiedad_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_propiedad';
COMMENT ON FUNCTION wf.ft_tipo_propiedad_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_propieda';
COMMENT ON FUNCTION wf.ft_tipo_proceso_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_proceso';
COMMENT ON FUNCTION wf.ft_tipo_proceso_origen_sel(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS ' Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla wf.ttipo_proceso_origen';
COMMENT ON FUNCTION wf.ft_tipo_proceso_origen_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_proceso_origen';
COMMENT ON FUNCTION wf.ft_tipo_proceso_ime(p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
IS 'Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla wf.ttipo_proceso';


--tablas

COMMENT ON TABLE wf.tcatalogo
IS 'Los catálogos se refieren a dominios de datos limitados, que podrán ser utilizados
por los formularios dinámicos del workflow por proceso macro';
COMMENT ON COLUMN wf.tcatalogo.id_catalogo
IS 'Identificador de la cabecera de Catalogos de WF';
COMMENT ON COLUMN wf.tcatalogo.id_proceso_macro
IS 'Llave foránea de la tabla wf.tproceso_macro';
COMMENT ON COLUMN wf.tcatalogo.codigo
IS 'Código único (llave alterna) para nombrar al Catálogo';
COMMENT ON COLUMN wf.tcatalogo.nombre
IS 'Nombre del catálogo';

COMMENT ON TABLE wf.tcatalogo_valor
IS 'Valores definidos en el catálogo (o dominio) creado';
COMMENT ON COLUMN wf.tcatalogo_valor.id_catalogo_valor
IS 'Relación recursiva para registro de datos jerárquicos (árbol)';
COMMENT ON COLUMN wf.tcatalogo_valor.id_catalogo
IS 'Llave foránea del maestro de la tabla wf.tcatalogo';
COMMENT ON COLUMN wf.tcatalogo_valor.codigo
IS 'Código único (llave alterna) de los valores del catálogo';
COMMENT ON COLUMN wf.tcatalogo_valor.nombre
IS 'Nombre de los valores del catálogo';
COMMENT ON COLUMN wf.tcatalogo_valor.orden
IS 'Orden de despliegue de los valores del catálogo';

COMMENT ON TABLE wf.tcategoria_documento
IS 'Tabla que alberga datos de la categoria de un documento relacionado al workflow';
COMMENT ON COLUMN wf.tcategoria_documento.codigo
IS 'identifica el documento y se almacenes en el array  categoria_documento en la interface de tipo_documento_wf';

COMMENT ON TABLE wf.tcolumna_estado
IS 'contiene informacion del estado correspondiente a la tabla wf.ttipo_columna con el estado wf.ttipo_estado';
COMMENT ON COLUMN wf.tcolumna_estado.id_tipo_columna
IS 'identificador de la tabla wf.ttipo_columna';
COMMENT ON COLUMN wf.tcolumna_estado.id_tipo_estado
IS 'identificador de la tabla wf.ttipo_estado';

COMMENT ON TABLE wf.tdocumento_historico_wf
IS 'contiene informacion historica de los documentos del workflow';
COMMENT ON COLUMN wf.tdocumento_historico_wf.vigente
IS 'si o no, lo no vigentes son versiones anteriores';
COMMENT ON COLUMN wf.tdocumento_historico_wf.url_old
IS 'direccion antigua del documento mod';
COMMENT ON COLUMN wf.tdocumento_historico_wf.url
IS 'direccion actual del documento';

COMMENT ON TABLE wf.tdocumento_wf
IS 'contiene informacion del documento asociado a un proceso wf';
COMMENT ON COLUMN wf.tdocumento_wf.id_tipo_documento
IS 'hace referencia al tipo de documento en la tabla wf.ttipo_documento';
COMMENT ON COLUMN wf.tdocumento_wf.id_proceso_wf
IS 'referencia al proceso workflow en wf.tproceso_wf';
COMMENT ON COLUMN wf.tdocumento_wf.id_estado_ini
IS 'hace referencia al estado donde se creo el documento';
COMMENT ON COLUMN wf.tdocumento_wf.chequeado_fisico
IS 'identifica los documentos que se tienen fisicamente';
COMMENT ON COLUMN wf.tdocumento_wf.momento_fisico
IS 'verificar o exigir documentos fisicos';
COMMENT ON COLUMN wf.tdocumento_wf.id_proceso_wf_ori
IS 'para alguno documentos copiados, como los contratos en OP, toma el pvalor del proceso wf original para que nos sirva para direccionar a los otros documentos del tramite original';
COMMENT ON COLUMN wf.tdocumento_wf.nro_tramite_ori
IS 'por rendimiento copiamos el nro_tramite';
COMMENT ON COLUMN wf.tdocumento_wf.demanda
IS 'documento insertado por demanda si o no, por defecto es no';

COMMENT ON TABLE wf.testado_wf
IS 'contiene informacion del estado asociado a un proceso workflow
ademas de refrenciar a un estado anterior a si mismo';
COMMENT ON COLUMN wf.testado_wf.id_proceso_wf
IS 'identificador del proceso workflow tproceso_wf';
COMMENT ON TABLE wf.testructura_estado
IS 'contiene informacion de prioridades y reglas para el tipo_estado';
COMMENT ON COLUMN wf.testructura_estado.id_tipo_estado_padre
IS 'identificador del tipo_estado_padre de ttipo_estado';
COMMENT ON COLUMN wf.testructura_estado.id_tipo_estado_hijo
IS 'identificador el tipo_estado_hijo de la tabla ttipo_estado';
COMMENT ON COLUMN wf.testructura_estado.bucle
IS 'identifica si la arista ocaciona un bucle, este campo se registra de manera automatica el momento de insetar la arista';

COMMENT ON TABLE wf.tfuncionario_tipo_estado
IS 'contiene informacion (id_funcionario en orga.tfuncionario)
relacionado al usuario involucrado en tipo de estado en el workflow';
COMMENT ON COLUMN wf.tfuncionario_tipo_estado.id_funcionario
IS 'relaciona la informacion del estado con el funcionario en la tabla orga.tfuncionario';
COMMENT ON TABLE wf.tfuncionario_tipo_estado
IS 'contiene informacion (id_funcionario en orga.tfuncionario)
relacionado al usuario involucrado en tipo de estado en el workflow';
COMMENT ON COLUMN wf.tfuncionario_tipo_estado.id_funcionario
IS 'relaciona la informacion del estado con el funcionario en la tabla orga.tfuncionario';
COMMENT ON TABLE wf.tnum_tramite
IS 'contiene datos de numero de tramite de un proceso macro del work flow';
COMMENT ON TABLE wf.tobs
IS 'tiene informacion de alguna observacion relacionado a un estado workflow';
COMMENT ON COLUMN wf.tobs.descripcion
IS 'descripcion de la observacion';
COMMENT ON COLUMN wf.tobs.estado
IS 'estado del proceso de observacion';
COMMENT ON COLUMN wf.tobs.num_tramite
IS 'numero de tramite';
COMMENT ON COLUMN wf.tobs.id_estado_wf
IS 'referencia al estado workflow';
COMMENT ON COLUMN wf.tobs.id_alarma
IS 'referencia a la alarma creada por la observacion';

COMMENT ON TABLE wf.tplantilla_correo
IS 'contiene informacion de una plantilla de correo con sus respectivas reglas';
COMMENT ON COLUMN wf.tplantilla_correo.correos
IS 'direcciones de correo electronico';
COMMENT ON COLUMN wf.tplantilla_correo.regla
IS 'reglas de la plantilla';
COMMENT ON COLUMN wf.tplantilla_correo.requiere_acuse
IS 'si l aplantilla requiere acuse el correo se manda con un link donde la persona que recibe tendra que confirma su aceptación';
COMMENT ON COLUMN wf.tplantilla_correo.url_acuse
IS 'indeitifca la URL que se coloca en el link del correo para que la persona que recibe acepte,   puede ser un servidor dintinto, en un dmz';
COMMENT ON COLUMN wf.tplantilla_correo.mensaje_acuse
IS 'depues de precinar el link del acuse se muestra este mensaje,';
COMMENT ON COLUMN wf.tplantilla_correo.mensaje_link_acuse
IS 'mensjae que a antes del link de acuse de recibo';
COMMENT ON COLUMN wf.tplantilla_correo.mandar_automaticamente
IS 'se manda el correo de manera automatica al llegar a este estado o espera la confirmación para enviar';
COMMENT ON COLUMN wf.tplantilla_correo.funcion_acuse_recibo
IS 'esta funcion se ejecuta cuando se recibe el acuse de recibo';
COMMENT ON COLUMN wf.tplantilla_correo.funcion_creacion_correo
IS 'esta funcion se ejecuta despude se insertar la alerta';

COMMENT ON TABLE wf.tproceso_macro
IS 'informacion de los procesos macro de un flujo de trabajo asignado a un susbsistema';
COMMENT ON COLUMN wf.tproceso_macro.codigo
IS 'codigo del proceso macro';
COMMENT ON COLUMN wf.tproceso_macro.nombre
IS 'nombre del proceso macro';
COMMENT ON COLUMN wf.tproceso_macro.grupo_doc
IS 'aca se almacena la configuracion gruposBarraTareas  que va en la interface de documentos para definir que categorias pueden verse desde esta interface.';

COMMENT ON TABLE wf.tproceso_wf
IS 'contiene informacion del proceso del workflow relacionado al tipo de proceso correspondiente';
COMMENT ON COLUMN wf.tproceso_wf.nro_tramite
IS 'numero de tramite del proceso';
COMMENT ON COLUMN wf.tproceso_wf.descripcion
IS 'descripcion del proceso';
COMMENT ON COLUMN wf.tproceso_wf.codigo_proceso
IS 'es un codigo que permite identifica al proceso origen de manrea univoca, por ejemplo nro de solicitud de compra, orden de compra, o numero de cuota, etc';
COMMENT ON COLUMN wf.tproceso_wf.prioridad
IS 'los numeros mas bajos representan prioridades mayores';
COMMENT ON COLUMN wf.tproceso_wf.id_tipo_estado_wfs
IS 'almacenes el historico de tipo de estado por lo que va pansado el flujo, se utiliza para saber cuanto veces paso por un mismo estado';

COMMENT ON TABLE wf.tsoporte
IS 'Contiene informacion de soporte en un estado del proceso wf';
COMMENT ON COLUMN wf.tsoporte.estado
IS 'estado del proceso wf en un determinado estado';
COMMENT ON COLUMN wf.tsoporte.problema
IS 'problema a dar soporte';
COMMENT ON COLUMN wf.tsoporte.origen_problema
IS 'origen del problema';
COMMENT ON COLUMN wf.tsoporte.solucion
IS 'solucion al problema';

COMMENT ON TABLE wf.ttabla
IS 'informacion de tablas relacionadas a un tipo de proceso';
COMMENT ON COLUMN wf.ttabla.bd_scripts_extras
IS 'En este campo se puede definir llaves foraneas, indices, triggers, funciones y otros que puedan ser necesarios para la tabla';
COMMENT ON COLUMN wf.ttabla.vista_id_tabla_maestro
IS 'la tabla qu es maestro en caso de que sea detalle';
COMMENT ON COLUMN wf.ttabla.vista_campo_maestro
IS 'el campo del maestro en caso de ser detalle';
COMMENT ON COLUMN wf.ttabla.vista_scripts_extras
IS 'En este campo debe registrarse un json con los metodos que se desean sobrescribir de la clase';

COMMENT ON TABLE wf.ttipo_columna
IS 'identifica la columna a evaluar de la tabla ttabla';
COMMENT ON COLUMN wf.ttipo_columna.bd_campos_adicionales
IS 'el formato es : "nombre_columna nombre_modelo tipo" separados por comas por cada campo adicional';
COMMENT ON COLUMN wf.ttipo_columna.grid_sobreescribe_filtro
IS 'sobreescribir el filtro de una columna en la vista, debe ser un objeto de tipo json {}';
COMMENT ON COLUMN wf.ttipo_columna.grid_campos_adicionales
IS 'el formato es : "nombre tipo formato" separados por comas por cada campo adicional';
COMMENT ON COLUMN wf.ttipo_columna.form_tipo_columna
IS 'tipo de dato de la columna';
COMMENT ON COLUMN wf.ttipo_columna.form_es_combo
IS 'si o no para ver si es un combo';
COMMENT ON COLUMN wf.ttipo_columna.form_sobreescribe_config
IS 'sobreescribir el config de una columna en la vista, debe ser un objeto de tipo json {}';

COMMENT ON TABLE wf.ttipo_comp_tipo_prop
IS 'Almacena los tipos de propiedad para cada tipo de componente';
COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.id_tipo_comp_tipo_prop
IS 'Identificador de la tabla';
COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.id_tipo_propiedad
IS 'Llave foranea de la tabla wf.ttipo_propiedad';
COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.id_tipo_componente
IS 'Llave foranea de la tabla wf.ttipo_componente';
COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.obligatorio
IS 'Define si el registro del valor del tipo de propiedad sera obligatorio';
COMMENT ON COLUMN wf.ttipo_comp_tipo_prop.tipo_dato
IS 'Tipo de dato para el valor del tipo de propiedad';

COMMENT ON TABLE wf.ttipo_componente
IS 'Almacena los tipos de componente disponibles para la generación de formularios dinámicos';
COMMENT ON COLUMN wf.ttipo_componente.id_tipo_componente
IS 'Identificador de la tabla';
COMMENT ON COLUMN wf.ttipo_componente.codigo
IS 'Codigo unico que representa al componente';
COMMENT ON COLUMN wf.ttipo_componente.nombre
IS 'Nombre descriptivo del componente';

COMMENT ON TABLE wf.ttipo_documento
IS 'contiene informacion del tipo de documento relacionado a un tipo de proceso del workflow';
COMMENT ON COLUMN wf.ttipo_documento.codigo
IS 'codigo del tipo de documento';
COMMENT ON COLUMN wf.ttipo_documento.nombre
IS 'nombre del tipo de documento';
COMMENT ON COLUMN wf.ttipo_documento.action
IS 'accion relacionado algun tipo de reporte';
COMMENT ON COLUMN wf.ttipo_documento.tipo
IS 'tipo generado o escaneado';
COMMENT ON COLUMN wf.ttipo_documento.solo_lectura
IS 'los campos  de solo lectura se copia por base de datos,  y no deben ser cambiados por los usuarios';
COMMENT ON COLUMN wf.ttipo_documento.categoria_documento
IS 'este campo sirve para idetoficar a que caterorias pertenece un tipo de documento';
COMMENT ON COLUMN wf.ttipo_documento.orden
IS 'numero para ordenar los documentos por importancion los mas importantes necesitan numeros mas bajos';

COMMENT ON TABLE wf.ttipo_documento_estado
IS 'informacion de documentos relacionados en el estado de tipo_estado';
COMMENT ON COLUMN wf.ttipo_documento_estado.tipo_busqueda
IS 'superior o inferior, define la forma de buscar el documento';

COMMENT ON TABLE wf.ttipo_estado
IS 'informacion del estado en el que se puede encontrar un tipo de estado de un proceso en el workflow';
COMMENT ON COLUMN wf.ttipo_estado.codigo
IS 'codigo del estado en el que se encuentra un tipo de estado';
COMMENT ON COLUMN wf.ttipo_estado.nombre_estado
IS 'nombre del estado';
COMMENT ON COLUMN wf.ttipo_estado.inicio
IS 'indica si ese estado es algun estado de inicio';
COMMENT ON COLUMN wf.ttipo_estado.disparador
IS 'indica si el estado es un disparador a otro proceso que va a iniciar';
COMMENT ON COLUMN wf.ttipo_estado.fin
IS 'indica si el estado es un estado final del proceso';
COMMENT ON COLUMN wf.ttipo_estado.obs
IS 'Este campo se utiliza para adicionar comodines que pueden ser utile en el proceso. Por ejemplo sirve para identificar que partidas son revisadas por los vistos buenos de almancenes y activos fijos';
COMMENT ON COLUMN wf.ttipo_estado.alerta
IS 'dato si se generan alertas en el estado actual';
COMMENT ON COLUMN wf.ttipo_estado.plantilla_mensaje
IS 'rirve para personalizar la el correo que me manda al cambiar el estado, los valor de la plantilla se recuperar de la table referenciada en tipo_proceso';
COMMENT ON COLUMN wf.ttipo_estado.cargo_depto
IS 'este campo recibe los cargo del depto que reciben la alerta, si no tiene valores se les manda  todos';
COMMENT ON COLUMN wf.ttipo_estado.mobile
IS 'si o no, se muestra en el la interface de vobowf,  solo es conveniente las interfaces que solo necesitas ir adelante o atras';
COMMENT ON COLUMN wf.ttipo_estado.funcion_inicial
IS 'esta funcion correo cuando  el flujo continua sobre este estado';
COMMENT ON COLUMN wf.ttipo_estado.funcion_regreso
IS 'esta funcion correo cuando  el flujo retrocede hacia este estado';
COMMENT ON COLUMN wf.ttipo_estado.acceso_directo_alerta
IS 'direccion de la interface que se manda dentro la alerta de este estado';
COMMENT ON COLUMN wf.ttipo_estado.nombre_clase_alerta
IS 'nombre de la clase que se ejecuta en el acceso directo de la clase';
COMMENT ON COLUMN wf.ttipo_estado.parametros_ad
IS 'parametros en formato JSON que se mandan al acceso directo';
COMMENT ON COLUMN wf.ttipo_estado.tipo_noti
IS 'tipo de alerta';
COMMENT ON COLUMN wf.ttipo_estado.titulo_alerta
IS 'Titulo que se muestra en la alerta';
COMMENT ON COLUMN wf.ttipo_estado.admite_obs
IS 'no, si, permite o no el registros de observaciones en el estado';
COMMENT ON COLUMN wf.ttipo_estado.adminte_obs
IS 'no o si, define si permite registrar observaciones en este estado';
COMMENT ON COLUMN wf.ttipo_estado.etapa
IS 'Este es un texto que sirve hacer menos abstrato el nombre de los estados,  por lo general barrios estado pueden pertener a una misma etapa, este cmapo tiene que aprece en el diagrama gantt y en grilla';
COMMENT ON COLUMN wf.ttipo_estado.grupo_doc
IS 'aca se almacena la configuracion gruposBarraTareas  que va en la interface de documentos para definir que categorias pueden verse desde esta interface.';
COMMENT ON COLUMN wf.ttipo_estado.icono
IS 'Icono para representar al estado';

COMMENT ON TABLE wf.ttipo_estado_rol
IS 'esta tabla enlaza el tipo de estado con un rol de usuario en la tabla segu.trol';
COMMENT ON COLUMN wf.ttipo_estado_rol.id_rol
IS 'identificador de rol de la tabla segu.trol';

COMMENT ON TABLE wf.ttipo_proceso
IS 'contiene informacion del tipo de proceso relacionado al proceso macro,
los datos importantes son el nombre del tipo de proceso y la tabla relacionada a esta';
COMMENT ON COLUMN wf.ttipo_proceso.tabla
IS 'contiene la direccion de informacion de la tabla para el tipo de proceso';
COMMENT ON COLUMN wf.ttipo_proceso.columna_llave
IS 'llave de la columna tabla';
COMMENT ON COLUMN wf.ttipo_proceso.funcion_validacion_wf
IS 'Nombre de la funcion de validacion, esta funcion retorna falso o verdadero. Sirve para decidir si el proceso se inia o no (ejemplo preingresos de almaces o aactivos fijos al relaizar compras)';
COMMENT ON COLUMN wf.ttipo_proceso.tipo_disparo
IS 'obligatorio -> define si el proceso se dispara siempre, opcional -> (el usuario decide), opcional_automatico (se revisa la funcion de validacion), bandeja -> el proceso queda pendiente en una bandeja de espera';
COMMENT ON COLUMN wf.ttipo_proceso.descripcion
IS 'campo que describe el tipo de proceso';
COMMENT ON COLUMN wf.ttipo_proceso.codigo_llave
IS 'Este codigo permite identificar en tiempode ejecucion la anturaleza del proceso, pro ejemeplo, existe para procesos de Obligacion de pago, esto nos permite identificar que son obligaciones de pago y no ingresos a almacenes';
COMMENT ON COLUMN wf.ttipo_proceso.funcion_disparo_wf
IS 'Esta funcion sirve para colocar logija adicional depues de un disparo de proceso, ejemplo al dispara la obligacion de pago es necesario copiar el detalle de la cotizacion y copiarlo al detallle de la obligacion';

COMMENT ON COLUMN wf.ttipo_proceso_origen.tipo_disparo
IS 'obligatorio -> define si el proceso se dispara siempre, opcional -> (el usuario decide), opcional_automatico (se revisa la funcion de validacion), bandeja -> el proceso queda pendiente en una bandeja de espera';
COMMENT ON COLUMN wf.ttipo_proceso_origen.funcion_validacion_wf
IS 'tuncion de validacion o regla a ser evaluada';
COMMENT ON COLUMN wf.ttipo_proceso_origen.id_proceso_macro
IS 'ee utiliza para filtrar los tipo_estado disaradores que se muestran';

COMMENT ON TABLE wf.ttipo_propiedad
IS 'Almacena los tipos de propiedad generales que podrán ser relacionados a los tipos de componente';
COMMENT ON COLUMN wf.ttipo_propiedad.id_tipo_propiedad
IS 'Identificador de la tabla';
COMMENT ON COLUMN wf.ttipo_propiedad.codigo
IS 'Codigo unico que representa al tipo de propiedad';
COMMENT ON COLUMN wf.ttipo_propiedad.nombre
IS 'Nombre descriptivo del tipo de propiedad';
COMMENT ON COLUMN wf.ttipo_propiedad.tipo_dato
IS 'Tipo de dato por defecto para el valor del tipo de propiedad';


/*****************************F-SCP-AKFG-WF-0-21/11/2019*************/

/*****************************I-SCP-BVP-WF-0-28/02/2020*************/
CREATE TABLE wf.tdocumento_abierto (
  id_documento_abierto SERIAL,
  id_proceso_wf INTEGER,
  id_tipo_documento INTEGER,
  id_documento_wf INTEGER,
  id_documento_historico_wf INTEGER,
  historico VARCHAR(50) DEFAULT 'no'::character varying,
  url VARCHAR,
  extension VARCHAR(20),
  action VARCHAR,
  id_uo_funcionario INTEGER,
  id_uo INTEGER,
  CONSTRAINT tdocuments_open_pkey PRIMARY KEY(id_documento_abierto)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE wf.tdocumento_abierto
  ALTER COLUMN id_proceso_wf SET STATISTICS 0;

COMMENT ON TABLE wf.tdocumento_abierto
IS 'Almacena informacion de los usuario que abrieron un documento escaneado o generado.';

COMMENT ON COLUMN wf.tdocumento_abierto.historico
IS 'Campo que diferencia si el documento es un historico de documentos, o es el documento oficial.';

ALTER TABLE wf.tdocumento_abierto
  OWNER TO postgres;
/*****************************F-SCP-BVP-WF-0-28/02/2020*************/

/*****************************I-SCP-BVP-WF-0-24/03/2020*************/

ALTER TABLE wf.tobs
  ADD COLUMN id_funcionario_cc INTEGER[];

COMMENT ON COLUMN wf.tobs.id_funcionario_cc
IS 'Correo funcionarios en copia para correos.';

ALTER TABLE wf.tobs
  ADD COLUMN tipo VARCHAR;

COMMENT ON COLUMN wf.tobs.tipo
IS 'Tipo de observacion.';
  
/*****************************F-SCP-BVP-WF-0-24/03/2020*************/

/*****************************I-SCP-BVP-WF-0-03/04/2020*************/
ALTER TABLE wf.ttipo_estado
  ADD COLUMN control_tiempo VARCHAR(2);

COMMENT ON COLUMN wf.ttipo_estado.control_tiempo
IS 'Control para verficar si se controlara los procesos en estados por tiempo.';

  
ALTER TABLE wf.ttipo_estado
  ADD COLUMN tiempo_estado INTERVAL;
  
COMMENT ON COLUMN wf.ttipo_estado.tiempo_estado
IS 'Tiempo que estara el proceso en un estado.';

ALTER TABLE wf.ttipo_estado
  ADD COLUMN tipo_accion VARCHAR;

COMMENT ON COLUMN wf.ttipo_estado.tipo_accion
IS 'Tipo de accion a ejecutar cuando el tiempo del proceso concluya.';

ALTER TABLE wf.ttipo_estado
  ADD COLUMN funcion_cambio_estado VARCHAR;

COMMENT ON COLUMN wf.ttipo_estado.funcion_cambio_estado
IS 'Funcion a ejecutar si el tipo de accion es cambio automatico de estado.';

ALTER TABLE wf.ttipo_estado
  ADD COLUMN id_funcionario_cc integer[];

 COMMENT ON COLUMN wf.ttipo_estado.id_funcionario_cc
IS 'Lista de funcionarios a los que se enviara un correo de notificacion, de los procesos que concluyeron su tiempo limite.';

ALTER TABLE wf.testado_wf
  ADD COLUMN codigo VARCHAR;

COMMENT ON COLUMN wf.testado_wf.codigo
IS 'Codigo de evaluacion para controles.';

/*****************************F-SCP-BVP-WF-0-03/04/2020*************/

/*****************************I-SCP-BVP-WF-0-15/04/2020*************/
ALTER TABLE wf.testado_wf
  RENAME COLUMN codigo TO codigo_wf_control;

COMMENT ON COLUMN wf.testado_wf.codigo_wf_control
IS 'Codigo_wf de evaluacion para controles.';
/*****************************F-SCP-BVP-WF-0-15/04/2020*************/
