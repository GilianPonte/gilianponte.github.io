---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---


Working papers: 

1. _Removed title to facilitate review process_ (under review at JMR); Gilian Ponte, Jaap Wieringa, Tom Boot & Peter Verhoef.
2. Consumers' Perceptions of Privacy Risk (data collection); Gilian Ponte, Tom Boot, Thomas Reutterer, Jaap Wieringa.
3. Causal Private Neural Networks (data collection); Gilian Ponte, Tom Boot, Thomas Reutterer, Jaap Wieringa.  

For now [here](https://github.com/GilianPonte/gilianponte.github.io/blob/master/files/RM_thesis_Gilian.pdf) is my research master thesis.

{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
