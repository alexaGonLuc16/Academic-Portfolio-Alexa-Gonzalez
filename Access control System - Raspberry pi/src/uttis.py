import sys
import glob

import serial  # pyserial library


def find_available_serial_ports() -> list[str]:
    if sys.platform.startswith('win'):  # Windows computer
        platform = 'win'
        ports = [f'COM{i}' for i in range(1, 256)]
    elif sys.platform.startswith('linux'):  # Linux computer
        platform = 'linux'
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):  # macOS
        platform = 'darwin'
        ports = glob.glob('/dev/tty.*')
    else:
        raise EnvironmentError('Unsupported platform')

    result = []
    for port in ports:
        # On Windows, stop early if a port cannot be opened
        early_stop = True if platform == 'win' else False
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            if early_stop:
                break
            continue

    return result
