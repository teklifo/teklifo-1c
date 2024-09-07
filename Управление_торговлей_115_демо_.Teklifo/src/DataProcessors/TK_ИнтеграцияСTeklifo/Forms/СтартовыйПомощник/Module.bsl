#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГиперссылкаНаСтраницуУстановкиПароляНажатие(Элемент)

	ЗапуститьПриложениеАсинх("https://teklifo.com/ru/settings");

КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаСайтTeklifoНажатие(Элемент)

	ЗапуститьПриложениеАсинх("https://teklifo.com");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиПользователяВTeklifo(Команда)

	Если Не ЗначениеЗаполнено(СокрЛП(Объект.АдресЭлектроннойПочты)) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите адрес вашей электронной почты.'"), ,
			"АдресЭлектроннойПочты", "Объект");
		Возврат;
	КонецЕсли;

	ПолучитьCSRFТокенНаСервере();

	Если Не ЗначениеЗаполнено(Объект.ТокенCSRF) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
			"ru = 'Не удалось подключиться к сервису Teklifo. Проверьте соединение с сетью.'"));
		Возврат;
	КонецЕсли;

	Если ПользовательУжеЗарегистрированНаTeklifo() Тогда
		ПерейтиКСтарницеВводаПароля();
	Иначе
		Если ЗарегистрироватьНовогоПользователя() Тогда
			ПерейтиКСтраницеУведомленияОПисьме();
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр(
			"ru = 'Не удалось зарегистрировать нового пользователя Teklifo. Проверьте соединение с сетью.'"));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВводуПароля(Команда)

	ПерейтиКСтарницеВводаПароля();

КонецПроцедуры

&НаКлиенте
Процедура АвторизоватьПользователя(Команда)

	РезультатАвторизации = АвторизоватьПользователяНаСервере();

	Если РезультатАвторизации Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Авторизация прошла успешно'"), , , БиблиотекаКартинок.Успешно32);
		СохранитьУчетнуюЗаписьИнтеграцииСTeklifo();
		ЗагрузитьОрганизацииУчетнойЗаписи();
		Если ТаблицаОрганизаций.Количество() = 0 Тогда
			ПредложитьСоздатьНовуюОрганизациюНаTeklifo();
		КонецЕсли;
		ПерейтиКСтраницеСоответствияОрганизаций();
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Авторизация не выполнена. Проверьте правильность ввода пароля.'"), , "Пароль", "Объект");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрганизациюНаTeklifo(Команда)

	Если СоздатьОрганизациюНаTeklifoНаСервере() Тогда
		ЗагрузитьОрганизацииУчетнойЗаписи();
		ПерейтиКСтраницеСоответствияОрганизаций();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСоответствиюОрганизаций(Команда)

	ПерейтиКСтраницеСоответствияОрганизаций();

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСозданиюОрганизацииНаTeklifo(Команда)

	ПерейтиКСозданиюНовойОрганизации();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьСоответствиеОрганизаций(Команда)

	СохранитьСоответствиеОрганизацийНаСервере();

	ПоказатьОповещениеПользователя(НСтр("ru = 'Данные успешно сохранены'"), , , БиблиотекаКартинок.Успешно32);

	ПредложитьСоздатьЗапросЦенПоставщикам();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПереходПоСтраницам

&НаКлиенте
Процедура ПерейтиКСтраницеУведомленияОПисьме()

	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаУведомлениеОПисьме;
	Элементы.ПерейтиКВводуПароля.КнопкаПоУмолчанию = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтарницеВводаПароля()

	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВводПароля;
	Элементы.АвторизоватьПользователя.КнопкаПоУмолчанию = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСтраницеСоответствияОрганизаций()

	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСоответствиеОрганизаций;
	Элементы.КомандаСохранитьДанные.КнопкаПоУмолчанию = Истина;

КонецПроцедуры

&НаСервере
Процедура ПерейтиКСтранцеСозданияНовойОрганизации()

	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСозданиеОрганизации;
	Элементы.СоздатьОрганизациюНаTeklifo.КнопкаПоУмолчанию = Истина;

КонецПроцедуры

#КонецОбласти

#Область Авторизация

&НаСервере
Процедура ПолучитьCSRFТокенНаСервере()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.ПолучитьCSRFТокен();
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");

КонецПроцедуры

&НаСервере
Функция ПользовательУжеЗарегистрированНаTeklifo()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектОбработки.НайтиПользователяНаTeklifo() <> Неопределено;

КонецФункции

&НаСервере
Функция ЗарегистрироватьНовогоПользователя()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектОбработки.ЗарегистрироватьНовогоПользователя();

КонецФункции

&НаСервере
Функция АвторизоватьПользователяНаСервере()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	Результат = ОбъектОбработки.АвторизоватьПользователя();
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");

	Возврат Результат;

КонецФункции

&НаСервере
Процедура СохранитьУчетнуюЗаписьИнтеграцииСTeklifo()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.СохранитьУчетнуюЗаписьИнтеграцииСTeklifo();
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");

КонецПроцедуры

#КонецОбласти

#Область СозданиеОрганизаций

&НаКлиенте
Асинх Процедура ПредложитьСоздатьНовуюОрганизациюНаTeklifo()

	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Да'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Пропустить'"));

	Результат = Ждать ВопросАсинх(НСтр("ru = 'Вы пока еще не состоите ни в одной организации на Teklifo. Создать новую организацию в Teklifo на основании организации из 1С?'"), СписокКнопок, ,
			КодВозвратаДиалога.Да);
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПерейтиКСозданиюНовойОрганизации();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОрганизацииУчетнойЗаписи()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ЗначениеВРеквизитФормы(ОбъектОбработки.ТаблицаОрганизацийУчетнойЗаписи(), "ТаблицаОрганизаций");

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСозданиюНовойОрганизации()

	ВыбраннаяОрганизация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");

	ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Организации");
	Оповещение = Новый ОписаниеОповещения("ПерейтиКСозданиюНовойОрганизацииЗавершение", ЭтотОбъект);

	ПоказатьВводЗначения(Оповещение, ВыбраннаяОрганизация, "Введите значение", ОписаниеТипов);

КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСозданиюНовойОрганизацииЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	Если ВыбранноеЗначение <> Неопределено Тогда
		ЗаполнитьДанныеНовойОрганизации(ВыбранноеЗначение);
		ПерейтиКСтранцеСозданияНовойОрганизации();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеНовойОрганизации(ВыбраннаяОрганизация)

	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВыбраннаяОрганизация, "Наименование, ИНН");

	НаименованиеОрганизации = РеквизитыОрганизации.Наименование;
	ИНН = РеквизитыОрганизации.ИНН;

    КонтактныеДанныеОрганизации = TK_ОбщегоНазначенияВызовСервера.ПолучитьТелефонИEmailОрганизации(ВыбраннаяОрганизация);
    
    НомерТелефонаОрганизации = КонтактныеДанныеОрганизации.НомерТелефона;
    EmailОрганизации         = КонтактныеДанныеОрганизации.Email; 
КонецПроцедуры

&НаСервере
Функция СоздатьОрганизациюНаTeklifoНаСервере()

    

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");

	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("id", ИдентификаторОрганизации);
	СтруктураДанных.Вставить("name", НаименованиеОрганизации);
	СтруктураДанных.Вставить("tin", ИНН);
	СтруктураДанных.Вставить("email ", EmailОрганизации);
	СтруктураДанных.Вставить("phone", НомерТелефонаОрганизации);
	СтруктураДанных.Вставить("website", "");
	СтруктураДанных.Вставить("description", Описание);
	СтруктураДанных.Вставить("descriptionRu", ОписаниеНаРусском);
	СтруктураДанных.Вставить("slogan", Слоган);
	СтруктураДанных.Вставить("sloganRu", СлоганНаРускком);

	РезультатСоздания = ОбъектОбработки.СоздатьОрганизациюНаTeklifo(СтруктураДанных);

	Если РезультатСоздания.Свойство("errors") Тогда
		Для Каждого СтруктураОшибки Из РезультатСоздания.errors Цикл
			ОбщегоНазначения.СообщитьПользователю(СтруктураОшибки.message);
		КонецЦикла;
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции

&НаСервере
Процедура СохранитьСоответствиеОрганизацийНаСервере()

	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.СохранитьСоответствиеОрганизаций(РеквизитФормыВЗначение("ТаблицаОрганизаций"));

КонецПроцедуры

&НаКлиенте
Асинх Процедура ПредложитьСоздатьЗапросЦенПоставщикам()

	Если ТаблицаОрганизаций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Да'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Не сейчас'"));

	Результат = Ждать ВопросАсинх(НСтр("ru = 'Все этапы настройки успешно пройдены. Хотите перейти к созданию запроса цен у поставщиков?'"), СписокКнопок, ,
			КодВозвратаДиалога.Да);

	Если Результат = КодВозвратаДиалога.Да Тогда
		ОткрытьДокументЗапросаЦенПоставщикам();
	Иначе
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументЗапросаЦенПоставщикам()

	ОткрытьФорму("Документ.TK_ЗапросЦенПоставщикам.Форма.ФормаДокумента");

КонецПроцедуры

#КонецОбласти

#КонецОбласти