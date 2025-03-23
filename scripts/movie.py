import argparse
import platform
import subprocess
from urllib.parse import quote, quote_plus, urlencode

import urllib3 as u


def search_show(title_or_id: str, index: int = -1):
    show = imdb_search(
        title_or_id=title_or_id, year=None, media_type="series", index=index
    )
    if len(show) != 1:
        return []
    imdb_id = str(show[0]["imdbID"]).removeprefix("tt")
    eztv_url = f"https://eztvx.to/api/get-torrents?imdb_id={imdb_id}&limit=100&page=1"
    eztv_res = u.request("GET", eztv_url)
    eztv_result = eztv_res.json()
    torrents = [t for t in eztv_result["torrents"]]

    torrents.sort(
        key=lambda x: (int(x["season"]) * 1000) + (int(x["episode"]) * 10),
        reverse=False,
    )
    for i, t in enumerate(torrents):
        torrent_type = "PACK" if t["episode"] == "0" else "PART"
        size = "{:.2f}".format(float(t["size_bytes"]) / (1024**3))
        print(f"{i:02} [{torrent_type}] {size:6}GB {t['title']:50}")

    return torrents


def movie_search(title_or_id, index: int | None):
    url = "https://yts.mx/api/v2/list_movies.json"
    params = urlencode({"limit": 50, "query_term": title_or_id})
    res = u.request("GET", f"{url}?{params}").json()
    if not "movies" in res["data"]:
        return []
    movie_list = res["data"]["movies"]
    movies = [
        {
            "title": m["title_english"],
            "year": m["year"],
            "imdb_code": m["imdb_code"],
            "downloads": [
                {
                    "url": md["url"],
                    "hash": md["hash"],
                    "quality": md["quality"],
                    "size": md["size"],
                    "type": md["type"],
                    "magent_url": create_magenet(md, m),
                }
                for md in m["torrents"]
            ],
        }
        for m in movie_list
    ]

    if index == None:
        for i, m in enumerate(movies):
            name_line = f"{i:02} {m['title']:<50}\t{m['year']:10}\t{m['imdb_code']}"
            print(name_line)
    else:
        for i, m in enumerate([movies[index]]):
            name_line = f"{index:02} {m['title']:<50}\t{m['year']:10}\t{m['imdb_code']}"
            print(name_line)

    if index == None:
        return movies
    else:
        return [movies[index]]


def open_magnet_link(magnet_link: str):
    system_name = platform.system()
    try:
        if system_name == "Windows":
            subprocess.Popen(
                f"start {magnet_link}",
                shell=True,
                stdin=None,
                stdout=None,
                stderr=None,
                close_fds=True,
            )
        elif system_name == "Darwin":  # macOS
            subprocess.Popen(
                ["open", magnet_link],
                stdin=None,
                stdout=None,
                stderr=None,
                close_fds=True,
            )
        elif system_name == "Linux":
            subprocess.Popen(
                ["xdg-open", magnet_link],
                stdin=None,
                stderr=None,
                stdout=None,
                close_fds=True,
            )
        else:
            print(magnet_link)
    except Exception as e:
        print(f"Error opening magnet link: {e}")


def create_magenet(md, m):
    # NOTE: this is form the API page https://yts.mx/api:
    # To get Magnet URLs you need to construct this yourself like so:
    #    magnet:?xt=urn:btih:TORRENT_HASH&dn=Url+Encoded+Movie+Name&tr=http://track.one:1234/announce&tr=udp://track.two:80
    return f"magnet:?xt=urn:btih:{md['hash']}&dn={quote(m['title_long']+' ' +f'[{md['quality']}]' +' '+ f'[{md['type']}]')}&tr=http://track.one:1234/announce&tr=udp://track.two:80&tr=udp://open.demonii.com:1337/announce&tr=udp://tracker.openbittorrent.com:80&tr=udp://tracker.coppersurfer.tk:6969&tr=udp://glotorrents.pw:6969/announce&tr=udp://tracker.opentrackr.org:1337/announce&tr=udp://torrent.gresille.org:80/announce&tr=udp://p4p.arenabg.com:1337&tr=udp://tracker.leechers-paradise.org:6969"


def imdb_search(
    title_or_id: str, year: str | None, media_type: str | None, index: int = -1
):
    title = None
    id = None
    title_or_id = title_or_id.strip()
    if title_or_id.startswith("tt"):
        id = title_or_id
    else:
        title = title_or_id
    params = {
        "apikey": "7aa216ac",
        "i": id,  # A valid IMDb ID (e.g. tt1285016)
        "s": title,
        "y": year,  # year
        "type": media_type,  # ["movie", "series", "episode"]
        "r": "json",  # ["json", "xml"]
        "page": 1,  # 1-100
    }
    omdb_url = "https://www.omdbapi.com/?" + "&".join(
        [f"{p}={quote_plus(str(v))}" for p, v in params.items() if v is not None]
    )
    omdb_req = u.request("GET", omdb_url)
    response = omdb_req.json()
    # {'Response': 'False', 'Error': 'Movie not found!'}
    if response["Response"] == "False":
        return response["Error"]

    search_result = response["Search"]
    movies_display = [
        f"{i:02}\t{s['Title']:<50}\t{s['Year']:10}\t{s['imdbID']}\t{s['Type']}"
        for i, s in enumerate(search_result)
    ]

    if index == -1 or not index in range(len(movies_display)):
        print("\n".join(movies_display))
        return search_result
    else:
        print("\n".join([movies_display[int(index)]]))
        return [search_result[index]]


def main():
    parser = argparse.ArgumentParser(
        description="CLI tool to search movies and get torrents."
    )
    subparsers = parser.add_subparsers(
        dest="target", help="Specify the target: movie, tv show, or IMDb search"
    )

    imdb = subparsers.add_parser(
        "imdb", aliases=["i"], help="Search for a movie or show on IMDb"
    )
    imdb.add_argument("title", type=str, help="Title or IMDb Code of the movie/show")
    imdb.add_argument(
        "-t",
        "--type",
        choices=["movie", "series", "episode"],
        type=str,
        help="Specify the type of media to search for",
    )
    imdb.add_argument("-y", "--year", type=str, help="Specify the year of release")
    imdb.add_argument(
        "-i", "--index", type=int, help="Specify the index of the result to display"
    )
    imdb.add_argument(
        "-d",
        "--download",
        type=int,
        help="Download or print the magnet link if provided",
    )

    movie = subparsers.add_parser("movie", aliases=["m"], help="Search for a movie")
    movie.add_argument(
        "title",
        type=str,
        help="Title/IMDb Code, Actor Name/IMDb Code, or Director Name/IMDb Code",
    )
    movie.add_argument("-y", "--year", type=str, help="Specify the year of release")
    movie.add_argument(
        "-i", "--index", type=int, help="Specify the index of the result to display"
    )
    movie.add_argument(
        "-d",
        "--download",
        type=int,
        help="Download or print the magnet link if provided",
    )

    show = subparsers.add_parser("tv", aliases=["t"], help="Search for a TV show")
    show.add_argument("title", type=str, help="Title or IMDb Code of the show")
    show.add_argument(
        "-i", "--index", type=int, help="Specify the index of the result to display"
    )
    show.add_argument(
        "-p", "--page", type=int, default=1, help="Specify the page number of results"
    )
    show.add_argument(
        "-d",
        "--download",
        type=int,
        help="Download or print the magnet link if provided",
    )

    args = parser.parse_args()

    if args.target in ["movie", "m"]:
        title = (args.title,)
        year = args.year
        index = args.index
        download = args.download
        movie = movie_search(title, index=index)
        if not movie:
            print("Movie not found!")
            return

        if len(movie) == 1:
            movie = movie[0]
            print(
                "\n".join(
                    [
                        f'{i} {movie["title"]}\t{download["quality"]}\t{download["type"]}\t{download["size"]}'
                        for i, download in enumerate(movie["downloads"])
                    ]
                )
            )

        if download and movie["downloads"][download]:
            # print(movie["downloads"][download]["magent_url"])
            open_magnet_link(movie["downloads"][download]["magent_url"])

    elif args.target in ["tv", "t"]:
        title = args.title
        index = args.index
        download = args.download
        torrents = search_show(title_or_id=title, index=index)
        if download and torrents:
            # print(torrents[download]['magnet_url'])
            open_magnet_link(torrents[download]["magnet_url"])

    elif args.target in ["imdb", "i"]:
        title = args.title
        media_type = args.type
        year = args.year
        index = args.index
        download = args.download
        imdb_search(title_or_id=title, year=year, media_type=media_type, index=index)

    else:
        parser.print_help()


if __name__ == "__main__":
    main()
