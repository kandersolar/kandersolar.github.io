.. post:: Dec 25, 2021
   :tags: electrical-engineering, python

LED I-V Curves
--------------

I thought it would be fun to do some quick-and-dirty measurements of the
I-V characteristic of some LEDs I had laying around.  I have no idea where
they came from, but one is red and one is white.

Fun fact: white LEDs, which of course would require many junctions of varying
bandgap to produce white light directly, are often implemented by coating a
blue LED in a phosphor that downconverts some photons into the rest of the
visible spectrum.

Ideally I would make something like the `IV_Swinger <https://github.com/csatt/IV_Swinger>`_
to automate the measurements, but I just moved and I'm not sure where any of my
microcontrollers are right now, so I did it old school and entered data by hand.
The horror!

I connected my benchtop power supply to the LED in series with a 1k resistor.
My multimeter tells me the 1k resistor is actually 993 ohms.
I prefer measuring voltage to current where possible, so I opted to measure
voltage across the resistor and use Ohm's law to find the current through the
LED.

Here are the results:

Red LED
=======

.. ipython:: python

    import matplotlib.pyplot as plt
    V = [1.3094, 1.5546, 1.6256, 1.639, 1.661, 1.676, 1.661, 1.68, 1.678, 1.69, 1.664, 1.692, 1.704, 1.688, 1.689, 1.709]
    I = [0.0, 0.0002, 0.0006, 0.0011, 0.0015, 0.002, 0.0022, 0.0027, 0.0031, 0.0036, 0.0041, 0.0046, 0.0055, 0.0061, 0.0067, 0.0073]
    plt.scatter(V, I)
    plt.xlabel('Voltage [V]')
    plt.ylabel('Current [A]')
    plt.title('Red LED')
    @savefig red-led-iv.png width=6in
    plt.show()
    @suppress
    plt.close();

White LED
=========

.. ipython:: python

    import matplotlib.pyplot as plt
    V = [2.359, 2.462, 2.53, 2.55, 2.635, 2.656, 2.676, 2.721, 2.731, 2.788, 2.805, 2.826, 2.867, 2.926, 2.94, 3.01]
    I = [0.0, 0.0, 0.0002, 0.0004, 0.0005, 0.001, 0.0015, 0.0022, 0.0029, 0.0036, 0.0048, 0.0061, 0.0073, 0.009, 0.011, 0.0141]
    plt.scatter(V, I)
    plt.xlabel('Voltage [V]')
    plt.ylabel('Current [A]')
    plt.title('White LED')
    @savefig white-led-iv.png width=6in
    plt.show()
    @suppress
    plt.close();
