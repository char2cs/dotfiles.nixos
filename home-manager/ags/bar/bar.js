const hyprland = await Service.import('hyprland');
const systemtray = await Service.import("systemtray");

import { Workspaces } from './widgets/hyprland.js';
import { Volume, Mic, Media } from './widgets/sound.js';
import { Battery } from './widgets/battery.js'
import { Network } from './widgets/network.js'
import { Brightness } from './widgets/brightness.js';
import { Clock } from './widgets/clock.js';

function ClientTitle() {
    return Widget.Label({
        class_name: "client-title",
        label: hyprland.active.client.bind("title"),
    })
}

function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        children: items,
    })
}

// layout of the bar
function Left() {
    return Widget.Box({
        spacing: 8,
        children: [
            Workspaces(),
            ClientTitle(),
        ],
    })
}

function Center() {
    return Widget.Box({
        spacing: 8,
        children: [
            Media(),
        ],
    })
}

function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 8,
        children: [
            SysTray(),
            Mic(),
            Brightness(),
            Volume(),
            Battery(),
            Network(),
            Clock(),
        ],
    })
}

export function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    })
}
