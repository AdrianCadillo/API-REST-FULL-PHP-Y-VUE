-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-07-2022 a las 15:00:20
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_permisos`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pc_permisoXRol` (`rol` VARCHAR(70))   begin
  select rp.id_rol,rp.id_permiso,descripcion,estado from 
 rol_permisos rp inner join permisos p on 
 rp.id_permiso=p.id_permiso inner join 
 roles r on rp.id_rol=r.id_rol 
 where r.nombre_rol=rol;
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pra_permisosnoasignadosxrol` (`rol` VARCHAR(70), `buscador` VARCHAR(40))   begin
 SELECT p.id_permiso,name_permiso,if(descripcion is null,'No especifica',descripcion) as 
DESCRIPCION FROM  permisos p where 
id_permiso not in(select rp.id_permiso from rol_permisos rp inner join 
permisos p1 on rp.id_permiso=p1.id_permiso inner join roles r on 
rp.id_rol=r.id_rol where r.nombre_rol=rol)
and
  (name_permiso like buscador or descripcion like buscador);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_crearcuentauser` (`name_usu` VARCHAR(80), `corr` VARCHAR(90), `pass` VARCHAR(80), `rol` VARCHAR(70))   begin
 insert into usuarios(nombre_usuario,correo,pasword)
 values(name_usu,corr,md5(pass));
 insert into usuario_roles(id_usuario,id_rol,estado)
 values((select id_usuario from usuarios where nombre_usuario=name_usu),
 (select id_rol from roles where nombre_rol=rol),'1');
 select 'usuario creado correctamente';
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_eliminacuenta` (`id` INTEGER)   begin
delete from usuario_roles where id_usuario=id;
delete from usuarios where id_usuario=id;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_rolesasigned` (`users` VARCHAR(80))   begin
select ur.id_usuario,ur.id_rol,r.nombre_rol,ur.estado
 from usuario_roles ur inner join usuarios u 
 on ur.id_usuario=u.id_usuario inner join 
 roles r on ur.id_rol=r.id_rol
 where u.nombre_usuario=users;
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_rolesnoasigned` (`id` INT)   begin
  select r.id_rol,r.nombre_rol from roles r
 where r.id_rol not in(select ur.id_rol from 
 usuario_roles ur inner join roles r1 on 
 ur.id_rol=r1.id_rol inner join usuarios u on ur.id_usuario=u.id_usuario
 where u.id_usuario=id);
 end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_userauditor` (`filtro` VARCHAR(30))   begin
select userconectado,perfil,usernameaccion,
if(usernameantiguo is null,'------------',usernameantiguo) 
as USUARIONAMEANTIGUO,accion,
date_format(fecha,'%d/%m/%Y') as FECHA,hora from 
pitagorauser where  accion like filtro;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos`
--

CREATE TABLE `modulos` (
  `id_modulo` int(11) NOT NULL,
  `name_modulo` varchar(65) NOT NULL,
  `name_menu` varchar(65) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `modulos`
--

INSERT INTO `modulos` (`id_modulo`, `name_modulo`, `name_menu`) VALUES
(1, 'Administración de usuarios', 'usuario'),
(2, 'Cliente', 'Cliente'),
(3, 'Empleado', 'empleado'),
(4, 'Producto', 'producto'),
(5, 'Venta', 'venta'),
(6, 'Proveedor', 'provedor'),
(7, 'Almacén', 'almacen'),
(8, 'Módulo', 'modulo'),
(9, 'Permiso', 'permiso'),
(10, 'Reportes', 'reporte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(11) NOT NULL,
  `name_permiso` varchar(65) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `id_modulo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id_permiso`, `name_permiso`, `descripcion`, `id_modulo`) VALUES
(1, 'addcli', 'Ver la interfaz de agregar clientes', 2),
(2, 'listcli', 'Ver ls lista de clientes', 2),
(3, 'addprod', 'ver la interfaz de productos', 4),
(4, 'listprod', 'ver la lista de productos', 4),
(5, 'adduser', 'ver la interzaz de usuarios', 1),
(6, 'listuser', 'ver la lista de usuarios', 1),
(7, 'addemp', 'ver la interfaz de empleados', 3),
(8, 'listemp', 'ver la lista de empleado', 3),
(9, 'addventas', 'ver la interfaz realizar ventas', 5),
(10, 'listventas', 'ver ventas realizados', 5),
(11, 'addNuevoPermiso', 'Agregar nuevos permisos (ver interfaz permisos)', NULL),
(12, 'add-rol', 'guardar roles (store)', NULL),
(13, 'ver-permisos', 'ver los permisos existentes', NULL),
(26, 'add-roles-permisos', 'agregar permisos a nuevos roles', NULL),
(27, 'list-reportes', 'ver todos los reportes', 10),
(29, 'create-rol-permissions', 'Visualizar ventana de crear roles y permisos', NULL),
(30, 'store-usuario', 'Registrar cuentas de usuarios', NULL),
(31, 'editar-usuario', 'Editar datos del usuario (como cambiar su rol)', NULL),
(32, 'ver-roles-usuario', 'Ver la lista de roles asignados a usuarios', NULL),
(33, 'create-Asignedpermissions', 'ventana de crear roles y permisos(asignar)', 1),
(34, 'modificar-usuario', 'modificar datos de los usuarios', NULL),
(36, 'ver-lista-modulos', 'Ver la lista de módulos existentes', 8),
(37, 'store-modulo', 'Registrar nuevos módulos al sistema', NULL),
(38, 'modificar-modulo', 'Modificar los módulos del sistema', NULL),
(39, 'modulo-create', 'Visualizar la interfzas de crear módulos desde el menu', 8),
(40, 'submodulo-create', 'Visualizar la interfaz de crear nuevos permisos en el sistema', 9),
(41, 'eliminar-cuenta', 'Eliminar las cuentas de los usuarios, incluyendo sus roles asignados', NULL),
(42, 'listado-roles', 'Ver la interfaz de  lista de roles para consultar', 1),
(43, 'editar-roles', 'Editar los roles para poder modificar', NULL),
(44, 'modificar-rol', 'Guardar los cambios realizados en los roles(modificar)', NULL),
(46, 'auditoria-users', 'Ver la interfaz de auditoria de usuarios, para saber que aaciones se realizó', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pitagorauser`
--

CREATE TABLE `pitagorauser` (
  `id_pitagorauser` int(11) NOT NULL,
  `userconectado` varchar(90) NOT NULL,
  `perfil` varchar(70) NOT NULL,
  `usernameantiguo` varchar(80) DEFAULT NULL,
  `usernameaccion` varchar(80) DEFAULT NULL,
  `accion` enum('Registro','Modifico','Elimino') NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pitagorauser`
--

INSERT INTO `pitagorauser` (`id_pitagorauser`, `userconectado`, `perfil`, `usernameantiguo`, `usernameaccion`, `accion`, `fecha`, `hora`) VALUES
(1, 'Abelardo Adrian', 'Super Administrador', NULL, 'Danilo Ivan', 'Registro', '2022-07-12', '00:53:08'),
(2, 'Abelardo Adrian', 'Super Administrador', 'Danilo Ivan', 'Danilo Ivan Rosales', 'Modifico', '2022-07-12', '06:10:04'),
(3, 'Abelardo Adrian', 'Super Administrador', NULL, 'Danilo Gustavo', 'Registro', '2022-07-12', '06:10:48'),
(4, 'Abelardo Adrian', 'Super Administrador', NULL, 'Fiorella Irma', 'Registro', '2022-07-12', '06:12:50'),
(5, 'Abelardo Adrian', 'Super Administrador', 'Danilo Gustavo', 'Danilo Gustavo Cadillo', 'Modifico', '2022-07-12', '06:13:39'),
(6, 'Fiorella Irma', 'Vendedor', NULL, 'Jorge Hugo', 'Registro', '2022-07-12', '06:13:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pitagorausuario`
--

CREATE TABLE `pitagorausuario` (
  `id_tabla` int(11) NOT NULL,
  `name_user` varchar(80) NOT NULL,
  `name_user_antiguo` varchar(80) DEFAULT NULL,
  `tipo` enum('Registro','Modifico','Borrado') DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pitagorausuario`
--

INSERT INTO `pitagorausuario` (`id_tabla`, `name_user`, `name_user_antiguo`, `tipo`, `fecha`, `hora`) VALUES
(1, 'Abelardo Adrian', NULL, 'Registro', '2022-07-12', '00:52:06'),
(2, 'Danilo Ivan', NULL, 'Registro', '2022-07-12', '00:53:07'),
(3, 'Danilo Ivan Rosales', 'Danilo Ivan', 'Modifico', '2022-07-12', '06:10:04'),
(4, 'Danilo Gustavo', NULL, 'Registro', '2022-07-12', '06:10:47'),
(5, 'Fiorella Irma', NULL, 'Registro', '2022-07-12', '06:12:49'),
(6, 'Danilo Gustavo Cadillo', 'Danilo Gustavo', 'Modifico', '2022-07-12', '06:13:39'),
(7, 'Jorge Hugo', NULL, 'Registro', '2022-07-12', '06:13:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(65) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`) VALUES
(1, 'Super Administrador'),
(2, 'Vendedor'),
(3, 'Almacenero'),
(4, 'Cajero'),
(5, 'Gerente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permisos`
--

CREATE TABLE `rol_permisos` (
  `id_rol` int(11) NOT NULL,
  `id_permiso` int(11) NOT NULL,
  `estado` enum('0','1') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `rol_permisos`
--

INSERT INTO `rol_permisos` (`id_rol`, `id_permiso`, `estado`) VALUES
(1, 2, '0'),
(1, 3, '1'),
(1, 4, '0'),
(1, 5, '1'),
(1, 6, '1'),
(1, 7, '0'),
(1, 8, '0'),
(1, 9, '0'),
(1, 10, '1'),
(1, 11, '1'),
(1, 12, '1'),
(1, 13, '1'),
(1, 26, '1'),
(1, 27, '1'),
(1, 29, '1'),
(1, 30, '1'),
(1, 31, '1'),
(1, 32, '1'),
(1, 33, '1'),
(1, 34, '1'),
(1, 37, '1'),
(1, 38, '1'),
(1, 39, '1'),
(1, 40, '1'),
(1, 41, '1'),
(1, 42, '1'),
(1, 43, '1'),
(1, 44, '1'),
(1, 46, '1'),
(2, 1, '1'),
(2, 5, '1'),
(2, 6, '1'),
(2, 30, '1'),
(2, 31, '0'),
(2, 32, '1'),
(3, 5, '1'),
(3, 6, '1'),
(3, 31, '1'),
(3, 34, '1'),
(4, 39, '1'),
(5, 5, '1'),
(5, 6, '1'),
(5, 10, '1'),
(5, 31, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(45) NOT NULL,
  `correo` varchar(120) NOT NULL,
  `pasword` varchar(85) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre_usuario`, `correo`, `pasword`) VALUES
(1, 'Abelardo Adrian', 'adriaaanroosales@gmail.com', '32eeaa838a635fb0a7479f7525e6d260'),
(2, 'Danilo Ivan Rosales', 'Danilo@hotmail.com', 'dd378508e90d58165813d3a77049e193'),
(3, 'Danilo Gustavo Cadillo', 'Danilogmail.com', 'e10adc3949ba59abbe56e057f20f883e'),
(4, 'Fiorella Irma', 'Fiorella@gmail.com', 'e10adc3949ba59abbe56e057f20f883e'),
(5, 'Jorge Hugo', 'Hugo@gmail.com', 'e10adc3949ba59abbe56e057f20f883e');

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `operacionusuariodelete` AFTER DELETE ON `usuarios` FOR EACH ROW begin
insert into pitagorausuario(name_user,name_user_antiguo,tipo,fecha,hora)
values('',old.nombre_usuario,'Borrado',curdate(),curtime());
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `operacionusuarioinsertar` AFTER INSERT ON `usuarios` FOR EACH ROW begin
insert into pitagorausuario(name_user,tipo,fecha,hora)
values(new.nombre_usuario,'Registro',curdate(),curtime());
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `operacionusuarioupdate` AFTER UPDATE ON `usuarios` FOR EACH ROW begin
insert into pitagorausuario(name_user,name_user_antiguo,tipo,fecha,hora)
values(new.nombre_usuario,old.nombre_usuario,'Modifico',curdate(),curtime());
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_roles`
--

CREATE TABLE `usuario_roles` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `estado` enum('0','1') NOT NULL,
  `sessions` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario_roles`
--

INSERT INTO `usuario_roles` (`id_usuario`, `id_rol`, `estado`, `sessions`) VALUES
(1, 1, '1', 0),
(2, 2, '1', 0),
(3, 2, '1', 0),
(4, 2, '1', 0),
(5, 5, '1', 0);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_login`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_login` (
`nombre_usuario` varchar(45)
,`nombre_rol` varchar(65)
,`pasword` varchar(85)
,`correo` varchar(120)
,`estado` enum('0','1')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_moduloxrol`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_moduloxrol` (
`nombre_rol` varchar(65)
,`name_modulo` varchar(65)
,`name_menu` varchar(65)
,`estado` enum('0','1')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_permisoxrol`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_permisoxrol` (
`name_permiso` varchar(65)
,`nombre_rol` varchar(65)
,`estado` enum('0','1')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_users`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_users` (
`id_usuario` int(11)
,`nombre_usuario` varchar(45)
,`correo` varchar(120)
,`ROLES` mediumtext
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_verificar_permisos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_verificar_permisos` (
`name_permiso` varchar(65)
,`nombre_rol` varchar(65)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `v_login`
--
DROP TABLE IF EXISTS `v_login`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_login`  AS SELECT `u`.`nombre_usuario` AS `nombre_usuario`, `r`.`nombre_rol` AS `nombre_rol`, `u`.`pasword` AS `pasword`, `u`.`correo` AS `correo`, `ur`.`estado` AS `estado` FROM ((`usuario_roles` `ur` join `usuarios` `u` on(`ur`.`id_usuario` = `u`.`id_usuario`)) join `roles` `r` on(`ur`.`id_rol` = `r`.`id_rol`))  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_moduloxrol`
--
DROP TABLE IF EXISTS `v_moduloxrol`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_moduloxrol`  AS SELECT DISTINCT `r`.`nombre_rol` AS `nombre_rol`, `m`.`name_modulo` AS `name_modulo`, `m`.`name_menu` AS `name_menu`, `rp`.`estado` AS `estado` FROM (((`rol_permisos` `rp` join `roles` `r` on(`rp`.`id_rol` = `r`.`id_rol`)) join `permisos` `p` on(`rp`.`id_permiso` = `p`.`id_permiso`)) join `modulos` `m` on(`p`.`id_modulo` = `m`.`id_modulo`))  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_permisoxrol`
--
DROP TABLE IF EXISTS `v_permisoxrol`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_permisoxrol`  AS SELECT `p`.`name_permiso` AS `name_permiso`, `r`.`nombre_rol` AS `nombre_rol`, `rp`.`estado` AS `estado` FROM (((`rol_permisos` `rp` join `roles` `r` on(`rp`.`id_rol` = `r`.`id_rol`)) join `permisos` `p` on(`rp`.`id_permiso` = `p`.`id_permiso`)) join `modulos` `m` on(`p`.`id_modulo` = `m`.`id_modulo`))  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_users`
--
DROP TABLE IF EXISTS `v_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_users`  AS SELECT `u`.`id_usuario` AS `id_usuario`, `u`.`nombre_usuario` AS `nombre_usuario`, `u`.`correo` AS `correo`, group_concat('  ',`r`.`nombre_rol` separator ',') AS `ROLES` FROM ((`usuario_roles` `ur` join `usuarios` `u` on(`ur`.`id_usuario` = `u`.`id_usuario`)) join `roles` `r` on(`ur`.`id_rol` = `r`.`id_rol`)) GROUP BY `u`.`id_usuario`  ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_verificar_permisos`
--
DROP TABLE IF EXISTS `v_verificar_permisos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_verificar_permisos`  AS SELECT `p`.`name_permiso` AS `name_permiso`, `r`.`nombre_rol` AS `nombre_rol` FROM ((`rol_permisos` `rp` join `permisos` `p` on(`rp`.`id_permiso` = `p`.`id_permiso`)) join `roles` `r` on(`rp`.`id_rol` = `r`.`id_rol`)) WHERE `rp`.`estado` = '1''1'  ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `modulos`
--
ALTER TABLE `modulos`
  ADD PRIMARY KEY (`id_modulo`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id_permiso`),
  ADD KEY `fk_PERMISOS_MODULOS1` (`id_modulo`);

--
-- Indices de la tabla `pitagorauser`
--
ALTER TABLE `pitagorauser`
  ADD PRIMARY KEY (`id_pitagorauser`);

--
-- Indices de la tabla `pitagorausuario`
--
ALTER TABLE `pitagorausuario`
  ADD PRIMARY KEY (`id_tabla`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `rol_permisos`
--
ALTER TABLE `rol_permisos`
  ADD PRIMARY KEY (`id_rol`,`id_permiso`),
  ADD KEY `fk_ROLES_has_PERMISOS_PERMISOS1` (`id_permiso`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `usuario_roles`
--
ALTER TABLE `usuario_roles`
  ADD PRIMARY KEY (`id_usuario`,`id_rol`),
  ADD KEY `fk_USUARIOS_has_ROLES_ROLES1` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `modulos`
--
ALTER TABLE `modulos`
  MODIFY `id_modulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id_permiso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `pitagorauser`
--
ALTER TABLE `pitagorauser`
  MODIFY `id_pitagorauser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `pitagorausuario`
--
ALTER TABLE `pitagorausuario`
  MODIFY `id_tabla` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD CONSTRAINT `fk_PERMISOS_MODULOS1` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `rol_permisos`
--
ALTER TABLE `rol_permisos`
  ADD CONSTRAINT `fk_ROLES_has_PERMISOS_PERMISOS1` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ROLES_has_PERMISOS_ROLES1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuario_roles`
--
ALTER TABLE `usuario_roles`
  ADD CONSTRAINT `fk_USUARIOS_has_ROLES_ROLES1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_USUARIOS_has_ROLES_USUARIOS1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
