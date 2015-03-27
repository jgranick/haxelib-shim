package;


import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import tools.haxelib.Data;

@:access(tools.haxelib.Main)


class Main {
	
	
	private static function findUpgrade ():String {
		
		try {
			
			var client = getHaxelibClient (".haxelib");
			
			if (client == null) {
				
				var envPath = Sys.getEnv ("HAXELIB_PATH");
				
				if (envPath != null) {
					
					client = getHaxelibClient (envPath);
					
				} else {
					
					var configFile = "";
					
					if (Sys.systemName () == "Windows") {
						
						var homeDrive = Sys.getEnv ("HOMEDRIVE");
						var homePath = Sys.getEnv ("HOMEPATH");
						
						if (homeDrive != null && homePath != null) {
							
							var configFile = homeDrive + homePath + "/.haxelib";
							
						}
						
						if (configFile != null && FileSystem.exists (configFile) && !FileSystem.isDirectory (configFile)) {
							
							client = getHaxelibClient (File.getContent (configFile));
							
						} else {
							
							var haxePath = Sys.getEnv ("HAXEPATH");
							
							if (haxePath != null) {
								
								client = getHaxelibClient (haxePath + "/lib");
								
							}
							
						}
						
					} else {
						
						var home = Sys.getEnv ("HOME");
						
						if (home != null) {
							
							var configFile = home + "/.haxelib";
							
							if (configFile != null && FileSystem.exists (configFile) && !FileSystem.isDirectory (configFile)) {
								
								client = getHaxelibClient (File.getContent (configFile));
								
							} else if (FileSystem.exists ("/etc/.haxelib")) {
								
								client = getHaxelibClient (File.getContent ("/etc/.haxelib"));
								
							}
							
						}
						
					}
					
				}
				
			}
			
			return client;
			
		} catch (e:Dynamic) {
			
			return null;
			
		}
		
	}
	
	
	private static function getHaxelibClient (path:String):String {
		
		try {
			
			path = StringTools.trim (path) + "/haxelib_client";
			
			if (FileSystem.exists (path) && FileSystem.isDirectory (path)) {
				
				if (FileSystem.exists (path + "/.dev")) {
					
					path = StringTools.trim (File.getContent (path + "/.dev"));
					
				} else if (FileSystem.exists (path + "/.current")) {
					
					path += "/" + Data.safe (StringTools.trim (File.getContent (path + "/.current")));
					
				} else {
					
					return null;
					
				}
				
				if (FileSystem.exists (path) && FileSystem.isDirectory (path)) {
					
					return path;
					
				}
				
			}
			
		} catch (e:Dynamic) {}
		
		return null;
		
	}
	
	
	public static function main () {
		
		var upgradedClient = findUpgrade ();
		
		if (upgradedClient != null) {
			
			var args = Sys.args ();
			
			if (FileSystem.exists (upgradedClient + "/haxelib.n")) {
				
				Sys.exit (Sys.command ("neko", [ upgradedClient + "/haxelib.n" ].concat (args)));
				
			} else if (FileSystem.exists (upgradedClient + "/bin/haxelib.n")) {
				
				Sys.exit (Sys.command ("neko", [ upgradedClient + "/bin/haxelib.n" ].concat (args)));
				
			} else if (FileSystem.exists (upgradedClient + "/tools/haxelib/Main.hx")) {
				
				Sys.exit (Sys.command ("haxe", [ "-cp", upgradedClient, "--run", "tools.haxelib.Main" ].concat (args)));
				
			} else {
				
				Sys.exit (Sys.command ("haxe", [ "-cp", upgradedClient + "/src", "--run", "tools.haxelib.Main" ].concat (args)));
				
			}
			
		}
		
		new tools.haxelib.Main ().process ();
		
	}
	
	
}