'''
Print Article given a link.
'''
import sys
from newspaper import Article

# read user input
#print(sys.argv)
if len(sys.argv) > 1:
    url = str(sys.argv[1]).strip()
else:
    print("\n>> No URL given. Please provide a URL as argument.\n")
    sys.exit()

# download article
print("\n>> Downloading article...")
article = Article(url)
article.download()
print(">> Parsing HTML...")
article.parse()

# print results
print("\n>> Authors: {}\n".format(article.authors))
print(article.text)

print("\n>> END.")

# save html
save_html = r"U:\MIT\Python\downloaded_article.html"
try:
    with open(save_html, 'w') as f:
        f.write(article.html)
    print("(Saved HTML in {})\n".format(save_html))
except Exception as e:
    print("(Couldn't save HTML in {})".format(save_html))
    print("ERROR: {}".format(str(e)))
