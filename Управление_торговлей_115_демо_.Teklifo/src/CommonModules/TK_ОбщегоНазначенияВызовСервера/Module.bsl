#Область ПрограммныйИнтерфейс

// Возвращает список организаций для которых настроена интеграция с Teklifo.
// 
// Возвращаемое значение:
//  Массив Из СправочникСсылка.Организации - доступные для интеграции организации
Функция ПолучитьСписокДоступныхОрганизаций() Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СоответствияОрганизаций.Организация
						  |ИЗ
						  |	РегистрСведений.TK_СоответствиеОрганизацийTeklifo КАК TK_СоответствияОрганизаций
						  |СГРУППИРОВАТЬ ПО
						  |	TK_СоответствияОрганизаций.Организация");

	Результат = Запрос.Выполнить().Выгрузить();

	Возврат Результат.ВыгрузитьКолонку("Организация");

КонецФункции

// Возвращает URL публикации документа на сервисе Teklifo.
// 
// Параметры:
//  Документ - ДокументСсылка.TK_ЗапросЦенПоставщикам - Ссылка на документ
// 
// Возвращаемое значение:
//  Строка - URL публикации документа
Функция ВнешняяСсылкаНаОпубликованныйДокумент(Документ) Экспорт

	ДанныеПубликации = ДанныеОпубликованногоДокумента(Документ);

	СсылкаДляЗапуска = "";

	Если ТипЗнч(Документ) = Тип("ДокументСсылка.TK_ЗапросЦенПоставщикам") И ЗначениеЗаполнено(
		ДанныеПубликации.Идентификатор) Тогда
		СсылкаДляЗапуска = СтрШаблон("https://teklifo.com/rfq/%1", ДанныеПубликации.Идентификатор);
	КонецЕсли;

	Возврат СсылкаДляЗапуска;

КонецФункции

// Получить данные документа.
// 
// Параметры:
//  Документ - ДокументСсылка.TK_ЗапросЦенПоставщикам - Ссылка на документ
// 
// Возвращаемое значение:
//  Структура - Получить данные документа:
// * Идентификатор - Строка
// * НомерДокумента - Строка
Функция ДанныеОпубликованногоДокумента(Документ) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_ИдентификаторыДокументовНаTeklifo.Идентификатор,
						  |	TK_ИдентификаторыДокументовНаTeklifo.НомерДокумента
						  |ИЗ
						  |	РегистрСведений.TK_ИдентификаторыДокументовНаTeklifo КАК TK_ИдентификаторыДокументовНаTeklifo
						  |ГДЕ
						  |	TK_ИдентификаторыДокументовНаTeklifo.Документ = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	СтруктураДанных = Новый Структура("Идентификатор, НомерДокумента", "", "");
	Если Выборка.Количество() > 0 Тогда
		СтруктураДанных.Идентификатор = Выборка.Идентификатор;
		СтруктураДанных.НомерДокумента = Выборка.НомерДокумента;
	КонецЕсли;

	Возврат СтруктураДанных;

КонецФункции

// Получить данные документа запроса цен от клиента по внешнему ID.
// 
// Параметры:
//  ИдентификаторВерсииЗапросаКлиенту - Строка - Version id
// 
// Возвращаемое значение:
//  Структура - Получить данные документа запроса цен от клиента по внешнему ID:
// * Идентификатор - Строка
// * НомерДокумента - Строка
// * Документ - ДокументСсылка.TK_ЗапросЦенОтКлиента
Функция ПолучитьДанныеДокументаЗапросаЦенОтКлиентаПоВнешнемуID(ИдентификаторВерсииЗапросаКлиенту = "") Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СоответствияДокументовЗапросаЦенОтКлиентов.Идентификатор,
						  |	TK_СоответствияДокументовЗапросаЦенОтКлиентов.НомерДокумента,
						  |	TK_СоответствияДокументовЗапросаЦенОтКлиентов.Документ
						  |ИЗ
						  |	РегистрСведений.TK_СоответствияДокументовЗапросаЦенОтКлиентов КАК TK_СоответствияДокументовЗапросаЦенОтКлиентов
						  |ГДЕ
						  |	TK_СоответствияДокументовЗапросаЦенОтКлиентов.ИдентификаторВерсии = &ИдентификаторВерсии");
	Запрос.УстановитьПараметр("ИдентификаторВерсии", ИдентификаторВерсииЗапросаКлиенту);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	СтруктураДанных = Новый Структура("Идентификатор, НомерДокумента, Документ", "", "",
		Документы.TK_ЗапросЦенОтКлиента.ПустаяСсылка());
	Если Выборка.Количество() > 0 Тогда
		СтруктураДанных.Идентификатор = Выборка.Идентификатор;
		СтруктураДанных.НомерДокумента = Выборка.НомерДокумента;
		СтруктураДанных.Документ = Выборка.Документ;
	КонецЕсли;

	Возврат СтруктураДанных;

КонецФункции

// Возвращает актуальный статус публикации документа на Teklifo.
// 
// Параметры:
//  Документ - ДокументСсылка.TK_ЗапросЦенПоставщикам - Ссылка на заказ
// 
// Возвращаемое значение:
// 	ПеречислениеСсылка.TK_СтатусыПубликацииЗапросовЦен 
Функция СтатусПубликацииДокумента(Документ) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СтатусыДокументовИнтеграцииСрезПоследних.Статус
						  |ИЗ
						  |	РегистрСведений.TK_СтатусыПубликацииДокументовНаTeklifo.СрезПоследних(, Документ = &Документ) КАК
						  |		TK_СтатусыДокументовИнтеграцииСрезПоследних");
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Статус;
	Иначе
		Возврат Перечисления.TK_СтатусыПубликацииЗапросовЦен.НеОпубликован;
	КонецЕсли;

КонецФункции

// Устанавливает статус публикации запроса цен поставщикам.
// 
// Параметры:
//  Документ - ДокументСсылка.TK_ЗапросЦенПоставщикам - Ссылка на заказ
//  Статус - ПеречислениеСсылка.TK_СтатусыПубликацииЗапросовЦен - Статус
Процедура УстановитьСтатусПубликацииЗаказаЦенПоставщикам(Документ, Статус) Экспорт

	МенеджерЗаписи = РегистрыСведений.TK_СтатусыПубликацииДокументовНаTeklifo.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Статус = Статус;
	МенеджерЗаписи.Записать();

КонецПроцедуры

#КонецОбласти