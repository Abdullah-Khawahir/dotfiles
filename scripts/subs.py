"""
HTMLParser for parsing raw html strings.
re is the Python standard library regex.
requests is a 3rd party HTTP client.
"""
from html.parser import HTMLParser
import re
import requests
class HyperRefParser(HTMLParser):
    """
    Parser for extracting the hrefs from a tages like "<a href ..."
    """
    def __init__(self):
        super().__init__()
        self.links = []
    def handle_starttag(self , tag ,attrs):
        if tag == 'a':
            for attr in attrs :
                if attr[0] == 'href':
                    self.links.append(attr[1])
class TableParser(HTMLParser):
    """
    Parses all the tables from an html to table_data as List of Lists
    """
    def __init__(self):
        super().__init__()
        self.in_table = False
        self.in_row = False
        self.in_cell = False
        self.current_row = []
        self.table_data = []

    def handle_starttag(self, tag, attrs):
        if tag == 'table':
            self.in_table = True
        elif tag == 'tr' and self.in_table:
            self.in_row = True
            self.current_row = []
        elif tag == 'td' and self.in_row:
            self.in_cell = True

    def handle_endtag(self, tag):
        if tag == 'table':
            self.in_table = False
        elif tag == 'tr':
            self.in_row = False
            if self.current_row:
                self.table_data.append(self.current_row)
        elif tag == 'td':
            self.in_cell = False

    def handle_data(self, data):
        if self.in_cell:
            self.current_row.append(data+'\n')

LANG = 'arabic'

def search_url(name):
    """
    build a full url for by a search name
    """
    return f"https://api.subdl.net/auto?query={name}"

def subs_link(link):
    """
    build the subtitles from the `link` response of search_url function
    """
    return f"https://subdl.com{link}/{LANG}"

def by_uri(uri):
    """
    appneds the uri to the host name
    """
    return 'https://subdl.com' + uri

def fetch_subtitles(user_input):
    """
    fetches the movie/show subtitles pages by search name
    """
    response_json = requests.get(search_url(user_input),timeout=30).json()
    if "results" not in response_json or not response_json["results"]:
        print("No results found.")
        return []
    return response_json["results"]

def display_results(results):
    """
    to print the results came from `fetch_subtitles`
    """
    for i, result in enumerate(results):
        display_response = f"{i} - {result['type']}: {result['name']} ({result['year']})"
        print(display_response)

def get_tv_episodes(results):
    """
    this is for the tv `type` result to get the episodes or seasions however it
    is presented from the API
    """
    for i, result in enumerate(results):
        display_response = f"{i} - {result['type']}: {result['name']} ({result['year']})"
        print(display_response)

def print_table(table_data):
    """
    prints a table which is created by TableParser class
    """
    for i, row in enumerate(table_data):
        print(f'{i}\n', end='')
        for col in row:
            print(col, end="")
        print('='*80)

def download_subs(url):
    """
    download a file from the provided url and save it in CWD
    """
    file_stream= requests.get(url, stream=True,timeout=30)
    if file_stream.status_code == 200:
        filename =file_stream.headers['content-disposition'].split("=")[-1]
        with open(filename, 'wb') as file:
            for chunk in file_stream.iter_content(chunk_size=8192):
                file.write(chunk)
            print(f'{filename} is downloaded')

def main():
    """
    here the program asks for the show/movie `name` via input. After that the
    program will fetch for the rquested input from an API then the choice will
    be from a list of tv/movies. then if it movie the user will choose which
    file he wants or if it a tv show the user will choose a season or
    whatever is provided by the api
    """
    try:
        results = fetch_subtitles(input("Enter movie/show name: "))
        display_results(results)
        if not results:
            return

        selected = int(input("Select the movie/show : "))
        link = subs_link(results[selected]['link'])
        if results[selected]['type'] == 'movie':
            sub_page = requests.get(link,timeout=30).text
            parser = TableParser()
            parser.feed(sub_page)
            print()
            print_table(parser.table_data)

            download_urls =re.findall(r"https://dl.subdl.com/subtitle/\d+-\d+", sub_page)
            download_subs(download_urls[int(input("Select number > "))])

        elif results[selected]['type'] == 'tv':
            seasons_page = requests.get(link,timeout=30).text
            parser = HyperRefParser()
            parser.feed(seasons_page)
            seasons_links = list(set(filter(lambda l: '/subtitle/' in l, parser.links)))
            for i, link in enumerate(seasons_links):
                print(f'{i} - {link.split("/")[-1]}')

            season_choice = seasons_links[int(input("Select the season > "))] + f'/{LANG}'
            season_page = requests.get(by_uri(season_choice ),timeout=30).text
            table_praser = TableParser()
            table_praser.feed(season_page)
            print_table(table_praser.table_data)
            href_parser = HyperRefParser()
            href_parser.feed(season_page)
            subs_links = list(dict.fromkeys([l for l in href_parser.links if '/s/info/' in l]))
            sub_link = subs_links[int(input("select the sub > "))]

            sub_page = requests.get(by_uri(sub_link),timeout=30).text
            download_urls =re.findall(r"https://dl.subdl.com/subtitle/\d+-\d+", sub_page)
            download_subs(download_urls[0])
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    main()
