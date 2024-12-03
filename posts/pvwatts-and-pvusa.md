---
blogpost: true
date: Feb 1, 2020
tags: photovoltaics, math
---

# PVWatts and PVUSA

I read a paper recently that turned on a lightbulb about why the 
PVUSA/ASTM E2848-13 equation is defined the way it is.  To quote the paper [^1]:

    The PVUSA method is based on the simplified assumptions that array current
    is primarily dependent on irradiance and that array voltage is primarily
    dependent on array temperature, which, in turn is dependent on irradiance,
    ambient temperature, and wind speed.

The concept of modeling power by modeling current and voltage separately
(other than IV-curve modeling, of course) is
obvious in hindsight but had never occurred to me before... so let's have some fun
and try it out!

Start with the fact that PV modules have known electrical characteristics at
standard test conditions.  Assuming that module output power is only a function 
of POA irradiance ($G$) and cell temperature ($T$), that means we know
the value of the 2-D functions 
$I(G, T)$ and $V(G, T)$ at one point:

$$
    I(G_{stc}, T_{stc}) = I_{stc}
$$ 

$$
    V(G_{stc}, T_{stc}) = V_{stc}
$$

That's nice, but operating conditions are often pretty different from STC.  Let's
take a first-order Taylor expansion as a starting approximation for points away from STC.
Let's define some new variables for convenience:

$$
    \gamma_I \equiv \frac{\partial I}{\partial T} \bigg\rvert_{(G_{stc}, T_{stc})}
    \quad\quad\quad
    \beta_I \equiv \frac{\partial I}{\partial G} \bigg\rvert_{(G_{stc}, T_{stc})}
$$

$$
    \gamma_V \equiv \frac{\partial V}{\partial T} \bigg\rvert_{(G_{stc}, T_{stc})}
    \quad\quad\quad
    \beta_V \equiv \frac{\partial V}{\partial G} \bigg\rvert_{(G_{stc}, T_{stc})}
$$

So our Taylor expansions are:

$$
    I(G, T) \approx I_{stc} + \gamma_I (T - T_{stc}) + \beta_I (G - G_{stc})
$$

$$
    V(G, T) \approx V_{stc} + \gamma_V (T - T_{stc}) + \beta_V (G - G_{stc})
$$

First let's take a look at current.  Experience tells us that PV current is only very
slightly dependent on temperature, so let's assume that $\gamma_I = 0$.  We also know
that PV modules produce zero current at zero irradiance:

$$
    I(0, T) = 0 \rightarrow \beta_I = I_{stc} / G_{stc}
$$

$$
    I(G, T) = I_{stc} + \frac{I_{stc}}{G_{stc}} (G - G_{stc})
$$

$$
    \boxed{I(G, T) = I_{stc} \frac{G}{G_{stc}}}
$$

Simple enough -- what we've done is just a fancy way of saying "current is linear with
irradiance and independent of temperature", but a little formalism doesn't hurt. 

Now for voltage.  In theory, PV voltage depends on temperature and irradiance
*spectrum*, but not irradiance itself, so let's assume $\beta_V = 0$.
There's no clever trick we can use to calculate $\gamma_V$, but we can
define $\alpha_V \equiv \gamma_V / V_{stc}$ to simplify our math.
Instead of an absolute change like $\gamma_V$ (V/C), 
$\alpha_V$ is a percent change (%/C). $\alpha_V$ is also usually what's reported
in datasheets. 

$$
    \boxed{V(G, T) = V_{stc} [1 +  \alpha_V (T - T_{stc})]}
$$

Now let's multiply them together! $P = IV$, after all:

$$
    P(G, T) = \left ( I_{stc} \frac{G}{G_{stc}} \right ) \left ( V_{stc} [1 +  \alpha_V (T - T_{stc})] \right )
    = P_{stc} \frac{G}{G_{stc}} (1 +  \alpha_V [T - T_{stc}])
$$

This is starting to look familiar... except what's that $\alpha_V$ doing there?
Quick, let's try something out:

$$
    \gamma_P \equiv \frac{\partial P}{\partial T} \bigg\rvert_{(G_{stc}, T_{stc})}
    = V_{stc} \frac{\partial I}{\partial T} + I_{stc} \frac{\partial V}{\partial T}
    = V_{stc} \gamma_I + I_{stc} \gamma_V
    = I_{stc} \gamma_V
$$

Here we are still assuming $\gamma_I = 0$.  Now, divide both sides by $P_{stc}$:

$$
    \alpha_P \equiv \frac{\gamma_P}{P_{stc}} 
    = \frac{I_{stc} \gamma_V}{P_{stc}} 
    = \frac{\gamma_V}{V_{stc}} 
    = \alpha_V
$$

Ack!  It's our old friend PVWatts [^2]!

$$
    P(G, T) = P_{stc} \frac{G}{G_{stc}} (1 +  \alpha_P [T - T_{stc}])
$$

So the PVWatts equation is really just the first-order Taylor expansion around STC
with a couple assumptions.  How fun!

But let's take it a step further -- PVWatts isn't the only PV model in town, and didn't
we start this whole ramble by talking about the PVUSA equation?  Let's rearrange
our friend PVWatts a bit:

$$
    P(G, T) = \frac{P_{stc}}{G_{stc}} G [(1 - \alpha_P T_{stc}) + \alpha_P T]
$$

And consolidating constants $b, c$:

$$
    = G (b + c T)
$$

But hey, what is $T$ anyway?  Nobody measures cell temperature, so let's
model it with something else.  Recall the quote from [^1]:

    array temperature... is dependent on irradiance, ambient temperature, and wind speed

Fair enough!  Here's a straightforward way to represent that dependence:

$$
    T(G, T_a, v) = d G + e T_a + f v
$$

So let's plug that model into our consolidated equation, and consolidate again...
Ack!  It's our old friend the PVUSA equation! 

$$
    P(G, T_a, v) = G (a_0 + a_1 G + a_2 T_a + a_3 v)
$$

So the PVUSA equation is really
just PVWatts with a specific cell temperature formulation, how fun!  But now
that we're digging into it, isn't $T = d G + e T_a + f v$ kind of a weird
temperature model?  In other models (e.g. Faiman [^3] and Sandia [^4]), wind
speed and irradiance have some multiplicative relationship.  For instance at night
when $G = 0$, wind drops out of both models and they predict $T = T_a$, 
but $T = d G + e T_a + f v$ lets wind influence temperature separately from irradiance.
Let's try using the Faiman model instead!  For the forgetful reader, the Faiman model is:

$$
    T = T_a + \frac{G}{U_0 + U_1 v}
$$
And so our modified PVUSA equation becomes:

$$
    P = G \left (a_0 + a_1 T_a + \frac{G}{a_2 + a_3 v} \right )
$$

I humbly suggest this equation be named the KSAUSA equation.  Maybe someday I'll
test this variant against the normal PVUSA equation, but to be honest when
I've dug into PVUSA regression in the past, I've often found that the wind
speed coefficient wasn't statistically distinguishable from zero anyway...

The broader question raised here is more interesting:  should ASTM E2848-13
capacity testing adapt the PVUSA equation to use more detailed cell temperature
models instead of the simple form it currently uses?

*Edit in 2021: I answered this question at the [2021 PVSC](https://doi.org/10.1109/PVSC43889.2021.9519077).*

Summary
-------

- The PVWatts equation is just the first-order Taylor expansion of $P=IV$
  around STC with some terms assumed to be zero.
- The PVUSA equation is just the PVWatts equation combined with a particular
  form of cell temperature model. 
- The PVUSA equation can be redefined to use other cell temperature formulations,
  which may be useful for ASTM capacity testing. 

References
----------

[^1]: C. M. Whitaker et al., "Application and validation of a new PV performance
      characterization method," Conference Record of the Twenty Sixth IEEE Photovoltaic
      Specialists Conference - 1997, Anaheim, CA, USA, 1997, pp. 1253-1256.

[^2]: A. P. Dobos, "PVWatts Version 5 Manual" http://pvwatts.nrel.gov/downloads/pvwattsv5.pdf (2014).

[^3]: Faiman cell temperature model: https://pvpmc.sandia.gov/modeling-steps/2-dc-module-iv/module-temperature/faiman-module-temperature-model/

[^4]: Sandia cell temperature model: https://pvpmc.sandia.gov/modeling-steps/2-dc-module-iv/module-temperature/sandia-module-temperature-model/
