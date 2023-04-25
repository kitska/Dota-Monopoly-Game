button = $.CreatePanel("Button", $("#general"), "button"); /* создаем нашу кнопку с id = button в нашей general панели */
button.AddClass("button"); /* добавляем класс button нашей кнопке */
/*создаем функцию которая будет выводить сообщение в консоль */
function clickfunc() {
    $.Msg("my custom button was clicked");
}
button.SetPanelEvent("onactivate", function() { /*почему-то консоль у меня ругается, если я сюда вставляю наш скрипт, но можно закостылять, как я и сделал */
    clickfunc();
}); /* подписываемся, что при нажатии на эту кнопку должен выполнится clickfunc() */