from seleniumwire import webdriver
from selenium.webdriver.common.by import By

import json

options = webdriver.EdgeOptions()
options.accept_insecure_certs = True
options.add_argument('--disable-blink-features=AutomationControlled')
# options.add_experimental_option("detach", True)
driver = webdriver.Edge(seleniumwire_options={
                        'disable_encoding': True}, options=options)


# Get coordinates of all Ontario places
link_places = "http://www.fallingrain.com/world/CA/08/a/"
lats = []
longs = []
for letter in range(65, 91):
    # Enter place list page of each letter
    code = chr(letter)
    driver.get(link_places + code)

    # Get place list table rows
    rows = driver.find_elements(by=By.TAG_NAME, value="tr")
    count = 0
    for i in range(1, len(rows)):
        row = rows[i]
        # nth-of-type is 1-based index
        pop = row.find_element(
            by=By.CSS_SELECTOR, value="td:nth-of-type(8)")

        # We only care places with population > 5000
        if int(pop.get_attribute("innerText")) < 5000:
            continue

        lat = row.find_element(
            by=By.CSS_SELECTOR, value="td:nth-of-type(5)")
        long = row.find_element(
            by=By.CSS_SELECTOR, value="td:nth-of-type(6)")
        lats.append(float(lat.get_attribute("innerText")))
        longs.append(float(long.get_attribute("innerText")))
        count += 1

    print("%d places for %s" % (count, code))

print("totally %d places" % len(lats))

# Search every place by changing default location
link_search = "https://www.homehardware.ca/en/store-locator"
places = {}
for i in range(len(lats)):
    coordinates = {
        "latitude": lats[i],
        "longitude": longs[i],
        "accuracy": 100
    }

    # Must start a new driver
    driver = webdriver.Edge(seleniumwire_options={
        'disable_encoding': True}, options=options)

    driver.execute_cdp_cmd("Emulation.setGeolocationOverride", coordinates)
    driver.get(link_search)

    # Append the results
    for request in driver.requests:
        if request.url == "https://www.homehardware.ca/_data/en/storeGeoFindFilter" and \
                request.response and \
                request.response.status_code == 200:
            stores = json.loads(request.response.body.decode())
            for store in stores:
                if store['code'] not in places and store['address']['stateOrProvince'] == 'ON':
                    places[store['code']] = {
                        'name': store['name'],
                        'addr': store['address'],
                    }
    if i % 100 == 0:
        print("%d processed" % i)

    driver.close()

# Write to file
with open("home_hardware.json", "w") as outfile:
    outfile.write(json.dumps(places))
