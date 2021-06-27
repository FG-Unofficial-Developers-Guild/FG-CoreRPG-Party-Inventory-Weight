-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function calculateItemWeight(node_parcel_items)
	local number_weight_total = 0
	for _,node_party_item in pairs(node_parcel_items.getChildren()) do
		local number_item_count = DB.getValue(node_party_item, 'count', 0)
		local number_item_weight = DB.getValue(node_party_item, 'weight', 0)
		number_weight_total = number_weight_total + (number_item_count * number_item_weight) 
	end
	return number_weight_total
end

function calculateCoinWeight(node_parcel_coins)
	local number_coins_total = 0
	if CoinsWeight and CoinsWeight.aDenominations then
		for _,node_party_coin in pairs(node_parcel_coins.getChildren()) do
			local string_coin_description = DB.getValue(node_party_coin, 'description', ''):lower()
			if CoinsWeight.aDenominations[string_coin_description] then
				number_coins_total = number_coins_total + DB.getValue(node_party_coin, 'amount', 0) * CoinsWeight.aDenominations[string_coin_description]['nWeight']
			else
				number_coins_total = number_coins_total + DB.getValue(node_party_coin, 'amount', 0) * CoinsWeight.nDefaultCoinWeight
			end
		end
	end
	return number_coins_total
end

local function determineRounding(nTotalWeight)
	if nTotalWeight >= 100 then
		return 0
	elseif nTotalWeight >= 10 then
		return 1
	else
		return 2
	end 
end

function round(number)
	local n = 10^(determineRounding(number) or 0)
	number = number * n
	if number >= 0 then number = math.floor(number + 0.5) else number = math.ceil(number - 0.5) end
	return number / n
end