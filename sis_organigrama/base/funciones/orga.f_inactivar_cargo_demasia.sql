CREATE OR REPLACE FUNCTION orga.f_inactivar_cargo_demasia (
)
RETURNS void AS
$body$
/**************************************************************************
SISTEMA:	SISTEMA ORGANIGRAMA
FUNCION: alm.f_get_saldo_fisico_item1
DESCRIPCION: Función que devuelve la cantidad existente del item con ID: p_id_item
RETORNA:	Devuelve el valor de la cantidad disponible para el item: p_id_item
AUTOR: franklin espinoza
FECHA:	19/11/2019

***************************************************************************/

DECLARE

v_nombre_funcion	text;
v_resp	varchar;
v_item_saldo numeric;
v_resultado record;
v_consulta varchar;

v_cargos	record;
v_cargo	record;
v_id_temporal_cargo integer;
v_contador integer=0;
BEGIN

for v_cargos in select tc.nombre, count(tc.nombre) as cantidad
from orga.ttemporal_cargo tc
where tc.estado = 'activo'
group by tc.nombre
having count(tc.nombre)>1 loop
select max(tc.id_temporal_cargo)
into v_id_temporal_cargo
from orga.ttemporal_cargo tc
where tc.nombre = v_cargos.nombre;

for v_cargo in select tc.id_temporal_cargo, tc.estado, tc.nombre
from orga.ttemporal_cargo tc
where tc.nombre = v_cargos.nombre loop
v_contador = v_contador + 1;
if v_cargo.estado = 'activo' and v_id_temporal_cargo != v_cargo.id_temporal_cargo then
update orga.ttemporal_cargo set
estado_reg	= 'inactivo',
estado = 'inactivo'
where id_temporal_cargo = v_cargo.id_temporal_cargo;
raise notice '-------------------------------------';
raise notice 'contador: %', v_contador;
raise notice 'nombre: %, mayor: %, actual: %, estado: %',v_cargos.nombre, v_id_temporal_cargo, v_cargo.id_temporal_cargo, v_cargo.estado;
end if;
end loop;
end loop;

EXCEPTION
WHEN OTHERS THEN
v_resp='';
v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;