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

@app.route("/responsavel", methods=["GET", "POST"])
def responsavel():
    if request.method == "GET":
        busca = request.args.get("busca")
        conexao,cursor = conectar()
        if busca:
            cursor.execute(""" SELECT id_responsavel, nome, cpf FROM responsavel
                                WHERE nome like %s;""", [f"%{busca}%"])
        else:
            cursor.execute(""" SELECT id_responsavel, nome, cpf FROM responsavel""")
        responsaveis = cursor.fetchall()
        conexao.close()
        return render_template("responsavel.html", responsaveis = responsaveis)

    if request.method == "POST":
        nome = request.form.get("nome")
        cpf = request.form.get("cpf")

        conexao, cursor = conectar()
        cursor.execute(""" INSERT INTO responsavel (cpf,nome)
                            VALUES (%s,%s);""",(cpf,nome))
        conexao.commit()
        conexao.close()
        return redirect("/responsavel")

@app.route("/excluir_responsavel/<id>")
def excluir_responsavel(id):
    conexao,cursor = conectar()
    cursor.execute(""" DELETE FROM responsavel 
                        WHERE id_responsavel = %s""",(id,))
    conexao.commit()
    conexao.close()

    return redirect("/responsavel")

@app.route("/alterar_responsavel",methods=["POST"])
def alterar_responsavel():
    id_responsavel= request.form.get("id_responsavel_alt")
    cpf = request.form.get("cpf_alt")
    nome = request.form.get("nome_alt")

    conexao,cursor = conectar()
    cursor.execute(""" UPDATE responsavel
                        SET cpf = %s, nome = %s
                        WHERE id_responsavel = %s;""",(cpf,nome,id_responsavel))
    conexao.commit()
    conexao.close()
    return redirect("/responsavel")
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)