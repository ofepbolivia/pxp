create function orga.f_get_presupuesto_uo(p_id_uo integer) returns integer
	language plpgsql
as $$
/**************************************************************************
 SISTEMA:		Sistema Organigrama
 FUNCION: 		orga.f_get_arbol_padre_uo
 DESCRIPCION:   Funcion que recupera los padres de un Nodo.
 AUTOR: 		(franklin.espinoza)
 FECHA:	        17-06-2019 15:15:26
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_resp		            varchar='';
	v_nombre_funcion        text;
	v_record 				record;
    v_record_ids			record;
    v_cadena_ids			varchar = '';
    v_arbol_padre			varchar = '';
    v_presupuesta 			varchar = '';
    v_id_uo					integer = -1;
BEGIN

    v_nombre_funcion = 'orga.f_get_presupuesto_uo';

    for v_record_ids in select teo.id_uo_padre, teo.id_uo_hijo from orga.testructura_uo teo where teo.id_uo_hijo = p_id_uo loop

    	select tu.presupuesta
        into v_presupuesta
        from orga.tuo tu
        where tu.id_uo = p_id_uo;
		--raise notice 'v_presupuesta: %, %, %', v_presupuesta, v_record_ids.id_uo_padre, v_record_ids.id_uo_hijo;
        if v_presupuesta = 'si' then
        	return p_id_uo;
        end if;

    	v_id_uo = orga.f_get_presupuesto_uo(v_record_ids.id_uo_padre);

    end loop;

    RETURN v_id_uo;

EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$$;

alter function orga.f_get_presupuesto_uo(integer) owner to postgres;

