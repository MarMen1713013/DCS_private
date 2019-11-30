# OP AMP configurations

Two choices are actually available:
1. transimpedance (low gain) + high voltage gain
2. transimpedance (high gain)

## First

![two_stages](/home/marco/Scrivania/DCS/Components/op_amp_config/OP_AMP_noninverting_twoStages.jpg)
$$
\left\{
\begin{align*}
V_o &= A_v*V_{in} \\
V_{in}^+ &= R_s*I_{cs} \\ 
V_{in}^- &= \frac{R_g}{R_f + R_g}*V_o
\end{align*}
\right.
$$
Setting $R_s = 1 \Omega$ we can exchange $V_{in}^+$ with $I_{cs}$, and easily solve the system.transimpedance
Or else we could see it in a __*Control fashion*__:
$$
\left\{
\begin{align*}
A_v &= \text{open loop gain} \\
\beta &= \frac{R_g}{R_f + R_g}= \text{feedback transfer function} \\
G &= R_s = \text{pre-amplifier}
\end{align*}
\right.
$$
Hence: $W_{TZ} = G \frac{A_v}{1+\beta A_v} \simeq \frac{G}{\beta} = 1+\frac{R_f}{R_g}$ is our Voltage gain.

## Second

![transimpedance](/home/marco/Scrivania/DCS/Components/op_amp_config/OP_AMP_transimpedance.jpg)
$$
\left\{
\begin{align*}
V_{in}^+ &= 0 \\
V_{in}^- &= V_{in} =V_o + R_sI_{cs} \\
V_o &= -A_vV_{in}
\end{align*}
\right.
$$
It could be solved easily or else, as before, we could see it in a __*Control fashion*__:
$$
\left\{
\begin{align*}
-A_v &= \text{open loop gain} \\
\beta &= \frac{1}{R_f}= \text{feedback transfer function}
\end{align*}
\right.
$$
Hence: $W_{TZ} = \frac{-A_v}{1-\beta A_v} = \frac{1}{\frac{1}{-A_v}+\beta}\simeq \frac{1}{\beta} = R_f$ is our Voltage gain.



