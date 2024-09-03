App.addIcons(`${App.configDir}/assets`);
import { Bar } from './bar/bar.js';
import { NotificationPopups } from './notifications/notificationPopups.js';
import { setupQuickSettings } from './quicksettings/quicksettings.js';
import { applauncher } from "./widgets/applauncher.js";

setupQuickSettings();
App.config({
    windows: [
        // this is where window definitions will go
        // Bar(0),
        Bar(0),
        applauncher,
       	// NotificationPopups(0),
        NotificationPopups(0)
    ],
    style: './style.css',
})

export {}
