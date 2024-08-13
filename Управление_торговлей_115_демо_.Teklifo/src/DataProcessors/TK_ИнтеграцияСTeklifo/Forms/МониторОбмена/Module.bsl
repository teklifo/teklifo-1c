#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьКакПрочитанное(Команда)

	Для Каждого ВыделеннаяСтрока Из Элементы.Уведомления.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Уведомления.ДанныеСтроки(ВыделеннаяСтрока);
		УстановитьПометкуПрочтенияУведомления(ДанныеСтроки.Ссылка, Истина);
	КонецЦикла;

	Элементы.Уведомления.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ОтметитьКакНепрочитанное(Команда)

	Для Каждого ВыделеннаяСтрока Из Элементы.Уведомления.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Уведомления.ДанныеСтроки(ВыделеннаяСтрока);
		УстановитьПометкуПрочтенияУведомления(ДанныеСтроки.Ссылка, Ложь);
	КонецЦикла;

	Элементы.Уведомления.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура УдалитьУведомление(Команда)

	Для Каждого ВыделеннаяСтрока Из Элементы.Уведомления.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Уведомления.ДанныеСтроки(ВыделеннаяСтрока);
		УдалитьУведомлениеНаСервере(ДанныеСтроки.Ссылка);
	КонецЦикла;

	Элементы.Уведомления.Обновить();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	СписокУсловноеОформление = Уведомления.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// Непрочитанное уведомление
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Непрочитанное уведомление'");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Прочитано");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.TK_ШрифтЖирный);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПометкуПрочтенияУведомления(Уведомление, Прочитано)

	УведомлениеОбъект = Уведомление.ПолучитьОбъект();
	УведомлениеОбъект.Прочитано = Прочитано;
	УведомлениеОбъект.Записать();

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьУведомлениеНаСервере(Уведомление)

	УведомлениеОбъект = Уведомление.ПолучитьОбъект();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		УведомлениеОбъект.Удалить();
	Исключение
		ЗаписьЖурналаРегистрации("Удаление уведомления Teklifo", УровеньЖурналаРегистрации.Ошибка, , ,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

#КонецОбласти