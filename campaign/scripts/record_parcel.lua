--
--	Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
local function updateWeight()
	local node_parcel = getDatabaseNode()
	local node_party_coins = node_parcel.getChild("coinlist")
	local node_party_items = node_parcel.getChild("itemlist")

	local number_weight = ParcelWeight.calculateItemWeight(node_party_items)
		+ ParcelWeight.calculateCoinWeight(node_party_coins)
	DB.setValue(node_parcel, "parcelweight", "number", ParcelWeight.round(number_weight))
end

local function manageHandlers(bRemove)
	if bRemove then
		DB.removeHandler("treasureparcels.*.coinlist.*", "onChildUpdate", updateWeight)
		DB.removeHandler("treasureparcels.*.coinlist", "onChildDeleted", updateWeight)

		DB.removeHandler("treasureparcels.*.itemlist.*.count", "onUpdate", updateWeight)
		DB.removeHandler("treasureparcels.*.itemlist.*.weight", "onUpdate", updateWeight)
		DB.removeHandler("treasureparcels.*.itemlist", "onChildDeleted", updateWeight)
	else
		DB.addHandler("treasureparcels.*.coinlist.*", "onChildUpdate", updateWeight)
		DB.addHandler("treasureparcels.*.coinlist", "onChildDeleted", updateWeight)

		DB.addHandler("treasureparcels.*.itemlist.*.count", "onUpdate", updateWeight)
		DB.addHandler("treasureparcels.*.itemlist.*.weight", "onUpdate", updateWeight)
		DB.addHandler("treasureparcels.*.itemlist", "onChildDeleted", updateWeight)
	end
end

function onInit()
	if super and super.onInit then
		super.onInit()
	end
	if Session.IsHost then
		manageHandlers()
	end
	updateWeight()
end

function onClose()
	if super and super.onClose then
		super.onClose()
	end
	if Session.IsHost then
		manageHandlers(true)
	end
end
