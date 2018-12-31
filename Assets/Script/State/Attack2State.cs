﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Attack2State : BaseBattleState
{
    public Attack2State(Actor actor) : base(actor, EActionState.Attack2)
    {
    }

    public override void EnterState(EActionState eState)
    {
        base.EnterState(eState);
    }

    public override void BreakState(EActionState eState)
    {
        base.BreakState(eState);
    }

    public override void OnUpdate()
    {
        base.OnUpdate();
    }

    public override void OnFixedUpdate()
    {
        base.OnFixedUpdate();
    }
}