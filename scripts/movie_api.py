import subprocess
import platform
import urllib3
from urllib.parse import quote , urlencode
import argparse

def open_magnet_link(magnet_link: str):
    system_name = platform.system()
    try:
        if system_name == "Windows":
            subprocess.run(f'start {magnet_link}', shell=True,stdin=None ,stdout=None,start_new_session=True)
        elif system_name == "Darwin":  # macOS
            subprocess.run(["open", magnet_link], stdin=None ,stdout=None,start_new_session=True)
        elif system_name == "Linux":
            subprocess.run(["xdg-open", magnet_link] , stdin=None ,stdout=None,start_new_session=True)
        else:
            print(f"Unsupported OS: {system_name}")
    except Exception as e:
        print(f"Error opening magnet link: {e}")

def create_magenet(md,m):
    #NOTE: this is form the API page https://yts.mx/api:
    #To get Magnet URLs you need to construct this yourself like so:
    #   magnet:?xt=urn:btih:TORRENT_HASH&dn=Url+Encoded+Movie+Name&tr=http://track.one:1234/announce&tr=udp://track.two:80

    return f'magnet:?xt=urn:btih:{md['hash']}&dn={quote(m['title_long']+' ' +f'[{md['quality']}]' +' '+ f'[{md['type']}]')}&tr=http://track.one:1234/announce&tr=udp://track.two:80&tr=udp://open.demonii.com:1337/announce&tr=udp://tracker.openbittorrent.com:80&tr=udp://tracker.coppersurfer.tk:6969&tr=udp://glotorrents.pw:6969/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://torrent.gresille.org:80/announce&tr=udp://p4p.arenabg.com:1337&tr=udp://tracker.leechers-paradise.org:6969'

def main():
    url = 'https://yts.mx/api/v2/list_movies.json'
    params = urlencode({
        'limit':50,
        'query_term': input('searh > ')
        })
    res =urllib3.request('GET',f'{url}?{params}').json()
    movie_list = res['data']['movies'] or []
    movies = [{
        'title':m['title_english'] ,
        'year':m['year'] ,
        'rating':m['rating'],
        'genres':m['genres'],
        'downloads':[
            { 
             'url':md['url'],
             'hash':md['hash'],
             'quality':md['quality'],
             'size':md['size'],
             'magent':create_magenet(md ,m)
             } for md in m['torrents']
            ]

        } for m in movie_list]

    text_len = max(len(movie['title']) for movie in movies) + 2
    len_size = len(str(len(movies)))
    for i, m in enumerate(movies):
        sorted_genres = ' '.join(sorted(m['genres'], reverse=True))
        name_line = f"{i:<{len_size}} {m['title']:<{text_len}}\t{m['year']:<2}\t{m['rating']:>4.2f}\t{sorted_genres}"
        print(name_line)

    selection = int(input("select 0 >") or '0')
    movie = movies[selection] or exit(1)

    for i,download in enumerate(movie['downloads']):
        print(f'{i} {movie["title"]}\t{download["quality"]}\t{download["size"]}')

    selection = int(input("select 0 >") or '0')
    open_magnet_link(movie['downloads'][selection]['magent'])

if __name__ == "__main__":
    main()
