/* ----------------------------------------------------------------------------
Function: lilc_atm_fnc_callback_createAccount
Scope: private

Description:
    Sets the received atm bank account data.

Parameters:
    _bankAccount - Is the received bank account data. <ARRAY>

Returns:
    - <NIL>

Examples:
    (begin example)
    (end)

Author:
    TheMysteriousVincent
---------------------------------------------------------------------------- */

[_this] params [
    ["_bankAccount", [], [[]]]
];

if ((count _bankAccount) > 0) then {
    lilc_bank_accounts pushBack [_bankAccount select 4, _bankAccount select 1];
    ["create_complete"] call lilc_atm_fnc_selectMenu;
} else {
    ["create_failed"] call lilc_atm_fnc_selectMenu;
};

lilc_atm_currentBankAccount = _bankAccount;
