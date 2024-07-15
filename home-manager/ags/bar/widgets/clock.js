export function Clock() {
    const time = Variable("", {
        poll: [1000, 'date "+%H:%M"'],
    })

    const date = Variable("", {
        poll: [1000, 'date "+%e %B %y %H:%M"'],
    })

    return Widget.Button({
        on_clicked: () => App.toggleWindow("quicksettings"),
        label: date.bind(),
    })
}