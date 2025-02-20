"""
HTMLParser for parsing raw html strings.
re is the Python standard library regex.
requests is a 3rd party HTTP client.
"""
from html.parser import HTMLParser
import os
import re
import requests
import urllib.parse
from bs4 import BeautifulSoup
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
class TableParser():
    """
    Extracts filename and download link from li elements.
    """
    def __init__(self):
        super().__init__()
    def feed(self,html):
        bs = BeautifulSoup(html,'html.parser')
        titles = [e.text for e in bs.select('li div a h4')] 
        links =  [e['href'] for e in bs.select('li div a') if 'https://dl.subdl.com/subtitle' in e['href']]
        self.results = [{'title':t, 'link':l} for t,l  in zip(titles,links)]
    def print(self):
        current_dir = [os.path.splitext(file)[0] for file in os.listdir()]
        for i , res in enumerate(self.results):
            print(f"{i:>2} {'*' if res['title'] in current_dir else ' '} {res['title']}")

LANG = 'arabic'

def search_url(name):
    """
    build a full url for by a search name
    """
    return f"https://api3.subdl.com/auto?query={urllib.parse.quote(name)}"

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
    response_json = requests.get(search_url(user_input),timeout=10).json()
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
    print(table_data)
    for i, row in enumerate(table_data):
        print(f'{i}\n', end='')
        for col in row:
            print(col, end="")
        print('='*80)

def download_subs(url):
    """
    download a file from the provided url and save it in CWD
    """
    file_stream= requests.get(url, stream=True,timeout=10)
    if file_stream.status_code == 200:
        filename =file_stream.headers['content-disposition'].split("=")[-1].replace("UTF-8\'\'", "")
        filename = urllib.parse.unquote(filename)
        with open(filename, 'wb') as file:
            for chunk in file_stream.iter_content(chunk_size=8192):
                file.write(chunk)
            print(f'{filename} is downloaded')

def guess_name(text=None):
    """
    checks the CWD for any movie name hints 
    """
    if text is None:
        text = os.getcwd()
    movie_name = text.split('/')[-1].split(' (')[0]
    return movie_name

def main():
    """
    The program asks the user for the name of a show or movie, fetches the
    requested information from an API, and presents the user with a list of TV
    shows or movies to choose from. The user can then select a specific file for a
    movie or a season for a TV show.
    """
    try:
        gueesed_name = guess_name()
        search_name = input(f"Enter movie/show name ({gueesed_name}): ") or gueesed_name
        results = fetch_subtitles(search_name)
        display_results(results)
        if not results:
            return

        selected = int(input("Select the movie/show (0) : ") or 0)
        link = subs_link(results[selected]['link'])
        if results[selected]['type'] == 'movie':
            sub_page = requests.get(link,timeout=30).text
            parser = TableParser()
            parser.feed(sub_page)
            print()
            parser.print()

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
            season_page = requests.get(by_uri(season_choice ),timeout=10).text
            table_praser = TableParser()
            table_praser.feed(season_page)
            table_praser.print()
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
