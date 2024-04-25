from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager

app = Flask(__name__, template_folder='templates/', static_folder='templates/static/')
app.config['SECRET_KEY']= 'd7ffffeda6d2eee20b6678d783312c7b'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'
db = SQLAlchemy(app)
bcrypt = Bcrypt(app)
login_manager = LoginManager(app)
# app.config['OPTIONS'] = {'index_files': []}

from flaskblog import routes
