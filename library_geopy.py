'''
Geopy. Calculates latitude & longitude.
'''

import geopy
from geopy.geocoders import Nominatim, Photon

"""
GRIVEGNEE: LAT: 50.6299443 & LONG: 5.6244572
TOURNAI: LAT: 50.6039353 & LONG: 3.404471
"""

# create object with user => CHOOSE NEW USER AGENT 
geolocator = Photon(user_agent="whadup")

# address text
grivegnee = 'Rue Servais-Malaise 31, GRIVEGNEE'
tournai = 'LES BASTIONS Boulevard Walter de Marvis, TOURNAI'

# print results
location = geolocator.geocode(grivegnee)
print("\n{}\nLAT: {}\nLONG: {}".format(grivegnee, location.latitude, location.longitude))

location = geolocator.geocode(tournai)
print("\n{}\nLAT: {}\nLONG: {}".format(tournai, location.latitude, location.longitude))


print("\nDone.\n")
