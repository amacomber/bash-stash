# bash-stash

# 11.07.2021
I just created the best place to stash my bash (code, that is).

## Overview
**bash-stash** is a collection of macOS management scripts designed as reusable building blocks for IT automation—installing apps, running Jamf actions, and cleaning up systems.

## Repository Structure
- **Actions/** – Operational scripts that toggle or configure system behavior.
- **App-Installers/** – Bash-based installers for third-party macOS software, usually branching for Apple Silicon vs. Intel.
- **OS-Installers/** – Jamf-friendly upgrade workflows that guide users and orchestrate `startosinstall` for specific macOS versions.
- **Jamf/** – Jamf-specific tooling, including Extension Attributes that emit `<result>` values and UI/automation helpers.
- **Uninstallers/** – Scripts that reverse installations and remove supporting files or services.
- **AutoPkg-Server-Setup/** – Utilities for setting up an AutoPkg host with cleanup tasks.
- **git_hosted_app_version_numbers/** – Helpers that query upstream release APIs (e.g., GitHub) for version checks.
- **Profiles/** – Ready-to-upload configuration profiles for common macOS permissions and settings.
- **in_progress/** – Experiments and drafts that may need polishing before production use.

## How Scripts Are Structured
- Predominantly standalone Bash with minimal function abstraction.
- Heavy use of macOS-native tools (`curl`, `launchctl`, `osascript`, `sysadminctl`).
- Jamf-focused scripts respect parameter positions (`$4+`), emit `<result>` for extension attributes, and often leverage JamfHelper for UI messaging.

## Getting Started
1. **Review small utilities** in `Actions/` to understand the style and side effects.
2. **Customize installers** in `App-Installers/` by swapping download URLs or bundle IDs for your environment.
3. **Study upgrade workflows** in `OS-Installers/` to learn the pattern for prompting users and running `startosinstall`.
4. **Explore Jamf automation** examples in `Jamf/`, including API scripts and inventory Extension Attributes.
5. **Integrate automation** by pairing version checks (`git_hosted_app_version_numbers/`) with AutoPkg or Jamf policies.

These notes should help newcomers map the repository quickly and identify templates to reuse in their own macOS management workflows.
