STMicroelectronics LSM303DLH Accelerometer/Magenetometer
========================================================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The LSM303DLH is a 3-axis accelerometer and magnetometer.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Driver                                                             |
| -   2 Accelerometer                                                      |
|     -   2.1 Instantiate the device                                       |
|     -   2.2 Enabling the device                                          |
|     -   2.3 Reading the output of the device                             |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Driver
------

The official driver available is available at a cached version of the
manufacturer's website. The driver is open source an it was released
under the GNU General Public License (v2). It compiles fine, and the
accelerometer module can be loaded without problems:

    dmesg

    ...
    [  124.908804] lsm303dlh_acc_sysfs accelerometer driver: init
    [  124.908876] i2c-core: driver [lsm303dlh_acc_sysfs] using legacy suspend method
    [  124.908885] i2c-core: driver [lsm303dlh_acc_sysfs] using legacy resume method

The following error occurs when loading the magnetometer module:

    dmesg

    ...
    [ 2546.530196] lsm303dlh_mag_sysfs: Unknown symbol input_allocate_polled_device (err 0)
    [ 2546.530271] lsm303dlh_mag_sysfs: Unknown symbol input_free_polled_device (err 0)
    [ 2546.530425] lsm303dlh_mag_sysfs: Unknown symbol input_register_polled_device (err 0)
    [ 2546.530550] lsm303dlh_mag_sysfs: Unknown symbol input_unregister_polled_device (err 0)

Accelerometer
-------------

> Instantiate the device

Run the following command to instantiate the device:

    # echo lsm303dlh_acc_sysfs 25 > /sys/bus/i2c/devices/i2c-2/new_device

Although, it seems to be a problem with the driver.

    demesg

    ...
    [  833.274769] lsm303dlh_acc_sysfs: probe start.
    [  833.274781] lsm303dlh_acc_sysfs 2-0019: platform data is NULL. exiting.
    [  833.274790] lsm303dlh_acc_sysfs: Driver Init failed
    [  833.274813] i2c i2c-2: new_device: Instantiated device lsm303dlh_acc_sysfs at 0x19

> Enabling the device

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Reading the output of the device

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

See also
--------

-   Older version of the driver at lklm.org.
-   Luke Ross' website.

Retrieved from
"https://wiki.archlinux.org/index.php?title=STMicroelectronics_LSM303DLH_Accelerometer/Magenetometer&oldid=207249"

Category:

-   Other hardware
