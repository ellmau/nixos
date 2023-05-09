module Main where

import Data.Ratio
import XMonad hiding ((|||))
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Util.EZConfig
import Network.HostName (getHostName)
-- Imports for Polybar --
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D
import           XMonad.Hooks.DynamicLog

main :: IO ()
main' :: D.Client -> IO ()
main = mkDbusClient >>= main'

main' dbus = do
  hostname <- io $ getHostName
  xmonad . docks . ewmhFullscreen . ewmh $ def
    { terminal = "alacritty"
      , logHook = polybarLogHook dbus
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

polybarHook :: D.Client -> PP
polybarHook dbus =
  let wrapper c s | s /= "NSP" = wrap ("%{F" <> c <> "} ") " %{F-}" s
                  | otherwise  = mempty
      blue   = "#2E9AFE"
      gray   = "#7F7F7F"
      orange = "#ea4300"
      purple = "#9058c7"
      red    = "#722222"
  in  def { ppOutput          = dbusOutput dbus
          , ppCurrent         = wrapper blue
          , ppVisible         = wrapper gray
          , ppUrgent          = wrapper orange
          , ppHidden          = wrapper gray
          , ppHiddenNoWindows = wrapper red
          , ppTitle           = shorten 100 . wrapper purple
          }

fadeHook :: Rational -> Rational -> X ()
fadeHook act inact = fadeOutLogHook $ fadeAllBut exceptions act inact
  where exceptions = isFullscreen
                   <||> className =? "firefox"
                   <||> className =? "Chromium-browser"

fadeAllBut :: Query Bool -> Rational -> Rational -> Query Rational
fadeAllBut qry amt inact = do isInactive <- isUnfocused
                              isQry <- qry
                              if isQry
                                then return 1
                                else if isInactive
                                     then return inact
                                     else return amt

polybarLogHook dbus = fadeHook 0.95 0.75 <+> dynamicLogWithPP (polybarHook dbus)