import json
import os
import folium

worldmap = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'world-countries.json')
output = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'index.html')

visited = ['Belgium', 'United States of America', 'Denmark', 'Germany', 'Norway', 'Japan', 
'Thailand', 'New Zealand', 'Spain', 'Italy', 'Czech Republic', 'Nepal', 'Austria',
'Switzerland', 'Estonia', 'France', 'United Kingdom', 'Hungary', 'Ireland', 'South Korea',
 'Luxembourg', 'Netherlands', 'Poland', 'Slovakia', 'Sweden', 'Canada', 'Greece', 'China',
 'Taiwan', 'Malaysia']

new_features = []
with open(worldmap, 'r') as f: world_countries = json.loads(f.read())

for feature in world_countries['features']:
    if feature['properties']['name'] in visited:
        new_features.append(feature)

new_world_countries = world_countries
new_world_countries['features'] = new_features

m = folium.Map(location=[51, 0], zoom_start=2.5)
folium.Choropleth(geo_data=new_world_countries, highlight=True, fill_color='orange', fill_opacity=0.2, line_color='orange').add_to(m)
folium.LayerControl().add_to(m)

textfile = open(output, "w")
textfile.write(m.get_root().render())
textfile.close()
