# 📱 Gestion de Contacts – Flutter + Flask + PostgreSQL + n8n

Une application complète permettant d’ajouter, modifier, supprimer et consulter des contacts avec une interface Flutter.  
Les données sont stockées dans une base PostgreSQL via une API Flask.  
Un webhook n8n permet d’envoyer un email automatiquement lorsqu’un contact est ajouté.

---

## 🔧 Technologies utilisées

- **Flutter** – Interface mobile
- **Flask** – API REST (backend)
- **PostgreSQL** – Base de données relationnelle
- **Docker & Docker Compose** – Conteneurisation des services
- **n8n** – Automatisation de workflow (notification email à l’ajout)

---

## 📦 Structure du projet

```bash
.
├── backend/                # Code Flask
│   ├── app.py
│   ├── routes.py
│   ├── models.py
│   ├── database.py
│   └── requirements.txt
├── frontend/               # Code Flutter
│   └── lib/
│       ├── main.dart
│       ├── pages/
│           ├── contact_list_page.dart
│           ├── add_contact_page.dart
│           └── edit_contact_page.dart
├── docker-compose.yml
├── .env
└── README.md
