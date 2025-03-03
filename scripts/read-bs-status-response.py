import json
import argparse
import http.client
import time
import os
from types import SimpleNamespace
from enum import Enum

# Constantes
sleep_time = 10

class Status(Enum):
    SUCCESS = "done"
    FAILED = "failed"
    RUNNING = "running"
    TIMEOUT = "timeout"

    def toString(self):
        translations = {
            "done": "Sucesso :white_check_mark:",
            "failed": "Falhou :x:",
            "running": "Executando",
            "timeout": "Timeout"
        }
        return translations[self.value]

# Parse do hash token
parser = argparse.ArgumentParser(description='Processa uma string JSON e decodifica seus dados.')
parser.add_argument('token', type=str, help='A string JSON a ser processada')
args = parser.parse_args()

# Request para api do BS para identificar a ultima build gerada com status diferente de "running"
bs_conn = http.client.HTTPSConnection("api-cloud.browserstack.com")
payload = ''
headers = {
  'Authorization': f'Basic {args.token}'
}

bs_conn.request("GET", "/app-automate/builds.json?&limit=1", payload, headers)
res = bs_conn.getresponse()
data = res.read()

data = json.loads(data, object_hook=lambda d: SimpleNamespace(**d))

automation_build = data[0].automation_build

session_detail = SimpleNamespace(device = "", browserstack_status = Status.RUNNING.value, app_details = SimpleNamespace(app_version = ""), public_url = "", duration = 0)
counter = 1

# Pulling para buscar detalhes da sessão após o processamento do BS
while session_detail.browserstack_status == Status.RUNNING.value :
    print(f"Tentativa: {counter}, aguardando processamento do BrowserStack")
    bs_conn.request("GET", f"/app-automate/builds/{automation_build.hashed_id}/sessions.json", payload, headers)
    res = bs_conn.getresponse()
    data = res.read()
    data = json.loads(data, object_hook=lambda d: SimpleNamespace(**d))

    session_detail = data[0].automation_session
    counter += 1

    time.sleep(sleep_time)

# Monta e envia mensagem para Discord
message = f"""
### Execução dos testes de UI
Status: {Status(session_detail.browserstack_status).toString()}
Device: {session_detail.device}
Versão do app: {session_detail.app_details.app_version}
Tempo em execução: {session_detail.duration} segundos
Link do BrowserStack: {session_detail.public_url} 
"""

discord_conn = http.client.HTTPSConnection("discord.com")
payload = f"{{\'content\':\'{message}\'}}"

headers = {
  'Content-Type': 'application/json',
}

payload = json.dumps({
  "content": f"{message}"
})

# Envia webhook para discord
discord_conn.request("POST", "/api/webhooks/00000000000000/oaskdoaskdosadksaodko", payload, headers)
res = discord_conn.getresponse()

# Fecha conexões
bs_conn.close()
discord_conn.close()