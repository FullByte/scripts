import json
from deutschland.lebensmittelwarnung import Lebensmittelwarnung

lw = Lebensmittelwarnung()
# search by content type and region, see documetation for all available params
data = lw.get("lebensmittel", "niedersachsen") #alternativ: alle
my_json = json.dumps(data, indent=5)
print(my_json)
