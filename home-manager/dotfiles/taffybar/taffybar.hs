{-# LANGUAGE OverloadedStrings #-}

module Main where

import           System.Taffybar
import           System.Taffybar.Example                         (transparent)
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

import           System.Taffybar.Widget.FreedesktopNotifications (defaultNotificationConfig,
                                                                  notifyAreaNew)
import           System.Taffybar.Widget.MPRIS2                   (mpris2New)
import           System.Taffybar.Widget.SimpleClock

import           System.Taffybar.Widget.Generic.PollingGraph

import           System.Taffybar.Information.CPU                 (cpuLoad)
import           System.Taffybar.Information.Memory
import           System.Taffybar.Widget                          (defaultWorkspacesConfig,
                                                                  networkGraphNew,
                                                                  sniTrayNew,
                                                                  textBatteryNew,
                                                                  workspacesNew)


green1 = (0, 1, 0, 1)
green2 = (1, 0, 1, 0.5)
taffyBlue = (0.129, 0.588, 0.953, 1)
yellow1 = (0.9453125, 0.63671875, 0.2109375, 1.0)
yellow2 = (0.9921875, 0.796875, 0.32421875, 1.0)

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

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (_userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main =
  let
      clock = textClockNew Nothing "<span size='large' fgcolor='white'>%a %d %b %Y %H:%M:%S UTC+10</span>" 1
      -- pager = taffyPagerNew defaultPagerConfig
      workspaces = workspacesNew defaultWorkspacesConfig
      note = notifyAreaNew defaultNotificationConfig
      -- wea = weatherNew (defaultWeatherConfig "KMSN") 10

      -- MPRIS2 FAILS WITH THIS --- RUN BINARY IN ~/.cache/taffybar TO SEE
      -- [WARNING] System.Taffybar.Widget.MPRIS2 - Failed to get MPRIS icon: "Failed to get image"
      -- [WARNING] System.Taffybar.Widget.MPRIS2 - MPRIS failure for: BusName "org.mpris.MediaPlayer2.spotify"
      -- taffybar-linux-x86_64: Couldn’t recognize the image file format for file “/nix/store/98iqj24k81k9ghxa3wzh99b50fjm0gfv-taffybar-3.2.1-data/share/ghc-8.6.4/x86_64-linux-ghc-8.6.4/taffybar-3.2.1/icons/play.svg” (3)
      -- mpris2 = mpris2New
      net = networkGraphNew netCfg Nothing
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = sniTrayNew
      batt = textBatteryNew "Batt: $percentage$% $status$ $time$"
      cfg = defaultSimpleTaffyConfig
        { barHeight = 40
        , barPosition = Top
        , widgetSpacing = 10
        , startWidgets = [ workspaces, note ]
        , endWidgets = [ clock, tray, batt, net, mem, cpu ]
        }
  in
    -- TODO: add this back in with taffybar2
    -- defaultTaffybar . handleDBusToggle $
    dyreTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $ toTaffyConfig cfg