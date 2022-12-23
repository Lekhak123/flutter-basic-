from flask import Flask, request, jsonify, send_file

app = Flask(__name__)
import mysql.connector


mydb = mysql.connector.connect(host="localhost", user="root", password="root")
cursor = mydb.cursor(buffered=True)
cursor.execute("CREATE DATABASE IF NOT EXISTS FOO;")
cursor.execute("USE FOO;")
cursor.execute("CREATE TABLE IF NOT EXISTS data (name VARCHAR(255));")


@app.route("/entry", methods=["POST"])
def tts():

    json = request.get_json()
    text = json.get("text")
    if not text:
        return "text field is required"
    else:
        try:
            sql = "INSERT INTO data (name) VALUES ('{}')".format(text)
            cursor.execute(sql)
            mydb.commit()
            message = jsonify(entry= text,status=True)
            return message
        except Exception as error:
            print(error)
            return False


@app.route("/clear", methods=["POST"])
def clear():
    try:
        sql = "TRUNCATE TABLE data"
        cursor.execute(sql)
        mydb.commit()
        msg = "Cleared the table."
        return msg
    except Exception as error:
        print(error)
        return "Error in /clear"



if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)
