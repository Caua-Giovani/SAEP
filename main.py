from flask import Flask, render_template, request, redirect, session, jsonify, url_for, flash
from conexao import conectar
from datetime import timedelta

app = Flask("__name__")

app.secret_key = "banana"
app.config["PERMANENT_SESSION_LIFETIME"] = timedelta(minutes=30)

@app.route("/")
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "GET":
        return render_template("login.html")

    if request.method == "POST":
        conexao, cursor =  conectar()

        cursor.execute("""
            SELECT login FROM usuario
            WHERE login = %s
            AND senha = %s;
    """,(request.form.get("login"), request.form.get("senha")))

    usuario = cursor.fetchone()

    if usuario:
        session["usuario"] = usuario
        session.permanent = True
        return redirect("/principal")
    else:
        return "USUARIO OU SENHA INCORRETA"

@app.route("/principal")
def principal():
    return render_template("principal.html")
@app.route("/logoff")
def logoff():
    session.clear()
    return redirect("/login")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)