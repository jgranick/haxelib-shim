# haxelib-shim

You can test it like this:

    git clone https://github.com/haxefoundation/haxelib
    git clone https://github.com/jgranick/haxelib-shim
    cd haxelib-shim
    haxe build.hxml

In order to test the update behavior, add to "Main.hx" at line 137:

    Sys.println ("Upgraded haxelib client: " + upgradedClient);

To install on Windows, copy "haxelib.exe" to "C:\HaxeToolkit\haxe\haxelib.exe"

To install on Mac and Linux, copy "haxelib" to "/usr/lib/haxe/haxelib"

On Mac, I also had to replace "/usr/bin/haxelib", since it was not a symlink.

On a fresh install of Haxe, `upgradedClient` should be null. It uses the compiled version of haxelib.

You can use `haxelib set haxelib_client` to any version, it should return this value

You can also use `haxelib dev path/to/haxelib` to use a development version
