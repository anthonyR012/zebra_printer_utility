# Flutter ZebraUtil



Zebra utility is a plugin for working easily with zebra printers in your flutter project.

  - Discovery bluetooth and wifi printers in android and bluetooth printers in iOS.
  - Connect and disconnect to printers
  - Set mediatype, darkness, calibrate command without writing any ZPL code for ZPL printers.
  - Rotate ZPL without changing your zpl.


# Installation

## Android

Add this code to android block in `build.gradle` (Module level).

```sh
android {
    packagingOptions {
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/NOTICE.txt'
        exclude 'META-INF/NOTICE'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/DEPENDENCIES'
    }
}
```

Include the necessary permission in the Android Manifest.
```sh
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## iOS
Add `Supported external accessory protocols` in your `info.plist` and then add `com.zebra.rawport`to its.
Add `Privacy - Local Network Usage Description` in your `info.plist`.

# Example
## Getting Started
There is a static class that allows you to create different instances of ZebraPrinter.
```sh
     FutureBuilder(
        future: ZebraUtil.getPrinterInstance(), //required async 
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final zebraPrinter = snapshot.data as ZebraPrinter;
          return PrinterTemplate(zebraPrinter);
        },
      ),
```

You can then pass callbacks for either `onDiscoveryError`, `onPermissionDenied`, or neither.

```sh
     zebraPrinter.onDiscoveryError =  ( errorCode, errorText) {
      print("Error: $errorCode, $errorText");
    };
    zebraPrinter.onPermissionDenied = () {
      print("Permission denied");
    }
```

## Methods
After configuring the instance, use the following method to start searching for available devices:

```sh
  zebraPrinter.discoveryPrinters();
```
To listen for and display any devices (`ZebraDevice`), you can use the Zebra printer `notifier`
```sh
  ListenableBuilder(
      listenable: zebraPrinter.notifier,
      builder: (context, child) {
        final printers = notifier.printers;
        if (printers.isEmpty) {
          return const Center(
            child: Text("Printers not found"),
          );
        }
        return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(printers[index].name),
                  subtitle: Text(printers[index].status,
                      style: TextStyle(color: printers[index].color)),
                  leading: Icon(Icons.print, color: printers[index].color),
                  onTap: () {
                    zebraPrinter.connectToPrinter(printers[index].address);
                  });
            },
            itemCount: printers.length);
      },
    )
```

For connecting to printer, pass ipAddreess for wifi printer or macAddress for bluetooth printer to `connectToPrinter` method.
```sh
 zebraPrinter.connectToPrinter("192.168.47.50");
```

You can set media type between `Lable`, `Journal` and `BlackMark`. You can choose media type by `EnumMediaType`.
```sh
  zebraPrinter.setMediaType(EnumMediaType.BlackMark);
```
You may callibrate printer after set media type. You can use this method.
```sh
zebraPrinter.calibratePrinter();
```
You can set darkness. the valid darkness value are -99,-75,-50,-25,0,25,50,75,100,125,150,175,200.
```sh
  zebraPrinter.setDarkness(25);
```
For print ZPL, you pass ZPL to `print` method.
```sh
  zebraPrinter.print("Your ZPL");
```
For rotate your ZPL without changing your ZPL, you can use this method. You can call this again for normal printing.
```sh
  zebraPrinter.rotate();
```
For disconnect from printer, use `disconnect` method. For battery saver, disconnect from printer when you not need printer.
```sh
  zebraPrinter.disconnect();
```

# Acknowledgements
I would like to express my gratitude to Deltec for fostering a friendly and supportive environment.

Special thanks to [`MythiCode`](https://github.com/MythiCode/zebra_utlity) for providing the foundational code for this library. Specifically, I appreciate the following contributions:

* Base implementation for core functionalities
* Initial setup and structure
* Key algorithms and methods

Thank you to everyone who made this project possible!