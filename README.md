# gpt5.5

## PSSE (phasor/average-domain) vs PSCAD (transient/EMT) modeling

- **PSSE (phasor, RMS, average-domain):**
  - Assumes near-sinusoidal steady-state waveforms and tracks magnitude/angle (phasors), not instantaneous wave shape.
  - Uses larger time steps and simplified component models.
  - Best for bulk-grid studies: power flow, transient stability, contingency analysis, and planning over seconds to minutes.
  - Faster for large systems, but limited for high-frequency switching and waveform-level effects.

- **PSCAD (transient, EMT domain):**
  - Solves instantaneous voltage/current differential equations in the time domain.
  - Uses very small time steps and detailed electromagnetic component/control models.
  - Best for fast phenomena: switching transients, harmonics, converter/HVDC behavior, protection interactions, and sub-cycle events.
  - More accurate for waveform-level dynamics, but computationally heavier and typically used on smaller subsystems.

In short: **PSSE = system-wide, slower electromechanical dynamics (phasor/RMS)**, while **PSCAD = detailed, fast electromagnetic transients (instantaneous EMT)**.
