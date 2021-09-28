local s, id= GetID()
--created by UserName290, coded by Lyris
--Cesario the Twin Dragon
function s.initial_effect(c)
	--If a "Viola the Twin Dragon" or a "Sebastian the Twin Dragon" is Summoned to your field: You can Special Summon this card from your hand or GY, but banish it when it leaves the field.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--This card can be treated as a non-Tuner monster for a Synchro Summon.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(aux.AND(Card.IsFaceup, Card.IsCode), 1, nil, id+1, id+3)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
end
