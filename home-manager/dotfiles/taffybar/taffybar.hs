{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Memory
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Generic.PollingLabel
import System.Taffybar.Widget.Util
import System.Taffybar.Widget.Workspaces

transparent = (0.0, 0.0, 0.0, 0.0)
yellow1 = (0.9453125, 0.63671875, 0.2109375, 1.0)
yellow2 = (0.9921875, 0.796875, 0.32421875, 1.0)
green1 = (0, 1, 0, 1)
green2 = (1, 0, 1, 0.5)
taffyBlue = (0.129, 0.588, 0.953, 1)

myGraphConfig =
  defaultGraphConfig
  { graphPadding = 0
  , graphBorderWidth = 0
  , graphWidth = 75
  , graphBackgroundColor = transparent
  }

netCfg = myGraphConfig
  { graphDataColors = [yellow1, yellow2]
  , graphLabel = Just "net"
  }

memCfg = myGraphConfig
  { graphDataColors = [taffyBlue]
  , graphLabel = Just "mem"
  }

cpuCfg = myGraphConfig
  { graphDataColors = [green1, green2]
  , graphLabel = Just "cpu"
  }

memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  let myWorkspacesConfig =
        defaultWorkspacesConfig
        { minIcons = 0
        , widgetGap = 0
        , showWorkspaceFn = hideEmpty
        , getWindowIconPixbuf = scaledWindowIconPixbufGetter getWindowIconPixbufFromEWMH
        }
      workspaces = workspacesNew myWorkspacesConfig
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      mem = pollingGraphNew memCfg 1 memCallback
      net = networkGraphNew netCfg Nothing
      clock = textClockNew Nothing "  %a %b %_d %H:%M:%S" 1
      layout = layoutNew defaultLayoutConfig
      windows = windowsNew defaultWindowsConfig
      tray = sniTrayNew
      myConfig = defaultSimpleTaffyConfig
        { startWidgets =
            workspaces : map (>>= buildContentsBox) [ layout, windows ]
        , endWidgets = map (>>= buildContentsBox)
          [ clock
          , cpu
          , mem
          , net
          , textBatteryNew "Batt: $percentage$% $status$ $time$"
          , tray
          ]
        , barPosition = Top
        , barPadding = 1
        , barHeight = 40 
        , widgetSpacing = 0
        --, monitorsAction = usePrimaryMonitor -- This doesn't actually pick the right display at Taffybar 3.1.2
        }
  dyreTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $
    toTaffyConfig myConfig