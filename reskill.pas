///////////////////////////////////////////////////////////
//
//          LANGHOST RESKILL SCRIPT v1.0 (C) 2020
//
///////////////////////////////////////////////////////////

uses SysUtils;

///////////////////////////////////////////////////////////
//
//                      USER SETTINGS
//
///////////////////////////////////////////////////////////

const
    RESKILL_DELAY = 2000;
    RESKILL_RANGE = 900;

///////////////////////////////////////////////////////////
//
//                    SCRIPT DEFINES
//
///////////////////////////////////////////////////////////

type
    TSkill = (SOLAR_FLARE_SKILL = 1265,
              FOE_SKILL = 1427);

procedure FindFOE();
var
    target : TL2Char;
    i : integer;
begin
    for i := 0 to CharList.Count - 1 do
    begin
        target := CharList.Items(i);

        if (not target.Valid)
        then continue;

        if (target.Clan <> User.Clan) and (target.Cast.EndTime > 0)
            and (target.Cast.ID = Integer(FOE_SKILL))
        then begin
            Engine.SetTarget(target);
            Delay(200);
            continue;
        end;
    end;
end;

procedure Reskill();
var
    p1, p2 : pointer;
    target: TL2Live;
    enemy : TL2Char;
begin
    Engine.WaitAction([laRevive], p1, p2);
    target := TL2Live(p1);

    if (User.DistTo(target) <= RESKILL_RANGE) and (target.Clan <> User.Clan)
    then begin
        Engine.SetTarget(target);
        Engine.DUseSkill(Integer(SOLAR_FLARE_SKILL), False, False);
        Delay(RESKILL_DELAY);
    end;
end;

///////////////////////////////////////////////////////////
//
//                    SCRIPT THREADS
//
///////////////////////////////////////////////////////////

procedure FindFOEThread();
begin
    Engine.GamePrint('FOE finder started.', 'RESKILL', 3);
    while True do
    begin
        FindFOE();
        Delay(10);
    end;
end;

procedure ReskillThread();
begin
    Engine.GamePrint('Reskill started.', 'RESKILL', 3);
    while True do
    begin
        Reskill();
        Delay(10);
    end;
end;

///////////////////////////////////////////////////////////
//
//                   MAIN FUNCTION
//
///////////////////////////////////////////////////////////

begin
    script.NewThread(@ReskillThread);
    script.NewThread(@FindFOEThread);
end.