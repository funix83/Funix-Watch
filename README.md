# Funix Watch
## Version française
**Funix Watch** est un exemple de l'utilisation du [SDK Connect IQ](https://developer.garmin.com/connect-iq/overview/) pour personnaliser l'affichage d'une montre Garmin. Il est configuré pour pouvoir être utilisé sur une montre Garmin Instinct 2 (modèle surf) mais il est assez facile de personnaliser le code.
L'environnement de développement utilisé est [Visual Studio Code](https://code.visualstudio.com/) sous linux avec l'extension Connect IQ. Vous trouverez davantage de détails sur l'installation de cette environnement sur mon site [Funix](https://www.funix.org/fr/linux/index.php?ref=garmin).

Avec ces sources vous saurez comment:
- faire un rafraichissement toutes les secondes pour l'affichage des secondes et des battements de coeurs en utilisant la fonction [onPartialUpdate](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-get-my-watch-face-to-update-every-second/)
- Créer une jauge graphique pour la charge batterie et le ratio pas et objectif de pas quotidien
- Rajouter une font personnalisée
- Rajouter des images personnalisées

**Avertissement**
Ces sources sont mises à disposition sous licence GPL à des fins didactiques sans aucune garantie de résultat, je ne saurais être tenu responsable de tout dommage sur votre montre GPS.

## English version
**Funix Watch** is an example of using the [Connect IQ SDK](https://developer.garmin.com/connect-iq/overview/) to customize the display of a Garmin watch. It is configured for use on a Garmin Instinct 2 watch (surfing model) but it is quite easy to customize the code.
The development environment used is [Visual Studio Code](https://code.visualstudio.com/) under Linux with the Connect IQ extension. You will find more details on installing this environment on my site [Funix](https://www.funix.org/fr/linux/index.php?ref=garmin).

With these sources you will know how to:
- refresh every second for the seconds display and heartbeat display using the [onPartialUpdate](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-get-my) function -watch-face-to-update-every-second/)
- Create a graphical battery gauge
- Add a custom font
- Add personalized images

** Warning **
These sources are made available under GPL license for educational purposes without any guarantee of results, I cannot be held responsible for any damage to your GPS watch.

## Change Log

* *Version 1.1.0*

Icon of quality GPS (GPS is unavalaible with watchface app, only works when an activity is launched)

![Garmin-Funix-Watch-1440-720-v1 1 0](https://github.com/user-attachments/assets/af6db280-269e-4106-94a9-e2c0e75d99d5)

* *Version 1.0.0*

color inversion in the top right dial

![Garmin-Funix-Watch-1440-720-v0 5 0](https://github.com/user-attachments/assets/c50e7b90-65aa-4d4d-919c-429a8b949337)

* *Version 0.4.0*

With a uniform font for hours and minutes

![Garmin-Funix-Watch-1440-720-v0 4 0](https://github.com/user-attachments/assets/cfd318fc-26e8-44a6-8ec0-4c5b2b96dcc9)

* *Version 0.3.0*

With the day of week, a different font for seconds and update of heartbeat every seconds

![Garmin-Funix-Watch-1440-720-v0 3 0](https://github.com/user-attachments/assets/ff99f5f5-88b9-4772-9dbf-26fe19347b03)

* *Version 0.2.0*

With the arc-shaped gauges for battery and steps and a outline font for minutes

  ![connectiq-funixv2-1](https://github.com/user-attachments/assets/441986ec-3ff9-4586-9282-b6e05f36a5e8)

* *Version 0.1.0*

Initial version with a rectangle gauge for battery

  ![connectiq-render](https://github.com/user-attachments/assets/1f515dfc-5175-4883-8076-f0303528f3fc)



