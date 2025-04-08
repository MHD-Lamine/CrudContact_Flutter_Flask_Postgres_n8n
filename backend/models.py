from sqlalchemy import Column, Integer, String
from database import Base

class Contact(Base):
    __tablename__ = "contacts"
    id = Column(Integer, primary_key=True)
    nom = Column(String, nullable=False)
    email = Column(String, nullable=False)
    telephone = Column(String, nullable=False)
