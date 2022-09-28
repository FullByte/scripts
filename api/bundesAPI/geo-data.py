from deutschland.geo import Geo
geo = Geo()
# top_right and bottom_left coordinates
data = geo.fetch([52.530116236589244, 13.426532801586827],
                 [52.50876180448243, 13.359631043007212])
print(data.keys())
# dict_keys(['Adresse', 'Barrierenlinie', 'Bauwerksflaeche', 'Bauwerkslinie', 'Bauwerkspunkt', 'Besondere_Flaeche', 'Besondere_Linie', 'Besonderer_Punkt', 'Gebaeudeflaeche', 'Gebaeudepunkt', 'Gewaesserflaeche', 'Gewaesserlinie', 'Grenze_Linie', 'Historischer_Punkt', 'Siedlungsflaeche', 'Vegetationslinie', 'Verkehrsflaeche', 'Verkehrslinie', 'Verkehrspunkt', 'Hintergrund'])

print(data["Adresse"][0])
# {'geometry': {'type': 'Point', 'coordinates': (13.422642946243286, 52.51500157651358)}, 'properties': {'postleitzahl': '10179', 'ort': 'Berlin', 'ortsteil': 'Mitte', 'strasse': 'Holzmarktstraße', 'hausnummer': '55'}, 'id': 0, 'type': 'Feature'}
