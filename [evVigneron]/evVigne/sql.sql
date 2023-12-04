INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_vigne', 'vigne', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_vigne', 'vigne', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_vigne', 'vigne', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('vigne', 'vigne')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('vigne',0,'recrue','Recrue',12,'{}','{}'),
	('vigne',1,'medium',"Medium",24,'{}','{}'),
	('vigne',2,'ce','chef Equipe',36,'{}','{}'),
	('vigne',3,'boss',"Patron",48,'{}','{}')
;

INSERT INTO `items` (name, label) VALUES 
    ('raisin', 'Raisin'),
    ('raisinb', 'Raisin Blanc'),
    ('jusraisin', 'Jus de Raisin'),
    ('jusraisinb', 'Jus de Raisin Blanc'),
    ('grandcru', 'Grand Cru'),
    ('terroirb', 'Vin de Terroir'),
;






CREATE TABLE `vignoble_veh` (
  `veh` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vignoble_veh`
--

INSERT INTO `vignoble_veh` (`veh`, `stock`) VALUES
('blista', 1),
('guardian', 2);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `vignoble_veh`
--
ALTER TABLE `vignoble_veh`
  ADD PRIMARY KEY (`veh`);
COMMIT;





CREATE TABLE `vignoble` (
  `iden` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `discord` varchar(255) NOT NULL,
  `stylep` varchar(255) NOT NULL,
  `motivations` varchar(255) NOT NULL,
  `accept` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `vignoble`
--
ALTER TABLE `vignoble`
  ADD PRIMARY KEY (`iden`);
COMMIT;
