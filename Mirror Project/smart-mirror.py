import tkinter as tk
from tkinter import Label, Button
from datetime import datetime
import requests
import spotipy
from spotipy.oauth2 import SpotifyOAuth

class SmartMirrorApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Smart Mirror")
        self.geometry("800x480")
        self.configure(background='black')

        # Initialize Spotify authentication and API client
        self.spotify = spotipy.Spotify(auth_manager=SpotifyOAuth(scope="user-read-currently-playing"))

        # Create GUI elements
        self.create_widgets()

        # Update Spotify information
        self.update_spotify_info()

        # Update time and date
        self.update_time_date()

        # Update weather
        self.update_weather()

    def create_widgets(self):
        # Greeting Label
        self.greeting_label = Label(self, text="Good Morning!", font=('Helvetica', 20), fg='white', bg='black')
        self.greeting_label.place(relx=0.5, y=20, anchor='center')

        # Weather Label
        self.weather_label = Label(self, text="", font=('Helvetica', 16), fg='white', bg='black')
        self.weather_label.place(relx=0.05, y=60, anchor='w')

        # Calendar Label
        self.calendar_title_label = Label(self, text="Today's Calendar", font=('Helvetica', 16), fg='white', bg='black')
        self.calendar_title_label.place(relx=0.05, y=160, anchor='w')

        self.event_labels = []
        for i in range(5):
            event_label = Label(self, text=f"Event {i+1}", font=('Helvetica', 12), fg='white', bg='black')
            event_label.place(relx=0.05, y=200 + i*20, anchor='w')
            self.event_labels.append(event_label)

        # Spotify Display
        self.song_label = Label(self, text="", font=('Helvetica', 16), fg='white', bg='black')
        self.song_label.place(relx=0.95, y=60, anchor='e')

        self.play_pause_button = Button(self, text="", command=self.toggle_playback)
        self.play_pause_button.place(relx=0.95, y=100, anchor='e')

        # News Label
        self.news_title_label = Label(self, text="News Headlines", font=('Helvetica', 16), fg='white', bg='black')
        self.news_title_label.place(relx=0.05, rely=1.0, y=-60, anchor='w')

        self.headline_labels = []
        for i in range(5):
            headline_label = Label(self, text=f"Headline {i+1}", font=('Helvetica', 12), fg='white', bg='black')
            headline_label.place(relx=0.05, rely=1.0, y=-20 - i*20, anchor='w')
            self.headline_labels.append(headline_label)

    def update_time_date(self):
        now = datetime.now()
        current_time = now.strftime("%H:%M:%S")
        current_date = now.strftime("%Y-%m-%d")
        self.greeting_label.config(text=self.get_greeting(now))
        self.time_label.config(text=current_time)
        self.date_label.config(text=current_date)
        self.after(1000, self.update_time_date)  # Update every second

    def update_weather(self):
        location = "blackpool"  # Update with your location
        weather_info = self.get_weather(location)
        self.weather_label.config(text=weather_info)
        self.after(60000, self.update_weather)  # Update every minute

    def update_spotify_info(self):
        current_track = self.spotify.current_playback()
        if current_track is not None and current_track['is_playing']:
            song_info = f"{current_track['item']['name']} - {current_track['item']['artists'][0]['name']}"
            self.song_label.config(text=song_info)
            self.play_pause_button.config(text="Pause")
        else:
            self.song_label.config(text="No song currently playing")
            self.play_pause_button.config(text="Play")

        self.after(10000, self.update_spotify_info)  # Update every 10 seconds

    def toggle_playback(self):
        current_track = self.spotify.current_playback()
        if current_track is not None and current_track['is_playing']:
            self.spotify.pause_playback()
        else:
            self.spotify.start_playback()

    def get_greeting(self, now):
        current_hour = now.hour
        if 6 <= current_hour < 12:
            return "Good Morning!"
        elif 12 <= current_hour < 18:
            return "Good Afternoon!"
        else:
            return "Good Evening!"

    def get_weather(self, location):
        weather_url = f'https://api.open-meteo.com/weather?location={location}'
        response = requests.get(weather_url)
        weather_data = response.json()
        if 'error' in weather_data:
            return
