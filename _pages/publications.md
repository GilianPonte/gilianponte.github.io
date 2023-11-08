---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---


Working papers: 

1. _Under review_ (now under review at JMR); Gilian Ponte, Jaap Wieringa, Tom Boot & Peter C. Verhoef.

To protect individuals’ privacy, the General Data Protection Regulation requires firms, researchers, and policy makers to minimize data collection. In contrast, we find that a larger sample size enables a reduction in customers' privacy risk while maintaining the ability to derive meaningful insights. We call this a “Where’s Waldo” effect.

2. Consumers' Perceptions of Privacy Risk (data collection); Gilian Ponte, Tom Boot, Thomas Reutterer, Jaap Wieringa.

In this study, we examine the relationship between objective privacy risk, as defined by differential privacy, and subjective privacy concerns perceived by consumers. To address this issue, we develop and test a randomized response (RR) design as a solution to reduce response bias while also preserving customers' privacy through satisfying a level of differential privacy.

3. Causal Private Neural Networks (data collection); Gilian Ponte, Tom Boot, Thomas Reutterer, Jaap Wieringa. 

In this project, we develop neural networks that directly predict the incremental effect of a targeting action (i.e., conditional average treatment effect) while protecting subject's privacy mathematically. 

For now [here](https://github.com/GilianPonte/gilianponte.github.io/blob/master/files/RM_thesis_Gilian.pdf) is my research master thesis.

{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

{% for post in site.publications reversed %}
  {% include archive-single.html %}
{% endfor %}
