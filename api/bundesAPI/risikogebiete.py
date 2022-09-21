#pip install git+https://github.com/bundesAPI/deutschland.git
 
import time
from deutschland import risikogebiete
from pprint import pprint
from deutschland.risikogebiete.api import default_api
from deutschland.risikogebiete.model.risk_countries import RiskCountries
# Defining the host is optional and defaults to https://api.einreiseanmeldung.de/reisendenportal
# See configuration.py for a list of all supported configuration parameters.
configuration = risikogebiete.Configuration(
    host = "https://api.einreiseanmeldung.de/reisendenportal"
)

# Enter a context with an instance of the API client
with risikogebiete.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    
    try:
        # Liste der Länder
        api_response = api_instance.risikogebiete_get()
        pprint(api_response)
    except risikogebiete.ApiException as e:
        print("Exception when calling DefaultApi->risikogebiete_get: %s\n" % e)
