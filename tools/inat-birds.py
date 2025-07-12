
import requests
import pandas as pd

# %%

BIRDS = 3

def get_species(place, year):

    url = "https://api.inaturalist.org/v1/observations"
    
    all_results = []
    
    for i in range(1, 10):
        #print(i)
        
        params = dict(place_id=place, taxon_id=BIRDS, user_id="kevin-anderson", year=year, per_page=200, page=i,
                      rank=['species'], term_id=22, term_value_id=24, photos='true')
        response = requests.get(url, params)
        js = response.json()
        
        these_results = js['results']
        all_results.extend(these_results)
        
        if len(all_results) == js['total_results']:
            break

    observed_species = []
    
    for record in all_results:
        taxon = record['taxon']
        order = taxon['ancestor_ids'][5]
        family = taxon['ancestor_ids'][6]
        species = taxon['id']
        species_latin_name = taxon['name']
        species_common_name = taxon['preferred_common_name']
        
        row = dict(order=order, family=family, species=species,
                   species_latin_name=species_latin_name,
                   species_common_name=species_common_name)
        observed_species.append(row)
    
    observed_species = pd.DataFrame(observed_species).drop_duplicates()
    
    return observed_species


def get_taxonomy():
    url = "https://api.inaturalist.org/v1/taxa"
    
    all_results = []
    
    for i in range(1, 10):
        #print(i)
        params = dict(taxon_id=BIRDS, rank=['order', 'family'], per_page=200, page=i)
        response = requests.get(url, params)
        js = response.json()
        
        these_results = js['results']
        all_results.extend(these_results)
        
        if len(all_results) == js['total_results']:
            break

    order_lookup = {}
    family_lookup = {}
    
    for record in all_results:
        
        if record['rank'] == 'order':
            lookup = order_lookup
        elif record['rank'] == 'family':
            lookup = family_lookup
        else:
            raise
            
        lookup[record['id']] = record['name']
    
    return order_lookup, family_lookup


# %%

order_lookup, family_lookup = get_taxonomy()

# %%

places = {
    'Florida': 21,
    'North Carolina': 30,
    'Durham County': 471,
}

species_lists = {}

for place_name, place_id in places.items():
    print(place_name)
    observed_species = get_species(place_id, 2025)
    
    observed_species['order_name'] = [order_lookup[oid] for oid in observed_species['order']]
    observed_species['family_name'] = [family_lookup[fid] for fid in observed_species['family']]
    
    out = observed_species[['order_name', 'family_name', 'species_common_name']]
    out = out.sort_values(by=list(out.columns))
    
    species_lists[place_name] = out

# %%

summary = []

for place_name, out in species_lists.items():
    
    summary.append({
        'place': place_name,
        'species': len(out),
        'families': len(out['family_name'].unique()),
        'orders': len(out['order_name'].unique())
    })

summary = pd.DataFrame(summary)
summary['score'] = summary['species'] + 2 * summary['families'] + 3 * summary['orders']

# %%

combined = pd.concat([
    out.set_index(['order_name', 'family_name', 'species_common_name']).assign(**{place: "✓"})
    for place, out in species_lists.items()
], axis=1)

# %%

out = combined.sort_index()
out = out.fillna("")

with open("inat-birds.html", "w") as f:
    
    f.write(summary.to_html(index=False))
    
    f.write("\n\n")
    
    f.write(out.to_html())
