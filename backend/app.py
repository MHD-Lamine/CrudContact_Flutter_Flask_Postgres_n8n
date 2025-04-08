from flask import Flask
from database import Base, engine
from routes import routes

app = Flask(__name__)
Base.metadata.create_all(bind=engine)
app.register_blueprint(routes)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
