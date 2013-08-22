endpoint = 'http://dbpedia.org/sparql';

% This may depend on the endpoint.  If you run a test query, you'll see that the 
% URL for the downloaded query results contains something like 
% http://...&format=text%2F/tab-separated-values...
% Whatever you see specified is what needs to go below
format = 'text/tab-separated-values';

% query to retrieve per company the number of Employees and their netIncome
query = ['PREFIX dbprop: <http://dbpedia.org/property/>'...
         'PREFIX template: <http://dbpedia.org/resource/Template:>'...
         'PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>'...
         'PREFIX foaf: <http://xmlns.com/foaf/0.1/>'...
         'select * where {'...
         '  ?company dbprop:wikiPageUsesTemplate template:Infobox_company . '...
         '  ?company dbpedia-owl:numberOfEmployees ?numberOfEmployees . '...
         '  ?company dbpedia-owl:netIncome ?netIncome . '...
         '  ?company foaf:name ?name . '...
         '}'];

url_head = strcat(endpoint,'?query=');
url_query = urlencode(query);
url_tail = strcat('&format=', format);

url = strcat(url_head, url_query, url_tail);

% get the data from the endpoint
query_results = urlread(url);

% write the data to a file so that tdfread can parse it
fid = fopen('query_results.txt','w');
if fid>=0
    fprintf(fid, '%s\n', query_results)
    fclose(fid)
end

% this reads the tsv file into a struct
sparql_data = tdfread('query_results.txt')
