----------
# **Packebian Backend Builder**

[![Build Status](https://travis-ci.org/Packebian/Backend-builder.svg?branch=master)](https://travis-ci.org/Packebian/Backend-builder)

## **Introduction :**
Au cours de mon cursus RICM (Réseaux Informatique Communication Multimédia) au sein de l'école de Polytech Grenoble, de nombreux outils ont été nécessaires pour la réalisation des Travaux-Pratiques et des Projets. Cependant, certains outils ne sont pas utilisables facilement, il a fallu environ une heure et parfois bien plus pour réussir à les installer et les utiliser.
C'est pourquoi nous avons décidé mon groupe et moi-même de créer un dépôt de packages pour l'école Polytech pour les élèves et les enseignants de la filière RICM. Le but principal est de gagner un temps précieux sur les TPs et les projets en se focalisant principalement sur le réel objectif : la réussite.

##### **Équipe projet :**
- Germain Lecorps : Frontend
- Régis Ramel : Frontend
- Rémi Gattaz : Backend controller
- **Thibaut Nouguier : Backend builder**

## **Fonctionnement du Builder :**

### **Arborescence du Builder**
L'arborescence du builder a la forme suivante :

	Backend-builder
		| * build
		| - built
		| - scripts
			| * build_ant
			| * build_bin
			| * build_gradle
			| * build_makefile
			| * build_maven
		| * README.md
Le script build est le maître script, c'est lui qui récupère les paramètres nécessaires :

- --repository= : l'url du dépôt git.
- --package= : le nom du package que l'on souhaite créer.
- --tag= : le tag correspondant au commit du github que l'on souhaite cloner.

Il clone le dépôt git grâce à l'url passée en paramètre, il vérifie que le dossier DEBIAN existe et qu'il contient bien le fichier control, puis il vérifie qu'aucun dossier n'est nommé opt ou usr. Ensuite il créé les dossier opt/packebian/{nom du package} et usr/local/bin, pour enfin lancer la détection du type du projet dans le but de créer une arborescence de fichier compatible avec la création d'un package. Dès lors que cette arborescence est validée, il lance la création du package et nettoie son espace de travail en supprimant l'arborescence créée. Le package précédemment créé se trouve dans le dossier built.

### **Gestion des types de projet :**
La liste explicatives des types de projet gérés par le builder ci-dessous n'est pas exhaustive.
Chaque projet doit contenir sur son dépôt git un dossier DEBIAN contenant le fichier control décrivant le package que l'on souhaite créer.
#### __*Projet basé sur un makefile*__
Pour qu'un projet soit détecté comme un projet basé sur un makefile il est demandé que le makefile soit à la racine du projet.
L'arborescence de fichier sur un dépôt git doit correspondre à la suivante :

	test-builder-makefile
		| DEBIAN
			| * control
		| * makefile
		| * {sources}
Après le clonage de ce dépôt par le builder l'arborescence de fichier ressemble à :

	test-builder-makefile
		| - DEBIAN
			| * control
		| * makefile
		| * {sources}
		| - opt
			| - packebian
				| - test-builder-makefile
		| - usr
			| - local
				| - bin
Les sources et le makefile vont être déplacés dans opt/packebian/test-builder-makefile, c'est ainsi que la commande *make* est lancé pour produire un ou plusieurs exécutables :

	test-builder-makefile
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-makefile
					| * makefile
					| * {sources}
					| * {exécutables}
		| - usr
			| - local
				| - bin
Les exécutables produits sont ensuite déplacés dans usr/local/bin, pour que leur exécution soit accessible directement dans un terminal après l'installation du package. Le package est maintenant prêt à être créé grâce a une arborescence correcte :

	test-builder-makefile
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-makefile
					| * makefile
					| * {sources}
		| - usr
			| - local
				| - bin
					| * {exécutables}

#### __*Projet basé sur des exécutables*__
Pour qu'un projet soit détecté comme un projet basé des exécutables il est demandé que les exécutables soient à la racine du projet.
L'arborescence de fichier sur un dépôt git doit correspondre à la suivante :

	test-builder-bin
		| DEBIAN
			| * control
		| * {exécutables}
		| * {sources}
Après le clonage de ce dépôt par le builder l'arborescence de fichier ressemble à :

	test-builder-bin
		| - DEBIAN
			| * control
		| * {exécutables}
		| * {sources}
		| - opt
			| - packebian
				| - test-builder-bin
		| - usr
			| - local
				| - bin
Les sources et les exécutables vont être déplacés dans opt/packebian/test-builder-bin. Ensuite, un script est créé pour chaque exécutable. Il permet de lancer la commande qui lancera l'exécution de l'exécutable. Ces scripts sont déplacés dans usr/local/bin. Le package est maintenant prêt à être créé grâce a une arborescence correcte :

	test-builder-bin
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-bin
					| * {exécutables}
					| * {sources}
		| - usr
			| - local
				| - bin
					| * {exécutables}

#### __*Projet ant*__
Pour qu'un projet soit détecté comme un projet ant, il est demandé que le build.xml soit à la racine du projet.
L'arborescence de fichier sur un dépôt git doit correspondre à la suivante :

	test-builder-ant
		| DEBIAN
			| * control
		| * build.xml
		| * {sources}
Après le clonage de ce dépôt par le builder l'arborescence de fichier ressemble à :

	test-builder-ant
		| - DEBIAN
			| * control
		| * build.xml
		| * {sources}
		| - opt
			| - packebian
				| - test-builder-ant
		| - usr
			| - local
				| - bin
La construction du projet va être lancé grâce à la commande *ant run*. Ensuite toutes les sources et le dossier build sont déplacés dans opt/packebian/test-builder-ant.

	test-builder-ant
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-ant
					| * build.xml
					| * {sources}
					| - build
						| * {fichiers}
						| - {dossiers}
						| - jar
							| * test-builder-ant.jar
		| - usr
			| - local
				| - bin
Ensuite, un script est créé pour exécuter la commande qui lancera l'exécution de test-builder-ant-{version}.jar. Ce script est déplacé dans usr/local/bin. Le package est maintenant prêt à être créé grâce a une arborescence correcte :

	test-builder-ant
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-ant
					| * pom.xml
					| * {sources}
					| - build
						| * {fichiers}
						| - {dossiers}
						| - jar
							| * test-builder-ant.jar
		| - usr
			| - local
				| - bin
					| * test-builder-ant

#### __*Projet gradle*__
Pour qu'un projet soit détecté comme un projet gradle il est demandé que le build.gradle soit à la racine du projet.
L'arborescence de fichier sur un dépôt git doit correspondre à la suivante :

	test-builder-gradle
		| DEBIAN
			| * control
		| * build.gradle
		| * {sources}
Après le clonage de ce dépôt par le builder l'arborescence de fichier ressemble à :

	test-builder-gradle
		| - DEBIAN
			| * control
		| * build.gradle
		| * {sources}
		| - opt
			| - packebian
				| - test-builder-gradle
		| - usr
			| - local
				| - bin
La construction du projet va être lancé grâce à la commande *gradle build*. Ensuite toutes les sources et le dossier build sont déplacés dans opt/packebian/test-builder-gradle.

	test-builder-gradle
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-gradle
					| * build.gradle
					| * {sources}
					| - build
						| * {fichiers}
						| - {dossiers}
						| - libs
							| * test-builder-gradle.jar
		| - usr
			| - local
				| - bin
Ensuite, un script est créé pour exécuter la commande qui lancera l'exécution de test-builder-gradle-{version}.jar. Ce script est déplacé dans usr/local/bin. Le package est maintenant prêt à être créé grâce a une arborescence correcte :

	test-builder-gradle
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-gradle
					| * build.gradle
					| * {sources}
					| - build
						| * {fichiers}
						| - {dossiers}
						| - libs
							| * test-builder-gradle.jar
		| - usr
			| - local
				| - bin
					| * test-builder-gradle

#### __*Projet maven*__
Pour qu'un projet soit détecté comme un projet maven il est demandé que le pom.xml soit à la racine du projet.
L'arborescence de fichier sur un dépôt git doit correspondre à la suivante :

	test-builder-maven
		| DEBIAN
			| * control
		| * pom.xml
		| * {sources}
Après le clonage de ce dépôt par le builder l'arborescence de fichier ressemble à :

	test-builder-maven
		| - DEBIAN
			| * control
		| * pom.xml
		| * {sources}
		| - opt
			| - packebian
				| - test-builder-makefile
		| - usr
			| - local
				| - bin
La construction du projet va être lancée grâce à la commande *mvn install*. Ensuite toutes les sources et le dossier target sont déplacés dans opt/packebian/test-builder-maven.

	test-builder-maven
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-maven
					| * pom.xml
					| * {sources}
					| - target
						| * {fichiers}
						| - {dossiers}
						| * test-builder-maven-{version}.jar
		| - usr
			| - local
				| - bin
Ensuite, un script est créé pour exécuter la commande qui lancera l'exécution de test-builder-maven-{version}.jar. Ce script est déplacé dans usr/local/bin. Le package est maintenant prêt à être créé grâce a une arborescence correcte :

	test-builder-maven
		| - DEBIAN
			| * control
		| - opt
			| - packebian
				| - test-builder-maven
					| * pom.xml
					| * {sources}
					| - target
						| * {fichiers}
						| - {dossiers}
						| * test-builder-maven-{version}.jar
		| - usr
			| - local
				| - bin
					| * test-builder-maven

### **Gestion des erreurs**
Les erreurs sont gérées de la façon suivante :

- Les erreurs générales du builder :
  - **50** : est levée si le type de projet par le builder n'est pas le bon, le builder passe donc au suivant. Ce code doit donc être levé chaque fois que le critère déterminant le type n'est pas trouvé.
  - **100** : est levée si tous les types de projet proposés par le builder ne permettent pas de gérer le git proposé.

- Les erreurs liées aux paramètres :
  - **200** : est levée si les paramètres du builder ne sont pas respectés.
  - **201** : est levée si les paramètres pour le type "makefile" ne sont pas respectés.
  - **202** : est levée si les paramètres pour le type "maven" ne sont pas respectés.
  - **203** : est levée si les paramètres pour le type "ant" ne sont pas respectés.
  - **204** : est levée si les paramètres pour le type "gradle" ne sont pas respectés.
  - **205** : est levée si les paramètres pour le type "exécutables" ne sont pas respectés.

- Les erreurs liés à la non présence de certains fichiers / dossiers :
  - **301** : est levée si le fichier control n'existe pas dans le git proposé ce qui empêchera la création du package.
  - **302** : est levée si le dossier DEBIAN n'existe pas dans le git proposé ce qui empêchera la création du package.
  - **303** : est levée si aucun jar n'a été trouvé après la construction du projet maven.
  - **304** : est levée si aucun jar n'a été trouvé après la construction du projet ant.
  - **305** : est levée si aucun jar n'a été trouvé après la construction du projet gradle.
  - **306** : est levée si aucun exécutable n'a été trouvé pour un projet basé sur des exécutables.

- Les erreurs liés à la présence de certains dossiers :
  - **401** : est levée si un dossier opt existe dans le git proposé. Le dossier opt est réservé pour les sources du package, il est créé lors de sa création.
  - **402** : est levée si un dossier usr existe dans le git proposé. Le dossier usr est réservé pour les commandes que le package propose, il est crée lors de sa création.

## **Perspectives d'évolution :**

### **Améliorations possibles :**

#### __*build :*__

* Actuellement la version utilisée par les projet maven est traduite par le paramètre *tag*, il peut être préférable d'avoir un réel paramètre version.
* Le paramètre *tag* représentant un tag d'un dépôt github n'est pas utilisé, il faudra donc l'introduire prochainement.
* La construction d'un package se fait grâce à la commande *dpkg-deb --build*, il peut être intéressant de s'intéresser aussi à la commande *debuild*.

#### __*build_ant :*__

* Actuellement le projet se construit grâce à la commande *ant jar*. Attention si le *build.xml* n'a pas définit les dépendances entre les commandes.
* Le builder s'attend à trouver un jar nommé *{nom du package}.jar* dans *build/jar/*, c'est un critère très strict, il serait donc intéressant de le rendre plus permissif.

#### __*build_gradle :*__

* Le builder s'attend à trouver un jar nommé *{nom du package}.jar* dans *build/libs/*, c'est un critère très strict, il serait donc intéressant de le rendre plus permissif.

#### __*build_maven :*__

* Actuellement le projet se construit grâce à la commande *mvn install*. Attention si le *pom.xml* n'a pas définit les dépendances entre les commandes.
* Le builder s'attend à trouver un jar nommé *{nom du package}-{version}.jar* dans *target/*, c'est un critère très strict, il serait donc intéressant de le rendre permissif.

### **Reste à faire :**

* Agrémenter le builder d'autres types de projet, car la liste des types gérés n'est pas exhaustive : CMake, SCons, Waf, etc...
* Le plus important est d'améliorer la modularité du builder, actuellement le builder est stable, mais ce n'est qu'une base.
