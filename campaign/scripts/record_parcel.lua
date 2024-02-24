--
--	Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function updateWeight()
	local node_parcel = getDatabaseNode()
	local node_party_coins = node_parcel.getChild("coinlist")
	local node_party_items = node_parcel.getChild("itemlist")

	local item_weight = ParcelWeight.calculateItemWeight(node_party_items)
	local coins_weight = ParcelWeight.calculateCoinWeight(node_party_coins)
	DB.setValue(node_parcel, "parcelweight", "number", ParcelWeight.round(item_weight + coins_weight))
end

function onInit()
	if super and super.onInit then
		super.onInit()
	end
	if Session.IsHost then
		DB.addHandler("treasureparcels.*.coinlist.*", "onChildUpdate", updateWeight)
		DB.addHandler("treasureparcels.*.coinlist", "onChildDeleted", updateWeight)

		DB.addHandler("treasureparcels.*.itemlist.*.count", "onUpdate", updateWeight)
		DB.addHandler("treasureparcels.*.itemlist.*.weight", "onUpdate", updateWeight)
		DB.addHandler("treasureparcels.*.itemlist", "onChildDeleted", updateWeight)
	end
	updateWeight()
end

function onClose()
	if super and super.onClose then
		super.onClose()
	end
	if Session.IsHost then
		DB.removeHandler("treasureparcels.*.coinlist.*", "onChildUpdate", updateWeight)
		DB.removeHandler("treasureparcels.*.coinlist", "onChildDeleted", updateWeight)

		DB.removeHandler("treasureparcels.*.itemlist.*.count", "onUpdate", updateWeight)
		DB.removeHandler("treasureparcels.*.itemlist.*.weight", "onUpdate", updateWeight)
		DB.removeHandler("treasureparcels.*.itemlist", "onChildDeleted", updateWeight)
	end
end
