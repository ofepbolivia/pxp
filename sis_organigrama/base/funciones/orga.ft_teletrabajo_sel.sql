CREATE OR REPLACE FUNCTION orga.ft_teletrabajo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Organigrama
 FUNCION: 		orga.ft_teletrabajo_sel
 DESCRIPCION:   Funcion que devolvera la consulta de los funcionarios
 AUTOR: 		Ismael Valdivia
 FECHA:	        26/05/2020 22:30:00
 COMENTARIOS:
***************************************************************************/


DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

    v_existencia		integer;
    v_registrado		varchar;
    v_existe_fun		integer;


BEGIN

	v_nombre_funcion = 'orga.ft_teletrabajo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ORGA_CONS_TELTRA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR: 		Ismael Valdivia
 	#FECHA:	        26/05/2020 22:30:00
	***********************************/

	if(p_transaccion='ORGA_CONS_TELTRA_SEL')then

    	begin

        /*Aqui ponemos el control para verrificar si ya se registro el funcionario*/
          select count(tele.ci) into v_existencia
          from orga.tformulario_teletrabajo tele
          where tele.ci = v_parametros.ci;
        /**************************************************************************/

        if (v_existencia > 0) then
        	v_registrado = 'Si';
        else
        	v_registrado = 'No';
        end if;


            select count (car.id_funcionario) into v_existe_fun
            from orga.vfuncionario_ultimo_cargo car
            where car.ci = v_parametros.ci and (car.fecha_finalizacion is null or car.fecha_finalizacion >= now()::date);

            IF (v_existe_fun = 0) then
            	raise exception 'El Funcionario se encuentra inactivo';
            end if;



        v_consulta = 'select car.id_funcionario::integer,
                             per.apellido_paterno::varchar,
                             per.apellido_materno::varchar,
                             per.nombre::varchar,
                             per.ci::varchar,
                             per.expedicion::varchar,
                             per.direccion::varchar,
                             car.nombre_cargo::varchar,
                             COALESCE (
                             (select uo.nombre_unidad::varchar
                              from orga.tuo uo
                              where uo.id_uo = orga.f_get_uo_gerencia(car.id_uo,car.id_funcionario,now()::date)),''SIN GERENCIA'')::varchar as gerencia,
                              '''||v_registrado||'''::varchar as registrado
                      from segu.tpersona per
                      inner join orga.vfuncionario_persona funper on funper.id_persona = per.id_persona
                      inner join orga.vfuncionario_ultimo_cargo car on car.id_funcionario = funper.id_funcionario
                      where per.ci = '''||v_parametros.ci||''' and car.estado_reg_fun = ''activo''';

        return v_consulta;


		end;

    /*********************************
 	#TRANSACCION:  'ORGA_LIST_TELTRA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR: 		Ismael Valdivia
 	#FECHA:	        26/05/2020 22:30:00
	***********************************/

	elsif(p_transaccion='ORGA_LIST_TELTRA_SEL')then

    	begin


        v_consulta = 'select tele.id_teletrabajo,
        					 tele.id_funcionario,
                             tele.ci,
                             tele.equipo_computacion,
                             tele.tipo_de_uso,
                             tele.cuenta_con_internet,
                             tele.zona_domicilio,
                             tele.transporte_particular,
                             tele.tipo_transporte,
                             tele.placa
        			  from orga.tformulario_teletrabajo tele
                      where ';

        	v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

        return v_consulta;


		end;
    /*********************************
 	#TRANSACCION:  'ORGA_LIST_TELTRA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		Jose Mita
 	#FECHA:		21-06-2016 10:11:23
	***********************************/

	elsif(p_transaccion='ORGA_LIST_TELTRA_CONT')then

		begin

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(tele.id_teletrabajo)
        			  from orga.tformulario_teletrabajo tele
                      where ';

			--Devuelve la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
			return v_consulta;

		end;

	else

		raise exception 'Transaccion inexistente';

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
