---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---

Publications

0. G.R. Ponte. (2024), Differential Privacy & Marketing Analytics. _PhD Thesis._ ([link to thesis](https://research.rug.nl/en/publications/differential-privacy-amp-marketing-analytics))
1. G.R. Ponte, J. E. Wieringa, T. Boot, P.C. Verhoef. (2024), Where’s Waldo? A framework for quantifying the privacy-utility trade-off in marketing applications. _International Journal of Research in Marketing._ ([link to article](https://www.sciencedirect.com/science/article/pii/S0167811624000417?via%3Dihub)) ([link to code](https://github.com/GilianPonte/likelihood_based_privacy_attack))

Shiny apps:
0. https://gilianponte.shinyapps.io/private_targeting/

Working papers: 


{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
