#include "include/go_form/go_form_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "go_form_plugin.h"

void GoFormPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  go_form::GoFormPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
