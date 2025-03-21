import random
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Weather API
API_KEY = "d7e4c8b1ab414b938bd235022252802"
BASE_URL = "http://api.weatherapi.com/v1/current.json"

# Cat API
CAT_SEARCH_API = "https://api.thecatapi.com/v1/images/search?has_breeds=1"
CAT_DETAILS_API = "https://api.thecatapi.com/v1/images/{}"  
# Deezer API
DEEZER_API_URL = "https://api.deezer.com/playlist/908622995/tracks"

current_song = None

@app.route('/')
def home():
    return "HEELO WORLD"

### WEATHER API ENDPOINTS ###
def fetch_weather(location="Philippines"):
    response = requests.get(BASE_URL, params={"key": API_KEY, "q": location, "aqi": "no"})
    if response.status_code == 200:
        return response.json()
    return None



#location
@app.route('/weather/location', methods=['GET'])
def get_weather_location():
    location = request.args.get('location', 'Philippines')
    data = fetch_weather(location)
    if data:
        return jsonify({"location": data["location"]["name"]})
    return jsonify({"error": "No location found"}), 500

#temp
@app.route('/weather/temperature', methods=['GET'])
def get_weather_temperature():
    location = request.args.get('location', 'Philippines')
    data = fetch_weather(location)
    if data:
        return jsonify({"temperature_c": data["current"]["temp_c"]})
    return jsonify({"error": "No temperature data found"}), 500

#conditon
@app.route('/weather/condition', methods=['GET'])
def get_weather_condition():
    location = request.args.get('location', 'Philippines')
    data = fetch_weather(location)
    if data:
        return jsonify({"condition": data["current"]["condition"]["text"]})
    return jsonify({"error": "No condition data found"}), 500

#humdity
@app.route('/weather/humidity', methods=['GET'])
def get_weather_humidity():
    location = request.args.get('location', 'Philippines')
    data = fetch_weather(location)
    if data:
        return jsonify({"humidity": data["current"]["humidity"]})
    return jsonify({"error": "No humidity data found"}), 500

#wind
@app.route('/weather/wind', methods=['GET'])
def get_weather_wind():
    location = request.args.get('location', 'Philippines')
    data = fetch_weather(location)
    if data:
        return jsonify({"wind_kph": data["current"]["wind_kph"]})
    return jsonify({"error": "No wind data found"}), 500


### CAT API ENDPOINTS ###

#fetch random id
def fetch_cat_id():
    """Fetch a random cat ID"""
    response = requests.get(CAT_SEARCH_API)
    if response.status_code == 200:
        data = response.json()
        if data and "id" in data[0]:
            return data[0]["id"], data[0]["url"]  
    return None, None  

#get the id in the fetch_cad_id
def fetch_cat_details(cat_id):
    """Fetch cat details using the ID"""
    response = requests.get(CAT_DETAILS_API.format(cat_id))
    if response.status_code == 200:
        data = response.json()
        if "breeds" in data and data["breeds"]:
            return data  
    return None  

# Get Cat Name
@app.route('/cat/name', methods=['GET'])
def get_cat_name():
    cat_id, _ = fetch_cat_id()
    if cat_id:
        cat_data = fetch_cat_details(cat_id)
        if cat_data:
            return jsonify({"name": cat_data["breeds"][0].get("name", "Unknown")})
    return jsonify({"error": "No cat name found"}), 500

# Get Cat Origin
@app.route('/cat/origin', methods=['GET'])
def get_cat_origin():
    cat_id, _ = fetch_cat_id()
    if cat_id:
        cat_data = fetch_cat_details(cat_id)
        if cat_data:
            return jsonify({"origin": cat_data["breeds"][0].get("origin", "Unknown")})
    return jsonify({"error": "No cat origin found"}), 500

# Get Cat Image
@app.route('/cat/image', methods=['GET'])
def get_cat_image():
    _, cat_image_url = fetch_cat_id()
    if cat_image_url:
        return jsonify({"image": cat_image_url})
    return jsonify({"error": "No cat image found"}), 500


### MUSIC API ENDPOINTS ###
def fetch_random_song():
    response = requests.get(DEEZER_API_URL)
    if response.status_code == 200:
        data = response.json().get('data', [])
        if data:
            return random.choice(data)
    return None

#title
@app.route('/music/song', methods=['GET'])
def get_random_song():
    global current_song
    current_song = fetch_random_song()  # Fetch and store the song data
    if current_song:
        return jsonify({"title": current_song.get("title")})
    return jsonify({"error": "No song found"}), 500

#artist
@app.route('/music/artist', methods=['GET'])
def get_random_artist():
    global current_song
    if current_song:
        return jsonify({"artist": current_song.get("artist", {}).get("name", "Unknown")})
    return jsonify({"error": "No artist found"}), 500

#duration
@app.route('/music/duration', methods=['GET'])
def get_random_duration():
    global current_song
    if current_song:
        return jsonify({"duration": current_song.get("duration", 0)})
    return jsonify({"error": "No duration found"}), 500

#music URL
@app.route('/music/url', methods=['GET'])
def get_random_song_url():
    global current_song
    if current_song:
        return jsonify({"url": current_song.get("preview")})  # Deezer provides a preview URL
    return jsonify({"error": "No song URL found"}), 500



if __name__ == '__main__':
    app.run(debug=True)
