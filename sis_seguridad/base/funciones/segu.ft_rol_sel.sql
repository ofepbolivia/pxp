CREATE OR REPLACE FUNCTION segu.ft_rol_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 FUNCION: 		segu.ft_rol_sel
 DESCRIPCION:
 AUTOR: 		KPLIAN(jrr)
 FECHA:
 COMENTARIOS:
***************************************************************************/
DECLARE


v_consulta    varchar;
v_parametros  record;
v_resp                  varchar;
v_nombre_funcion   text;
v_mensaje_error    text;


/*

'filtro'
'ordenacion'
'dir_ordenacion'
'puntero'
'cantidad'

*/

BEGIN

     v_parametros:=pxp.f_get_record(p_tabla);
     v_nombre_funcion:='segu.ft_rol_sel';


     if(p_transaccion='SEG_ROL_SEL')then

          --consulta:=';
          BEGIN

               v_consulta:='SELECT
                            roll.id_rol,
                            roll.descripcion,
                            roll.fecha_reg,
                            roll.estado_reg,
                            roll.rol,
                            roll.id_subsistema,
                            coalesce(subsis.nombre,'' '') as desc_subsis,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            roll.fecha_mod,
                            roll.fecha_reg_hora
                        FROM segu.trol roll
                        LEFT JOIN segu.tusuario usu1 on usu1.id_usuario = roll.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 on usu2.id_usuario = roll.id_usuario_mod
                        LEFT join segu.tsubsistema subsis
                        on subsis.id_subsistema=roll.id_subsistema where roll.estado_reg = ''activo'' AND ';
              v_consulta:=v_consulta||v_parametros.filtro;
               v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

               return v_consulta;


         END;


        elsif(p_transaccion='SEG_ROL_CONT')then

          --consulta:=';
          BEGIN

               v_consulta:='SELECT count(roll.id_rol)
                            FROM segu.trol roll
                            LEFT JOIN segu.tusuario usu1 on usu1.id_usuario = roll.id_usuario_reg
                            LEFT JOIN segu.tusuario usu2 on usu2.id_usuario = roll.id_usuario_mod
                        LEFT JOIN segu.tsubsistema subsis
                        on subsis.id_subsistema=roll.id_subsistema where roll.estado_reg = ''activo'' AND ';
               v_consulta:=v_consulta||v_parametros.filtro;
               return v_consulta;
         END;

       /*******************************
       #TRANSACCION:  SEG_EXPROL_SEL
       #DESCRIPCION:	Listado de gui_rol de un subsistema para exportar
       #AUTOR:		Jaime Rivera Rojas
       #FECHA:		20/12/2012
      ***********************************/


       elseif(p_transaccion='SEG_EXPROL_SEL')then

          --consulta:=';
          BEGIN

               v_consulta:='SELECT
                            ''rol''::varchar,
                            roll.descripcion,
                            roll.rol,
                            coalesce(subsis.codigo,'' '') as desc_codigo,
                            roll.estado_reg
                        FROM segu.trol roll
                        INNER join segu.tsubsistema subsis
                        on subsis.id_subsistema=roll.id_subsistema

                        WHERE roll.id_subsistema = '|| v_parametros.id_subsistema;
               if (v_parametros.todo = 'no') then
               		v_consulta = v_consulta || ' and roll.modificado is null ';
               end if;
               v_consulta = v_consulta || ' order by roll.id_rol ASC';

               return v_consulta;


         END;
            /*******************************
       #TRANSACCION:  SEG_USROL_SEL
       #DESCRIPCION:	Listado de gui_rol de un subsistema para exportar
       #AUTOR:		MMV
       #FECHA:		20/12/2012
      ***********************************/
       elseif(p_transaccion='SEG_USROL_SEL')then

          BEGIN
		  /*Aumentando esta parte para filtrar usuarios que aun tiene fecha de caducidad vigente (Ismael Valdivia 28/01/2019)*/
          /*us.fecha_caducidad >= now()::date*/

          v_consulta:='select  	ts.id_rol,
								p.nombre_completo1 as nombre,
                                COALESCE (car.nombre_cargo,''NO ES FUNCIONARIO'') AS cargo,
                                ro.fecha_reg,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                us.fecha_mod,
                                ro.id_usuario_rol,
                                ro.fecha_reg_hora
								from segu.tusuario us
                                inner join segu.tusuario_rol ro on ro.id_usuario = us.id_usuario and ro.estado_reg = ''activo''
                                inner join segu.trol ts on ts.id_rol =ro.id_rol and ts.estado_reg = ''activo''
                                inner join segu.vpersona p on p.id_persona = us.id_persona

                                /*Aumentando estas condiciones (Ismael Valdivia 28/01/2020)*/
                                left join orga.vfuncionario fun on fun.id_persona = p.id_persona
                                left join orga.vfuncionario_ultimo_cargo car on car.id_funcionario = fun.id_funcionario
                                /******************************/
                                /*Aumentando estas condiciones (Breydi Vasquez 16/03/2021)*/
                                LEFT JOIN segu.tusuario usu1 on usu1.id_usuario = ro.id_usuario_reg
                                LEFT JOIN segu.tusuario usu2 on usu2.id_usuario = ro.id_usuario_mod
                                where us.fecha_caducidad >= now()::date and';

          v_consulta:=v_consulta||v_parametros.filtro;
          v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
		  raise notice 'con %',v_consulta;
          return v_consulta;
       end;
       elsif(p_transaccion='SEG_USROL_CONT')then


          BEGIN
          /*Aumentando esta parte para filtrar usuarios que aun tiene fecha de caducidad vigente (Ismael Valdivia 28/01/2019)*/
          /*us.fecha_caducidad >= now()::date*/

               v_consulta:='select  count(	ts.id_rol)
								from segu.tusuario us
                                inner join segu.tusuario_rol ro on ro.id_usuario = us.id_usuario and ro.estado_reg = ''activo''
                                inner join segu.trol ts on ts.id_rol =ro.id_rol and ts.estado_reg = ''activo''
                                inner join segu.vpersona p on p.id_persona = us.id_persona

                                /*Aumentando estas condiciones (Ismael Valdivia 28/01/2020)*/
                                left join orga.vfuncionario fun on fun.id_persona = p.id_persona
                                left join orga.vfuncionario_ultimo_cargo car on car.id_funcionario = fun.id_funcionario
                                /******************************/
                                /*Aumentando estas condiciones (Breydi Vasquez 16/03/2021)*/
                                LEFT JOIN segu.tusuario usu1 on usu1.id_usuario = ro.id_usuario_reg
                                LEFT JOIN segu.tusuario usu2 on usu2.id_usuario = ro.id_usuario_mod
                                where us.fecha_caducidad >= now()::date and';
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

ALTER FUNCTION segu.ft_rol_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;
