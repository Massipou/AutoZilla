# AutoZilla
Autozilla is an automatised mastering software.
It save and restore full disk state with clonezilla program but with a minimal and user-friendly GUI.
He make mastering easyer by detectecting computer model and display all master have been made for this model.

He work as a bootable usb stick and he get machine masters on a external CIFS server.
He get path of target machine's master with a CSV file stored on a CIFS server to.

## Build :

for build it you need a Debian 11 machine.

### Install :
<code> apt-get install live-build </code>

<code> git clone https://github.com/Massipou/AutoZilla.git </code> 

<code> cd AutoZilla; cd AutoZilla </code> 
  
### build :
<code> lb config </code>

<code> sudo lb build </code>
  
### cleaning build :

<code> sudo lb clean </code>

## Configuration : 

The configuration file is <code>config/includes.binary/preconfig.cfg</code>

(You can also edit it after buid, the config file will be in the root folder of the iso)

He contain the following options:

### Database path config :

<li><code>db_share</code> : Database share network path (exemple "//192.168.1.19/Docs")</li>
<li><code>db_path</code> : Path for the database from db_share (exemple "/path.txt" if absolute CIFS path is //192.168.1.19/Docs/path.txt</li>
<li><code>db_username</code> : CIFS login for read the database</li>
<li><code>db_password</code> : CIFS Password.</li>

### Master path config :

<li><code>shareip</code> : Hostname of CIFS mastering server. (just hostname, exemple : "192.168.1.19" or "SMB_SERVER")</li>
Server must be in read-only for guest. (login: "guest", password: "")
/!\ Server should respond to ping.

## Database.

The database is used for get targeted machine's master path for each machine model. (for avoid to write the path each time you want to restore or save)
one database entry have to be like this:

<code> &lt;model name&gt;;&lt;path to masters&gt; </code>

exemple :

<code> OptiPlex 3000;/Serveur/clonezilla/Optiplex/ </code>

Where "Optiplex 3000" Is the precise model name in the motherboard
and "/Serveur/clonezilla/Optiplex/" is the master's path.

if &lt;shareip&gt; in preconfig.cfg is 192.168.1.16
the master path will be "//192.168.1.16/Serveur/clonezilla/Optiplex/"

/!\ Don't add space between model name and ";"

## Utilisation :

<li>First flash a USB key with "autozilla-amd64.hybrid.iso" with dd or rufus.</li>
<li>On the machine you want to restore disk, boot on the usb key.</li>
The system will load in RAM and try DHCP. When CIFS server is reachable (by ping) the script launch
<li>First menu ask you to select a disk (to restore or save)</li>
<li>Program will ask you to restore or save disk</li>

### Restore :
<li> AutoZilla will show you a menu with all masters there is in the path corresponding to the machine model, you just have to choose one </li>
<li> You maybe have to press enter to validate or the restoration automaticly start </li>

### Save :
<li> Autozilla ask you th write the path for the new disk save, by default it is naturaly the path of the database<Lli>
<li> Autozilla will ask you username and password for write access </li>
If there is no errors, the save will start.

### If there is no entry for the model in database:

Autozilla will show you an error message with the model name of the current machine and you will be able to write a new entry in the database for this model.
After the entry is added, press enter and AutoZilla will retry to find an entry corresponding to his model name.
