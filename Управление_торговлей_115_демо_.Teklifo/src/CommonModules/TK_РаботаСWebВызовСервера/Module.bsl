#Область ПрограммныйИнтерфейс

// Публикует запрос цен поставщикам на сервисе Teklifo.
// 
// Параметры:
//  ЗапросЦенПоставщикам  - ДокументСсылка.TK_ЗапросЦенПоставщикам
// 
// Возвращаемое значение:
//  Булево - результат публикации запроса цен поставщикам
Функция ОпубликоватьЗапросЦенПоставщикамНаTeklifo(ЗапросЦенПоставщикам) Экспорт

	ПубликацияПрошлаУспешно = Ложь;

	РеквизитыЗапросаЦенПоставщикам = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗапросЦенПоставщикам,
		"Организация, Товары");

	УчетнаяЗаписьИИдентификаторОрганизации = УчетнаяЗаписьИИдентификаторОрганизацииВTeklifo(
		РеквизитыЗапросаЦенПоставщикам.Организация);
	
	МассивНоменклатуры = РеквизитыЗапросаЦенПоставщикам.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура");

	// 1. Сначала выполняем передачу номенклатуры из табличной части товаров.
	ТокенСессии = ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, УчетнаяЗаписьИИдентификаторОрганизации);
	ОбработкаИнтеграции = Обработки.TK_ИнтеграцияСTeklifo.Создать();
	
	// 2. Выполняем публикацию непосредственного самого документа.
	ДанныеПубликации = Новый Структура;
	
	ТекущийСтатусПубликации = TK_ОбщегоНазначенияВызовСервера.СтатусПубликацииДокумента(ЗапросЦенПоставщикам);
	
	Если ТекущийСтатусПубликации = Перечисления.TK_СтатусыПубликацииЗапросовЦен.ТребуетсяОбновление Тогда
		ВнешнийID = TK_ОбщегоНазначенияВызовСервера.ПолучитьДанныеДокумента(ЗапросЦенПоставщикам).ВнешнийИдентификатор;

		ДанныеОтправки = ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам_Обновление(ЗапросЦенПоставщикам,
			ВнешнийID);
		ДанныеПубликации = ОбработкаИнтеграции.ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам_Обновление(
			ДанныеОтправки, ВнешнийID, ТокенСессии, УчетнаяЗаписьИИдентификаторОрганизации.ОрганизацияНаСайте);
	Иначе
		ДанныеОтправки = ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам(ЗапросЦенПоставщикам);

		ДанныеПубликации = ОбработкаИнтеграции.ОпубликоватьЗапросЦенПоставщикамНаTeklifo(ДанныеОтправки, ТокенСессии,
			УчетнаяЗаписьИИдентификаторОрганизации.ОрганизацияНаСайте);
	КонецЕсли;

	ПубликацияПрошлаУспешно = Ложь;

	Если ДанныеПубликации <> Неопределено Тогда
		СохранитьИдентификаторДокументаНаTeklifo(ЗапросЦенПоставщикам, ДанныеПубликации);
		СохранитьИдентификаторыСтрокДокументаНаTeklifo(ЗапросЦенПоставщикам, ДанныеПубликации.items);
		ПубликацияПрошлаУспешно = Истина;
	КонецЕсли;

	Возврат ПубликацияПрошлаУспешно;

КонецФункции

// Получить результат отправки номенклатуры.
// 
// Параметры:
//  МассивНоменклатуры - Массив Из СправочникСсылка.Номенклатура - Массив номенклатуры
//  ДанныеПоОрганизации - Структура - Данные по организации:
// * УчетнаяЗапись - СправочникСсылка.TK_УчетныеЗаписиTeklfio 
// * ИдентификаторОрганизацииTeklifo - Строка
// * Организация - СправочникСсылка.Организации
// 
// Возвращаемое значение:
//  Структура, Неопределено, Произвольный, Строка - Получить результат отправки номенклатуры
Функция ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ДанныеПоОрганизации) Экспорт

	ОбработкаИнтеграции = Обработки.TK_ИнтеграцияСTeklifo.Создать();

	ТокенСессии = ПолучитьТокенСессии(ДанныеПоОрганизации.УчетнаяЗапись);

	Результат = ОбработкаИнтеграции.ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ТокенСессии, СокрЛП(
		ДанныеПоОрганизации.ОрганизацияНаСайте));

	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		СинхронизоватьНоменклатуру(Результат, ДанныеПоОрганизации.Организация);
	КонецЕсли;

	Возврат ТокенСессии;

КонецФункции

// Получить результат получения запроса цен.
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - Организация
//  Url - Строка - Url
// 
// Возвращаемое значение:
//  Структура - Получить результат получения запроса цен:
// * Загружен - Булево 
// * Сообщение - Строка
Функция ПолучитьРезультатПолученияЗапросаЦен(Организация, Url = "") Экспорт

	ДанныеПоОрганизации = УчетнаяЗаписьИИдентификаторОрганизацииВTeklifo(Организация);

	ТокенСессии = ПолучитьТокенСессии(ДанныеПоОрганизации.УчетнаяЗапись);

	ОтветЗагрузкиДанных = Новый Структура("Загружен, Сообщение", Ложь, "");

	IdЗаказа = ПолучитьIDЗапросаИзURL(Url);

	ОбработкаИнтеграции = Обработки.TK_ИнтеграцияСTeklifo.Создать();
	Результат = ОбработкаИнтеграции.ПолучитьРезультатДокументаЗапросЦенОтКлиента(IdЗаказа, ТокенСессии,
		ДанныеПоОрганизации.ОрганизацияНаСайте);

	Если Результат.Свойство("ИдентификаторВерсии") Тогда

		РезультатПодтверждения = ОбработкаИнтеграции.ПолучитьРезультатПодтвержденияУчастия(IdЗаказа, ТокенСессии,
			ДанныеПоОрганизации.ОрганизацияНаСайте);

		Если РезультатПодтверждения.Подтвержден Тогда
			Попытка
				НачатьТранзакцию();
				РезультатЗагрузки = TK_ЗагрузкаИСозданиеДанныхСервер.ЗагрузитьДокументЗапросЦенОтКлиента(Результат,
					Организация);
				СохранитьИдентификаторДокументаНаTeklifo(РезультатЗагрузки.ДокЗапроса, РезультатЗагрузки);
				ЗафиксироватьТранзакцию();
				ОтветЗагрузкиДанных.Загружен = Истина;
				ОтветЗагрузкиДанных.Сообщение = Строка(РезультатЗагрузки.ДокЗапроса) + " успешно загружен.";
			Исключение
				ОтменитьТранзакцию();
				ОтветЗагрузкиДанных.Загружен = Ложь;
				ОтветЗагрузкиДанных.Сообщение = ОписаниеОшибки();
			КонецПопытки;
		Иначе
			ОтветЗагрузкиДанных.Загружен = Ложь;
			ОтветЗагрузкиДанных.Сообщение = РезультатПодтверждения.Сообщение;
		КонецЕсли;

	КонецЕсли;

	Возврат ОтветЗагрузкиДанных;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТокенСессии(УчетнаяЗапись)

	РеквизитыУчетнойЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, "АдресЭлектроннойПочты, Пароль");

	ОбработкаИнтеграции = Обработки.TK_ИнтеграцияСTeklifo.Создать();
	ОбработкаИнтеграции.АдресЭлектроннойПочты = РеквизитыУчетнойЗаписи.АдресЭлектроннойПочты;
	ОбработкаИнтеграции.Пароль = РеквизитыУчетнойЗаписи.Пароль;
	ОбработкаИнтеграции.ПолучитьCSRFТокен();
	ОбработкаИнтеграции.АвторизоватьПользователя();

	ТокенСессии = ОбработкаИнтеграции.АвторизоватьПользователя();

	Возврат ТокенСессии;

КонецФункции

Процедура СохранитьИдентификаторыСтрокДокументаНаTeklifo(Документ, Строки)

	Для Каждого ДанныеСтроки Из Строки Цикл
		МенеджерЗаписи = РегистрыСведений.TK_ИдентификаторыСтрокДокументовНаTeklifo.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ = Документ;
		МенеджерЗаписи.ИдентификаторСтроки = ДанныеСтроки.externalId;
		МенеджерЗаписи.ВнешнийИдентификатор = ДанныеСтроки.id;
		МенеджерЗаписи.ИдентификаторВерсии = ДанныеСтроки.versionId;
		МенеджерЗаписи.Записать();
	КонецЦикла;

КонецПроцедуры

Процедура СохранитьИдентификаторДокументаНаTeklifo(Документ, ДанныеПубликации)

	МенеджерЗаписи = РегистрыСведений.TK_ИдентификаторыДокументовНаTeklifo.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Идентификатор = ДанныеПубликации.id;
	МенеджерЗаписи.НомерДокумент = ДанныеПубликации.number;
	МенеджерЗаписи.ИдентификаторВерсии = ДанныеПубликации.versionId;
	МенеджерЗаписи.ЭтоАктуальнаяВерсия = ДанныеПубликации.latestVersion;
	МенеджерЗаписи.Записать();

КонецПроцедуры

Функция ПолучитьДанныеДокументаДокументаЗапросЦенПоставщикам(ДокЗапроса)

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_ЗапросЦенПоставщикам.Дата КАК Дата,
						  |	TK_ЗапросЦенПоставщикам.Номер КАК Номер,
						  |	TK_ЗапросЦенПоставщикам.Ссылка КАК Ссылка,
						  |	TK_ЗапросЦенПоставщикам.Организация КАК Организация,
						  |	TK_ЗапросЦенПоставщикам.Валюта КАК Валюта,
						  |	TK_ЗапросЦенПоставщикам.НачальнаяДатаСбораПредложений КАК НачальнаяДатаСбораПредложений,
						  |	TK_ЗапросЦенПоставщикам.КонечнаяДатаСбораПредложений КАК КонечнаяДатаСбораПредложений,
						  |	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.ТекстовоеОписание КАК СТРОКА(1000)) КАК ТекстовоеОписание,
						  |	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.АдресДоставки КАК СТРОКА(1000)) КАК АдресДоставки,
						  |	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.КомментарийКУсловиямДоставки КАК СТРОКА(1000)) КАК КомментарийКУсловиямДоставки,
						  |	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.КомментарийКУсловиямОплаты КАК СТРОКА(1000)) КАК КомментарийКУсловиямОплаты,
						  |	TK_ЗапросЦенПоставщикам.ТипЗапроса КАК ТипЗапроса,
						  |	TK_ЗапросЦенПоставщикамТовары.Номенклатура КАК Номенклатура,
						  |	TK_ЗапросЦенПоставщикамТовары.Количество КАК Количество,
						  |	TK_ЗапросЦенПоставщикамТовары.ЖелаемаяЦена КАК ЖелаемаяЦена,
						  |	TK_ЗапросЦенПоставщикамТовары.ДатаДоставки КАК ДатаДоставки,
						  |	TK_ЗапросЦенПоставщикамТовары.Комментарий КАК Комментарий,
						  |	TK_ЗапросЦенПоставщикамТовары.ИдентификаторСтроки КАК ИдентификаторСтроки
						  |ПОМЕСТИТЬ ТЗДок
						  |ИЗ
						  |	Документ.TK_ЗапросЦенПоставщикам.Товары КАК TK_ЗапросЦенПоставщикамТовары
						  |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.TK_ЗапросЦенПоставщикам КАК TK_ЗапросЦенПоставщикам
						  |		ПО TK_ЗапросЦенПоставщикамТовары.Ссылка = TK_ЗапросЦенПоставщикам.Ссылка
						  |ГДЕ
						  |	TK_ЗапросЦенПоставщикамТовары.Ссылка = &ДокЗапроса
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ТЗДок.Номенклатура КАК Номенклатура,
						  |	ТЗДок.Организация КАК Организация,
						  |	TK_СоответствияНоменклатуры.Идентификатор КАК Идентификатор
						  |ПОМЕСТИТЬ ТЗНом
						  |ИЗ
						  |	ТЗДок КАК ТЗДок
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_СоответствиеНоменклатурыTeklifo КАК TK_СоответствияНоменклатуры
						  |		ПО ТЗДок.Номенклатура = TK_СоответствияНоменклатуры.Номенклатура
						  |		И ТЗДок.Организация = TK_СоответствияНоменклатуры.Организация
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ТЗДок.Ссылка КАК Ссылка,
						  |	ТЗДок.ИдентификаторСтроки КАК ИдентификаторСтроки,
						  |	TK_ВнешниеИдентификаторыСтрокДокументов.Идентификатор КАК ВнешнийIDСтроки
						  |ПОМЕСТИТЬ ТЗДанныеИдентификаторовСтрок
						  |ИЗ
						  |	ТЗДок КАК ТЗДок
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_ИдентификаторыСтрокДокументовНаTeklifo КАК TK_ВнешниеИдентификаторыСтрокДокументов
						  |		ПО ТЗДок.Ссылка = TK_ВнешниеИдентификаторыСтрокДокументов.Документ
						  |		И ТЗДок.ИдентификаторСтроки = TK_ВнешниеИдентификаторыСтрокДокументов.ИдентификаторСтроки
						  |ГДЕ
						  |	(TK_ВнешниеИдентификаторыСтрокДокументов.Документ,
						  |		TK_ВнешниеИдентификаторыСтрокДокументов.ИдентификаторСтроки) В
						  |		(ВЫБРАТЬ
						  |			ТЗДок.Ссылка КАК Ссылка,
						  |			ТЗДок.ИдентификаторСтроки КАК ИдентификаторСтроки
						  |		ИЗ
						  |			ТЗДок КАК ТЗДок)
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ТЗДок.Дата КАК Дата,
						  |	ТЗДок.Номер КАК Номер,
						  |	ТЗДок.Ссылка КАК Ссылка,
						  |	ТЗДок.Организация КАК Организация,
						  |	ТЗДок.Валюта КАК Валюта,
						  |	ТЗДок.НачальнаяДатаСбораПредложений КАК НачальнаяДатаСбораПредложений,
						  |	ТЗДок.КонечнаяДатаСбораПредложений КАК КонечнаяДатаСбораПредложений,
						  |	ТЗДок.ТекстовоеОписание КАК ТекстовоеОписание,
						  |	ТЗДок.АдресДоставки КАК АдресДоставки,
						  |	ТЗДок.КомментарийКУсловиямДоставки КАК КомментарийКУсловиямДоставки,
						  |	ТЗДок.КомментарийКУсловиямОплаты КАК КомментарийКУсловиямОплаты,
						  |	ТЗДок.ТипЗапроса КАК ТипЗапроса,
						  |	ТЗДок.Номенклатура КАК Номенклатура,
						  |	ТЗДок.Количество КАК Количество,
						  |	ТЗДок.ЖелаемаяЦена КАК ЖелаемаяЦена,
						  |	ТЗДок.ДатаДоставки КАК ДатаДоставки,
						  |	ТЗДок.Комментарий КАК Комментарий,
						  |	ТЗНом.Идентификатор КАК Идентификатор,
						  |	ТЗДок.ИдентификаторСтроки КАК ИдентификаторСтроки,
						  |	ТЗДанныеИдентификаторовСтрок.ВнешнийIDСтроки КАК ВнешнийIDСтроки
						  |ИЗ
						  |	ТЗДок КАК ТЗДок
						  |		ЛЕВОЕ СОЕДИНЕНИЕ ТЗНом КАК ТЗНом
						  |		ПО ТЗДок.Организация = ТЗНом.Организация
						  |		И ТЗДок.Номенклатура = ТЗНом.Номенклатура
						  |		ЛЕВОЕ СОЕДИНЕНИЕ ТЗДанныеИдентификаторовСтрок КАК ТЗДанныеИдентификаторовСтрок
						  |		ПО ТЗДок.Ссылка = ТЗДанныеИдентификаторовСтрок.Ссылка
						  |		И ТЗДок.ИдентификаторСтроки = ТЗДанныеИдентификаторовСтрок.ИдентификаторСтроки
						  |ИТОГИ
						  |	МАКСИМУМ(Дата),
						  |	МАКСИМУМ(Номер),
						  |	МАКСИМУМ(Организация),
						  |	МАКСИМУМ(Валюта),
						  |	МАКСИМУМ(НачальнаяДатаСбораПредложений),
						  |	МАКСИМУМ(КонечнаяДатаСбораПредложений),
						  |	МАКСИМУМ(ТекстовоеОписание),
						  |	МАКСИМУМ(АдресДоставки),
						  |	МАКСИМУМ(КомментарийКУсловиямДоставки),
						  |	МАКСИМУМ(КомментарийКУсловиямОплаты),
						  |	МАКСИМУМ(ТипЗапроса)
						  |ПО
						  |	Ссылка");
	Запрос.УстановитьПараметр("ДокЗапроса", ДокЗапроса);

	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Возврат Выборка;

КонецФункции

Функция ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам_Обновление(ДокЗапроса, ВнешнийID = "")

	Выборка = ПолучитьДанныеДокументаДокументаЗапросЦенПоставщикам(ДокЗапроса);

	ДанныеЗапросаПоставщикам = НоваяСтруктураДанныхЗапросаЦенПоставщикам();

	МассивСтрок = Новый Массив;

	Пока Выборка.Следующий() Цикл

		ДанныеЗапросаПоставщикам.externalId = Строка(Выборка.Ссылка.УникальныйИдентификатор());
		ДанныеЗапросаПоставщикам.id = ВнешнийID;
		ДанныеЗапросаПоставщикам.privateRequest = Выборка.ТипЗапроса = Перечисления.TK_ТипыЗапросовЦен.Закрытый;
		ДанныеЗапросаПоставщикам.currency = Строка(Выборка.Валюта);
		ДанныеЗапросаПоставщикам.title = "RFQ # " + Строка(Выборка.Номер) + " от " + Формат(Выборка.Дата,
			"ДФ=dd.MM.yyyy;");
		ДанныеЗапросаПоставщикам.date.from = Формат(Выборка.НачальнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;");
		ДанныеЗапросаПоставщикам.date.to = Формат(Выборка.КонечнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;");
		ДанныеЗапросаПоставщикам.description = Выборка.ТекстовоеОписание;
		ДанныеЗапросаПоставщикам.deliveryAddress = Выборка.АдресДоставки;
		ДанныеЗапросаПоставщикам.deliveryTerms = Выборка.КомментарийКУсловиямДоставки;
		ДанныеЗапросаПоставщикам.paymentTerms = Выборка.КомментарийКУсловиямОплаты;

		ВыборкаДетали = Выборка.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Пока ВыборкаДетали.Следующий() Цикл

			ПозицияЗапросаПоставщикам = НоваяСтруктураПозицииЗапросаЦенПоставщикам();

			ПозицияЗапросаПоставщикам.id = ?(ЗначениеЗаполнено(ВыборкаДетали.ВнешнийIDСтроки),
				ВыборкаДетали.ВнешнийIDСтроки, "");
			ПозицияЗапросаПоставщикам.externalId = ВыборкаДетали.ИдентификаторСтроки;
			ПозицияЗапросаПоставщикам.productId = ВыборкаДетали.Идентификатор;
			ПозицияЗапросаПоставщикам.quantity = ВыборкаДетали.Количество;
			ПозицияЗапросаПоставщикам.price = ВыборкаДетали.ЖелаемаяЦена;
			ПозицияЗапросаПоставщикам.deliveryDate = Формат(ВыборкаДетали.ДатаПоставки, "ДФ=yyyy-MM-dd;");
			ПозицияЗапросаПоставщикам.comment = ВыборкаДетали.Комментарий;

			МассивСтрок.Добавить(ПозицияЗапросаПоставщикам);

		КонецЦикла;

	КонецЦикла;

	ДанныеЗапросаПоставщикам.items = МассивСтрок;

	Возврат ДанныеЗапросаПоставщикам;

КонецФункции

Функция ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам(ДокЗапроса)
	Выборка = ПолучитьДанныеДокументаДокументаЗапросЦенПоставщикам(ДокЗапроса);

	ДанныеЗапросаПоставщикам = НоваяСтруктураДанныхЗапросаЦенПоставщикам();

	МассивСтрок = Новый Массив;

	Пока Выборка.Следующий() Цикл

		ДанныеЗапросаПоставщикам.externalId = Строка(Выборка.Ссылка.УникальныйИдентификатор());
		ДанныеЗапросаПоставщикам.privateRequest = Выборка.ТипЗапроса = Перечисления.TK_ТипыЗапросовЦен.Закрытый;
		ДанныеЗапросаПоставщикам.title = "RFQ # " + Строка(Выборка.Номер) + " от " + Формат(Выборка.Дата,
			"ДФ=dd.MM.yyyy;");
		ДанныеЗапросаПоставщикам.date.from = Формат(Выборка.НачальнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;");
		ДанныеЗапросаПоставщикам.date.to = Формат(Выборка.КонечнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;");
		ДанныеЗапросаПоставщикам.currency = Строка(Выборка.Валюта);
		ДанныеЗапросаПоставщикам.description = Выборка.ТекстовоеОписание;
		ДанныеЗапросаПоставщикам.deliveryAddress = Выборка.АдресДоставки;
		ДанныеЗапросаПоставщикам.deliveryTerms = Выборка.КомментарийКУсловиямДоставки;
		ДанныеЗапросаПоставщикам.paymentTerms = Выборка.КомментарийКУсловиямОплаты;

		ВыборкаДетали = Выборка.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Пока ВыборкаДетали.Следующий() Цикл
			ПозицияЗапросаПоставщикам = НоваяСтруктураПозицииЗапросаЦенПоставщикам();

			ПозицияЗапросаПоставщикам.externalId = ВыборкаДетали.ИдентификаторСтроки;
			ПозицияЗапросаПоставщикам.productId = ВыборкаДетали.Идентификатор;
			ПозицияЗапросаПоставщикам.quantity = ВыборкаДетали.Количество;
			ПозицияЗапросаПоставщикам.price = ВыборкаДетали.ЖелаемаяЦена;
			ПозицияЗапросаПоставщикам.deliveryDate = Формат(ВыборкаДетали.ДатаПоставки, "ДФ=yyyy-MM-dd;");
			ПозицияЗапросаПоставщикам.comment = ВыборкаДетали.Комментарий;

			МассивСтрок.Добавить(ПозицияЗапросаПоставщикам);
		КонецЦикла;

	КонецЦикла;

	ДанныеЗапросаПоставщикам.items = МассивСтрок;

	Возврат ДанныеЗапросаПоставщикам;

КонецФункции

Процедура СинхронизоватьНоменклатуру(МассивДанных, Организация)

	Для Каждого Элемент Из МассивДанных Цикл
		УникальныйИдентификаторВ1С = Элемент.externalId;
		ИДНаСайте = Элемент.id;

		Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(
			Новый УникальныйИдентификатор(УникальныйИдентификаторВ1С));

		Если ЗначениеЗаполнено(Номенклатура) Тогда
			МенеджерЗаписи = РегистрыСведений.TK_СоответствиеНоменклатурыTeklifo.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура = Номенклатура;
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.ВнешнийID = ИДНаСайте;
			МенеджерЗаписи.Записать();
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция УчетнаяЗаписьИИдентификаторОрганизацииВTeklifo(Организация)

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись,
						  |	TK_СоответствияОрганизаций.ИдентификаторОрганизацииTeklifo,
						  |	TK_СоответствияОрганизаций.Организация
						  |ИЗ
						  |	РегистрСведений.TK_СоответствиеОрганизацийTeklifo КАК TK_СоответствияОрганизаций
						  |ГДЕ
						  |	TK_СоответствияОрганизаций.Организация = &Организация
						  |СГРУППИРОВАТЬ ПО
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись,
						  |	TK_СоответствияОрганизаций.ИдентификаторОрганизацииTeklifo,
						  |	TK_СоответствияОрганизаций.Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Структура = Новый Структура("УчетнаяЗапись, ИдентификаторОрганизацииTeklifo", Выборка.УчетнаяЗапись,
		Выборка.ИдентификаторОрганизацииTeklifo);

	Возврат Структура;

КонецФункции

Функция ПолучитьIDЗапросаИзURL(Url = "")

	СимволПоиска = "rfq/";

	НомерСимвола = СтрНайти(Url, СимволПоиска);

	Если НомерСимвола <> 0 Тогда
		Возврат Сред(Url, НомерСимвола + 4);
	КонецЕсли;

	Возврат "";

КонецФункции

Функция НоваяСтруктураДанныхЗапросаЦенПоставщикам()

	ПериодСбораПредложений = Новый Структура("from", "to", '00010101', '00010101');

	ДанныеЗапросаПоставщикам = Новый Структура;
	ДанныеЗапросаПоставщикам.Вставить("id", "");
	ДанныеЗапросаПоставщикам.Вставить("externalId", "");
	ДанныеЗапросаПоставщикам.Вставить("privateRequest", Ложь);
	ДанныеЗапросаПоставщикам.Вставить("currency", "");
	ДанныеЗапросаПоставщикам.Вставить("title", "");
	ДанныеЗапросаПоставщикам.Вставить("date", ПериодСбораПредложений);
	ДанныеЗапросаПоставщикам.Вставить("description", "");
	ДанныеЗапросаПоставщикам.Вставить("deliveryAddress", "");
	ДанныеЗапросаПоставщикам.Вставить("deliveryTerms", "");
	ДанныеЗапросаПоставщикам.Вставить("paymentTerms", "");
	ДанныеЗапросаПоставщикам.Вставить("items", Новый Массив);

	Возврат ДанныеЗапросаПоставщикам

КонецФункции

Функция НоваяСтруктураПозицииЗапросаЦенПоставщикам()

	ПозицияЗапросаПоставщикам = Новый Структура;
	ПозицияЗапросаПоставщикам.Вставить("externalId", "");
	ПозицияЗапросаПоставщикам.Вставить("id", "");
	ПозицияЗапросаПоставщикам.Вставить("productId", "");
	ПозицияЗапросаПоставщикам.Вставить("quantity", 0);
	ПозицияЗапросаПоставщикам.Вставить("price", 0);
	ПозицияЗапросаПоставщикам.Вставить("deliveryDate", '00010101');
	ПозицияЗапросаПоставщикам.Вставить("comment", "");

	Возврат ПозицияЗапросаПоставщикам

КонецФункции

#КонецОбласти