import time
from deutschland import autobahn
from deutschland.autobahn.api import default_api
from deutschland.autobahn.model.webcams import Webcams
from deutschland.autobahn.model.road_id import RoadId
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
    road_id = RoadId("A2") # RoadId | 

    # example passing only required values which don't have defaults set
    try:
        # Liste verfügbarer Webcams
        api_response = api_instance.list_webcams(road_id)
        pprint(api_response)
    except autobahn.ApiException as e:
        print("Exception when calling DefaultApi->list_webcams: %s\n" % e)