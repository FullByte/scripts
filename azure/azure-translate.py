
import requests, uuid

# Input variables (get this from your azure translate resource)
location = "westeurope"
key = ""
url = "https://api.cognitive.microsofttranslator.com/translate"

# Translate text in various languages
def translate(text:'str', output:'dict'=[])-> 'dict':
    body = [{ 'text': text}]
    params = {'api-version': '3.0', 'from': 'en', 'to': ['de', 'ru', 'yue', 'tlh-Latn', 'ko', 'ku', 'mn-Cyrl', 'mn-Mong', 'ne', 'th', 'yua', 'ja', 'el']} #https://docs.microsoft.com/en-us/azure/cognitive-services/translator/language-support
    headers = {'Ocp-Apim-Subscription-Key': key, 'Ocp-Apim-Subscription-Region': location, 'Content-type': 'application/json', 'X-ClientTraceId': str(uuid.uuid4())}
    request = requests.post(url, params=params, headers=headers, json=body)
    result = request.json()[0]['translations']
    dict = {}
    print("-----------------------------------------------\n| ClientTraceId:\t" + str(uuid.uuid4()))
    print("| Chars to translate:\t" + str(len(result)))
    print("| Input:\t\t" + text + "\n-----------------------------------------------")
    for language in result:
        print(language['to'] + "\t" + language['text'])
        dict[language['to']] = language['text']

    return dict

translate("This is a test azure translation test!")