export SENDGRID_API_KEY='SG.something'

curl --request POST --url https://api.sendgrid.com/v3/mail/send --header "Authorization: Bearer $SENDGRID_API_KEY" --header 'Content-Type: application/json' --data '{"personalizations": [{"to": [{"email": "reciever@mail.tld"}]}],"from": {"email": "sender@mail.tld"},"subject": "Sending with SendGrid is Fun","content": [{"type": "text/plain", "value": "and easy to do anywhere, even with cURL"}]}'