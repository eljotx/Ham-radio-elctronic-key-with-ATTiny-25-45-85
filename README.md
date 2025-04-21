# Ham-radio-elctronic-key-with-ATTiny-25-45-85
Simple electronic key built on the basis of ATTiny 25/45/85 on the Bascom platform.

## Short description
The dot and dash characters are generated using the "delay" function, maintaining a 1:3 ratio of the dot and dash length. Additionally, the spaces between characters are one dot long.
The transmission speed measurement is based on a "group" of five characters of the "paris" string and ranges from 6 to 20 such strings per minute. The dash and dot durations were calculated for each speed in the range of 6-20 groups and saved in the kre[] and kro[] tables. The correct operating speed is determined by the voltage level measured on the potentiometer slider associated with the index of the kre[] and kro[] delay tables. The keyer generates two user signals: a key tone signal of approximately 800 Hz and a keying signal with active state 0.

## Schematic diagram, inputs and outputs of the key system
The circuit requires a minimum of components. Most of the capacitors can be omitted, remembering that the 800Hz tone signal on pin 3 (B.4) should be isolated for DC.

![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](/el_key2.jpg)

The inputs of the system are the voltage from the slider of the speed potentiometer (with linear characteristics) and the dot and dash signals from the manipulator. The outputs of the system are the 800 Hz tone signals and the keying signal active in state 0. Treating the keying output as an open collector system, it should be remembered that when the "key is raised" the voltage on it should not be higher than the voltage supplying the key.

## 800Hz tone generation
The ATTiny processor operates using an internal 8MHz clock. This clock and an interrupt from the T0 counter initially set to 178 are used to generate the 800Hz tone. The 8000000Hz clock is initially divided by internal dividers 2 and 64, and an interrupt from this counter overflow occurs additionally every (256-178)=78 clock cycles. This gives a total of 8000000/2/64/78 -> about 800Hz at the tone output.

## Programming the system
The key layout was coded in the original Bascom environment using an ISP programmer.

![Screenshot of a comment on a GitHub issue showing an image, added in the Markdown, of an Octocat smiling and raising a tentacle.](/fuse_bits2.jpg)

Since a factory-new processor chip has a pre-set clock divider, this division should be disabled using the so-called Fuse H bit (clock divide by 8). And this is the only requirement for preparing the processor for operation.
The attached .hex program file is a compiled version of the key circuit for use with direct programming, for example using PonyProg and an ISP interface.
The circuit has been tested using ATTiny45 and ATTiny85 processors, but it seems that due to the code size being less than 2kB it should also fit on an ATTiny25 processor.

