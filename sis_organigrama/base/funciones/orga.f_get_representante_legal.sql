CREATE OR REPLACE FUNCTION orga.f_get_representante_legal (
  p_fecha date,
  p_campo varchar
)
RETURNS varchar AS
$body$
DECLARE

v_resp			varchar;
v_campo			varchar;

v_nombre_funcion varchar;

BEGIN

	v_nombre_funcion = 'orga.f_get_representante_legal';
	if p_campo = 'nombre_representante' then
    	select (coalesce(rep.abreviatura_profesion,'Lic') || '. '|| initcap(vf.desc_funcionario1))::varchar
        into v_campo
        from orga.trepresentante_legal rep
        inner join orga.vfuncionario vf on vf.id_funcionario = rep.id_funcionario
        where p_fecha between rep.fecha_ini and coalesce(rep.fecha_fin,'31/12/9999'::date);

    elsif p_campo = 'numero_resolucion' then
    	select rep.nro_resolucion::varchar
        into v_campo
        from orga.trepresentante_legal rep
        where p_fecha between rep.fecha_ini and coalesce(rep.fecha_fin,'31/12/9999'::date);

    elsif p_campo = 'fecha_resolucion' then
    	select pxp.f_fecha_literal(rep.fecha_resolucion)::varchar
        into v_campo
        from orga.trepresentante_legal rep
        where p_fecha between rep.fecha_ini and coalesce(rep.fecha_fin,'31/12/9999'::date);

    elsif p_campo = 'cargo_representante' then
    	select car.nombre::varchar
        into v_campo
        from orga.trepresentante_legal rep
        inner join orga.tuo_funcionario tuo on tuo.id_uo_funcionario = orga.f_get_ultima_asignacion(rep.id_funcionario)
        inner join orga.tcargo car on car.id_cargo = tuo.id_cargo
        where p_fecha between rep.fecha_ini and coalesce(rep.fecha_fin,'31/12/9999'::date);

    end if;


	return v_campo;
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

ALTER FUNCTION orga.f_get_representante_legal (p_fecha date, p_campo varchar) OWNER TO postgres;