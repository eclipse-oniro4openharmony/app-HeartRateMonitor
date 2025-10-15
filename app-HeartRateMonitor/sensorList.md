# Sensor Overview

The device supports the following main sensor types:  

## Motion & Activity
- **PEDOMETER** — Step counter  
- **PEDOMETER_DETECTION** — Step detector  
- **WEAR_DETECTION** — Wear detection  
- **LINEAR_ACCELEROMETER** — Linear acceleration  
- **ORIENTATION** — Orientation sensor  
- **ROTATION_VECTOR** — Rotation vector  

## Environment
- **AMBIENT_LIGHT** — Ambient light sensor  
- **BAROMETER** — Barometer  
- **MAGNETIC_FIELD** — Magnetic field sensor  

## Vital Signs
- **HEART_RATE** — Heart rate sensor  

## Device Motion
- **ACCELEROMETER** — Accelerometer  
- **GRAVITY** — Gravity sensor  
- **GYROSCOPE** — Gyroscope  

---

# Sensor Information APIs

These APIs provide information about sensors and related calculations:  

- `sensor.getSensorList()`  
  Retrieves the list of all supported sensors. The response contains:
  - `sensorName`: Sensor name  
  - `vendorName`: Vendor name  
  - `sensorId`: Unique ID  
  - `hardwareVersion` / `firmwareVersion`: Hardware/Firmware version  
  - `power`: Power consumption (mA)  
  - `precision`: Sensor precision  
  - `maxRange`: Maximum measurement range  
  - `minSamplePeriod` / `maxSamplePeriod`: Sampling period range  

- `sensor.getGeomagneticInfo(location, time)`  
  Get geomagnetic field information for a given location and timestamp.  

- `sensor.getDeviceAltitude(seaLevelPressure, devicePressure)`  
  Estimate altitude from barometric pressure.  

- `sensor.getRotationMatrix(gravity, geomagnetic)`  
  Compute the rotation matrix from gravity and geomagnetic data.  

- `sensor.transformRotationMatrix(R, axisX, axisY)`  
  Transform a rotation matrix to a different coordinate system.  

- `sensor.getQuaternion(R)`  
  Compute the quaternion from a rotation matrix.  

- `sensor.getOrientation(R)`  
  Compute device orientation angles from a rotation matrix.  

- `sensor.getInclination(R)`  
  Calculate inclination angle.  

- `sensor.getAngleVariation(R1, R2)`  
  Calculate the angle variation between two rotation matrices.  

---

# Example: Get Sensor List

```ts
import { sensor } from '@kit.SensorServiceKit';

try {
  const list = sensor.getSensorListSync();
  list.forEach((s, i) => {
    console.info(`[${i}] ${s.sensorName}, vendor=${s.vendorName}, id=${s.sensorId}`);
  });
} catch (e) {
  console.error(`Failed to get sensor list: ${JSON.stringify(e)}`);
}
```