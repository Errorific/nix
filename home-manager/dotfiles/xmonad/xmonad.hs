import XMonad
import XMonad.Config.Desktop
import System.Taffybar.Support.PagerHints (pagerHints)

main = xmonad desktopConfig
    { terminal    = "urxvt"
    , modMask     = mod4Mask
    }