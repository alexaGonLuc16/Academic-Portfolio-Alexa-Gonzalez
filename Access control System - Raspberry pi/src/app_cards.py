from tkinter import Button, Frame, Label, Tk
from tkinter.ttk import Combobox
from tarjetas import BAUDRATES, SensorSerial
from uttis import find_available_serial_ports
import threading
import time
import requests


class App(Frame):
    def __init__(self, master, *args, **kwargs) -> None:
        Frame.__init__(self, master, *args, **kwargs)
        self.master: Tk = master

        # GUI object creation
        self.title_label: Label = self.create_title_label()
        self.serial_devices_combobox: Combobox = self.create_serial_devices_combobox()
        self.refresh_serial_devices_button: Button = self.create_serial_devices_refresh_button()
        self.baudrate_combobox: Combobox = self.create_baudrate_combobox()
        self.connect_serial_button: Button = self.create_connect_serial_button()
        self.access_label: Label = self.create_access_label()
        self.select_device_label: Label = self.create_select_device_label()
        self.connection_status_label: Label = self.create_connection_status_label()

        # Other objects
        self.sensor_serial: SensorSerial | None = None
        self.stop_reading: bool = False  # Flag to control the reading loop
        self.init_gui()

        # Registered users
        self.registered_users = {
            "4F0088B20772": "Alexa González Lucio"
        }

        # User status dictionary
        self.user_status = {}

    def init_gui(self) -> None:
        # GUI configuration
        self.master.title = 'User Access'
        self.master.geometry('1200x800')
        self['bg'] = '#0a0a2d'
        self.pack(fill='both', expand=True)

        # Row 0
        self.title_label.grid(row=0, column=0, columnspan=4, pady=40, padx=100)

        # Row 1
        self.select_device_label.grid(row=1, column=0, padx=50, pady=40)
        self.serial_devices_combobox.grid(row=1, column=1, padx=50, pady=40)
        self.refresh_serial_devices_button.grid(row=1, column=2, padx=50, pady=10)
        self.baudrate_combobox.grid(row=2, column=0, padx=30, pady=40)
        self.connect_serial_button.grid(row=2, column=1, padx=20, pady=40)

        # Row 2
        self.access_label.grid(row=3, column=0, columnspan=2, padx=10, pady=10, sticky='w')

        # Row 3
        self.connection_status_label.grid(row=4, column=0, columnspan=4, padx=10, pady=10)

        # Settings
        self.baudrate_combobox.current(0)

    def create_serial_devices_combobox(self) -> Combobox:
        ports = find_available_serial_ports()
        return Combobox(
            self,
            values=ports,
            font=('Helvetica Neue', 20)
        )

    def create_serial_devices_refresh_button(self) -> Button:
        return Button(
            self,
            text='Refresh available serial devices',
            command=self.refresh_serial_devices
        )

    def create_baudrate_combobox(self) -> Combobox:
        return Combobox(
            master=self,
            values=['Baudrate'] + BAUDRATES
        )

    def create_connect_serial_button(self) -> Button:
        return Button(
            master=self,
            text='Connect',
            command=self.create_sensor_serial
        )

    def create_access_label(self) -> Label:
        return Label(
            master=self,
            text='Code: N/A',
            font=('Helvetica Neue', 20),
            width=24  # Increased width to allow more text
        )

    def create_select_device_label(self) -> Label:
        return Label(
            master=self,
            text='Select device:',
            font=('Helvetica', 20),
            padx=10,  # Horizontal padding of 10 pixels
            pady=10   # Vertical padding of 10 pixels
        )

    def create_title_label(self) -> Label:
        return Label(
            master=self,
            text='User Access',
            font=('Helvetica Neue', 20),
            fg='black',      # Text color
            bg='#CCBB66',    # Background color
            padx=10,         # Horizontal padding
            pady=10          # Vertical padding
        )

    def create_connection_status_label(self) -> Label:
        return Label(
            master=self,
            text='Disconnected',
            font=('Helvetica Neue', 20),
            fg='red'
        )

    def refresh_serial_devices(self):
        ports = find_available_serial_ports()
        self.serial_devices_combobox.selection_clear()
        self.serial_devices_combobox['values'] = ports

    def create_sensor_serial(self) -> SensorSerial:
        port = self.serial_devices_combobox.get()
        baudrate = self.baudrate_combobox.get()

        if port == '' or baudrate == 'Baudrate':
            raise ValueError(f'Incorrect values for {port=} {baudrate=}')

        try:
            self.sensor_serial = SensorSerial(
                serial_port=port,
                baudrate=int(baudrate)
            )
            self.connection_status_label['text'] = 'Connected'
            self.connection_status_label['fg'] = 'green'
            self.stop_reading = False
            # Start background thread for continuous reading
            threading.Thread(target=self.read_code_continuously).start()
        except Exception as e:
            self.connection_status_label['text'] = f'Failed to connect: {e}'
            self.connection_status_label['fg'] = 'red'

    def read_code_continuously(self):
        buffer = ""
        while not self.stop_reading:
            if self.sensor_serial is not None:
                try:
                    data = self.sensor_serial.receive()
                    if data:
                        # Decode byte data into a string
                        buffer += data.decode('utf-8')

                        # Process each complete 14-character message
                        while len(buffer) >= 14:
                            complete_message = buffer[:14]
                            buffer = buffer[14:]
                            clean_code_str = self.clean_code(complete_message)
                            print(clean_code_str)  # Print code to console
                            self.access_label['text'] = f"Code: {clean_code_str}"
                            self.process_code(clean_code_str)  # Process code locally

                            # Clear buffer after processing
                            buffer = ""
                except Exception as e:
                    print(f"Error reading code: {e}")
            time.sleep(0.01)  # Adjust sleep time if necessary

    def process_code(self, code):
        if code in self.registered_users:
            user_name = self.registered_users[code]

            # Toggle user status
            if user_name in self.user_status and self.user_status[user_name] == "Accepted":
                status = "Inactive"
            else:
                status = "Accepted"

            self.user_status[user_name] = status
            data = {"code": user_name, "status": status}
        else:
            status = "Rejected"
            data = {"code": code, "status": status}

        self.send_to_server(data)

    def send_to_server(self, data):
        url = "http://localhost:8080/receive_code/"
        response = requests.post(url, data=data)

        if response.status_code == 200:
            print("Data sent successfully")
        else:
            print(f"Failed to send data. Status code: {response.status_code}")

    def clean_code(self, code):
        # Remove unwanted characters from the code
        return ''.join(filter(lambda x: x.isprintable(), code)).strip()


root = Tk()

if __name__ == '__main__':
    app = App(root)
    root.mainloop()
