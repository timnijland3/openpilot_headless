import cv2
import os
from nicegui import ui

authenticated = True

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

def get_cameras():
    # Initialize a list to store camera IDs
    cameras = []
    for i in range(10):  # Assuming a maximum of 10 cameras
        cap = cv2.VideoCapture(i)
        if cap.isOpened():
            cameras.append(i)
            cap.release()
    return cameras

def capture_image(camera_id):
    cap = cv2.VideoCapture(camera_id)
    ret, frame = cap.read()
    if ret:
        filename = f'camera_{camera_id}.jpg'
        cv2.putText(frame, f'CAMERA_ID: {camera_id}', (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2, cv2.LINE_AA)
        cv2.imwrite(filename, frame)
    cap.release()
    return filename

def take_pictures():
    cameras = get_cameras()
    for camera_id in cameras:
        filename = capture_image(camera_id)
        ui.image(filename).style('width: 400px; height: 300px;')

@ui.page('/login')
def login_page():
    ui.input('Username', on_change=lambda e: setattr(ui, 'username', e.value))
    ui.input('Password', password=True, on_change=lambda e: setattr(ui, 'password', e.value))
    ui.button('Login', on_click=lambda: authenticate(getattr(ui, 'username', ''), getattr(ui, 'password', '')))

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

@ui.page('/camera')
async def index():
    if authenticated:
        ui.label('Camera Capturing App')
        ui.button('Capture Images', on_click=take_pictures)
    else:
        ui.notify('Please log in first', color='red', duration=5)
        ui.open('/login')

# Set the default page to the login page
#ui.run(open_page='/login')
ui.run() # open_page='/controls')
