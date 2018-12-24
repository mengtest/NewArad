﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WalkState : BaseState
{
    public WalkState(Actor actor) : base(actor, EActionState.Walk)
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
}