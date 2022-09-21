import time
from deutschland import autobahn
from deutschland.autobahn.api import default_api
from deutschland.autobahn.model.webcam import Webcam
from pprint import pprint
# Defining the host is optional and defaults to https://verkehr.autobahn.de/o/autobahn
# See configuration.py for a list of all supported configuration parameters.
configuration = autobahn.Configuration(
    host = "https://verkehr.autobahn.de/o/autobahn"
)


# Enter a context with an instance of the API client
with autobahn.ApiClient() as api_client:
    # Create an instance of the API class
    api_instance = default_api.DefaultApi(api_client)
    webcam_id = "V0VCQ0FNX19OUldfU2lsYS1TaWduYWxiYXVfMTAxMDgxNDE3MjM4ODYzOTk5MTU=" # str | 

    # example passing only required values which don't have defaults set
    try:
        # Details einer Webcam
        api_response = api_instance.get_webcam(webcam_id)
        pprint(api_response)
    except autobahn.ApiException as e:
        print("Exception when calling DefaultApi->get_webcam: %s\n" % e)