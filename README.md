The Wizard Of Dev center interacts with the Apple Dev Center web pages so you don't have to!

Install
---

    $ gem install wod

Usage
---
    $ wod help
    
    === General Commands

    help                        # show this usage
    version                     # show the gem version

    login                       # log in with your apple credentials
    logout                      # clear local authentication credentials

    devices                     # list your registered devices
    devices:add <name> <udid>   # add a new device
    devices:remove <name>       # remove device (Still counts against device limit)

    profiles                    # list your distribution provisioning profiles
    profiles:get <name> <file>  # download distribution profile to file

Examples
---

List Devices:

    $ wod devices
    Steve Jobs iPad 3  | 554f3fg54bc953547ry7a6bd62c678c11e912345
    Jon Ive's iPhone 5 | 2d84d56ceg52c49379537413d3b9865ae2b12345

Add Device:

    $ wod devices:add "Dave's iPod Touch" 2d84d56ceg52c49379537413d3b9865ae2b12345
    
Remove Device:

    $ wod devices:remove "Jon Ive's iPhone 5"
    

Roadmap
---

More features to come as I need them or as other people fork and add em ;)

Proudly brought to you by the wizard of identity crises (whatupdave/snappycode/wizard of id)
