CREATE OR REPLACE FUNCTION orga.ft_teletrabajo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Organigrama
 FUNCION: 		orga.ft_teletrabajo_ime
 DESCRIPCION:   Funcion para ir registrando los funcionarios en teletrabajo
 AUTOR: 		Ismael Valdivia
 FECHA:	        26/05/2020 23:30:00
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE


	v_parametros           	record;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_id_teletrabajo		integer;

    v_existencia			integer;
	v_mensaje				varchar;

BEGIN

    v_nombre_funcion = 'orga.ft_teletrabajo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ORGA_INS_TELTRA_IME'
 	#DESCRIPCION:	Insercion de registros
    #AUTOR: 		Ismael Valdivia
    #FECHA:	        26/05/2020
	***********************************/

	if(p_transaccion='ORGA_INS_TELTRA_IME')then

		begin

        	/*Aqui ponemos el control para verrificar si ya se registro el funcionario*/
            select count(tele.ci) into v_existencia
            from orga.tformulario_teletrabajo tele
            where tele.ci = v_parametros.ci;
          /**************************************************************************/

          if (v_existencia > 0) then
              v_mensaje = 'El funcionario ya se encuentra registrado';
          else
              v_mensaje = 'Registro existoso';

              insert into orga.tformulario_teletrabajo( id_funcionario,
                                                      ci,
                                                      equipo_computacion,
                                                      tipo_de_uso,
                                                      cuenta_con_internet,
                                                      zona_domicilio,
                                                      transporte_particular,
                                                      tipo_transporte,
                                                      placa,
                                                      id_usuario_reg
                                                      )VALUES(
                                                      v_parametros.id_funcionario,
                                                      v_parametros.ci,
                                                      v_parametros.equipo_computacion,
                                                      v_parametros.tipo_de_uso,
                                                      v_parametros.cuenta_con_internet,
                                                      v_parametros.zona_domicilio,
                                                      v_parametros.transporte_particular,
                                                      v_parametros.tipo_transporte,
                                                      v_parametros.placa,
                                                      p_id_usuario )RETURNING id_teletrabajo into v_id_teletrabajo;



          end if;






			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'Mensaje','Exito');
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',v_mensaje::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_teletrabajo',v_id_teletrabajo::varchar);


            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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
