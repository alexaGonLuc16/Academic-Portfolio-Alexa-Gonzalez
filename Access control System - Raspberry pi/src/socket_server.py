import socket
import threading
import tkinter as tk
from tkinter import ttk
from datetime import datetime

ADDRESS = 'localhost'
PORT = 3333


class ServerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("User Log Server")

        # Configure styles
        self.style = ttk.Style()
        self.style.configure("TFrame", background="#f0f0f0")
        self.style.configure("TLabel", background="#f0f0f0", font=("Helvetica", 14))
        self.style.configure("Treeview", font=("Helvetica", 12), rowheight=25)
        self.style.configure(
            "Treeview.Heading",
            font=("Helvetica", 14, "bold"),
            background="#4CAF50",
            foreground="white"
        )
        self.style.map(
            "Treeview.Heading",
            background=[
                ('pressed', '!disabled', '#388E3C'),
                ('active', '#66BB6A')
            ]
        )

        self.frame = ttk.Frame(self.root, padding="20")
        self.frame.grid(row=0, column=0, sticky="nsew")

        # Get current date
        current_date = datetime.now().strftime("%d %B")

        self.label_date = ttk.Label(
            self.frame,
            text=current_date,
            anchor="center",
            font=("Helvetica", 14)
        )
        self.label_date.grid(row=0, column=0, columnspan=3, padx=20, pady=10)

        self.label_users = ttk.Label(
            self.frame,
            text="Registered Users",
            anchor="center",
            font=("Helvetica", 14)
        )
        self.label_users.grid(row=1, column=0, columnspan=3, padx=20, pady=10)

        self.tree = ttk.Treeview(
            self.frame,
            columns=("Access Time", "User", "Status"),
            show='headings'
        )
        self.tree.heading("Access Time", text="Time")
        self.tree.heading("User", text="User")
        self.tree.heading("Status", text="Status")

        self.tree.column("Access Time", anchor="center")
        self.tree.column("User", anchor="center")
        self.tree.column("Status", anchor="center")

        self.tree.grid(
            row=2,
            column=0,
            columnspan=3,
            padx=20,
            pady=(0, 10),
            sticky="nsew"
        )

        self.scrollbar = ttk.Scrollbar(
            self.frame,
            orient=tk.VERTICAL,
            command=self.tree.yview
        )
        self.tree.configure(yscroll=self.scrollbar.set)
        self.scrollbar.grid(
            row=2,
            column=3,
            padx=(0, 20),
            pady=(0, 10),
            sticky="ns"
        )

        # Create and configure socket
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind((ADDRESS, PORT))
        self.sock.listen()

        # Start server thread
        self.server_thread = threading.Thread(target=self.run_server)
        self.server_thread.daemon = True
        self.server_thread.start()

        # Configure grid weights to allow resizing
        self.root.grid_rowconfigure(0, weight=1)
        self.root.grid_columnconfigure(0, weight=1)
        self.frame.grid_rowconfigure(2, weight=1)
        self.frame.grid_columnconfigure(0, weight=1)
        self.frame.grid_columnconfigure(1, weight=1)
        self.frame.grid_columnconfigure(2, weight=1)

    def run_server(self):
        """Accept incoming socket connections."""
        while True:
            connection, address = self.sock.accept()
            print(f"Accepted connection from: {address}")
            threading.Thread(
                target=self.handle_client,
                args=(connection,)
            ).start()

    def handle_client(self, connection):
        """Handle incoming client messages."""
        with connection:
            while True:
                received = connection.recv(1024)
                if not received:
                    break
                message = received.decode()
                print(f"Received: {message}")
                self.root.after(0, self.update_tree, message)

    def update_tree(self, message):
        """Update the GUI table with a new access record."""
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.tree.insert(
            '',
            'end',
            values=(current_time, message, "Accessed")
        )

    def stop_server(self):
        """Close the socket server."""
        self.sock.close()


if __name__ == "__main__":
    root = tk.Tk()
    app = ServerApp(root)

    # Define action when the window is closed
    root.protocol("WM_DELETE_WINDOW", app.stop_server)

    root.mainloop()
