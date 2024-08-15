--
--	Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals onValueChanged

function onValueChanged()
	if super and super.onValueChanged then
		super.onValueChanged()
	end

	local nMax = window.maxweight.getValue() or 0
	if nMax > 0 then
		local nTotal = window.totalweight.getValue() or 0
		local nPercentDmg = nTotal / nMax * 100
		if nPercentDmg >= 100 then
			window.totalweight.setColor(ColorManager.getUIColor("health_wounds_critical")) -- red
		elseif nPercentDmg >= 50 then
			window.totalweight.setColor(ColorManager.getUIColor("health_wounds_heavy")) -- orange
		else
			window.totalweight.setColor(ColorManager.getUIColor("usage_full")) -- black
		end
	else
		window.totalweight.setColor(ColorManager.getUIColor("usage_full")) -- black
	end
end

function onInit()
	if super and super.onInit then
		super.onInit()
	end

	onValueChanged()
end
