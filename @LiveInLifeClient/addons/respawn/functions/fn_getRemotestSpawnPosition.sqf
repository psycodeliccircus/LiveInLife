
try
{
    if ((count lilc_respawn_corpsePosition) != 2) throw [];
    private _factionID = (player getVariable ["lilc_factionID", -1]);

    if (_factionID <= -1) then
    {
        if ((player getVariable ["lilc_prison_escapeTime", 0]) > 0 || (player getVariable ["lilc_prison_waitingTime", 0]) > 0) then {
            private _prisons = ("true" configClasses (missionConfigFile >> "CfgPrisons"));
            private _nearestPrisonCfg = (_prisons select 0);
            if ((count _prisons) <= 0) throw (["default"] call lilc_common_fnc_getDynamicPosition);

            private _dist = ((getMarkerPos getText(_nearestPrisonCfg >> "markerName")) distance player);
            {
                private _nDist = (getMarkerPos getText(_x >> "markerName")) distance player;
                if (_nDist < _dist) then {
                    _dist = _nDist;
                    _nearestPrisonCfg = _x;
                };
                true;
            } count _prisons;

            if (isNull _nearestPrisonCfg) throw (["default"] call lilc_common_fnc_getDynamicPosition);

            throw ([getText(_nearestPrisonCfg >> "respawnPosition")] call lilc_common_fnc_getDynamicPosition);
        } else {
            private _availableHospitals = [];
            {
                if ([_x, "hospital_"] call KRON_StrInStr) then
                {
                    _availableHospitals pushBack _x;
                };
            } forEach lilc_common_dynamicPositions;

            if ((count _availableHospitals) <= 0) throw [];

            private _remotestHospital = 0;
            {
                if (((([_x] call lilc_common_fnc_getDynamicPosition) select 0) distance (lilc_respawn_corpsePosition select 0)) >
                ((([_availableHospitals select _remotestHospital] call lilc_common_fnc_getDynamicPosition) select 0) distance (lilc_respawn_corpsePosition select 0))) then
                {
                    _remotestHospital = _forEachIndex;
                };
            } forEach _availableHospitals;

            throw ([(_availableHospitals select _remotestHospital)] call lilc_common_fnc_getDynamicPosition);
        };
    }
    else
    {
        private _factionConfig = ([_factionID] call lilc_factions_fnc_getFactionConfig);
        if (isNull _factionConfig) throw [];

        private _respawns = [];
        if (isArray(_factionConfig >> "respawn")) then
        {
            _respawns = getArray(_factionConfig >> "respawn");
        }
        else
        {
            if (isText(_factionConfig >> "respawn")) then
            {
                _respawns = [(getText(_factionConfig >> "respawn"))];
            };
        };

        if ((count _respawns) <= 0) throw [];

        private _remotestSpawnpoint = ([(_respawns select 0)] call lilc_common_fnc_getDynamicPosition);
        {
            if (((lilc_respawn_corpsePosition select 0) distance (_remotestSpawnpoint select 0)) < ((([_x] call lilc_common_fnc_getDynamicPosition) select 0) distance (lilc_respawn_corpsePosition select 0))) then
            {
                _remotestSpawnpoint = ([_x] call lilc_common_fnc_getDynamicPosition);
            };
        } forEach _respawns;

        throw _remotestSpawnpoint;
    };
} catch {
    _exception;
};
