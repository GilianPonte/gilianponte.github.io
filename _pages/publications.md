---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---

Hopefully more soon!

For now (here)[https://github.com/GilianPonte/gilianponte.github.io/blob/master/files/RM_thesis_Gilian.pdf] is my research master thesis.

{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
