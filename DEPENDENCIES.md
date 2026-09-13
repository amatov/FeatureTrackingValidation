# Dependencies

No specific Matlab version is recorded. `manTrack.m` uses `imshow`,
which requires Matlab's **Image Processing Toolbox**.

`manTrack.fig` is a GUIDE layout file and must be kept in the same
folder as `manTrack.m` -- launch the GUI by running `manTrack` from
Matlab.

## Missing function

`changeImage.m` and `manTrack.m` call `Gauss2D`, which is not included
in this repository; it is available in other repositories in this
account (e.g. `InstantaneousFlowTracker`).
