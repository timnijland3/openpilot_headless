from nicegui import ui
import os

authenticated = True
getstarted = False

def authenticate(username, password):
    global authenticated
    if username == 'admin' and password == 'password':  # Replace with your credentials
        authenticated = True
        ui.notify('Login successful!', color='green', duration=5)
        ui.open('/controls')
    else:
        ui.notify('Invalid credentials', color='red', duration=5)

def logout():
    global authenticated
    authenticated = False
    ui.notify('Logged out!', color='blue', duration=5)
    ui.open('/login')

def getstarted():
    global getstarted
    if authenticated:
        if os.path.exists(folder_path):
            ui.notify(f'Folder "{'~/openpilot'}" exists.', color='green', duration=5)
            getstarted = True

def reboot():
    if authenticated:
        os.system('sudo reboot')

def shutdown():
    if authenticated:
        os.system('sudo shutdown now')

def show_ip():
    if authenticated:
        ip = os.popen('hostname -I').read().strip()
        ui.notify(f'IP Address: {ip}', duration=5)

def factoryreset():
    if authenticated:
        ip = os.popen('hostname -I').read().strip()
        ui.notify(f'IP Address: {ip}', duration=5)

@ui.page('/login')
def login_page():
    ui.input('Username', on_change=lambda e: setattr(ui, 'username', e.value))
    ui.input('Password', password=True, on_change=lambda e: setattr(ui, 'password', e.value))
    ui.button('Login', on_click=lambda: authenticate(getattr(ui, 'username', ''), getattr(ui, 'password', '')))

@ui.page('/getstarted')
def getstarted_page():
    if authenticated:
        ui.button('Start', on_click=reboot, color='green', icon='restart_alt')
    else:
        ui.notify('Please log in first', color='red', duration=5)
        ui.open('/login')

@ui.page('/controls')
def controls_page():
    if authenticated:
        ui.button('Reboot', on_click=reboot, color='red', icon='restart_alt')
        ui.button('Shutdown', on_click=shutdown, color='red', icon='power_settings_new')
        ui.button('Factory Reset', on_click=factoryreset, color='red', icon='restart_alt')
        ui.button('Show IP Address', on_click=show_ip, icon='info')
        ui.button('Logout', on_click=logout, icon='logout')
    else:
        ui.notify('Please log in first', color='red', duration=5)
        ui.open('/login')

# Set the default page to the login page
#ui.run(open_page='/login')
ui.run(open_page='/controls')
