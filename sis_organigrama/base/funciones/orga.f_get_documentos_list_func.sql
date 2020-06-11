CREATE OR REPLACE FUNCTION orga.f_get_documentos_list_func (
  p_id_funcionario integer,
  documentos varchar
)
RETURNS json AS
$body$
/**************************************************************************
 SISTEMA:		Organigrama
 FUNCION: 		orga.f_get_documentos_list_func
 DESCRIPCION:   Funcion que retorna el json de los documentos de un funcionario
 AUTOR: 		Franklin Espinonza Alvarez
 FECHA:	        02-04-2018 15:45:34
 COMENTARIOS:
***************************************************************************/

DECLARE

	v_parametros           	record;
	v_archivo				        record;
	v_resp		              varchar;
	v_nombre_funcion        text;
  v_valores				        record;
	v_documentos_list			  json;

BEGIN

    v_nombre_funcion = 'orga.f_get_documentos_list_func';

    WITH archivos AS (
    	select ta.id_tipo_archivo,
        ta.id_archivo,
        tta.codigo
        from param.tarchivo ta
        inner join param.ttipo_archivo tta on tta.id_tipo_archivo = ta.id_tipo_archivo
        where ta.id_tabla = p_id_funcionario and tta.id_tipo_archivo = any (string_to_array(documentos, ',')::integer[]) AND ta.id_archivo_fk is null
    	order by tta.id_tipo_archivo asc
	)
	SELECT
		TO_JSON(ROW_TO_JSON(archivosData) :: TEXT) #>> '{}' AS json
        into v_documentos_list
    FROM (
           SELECT
             (
               SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(t_archivos))) as files
               FROM
                 (
                   SELECT fil.codigo,
                     (
                       SELECT string_to_array(pxp.list(ROW_TO_JSON(t_campos)::varchar),',') as campos
                       FROM
                         (
                           select
                           --tfta.nombre as clave,
                           tfva.valor
                           from param.tfield_tipo_archivo tfta
                           inner join param.tfield_valor_archivo tfva on tfva.id_field_tipo_archivo = tfta.id_field_tipo_archivo and tfva.id_archivo = fil.id_archivo
                           where tfta.id_tipo_archivo = fil.id_tipo_archivo
                         ) t_campos
                     )
                   FROM archivos fil
                 ) t_archivos
             )
         ) archivosData;

    return v_documentos_list;
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