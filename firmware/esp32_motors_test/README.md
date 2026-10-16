# Guide débutant — ESP32-CAM + Arduino + roues DC seulement

Oubliez le backend, l’app, le GPS pour l’instant.

## Vidéos à regarder (dans l’ordre)

1. **Installer ESP32 dans Arduino**  
   YouTube : chercher `installer esp32 arduino ide francais`  
   Exemple : tutos Random Nerd Tutorials / ElectroSolution « Add ESP32 to Arduino IDE »

2. **Flasher une ESP32-CAM (GPIO0, adaptateur)**  
   YouTube : chercher `ESP32-CAM flasher arduino AI Thinker`  
   Points importants dans la vidéo : GPIO0 → GND pour flasher, puis retirer après upload

3. **L298N + 2 moteurs DC**  
   YouTube : chercher `L298N 2 moteurs DC tutoriel`  
   Comprendre IN1 IN2 IN3 IN4 + alimentation moteurs

Puis revenez ici pour **notre sketch simple**.

---

## Matériel pour cette étape

- ESP32-CAM + adaptateur USB
- L298N
- 2 moteurs DC (+ roues)
- Batterie / alim pour les moteurs (ex. 7–12 V selon moteurs)
- Fils Dupont

## Câblage L298N → ESP32-CAM

| L298N | ESP32-CAM |
| --- | --- |
| IN1 | GPIO **13** |
| IN2 | GPIO **15** |
| IN3 | GPIO **14** |
| IN4 | GPIO **2** |
| GND | GND ESP32 |
| ENA / ENB | jumpers ON (ou 5 V) |
| + moteurs | borne alim du L298N (pas le 3,3 V de la CAM) |

Moteurs : OUT1/OUT2 = moteur gauche, OUT3/OUT4 = moteur droit (si un sens est inversé, inversez les 2 fils du moteur).

## Dans Arduino IDE (résumé)

1. Installer le support **esp32** (Gestionnaire de cartes)
2. Carte : **AI Thinker ESP32-CAM**
3. Port : **COMx**
4. Mode flash : **GPIO0 à GND**, brancher USB
5. Ouvrir le fichier :  
   `firmware/esp32_motors_test/esp32_motors_test.ino`
6. Cliquer **Téléverser**
7. Enlever GPIO0 de GND, appuyer RESET
8. Moniteur série **115200**
9. Taper `f` Entrée → les roues doivent tourner ; `s` = stop

## Si ça ne marche pas

| Problème | Solution |
| --- | --- |
| Connecting... forever | GPIO0 pas à GND / mauvais port COM |
| Upload OK mais rien ne bouge | Alim moteurs absente / GND pas commun |
| Un seul moteur | Vérifier IN3/IN4 et OUT3/OUT4 |
| Sens inversé | Inverser les 2 fils du moteur concerné |

Quand `f` / `s` marchent, on passera à l’étape suivante (Wi‑Fi / app).
