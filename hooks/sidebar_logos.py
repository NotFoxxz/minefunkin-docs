import re

LOGOS = {
    "Event scripts": "assets/event-logo.png",
    "Addon API": "assets/api-logo.png",
}
HEADER = re.compile(
    r'(<div class="md-nav__link md-nav__container">\s*)<a href="([^"]*)" class="md-nav__link(?: md-nav__link--active)? ?">(?:(?!</a>).)*?'
    r'<span class="md-ellipsis">\s*(%s)\s*</span>\s*</a>' % "|".join(re.escape(t) for t in LOGOS), re.S)


def on_post_page(output, page, config):
    up = "../" * page.url.count("/")

    def logo(m):
        title = m.group(3)
        box = m.group(1).replace('md-nav__container"', 'md-nav__container mf-nav-logo-box"', 1)
        return '%s<a href="%s" class="md-nav__link mf-nav-logo" title="%s"><img src="%s%s" alt="%s"></a>' % (
            box, m.group(2), title, up, LOGOS[title], title)

    return HEADER.sub(logo, output)
