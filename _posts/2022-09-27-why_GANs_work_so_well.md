---
layout: archive
title:  "Why can Generative Adversarial Networks (GANs) learn any probability distribution?"
published: true
---

In this post, I will aim to provide intuition for the proof of $p_{G} \stackrel{\text { plim. }}{\longrightarrow} p_{\text{data}}$ from Goodfellow et al. (2014). We want to be clear about our contribution to the proof, we only aim to provide more intuition for marketing scholars. Recall that we define $p_{G}$ as the distribution of the random variable $G$ and that $p_{\text{data}}$ is the dgp or real distribution. In the situation of $p_{G} \stackrel{\text { plim. }}{\longrightarrow} p_{\text{data}}$, the distribution of the generator is equal in distribution to the dgp. 

Goodfellow et al. (2014) take the value function $V(D,G)$ from Equation 1 in their paper and use the following equality:

$$ \mathbb{E}_{\boldsymbol{z} \sim p_{Z}(\boldsymbol{z})} \log (1-D(G(\boldsymbol{z}))) = \mathbb{E}_{\boldsymbol{x} \sim p_{G}(\boldsymbol{x})} \log(1-D(\boldsymbol{x})).$$

At first glance, one could argue that the equality comes from a neural network $G$ that applies a transformation with a unique set of parameters such that $G(\boldsymbol{z})$ leads to samples of $\boldsymbol{x}$. Subsequently, we could assume that an inverse function $G^{-1}$ of $G$ exists to go from $\boldsymbol{x}$ back to samples of $\boldsymbol{z}$. However, in practice a neural network need not be an invertible function, and thus, the inverse function $G^{-1}$ is not unique.

We posit that the equality is a result from a Radon-Nikodym derivative from the Radon-Nikodym Theorem. We can use the Radon-Nikodym derivative to switch between the probability measures $z$ and $g$, In the Equation above, the Radon-Nikodym theorem tells us that there exists a Radon-Nikodym derivative to arrive at


$$ V(D, G) := \mathbb{E}_{\boldsymbol{x} \sim p_{\text{data}}} (\log(D(\boldsymbol{z})) + \mathbb{E}_{\boldsymbol{z} \sim p_{Z}} (\log(1-D(G(\boldsymbol{z}))) $$

$$ = \int_{\boldsymbol{x}} p_{\text {data}}(\boldsymbol{x}) \log D(\boldsymbol{x}) \mathrm{d} x+\int_{z} p(\boldsymbol{z}) \log (1-D(G(\boldsymbol{z}))) \mathrm{d}z $$

$$ = \int_{\boldsymbol{x}} p_{\text {data}}(\boldsymbol{x}) \log D(\boldsymbol{x})+p_{G}(\boldsymbol{x}) \log (1-D(\boldsymbol{x})) \mathrm{d}x.\\$$

Subsequently, recall that the goal of the discriminator $D$ is to maximize Equation \ref{eq:8} (see Equation \ref{eq:1}). If $G$ is given, we can rewrite Equation \ref{eq:8} as $f(y)=a \log y+b \log (1-y)$. To find the maximum of a discriminator $D$ given a generator $G$, we take a first order derivative of $f(y)$ and set it equal to zero:

$$ f^{\prime}(y) = 0 \Rightarrow \frac{a}{y}+\frac{b}{1-y} = 0 \Rightarrow \frac{-a+a y-b y}{y(y-1)}=0 \Rightarrow -a+a y-b y= 0 \Rightarrow
y(a-b)-a=0 \Rightarrow y=\frac{a}{a-b}.$$

We can determine whether this is a maximum with $f^{\prime\prime}(y)$:

$$ f^{\prime\prime}(y) = 0 \Rightarrow -\frac{a}{y^{2}}-\frac{b}{(1-y)^{2}} = 0 \Rightarrow -\frac{a}{(\frac{a}{a-b})^{2}}-\frac{b}{(1-\frac{a}{a-b})^{2}} < 0. $$

Thus, we can conclude that $\frac{a}{a+b}$ is indeed a maximum (i.e., $f^{\prime\prime}(y) < 0$). \cite{goodfellow_2014} provide further evidence that the maximum $\frac{a}{a+b}$ must be a unique maximum on the domain given $a,b \in (0,1)$ and $a + b \neq 0$. Therefore, we find that the optimal discriminator given $G$ is

$$ D^{*}_{G}(\boldsymbol{x}) = \frac{p_{\text{data}}(\boldsymbol{x})}{p_{\text{data}}(\boldsymbol{x})+p_{G}(\boldsymbol{x})} \text{ and } 1 - D^{*}_{G}(\boldsymbol{\boldsymbol{x}}) = \frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x}) + p_{\text{data}}(\boldsymbol{x})}.$$

\cite{goodfellow_2014} explain that with the definition of an optimal discriminator, we can reformulate the value function from Equation \ref{eq:8} and define a virtual training criteria for the generator $C(G)$:

$$ C(G) = \max_{D}V(D^{*}_{G},G) $$

$$ = \mathbb{E}_{\boldsymbol{x} \sim p_{\text {data}}}(\log \frac{p_{\text{data}}(\boldsymbol{x})}{p_{\text {data}}(\boldsymbol{x})+p_{G}(\boldsymbol{x})})+\mathbb{E}_{\boldsymbol{x} \sim p_{G}}(\log \frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x}) + p_{\text{data}}(\boldsymbol{x})}).$$

Now that we have the optimal discriminator $D$ for a given generator $G$, we must find a global minimum of $G$. \cite{goodfellow_2014} claim that the global minimum of $C(G)$ is achieved iff $p_{G} = p_{\text{data}}$. In the first direction, given that $p_{\text{data}} = p_{G}$, we arrive at the optimal discriminator that is unable to distinguish real from artificial samples:

$$ D^{*}_{G}(\boldsymbol{x})=\frac{1}{2} \text{ and } 1 - D^{*}_{G}(\boldsymbol{x}) = \frac{1}{2}.$$

This represents the scenario where the discriminator is unable to distinguish between samples from $p_{\text{data}}$ and $p_{G}$. Subsequently, \cite{goodfellow_2014} plug the optimal discriminator $D^{*}_{G}(\boldsymbol{x})$ back into the value function from Equation \ref{eq:8} to obtain a candidate value for a global minimum:

$$ C(G) := \mathbb{E}_{\boldsymbol{x} \sim p_{\text {data }}}\left(\log D_{G}^{*}(\boldsymbol{x})\right)+\mathbb{E}_{\boldsymbol{x} \sim p_{g}}\left(\log \left(1-D_{G}^{*}(\boldsymbol{x})\right)\right)$$

$$ =\int_{\boldsymbol{x}} p_{\text {data}}(\boldsymbol{x}) \log (\frac{1}{2})+p_{G}(\boldsymbol{x}) \log (\frac{1}{2}) \mathrm{d}x.$$

Subsequently, we can integrate over the entire domain of both $p_{\text{data}}(\boldsymbol{x})$ and $p_{G}(\boldsymbol{x})$ with respect to $x$. The integrals of both pdfs are by definition equal to one such that

$$ =\log \frac{1}{2} + \log \frac{1}{2}$$

$$ =- \log 4. $$

The value $-\log 4$ is a candidate value for the global minimum. Next, we want to prove that this is a unique minimum for the generator. Therefore, we drop the assumption $p_{G} = p_{\text{data}}$ for now and observe that for any $G$, we can plug in $D^{*}_{G}$ into the equation where the discriminator achieves its maximum:


$$ C(G) = \mathbb{E}_{\boldsymbol{x} \sim p_{\text{data}}}(\log \frac{p_{\text{data}}(\boldsymbol{x})}{p_{\text{data}}(\boldsymbol{x})+p_{G}(\boldsymbol{x})})+\mathbb{E}_{\boldsymbol{x} \sim p_{G}}(\log \frac{p_{G}(\boldsymbol{x})}{{p_{G}}(\boldsymbol{x})+p_{\text{data}}(\boldsymbol{x})}) $$

$$ =\int_{\boldsymbol{x}} p_{\text {data}}(\boldsymbol{x}) \log(\frac{p_{\text{data}}(\boldsymbol{x})}{p_{\text{data}}(\boldsymbol{x})+p_{G}(\boldsymbol{x})}) + p_{G}(\boldsymbol{x})(\log \frac{p_{G}(\boldsymbol{x})}{{p_{G}}(\boldsymbol{x})+p_{\text{data}}(\boldsymbol{x})})\mathrm{d}x.$$

Subsequently, we use a trick to add and subtract $\log 2$ and multiply with a probability distribution in Equation \ref{eq:15}, which is equal to adding zero to both integrals:

$$ C(G) =\int_{\boldsymbol{x}}\textcolor{blue}{(\log 2-\log 2) p_{\text {data}}(\boldsymbol{x})+}p_{\text{data}}(\boldsymbol{x})\log\left(\frac{p_{\text{data}}(\boldsymbol{x})}{p_{\text{data}}(\boldsymbol{x})+p_{G}(\boldsymbol{x})}\right) $$

$$ +\textcolor{blue}{(\log 2-\log 2) p_{G}(\boldsymbol{x})+}p_{G}(\boldsymbol{x}) \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) \mathrm{d} x.$$

Subsequently, we can rewrite the equation as follows:

$$ =\int_{\boldsymbol{x}}\textcolor{blue}{\log 2p_{\text {data}}(\boldsymbol{x})-\log 2p_{\text {data}}(\boldsymbol{x})+}p_{\text {data}}(\boldsymbol{x}) \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) $$

$$ +\textcolor{blue}{\log 2p_{G}(\boldsymbol{x})-\log 2p_{G}(\boldsymbol{x})+}p_{G}(\boldsymbol{x}) \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) \mathrm{d} x $$

$$ =\int_{\boldsymbol{x}}\textcolor{blue}{-\log 2p_{\text {data}}(\boldsymbol{x})-\log 2p_{G}(\boldsymbol{x})+}p_{\text {data}}(\boldsymbol{x}) \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) $$

$$ +\textcolor{blue}{\log 2p_{\text {data}}(\boldsymbol{x}) +\log 2p_{G}(\boldsymbol{x})+}p_{G}(\boldsymbol{x}) \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) \mathrm{d} x $$

$$ =\int_{\boldsymbol{x}}\textcolor{blue}{-\log 2(p_{\text {data}}(\boldsymbol{x})+ p_{G}(\boldsymbol{x})) +}p_{\text {data}}(\boldsymbol{x}) \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) $$

$$ +\textcolor{blue}{\log 2p_{\text {data}}(\boldsymbol{x}) +\log 2p_{G}(\boldsymbol{x})+}p_{G}(\boldsymbol{x}) \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) \mathrm{d} x $$

Eventually, we can integrate $\textcolor{blue}{p_{\text {data}}(\boldsymbol{x})+ p_{G}(\boldsymbol{x})}$ over $x$ and use linearity of the integral to rewrite as

$$ ={-\log 4} + \int_{\boldsymbol{x}}p_{\text {data}}(\boldsymbol{x}) \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) $$

$$ +{\log 2p_{\text {data}}(\boldsymbol{x}) +\log 2p_{G}(\boldsymbol{x})+}p_{G}(\boldsymbol{x}) \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) \mathrm{d} x$$

$$ ={-\log 4} + \int_{\boldsymbol{x}} {\log2p_{\text {data}}(\boldsymbol{x})} + p_{\text {data}}(\boldsymbol{x}) \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) $$

$$ +{\log 2p_{G}(\boldsymbol{x})+}p_{G}(\boldsymbol{x}) \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right) \mathrm{d} x $$

$$ ={-\log 4} + \int_{\boldsymbol{x}} {p_{\text {data}}(\boldsymbol{x})( \log2} + \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right)) $$

$$ +p_{G}(\boldsymbol{x})({\log 2+}\log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right)) \mathrm{d} x$$

Now, we can use the logarithmic product rule for $\log2 + \log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right)$ and $\log2 + \log \left(\frac{p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right)$ to arrive at the following:

$$ ={-\log 4} + \int_{\boldsymbol{x}} p_{\text {data}}(\boldsymbol{x})(\log \left(\frac{2p_{\text {data}}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right)) $$

$$ +p_{G}(\boldsymbol{x})(\log \left(\frac{2p_{G}(\boldsymbol{x})}{p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})}\right)) \mathrm{d} x$$

$$ ={-\log 4} + \int_{\boldsymbol{x}} p_{\text {data}}(\boldsymbol{x})(\log \left(\frac{p_{\text {data}}(\boldsymbol{x})}{(p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x}))/2}\right)) $$

$$ +p_{G}(\boldsymbol{x})(\log \left(\frac{p_{G}(\boldsymbol{x})}{(p_{G}(\boldsymbol{x})+p_{\text {data}}(\boldsymbol{x})/2}\right)) \mathrm{d} x$$

Subsequently, \cite{goodfellow_2014} largely draw from information theory and use a definition of the Kullback-Leibler and Jensen-Shannon divergence to show that $- \log 4$ is a unique global minimum. The Kullback-Leibler divergence for probability measures $P$ and $Q$ of a continuous random variable is defined as follows \citep{bishop_2016}: 

$$ \mathrm{KL}(P \| Q)= \int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{p(\boldsymbol{x})}{q(\boldsymbol{x})}\right) \mathrm{d} x.$$

Intuitively, the Kullback-Leibler divergence measures the difference between two probability distributions. We arrive at Equation 5 by following \cite{goodfellow_2014}, in which the authors apply the definition of the Kullback-Leibler divergence in Equation \ref{eq:finally} to arrive at

$$ C(G)=-\log4 + \mathrm{K L}\left(p_{\text {data }}(\boldsymbol{x}) \| \frac{p_{\text {data }}(\boldsymbol{x})+p_{G}(\boldsymbol{x})}{2}\right) + \mathrm{K L}\left(p_{G}(\boldsymbol{x}) \| \frac{p_{\text {data }}(\boldsymbol{x})+p_{G}(\boldsymbol{x})}{2}\right).$$

\cite{bishop_2016} shows that with Jensen's inequality for a convex function and random variable $X$: $\mathrm{E}(f(X)) \geqslant f(\mathrm{E}(X))$, as well as the fact that $f(x) = -\ln x$ is a strictly convex function, that the Kullback-Leibler divergence nonnegative is iff $p(\boldsymbol{x}) = q(\boldsymbol{x})$ for all $\boldsymbol{x}$. Therefore, we take the definition of the Kullback-Leibler divergence from Equation \ref{KL} and use the logarithm quotient rule $\log(\frac{z}{x}) = -\log(\frac{x}{z})$ to arrive at

$$ \mathrm{KL}(P \| Q) = -\int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x. $$

Next, we use Jensen's inequality to prove that the Kullback-Leibler divergence from Equation \ref{KLdiv} must be greater or equal to zero:

$$ \mathrm{KL}(P \| Q) = -\int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x $$

$$ = -\int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x \geqslant - \log  \left(\int_{\boldsymbol{x}} p(\boldsymbol{x})\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x $$

$$ = -\int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x \geqslant - \log\left(  \int_{\boldsymbol{x}} \frac{p(\boldsymbol{x})q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x $$

$$ = -\int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x \geqslant - \log  \left(\int_{\boldsymbol{x}} q(\boldsymbol{x})\right) \mathrm{d} x $$

$$ = -\int_{\boldsymbol{x}} p(\boldsymbol{x}) \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) \mathrm{d} x \geqslant 0 $$

Alternatively, we can use $- \log \left(\frac{q(\boldsymbol{x})}{p(\boldsymbol{x})}\right) = \log \left(\frac{p(\boldsymbol{x})}{q(\boldsymbol{x})}\right)$:

$$ = \int p(\boldsymbol{x}) \log \left(\frac{p(\boldsymbol{x})}{q(\boldsymbol{x})}\right) \mathrm{d} x \geqslant 0.$$

Finally, we use the result from Equation \ref{jensen} to show that the Kullback-Leibler divergence must be equal to or greater than zero in Equation \ref{cg}. This shows that the global minimum must be $-\log4$. Finally, \cite{goodfellow_2014} use the definition of the Jensen-Shannon divergence in Equation \ref{cg} to prove that only one $G$ is able to achieve this minimum \citep{lin1991divergence}:

$$ \operatorname{JSD}(P \| Q)=\frac{1}{2} \mathrm{KL}(P \| (P+Q)/2)+\frac{1}{2} \mathrm{KL}(Q \|(P+Q)/2).$$

If we use the definition of the Jensen-Shannon divergence for Equation \ref{cg}, where $P = p_{\text{data}}$ and $Q = p_{G}$, we obtain

$$ C(G)  =-\log4 + \mathrm{K L}\left(p_{\text {data }}(\boldsymbol{x}) \| \frac{p_{\text {data }}(\boldsymbol{x})+p_{G}(\boldsymbol{x})}{2}\right)$$

$$ + \mathrm{K L}\left(p_{G}(\boldsymbol{x}) \| \frac{p_{\text {data }}(\boldsymbol{x})+p_{G}(\boldsymbol{x})}{2}\right) $$

$$ = -\log 4 + 2 \cdot \operatorname{J S D}\left(p_{\text{data}}(\boldsymbol{x}) \| p_{G}(\boldsymbol{x})\right). $$

We show that the Kullback-Leibler divergence must be equal to or greater than zero, so we can extend this idea to the Jensen-Shannon divergence \citep{lin1991divergence}. The Jensen-Shannon divergence between two distributions is always nonnegative and zero iff $p_{G} = p_{\text{data}}$ for any value of $\boldsymbol{x}$ \citep{goodfellow_2014}. In conclusion, we show that $-\log4$ is a unique global minimum of $G$.
