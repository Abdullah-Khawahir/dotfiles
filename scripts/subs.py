import requests
import re
from html.parser import HTMLParser

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

parser = TableParser()
lang = 'arabic'
def search_url(name):
    return f"https://api.subdl.net/auto?query={name}"

def subs_link(link):
    return f"https://subdl.com{link}/{lang}"

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

def main():
        try:
            movie_name = input("Enter movie/show name: ")
            results = fetch_subtitles(movie_name)
            display_results(results)
            if not results: return

            subs_choice = int(input("Select the movie/show : "))
            choice_link =subs_link(results[subs_choice]['link'])
            sub_page = requests.get(choice_link).text
            parser.feed(sub_page)
            print()
            for i, row in enumerate(parser.table_data):
             print(f'{i}\n', end='')
             for col in row:
                 print(col, end="")
             print()
             print('='*80)


            download_urls =re.findall(r"https://dl.subdl.com/subtitle/\d+-\d+", sub_page)
            # for i, url in enumerate(download_urls):
            #     print(f"{i} - {url}")
            download_choice = int(input("Select number > "))

            file_stream= requests.get(download_urls[download_choice], stream=True)
            if file_stream.status_code == 200:
                filename =file_stream.headers['content-disposition'].split("=")[-1]
                with open(filename, 'wb') as file:
                    for chunk in file_stream.iter_content(chunk_size=8192):
                        file.write(chunk)
                    print(f'{filename} is downloaded')

        except KeyboardInterrupt:
            pass
        except ValueError:
            print("Please enter a valid number.")
        except Exception as e:
            print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()
