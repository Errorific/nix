import qualified Data.Map                         as M
import           Data.Monoid                      ((<>))

import qualified Graphics.X11.Types               as XT
import           XMonad                           (Layout, ManageHook, Window,
                                                   X, XConfig (..), def,
                                                   mod4Mask, spawn, windows,
                                                   xmonad, (.|.), (|||))
import           XMonad.Actions.SpawnOn           (manageSpawn, spawnOn)
import           XMonad.Hooks.EwmhDesktops        (ewmh, fullscreenEventHook)
import           XMonad.Hooks.ManageDocks         (avoidStruts, docks,
                                                   manageDocks)
import           XMonad.Hooks.ManageHelpers       (doFullFloat, isFullscreen)
import           XMonad.Layout.NoBorders          (smartBorders)
import           XMonad.Layout.ThreeColumns       (ThreeCol (ThreeCol, ThreeColMid))
import           XMonad.ManageHook                (appName, className,
                                                   composeAll, doShift, (-->),
                                                   (<+>), (=?))
import qualified XMonad.StackSet                  as W
import           XMonad.Util.Scratchpad           (scratchpadSpawnAction, scratchpadManageHook)

import           System.Taffybar.Support.PagerHints (pagerHints)

-- docks: add dock (panel) functionality to your configuration
-- ewmh: https://en.wikipedia.org/wiki/Extended_Window_Manager_Hints - lets XMonad talk to panels
-- pagerHints: add support for Taffybar's current layout and workspaces hints
main :: IO ()
main = xmonad . docks . ewmh . pagerHints $ def
  {
    borderWidth = 3
  , handleEventHook = handleEventHook def <+> fullscreenEventHook
  , keys = myKeys
  , layoutHook = myLayoutHook
    -- let XMonad manage docks (taffybar)
  , manageHook = myManageHook 
                 <+> manageDocks 
                 <+> scratchpadManageHook (W.RationalRect 0 0 1 0.3)
                 <+> manageHook def
  , terminal = "urxvt"
  , workspaces = myWorkspaces
  , modMask = mod4Mask
  }

-- Find keys using `xev -event keyboard` and look for the `keysym`.
-- If `xev` doesn't give you the event, try `xmodmap -pk | grep <foo>`
myKeys :: XConfig Layout -> M.Map (XT.ButtonMask, XT.KeySym) (X ())
myKeys conf@XConfig {modMask = modm} = (M.fromList []) <> keys def conf

myWorkspaces :: [String]
myWorkspaces =
  [ "1"
  , "2"
  , "3"
  , "4"
  , "5"
  , "6"
  , "7"
  , "8"
  , "9"
  ]

-- Class name can be found with `xprop | grep WM_CLASS`
myManageHook :: ManageHook
myManageHook =
  composeAll [ isFullscreen --> doFullFloat
             ]

-- avoidStruts tells windows to avoid the "strut" where docks live
myLayoutHook = smartBorders $ avoidStruts $ layoutHook def ||| ThreeColMid 1 (3/100) (1/2)