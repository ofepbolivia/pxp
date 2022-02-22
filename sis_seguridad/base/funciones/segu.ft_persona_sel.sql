CREATE OR REPLACE FUNCTION segu.ft_persona_sel (
  par_administrador integer,
  par_id_usuario integer,
  par_tabla varchar,
  par_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 FUNCION: 		segu.ft_persona_sel
 DESCRIPCION:   consultas de persona
 AUTOR: 		KPLIAN(jrr)
 FECHA:
 COMENTARIOS:
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCION:	actualizacion a nueva version xph
 AUTOR:		KPLIAN(jrr)
 FECHA:		08/01/11
***************************************************************************/

DECLARE


v_consulta    varchar;
v_parametros  record;
v_nombre_funcion   text;
v_mensaje_error    text;
v_resp varchar;


/*

'filtro'
'ordenacion'
'dir_ordenacion'
'puntero'
'cantidad'

*/

BEGIN

     v_parametros:=pxp.f_get_record(par_tabla);
     v_nombre_funcion:='segu.ft_persona_sel';


 /*******************************
 #TRANSACCION:  SEG_PERSON_SEL
 #DESCRIPCION:	Selecciona Personas
 #AUTOR:		KPLIAN(jrr)
 #FECHA:		08/01/11
***********************************/
     if(par_transaccion='SEG_PERSON_SEL')then

          --  Se arma la consulta de personas
          BEGIN

               v_consulta:='SELECT
                              p.id_persona,
                              p.ap_materno,
                              p.ap_paterno,
                              p.nombre,
                              p.nombre_completo1,
                              p.nombre_completo2,
                              p.ci,
                              p.correo,
                              p.celular1,
                              p.num_documento,
                              p.telefono1,
                              p.telefono2,
                              p.celular2,
                              per.fecha_nacimiento,
                              per.genero,
                              per.direccion,
                              td.nombre as tipo_documento,
                              per.expedicion,
                              per.id_tipo_doc_identificacion,
                              per.nacionalidad,
                              per.id_lugar,
                              per.discapacitado,
                              tl.nombre as nombre_lugar
                          FROM segu.vpersona p
                          inner join segu.tpersona per on per.id_persona = p.id_persona
                          left join segu.ttipo_documento td on td.id_tipo_documento = per.id_tipo_doc_identificacion
                          left join param.tlugar tl on tl.id_lugar = per.id_lugar
                          WHERE ';
               v_consulta:=v_consulta||v_parametros.filtro;
               v_consulta:=v_consulta || ' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
               --raise exception '%',v_consulta;
               return v_consulta;


         END;




/*******************************
 #TRANSACCION:  SEG_PERSON_CONT
 #DESCRIPCION:	Cuenta Personas
 #AUTOR:		KPLIAN(jrr)
 #FECHA:		08/01/11
***********************************/

     elsif(par_transaccion='SEG_PERSON_CONT')then

          --se arma la sonsulta que cuenta personas
          BEGIN

               v_consulta:='select count(p.id_persona)
               				FROM segu.vpersona p
                          	inner join segu.tpersona per on per.id_persona = p.id_persona
                            inner join segu.ttipo_documento td on td.id_tipo_documento = per.id_tipo_doc_identificacion
                          	left join param.tlugar tl on tl.id_lugar = per.id_lugar
                            WHERE ';
               v_consulta:=v_consulta||v_parametros.filtro;
               return v_consulta;
         END;


 /*******************************
 #TRANSACCION:  SEG_PERSONMIN_SEL
 #DESCRIPCION:	Selecciona Personas + fotografia
 #AUTOR:		KPLIAN(rac)
 #FECHA:		08/01/11
***********************************/
     elsif(par_transaccion='SEG_PERSONMIN_SEL')then

          --  Se arma la consulta de personas
          BEGIN

               v_consulta:='SELECT
                             p.id_persona,
                             p.apellido_materno AS ap_materno,
                             p.apellido_paterno AS ap_paterno,
                             p.nombre,
                             per.nombre_completo1,
                             per.nombre_completo2,
                             /*(((COALESCE(p.nombre, '''' ::character varying) ::text || '' '' ::text) ||
                              COALESCE(p.apellido_paterno, '''' ::character varying) ::text) || '' ''
                               ::text) || COALESCE(p.apellido_materno, '''' ::character varying)
                                ::text AS nombre_completo1,
                             (((COALESCE(p.apellido_paterno, '''' ::character varying) ::text || '' ''
                              ::text) || COALESCE(p.apellido_materno, '''' ::character varying) ::text
                              ) || '' '' ::text) || COALESCE(p.nombre, '''' ::character varying) ::text
                               AS nombre_completo2,*/
                             p.ci,
                             p.correo,
                             p.celular1,
                             p.num_documento,
                             p.telefono1,
                             p.telefono2,
                             p.celular2,
                             p.extension,
                             td.nombre as tipo_documento,
                             p.expedicion,
                             p.foto,

                             p.direccion,
							 p.carnet_discapacitado,
                             p.nacionalidad,
                             p.genero,
                             p.estado_civil,
                             p.discapacitado,
                             p.fecha_nacimiento,
                             lu.id_lugar,
                             lu.nombre AS lugar,
                             p.id_tipo_doc_identificacion
                          FROM segu.tpersona p
                          left join param.tlugar lu on lu.id_lugar = p.id_lugar
                          inner join segu.vpersona per on per.id_persona = p.id_persona
                          left join segu.ttipo_documento td on td.id_tipo_documento = p.id_tipo_doc_identificacion
                           WHERE ';


               v_consulta:=v_consulta||v_parametros.filtro;
               v_consulta:=v_consulta || ' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
               --raise exception '%',v_consulta;
               return v_consulta;


         END;
/*******************************
 #TRANSACCION:  SEG_OPERFOT_SEL
 #DESCRIPCION:	Selecciona Personas + fotografia
 #AUTOR:		KPLIAN(rac)
 #FECHA:		23/04/13
***********************************/
     elsif(par_transaccion='SEG_OPERFOT_SEL')then

          --  Se arma la consulta de personas
          BEGIN

              /*v_consulta:='SELECT p.id_persona,
                             p.extension,
                             p.foto
                          FROM segu.tpersona p
                          inner join segu.tusuario u on u.id_persona = p.id_persona
                          WHERE u.id_usuario='||v_parametros.id_usuario;*/
                --Cambio Alan 15/11/2019
				          v_consulta='select  per.id_persona,
                					            tar.nombre_archivo,
                                      tar.extension
                              from param.tarchivo tar
                                    inner join orga.tfuncionario funcio on funcio.id_funcionario=tar.id_tabla and tar.id_tipo_archivo = 10
                                    inner join segu.tpersona per on per.id_persona=funcio.id_persona
                                    inner join segu.tusuario usu on usu.id_persona= per.id_persona
                               where usu.id_usuario='||v_parametros.id_usuario;

                raise notice '%',v_consulta;

                return v_consulta;


         END;

/*******************************
 #TRANSACCION:  SEG_PERSONMIN_CONT
 #DESCRIPCION:	Cuenta Personas con foto
 #AUTOR:		KPLIAN(jrr)
 #FECHA:		08/01/11
***********************************/

     elsif(par_transaccion='SEG_PERSONMIN_CONT')then


          --se arma la sonsulta que cuenta personas
          BEGIN

               v_consulta:='select count(p.id_persona)
               from segu.tpersona p
               left join param.tlugar lu on lu.id_lugar = p.id_lugar
               inner join segu.vpersona per on per.id_persona = p.id_persona
               where ';
               v_consulta:=v_consulta||v_parametros.filtro;
               return v_consulta;
         END;

	/*******************************
     #TRANSACCION:  SEG_PER_DOC_IDE_SEL
     #DESCRIPCION:	Listar los documentos de Identificación Persona.
     #AUTOR:		franklin.espinoza
     #FECHA:		12/11/2018
    ***********************************/
     elsif(par_transaccion='SEG_PER_DOC_IDE_SEL')then


          --se arma la sonsulta que cuenta personas
          BEGIN

               v_consulta:='select
               	td.id_tipo_documento as id_tipo_doc_identificacion,
               	td.nombre,
               	td.descripcion,
               	td.fecha_reg::date,
               	td.estado_reg
               from segu.ttipo_documento td
               where ';
               v_consulta:=v_consulta||v_parametros.filtro;
               v_consulta:=v_consulta || ' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
               raise notice 'v_consulta: %', v_consulta;
               return v_consulta;
         END;


     /*******************************
       #TRANSACCION:  SEG_PERSONV2_SEL
       #DESCRIPCION:	Selecciona Personas
       #AUTOR:		Maylee Perez Pastor
       #FECHA:		01/04/2020
      ***********************************/
           elsif(par_transaccion='SEG_PERSONV2_SEL')then

                --  Se arma la consulta de personas
                BEGIN

                     v_consulta:='SELECT
                                    p.id_persona,
                                    p.ap_materno,
                                    p.ap_paterno,
                                    p.nombre,
                                    p.nombre_completo1,
                                    p.nombre_completo2,
                                    p.ci,
                                    p.correo,
                                    p.celular1,
                                    p.num_documento,
                                    p.telefono1,
                                    p.telefono2,
                                    p.celular2,
                                    per.fecha_nacimiento,
                                    per.genero,
                                    per.direccion,
                                    td.nombre as tipo_documento,
                                    per.expedicion,
                                    per.id_tipo_doc_identificacion,
                                    per.nacionalidad,
                                    per.id_lugar,
                                    per.discapacitado,
                                    tl.nombre as nombre_lugar,

                                    per.fax,
                                    per.pag_web,
                                    per.observaciones

                                FROM segu.vpersona p
                                inner join segu.tpersona per on per.id_persona = p.id_persona
                                inner join segu.ttipo_documento td on td.id_tipo_documento = per.id_tipo_doc_identificacion
                                left join param.tlugar tl on tl.id_lugar = per.id_lugar
                                WHERE ';
                     v_consulta:=v_consulta||v_parametros.filtro;
                     v_consulta:=v_consulta || ' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                     --raise exception '%',v_consulta;
                     return v_consulta;


               END;




      /*******************************
       #TRANSACCION:  SEG_PERSONV2_CONT
       #DESCRIPCION:	Cuenta Personas
       #AUTOR:		Maylee Perez Pastor
       #FECHA:		01/04/2020
      ***********************************/

           elsif(par_transaccion='SEG_PERSONV2_CONT')then

                --se arma la sonsulta que cuenta personas
                BEGIN

                     v_consulta:='select count(p.id_persona)
                                  FROM segu.vpersona p
                                  inner join segu.tpersona per on per.id_persona = p.id_persona
                                  inner join segu.ttipo_documento td on td.id_tipo_documento = per.id_tipo_doc_identificacion
                                  left join param.tlugar tl on tl.id_lugar = per.id_lugar
                                  WHERE ';
                     v_consulta:=v_consulta||v_parametros.filtro;
                     return v_consulta;
             END;


     else
         raise exception 'No existe la opcion';

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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;