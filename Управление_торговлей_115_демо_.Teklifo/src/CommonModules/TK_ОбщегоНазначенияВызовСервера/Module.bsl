#Область ПрограммныйИнтерфейс

#Область Организации

// Возвращает список организаций для которых настроена интеграция с Teklifo.
// 
// Возвращаемое значение:
//  Массив Из СправочникСсылка.Организации - доступные для интеграции организации
Функция ОрганизацииДоступныеКОбменуСTeklifo() Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СоответствияОрганизаций.Организация
						  |ИЗ
						  |	РегистрСведений.TK_СоответствиеОрганизацийTeklifo КАК TK_СоответствияОрганизаций
						  |СГРУППИРОВАТЬ ПО
						  |	TK_СоответствияОрганизаций.Организация");

	Результат = Запрос.Выполнить().Выгрузить();

	Возврат Результат.ВыгрузитьКолонку("Организация");

КонецФункции

#КонецОбласти

#Область ЗапросЦенОтКлиента

// Возвращает данные опубликованного запроса цен от клиента по идентификатору версии.
// 
// Параметры:
//  ИдентификаторВерсии - Строка - идентификатор версии опубликованного документа
// 
// Возвращаемое значение:
//  ДокументСсылка.TK_ЗапросЦенОтКлиента
Функция ЗапросЦенОтКлиентаПоИдентификаторуВерсии(ИдентификаторВерсии) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_ЗапросЦенОтКлиента.Ссылка КАК Документ
						  |ИЗ
						  |	Документ.TK_ЗапросЦенОтКлиента КАК TK_ЗапросЦенОтКлиента
						  |ГДЕ
						  |	TK_ЗапросЦенОтКлиента.Проведен
						  |	И TK_ЗапросЦенОтКлиента.ИдентификаторВерсии = &ИдентификаторВерсии");
	Запрос.УстановитьПараметр("ИдентификаторВерсии", ИдентификаторВерсии);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Документ;
	КонецЕсли;

	Возврат Документы.TK_ЗапросЦенОтКлиента.ПустаяСсылка();

КонецФункции

#КонецОбласти

#Область ЗапросЦенПоставщикам

// Возвращает данные опубликованного запроса цен поставщикам.
// 
// Параметры:
//  ЗапросЦенПоставщикам - ДокументСсылка.TK_ЗапросЦенПоставщикам - Запрос цен поставщикам
// 
// Возвращаемое значение:
//  Структура:
// * Идентификатор - Строка
// * НомерДокумента - Строка
Функция ДанныеОпубликованногоЗапросаЦенПоставщикам(ЗапросЦенПоставщикам) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	ЗапросыЦенПоставщикамНаTeklifo.Идентификатор,
						  |	ЗапросыЦенПоставщикамНаTeklifo.НомерДокумента
						  |ИЗ
						  |	РегистрСведений.TK_ЗапросыЦенПоставщикамНаTeklifo КАК ЗапросыЦенПоставщикамНаTeklifo
						  |ГДЕ
						  |	ЗапросыЦенПоставщикамНаTeklifo.Документ = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ЗапросЦенПоставщикам);
	Выборка = Запрос.Выполнить().Выбрать();

	СтруктураДанных = Новый Структура("Идентификатор, НомерДокумента", "", "");
	Если Выборка.Следующий() Тогда
		СтруктураДанных.Идентификатор = Выборка.Идентификатор;
		СтруктураДанных.НомерДокумента = Выборка.НомерДокумента;
	КонецЕсли;

	Возврат СтруктураДанных;

КонецФункции

// Возвращает URL публикации запроса цен поставщикам на сервисе Teklifo.
// 
// Параметры:
//  ЗапросЦенПоставщикам - ДокументСсылка.TK_ЗапросЦенПоставщикам - Запрос цен поставщикам
// 
// Возвращаемое значение:
//  Строка - URL публикации документа
Функция ВнешняяСсылкаНаОпубликованныйЗапросЦенПоставщикам(ЗапросЦенПоставщикам) Экспорт

	ДанныеПубликации = ДанныеОпубликованногоЗапросаЦенПоставщикам(ЗапросЦенПоставщикам);

	ВнешняяСсылка = "";

	Если ЗначениеЗаполнено(ДанныеПубликации.Идентификатор) Тогда
		ВнешняяСсылка = СтрШаблон("https://teklifo.com/rfq/%1", ДанныеПубликации.Идентификатор);
	КонецЕсли;

	Возврат ВнешняяСсылка;

КонецФункции

// Возвращает актуальный статус публикации запроса цен поставщикам на Teklifo.
// 
// Параметры:
//  ЗапросЦенПоставщикам - ДокументСсылка.TK_ЗапросЦенПоставщикам - Запрос цен поставщикам
// 
// Возвращаемое значение:
// 	ПеречислениеСсылка.TK_СтатусыПубликацииДокументовНаTeklifo 
Функция СтатусПубликацииЗапросаЦенПоставщикам(ЗапросЦенПоставщикам) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	СтатусыПубликацииЗапросовЦен.Статус
						  |ИЗ
						  |	РегистрСведений.TK_СтатусыПубликацииЗапросовЦенПоставщикамНаTeklifo.СрезПоследних(, Документ = &Документ) КАК
						  |		СтатусыПубликацииЗапросовЦен");
	Запрос.УстановитьПараметр("Документ", ЗапросЦенПоставщикам);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Статус;
	Иначе
		Возврат Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.НеОпубликован;
	КонецЕсли;

КонецФункции

// Устанавливает статус публикации запроса цен поставщикам.
// 
// Параметры:
//  ЗапросЦенПоставщикам - ДокументСсылка.TK_ЗапросЦенПоставщикам - Запрос цен поставщикам
//  СтатусПубликации - ПеречислениеСсылка.TK_СтатусыПубликацииДокументовНаTeklifo - СтатусПубликации публикации
Процедура УстановитьСтатусПубликацииЗапросаЦенПоставщикам(ЗапросЦенПоставщикам, СтатусПубликации) Экспорт

	МенеджерЗаписи = РегистрыСведений.TK_СтатусыПубликацииЗапросовЦенПоставщикамНаTeklifo.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Документ = ЗапросЦенПоставщикам;
	МенеджерЗаписи.Статус = СтатусПубликации;
	МенеджерЗаписи.Записать();

КонецПроцедуры

// Проверяет наличие изменений в запросе цен поставщика, требующих повторной публикации документа.
// 
// Параметры:
//  Объект - ДокументОбъект.TK_ЗапросЦенПоставщикам - Объект запроса цен поставщикам
// 
// Возвращаемое значение:
//  Булево - Запрос цен поставщикам изменен
Функция ЗапросЦенПоставщикамИзменен(Объект) Экспорт

	Возврат ОбменДаннымиСобытия.ДанныеРазличаются(Объект, Объект.Ссылка.ПолучитьОбъект(), , "Комментарий, Менеджер");

КонецФункции

#КонецОбласти

#Область КоммерческоеПредложениеКлиенту

// Возвращает идентификатор опубликованного коммерческого предложения клиенту.
// 
// Параметры:
//  КоммерческоеПредложениеКлиенту - ДокументСсылка.TK_КоммерческоеПредложениеКлиенту - Коммерческое предложение клиенту
// 
// Возвращаемое значение:
//  Число - Идентификатор опубликованного коммерческого предложения клиенту
Функция ИдентификаторОпубликованногоКоммерческогоПредложенияКлиенту(КоммерческоеПредложениеКлиенту) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	КоммерческиеПредложенияКлиентамНаTeklifo.Идентификатор
						  |ИЗ
						  |	РегистрСведений.TK_КоммерческиеПредложенияКлиентамНаTeklifo КАК КоммерческиеПредложенияКлиентамНаTeklifo
						  |ГДЕ
						  |	КоммерческиеПредложенияКлиентамНаTeklifo.Документ = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", КоммерческоеПредложениеКлиенту);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Идентификатор;
	КонецЕсли;

	Возврат 0;

КонецФункции

// Возвращает URL публикации коммерческого предложения клиенту на сервисе Teklifo.
// 
// Параметры:
//  КоммерческоеПредложениеКлиенту - ДокументСсылка.TK_КоммерческоеПредложениеКлиенту - Коммерческое предложение клиенту
// 
// Возвращаемое значение:
//  Строка - URL публикации документа
Функция ВнешняяСсылкаНаОпубликованноеКоммерческоеПредложениеКлиенту(КоммерческоеПредложениеКлиенту) Экспорт

	Идентификатор = ИдентификаторОпубликованногоКоммерческогоПредложенияКлиенту(КоммерческоеПредложениеКлиенту);

	ВнешняяСсылка = "";

	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ВнешняяСсылка = СтрШаблон("https://teklifo.com/quotation/%1", Идентификатор);
	КонецЕсли;

	Возврат ВнешняяСсылка;

КонецФункции

// Возвращает актуальный статус публикации коммерческого предложения клиенту на Teklifo.
// 
// Параметры:
//  КоммерческоеПредложениеКлиенту - ДокументСсылка.TK_КоммерческоеПредложениеКлиенту - Коммерческое предложение клиенту
// 
// Возвращаемое значение:
// 	ПеречислениеСсылка.TK_СтатусыПубликацииДокументовНаTeklifo 
Функция СтатусПубликацииКоммерческогоПредложенияКлиенту(КоммерческоеПредложениеКлиенту) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	СтатусыПубликацииКоммерческихПредложений.Статус
						  |ИЗ
						  |	РегистрСведений.TK_СтатусыПубликацииКоммерческихПредложенийНаTeklifo.СрезПоследних(, Документ = &Документ) КАК
						  |		СтатусыПубликацииКоммерческихПредложений");
	Запрос.УстановитьПараметр("Документ", КоммерческоеПредложениеКлиенту);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Статус;
	Иначе
		Возврат Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.НеОпубликован;
	КонецЕсли;

КонецФункции

// Устанавливает статус публикации коммерческого предложения клиенту.
// 
// Параметры:
//  КоммерческоеПредложениеКлиенту - ДокументСсылка.TK_КоммерческоеПредложениеКлиенту - Коммерческое предложение клиенту
//  СтатусПубликации - ПеречислениеСсылка.TK_СтатусыПубликацииДокументовНаTeklifo - СтатусПубликации публикации
Процедура УстановитьСтатусПубликацииКоммерческогоПредложенияКлиенту(КоммерческоеПредложениеКлиенту, СтатусПубликации) Экспорт

	МенеджерЗаписи = РегистрыСведений.TK_СтатусыПубликацииКоммерческихПредложенийНаTeklifo.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = ТекущаяДатаСеанса();
	МенеджерЗаписи.Документ = КоммерческоеПредложениеКлиенту;
	МенеджерЗаписи.Статус = СтатусПубликации;
	МенеджерЗаписи.Записать();

КонецПроцедуры

// Проверяет наличие изменений в коммерческом предложении клиенту, требующих повторной публикации документа.
// 
// Параметры:
//  Объект - ДокументОбъект.TK_КоммерческоеПредложениеКлиенту - Объект коммерческого предложения клиенту
// 
// Возвращаемое значение:
//  Булево - Коммерческое предложение клиенту изменено
Функция КоммерческоеПредложениеКлиентуИзменено(Объект) Экспорт

	Возврат ОбменДаннымиСобытия.ДанныеРазличаются(Объект, Объект.Ссылка.ПолучитьОбъект(), , "Комментарий, Менеджер");

КонецФункции

#КонецОбласти

#Область Прочее

// Устанавливает условное оформление для статуса публикации в динамическом списке.
// 
// Параметры:
//  СписокУсловноеОформление - УсловноеОформлениеКомпоновкиДанных - Условное оформление
Процедура УсловноеОформлениеСтатусаПубликации(СписокУсловноеОформление) Экспорт
	
	// Статус жирным шрифтом
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Статус публикации жирным шрифтом'");

	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СтатусПубликации");

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.TK_ШрифтЖирный);
	
	// Не опубликован
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Не опубликован'");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусПубликации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.НеОпубликован;

	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СтатусПубликации");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаКнопки);
	
	// Опубликован
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Опубликован'");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусПубликации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.Опубликован;

	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СтатусПубликации");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветАкцента);
	
	// Требуется обновление
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Требуется обновление'");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатусПубликации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.ТребуетсяОбновление;

	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("СтатусПубликации");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);

КонецПроцедуры

#КонецОбласти

#КонецОбласти