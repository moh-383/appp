# 🤖 Rover Data & Mine Detection App

Application Flutter pour le contrôle d’un rover autonome dédié à la *collecte de données environnementales* et à la *détection de mines terrestres*.

## 🧭 Fonctionnalités principales

- 🎮 *Contrôle du rover* à distance (mouvement, arrêt, vitesse)
- 📊 *Visualisation en temps réel* des données collectées (ex : température, humidité, qualité de l’air, etc.)
- 🗺 *Cartographie interactive* avec affichage de la position du rover
- 💥 *Détection de mines* avec alertes visuelles/audio
- 🔐 *Interface sécurisée* avec mode administrateur

## 🖥 Écrans de l'application

| Écran              | Description                                           
| 🏠 Accueil          | Présentation du projet + navigation vers les autres pages |

| 🎮 Contrôle         | Interface de pilotage (direction, vitesse, commandes) |

| 📈 Données          | Affichage des mesures récupérées par les capteurs    |

| 🗺 Cartographie     | Carte avec localisation et itinéraire du rover       |

| Paramètres    |  Contenant différents paramètres       |

## 🧪 Technologies utilisées

- *Flutter* pour l’interface mobile (Android / iOS)
- *Python (Flask ou FastAPI)* pour le backend API
- *Kivy* pour la version locale embarquée
- *WebSockets* pour la communication temps réel (optionnel)
- *Capteurs connectés* via Arduino ou Raspberry Pi (hors app Flutter)

## 🚀 Installation rapide

### Prérequis

- Flutter SDK : [Installer Flutter](https://flutter.dev/docs/get-started/install)
- Python 3.9+
- Android Studio ou VS Code
- Git

### 1. Cloner le projet


git clone https://github.com/moh-383/appp.git

### 2. Lancer l'application Flutter 
flutter run 

### 3. Lancer le backend 

cd backend/
pip install -r requirements.txt
python main.py
---

### ✅ Partie "Collaboration" (commandes Git utiles) :

## 👥 Collaboration

### 1. Crée une branche :

git checkout -b nom-de-ta-branche


Pour pousser la branche sur github:

git push -u origin nom-de-ta-branche


### 2. Push tes modifications 


git add .


git commit -m "Ajout de l'écran de visualisation des données ou tout autre message"


git push 
