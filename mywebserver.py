from flask import Flask, request as REQ
import sqlite3

App = Flask(__name__)
@App.route('/data', methods=['POST'])
def get_data():
    dD = REQ.json
    print((
        dD['id'],\
        dD['mp01'], dD['mp02'], dD['mp03'],\
        dD['hi01'], dD['hi02'], dD['hi03'],\
        dD['hi04'], dD['hi05'], dD['hi06'],\
        dD['te'], dD['hr']
    ))
    # Conexión a la base de datos SQLite
    conn = sqlite3.connect('IOT.db')
    cursor = conn.cursor()

    # Consulta para insertar datos a la tabla
    cursor.execute(
        "INSERT INTO sensores (id, mp01, mp02, mp03, hi01, hi02, hi03, hi04, hi05, hi06, te, hr) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (
            dD['id'], 
            dD['mp01'], dD['mp02'], dD['mp03'],
            dD['hi01'], dD['hi02'], dD['hi03'],
            dD['hi04'], dD['hi05'], dD['hi06'],
            dD['te'], dD['hr']
        )
    )

    # Guardar cambios y cerrar conexion a la bd
    conn.commit()
    conn.close()

    return 'Datos almacenados en la base de datos'
if __name__ == '__main__':
    App.run(debug=True, host='0.0.0.0', port=7070)