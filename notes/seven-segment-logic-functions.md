# 7-Segment Displays

- 8 digits, 7 segments per digit
- Each digits has a single anode, which acts as a “digit enable” signal.
- Each segment has a single cathode.
- Each of the 7 cathodes is tied to its corresponding cathode across all 8 digits.

So the whole system is basically multiplexed wherein the digit `enable` signal is the switch control. When a digit is selected, its corresponding cathode signal is applied.

Digit Enables (Anodes):	`AN7` – `AN0`

Segment Enables (Cathodes):	`CA` – `CG`, `DP`

| | | | | | | | | |
|---|---|---|---|---|---|---|---|---|
Digit Enables (Anodes) | `AN7` | `AN6` | `AN5` | `AN4` | `AN3` | `AN2` | `AN1` | `AN0`
Signal ID | `M1` | `L1` | `N4` | `N2` | `N5` | `M3` | `M6` | `N6`
Segment Enables | `CA` | `CB` | `CC` | `CD` | `CE` | `CF` | `CG` | `DP`
Signal ID | `L3` | `N1` | `L5` | `L4` | `K3` | `M2` | `L6` | `M4`
