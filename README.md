# ZRAM ZSTD KernelSU Module
A lightweight, clean, and non-destructive KernelSU module designed to configure the ZRAM algorithm to **`zstd`** during boot on Samsung devices, without risking data loss or requiring unsafe runtime hot-resets (`swapoff`/`swap_reset`).

## Overview
Samsung devices initialize their swap/ZRAM configurations dynamically during boot, defaulting to standard algorithms.

This module intercepts the boot sequence precisely during the **`post-fs-data`** phase—a safe time window where the `/sys/block/zram0` device controller already exists in memory, but **before** the system activates the swap space. This allows you to reconfigure the algorithm cleanly before any swap memory is actively in use.

* **Advanced Efficiency:** Forces `zstd` for superior memory efficiency and performance.
* **Reversible:** Simply disable or remove the module via the KernelSU manager to restore the default algorithm.

## Installation

> [!NOTE]
> Make sure your kernel has native support for the `zstd` ZRAM algorithm before installing the module.

1. Flash the module `.zip` file in your KernelSU manager.
2. Reboot your device.
