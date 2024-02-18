
&НаКлиенте
Процедура КомандаАвторизовация(Команда)
	КомандаАвторизовацияНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаАвторизовацияНаСервере()
	Если Не ЗначениеЗаполнено(СокрЛП(Объект.Email)) Тогда
		Сообщить("Заполните Email!");
		Возврат;
	КонецЕсли;
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.ВыполнитьАвторизацию();
КонецПроцедуры
