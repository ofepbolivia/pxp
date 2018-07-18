CREATE OR REPLACE FUNCTION orga.final_palabra (
  v_recomendacion varchar
)
RETURNS varchar AS
$body$
DECLARE
  result 					varchar;
  reg 						record;
  reco 						varchar;
  cont 						integer;
  i							record;
  caja						varchar[];
  v_cantidad				integer;
  v_resp		            varchar;
  v_nombre_funcion        	text;
  v_guion					varchar;
  v_iniciales				varchar;
  v_i						integer;
  total						varchar;
  espacio					varchar;
  total1 					varchar;
  v_punto					varchar;
	
BEGIN
	reco = regexp_replace(regexp_replace(v_recomendacion, E'<.*?>', '', 'g' ), E'&nbsp;', '', 'g'); --eliminar todo html
    v_guion = replace(reco,'-','');
    v_punto = replace(v_guion,'•','');
    v_resp=regexp_replace(v_punto,'[[:space:]][[:space:]]',' ','g');     
    v_iniciales = REGEXP_REPLACE(v_resp,'[[:digit:]].','','g');
	v_i = orga.f_punto(v_iniciales);
    
    if v_i > 1 then
    
     espacio = replace(replace(v_iniciales,chr(10), ' '),chr(13),' ');
     result =replace(espacio,'.',chr(10));
     
    elsif v_i = 1 then    
    
     total = replace(replace(replace(replace(v_iniciales,chr(10),' '),chr(11),''),chr(13),''),chr(27),'');
     result = total;
     
    elsif v_i = 0 then
      total = replace(replace(replace(v_iniciales,chr(11),''),chr(13),''),chr(27),'');
      --espacio = replace(replace(total,chr(10), ' '),chr(13),'');
     -- total1 = replace(espacio,chr(10),' ');
	  result = total;
     end if;
     
   RETURN result;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;