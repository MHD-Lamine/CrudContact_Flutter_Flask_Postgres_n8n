from flask import Blueprint, request, jsonify
from models import Contact
from database import SessionLocal
import requests

routes = Blueprint("routes", __name__)
db = SessionLocal()

def notifier_n8n(contact):
    try:
        response = requests.post(
            "http://n8n:5678/webhook-test/new-contact",  # entre conteneurs Docker
            json={
                "nom": contact.nom,
                "email": contact.email,
                "telephone": contact.telephone
            },
            timeout=5
        )
        print("Webhook n8n envoyé avec succès :", response.status_code)
    except Exception as e:
        print("Erreur lors de l'envoi du webhook n8n :", e)

@routes.route("/contacts", methods=["GET"])
def get_contacts():
    contacts = db.query(Contact).all()
    return jsonify([{
        "id": c.id,
        "nom": c.nom,
        "email": c.email,
        "telephone": c.telephone
    } for c in contacts])

@routes.route("/contacts", methods=["POST"])
def add_contact():
    data = request.json
    contact = Contact(nom=data["nom"], email=data["email"], telephone=data["telephone"])
    db.add(contact)
    db.commit()
    
    # Notifier n8n après ajout
    notifier_n8n(contact)

    return jsonify({"message": "Contact ajouté"})

@routes.route("/contacts/<int:id>", methods=["PUT"])
def update_contact(id):
    data = request.json
    contact = db.query(Contact).get(id)
    if not contact:
        return jsonify({"error": "Contact non trouvé"}), 404
    contact.nom = data["nom"]
    contact.email = data["email"]
    contact.telephone = data["telephone"]
    db.commit()
    return jsonify({"message": "Contact modifié"})

@routes.route("/contacts/<int:id>", methods=["DELETE"])
def delete_contact(id):
    contact = db.query(Contact).get(id)
    if not contact:
        return jsonify({"error": "Contact non trouvé"}), 404
    db.delete(contact)
    db.commit()
    return jsonify({"message": "Contact supprimé"})
