#!/usr/bin/env bash
sleep 1
kill -e xdg-desktop-portal-hyprland
kill -e xdg-desktop-portal-wlr
kill xdg-desktop-portal
xdg-desktop-portal-hyprland &
sleep 2
xdg-desktop-portal &
