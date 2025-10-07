import sys
import requests
from dotenv import load_dotenv
import os

load_dotenv()
SECRET_KEY = os.getenv('API_KEY')

sys.stdout.reconfigure(encoding='utf-8')

data = []

for x in range(10):
    url = f'https://api.themoviedb.org/3/movie/popular?api_key={SECRET_KEY}&page={x+1}'
    response = requests.get(url)
    if response.status_code == 200:
        json_data = response.json()
        data += json_data.get("results", [])
    else:
        print(f"Erreur sur la page {x+1}: {response.status_code}")

data_limit = data[0:30]

print(data_limit)
print(len(data_limit))
