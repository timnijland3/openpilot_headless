import subprocess
from nicegui import ui

def check_internet():
    try:
        subprocess.check_output(['ping', '-c', '1', 'google.com'])
        return True
    except subprocess.CalledProcessError:
        return False

def scan_wifi_networks():
    try:
        result = subprocess.check_output(['nmcli', '-t', '-f', 'SSID', 'dev', 'wifi'])
        networks = result.decode().split('\n')
        return [network for network in networks if network]
    except subprocess.CalledProcessError:
        return []

def connect_to_wifi(ssid, password):
    try:
        result = subprocess.check_output(['nmcli', 'dev', 'wifi', 'connect', ssid, 'password', password])
        ui.notify('Connected to WiFi successfully!', level='success')
    except subprocess.CalledProcessError:
        ui.notify('Failed to connect to WiFi.', level='error')

@ui.page('/network')
def network_page():
    with ui.card():
        if check_internet():
            ui.label('You are connected to the internet!')
        else:
            ui.label('No internet connection detected. Please connect to WiFi.')
            ssid_dropdown = ui.select(options=scan_wifi_networks(), label='Select WiFi Network').props('outlined')
            password_input = ui.input('Password').props('outlined', 'type=password')
            ui.button('Connect', on_click=lambda: connect_to_wifi(ssid_dropdown.value, password_input.value))

ui.run()
