-- Creación de base de datos
CREATE SCHEMA alke_wallet;
USE alke_wallet;

-- Creación de tablas
CREATE TABLE usuario(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    contrasenia VARCHAR(100) NOT NULL,
    saldo INT NOT NULL,
    fecha_de_creacion DATETIME NOT NULL
);

CREATE TABLE currency(
	currency_id INT PRIMARY KEY AUTO_INCREMENT,
    currency_name VARCHAR(100) NOT NULL,
    currency_symbol CHAR(3) NOT NULL
);

CREATE TABLE transaccion(
	transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    valor INT NOT NULL,
    transaction_date DATETIME NOT NULL,
    currency_id INT NOT NULL,
    
    FOREIGN KEY(sender_user_id) REFERENCES usuario(user_id) ON DELETE CASCADE,
    FOREIGN KEY(receiver_user_id) REFERENCES usuario(user_id) ON DELETE CASCADE,
    FOREIGN KEY(currency_id) REFERENCES currency(currency_id) ON DELETE CASCADE
);

-- Insert de datos
-- Datos generados en "https://www.mockaroo.com/"
INSERT INTO usuario(nombre, apellido, correo, contrasenia, saldo, fecha_de_creacion)
VALUES ('Brett','Lewing','blewing0@moonfruit.com','oA9#M',1500,'2024-02-27 04:27:53'),
       ('Whitman','Glasebrook','wglasebrook1@desdev.cn','eT2`>$621',189500,'2021-04-08 02:43:54'),
       ('Al','Applegate','aapplegate2@de.vu','hJ6=n',850,'2023-04-04 18:18:11'),
       ('Jeffry','MacIlory','jmacilory3@jugem.jp','bP6/n>',1589666,'2022-11-08 17:01:47'),
       ('Brade','Duckitt','bduckitt4@tiny.cc','wR1=X+.SQ?',1890,'2022-02-25 04:23:21'),
       ('Iolanthe','McGurgan','imcgurgan5@eventbrite.com','yE7#Gg',1590,'2024-03-06 12:30:39'),
       ('Engelbert','Coldbreath','ecoldbreath6@youtu.be','zD4$ozB>8b',5999994,'2022-11-25 07:45:45'),
       ('Gabi','De Hoogh','gdehoogh7@zdnet.com','rJ4*\tn<',10,'2022-08-24 18:35:45');

INSERT INTO currency (currency_name, currency_symbol)
VALUES ('Peso chileno', '$'),  
	   ('Euro', '€'),
       ('Dólar estadounidense', '$'),
       ('Yen japonés','¥');

INSERT INTO transaccion(sender_user_id, receiver_user_id, valor, transaction_date, currency_id)
VALUES (1, 2, 1000, '2023-02-15 16:18:04', 1),
	   (2, 3, 1500, '2023-03-28 13:58:10', 4),
       (3, 1, 1090, '2023-11-15 01:40:00', 3),
       (8, 5, 29076, '2022-05-14 02:18:02', 2),
       (4, 2, 53070, '2024-02-06 04:41:00', 2),
       (4, 8, 61704, '2020-11-11 06:19:20', 4),
       (7, 3, 16206, '2021-02-02 01:58:56', 1),
       (4, 1, 8799, '2024-02-09 03:16:51', 1),
       (5, 6, 87937, '2024-02-24 00:55:35', 1),
       (6, 4, 14384, '2020-10-31 05:23:21', 4);
       
select * from usuario;
select * from transaccion;
select * from currency;

-- Consulta para obtener el nombre de la moneda elegida por un usuario específico
-- Se agregan datos extra que ayuden a entender la consulta realizada (t.transaction_id, u.nombre, u.apellido)
SELECT t.transaction_id 'ID transacción', c.currency_name 'Nombre de la moneda escogida',
CONCAT(u.nombre, ' ' , u.apellido ) 'Nombre usuario'
FROM transaccion t INNER JOIN usuario u ON t.sender_user_id = u.user_id
				   INNER JOIN currency c ON c.currency_id = t.currency_id
WHERE u.user_id = 4;

                      
-- Consulta para obtener todas las transacciones registradas
SELECT * FROM transaccion;

-- Consulta para obtener todas las transacciones realizadas por un usuario específico
-- Se acota la consulta a algunos campos para que no quede tan extensa 
-- Se considera como transaccion tanto lo enviado como lo recibido
SELECT t.transaction_id 'ID de transacción', t.valor 'Monto transacción', t.sender_user_id 'ID remitente',
CONCAT(u.nombre, ' ' , u.apellido ) 'Nombre remitente', t.receiver_user_id 'ID receptor',
CONCAT(ur.nombre, ' ' , ur.apellido) 'Nombre receptor'
FROM transaccion t INNER JOIN usuario u ON t.sender_user_id = u.user_id
				   INNER JOIN usuario ur ON t.receiver_user_id = ur.user_id
WHERE t.sender_user_id = (SELECT user_id
				   FROM usuario
                   WHERE user_id = 1)
OR t.receiver_user_id = (SELECT user_id
				   FROM usuario
                   WHERE user_id = 1);
                   
-- Sentencia DML para modificar el campo correo electrónico de un usuario específico
UPDATE usuario
SET correo = LOWER(CONCAT(LEFT(nombre,2),'.', apellido, '@ejemplo.cl'))
WHERE user_id = 2; 

-- Sentencia para eliminar los datos de una transacción (eliminado de la fila completa)
DELETE FROM transaccion
WHERE transaction_id = 2;

-- Evaluación integradora en clases
-- Eliminar datos con integridad referencial
-- Aseguraremos que la eliminación de un usuario también elimine automáticamente las transacciones relacionadas.
DELETE FROM usuario
WHERE user_id = 5;

-- Evaluación integradora en clases
-- Modificar una restriccion de nulidad de una tabla
-- Crear tabla inicialmente permitiendo nlos en la columna apellido
CREATE TABLE empleados(
	id_empleados INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NULL
);

-- Modificar la restriccion de nulidad de la columna apellido
ALTER TABLE empleados
MODIFY COLUMN apellido VARCHAR(50) NOT NULL;
