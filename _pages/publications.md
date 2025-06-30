---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---
Surprise! No research talk here—I would much rather hear about your favorite band. Here are a few vinyls I keep playing, in no particular order:

- *Messy* – Olivia Dean  
- *A Deeper Understanding* – The War on Drugs  
- *Absolutely* – Dijon  
- *Two Star & the Dream Police* – Mk.gee
- *Geography* – Tom Misch
- *People Watching* - Sam Fender

Let me know if you have any recommendations!


{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
