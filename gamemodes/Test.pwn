#include <a_samp> //Include all necessary native functions
#include <strlib> //String manipulation library
#include <YSI\y_commands> //Commands processing
#include <YSI\y_master>
#include <YSI\y_ini>
#include <sscanf2> //Text processing
#include <Whirlpool>
#include <a_mysql>
#include <bcrypt>

//DEFINES

#define SCM SendClientMessage
#define SCMex SendClientMessageEx

#define MYSQL_HOST        "localhost"    // Change this to your MySQL Remote IP or "localhost".
#define MYSQL_USER        "mysqladmin" // Change this to your MySQL Database username.
#define MYSQL_PASS        "1234" // Change this to your MySQL Database password.
#define MYSQL_DATABASE    "playersdb" // Change this to your MySQL Database name.
#define function%0(%1) forward %0(%1); public%0(%1)

//-------------------------------------------------------------
//-------------------------- STATICS --------------------------
//-------------------------------------------------------------

static stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser", "SFPD Cruiser", "LVPD Cruiser",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

//-------------------------------------------------------------
//------------------------ END STATICS ------------------------
//-------------------------------------------------------------




//-----------------------------SQL_CONNECTION-----------------------------


new MySQL:SQL_connection , sqlQuery[256], sqlString[256];

enum pAccount_Data
{
	pSQLID,
	pName[MAX_PLAYER_NAME],
	pPassword[BCRYPT_HASH_LENGTH],
	pEmail[32],
	bool: pIsLogged,
	passTries,
	pSkin,
	bool: isPassCorrect
}
new AccountInfo[MAX_PLAYERS][pAccount_Data];

enum 
{
	//Register
	DIALOG_REGISTER_PASS,
	DIALOG_REGISTER_EMAIL,
	//Login
	DIALOG_LOGIN
}
//------------------------------------------------------------------------



/*
 * ======================================================
 *
 * FORWARDS
 *
 * ======================================================
 */

 
 
/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 * MAIN FUNCTION
 * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

main()
{
	print("\n----------------------------------");
	print(" Test Gamemode by moi here");
	print("----------------------------------\n");
	
	
	
}

public OnGameModeInit()
{
	/*
		new MySQLOpt: option_id = mysql_init_options();
		mysql_set_option(option_id, AUTO_RECONNECT, true);
	*/
	SetGameModeText("This is a test gamemode");
	SQL_connection = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE);
	if(mysql_errno(SQL_connection) != 0) // Checking if the database connection is invalid to shutdown.
	{
		print("I couldn't connect to the MySQL server, closing."); // Printing a message to the log.

		//SendRconCommand("exit"); // Sending console command to shut down server.
		return 1;
	}
	else
	{
		print("I have connected to the MySQL server."); // If the given MySQL details were all okay, this message prints to the log.
	}
	
	
	return 1;
}

public OnGameModeExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		SavePlayerData(i);
	}	
	mysql_close(SQL_connection);
	print("Connexion to MySQL server has been closed.");
	return 1;
}

public OnPlayerConnect(playerid)
{
	
	//sqlQuery[0] = EOS;
	//mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT * FROM players_data WHERE Name = '%e'", GetName(playerid));
	
	
	
	SCM(playerid, COLOR_LIME, "You have connected");
	AccountInfo[playerid][pName] = GetName(playerid);
	sqlQuery[0] = EOS; //Reset sqlQuery
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT * FROM players_data WHERE Name = '%e'", GetName(playerid));
	mysql_tquery(SQL_connection, sqlQuery, "checkAccountExists", "i", playerid);
	mysql_tquery(SQL_connection, sqlQuery, "ResetPlayerData", "i", playerid); //Citire din baza de date si setare in enum
	
	
	TogglePlayerSpectating(playerid, true);
	SetTimerEx("connect_dialog", 100, 0, "i", playerid);
	
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SavePlayerData(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SCM(playerid, COLOR_LIME, "You have been spawned");
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	SCM(playerid, COLOR_AQUA, "You have requested a spawn");
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	SCM(playerid, COLOR_BLUE, "You have exited the menu");
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_REGISTER_PASS:
		{
			if(!response)
			{
				return Kick(playerid);
			}
			if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
			{
				return ShowPlayerDialog(playerid, DIALOG_REGISTER_PASS, DIALOG_STYLE_PASSWORD, "EROARE", "Parola trebuie sa aiba intre 6 si 32 caractere!\nIntroduceti o parola puternica unica.\n!!Asigurati-va ca nu ati mai folosit-o altundeva!", "Inregistrare", "Anulare");
				
			}
			
			/*
			sqlQuery[0] = EOS;
			mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "INSERT INTO players_data (Name, Password) VALUES ('%s', '%s')", GetName(playerid), inputtext);
			mysql_tquery(SQL_connection, sqlQuery, "insertAccount", "i", playerid);
			*/
			/*
			sqlString[0] = EOS;
			format(sqlString, sizeof(sqlString), "Parola ta contine %d caractere", strlen(inputtext));
			SCM(playerid, COLOR_WHITE, sqlString);
			*/
			HashPassword(inputtext, playerid);
			ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Email", "Introdu adresa de email", "Continua", "Anuleaza");
		}
		case DIALOG_REGISTER_EMAIL:
		{
			if(!response)
			{
				return Kick(playerid);
			}
			if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
			{
				return ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "EROARE", "Emailul trebuie sa aiba intre 6 si 32 caractere", "Inregistrare", "Anulare");
				
			}
			if(!isValidEmail(inputtext, playerid))
			{
				return ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "EROARE", "Emailul nu este valid", "Inregistrare", "Anulare");
			}
			format(AccountInfo[playerid][pEmail], 32, "%s", inputtext);
			
			/*
			sqlQuery[0] = EOS;
			mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "UPDATE players_data SET Email = '%s' WHERE ID = '%d'", inputtext, AccountInfo[playerid][pSQLID]);
			mysql_tquery(SQL_connection, sqlQuery);
			*/
			sqlQuery[0] = EOS;
			mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "INSERT INTO players_data (Name, Password, Email, IP_Registered, Date_Registered, Time_Registered) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", AccountInfo[playerid][pName], AccountInfo[playerid][pPassword], AccountInfo[playerid][pEmail], ReturnIP(playerid), ReturnDate(), ReturnTime());
			mysql_tquery(SQL_connection, sqlQuery, "insertAccount", "i", playerid);
			
			sqlString[0] = EOS;
			format(sqlString, sizeof(sqlString), "Email setat: %s", AccountInfo[playerid][pEmail]);
			SCM(playerid, COLOR_WHITE, sqlString);
			AccountInfo[playerid][pSkin] = 250;
			SetSpawnInfo(playerid, 0, AccountInfo[playerid][pSkin], 1642.2968, -2239.2695, 13.4966, 180.0122, 0, 0, 0, 0, 0, 0);
			
			TogglePlayerSpectating(playerid, false);
		}
		case DIALOG_LOGIN:
		{
			if(!response)
			{
				SCM(playerid, COLOR_RED, "Trebuie sa te loghezi pentru a putea juca!");
				return Kick(playerid);
			}
			/*
			sqlQuery[0] = EOS;
			mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT Name, Password FROM players_data WHERE Name = '%s' AND Password = '%s'", AccountInfo[playerid][pName], inputtext);
			mysql_tquery(SQL_connection, sqlQuery, "onLogin", "i", playerid);
			*/
			CheckPassword(inputtext, playerid);
			//SetTimerEx("LoginPlayer", 100, 0, "d", playerid);
			//LoginPlayer(playerid);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	
	return 1;
}

/* =============================================================
 * =============================================================
 * =============================================================
 *						CUSTOM FUNCTIONS
 * =============================================================
 * =============================================================
 * =============================================================
 */

function ResetPlayerData(playerid) //La conectare, datele trebuie citite din baza de date
{
	SCM(playerid, COLOR_WHITE, "A intrat in reset data");
	AccountInfo[playerid][pIsLogged] = false;
	AccountInfo[playerid][isPassCorrect] = false;
	AccountInfo[playerid][passTries] = 0;
	AccountInfo[playerid][pName] = GetName(playerid);
	/*
	sqlQuery[0] = EOS;
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT * FROM players_data WHERE Name = '%e'", GetName(playerid));
	mysql_tquery(SQL_connection, sqlQuery);
	*/
	cache_get_value_name_int(0, "ID", AccountInfo[playerid][pSQLID]);
	
	// Citire SkinID
	/*
	sqlQuery[0] = EOS;
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT SkinID FROM players_data WHERE Name = '%e'", GetName(playerid));
	mysql_tquery(SQL_connection, sqlQuery);
	*/
	cache_get_value_name_int(0, "SkinID", AccountInfo[playerid][pSkin]);
	
	// Citire Email
	/*
	sqlQuery[0] = EOS;
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT Email FROM players_data WHERE Name = '%e'", GetName(playerid));
	mysql_tquery(SQL_connection, sqlQuery);
	*/
	cache_get_value_name(0, "Email", AccountInfo[playerid][pEmail], 32 );
	
	// Citire Password
	/*
	sqlQuery[0] = EOS;
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT Password FROM players_data WHERE Name = '%e'", GetName(playerid));
	mysql_tquery(SQL_connection, sqlQuery);
	*/
	cache_get_value_name(0, "Password", AccountInfo[playerid][pPassword], BCRYPT_HASH_LENGTH);
	SCMex(playerid, COLOR_WHITE, "SkinID from database is %i, Email is %s, Password is %s.", AccountInfo[playerid][pSkin], AccountInfo[playerid][pEmail], AccountInfo[playerid][pPassword]);
	
	return 1;
}

stock SavePlayerData(playerid) //La deconectare, datele trebuie scrise in baza de date si salvate
{
	AccountInfo[playerid][pIsLogged] = false;
	//Salvat skin doar deocamdata
	sqlQuery[0] = EOS;
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "UPDATE players_data SET SkinID = '%d' WHERE Name = '%e'", AccountInfo[playerid][pSkin], AccountInfo[playerid][pName]);
	mysql_tquery(SQL_connection, sqlQuery);
	
	return 1;
}

stock GetName(playerid)
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
	return playerName;
}

function checkAccountExists(playerid)
{
	new Rows;
	cache_get_row_count(Rows);
	switch(Rows)
	{
		case 0: 
		{
			SetTimerEx("connect_dialog", 100, 0, "i", playerid);
			SCMex(playerid, COLOR_YELLOW, "Welcome to the server, %s! Please register to play.", AccountInfo[playerid][pName]);
			new Dialog_Inregistrare[1000];
			format(Dialog_Inregistrare, sizeof(Dialog_Inregistrare), "Bun venit pe server, {77DDFF}%s{A9C4E4}! Scrie o parola puternica pentru a te inregistra.\nParola trebuie sa aiba minimum 6 caractere si maximum 32.\nAsigura-te ca nu ai mai folosi-to nicaieri!", GetName(playerid));
			ShowPlayerDialog(playerid, DIALOG_REGISTER_PASS, DIALOG_STYLE_PASSWORD, "Inregistrare", Dialog_Inregistrare, "Inregistrare", "Anulare");
			SCM(playerid, COLOR_RED, "Nu ai cont!");
		}
		case 1:
		{
			SetTimerEx("connect_dialog", 100, 0, "i", playerid);
			new Dialog_Login[1000];
			format(Dialog_Login, sizeof(Dialog_Login), "   Bun venit inapoi, {77DDFF}%s{A9C4E4}!\nIntrodu parola pentru a te conecta:", GetName(playerid));
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Conectare", Dialog_Login, "Continua", "Anulare");
			SCM(playerid, COLOR_RED, "Ai cont!");
		}
		default:
		{
			SCM(playerid, COLOR_RED, "Eroare la conectare, va rugam incercati din nou");
			Kick(playerid);
		}
	}
	return 1;
}

function insertAccount(playerid)
{
	AccountInfo[playerid][pSQLID] = cache_insert_id();
	printf("%s s-a inregistrat cu SQLID-ul #%d.", GetName(playerid), AccountInfo[playerid][pSQLID]);
	return 1;
}

function onLogin(playerid)
{
	/*
	new Rows, name[MAX_PLAYER_NAME], pass[BCRYPT_HASH_LENGTH];
	cache_get_row_count(Rows);
	cache_get_value_name(0, "Name", name);
	cache_get_value_name(0, "Password", pass);
	SCMex(playerid, COLOR_AQUA, "Randuri: %d, Nume: %s, Parola: %s", Rows, name, pass);
	*/
	if(AccountInfo[playerid][isPassCorrect] == true)
	{
		
	}
	
	return 1;
}


// Stock Values

stock ReturnName(playerid, underScore = 1)
{
    new playersName[MAX_PLAYER_NAME + 2];
    GetPlayerName(playerid, playersName, sizeof(playersName));
 
    if(!underScore)
    {
        {
            for(new i = 0, j = strlen(playersName); i < j; i ++)
            {
                if(playersName[i] == '_')
                {
                    playersName[i] = ' ';
                }
            }
        }
    }
 
    return playersName;
}
 
stock ReturnIP(playerid)
{
    new
        ipAddress[20];
 
    GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
    return ipAddress;
}
 
stock ReturnDate()
{
    new Year, Month, Day, DateString[24];
	getdate(Year, Month, Day);		
	format(DateString, sizeof(DateString), "%d/%d/%d", Day, Month, Year);
    return DateString;
}

stock ReturnTime()
{
	new Hour, Minute, Second, TimeString[24];
	gettime(Hour, Minute, Second);
	format(TimeString, sizeof(TimeString), "%d:%d:%d", Hour, Minute, Second);
	return TimeString;
}
 
stock KickEx(playerid)
{
    return SetTimerEx("KickTimer", 100, false, "i", playerid);
}
 
stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...) //SendClientMessage but permits formating of text without the additional use of format()
{
    static
        args,
        start,
        end,
        string[156]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args
 
    if (args > 12)
    {
        #emit ADDR.pri str
        #emit STOR.pri start
 
        for (end = start + (args - 12); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 156
        #emit PUSH.C string
        #emit PUSH.C args
        #emit SYSREQ.C format
 
        SCM(playerid, color, string);
 
        #emit LCTRL 5
        #emit SCTRL 4
        #emit RETN
    }
    return SCM(playerid, color, str);
}
 
stock ReturnVehicleName(vehicleid)
{
    new
        model = GetVehicleModel(vehicleid),
        name[32] = "None";
 
    if (model < 400 || model > 611)
        return name;
 
    format(name, sizeof(name), g_arrVehicleNames[model - 400]);
    return name;
}

function connect_dialog(playerid)
{
	SetPlayerCameraPos(playerid, 1338.1400, -2484.9341, 123.6392);
	SetPlayerCameraLookAt(playerid, 1338.7003, -2484.0986, 123.4541);
	
    
    return 1;
}

stock static HashPassword(string_pass[], playerid)
{
	bcrypt_hash(string_pass, BCRYPT_COST, "OnPasswordHashed", "d", playerid);
	return 1;
}

stock static CheckPassword(string_pass[], playerid)
{
	new hashed_pass[BCRYPT_HASH_LENGTH];
	/*
	sqlQuery[0] = EOS;
	mysql_format(SQL_connection, sqlQuery, sizeof(sqlQuery), "SELECT Password FROM players_data WHERE Name = '%s'", AccountInfo[playerid][pName]);
	mysql_tquery(SQL_connection, sqlQuery);
	cache_get_value_name(0, "Password", hashed_pass);
	*/
	format(hashed_pass, BCRYPT_HASH_LENGTH, "%s", AccountInfo[playerid][pPassword]);
	bcrypt_check(string_pass, hashed_pass, "LoginCheck", "d", playerid);
}

function OnPasswordHashed(playerid)
{
	new hash[BCRYPT_HASH_LENGTH];
	bcrypt_get_hash(hash);
	format(AccountInfo[playerid][pPassword], BCRYPT_HASH_LENGTH, "%s", hash); 
	return 1;
}

function LoginCheck(playerid)
{
	new bool:is_match = bcrypt_is_equal();
	if(is_match) //Parola corecta
	{
		LoginPlayer(playerid);
		return 1;
	}
	//Parola gresita
	AccountInfo[playerid][passTries] ++;
	SCMex(playerid, COLOR_RED, "Parola incorecta! %d incercari ramase", 3-AccountInfo[playerid][passTries]);
	if(AccountInfo[playerid][passTries] == 3)
	{
		return Kick(playerid);
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "EROARE", "Ai gresit parola.\nIncearca din nou:", "Continua", "Anulare");
	}
	return 1;
}

stock static LoginPlayer(playerid)
{
	printf("%s (user: %d) s-a logat. (Email: %s, Password: %s)", AccountInfo[playerid][pName], AccountInfo[playerid][pSQLID], AccountInfo[playerid][pEmail], AccountInfo[playerid][pPassword]);
		
	for(new i = 0; i < 10; i++) SCM(playerid, COLOR_WHITE, "");
	SCM(playerid, COLOR_LIME, "Te-ai logat cu succes");
	SetSpawnInfo(playerid, 0, AccountInfo[playerid][pSkin], 1642.2968, -2239.2695, 13.4966, 180.0122, 0, 0, 0, 0, 0, 0);
	TogglePlayerSpectating(playerid, false);
	AccountInfo[playerid][pIsLogged] = true;
	return 1;
}

function isValidEmail(const string[], playerid)
{
	new pos, len = strlen(string);
	new bool: hasArond = false;
	//Verifica daca are @
	for(pos = 0; pos < len; pos++ )
	{
		//Verific daca are caractere valide
		if( ( string[pos] >= 'a' && string[pos] <= 'z' ) || ( string[pos] >= 'A' && string[pos] <= 'Z' ) || ( string[pos] == '.' ) || ( string[pos] == '_' ) || ( string[pos] == '-' ) || ( string[pos] >= '0' && string[pos] <= '9') )
		if(string[pos] == '@')
		{
			hasArond = true;
			break;
		}
	}
	if(hasArond)
	{
		for(new i = pos; i < len; i++)
		{
			if(string[i] == '.' && (i - pos) > 2 && (len - i) > 2)
			{
				return 1;
			}
		}
	}
	//Verifica daca are un . dupa @
	return 0;
}

/*
 *
 *
 *	CUSTOM COMMANDS
 *
 *
 */

CMD:setskin(playerid, params[])
{
	new SkinID;
	if(sscanf(params, "i", SkinID)) return SCM(playerid, COLOR_GREEN, "Sintaxa: /setskin [Skin ID] .");
	if(SkinID < 0 || SkinID > 299) return SCM(playerid, COLOR_RED, "EROARE: Skinul este invalid.");
	SetPlayerSkin(playerid, SkinID);
	AccountInfo[playerid][pSkin] = SkinID;
	SCM(playerid, COLOR_LIME, "Skinul tau a fost schimbat.");
	return 1;
}
CMD:getskin(playerid, params[])
{
	SCMex(playerid, COLOR_WHITE, "Skinul tau are id-ul %i", AccountInfo[playerid][pSkin]);
	return 1;
}
CMD:spawnvehicle(playerid, params[])
{
	new vehicleID, Float:pX, Float:pY, Float:pZ, Float:pRot, color1 = 0, color2 = 0;
	if (!sscanf(params, "iii", vehicleID, color1, color2))
	{
		if(vehicleID < 400 || vehicleID > 603) return SCM(playerid, COLOR_RED, "EROARE: ID vehicul invalid.");
		if( (color1 < 0 || color1 > 255) || (color2 < 0 || color2 > 255) ) return SCM(playerid, COLOR_RED, "EROARE: ID culoare invalid.");
		if(IsPlayerInAnyVehicle(playerid))
		{
			RemovePlayerFromVehicle(playerid);
			DestroyVehicle(GetPlayerVehicleID(playerid));
		}
		GetPlayerPos(playerid, pX, pY, pZ);
		GetPlayerFacingAngle(playerid, pRot);
		new vehSpawnedID = CreateVehicle(vehicleID, pX, pY-1, pZ, pRot, color1, color2, -1);
		PutPlayerInVehicle(playerid, vehSpawnedID, 0);
	}
	else if(!sscanf(params, "i", vehicleID)) 
	{
		if(vehicleID < 400 || vehicleID > 603) return SCM(playerid, COLOR_RED, "EROARE: ID vehicul invalid.");
		if(IsPlayerInAnyVehicle(playerid))
		{
			RemovePlayerFromVehicle(playerid);
			DestroyVehicle(GetPlayerVehicleID(playerid));
		}
		GetPlayerPos(playerid, pX, pY, pZ);
		GetPlayerFacingAngle(playerid, pRot);
		new vehSpawnedID = CreateVehicle(vehicleID, pX, pY-1, pZ, pRot, color1, color2, -1);
		PutPlayerInVehicle(playerid, vehSpawnedID, 0);
	}
	else 
	{
		return SCM(playerid, COLOR_SYNTAX_WRONG, "Sintaxa: /spawnvehicle [Vehicle ID] <OPT: [COLOR1] [COLOR2]> .");
	}
	
	return 1;
}

CMD:tp(playerid, params[])
{
	new locX, locY, locZ;
	if(!sscanf(params, "fff", locX, locY, locZ))
	{
		SetPlayerPos(playerid, locX, locY, locZ);
	}
	else
	{
		return SCM(playerid, COLOR_SYNTAX_WRONG, "Sintaxa: /tp X Y Z.");
	}
	
	return 1;
}