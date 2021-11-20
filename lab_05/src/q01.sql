\copy (SELECT ROW_TO_JSON(c) FROM cashcollector c) to 'data/cashcollector.json'
\copy (SELECT ROW_TO_JSON(r) FROM requests r) to 'data/requests.json'
\copy (SELECT ROW_TO_JSON(o) FROM objects o) to 'data/objects.json'
\copy (SELECT ROW_TO_JSON(l) FROM legalentity l) to 'data/legalentity.json'