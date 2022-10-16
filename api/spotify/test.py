import requests
import base64

client_id = ""
client_secret = ""

encoded = base64.b64encode((client_id + ":" + client_secret).encode("ascii")).decode("ascii")

headers = {
     "Content-Type": "application/x-www-form-urlencoded",
     "Authorization": "Basic " + encoded
}
 
payload = {
     "grant_type": "client_credentials"
}
 
response = requests.post("https://accounts.spotify.com/api/token", data=payload, headers=headers)
print(response)
print(response.text)