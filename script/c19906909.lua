local s, id=GetID()
--created by Chahine, coded by Lyris
function s.initial_effect(c)
	--Add 1 "Paintress" monster from your Deck to your hand. You can only activate 1 "The Creation of Power Portraits" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--You can banish this card from your GY, then target 5 of your banished "Power Portrait" Spells/Traps, except "The Creation of Power Portraits"; Shuffle them into your Deck, then draw 1 card.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
	Duel.SendtoHand(g, nil, REASON_EFFECT)
	Duel.ConfirmCards(1-tp, g)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc52) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck() and not c:IsCode(id)
end
function s.tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter, tp, LOCATION_REMOVED, 0, 5, nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, Duel.SelectTarget(tp, s.cfilter, tp, LOCATION_REMOVED, 0, 5, 5, nil), 1, 0, 0)
end
function s.op(e, tp, eg, ep, ev, re, r, rp)
	local g=Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect, nil, e)
	if Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)>0 and g:FilterCount(Card.IsLocation, nil, LOCATION_DECK)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp, 1, REASON_EFFECT)
	end
end
