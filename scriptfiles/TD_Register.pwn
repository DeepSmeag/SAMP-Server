//Global Textdraws:

new Text:RegisterBackground;
new Text:RegisterWelcome;
new Text:RegisterUnderscore;
new Text:RegisterBox;
new Text:RegisterContinue;
new Text:RegisterCancel;


RegisterBackground = TextDrawCreate(438.000000, 140.625000, "usebox");
TextDrawLetterSize(RegisterBackground, 0.000000, 7.898610);
TextDrawTextSize(RegisterBackground, 202.000000, 0.000000);
TextDrawAlignment(RegisterBackground, 1);
TextDrawColor(RegisterBackground, 0);
TextDrawUseBox(RegisterBackground, true);
TextDrawBoxColor(RegisterBackground, 102);
TextDrawSetShadow(RegisterBackground, 0);
TextDrawSetOutline(RegisterBackground, 0);
TextDrawFont(RegisterBackground, 0);

RegisterWelcome = TextDrawCreate(209.500000, 142.625000, "Enter a password to register:");
TextDrawLetterSize(RegisterWelcome, 0.431500, 1.425001);
TextDrawAlignment(RegisterWelcome, 1);
TextDrawColor(RegisterWelcome, -1);
TextDrawSetShadow(RegisterWelcome, 0);
TextDrawSetOutline(RegisterWelcome, 1);
TextDrawBackgroundColor(RegisterWelcome, 51);
TextDrawFont(RegisterWelcome, 1);
TextDrawSetProportional(RegisterWelcome, 1);

RegisterUnderscore = TextDrawCreate(208.500000, 148.312500, "----------------------------------------------------------------------------------");
TextDrawLetterSize(RegisterUnderscore, 0.182499, 1.788126);
TextDrawAlignment(RegisterUnderscore, 1);
TextDrawColor(RegisterUnderscore, -1);
TextDrawSetShadow(RegisterUnderscore, 0);
TextDrawSetOutline(RegisterUnderscore, 1);
TextDrawBackgroundColor(RegisterUnderscore, -16755371);
TextDrawFont(RegisterUnderscore, 1);
TextDrawSetProportional(RegisterUnderscore, 1);

RegisterBox = TextDrawCreate(424.500000, 174.312500, "usebox");
TextDrawLetterSize(RegisterBox, 0.000000, 0.995833);
TextDrawTextSize(RegisterBox, 218.500000, 0.000000);
TextDrawAlignment(RegisterBox, 1);
TextDrawColor(RegisterBox, 0);
TextDrawUseBox(RegisterBox, true);
TextDrawBoxColor(RegisterBox, 102);
TextDrawSetShadow(RegisterBox, 0);
TextDrawSetOutline(RegisterBox, 0);
TextDrawFont(RegisterBox, 0);

RegisterContinue = TextDrawCreate(252.000000, 192.937500, "Continue");
TextDrawLetterSize(RegisterContinue, 0.239999, 1.324375);
TextDrawAlignment(RegisterContinue, 1);
TextDrawColor(RegisterContinue, -1);
TextDrawSetShadow(RegisterContinue, 0);
TextDrawSetOutline(RegisterContinue, 1);
TextDrawBackgroundColor(RegisterContinue, 51);
TextDrawFont(RegisterContinue, 2);
TextDrawSetProportional(RegisterContinue, 1);
TextDrawSetSelectable(RegisterContinue, true);

RegisterCancel = TextDrawCreate(345.500000, 193.375000, "Cancel");
TextDrawLetterSize(RegisterCancel, 0.253000, 1.324375);
TextDrawAlignment(RegisterCancel, 1);
TextDrawColor(RegisterCancel, -1);
TextDrawSetShadow(RegisterCancel, 0);
TextDrawSetOutline(RegisterCancel, 1);
TextDrawBackgroundColor(RegisterCancel, 51);
TextDrawFont(RegisterCancel, 2);
TextDrawSetProportional(RegisterCancel, 1);
TextDrawSetSelectable(RegisterCancel, true);


//Player Textdraws:

new PlayerText:RegisterPassText[MAX_PLAYERS];


RegisterPassText[playerid] = CreatePlayerTextDraw(playerid, 224.000000, 173.687500, "Enter password...");
PlayerTextDrawLetterSize(playerid, RegisterPassText[playerid], 0.195500, 1.035627);
PlayerTextDrawAlignment(playerid, RegisterPassText[playerid], 1);
PlayerTextDrawColor(playerid, RegisterPassText[playerid], -1);
PlayerTextDrawSetShadow(playerid, RegisterPassText[playerid], 7);
PlayerTextDrawSetOutline(playerid, RegisterPassText[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, RegisterPassText[playerid], 51);
PlayerTextDrawFont(playerid, RegisterPassText[playerid], 2);
PlayerTextDrawSetProportional(playerid, RegisterPassText[playerid], 1);
PlayerTextDrawSetSelectable(playerid, RegisterPassText[playerid], true);

