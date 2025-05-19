--
--	Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals onValueChanged

local function updateWeight()
	local node_party_sheet = getDatabaseNode()
	local node_party_coins = node_party_sheet.getChild('treasureparcelcoinlist')
	local node_party_items = node_party_sheet.getChild('treasureparcelitemlist')

	local number_weight = ParcelWeight.calculateItemWeight(node_party_items) + ParcelWeight.calculateCoinWeight(node_party_coins)
	DB.setValue(node_party_sheet, 'totalweight', 'number', ParcelWeight.round(number_weight))
end

local function manageHandlers(bRemove)
	if Session.IsHost then
		if bRemove then
			DB.removeHandler('partysheet.treasureparcelcoinlist.*', 'onChildUpdate', updateWeight)
			DB.removeHandler('partysheet.treasureparcelcoinlist', 'onChildDeleted', updateWeight)

			DB.removeHandler('partysheet.treasureparcelitemlist.*.count', 'onUpdate', updateWeight)
			DB.removeHandler('partysheet.treasureparcelitemlist.*.weight', 'onUpdate', updateWeight)
			DB.removeHandler('partysheet.treasureparcelitemlist', 'onChildDeleted', updateWeight)
		else
			DB.addHandler('partysheet.treasureparcelcoinlist.*', 'onChildUpdate', updateWeight)
			DB.addHandler('partysheet.treasureparcelcoinlist', 'onChildDeleted', updateWeight)

			DB.addHandler('partysheet.treasureparcelitemlist.*.count', 'onUpdate', updateWeight)
			DB.addHandler('partysheet.treasureparcelitemlist.*.weight', 'onUpdate', updateWeight)
			DB.addHandler('partysheet.treasureparcelitemlist', 'onChildDeleted', updateWeight)
		end
	end
end

function onInit()
	if super and super.onInit then
		super.onInit()
	end

	manageHandlers()

	updateWeight()
end

function onClose()
	if super and super.onClose then
		super.onClose()
	end

	manageHandlers(true)
end
