from flask import Flask , request, jsonify, render_template , url_for , redirect , flash 
from flaskblog import app, db, bcrypt
from flaskblog.forms import RegistrationForm, LoginForm
from flaskblog.models import User, Post
from flask_login import login_user, current_user, logout_user, login_required
import tensorflow as tf
import numpy as np
from PIL import Image,  UnidentifiedImageError



# Load the trained model
model = tf.keras.models.load_model('model_2 (3).h5')

# Define function to preprocess image for model input
def predict_category(file):
    categories = ['glioma_tumor', 'meningioma_tumor', 'pituitary_tumor', 'no_tumor']
    img = Image.open(file)
    img = img.resize((224, 224))
    
    # Convert image to 3-channel format if necessary
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    i = np.array(img, dtype='float32')
    i /= 255.0 # normalize image
    arr_reshaped = i.reshape((-1, 224, 224, 3))
    output = model.predict(arr_reshaped)
    result = categories[np.argmax(output)]
    return result

@app.route('/' , methods=['GET'])
def home():
    return render_template('index.html')



@app.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('prediction'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()
        if user and bcrypt.check_password_hash(user.password , form.password.data) :
            login_user(user, remember=form.remember.data)
            return redirect(url_for('prediction'))
        else : 
            flash('Login Unsuccessful. Please check email and password', 'danger')
    return render_template('login.html', title='Login', form=form)



@app.route("/Signup", methods=['GET', 'POST'])
def Signup():
    if current_user.is_authenticated:
        return redirect(url_for('prediction'))
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf_8')
        user = User(email=form.email.data, password=hashed_password)
        db.session.add(user)
        db.session.commit()
        #to query all users
        # u=User.query.all()
        # for uu in u :
        #     print(uu)
        flash(f'Your account has been created! Please login', 'success')
        return redirect(url_for('login'))
    return render_template('Signup.html', title='Signup', form=form)


@app.route("/supervisors")
def super():
   
    return render_template('super.html')
    


@app.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('home'))
    





@app.route('/prediction' , methods=['GET'])
def prediction():
    return render_template('Prediction.html')






    
@app.route('/predict', methods=['POST'])
def predict_image():
    # Get image file path from request
    file = request.files['image']
    if file.filename == '':
         return jsonify({'error': 'No file selected'})


    # Make prediction with model
    predicted_category = predict_category(file)
    # Return predicted category as JSON response
    return jsonify({'category': predicted_category})



