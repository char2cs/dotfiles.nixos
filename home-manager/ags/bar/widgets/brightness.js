import brightness from '../services/brightness.js';

const battery = await Service.import('battery')

export function Brightness () {
    if ( battery.percent == -1 )
        return null;

    return Widget.Button({
        onScrollUp: () => brightness.value += .01,
        onScrollDown: () => brightness.value -= .01,
        className: "brightness",
        child: Widget.Box({children: [
            Widget.Label({
                label: brightness.bind('value').as((v) => Math.floor(v * 100).toString().concat('%')), 
            }),
            Widget.Icon({
                icon: "brightness",                 
                css: "font-size: 15px; padding: 0px 3px;",
            }),
        ]})
    })
}
