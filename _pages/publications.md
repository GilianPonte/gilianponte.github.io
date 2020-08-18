---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---

<br>
<b>[Generative adversarial networks in marketing:
Overcoming privacy issues with the generation of
artificial data](http://gilianponte.nl/publications/RM_thesis_Gilian.pdf)</b> <br> 
<i><b>Gilian Ponte</b></i>.<br>
<i><b>Supervisor: Jaap Wieringa</b></i>.<br>
<i>Research Master Thesis - Rijksuniversiteit Groningen</i>.
<br>

{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
