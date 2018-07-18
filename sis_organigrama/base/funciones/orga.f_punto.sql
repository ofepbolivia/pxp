CREATE OR REPLACE FUNCTION orga.f_punto (
  texto varchar
)
RETURNS integer AS
$body$
DECLARE
  bus 			varchar[];
  dato 			varchar;
  cont			integer;
  i				integer;
  o				integer=0;
  guar			varchar[];
  sum			INTEGER=0;
BEGIN
dato = REGEXP_REPLACE(texto,'[[:space:]]','','g');
bus = regexp_split_to_array(dato,E'\\s*');
cont = array_length(bus,1);
for i in 1..cont
loop
	guar[o]=bus[i];
    if(guar[o]='.')then
    	sum=sum+1;
    end if;
    o=o+1;
end loop;
return sum;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;