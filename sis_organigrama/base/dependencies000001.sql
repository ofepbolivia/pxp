/********************************************I-DEP-RAC-ORGA-0-31/12/2012********************************************/

--
-- Definition for index fk_tdepto__id_subsistema (OID = 308873) : 
--
ALTER TABLE ONLY orga.tdepto
    ADD CONSTRAINT fk_tdepto__id_subsistema
    FOREIGN KEY (id_subsistema) REFERENCES segu.tsubsistema(id_subsistema);
--
-- Definition for index fk_tusuario_uo__id_uo (OID = 308908) : 
--
ALTER TABLE ONLY orga.tusuario_uo
    ADD CONSTRAINT fk_tusuario_uo__id_uo
    FOREIGN KEY (id_uo) REFERENCES orga.tuo(id_uo);
--
-- Definition for index fk_tusuario_uo__id_ususario (OID = 308913) : 
--
ALTER TABLE ONLY orga.tusuario_uo
    ADD CONSTRAINT fk_tusuario_uo__id_ususario
    FOREIGN KEY (id_usuario) REFERENCES segu.tusuario(id_usuario);
--
-- Definition for index fk_tfuncionario__id_persona (OID = 308948) : 
--
ALTER TABLE ONLY orga.tfuncionario
    ADD CONSTRAINT fk_tfuncionario__id_persona
    FOREIGN KEY (id_persona) REFERENCES segu.tpersona(id_persona);
--
-- Definition for index fk_tfuncionario__id_usuario_mod (OID = 308953) : 
--
ALTER TABLE ONLY orga.tfuncionario
    ADD CONSTRAINT fk_tfuncionario__id_usuario_mod
    FOREIGN KEY (id_usuario_mod) REFERENCES segu.tusuario(id_usuario);
--
-- Definition for index fk_tfuncionario__id_usuario_reg (OID = 308958) : 
--
ALTER TABLE ONLY orga.tfuncionario
    ADD CONSTRAINT fk_tfuncionario__id_usuario_reg
    FOREIGN KEY (id_usuario_reg) REFERENCES segu.tusuario(id_usuario);
--
-- Definition for index fk_tuo__id_uo_padre (OID = 414043) : 
--
ALTER TABLE ONLY orga.testructura_uo
    ADD CONSTRAINT fk_tuo__id_uo_padre
    FOREIGN KEY (id_uo_padre) REFERENCES orga.tuo(id_uo) ON UPDATE CASCADE;
--
-- Definition for index fk_testructura_uo__id_uo_hijo (OID = 414078) : 
--
ALTER TABLE ONLY orga.testructura_uo
    ADD CONSTRAINT fk_testructura_uo__id_uo_hijo
    FOREIGN KEY (id_uo_hijo) REFERENCES orga.tuo(id_uo) ON UPDATE CASCADE;
--
-- Definition for index fk_tuo_functionario__id_uo (OID = 414083) : 
--
ALTER TABLE ONLY orga.tuo_funcionario
    ADD CONSTRAINT fk_tuo_functionario__id_uo
    FOREIGN KEY (id_uo) REFERENCES orga.tuo(id_uo) ON UPDATE CASCADE;
--
-- Definition for index fk_tuo_functionario__id_funcionario (OID = 414088) : 
--
ALTER TABLE ONLY orga.tuo_funcionario
    ADD CONSTRAINT fk_tuo_functionario__id_funcionario
    FOREIGN KEY (id_funcionario) REFERENCES orga.tfuncionario(id_funcionario) ON UPDATE CASCADE;



ALTER TABLE ONLY  orga.tespecialidad
 ADD  CONSTRAINT fk_tespecialidad__id_especialidad_nivel 
      FOREIGN KEY (id_especialidad_nivel)
      REFERENCES orga.tespecialidad_nivel (id_especialidad_nivel) 
      MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

--
-- Definition for view vfuncionario (OID = 306686) : 
--
CREATE VIEW orga.vfuncionario AS
SELECT funcio.id_funcionario, person.nombre_completo1 AS desc_funcionario1,
    person.nombre_completo2 AS desc_funcionario2, person.num_documento AS
    num_doc, person.ci, funcio.codigo, funcio.estado_reg
FROM (orga.tfuncionario funcio JOIN segu.vpersona person ON ((funcio.id_persona
    = person.id_persona)));

--
-- Definition for view vfuncionario_cargo (OID = 306690) : 
--
CREATE VIEW orga.vfuncionario_cargo AS
SELECT uof.id_uo_funcionario, funcio.id_funcionario,
    person.nombre_completo1 AS desc_funcionario1, person.nombre_completo2
    AS desc_funcionario2, uo.id_uo, uo.nombre_cargo, uof.fecha_asignacion,
    uof.fecha_finalizacion, person.num_documento AS num_doc, person.ci,
    funcio.codigo, funcio.email_empresa, funcio.estado_reg AS
    estado_reg_fun, uof.estado_reg AS estado_reg_asi
FROM (((orga.tfuncionario funcio JOIN segu.vpersona person ON
    ((funcio.id_persona = person.id_persona))) JOIN orga.tuo_funcionario uof ON
    ((uof.id_funcionario = funcio.id_funcionario))) JOIN orga.tuo uo ON
    ((uo.id_uo = uof.id_uo)));







/********************************************F-DEP-RAC-ORGA-0-31/12/2012********************************************/


/********************************************I-DEP-JRR-ORGA-0-9/01/2014********************************************/
ALTER TABLE orga.tescala_salarial
  ADD CONSTRAINT fk__tescala_salarial__id_categoria_salarial FOREIGN KEY (id_categoria_salarial)
    REFERENCES orga.tcategoria_salarial(id_categoria_salarial)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo
  ADD CONSTRAINT fk__tcargo__id_escala_salarial FOREIGN KEY (id_escala_salarial)
    REFERENCES orga.tescala_salarial(id_escala_salarial)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE orga.tcargo
  ADD CONSTRAINT fk__tcargo__id_tipo_contrato FOREIGN KEY (id_tipo_contrato)
    REFERENCES orga.ttipo_contrato(id_tipo_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo
  ADD CONSTRAINT fk__tcargo__id_lugar FOREIGN KEY (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.ttemporal_cargo
  ADD CONSTRAINT fk__ttemporal_cargo_id_temporal_jerarquia_aprobacion FOREIGN KEY (id_temporal_jerarquia_aprobacion)
    REFERENCES orga.ttemporal_jerarquia_aprobacion(id_temporal_jerarquia_aprobacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo
  ADD CONSTRAINT fk__tcargo__id_temporal_cargo FOREIGN KEY (id_temporal_cargo)
    REFERENCES orga.ttemporal_cargo(id_temporal_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo_centro_costo
  ADD CONSTRAINT fk__tcargo_centro_costo__id_cargo FOREIGN KEY (id_cargo)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo_centro_costo
  ADD CONSTRAINT fk__tcargo_centro_costo__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo_centro_costo
  ADD CONSTRAINT fk__tcargo_centro_costo__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo_presupuesto
  ADD CONSTRAINT fk__tcargo_presupuesto__id_cargo FOREIGN KEY (id_cargo)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE orga.tcargo_presupuesto
  ADD CONSTRAINT fk__tcargo_presupuesto__id_gestion FOREIGN KEY (id_gestion)
    REFERENCES param.tgestion(id_gestion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo_presupuesto
  ADD CONSTRAINT fk__tcargo_presupuesto__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 

ALTER TABLE orga.tuo
  ADD CONSTRAINT fk__tuo__id_nivel_organizacional FOREIGN KEY (id_nivel_organizacional)
    REFERENCES orga.tnivel_organizacional(id_nivel_organizacional)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE; 


ALTER TABLE orga.toficina
  ADD CONSTRAINT fk__toficina__id_lugar FOREIGN KEY (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo
  ADD CONSTRAINT fk__tcargo__id_oficina FOREIGN KEY (id_oficina)
    REFERENCES orga.toficina(id_oficina)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tcargo
  ADD CONSTRAINT fk__tcargo__id_uo FOREIGN KEY (id_uo)
    REFERENCES orga.tuo(id_uo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
CREATE OR REPLACE VIEW orga.vfuncionario_cargo(
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi)
AS
  SELECT uof.id_uo_funcionario,
         funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         uo.id_uo,
         uo.nombre_cargo,
         uof.fecha_asignacion,
         uof.fecha_finalizacion,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.email_empresa,
         funcio.estado_reg AS estado_reg_fun,
         uof.estado_reg AS estado_reg_asi
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
       JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
        funcio.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
  where uof.estado_reg = 'activo';
  
ALTER TABLE orga.tfuncionario_cuenta_bancaria
  ADD CONSTRAINT fk__tfuncionario_cuenta_bancaria__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
ALTER TABLE orga.tfuncionario_cuenta_bancaria
  ADD CONSTRAINT fk__tfuncionario_cuenta_bancaria__id_institucion FOREIGN KEY (id_institucion)
    REFERENCES param.tinstitucion(id_institucion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/********************************************F-DEP-JRR-ORGA-0-9/01/2014********************************************/

/********************************************I-DEP-JRR-ORGA-0-24/01/2014********************************************/

ALTER TABLE orga.tuo_funcionario
  ADD CONSTRAINT fk__tuo_funcionario__id_cargo FOREIGN KEY (id_cargo)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
/********************************************F-DEP-JRR-ORGA-0-24/01/2014********************************************/

/*********************************I-DEP-JRR-ORGA-0-25/04/2014***********************************/
select pxp.f_insert_testructura_gui ('ESTORG.2.1.2.1', 'ESTORG.2.1.2');
select pxp.f_insert_testructura_gui ('FUNCIO.2.1', 'FUNCIO.2');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'ESTORG.2.1.2.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('SEG_UPFOTOPER_MOD', 'FUNCIO.2.1', 'no');

/*********************************F-DEP-JRR-ORGA-0-25/04/2014***********************************/


/*********************************I-DEP-RAC-ORGA-0-25/05/2014***********************************/


ALTER TABLE orga.tinterinato
  ADD CONSTRAINT tinterinato_ed_usuario_fk FOREIGN KEY (id_usuario_reg)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE orga.tinterinato
  ADD CONSTRAINT fk_tinterinato__id_usuario_mod FOREIGN KEY (id_usuario_mod)
    REFERENCES segu.tusuario(id_usuario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE orga.tinterinato
  ADD CONSTRAINT fk_tinterinato__id_cargo_titular FOREIGN KEY (id_cargo_titular)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
--------------- SQL ---------------

ALTER TABLE orga.tinterinato
  ADD CONSTRAINT fk_tinterinato__id_cargo_suplente FOREIGN KEY (id_cargo_suplente)
    REFERENCES orga.tcargo(id_cargo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/*********************************F-DEP-RAC-ORGA-0-25/05/2014***********************************/


/*****************************I-DEP-RAC-ORGA-0-31/07/2014*************/
--------------- SQL ---------------

CREATE OR REPLACE VIEW orga.vfuncionario_cargo(
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo)
AS
  SELECT uof.id_uo_funcionario,
         funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         uo.id_uo,
         uo.nombre_cargo,
         uof.fecha_asignacion,
         uof.fecha_finalizacion,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.email_empresa,
         funcio.estado_reg AS estado_reg_fun,
         uof.estado_reg AS estado_reg_asi,
         car.id_cargo,
         car.nombre AS descripcion_cargo,
         car.codigo AS cargo_codigo
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
       JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
        funcio.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
       JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
  WHERE uof.estado_reg::text = 'activo' ::text;


/*****************************F-DEP-RAC-ORGA-0-31/07/2014*************/

/*********************************I-DEP-JRR-ORGA-0-31/07/2014***********************************/

ALTER TABLE orga.toficina_cuenta
  ADD CONSTRAINT fk_toficina_cuenta__id_oficina FOREIGN KEY (id_oficina)
    REFERENCES orga.toficina(id_oficina)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
    
    
/*********************************F-DEP-JRR-ORGA-0-31/07/2014***********************************/



/*********************************I-DEP-RAC-ORGA-0-05/08/2014***********************************/
select pxp.f_insert_testructura_gui ('OFICI.1', 'OFICI');
select pxp.f_insert_testructura_gui ('ASIGINGEN', 'PROCRH');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_INS', 'OFICI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_MOD', 'OFICI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_ELI', 'OFICI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_OFCU_SEL', 'OFICI.1', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_INS', 'Interinos', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_SEL', 'Interinos', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'Interinos', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_MOD', 'Interinos', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_ELI', 'Interinos', 'no');
select pxp.f_insert_tprocedimiento_gui ('RH_FUNCIOCAR_SEL', 'ASIGINGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_INS', 'ASIGINGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_MOD', 'ASIGINGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_ELI', 'ASIGINGEN', 'no');
select pxp.f_insert_tprocedimiento_gui ('OR_INT_SEL', 'ASIGINGEN', 'no');

/*********************************F-DEP-RAC-ORGA-0-05/08/2014***********************************/


/*********************************I-DEP-RAC-ORGA-0-19/08/2014***********************************/
--------------- SQL ---------------
CREATE OR REPLACE VIEW orga.vfuncionario_cargo(
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo)
AS
  SELECT uof.id_uo_funcionario,
         funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         uo.id_uo,
         uo.nombre_cargo,
         uof.fecha_asignacion,
         uof.fecha_finalizacion,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.email_empresa,
         funcio.estado_reg AS estado_reg_fun,
         uof.estado_reg AS estado_reg_asi,
         car.id_cargo,
         car.nombre AS descripcion_cargo,
         car.codigo AS cargo_codigo,
         uo.nombre_unidad
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
       JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
        funcio.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
       JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
  WHERE uof.estado_reg::text = 'activo' ::text;

/*********************************F-DEP-RAC-ORGA-0-19/08/2014***********************************/




/*********************************I-DEP-RAC-ORGA-0-09/10/2014***********************************/


CREATE OR REPLACE VIEW orga.vfuncionario_persona
AS
  SELECT funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.estado_reg,
         funcio.email_empresa,
         funcio.interno,
         funcio.telefono_ofi,
         person.celular1,
         person.celular2,
         person.telefono1,
         person.telefono2,
  		 person.correo,
         person.id_persona
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona;
       
/*********************************F-DEP-RAC-ORGA-0-09/10/2014***********************************/

/*********************************I-DEP-JRR-ORGA-0-05/03/2015***********************************/

CREATE TRIGGER ttemporal_cargo_tr AFTER UPDATE 
ON orga.ttemporal_cargo FOR EACH ROW 
EXECUTE PROCEDURE orga.f_tr_temporal_cargo();


CREATE TRIGGER tcargo_tr AFTER UPDATE 
ON orga.tcargo FOR EACH ROW 
EXECUTE PROCEDURE orga.f_tr_cargo();



/*********************************F-DEP-JRR-ORGA-0-05/03/2015***********************************/

/*********************************I-DEP-JRR-ORGA-0-16/03/2017***********************************/
DROP TRIGGER tcargo_tr ON orga.tcargo;

CREATE TRIGGER tcargo_tr
  AFTER INSERT
  ON orga.tcargo FOR EACH ROW
  EXECUTE PROCEDURE orga.f_tr_cargo();

/*********************************F-DEP-JRR-ORGA-0-16/03/2017***********************************/

/*********************************I-DEP-FEA-ORGA-0-31/10/2017***********************************/
CREATE OR REPLACE VIEW orga.vfuncionario_biometrico (
    id_funcionario,
    id_biometrico,
    desc_funcionario1,
    desc_funcionario2,
    num_doc,
    ci,
    codigo,
    estado_reg,
    fecha_ingreso)
AS
 SELECT funcio.id_funcionario,
    funcio.id_biometrico,
    person.nombre_completo1 AS desc_funcionario1,
    person.nombre_completo2 AS desc_funcionario2,
    person.num_documento AS num_doc,
    person.ci,
    funcio.codigo,
    funcio.estado_reg,
    funcio.fecha_ingreso
   FROM orga.tfuncionario funcio
     JOIN segu.vpersona person ON funcio.id_persona = person.id_persona;

/*********************************F-DEP-FEA-ORGA-0-31/10/2017***********************************/

/*********************************I-DEP-FEA-ORGA-0-30/07/2019***********************************/
CREATE OR REPLACE VIEW orga.vfuncionario (
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    num_doc,
    ci,
    codigo,
    estado_reg,
    codigo_rc_iva,
    id_persona)
AS
SELECT funcio.id_funcionario,
    person.nombre_completo1 AS desc_funcionario1,
    person.nombre_completo2 AS desc_funcionario2,
    person.num_documento AS num_doc,
    person.ci,
    funcio.codigo,
    funcio.estado_reg,
    funcio.codigo_rc_iva,
    person.id_persona
FROM orga.tfuncionario funcio
JOIN segu.vpersona person ON funcio.id_persona = person.id_persona;
/*********************************F-DEP-FEA-ORGA-0-30/07/2019***********************************/

/************************************I-DEP-FEA-ORGA-0-06/09/2019*************************************************/
CREATE TRIGGER f_trig_replicacion_testructura_uo
  AFTER INSERT
  ON orga.testructura_uo

FOR EACH ROW
  EXECUTE PROCEDURE sqlserver.f_migrar_testructura_uo();

/************************************F-DEP-FEA-ORGA-0-06/09/2019*************************************************/
/************************************I-DEP-BVP-ORGA-0-25/11/2019*************************************************/
CREATE OR REPLACE VIEW orga.vfuncionario_ultimo_cargo(
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo,
    nombre_unidad)
AS
  SELECT uof.id_uo_funcionario,
         funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         uo.id_uo,
         uo.nombre_cargo,
         uof.fecha_asignacion,
         uof.fecha_finalizacion,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.email_empresa,
         funcio.estado_reg AS estado_reg_fun,
         uof.estado_reg AS estado_reg_asi,
         car.id_cargo,
         car.nombre AS descripcion_cargo,
         car.codigo AS cargo_codigo,
         uo.nombre_unidad
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
       JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
         funcio.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
       JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
  WHERE uof.estado_reg::text = 'activo'::text AND  uof.tipo = 'oficial' 
       and (uof.fecha_asignacion IN (
                                   SELECT max(tuo.fecha_asignacion) AS max
                                   FROM orga.tuo_funcionario tuo
                                   WHERE tuo.tipo::text = 'oficial'::text AND
                                         tuo.estado_reg::text = 'activo'::text
  AND
                                         tuo.id_funcionario =
                                           funcio.id_funcionario
                                   GROUP BY tuo.id_funcionario
        ));
/************************************F-DEP-BVP-ORGA-0-25/1/2019*************************************************/

/************************************I-DEP-BVP-ORGA-0-26/11/2019*************************************************/
CREATE VIEW orga.vmaxfecha_asig_funcionario (
    id_funcionario,
    fecha_asinacion_max)
AS
SELECT tuo.id_funcionario,
    max(tuo.fecha_asignacion) AS fecha_asinacion_max
FROM orga.tuo_funcionario tuo
WHERE tuo.tipo::text = 'oficial'::text AND tuo.estado_reg::text = 'activo'::text
GROUP BY tuo.id_funcionario;

CREATE OR REPLACE VIEW orga.vfuncionario_ultimo_cargo(
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo,
    nombre_unidad,
    lugar_nombre,
    id_lugar,
    id_oficina,
    oficina_nombre,
    oficina_direccion)
AS
  SELECT uof.id_uo_funcionario,
         funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         uo.id_uo,
         uo.nombre_cargo,
         uof.fecha_asignacion,
         uof.fecha_finalizacion,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.email_empresa,
         funcio.estado_reg AS estado_reg_fun,
         uof.estado_reg AS estado_reg_asi,
         car.id_cargo,
         car.nombre AS descripcion_cargo,
         car.codigo AS cargo_codigo,
         uo.nombre_unidad,
         lu.nombre AS lugar_nombre,
         lu.id_lugar,
         of . id_oficina,
         of . nombre AS oficina_nombre,
         of . direccion AS oficina_direccion         
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
       JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
         funcio.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
       JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
       JOIN orga.toficina of ON of . id_oficina = car.id_oficina
       JOIN param.tlugar lu ON lu.id_lugar = of . id_lugar       
       JOIN orga.vmaxfecha_asig_funcionario maxf ON maxf.id_funcionario =
         funcio.id_funcionario
  WHERE uof.estado_reg::text = 'activo'::text AND
        uof.tipo::text = 'oficial'::text AND
        uof.fecha_asignacion = maxf.fecha_asinacion_max;
/************************************F-DEP-BVP-ORGA-0-26/1/2019*************************************************/

/************************************I-DEP-MAY-ORGA-0-20/01/2021*************************************************/
  CREATE OR REPLACE VIEW orga.vfuncionario_cargo_v2(
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo,
    nombre_unidad,
    tipo_funcionario)
AS
  SELECT uof.id_uo_funcionario,
         funcio.id_funcionario,
         person.nombre_completo1 AS desc_funcionario1,
         person.nombre_completo2 AS desc_funcionario2,
         uo.id_uo,
         uo.nombre_cargo,
         uof.fecha_asignacion,
         uof.fecha_finalizacion,
         person.num_documento AS num_doc,
         person.ci,
         funcio.codigo,
         funcio.email_empresa,
         funcio.estado_reg AS estado_reg_fun,
         uof.estado_reg AS estado_reg_asi,
         car.id_cargo,
         car.nombre AS descripcion_cargo,
         car.codigo AS cargo_codigo,
         uo.nombre_unidad,
         uof.tipo AS tipo_funcionario
  FROM orga.tfuncionario funcio
       JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
       JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
         funcio.id_funcionario
       JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
       JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
  WHERE uof.estado_reg::text = 'activo'::text;

/************************************F-DEP-MAY-ORGA-0-20/01/2021*************************************************/

/************************************I-DEP-MAY-ORGA-0-30/04/2021*************************************************/
CREATE VIEW orga.vfuncionario_cargo_lugar_todos (
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo,
    nombre_unidad,
    lugar_nombre,
    id_lugar,
    id_oficina,
    oficina_nombre,
    oficina_direccion)
AS
SELECT uof.id_uo_funcionario,
    funcio.id_funcionario,
    person.nombre_completo1 AS desc_funcionario1,
    person.nombre_completo2 AS desc_funcionario2,
    uo.id_uo,
    uo.nombre_cargo,
    uof.fecha_asignacion,
    uof.fecha_finalizacion,
    person.num_documento AS num_doc,
    person.ci,
    funcio.codigo,
    funcio.email_empresa,
    funcio.estado_reg AS estado_reg_fun,
    uof.estado_reg AS estado_reg_asi,
    car.id_cargo,
    car.nombre AS descripcion_cargo,
    car.codigo AS cargo_codigo,
    uo.nombre_unidad,
    lu.nombre AS lugar_nombre,
    lu.id_lugar,
    of.id_oficina,
    of.nombre AS oficina_nombre,
    of.direccion AS oficina_direccion
FROM orga.tfuncionario funcio
     JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
     JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
         funcio.id_funcionario AND uof.tipo::text = 'oficial'::text
     JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
     JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
     JOIN orga.toficina of ON of.id_oficina = car.id_oficina
     JOIN param.tlugar lu ON lu.id_lugar = of.id_lugar
WHERE car.estado_reg::text = 'activo'::text AND uof.estado_reg::text =
    'activo'::text AND uof.estado_funcional::text = 'activo'::text
ORDER BY uof.fecha_reg DESC;

ALTER VIEW orga.vfuncionario_cargo_lugar_todos
  OWNER TO postgres;
/************************************F-DEP-MAY-ORGA-0-30/04/2021*************************************************/

/************************************I-DEP-MAY-ORGA-0-19/05/2021*************************************************/
DROP VIEW orga.vfuncionario_cargo_lugar_todos;

CREATE VIEW orga.vfuncionario_cargo_lugar_todos (
    id_uo_funcionario,
    id_funcionario,
    desc_funcionario1,
    desc_funcionario2,
    id_uo,
    nombre_cargo,
    fecha_asignacion,
    fecha_finalizacion,
    num_doc,
    ci,
    codigo,
    email_empresa,
    estado_reg_fun,
    estado_reg_asi,
    id_cargo,
    descripcion_cargo,
    cargo_codigo,
    nombre_unidad,
    lugar_nombre,
    id_lugar,
    id_oficina,
    oficina_nombre,
    oficina_direccion)
AS
SELECT uof.id_uo_funcionario,
    funcio.id_funcionario,
    person.nombre_completo1 AS desc_funcionario1,
    person.nombre_completo2 AS desc_funcionario2,
    uo.id_uo,
    uo.nombre_cargo,
    uof.fecha_asignacion,
    uof.fecha_finalizacion,
    person.num_documento AS num_doc,
    person.ci,
    funcio.codigo,
    funcio.email_empresa,
    funcio.estado_reg AS estado_reg_fun,
    uof.estado_reg AS estado_reg_asi,
    car.id_cargo,
    car.nombre AS descripcion_cargo,
    car.codigo AS cargo_codigo,
    uo.nombre_unidad,
    lu.nombre AS lugar_nombre,
    lu.id_lugar,
    of.id_oficina,
    of.nombre AS oficina_nombre,
    of.direccion AS oficina_direccion
FROM orga.tfuncionario funcio
     JOIN segu.vpersona person ON funcio.id_persona = person.id_persona
     JOIN orga.tuo_funcionario uof ON uof.id_funcionario =
         funcio.id_funcionario AND uof.tipo::text = 'oficial'::text
     JOIN orga.tuo uo ON uo.id_uo = uof.id_uo
     JOIN orga.tcargo car ON car.id_cargo = uof.id_cargo
     JOIN orga.toficina of ON of.id_oficina = car.id_oficina
     JOIN param.tlugar lu ON lu.id_lugar = of.id_lugar
WHERE uof.estado_reg::text = 'activo'::text
ORDER BY uof.fecha_reg DESC;

ALTER VIEW orga.vfuncionario_cargo_lugar_todos
  OWNER TO postgres;
/************************************F-DEP-MAY-ORGA-0-19/05/2021*************************************************/

/************************************I-DEP-FEA-ORGA-0-22/07/2021*************************************************/
CREATE VIEW orga.vplantilla_contrato_rrhh (
    id_uo_funcionario,
    id_funcionario,
    id_uo,
    id_cargo,
    numero_contrato,
    empleado,
    ci,
    expedicion,
    cargo,
    fecha_inicio,
    fecha_fin,
    haber_basico,
    haber_basico_literal,
    ciudad,
    item,
    herederos,
    periodo,
    nombre_representante,
    cargo_representante,
    numero_resolucion,
    fecha_resolucion)
AS
SELECT uofun.id_uo_funcionario,
    uofun.id_funcionario,
    uofun.id_uo,
    uofun.id_cargo,
    uofun.nro_documento_asignacion AS numero_contrato,
    initcap(fun.desc_funcionario1)::character varying AS empleado,
    fun.ci,
    per.expedicion,
    car.nombre AS cargo,
    pxp.f_fecha_literal(uofun.fecha_asignacion) AS fecha_inicio,
    pxp.f_fecha_literal(COALESCE(uofun.fecha_finalizacion, '9999-12-31'::date)) AS fecha_fin,
    to_char(esc.haber_basico, '99,999.99'::text) AS haber_basico,
    pxp.f_convertir_num_a_letra(esc.haber_basico) AS haber_basico_literal,
    lug.nombre AS ciudad,
    car.codigo AS item,
    orga.f_get_herederos(uofun.id_funcionario) AS herederos,
    pxp.f_obtener_literal_periodo(date_part('month'::text, uofun.fecha_asignacion)::integer, NULL::integer) AS periodo,
    orga.f_get_representante_legal(uofun.fecha_asignacion, 'nombre_representante'::character varying) AS nombre_representante,
    orga.f_get_representante_legal(uofun.fecha_asignacion, 'cargo_representante'::character varying) AS cargo_representante,
    orga.f_get_representante_legal(uofun.fecha_asignacion, 'numero_resolucion'::character varying) AS numero_resolucion,
    orga.f_get_representante_legal(uofun.fecha_asignacion, 'fecha_resolucion'::character varying) AS fecha_resolucion
FROM orga.tuo_funcionario uofun
     JOIN orga.tuo uo ON uo.id_uo = uofun.id_uo
     JOIN orga.vfuncionario fun ON fun.id_funcionario = uofun.id_funcionario AND COALESCE(uofun.fecha_finalizacion, '9999-12-31'::date) >= CURRENT_DATE
     JOIN segu.tpersona per ON per.id_persona = fun.id_persona
     JOIN orga.tcargo car ON car.id_cargo = uofun.id_cargo
     JOIN param.tlugar lug ON lug.id_lugar = car.id_lugar
     JOIN orga.tescala_salarial esc ON esc.id_escala_salarial = car.id_escala_salarial;

ALTER VIEW orga.vplantilla_contrato_rrhh OWNER TO postgres;
/************************************F-DEP-FEA-ORGA-0-22/07/2021*************************************************/