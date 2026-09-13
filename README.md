## Feature Tracking Validation

Matlab code I wrote to allow users to perform manual feature tracking.

## Quick start

This repository implements a Matlab GUI for manual feature tracking,
for comparison to automated feature detection and motion tracking
results. See [DEPENDENCIES.md](DEPENDENCIES.md) for the Image
Processing Toolbox requirement.

## Repository contents

- `manTrack.m`, `manTrack.fig` -- the manual speckle-tracking GUI
  (GUIDE-based; run `manTrack` in Matlab).
- `changeImage.m`, `deleteSpeckle.m`, `plotSpeckle.m` -- supporting
  functions used by the GUI.
- **License:** see [LICENSE](LICENSE) -- research/educational use.

## About

The purpose of this code is to enable comparison of manually tracked features to the results of automated feature detection and motion tracking; manual speckle tracking is performed via a graphical user interface (GUI) I developed.

For detailed information, see: https://www.researchgate.net/publication/388842022_Quantitative_Cell_Division_and_Migration_in_Medicine
