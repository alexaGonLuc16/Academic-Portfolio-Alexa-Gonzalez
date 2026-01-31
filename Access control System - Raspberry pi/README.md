# Access Control System – Raspberry Pi 4

An access control system based on an **RFID card reader**, providing **visual monitoring of access events** and **user registration** through a **web interface**.  
The project was developed using a **Raspberry Pi 4**, selected for its **low cost**, **compact size**, and adequate performance compared to other computing platforms.

This project is beneficial to the community as it enhances **security** and enables **accurate control** of individuals attempting to access the facility, as well as those who successfully enter and exit, including **timestamped access records**.  
Such information is valuable for ensuring and improving the overall security of a controlled environment.

---

## 🎥 Project Demonstration Video

[![Watch the video](https://img.youtube.com/vi/m25rJlFAseo/maxresdefault.jpg)](https://www.youtube.com/watch?v=m25rJlFAseo)

**Note:** The video is narrated in Spanish. English subtitles can be enabled using YouTube’s automatic caption and translation feature.

---

## 🛠️ Final Prototype

<p align="center">
  <img src="img/prototype.jfif" alt="Final Prototype Image" width="600"/>
</p>

## System Flow Diagram

### 📖 Diagram Description

The diagram illustrates the overall architecture of the access control system and the interaction between its main components:

- **Computer / Smartphone**: Connect to the system via a hotspot network to allow monitoring and user management through the web interface.
- **Raspberry Pi 4**: Acts as the central processing unit of the system, handling communication, data processing, and coordination between components.
- **RFID Reader**: Communicates with the Raspberry Pi through serial communication to transmit card identification data.
- **RFID Card**: Represents the user interaction element, providing identification when scanned.
- **Arduino Uno**: Controls the system state based on the received card identification.
- **Status Indicator Circuit**: Provides visual feedback to indicate the access status.

```mermaid
flowchart TB

PC[Computer] <-->|Hotspot Connection| RPI[Raspberry Pi 4]
PHONE[Smartphone] <-->|Hotspot Connection| RPI

RFID[RFID Reader] -->|Serial Communication| RPI

CARD[RFID Card] -->|User scans card| RFID

RFID -->|Card ID determines system state| ARD[Arduino Uno]

ARD --> STATUS[Status Indicator Circuit]