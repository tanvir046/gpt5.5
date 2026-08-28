import ast
import concurrent.futures
import html
import re
import ssl
import urllib.error
import urllib.parse
import urllib.request
from html.parser import HTMLParser
from pathlib import Path


SOURCE_FILE = Path("create_resume_docx.py")
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) UniversityLinkAudit/1.0"


class LinkExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
        self.current_href = None
        self.current_text = []

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            self.current_href = dict(attrs).get("href")
            self.current_text = []

    def handle_data(self, data):
        if self.current_href:
            self.current_text.append(data)

    def handle_endtag(self, tag):
        if tag == "a" and self.current_href:
            self.links.append((self.current_href, " ".join(self.current_text).strip()))
            self.current_href = None
            self.current_text = []


def directory_candidates(content, base_url):
    parser = LinkExtractor()
    parser.feed(content)
    candidates = []
    for href, label in parser.links:
        url = urllib.parse.urljoin(base_url, href)
        searchable = f"{label} {url}".lower()
        if any(word in searchable for word in ("faculty", "people", "directory")):
            if url.startswith("http") and url not in candidates:
                candidates.append(url)
    return candidates[:5]


def load_programs():
    tree = ast.parse(SOURCE_FILE.read_text(encoding="utf-8"))
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign) and any(
            isinstance(target, ast.Name) and target.id == "programs"
            for target in node.targets
        ):
            return ast.literal_eval(node.value)
    raise RuntimeError("Could not find the programs list")


def audit(program):
    university, department, _, faculty_and_url = program
    url = faculty_and_url.rsplit("\n", 1)[-1]
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    context = ssl.create_default_context()
    try:
        with urllib.request.urlopen(request, timeout=20, context=context) as response:
            content = response.read(500_000).decode("utf-8", errors="ignore")
            title_match = re.search(r"<title[^>]*>(.*?)</title>", content, re.I | re.S)
            title = html.unescape(re.sub(r"\s+", " ", title_match.group(1))).strip() if title_match else ""
            text = re.sub(r"<[^>]+>", " ", content).lower()
            relevant = any(word in text for word in ("faculty", "people", "professor")) and any(
                word in text for word in ("food", "nutrition", "nutritional")
            )
            candidates = directory_candidates(content, response.geturl())
            return university, response.status, response.geturl(), title, relevant, "", candidates
    except (urllib.error.URLError, TimeoutError, ValueError) as error:
        status = getattr(error, "code", "ERROR")
        return university, status, url, "", False, str(error), []


def main():
    programs = load_programs()
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        results = list(executor.map(audit, programs))
    print("University\tStatus\tRelevant\tFinal URL\tTitle/Error\tDirectory candidates")
    for university, status, final_url, title, relevant, error, candidates in results:
        print(f"{university}\t{status}\t{relevant}\t{final_url}\t{title or error}\t{' | '.join(candidates)}")


if __name__ == "__main__":
    main()