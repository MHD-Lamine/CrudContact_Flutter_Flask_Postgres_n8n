from flask import Blueprint, request, jsonify
from models import Contact
from database import SessionLocal

routes = Blueprint("routes", __name__)
db = SessionLocal()

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
