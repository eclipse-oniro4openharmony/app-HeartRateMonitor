# app-HeartRateMonitor

## Content table
1. [Overview](#overview)
2. [Features](#features)
3. [Setup Instructions](#setup-instructions)


## Overview
This OpenHarmony-based smartwatch application monitors real-time heart rate using the built-in sensor.
UI effects is as following:
![image1.jpg](images%2Fimage1.jpg)
![image2.jpg](images%2Fimage2.jpg)
## Features
**Real-time Heart Rate Monitoring** — continuously listens to heart rate changes

**Interactive UI** — ring progress for heart rate, visual timer, and toggle start/stop

**Permission Handling** — dynamically requests runtime permissions for health data

## Setup Instruction
**1. Clone the repository**
```bash
git clone https://github.com/imansmallapple/app-heartratemonitor.git
```

**2. Build and Deploy**
* Ensure you are using API level 18 
* Confirm your app is a `system-level` application
* Connect the watch using IP connection
* Sign the application with valid signature configurations
* Click `run` on DevEco Studio to install the application

> **Note:**
>
> See this [tutorial](https://docs.oniroproject.org/application-development/codeLabs/) for how to configure the project as a `system-level` application.

