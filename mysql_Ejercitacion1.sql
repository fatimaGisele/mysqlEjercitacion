/*EJERCICIO 6:

    BASE SAKILA:
   
    Crear un procedimiento que reciba nombre y apellido de un actor (ACTOR) en un solo STRING y el nombre de una pelicula (FILM).
    Si dicho actor existe no insertarlo.
    Si el actor no existe en la tabla ingresarlo y asociarlo como corresponda realizarlo a las entidades implicadas.
    Devolver en un parametro de salida tipo String indicando "SUCCESSFUL" para el caso que se inserten correctamente los datos
    y en caso que no se inserten devolver "NOT SUCCESSFUL".
       
    Entidades: Verificar en diagrama ER.*/
    select concat(actor.first_name," ",actor.last_name) as nombre 
    from actor where actor.first_name like "a%";
    
       
select  actor.first_name, ACTOR.last_name, FILM.title from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id ORDER BY ACTOR.LAST_NAME;

/*
CREATE PROCEDURE `ejercicio_seis` (in actor_nombre varchar(100), film_titulo varchar(255))
BEGIN
declare existe_actor varchar(100);
declare e varchar(50);
declare existe boolean;

select existe_actor = actor.first_name, actor.last_name from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id 
where film.title = film_titulo;

if(existe_actor is null)
then insert into actor(first_name, last_name) values(actor_nombre);

end if;
END
*/

/*
EJERCICIO NUEVE
CREAR UNA FUNCION:
Obtener gastos de un cliente (CUSTOMER) para un film. En caso de no tener devuelve 0.
*/

select amount FROM customer
inner join payment ON customer.customer_id = payment.customer_id
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
where customer.first_name ='gabriel';

/*CREATE FUNCTION `ejercicio_nueve` (customer_name varchar(45), customer_last_name varchar(45))
RETURNS decimal
BEGIN
declare gastos decimal(5,2);
set gastos = (select amount, customer.last_name, customer.first_name 
				FROM customer
				inner join payment ON customer.customer_id = payment.customer_id
				inner join rental on payment.rental_id = rental.rental_id
				inner join inventory on rental.inventory_id = inventory.inventory_id
				inner join film on inventory.film_id = film.film_id
				where customer.first_name =customer_name and customer.last_name = customer_last_name);

	if(gastos is null) 
    then set gastos = 0;
    else
    return gastos;
    end if;

RETURN gastos;
END*/

/*
Ejercicio 10:
    
    Ingresar pago de nueva compra segun customer actualizando los datos importantes en las entidades que lo consideren pertinentes.
    Investigar las entidades para saber donde ingresar los datos y donde actualizar.
*/
-----------------------------------------------------------------------------------------------
/*
    TRIGGERS:
    EJERCICIO 11 - TRIGGERS:
    BASE SAKILA
   
    Crear un control de inserción sobre la tabla film_text así como la tabla film que valide si existe un ingreso igual
    y que controle si ese ingreso existe en la entidad film,
    en caso de estar repetido en film_text y existir ingresarlo con el texto "FAIL"


DROP TRIGGER IF EXISTS `sakila`.`film_text_BEFORE_INSERT`;

DELIMITER $$
USE `sakila`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sakila`.`film_text_BEFORE_INSERT` 
BEFORE INSERT ON `film_text` 
FOR EACH ROW
BEGIN
	if(exists (
				select count(*) from film_text
				where title <> new.title
                )
		)
			then 
				if(exists (
					select count(*) from film
					where title <> new.title
						)
				)
				then
					set new.title = concat(new.title, "FAIL");
			end if;
    end if;    
END$$
DELIMITER ;*/
select * from sakila.film_text where film_id = 1048;
select count(*) from film_text
				where title LIKE "BOWFINGER GABLES%";
insert into film_text (film_id, title, description)
values(1048, "BOWFINGER GABLES","A Fast-Paced Yarn of a Waitress And a Composer who must Outgun a Dentist in California");
-----------------------------------------------
/*
   
    EJERCICIO 12 - TRIGGERS:
    BASE SAKILA
   
    Crear un desencadenador que controle en la insercion de un cliente nuevo que
    el nombre, el apellido y el mail no esten repetidos, en caso de estarlo lo ingrese
    con los campos mencionados con la leyenda "fail" omitiendo el texto ingresado.


CREATE DEFINER = CURRENT_USER TRIGGER `sakila`.`customer_BEFORE_INSERT`
BEFORE INSERT ON `customer` 
FOR EACH ROW
BEGIN
     IF(exists(
				select count(*) from customer
                where first_name <>new.first_name and last_name<>new.last_name and email <> new.email
                )
		)
			THEN
				SET NEW.first_name = "FAIL";
                SET NEW.last_name = "FAIL";
                SET NEW.email = "FAIL";
	END IF;
END
*/


-- #########################################################################################################################################
/*
   
    EJERCICIO 14 - TRIGGERS:
    BASE WORLD
   
    Crear un desencadenador que controle en la actualizacion de la poblacion de una ciudad que controle si la misma existe,
    si la poblacion es superior o inferior
    y que en cualquier caso actualice la diferencia en la entidad pais.

CREATE DEFINER=`root`@`localhost` TRIGGER `city_BEFORE_UPDATE` BEFORE UPDATE ON `city` FOR EACH ROW BEGIN
	DECLARE POP_PAISES INT;
    IF(exists(
			SELECT COUNT(*) FROM city
            WHERE city.Name = NEW.Name)
		)THEN
        IF(Population < new.Population or Population > new.Population)
            THEN
				set new.Population=new.Population;
                set POP_PAISES = (select Population from country
									inner join city 
									on country.Code = city.CountryCode);
		END IF;
	END IF;
END
*/
use world;
select city.Population, city.Name, country.name from country
							inner join city
                            on country.Code = city.CountryCode;
select country.Population, country.name,city.Name, city.Population from country
							inner join city;
                            
/*EJERCICIO 18c CLASE TRANSACTION:

    CREAR un SP que ejecute un TRANSACTION que para un film determinado analice la cantidad de alquileres que 
    tiene ese film e ingrese al inventario nuevas existencias si los alquileres superan los 50.

   Tener en cuenta que se debe evitar impactar la inserción de existencias siempre y cuando no existan alquileres EN CURSO para ese film.
   Considerar el contexto de que las TRANSACTIONS se encuentran corriendo en paralelo a muchas otras ejecuciones sobre las entidades implicadas.
    Justificar la estrategia elegida.
	
-- usar BANGER PINOCCHIO
*/

select * from film
inner join inventory
on film.film_id = inventory.film_id
where film.title = "BANGER PINOCCHIO";

select film.title
from film
where film_ID =573;

select * from rental
inner join inventory
on rental.inventory_id = inventory.inventory_id
where film_id = 573 and rental.return_date is null;


/*EJERCICIO 19 CLASE TRANSACTION:

    CREAR un SP que ejecute un TRANSACTION que para un film que se ingrese asignar un grupo de 3 actores existentes al mismo.

    La inserción del FILM debe estar siempre impactada y dentro de la TRANSACTION.
   Tener en cuenta que se debe evitar impactar la inserción de relacion entre films con actores siempre y cuando no se haya cargado 
   una existencia en inventario y se haya cargado un registro de alquiler.
   Considerar el contexto de que las TRANSACTIONS se encuentran corriendo en paralelo a muchas otras ejecuciones sobre las entidades implicadas.
    Justificar la estrategia elegida.
*/

SELECT *
FROM film
WHERE film.title = "MICROCOSMOS PARADISE";

INSERT INTO film_actor(actor_id, film_id)
VALUES(1,573);

select count(*) from rental
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on inventory.film_id = film.film_id
where inventory.film_id = 573;

/* EJERCICIO 20 CLASE TRANSACTION:

    CREAR un SP que ejecute una TRANSACTION que genere una nueva categoría de film que se llame "UNKNOWN" 
    que se asocie a los últimos 3 a 10 registros de films.
    La inserción de la categoría nueva debe estar siempre impactada y dentro de la TRANSACTION.
    La asociación de los registros de los films a la nueva categoría esta condicionada a que el 
    empleado de STAFF asignado al ultimo alquiler (RENTAL) del anteúltimo film ingresado este en proceso de activación.
    Puede utilizar una repetición con un LOOP u otro método de repetición para asociar los films como método para ejecutar 
    fácilmente la actualización de los registros con solo modificar un numero.
   Considerar el contexto de que las TRANSACTIONS se encuentran corriendo en paralelo a muchas otras ejecuciones sobre las entidades implicadas.
    Justificar la estrategia elegida.
*/
select max(film_id) from film;
-- select max(customer_id) from customer
select customer_id from customer;
select * from customer where customer_id = 603;

select MAX(rental.rental_id) into @r from rental
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on inventory.film_id = film.film_id
where film.film_id= (select MAX(film.film_id) - 1 from film);

select staff.active
from staff 
inner join rental 
on staff.staff_id = rental.staff_id
where rental.rental_id = @r; 


/*EJERCICIO 21 CLASE TRANSACTION:

    BASE WORLD

    CREAR un SP que ejecute un TRANSACTION que ingrese una nueva nacion llamada "FEDONIA" en el continente africano 
    con dos ciudades "Fedonia CITY" y "Fodonia" con valores de poblacion sobre las ciudades a eleccion.
     Se debe elegir un lenguaje de africa asociado segun el ultimo menos hablado en Africa.
    Sucede que el nuevo pais tiene nuevas ciudades todo el tiempo y la insercion de ciudades debe actualizar el valor
    del total de la suma de las ciudades del pais solo cuando no se este ingresando una nueva ciudad. 
    Por lo cual si esto es asi debe impactar las ciudades nuevas pero no la actualizacion que debera ser realizada por la 
    transaction que corra (cosa que se acordo con las otras operaciones).

   Considerar el contexto de que las TRANSACTIONS se encuentran corriendo en paralelo a muchas otras ejecuciones sobre las entidades implicadas.

*/
use world;
select MAX(country.Code2) from country;

select * from countrylanguage 
inner join country
on countrylanguage.CountryCode = country.Code
where Continent = 'Africa';

select city.Population, city.Name, countrylanguage.Language from countrylanguage 
inner join country
on countrylanguage.CountryCode = country.Code
inner join city
on country.Code = city.countryCode
where Continent = 'Africa' and city.Population order by city.Population asc;

select countrylanguage.language from countrylanguage 
inner join country
on countrylanguage.CountryCode = country.Code
inner join city
on country.Code = city.countryCode
where Continent = 'Africa' group by countrylanguage.language order by country.Population asc LIMIT 1; 

select MAX(city.ID) FROM city;
SELECT * FROM city where countryCode = 'FDN';
INSERT INTO country(Code, Name, Continent)
VALUES('FDN','Fedonia', 'Africa');

SELECT 
    *
FROM
    customer
        INNER JOIN
    rental ON customer.customer_id = rental.customer_id
        INNER JOIN
    payment ON rental.rental_id = payment.rental_id
WHERE
    rental.customer_id = payment.customer_id;

select * from payment
left join rental
on payment.rental_id = rental.rental_id
where rental.rental_id = payment.rental_id;

SELECT 
    *
FROM
    rental
        LEFT JOIN
    payment ON rental.rental_id = payment.rental_id
WHERE
    rental.customer_id = 126
        AND payment.customer_id = 126
        AND rental.inventory_id = 830;

insert into rental(rental_date, inventory_id,customer_id, staff_id)
values(now(),830, 12,1);

select staff_id from rental where customer_id=126 and rental_id = 16053;

select * from payment 
			where rental_id  not in(
								select rental_id from rental
														where customer_id = 1);
                                                        
select * from payment -- pagos de un alquiler asociados a un cliente
			where rental_id in(
								select rental_id from rental
														where customer_id = cliente_id);
select COUNT(RENTAL.rental_id) from rental
left join payment
on rental.rental_id = payment.rental_id
where rental.customer_id = 126
and rental.rental_id not in (select payment.rental_id from payment
							where customer_id = 126);
         
SELECT COUNT(R.rental_id) -- Cantidad de alquileres de customer que no tienen pagos asociados.
		FROM rental R LEFT JOIN payment P
			ON R.rental_id= P.rental_id
		WHERE P.payment_id IS NULL AND R.customer_id = 126;
        
SELECT 
    *
FROM
    rental
        LEFT JOIN
    payment ON rental.rental_id = payment.rental_id
WHERE
    rental.customer_id = 126
        AND rental.rental_id NOT IN (SELECT 
            payment.rental_id
        FROM
            payment
        WHERE
            customer_id = 126)
LIMIT 1; -- and return_date=null limit 1


SELECT 
   film_id
FROM
    rental
    inner join inventory
    on rental.inventory_id = inventory.inventory_id
WHERE
    customer_id = 126
        AND return_date IS NULL
LIMIT 1;


UPDATE rental 
SET 
    return_date = NOW()
WHERE
    rental_id = 16050;
    
SELECT R.rental_id
		FROM rental R LEFT JOIN payment P
			ON R.rental_id= P.rental_id
		WHERE P.payment_id IS NULL AND R.customer_id = 126;