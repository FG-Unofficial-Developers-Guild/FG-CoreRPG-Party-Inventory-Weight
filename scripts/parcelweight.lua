--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals calculateItemWeight
function calculateItemWeight(node_parcel_items)
	local number_weight_total = 0
	for _, node_party_item in ipairs(DB.getChildList(node_parcel_items)) do
		local number_item_count = DB.getValue(node_party_item, 'count', 0)
		local number_item_weight = DB.getValue(node_party_item, 'weight', 0)
		number_weight_total = number_weight_total + (number_item_count * number_item_weight)
	end
	return number_weight_total
end

-- luacheck: globals calculateCoinWeight
function calculateCoinWeight(node_parcel_coins)
	local number_coins_total = 0
	if not OptionsManager.isOption('CURR', 'on') then return 0 end
	for _, node_party_coin in ipairs(DB.getChildList(node_parcel_coins)) do
		local string_coin_description = DB.getValue(node_party_coin, 'description', ''):lower()
		local tCurrencyRecord = CurrencyManager.getCurrencyRecord(string_coin_description) or {}
		if not tCurrencyRecord['nWeight'] then Debug.console('No weight found for currency: ' .. string_coin_description) end
		local nCurrencyWeight = tCurrencyRecord['nWeight'] or 0
		local nCurrencyCount = DB.getValue(node_party_coin, 'amount', 0)

		number_coins_total = number_coins_total + (nCurrencyCount * nCurrencyWeight)
	end
	return number_coins_total
end

-- luacheck: globals round
function round(number)
	local function determineRounding(nTotalWeight)
		if nTotalWeight >= 100 then
			return 0
		elseif nTotalWeight >= 10 then
			return 1
		else
			return 2
		end
	end

	local n = 10 ^ (determineRounding(number) or 0)
	number = number * n
	if number < 0 then return math.ceil(number - 0.5) / n end
	return math.floor(number + 0.5) / n
end
