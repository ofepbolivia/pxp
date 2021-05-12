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