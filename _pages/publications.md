---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---

<br>
[Generative adversarial networks in marketing:
Overcoming privacy issues with the generation of
artificial data](https://gilianponte.nl/publications/RM%20thesis%20Gilian.pdf)

<i><b>Gilian Ponte</b></i>.<br>
<b>Supervisor: Jaap Wieringa</b>
<i>Research Master Thesis - Rijksuniversiteit Groningen</i>.
<br>

{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
