PlanMyWeek
PlanMyWeek ist eine App zur Planung und Verwaltung von wöchentlichen Aktivitäten. Sie ermöglicht es den Benutzern, ihre Termine effizient zu organisieren, zu verwalten und anzupassen.

Funktionen

Hinzufügen von Aktivitäten: Benutzer können neue Aktivitäten hinzufügen, indem sie Titel, Beschreibung, Datum, Standort, Kategorie und Bild auswählen.
Bearbeiten und Löschen von Aktivitäten: Bestehende Aktivitäten können bearbeitet oder gelöscht werden.
Kartenansicht und Standortauswahl: Interaktive Kartenansicht zur Auswahl und Anzeige von Standorten für Aktivitäten.
Filterung von Aktivitäten: Aktivitäten können nach Kategorien (z.B. Wichtig, Normal, Optional) und Datum gefiltert werden.
Benachrichtigungen und Erinnerungen: Benutzer können Benachrichtigungen für bevorstehende Aktivitäten erhalten.
Benutzeroberfläche
Hauptseite
Die Hauptseite der App zeigt eine Liste aller geplanten Aktivitäten. Benutzer können Aktivitäten hinzufügen, bearbeiten oder löschen. Durch Klicken auf eine Aktivität gelangen sie zu den Details der Aktivität.

Aktivitätsdetails
Zeigt die Details einer ausgewählten Aktivität an, einschließlich Titel, Beschreibung, Datum, Standort, Kategorie und Bild. Benutzer können die Aktivität bearbeiten oder löschen.

Kategorienansicht
Zeigt eine Liste der Aktivitäten basierend auf der ausgewählten Kategorie an. Benutzer können die Aktivitäten nach Wichtigkeit (Wichtig, Normal, Optional) filtern.

Kartenansicht
Ermöglicht die Auswahl und Anzeige von Standorten für Aktivitäten. Benutzer können Standorte hinzufügen und Marker auf der Karte setzen.

Kalenderansicht
Zeigt die Aktivitäten basierend auf einem ausgewählten Datum an. Benutzer können die Aktivitäten nach Tagen, Wochen oder Monaten filtern.


Installation

Klone das Repository:


git clone <repository-url>
Wechsle in das Projektverzeichnis:


cd plan_my_week
Installiere die Abhängigkeiten:


flutter pub get


Verwendung

Starte die App:

flutter run

Fülle deine grundlegenden Daten aus.
Bestimme deine Aktivitäten und plane sie für die Woche.
Verfolge und verwalte deine Aktivitäten über die verschiedenen Ansichten der App.


Projektstruktur
lib/
activity_controller/: Enthält den ActivityController, der die Benutzeraktionen verwaltet.
activity_manager/: Enthält den ActivityManager, der die Geschäftslogik der Aktivitätsdatenverwaltung implementiert.
db_manager/: Enthält den DatabaseManager, der die Datenbankoperationen verwaltet.
map_controller/: Enthält den MapController, der die Kartenlogik verwaltet.
screens/: Enthält die verschiedenen Ansichten der App (ActivityDetailsView, AddEditActivityView, CategoryView, MainActivityView, MapView, DateView).
models/: Enthält die Datenmodelle (ActivityModel, CategoryModel).
Tests
Führe die Unit-Tests und Widget-Tests aus, um die Funktionsfähigkeit der App zu überprüfen:

flutter test

Verwendete Technologien und Bibliotheken

Flutter: Hauptframework für die App-Entwicklung
Sqflite: SQLite-Plugin für lokale Datenbankoperationen
OpenStreetMap (über flutter_map): Für die Kartenansicht und Standortauswahl
intl: Für die Datum- und Zeitformatierung
flutter_map: Für die Kartenansicht
latlong2: Für die Handhabung geografischer Koordinaten
location: Für den Zugriff auf den aktuellen Standort des Nutzers
get: Für das State-Management und Navigation
table_calendar: Für die Kalenderansicht
image_picker: Für das Auswählen und Hochladen von Bildern
path: Für Dateipfade
permission_handler: Für die Verwaltung von App-Berechtigungen
mockito: Für das Mocking in Unit-Tests


Weitere Ressourcen

Lab: Write your first Flutter app
Cookbook: Useful Flutter samples
Flutter online documentation