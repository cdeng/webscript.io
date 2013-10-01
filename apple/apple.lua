--
-- Check specific product in store pick up availability at nearby Apple stores.
--
-- model: Apple product model number. e.g. ME307LL/A 16GB AT&T iPhone Gold
-- zipcode: Your zip code.
--

local model = 'ME307LL/A'
local zipcode = '12345'

local underscore = require 'underscore'

local response = http.request {
	url = 'http://store.apple.com/us/retail/availabilitySearch?parts.0=' .. model .. '&zip=' .. zipcode .. ''
}

local data = json.parse(response.content)

local store = underscore.detect(data.body.stores,
	function(store)
		if store['partsAvailability']['ME307LL/A']['storeSelectionEnabled'] == true then
			log('The product that you are tracking is now available at ' .. store.storeName .. '.')
			alert.email('The product that you are tracking is now available at ' .. store.storeName .. '.')
        else
            log('Model # ' .. sku .. ' is not available at ' .. store.storeName .. '.')
		end
	end)