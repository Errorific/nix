{-# LANGUAGE OverloadedStrings #-}

module Main where

import           System.Taffybar
import           System.Taffybar.Hooks                           (withBatteryRefresh,
                                                                  withLogServer,
                                                                  withToggleServer)
import           System.Taffybar.SimpleConfig                    (Position (Top),
                                                                  barHeight,
                                                                  barPosition,
                                                                  defaultSimpleTaffyConfig,
                                                                  endWidgets,
                                                                  startWidgets,
                                                                  toTaffyConfig,
                                                                  widgetSpacing)

import           System.Taffybar.Widget.SimpleClock

import           System.Taffybar.Widget                          (defaultWorkspacesConfig,
                                                                  sniTrayNew,
                                                                  textBatteryNew,
                                                                  workspacesNew,
                                                                  layoutNew,
                                                                  defaultLayoutConfig,
                                                                  windowsNew,
                                                                  defaultWindowsConfig,
                                                                  buildContentsBox)

main =
  let
      clock = textClockNew Nothing "<span size='large' fgcolor='white'>%a %d %b %Y %H:%M:%S</span>" 1
      workspaces = workspacesNew defaultWorkspacesConfig
      layout = layoutNew defaultLayoutConfig
      windows = windowsNew defaultWindowsConfig
      tray = sniTrayNew
      batt = textBatteryNew "Batt: $percentage$% $status$ $time$"
      cfg = defaultSimpleTaffyConfig
        { barHeight = 40
        , barPosition = Top
        , widgetSpacing = 10
        , startWidgets = workspaces : map (>>= buildContentsBox) [ layout, windows ]
        , endWidgets = [ clock, tray, batt ]
        }
  in
    dyreTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $ toTaffyConfig cfg