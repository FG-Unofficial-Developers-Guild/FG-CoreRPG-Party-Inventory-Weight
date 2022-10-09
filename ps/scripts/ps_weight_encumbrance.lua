--
--	Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals onValueChanged

function onValueChanged()
	if super and super.onValueChanged then super.onValueChanged() end

	local nMax = window.maxweight.getValue() or 0
	if nMax > 0 then
		local nTotal = window.totalweight.getValue() or 0
		local nPercentDmg = nTotal / nMax * 100
		if nPercentDmg >= 100 then
			window.totalweight.setColor(ColorManager.COLOR_HEALTH_CRIT_WOUNDS) -- red
		elseif nPercentDmg >= 50 then
			window.totalweight.setColor(ColorManager.COLOR_HEALTH_HVY_WOUNDS) -- orange
		else
			window.totalweight.setColor(ColorManager.COLOR_FULL) -- black
		end
	else
		window.totalweight.setColor(ColorManager.COLOR_FULL) -- black
	end
end

function onInit()
	if super and super.onInit then super.onInit() end

	onValueChanged()
end
