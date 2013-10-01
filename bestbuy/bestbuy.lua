--
-- Check specific product in store pick up availability at nearby BestBuy stores.
--
-- sku: Product SKU number.
-- zipcode: Your zip code.
-- api: BBYOPEN API key  ( If you don't have, register one from https://remix.mashery.com/member/register )
-- mile: Default 50 miles; Location must be within 50 miles of a Best Buy store.
--

local sku = '1755302'
local zipcode = '12345'
local api = 'PleaseReplaceMeWithYourOwnAPIKey'
local mile = '50'

local underscore = require 'underscore'

local response = http.request {
	url = 'http://api.remix.bestbuy.com/v1/stores(area(' .. zipcode .. ',' .. mile .. '))+products(sku=' .. sku .. ')?format=json&apiKey=' .. api .. ''
}

local data = json.parse(response.content)

if #data.stores > 0 then
	local store = underscore.detect(data.stores,
		function(store)
			local product = underscore.detect(store.products,
				function(product)
				if product.inStoreAvailability == true then
					log('SKU ' .. sku .. ' that you are tracking is available at ' .. store.name .. '.')
					alert.email('SKU ' .. sku .. ' that you are tracking is available at ' .. store.name .. '.')
				else
					log('SKU ' .. sku .. ' is not available at any Best Buy location in your area.')
				end
			end)
		end)
	end