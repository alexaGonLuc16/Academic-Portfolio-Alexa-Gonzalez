# AES Encryption on FPGA (Intel)
**Duration:** April – June 2024

## Overview
This project focuses on the hardware implementation of the Advanced Encryption Standard (AES) algorithm on an Intel FPGA platform using VHDL. The main objective was to design an efficient, modular, and high-performance encryption architecture suitable for resource-constrained and real-time systems.

The project was developed as part of an academic initiative and formally presented to Intel.

## Project Objectives
- Implement the AES encryption algorithm in hardware using VHDL
- Design a modular architecture for AES rounds and key expansion
- Optimize performance and hardware resource utilization
- Validate the design through simulation.

## Technical Approach
The AES algorithm was implemented following a structured hardware design methodology. The architecture was divided into functional modules corresponding to the main AES operations, enabling scalability and efficient data flow.

Emphasis was placed on:
- Parallelism and pipeline-friendly design
- Efficient use of FPGA resources
- Deterministic execution suitable for real-time applications

## Technologies and Tools
- VHDL
- Intel FPGA development tools

## AES Control State Machine

The following figure shows the finite state machine (FSM) used to control the AES implementation.  
It includes the main states of the algorithm as well as the corresponding functional modules involved in each stage of the encryption process.

![AES State Machine](img/State_machine.png)

## Project Presentation
A detailed explanation of the system architecture, design decisions, and experimental results is available in the presentation below:

📄 **AES FPGA Design – Technical Presentation**  
[View presentation](presentation/AES_FPGA_Intel_Presentation.pdf)


