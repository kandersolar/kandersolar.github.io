---
blogpost: true
date: Jun 17, 2021
tags: photovoltaics, math
---


# T_cell_typ_avg

This is a short note that derives the "typical average cell temperature" used in
the "Weather-Corrected Performance Ratio". The Weather-Corrected Performance Ratio
[^1] is defined as:

$$
    \mathrm{PR_{corr}} = \frac{\sum_i \mathrm{EN_{AC}}_{\_i}}
                              {\sum_i \left[ P_{\mathrm{STC}} \left( \frac{G_{\mathrm{POA}\_i}}{G_{\mathrm{STC}}}\right) \left( 1 - \frac{\delta}{100}(T_{\mathrm{cell\_typ\_avg}} - T_{\mathrm{cell}\_i})\right) \right] }
$$ 

The denominator is essentially the PVWatts DC model, except the reference
cell temperature is not $T_{\mathrm{STC}}$ but rather a "typical/average" cell
temperature.  The report has this to say about that decision:

    Correction to a cell temperature of 25°C usually results in a higher PR
    because modules more frequently operate at 45°C. Thus, while correction
    to 25°C essentially solves the problem of seasonal variations, it may
    overstate the actual performance and thus does not allow the financier
    to assess the effect of local climate on the expected performance.
    Therefore, correction to 25°C is not an acceptable method for removing
    the seasonal variability in the PR metric because it would change the PR
    value stated in the contract. 


Fair enough for back in 2013, but I wonder if this reasoning is still applicable
in 2021 (do financiers still look at PR?).  But I have several beefs with performance
ratios and they will have to wait for another day.

I've had several conversations over the years where people asked me why the
equation doesn't use 25°C, and what the significance of this magic
irradiance-weighted average cell temperature is.  I think the above snippet
explains the motivation, but here's a derivation of why it is defined the way it is.

Let's start by assuming that there is some $T^*$ such that this relation holds,
*i.e.* the two PRs are equal:

$$
    \frac{\sum_i \mathrm{EN_{AC}}_{\_i}}
         {\sum_i \left[ P_{\mathrm{STC}} \left( \frac{G_{\mathrm{POA}\_i}}{G_{\mathrm{STC}}}\right)\right] }
         =
    \frac{\sum_i \mathrm{EN_{AC}}_{\_i}}
         {\sum_i \left[ P_{\mathrm{STC}} \left( \frac{G_{\mathrm{POA}\_i}}{G_{\mathrm{STC}}}\right) \left( 1 - \frac{\delta}{100}(T^* - T_{\mathrm{cell}\_i})\right) \right] }
$$

The numerators are equal (and nonzero), so the denominators must be equal as well:

$$
    \sum_i \left[ P_{\mathrm{STC}} \left( \frac{G_{\mathrm{POA}\_i}}{G_{\mathrm{STC}}}\right)\right]
    =
    \sum_i \left[ P_{\mathrm{STC}} \left( \frac{G_{\mathrm{POA}\_i}}{G_{\mathrm{STC}}}\right) \left( 1 - \frac{\delta}{100}(T^* - T_{\mathrm{cell}\_i})\right) \right] 
$$

$P_{\mathrm{STC}}$ and $G_{\mathrm{STC}}$ are constants that can be factored out of the summations and then canceled:

$$
    \sum_i G_{\mathrm{POA}\_i}
    =
    \sum_i \left[  G_{\mathrm{POA}\_i} \left( 1 - \frac{\delta}{100}(T^* - T_{\mathrm{cell}\_i})\right) \right] 
$$

We can distribute the right-hand side and separate the sums:

$$
    \begin{split}
    \sum_i G_{\mathrm{POA}\_i}
    &=
    \sum_i \left[ G_{\mathrm{POA}\_i} \left( 1 - \frac{\delta}{100}(T^* - T_{\mathrm{cell}\_i})\right) \right] 
    \\
    &= \sum_i G_{\mathrm{POA}\_i}  - \sum_i \left[G_{\mathrm{POA}\_i} \left( \frac{\delta}{100}(T^* - T_{\mathrm{cell}\_i})\right) \right] 
    \end{split}
$$

The irradiance summations cancel, reducing to:

$$
\sum_i \left[ G_{\mathrm{POA}\_i} \left( \frac{\delta}{100}(T^* - T_{\mathrm{cell}\_i})\right) \right] = 0
$$

Assuming $\delta/100 \neq 0$, we can factor it out of the summation and cancel it, leaving:

$$
\sum_i \left[ G_{\mathrm{POA}\_i} (T^* - T_{\mathrm{cell}\_i})\right] = 0
$$

Distributing again, we find:

$$
\sum_i \left[ G_{\mathrm{POA}\_i} T^* \right] = \sum_i \left[ G_{\mathrm{POA}\_i}  T_{\mathrm{cell}\_i}\right]
$$

As $T^*$ is a constant, we can factor it out of the summation and then solve for it:

$$
T^* = \frac{ \sum_i \left[ G_{\mathrm{POA}\_i}  T_{\mathrm{cell}\_i}\right]}{\sum_i G_{\mathrm{POA}\_i}}
$$

And we are done: the right-hand expression is exactly the definition of $T_{\mathrm{cell\_typ\_avg}}$
in the technical report (Eq 5).

References
----------

[^1]: T. Dierauf et al., "Weather-Corrected Performance Ratio", NREL Technical
      Report TP-5200-57991.  April 2013.  https://doi.org/10.2172/1078057
