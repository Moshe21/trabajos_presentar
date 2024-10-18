
--

--
DROP DATABASE IF EXISTS `pqrs230831`;
CREATE DATABASE `pqrs230831`;
USE `pqrs230831`;
-- --------------------------------------------------------
 --
-- Table structure for table `departamento`
--
 
CREATE TABLE `departamento` (
	`iddepto` INT(11) NOT NULL,
    `nombre depto` VARCHAR(100) NOT NULL
);



ALTER TABLE `departamento`
  MODIFY `iddepto` INT PRIMARY KEY;

 -- Inserción de datos para tabla `departamento`
 
INSERT INTO `departamento` (`iddepto`,`nombre depto`) VALUES
(10,'atención al cliente'),
(20,'facturación'),
(30,'soporte técnico');
 --
-- Table structure for table `empleados`
--
 
CREATE TABLE `empleados` (
	`id empleado` INT(11) NOT NULL,
    `nombreEmpleado` VARCHAR(100) NOT NULL,
	`iddepto` INT(11) NOT NULL
);

 -- añadir primary key para tabla `empleados`, añadir foreign key para tabla `empleados`
 
ALTER TABLE `empleados`
ADD PRIMARY KEY (`id empleado`),
ADD CONSTRAINT `fk_iddepto` FOREIGN KEY (`iddepto`) REFERENCES `departamento`(`iddepto`);

 -- Inserción de datos para tabla `empleados`
 
INSERT INTO `empleados` (`id empleado`,`nombreEmpleado`, `iddepto`) VALUES
(1111,'andres',10),
(1112,'felipe',10),
(1113,'fernando',10),
(1114,'edward',10),
(1115,'hugo',20),
(1116,'gustavo',20),
(1117,'enrique',20),
(1118,'manuel',20),
(1119,'geovanny',30),
(1120,'victor',30),
(1121,'julio',30),
(1122,'Almenares',30);


-- Table structure for table `clientes`
--
CREATE TABLE `clientes` (
	`email` VARCHAR(100) NOT NULL,
    `nombre` VARCHAR(100) NOT NULL
);

-- añadir primary key para tabla `clientes`

ALTER TABLE `clientes`
MODIFY `email` VARCHAR(100) PRIMARY KEY;


 --
-- Table structure for table `asignaciones`
--
CREATE TABLE `asignaciones` (
	`id asignacion` INT(11) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `iddepto` INT(11) NOT NULL,
	`nombreEmpleado` VARCHAR(100) NOT NULL,
    `mensaje` varchar(500) NOT NULL,
    `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
-- añadir primary key para tabla `asignaciones`, añadir foreign key para tabla `asignaciones`
 
ALTER TABLE `asignaciones`
MODIFY `id asignacion` INT PRIMARY KEY AUTO_INCREMENT,
ADD CONSTRAINT `fk_iddpto` FOREIGN KEY (`iddepto`) REFERENCES `departamento`(`iddepto`),
ADD CONSTRAINT `fk_email` FOREIGN KEY (`email`) REFERENCES `clientes`(`email`);
 

