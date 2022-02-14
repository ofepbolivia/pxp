CREATE OR REPLACE FUNCTION orga.f_get_uo_gerencia_area_ope_ofi (
  par_id_uo integer,
  par_id_funcionario integer,
  par_fecha date
)
RETURNS integer AS
$body$
--recupera la gerencia considerando la asignacion oeprativa del funcionario, con prioridad sobre el organigrama
/* 22-09-2021 (maylee.perez)
para que busque oficial el uo hijo si tiene 2 (funcional u oficial) si parametro es funcionario
*/

DECLARE
  	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_consulta				text;
    v_id_uo					integer;
    v_gerencia			varchar;
    v_id_uo_hijo		integer;
    v_nivel				integer;
    v_count_funcionario_ope  integer;
    v_es_gerencia		varchar;
    --(may)
    v_count_id_uo		integer;
BEGIN
  	v_nombre_funcion = 'orga.f_get_uo_gerencia_area_ope_ofi';

    if (par_id_uo is not null) then

        select euo.id_uo_padre, uo.gerencia, euo.id_uo_hijo,ni.numero_nivel, uo.gerencia
        into v_id_uo, v_gerencia, v_id_uo_hijo, v_nivel, v_es_gerencia
        from orga.tuo uo
        inner join orga.testructura_uo euo
        	on euo.id_uo_hijo = uo.id_uo
        inner join orga.tnivel_organizacional ni
        	on ni.id_nivel_organizacional = uo.id_nivel_organizacional
        where euo.id_uo_hijo = par_id_uo;

        if (v_nivel in (2,3,4,6) or v_es_gerencia = 'si') then
        	return par_id_uo;
        else
        	if (v_id_uo = v_id_uo_hijo) then
        		return NULL;
            else
            	return orga.f_get_uo_gerencia_area_ope_ofi(v_id_uo, NULL, NULL);
            end if;
        end if;

    else

        select
          ufo.id_uo
        into
          v_id_uo
        FROM  orga.tuo_funcionario_ope ufo
        WHERE id_funcionario = par_id_funcionario
        and   ufo.estado_reg = 'activo' and
              ufo.fecha_asignacion <= par_fecha and (ufo.fecha_finalizacion is null or ufo.fecha_finalizacion >= par_fecha);



        IF v_id_uo is NULL THEN

          select
             funuo.id_uo
          into
             v_id_uo
          from orga.tuo_funcionario funuo
          where funuo.estado_reg = 'activo' and funuo.id_funcionario = par_id_funcionario and
              funuo.fecha_asignacion <= par_fecha and (funuo.fecha_finalizacion is null or funuo.fecha_finalizacion >= par_fecha);

          --(may)
          select count(funuo.id_uo)
          into v_count_id_uo
          from orga.tuo_funcionario funuo
          where funuo.estado_reg = 'activo' and funuo.id_funcionario = 131 and
          funuo.fecha_asignacion <= par_fecha and (funuo.fecha_finalizacion is null or funuo.fecha_finalizacion >= par_fecha);

          IF (v_count_id_uo > 1)THEN
          		select funuo.id_uo
                into v_id_uo
                from orga.tuo_funcionario funuo
                where funuo.estado_reg = 'activo'
                and funuo.id_funcionario = par_id_funcionario
                and funuo.fecha_asignacion <= par_fecha and (funuo.fecha_finalizacion is null or funuo.fecha_finalizacion >= par_fecha)
              	and funuo.tipo = 'oficial' ;
          END IF;

        end if;

        if (v_id_uo is null)then
        	return -1;
        end if;


        return orga.f_get_uo_gerencia_area_ope_ofi(v_id_uo, NULL, NULL);



    end if;




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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION orga.f_get_uo_gerencia_area_ope_ofi (par_id_uo integer, par_id_funcionario integer, par_fecha date)
  OWNER TO postgres;