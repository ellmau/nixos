module Main where

import ELSS

import Data.Ratio
import XMonad hiding ((|||))
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Layout
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.StatusBar
import XMonad.Util.EZConfig
import Network.HostName (getHostName)

import qualified XMonad.StackSet as W
-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D
import           XMonad.Hooks.DynamicLog
-- Code Action Imports
import System.Exit
import XMonad.Actions.PhysicalScreens

main :: IO ()
main' :: D.Client -> IO ()
main = mkDbusClient >>= main'

layout = avoidStruts $
  (Full ||| tall ||| Mirror tall)
  where tall = Tall 1 (3/100) (1/2)

main' dbus = do
  hostname <- io $ getHostName
  xmonad . docks . ewmhFullscreen . ewmh $ def
    { terminal = "alacritty"
      , logHook = polybarLogHook dbus
      , layoutHook = layout
      , modMask = mod4Mask -- rebind mod to super key
      , keys = keyMap
      , manageHook = composeAll [ manageDocks
                                , isFullscreen --> doFullFloat
                                , placeHook $ withGaps (32, 32, 32, 32) $ smart (0.5, 0.5)
                                , manageHook def
                                ]
      }

mkDbusClient :: IO D.Client
mkDbusClient = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") opts
  return dbus
 where
  opts = [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str =
  let opath  = D.objectPath_ "/org/xmonad/Log"
      iname  = D.interfaceName_ "org.xmonad.Log"
      mname  = D.memberName_ "Update"
      signal = D.signal opath iname mname
      body   = [D.toVariant $ UTF8.decodeString str]
  in  D.emit dbus $ signal { D.signalBody = body }

keyMap c = mkKeymap c $ 
  [ ("M-<Return>"      , spawn $ XMonad.terminal c)
  , ("M-d"             , spawn "rofi -show drun")
  , ("M-<Tab>"         , spawn "rofi -show window")
  , ("M-S-q"           , kill)
  , ("M-<Space>"       , sendMessage NextLayout)
  , ("M-S-r"           , refresh)
  , ("M-j"             , windows W.focusUp)
  , ("M-k"             , windows W.focusDown)
  , ("M-S-j"           , windows W.swapUp)
  , ("M-S-k"           , windows W.swapDown)
  , ("M-;"             , viewEmptyWorkspace)
  , ("M-S-;"           , tagToEmptyWorkspace)
  , ("M-S-<Backspace>" , io exitSuccess)
  , ("M-C-r"           , broadcastMessage ReleaseResources >> restart "xmonad" True)
  , ("M-C-j"           , sendMessage Expand)
  , ("M-C-k"           , sendMessage Shrink)
  , ("M-w"             , viewScreen def 0)
  , ("M-e"             , viewScreen def 1)
  , ("M-r"             , viewScreen def 2)
  , ("M-S-w"           , sendToScreen def 0)
  , ("M-S-e"           , sendToScreen def 1)
  , ("M-S-r"           , sendToScreen def 2)
  , ("M-t"             , withFocused $ windows . W.sink)
  , ("M-C-l"           , spawn "betterlockscreen -l --show-layout -u ~/.background-image.png")
  , ("M-S-<Tab>"       , spawn keyboardtoggle)
  ] ++
  [(m ++ k, windows $ f w)
  | (w, k) <- zip (XMonad.workspaces c) (map show $ [1..9] ++ [0]),
    (m, f) <- [("M-", W.greedyView), ("M-S-", W.shift)]
  ]
  ++
  [ ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioMicMute>", spawn "pactl set-source-mute @DEFAULT_SOURCE@ toggle")
  ]
   
polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c b "NSP" = mempty
      wrapper c (Just b) s = wrap ("%{F" <> c <> "}%{B" <> b <> "}") "%{F-}%{B-}" s
      wrapper c Nothing s = wrap ("%{F" <> c <> "}") "%{F-}" s
      current   = "#859900"
      visible   = "#eee8d5"
      urgent = "#d33682"
      highlighted = "#fdf6e3"
      title = "#657b83"
      free    = "#93a1a1"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper highlighted $ Just current
          , ppVisible         = wrapper title Nothing
          , ppUrgent          = wrapper highlighted $ Just urgent
          , ppHidden          = wrapper free Nothing
          , ppHiddenNoWindows = mempty
          , ppTitle           = wrapper title Nothing . shorten 60
          }

fadeHook :: Rational -> Rational -> X ()
fadeHook act inact = fadeOutLogHook $ fadeAllBut exceptions act inact
  where exceptions = isFullscreen
                   <||> className =? "firefox"
                   <||> className =? "Chromium-browser"
                   <||> className =? "Emacs"

fadeAllBut :: Query Bool -> Rational -> Rational -> Query Rational
fadeAllBut qry amt inact = do isInactive <- isUnfocused
                              isQry <- qry
                              if isQry
                                then return 1
                                else if isInactive
                                     then return inact
                                     else return amt

polybarLogHook dbus = fadeHook 0.95 0.75 <+> dynamicLogWithPP (polybarHook dbus)
