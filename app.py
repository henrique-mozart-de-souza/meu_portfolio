from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

# Rota principal (Página inicial)
@app.route('/')
def index():
    return render_template('index.html')

# Rota para baixar o currículo
@app.route('/download-cv')
def download_cv():
    # Caminho para a pasta onde o PDF está salvo
    pasta_docs = os.path.join(app.root_path, 'static', 'docs')
    # Retorna o arquivo como um anexo para download
    return send_from_directory(directory=pasta_docs, path='curriculo.pdf', as_attachment=True)

if __name__ == '__main__':
    # Roda em modo debug apenas quando executado diretamente (sem Gunicorn)
    app.run(debug=True, host='0.0.0.0', port=5000)