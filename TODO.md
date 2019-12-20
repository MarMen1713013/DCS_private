# TODO

- [x] Dynamics of the __*sensing pin*__ on the DC/DC converter $\rightarrow$ $+/- 10 mA$ 
1. - [x] Trans-impedance gain of the amplifier: $TZ = 250 \Omega \simeq 220 \Omega$
2. - [x] low pass filter @ 1kHz $\rightarrow \tau = RC = \frac{1}{1kHz} \rightarrow C \simeq 4.7 \eta F$ 
3. - [ ] if PWM frequency is high $\rightarrow$ we can push low pass frequency up to a decade before it.
- [x] What is it sensing? $\rightarrow$ current proportional to the one on the motor ( $I = KI_c,\text{ } K \simeq 7017$ )
> needed to optimize the *GAIN* of the amplifier

- [x] Block scheme
- [ ] Observers
- [ ] Supports
1. - [x] Motor
2. - [ ] DC/DC converter
- [x] Shield
- [x] How to use the potentiometer on loading motor
- [x] How to use the 2 pins on the H-bridge to control each motor (i.e. CW & CCW or abs. value & direction)
1. ENA, ENB are for PWM
2. IN1, IN2 (motor A) & IN3, IN4 (motor B) are for direction (i.e. 1 HIGH and 2 LOW $\rightarrow$ forward , 1 LOW and 2 HIGH $\rightarrow$ backward. Same for motor B)

## Hardware and tests

1. - [ ] Try the H-bridge at max speed
2. - [ ] Try the PWM with a certain profile
3. - [ ] Test dynamics of $I_{cs}$ (Try if $R_f = 220 \Omega$ is right)
4. - [ ] Test cut frequency for the low-pass filter