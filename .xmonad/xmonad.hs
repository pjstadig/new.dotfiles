import XMonad
import qualified Data.Map as M
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Xfce
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.NoBorders
import XMonad.Hooks.FadeInactive

main = xmonad $ xfceConfig
                { manageHook = manageDocks <+> manageHook xfceConfig
                , logHook    = ewmhDesktopsLogHook
                , layoutHook = avoidStruts $ smartBorders (layoutHook xfceConfig)
                , handleEventHook = ewmhDesktopsEventHook
                , startupHook = ewmhDesktopsStartup
                , modMask    = mod4Mask
                , focusFollowsMouse = False
                }
                `additionalKeysP` [("M-e", spawn "raise-or-run emacs /usr/bin/emacs")
                                   , ("M-c", spawn "raise-or-run conkeror conkeror")
                                   , ("M-p", spawn "dmenu_run")
                                   , ("M-S-<Return>", spawn "raise-or-run terminal x-terminal-emulator")
                                   , ("M-z", spawn "swarp 10000 10000")
                                   , ("M-s", spawn "wmctrl -s 1; skyyy")
                                   , ("M-<F2>", spawn "gnome-panel-control --run-dialog")]
