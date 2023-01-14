import datetime
import time
import csv

from functools import wraps
from io import StringIO
from flask import make_response
from flask import Flask
from flask import render_template
from flask import request
from flask import flash, redirect, url_for, get_flashed_messages, session
from flask_mail import Mail, Message
import mysql.connector
import os
import random
import smtplib
from email.message import EmailMessage

if os.path.isfile('.env'):
    from dotenv import load_dotenv
    load_dotenv()

app = Flask(__name__, template_folder='templates', static_folder="static")
app.secret_key = os.environ.get('secret_key')

app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = os.environ.get('EMAIL_USER')
app.config['MAIL_PASSWORD'] = os.environ.get('pass')
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True
mail = Mail(app)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('error.html'), 404

# functie pentru a ne asigura ca utilizatorul este logat
def login_required(func):
   @wraps(func)
   def wrapper(*args, **kwargs):
       if 'logged_in' not in session:
           flash('Please sign in')
           return redirect(url_for('render_sign_in'))
       elif 'logged_in' in session and session['logged_in'] == False:
           flash('Please sign in')
           return redirect(url_for('render_sign_in'))
       return func(*args, **kwargs)
   return wrapper

@app.route('/index.html')
@app.route('/')
def render_index():
    get_flashed_messages()
    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT idProdus, furnizor, departament, numeProdus, nota, pret, cantitate from tblinventar"

    cur.execute(query)
    results = cur.fetchall()

    # Close the cursor and connection
    cur.close()
    conn.close()
    dir_list = os.listdir('./static/Images')
    results_dict = [{'id_produs': row[0],
                     'furnizor': row[1],
                     'departament': row[2],
                     'nume_produs': row[3],
                     'nota': row[4],
                     'pret': row[5],
                     'cantitate': row[6]
                     }
                    for row in results if f'{row[0]}_0.jpg' in dir_list]
    random.shuffle(results_dict)
    # Render the template

    return render_template('index.html', results=results_dict[0:4])

@app.route('/about.html')
def render_about():
    return render_template('about.html')

@app.route('/sign-in.html')
def render_sign_in():
    return render_template('sign-in.html')


@app.route('/contact.html')
def render_contact():
    return render_template('contact.html')

@app.route('/sterge_comanda')
def render_sterge_comanda():

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT idComanda, id_Factura, id_Produs, CantitateProdus, PretProdus from tbldetaliifacturi"

    cur.execute(query)
    results = cur.fetchall()

    # Close the cursor and connection
    cur.close()
    conn.close()
    dir_list = os.listdir('./static/Images')
    data = [{'id_comanda': row[0],
                     'id_factura': row[1],
                     'id_produs': row[2],
                     'cantitate_produs': row[3],
                     'pret_produs': row[4],
                     }
                    for row in results]

    return render_template('sterge_comanda.html', data=data)



@app.route('/sign-out')
def sign_out():
    session['logged_in'] = False
    session['user'] = ''
    session['status'] = ''
    return redirect(url_for('render_success'))

@app.route('/success.html')
def render_success():
    return render_template('success.html')

@app.route('/products.html')
def render_products():
    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT idProdus, furnizor, departament, numeProdus, nota, pret, cantitate from tblinventar"

    cur.execute(query)
    results = cur.fetchall()

    # Close the cursor and connection
    cur.close()
    conn.close()
    dir_list = os.listdir('./static/Images')
    results_dict = [{'id_produs': row[0],
                     'furnizor': row[1],
                     'departament': row[2],
                     'nume_produs': row[3],
                     'nota': row[4],
                     'pret': row[5],
                     'cantitate': row[6]
                     }
                    for row in results if f'{row[0]}_0.jpg' in dir_list]
    # Render the template
    return render_template('products.html', results=results_dict)

@app.route('/single-product.html')
@app.route('/single-product')
def render_single_product():
    id_produs = request.args.get('id_produs')
    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT idProdus, furnizor, departament, numeProdus, nota, pret, cantitate " \
            "FROM tblinventar " \
            f"WHERE idProdus={id_produs}"

    cur.execute(query)
    results = cur.fetchone()

    # Close the cursor and connection
    cur.close()
    conn.close()
    results_dict = {'id_produs': results[0],
                     'furnizor': results[1],
                     'departament': results[2],
                     'nume_produs': results[3],
                     'nota': results[4],
                     'pret': results[5],
                     'cantitate': results[6]
                     }


    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = f"SELECT numeDepartament, categorieDepartament, sezon " \
            f"FROM tbldepartament " \
            f"WHERE idDepartament={results_dict['departament']}"

    cur.execute(query)
    results = cur.fetchone()
    # Close the cursor and connection
    cur.close()
    conn.close()

    categorie = ','.join(results)
    results_dict['categorie'] = categorie
    # Render the template
    return render_template('single-product.html', results=results_dict)

@app.route('/reclamatie', methods=['POST'])
def register_new_user():
    name = request.form['name']
    email = request.form['email_contact']
    subiect = request.form['subject']
    reclamatie = request.form['message']

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "INSERT INTO tblreclamatii (nume, email, subiect, reclamatie) VALUES (%s, %s, %s, %s)"
    cur.execute(query, (name, email, subiect, reclamatie))
    conn.commit()

    # Close the cursor and connection
    cur.close()
    conn.close()

    return redirect(url_for('render_success'))

@app.route('/send-email', methods=['POST'])
def send_email():
    email_address = request.form['email']

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "INSERT INTO tblabonati (adresaEmail) VALUES (%s)"
    values = (email_address,)
    cur.execute(query, values)
    conn.commit()

    # Close the cursor and connection
    cur.close()
    conn.close()
    # creates SMTP session
    s = smtplib.SMTP('smtp.gmail.com', 587)

    # start TLS for security
    s.starttls()

    # message to be sent
    message = "Subject: Abonare utilizator nou \n\n Felicitari. Te-ai abonat cu succes"

    # Authentication
    s.login(os.environ.get('EMAIL_USER'), os.environ.get('EMAIL_PASS'))

    # sending the mail
    s.sendmail(os.environ.get('EMAIL_USER'), email_address, message)

    # terminating the session
    s.quit()
    return redirect(url_for('render_success'))



@app.route('/signin', methods=['POST'])
def sign_in():
    email = request.form['username']
    password = request.form['password']
    # Check if the username and password are correct

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT * FROM tblutilizatori WHERE email = %s AND parola = %s"
    cur.execute(query, (email, password))
    user = cur.fetchone()

    # Close the cursor and connection
    cur.close()
    conn.close()

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT * FROM tblangajati WHERE email = %s AND parola = %s"
    cur.execute(query, (email, password))
    angajat = cur.fetchone()

    # Close the cursor and connection
    cur.close()
    conn.close()

    if user is not None:
        # The username and password are correct
        session['logged_in'] = True
        session['user'] = user
        session['status'] = 'user'
        return redirect(url_for('render_index'))
    elif angajat is not None:
        session['logged_in'] = True
        session['user'] = angajat
        session['status'] = 'angajat'
        return redirect(url_for('render_index'))
    else:
        # The username and password are incorrect
        flash('Combinatia de email, parola este incorecta. Te rugam sa incerci din nou!')
        return redirect(url_for('render_sign_in'))



@app.route('/signup', methods=['POST'])
def sign_up():
    full_name = request.form['fullname']
    email = request.form['email']
    password = request.form['password']
    # Check if the username and password are correct

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT * FROM tblutilizatori WHERE email = %s AND parola = %s"
    cur.execute(query, (email, password))
    user = cur.fetchone()

    # Close the cursor and connection
    cur.close()
    conn.close()

    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "SELECT * FROM tblangajati WHERE email = %s AND parola = %s"
    cur.execute(query, (email, password))
    angajat = cur.fetchone()

    # Close the cursor and connection
    cur.close()
    conn.close()

    if user is None and angajat is None:
        # Connect to the database
        conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                       database=os.environ.get('DATABASE_NAME'),
                                       user=os.environ.get('DATABASE_USER'),
                                       password=os.environ.get('DATABASE_PASSWORD'))
        cur = conn.cursor()
        # Execute a SELECT query to retrieve the user's record
        query = "INSERT INTO tblutilizatori (nume, email, parola) VALUES (%s, %s, %s)"
        cur.execute(query, (full_name, email, password))
        conn.commit()

        # Close the cursor and connection
        cur.close()
        conn.close()
        session['logged_in'] = False
        session['user'] = ''
        session['status'] = ''

        return redirect(url_for('render_index'))

    else:
        # The username and password are incorrect
        flash('Emailul exista deja in baza de date. Te rugam sa incerci din nou!')
        return redirect(url_for('render_sign_in'))


@app.route('/finalizare-comanda', methods=['POST'])
@login_required
def finalizare_comanda():
    pret = request.form['pret']
    quantity = request.form['quantity']
    id_produs = request.form['id_produs']

    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    query = "INSERT INTO tbldetaliifacturi (id_Produs, cantitateProdus, pretProdus) VALUES (%s, %s, %s)"
    cur.execute(query, (id_produs, quantity, pret))
    conn.commit()

    # Close the cursor and connection
    cur.close()
    conn.close()

    return redirect(url_for('render_success'))



@app.route('/sterge_comanda' , methods=['POST'])
@login_required
def sterge_comanda():

    id_comanda = request.form['id_comanda']


    # Connect to the database
    conn = mysql.connector.connect(host=os.environ.get('DATABASE_HOST'),
                                   database=os.environ.get('DATABASE_NAME'),
                                   user=os.environ.get('DATABASE_USER'),
                                   password=os.environ.get('DATABASE_PASSWORD'))
    cur = conn.cursor()
    # Execute a SELECT query to retrieve the user's record
    # Define the DELETE statement
    query = "DELETE FROM tbldetaliifacturi WHERE idComanda = %s"
    values = (id_comanda, )

    # Execute the DELETE statement
    cur.execute(query, values)
    conn.commit()

    # Close the connection
    conn.close()

    return redirect(url_for('render_success'))

if __name__ == '__main__':
    app.run()
