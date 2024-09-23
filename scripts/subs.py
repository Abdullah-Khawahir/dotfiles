import requests
import re
from html.parser import HTMLParser
class HyperRefParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
    def handle_starttag(self , tag ,attrs):
        if tag == 'a':
            for attr in attrs :
                if attr[0] == 'href':
                    self.links.append(attr[1])

class TableParser(HTMLParser):
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

lang = 'arabic'
def search_url(name):
    return f"https://api.subdl.net/auto?query={name}"

def subs_link(link):
    return f"https://subdl.com{link}/{lang}"
def by_uri(uri):
    return 'https://subdl.com' + uri

def fetch_subtitles(user_input):
    response_json = requests.get(search_url(user_input)).json()
    if "results" not in response_json or not response_json["results"]:
        print("No results found.")
        return []
    return response_json["results"]

def display_results(results):
    for i, result in enumerate(results):
        display_response = f"{i} - {result['type']}: {result['name']} ({result['year']})"
        print(display_response)

def fetch_download_links(link):
    sub_page = requests.get(subs_link(link)).text
    return re.findall(r"https://dl.subdl.com/subtitle/\d+-\d+", sub_page)

def get_tv_episodes(results):
    for i, result in enumerate(results):
        display_response = f"{i} - {result['type']}: {result['name']} ({result['year']})"
        print(display_response)
def print_table(table_data):
    for i, row in enumerate(table_data):
        print(f'{i}\n', end='')
        for col in row: print(col, end="")
        print('='*80)
def download_subs(url):
    file_stream= requests.get(url, stream=True)
    if file_stream.status_code == 200:
        filename =file_stream.headers['content-disposition'].split("=")[-1]
        with open(filename, 'wb') as file:
            for chunk in file_stream.iter_content(chunk_size=8192):
                file.write(chunk)
            print(f'{filename} is downloaded')
def main():
        try:
            movie_name = input("Enter movie/show name: ")
            results = fetch_subtitles(movie_name)
            display_results(results)
            if not results: return print('no result')

            selected = int(input("Select the movie/show : "))
            link = subs_link(results[selected]['link'])
            if results[selected]['type'] == 'movie':
                sub_page = requests.get(link).text
                parser = TableParser()
                parser.feed(sub_page)
                print()
                print_table(parser.table_data)

                download_urls =re.findall(r"https://dl.subdl.com/subtitle/\d+-\d+", sub_page)
                download_choice = int(input("Select number > "))
                download_subs(download_urls[download_choice])

            elif results[selected]['type'] == 'tv':
                seasons_page = requests.get(link).text
                parser = HyperRefParser()
                parser.feed(seasons_page)
                seasons_links = list(set(filter(lambda l: '/subtitle/' in l, parser.links)))
                for i, link in enumerate(seasons_links):
                    print(f'{i} - {link.split("/")[-1]}')

                selected_season = int(input("Select the season > "))
                season_choice = seasons_links[selected_season] + f'/{lang}'
                print(season_choice)
                season_page = requests.get(by_uri(season_choice )).text
                table_praser = TableParser()
                table_praser.feed(season_page)
                print_table(table_praser.table_data)
                href_parser = HyperRefParser()
                href_parser.feed(season_page)
                subs_links = list(dict.fromkeys([l for l in href_parser.links if '/s/info/' in l]))
                sub_link = subs_links[int(input("select the sub > "))]

                sub_page = requests.get(by_uri(sub_link)).text
                download_urls =re.findall(r"https://dl.subdl.com/subtitle/\d+-\d+", sub_page)
                download_subs(download_urls[0])
            else:
                return print('Unimplemented')

        except KeyboardInterrupt:
            pass

if __name__ == "__main__":
    main()
