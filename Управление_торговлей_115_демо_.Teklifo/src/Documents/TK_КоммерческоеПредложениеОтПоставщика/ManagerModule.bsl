#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область СозданиеНаОсновании
	
// Добавляет команду создания документа "Коммерческое предложение клиенту".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений, Неопределено - сформированные команды для вывода в подменю.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	// Добавить команду создания на основании.

КонецФункции
	
// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт

	// Добавить команды создания на основании.

КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Добавление команд печати

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов,
		КоллекцияПечатныхФорм);

КонецПроцедуры

#КонецОбласти
#Область Проведение
// Дополнительные источники данных для движений.
// 
// Параметры:
//  ИмяРегистра -Строка- Имя регистра
// 
// Возвращаемое значение:
//  Соответствие - Дополнительные источники данных для движений
//@skip-check doc-comment-collection-item-type
Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции


// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
// 
// Параметры:
//  МеханизмыДокумента - Массив из Строка - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	МеханизмыДокумента.Добавить("TKУчетныйМеханизм");
КонецПроцедуры



// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
// 
// Параметры:
//  Документ - ДокументСсылка.TK_КоммерческоеПредложениеОтПоставщика, ДокументОбъект.TK_КоммерческоеПредложениеОтПоставщика - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  СписокЗначений, Структура - Данные документа для проведения
//@skip-check doc-comment-collection-item-type
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт

	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;

	Если ТипЗнч(Документ) = Тип("ДокументОбъект.TK_КоммерческоеПредложениеОтПоставщика") Тогда
		ДокументОбъект = Документ;
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументОбъект = Документ.ПолучитьОбъект();
		ДокументСсылка = Документ;
	КонецЕсли;

	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений

		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		ТекстЗапросаТаблицаTK_ДанныеКоммерческихПредложенийОтПоставщика(Запрос, ТекстыЗапроса, Регистры, ДокументОбъект);
	КонецЕсли;
	

	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений

	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);

КонецФункции


#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область СлужебныеПроцедурыИФункции
Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
КонецПроцедуры

Функция ТекстЗапросаТаблицаTK_ДанныеКоммерческихПредложенийОтПоставщика(Запрос, ТекстыЗапроса, Регистры,
	ДокументОбъект = Неопределено)
	ИмяРегистра = "TK_ДанныеКоммерческихПредложенийОтПоставщика";

	//@skip-check undefined-variable
	//@skip-check unknown-method-property
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	МассивЗапросов = Новый Массив;

	ТекстЗапроса = "ВЫБРАТЬ
				   |	TK_КоммерческоеПредложениеОтПоставщика.Ссылка КАК Регистратор,
				   |	TK_КоммерческоеПредложениеОтПоставщика.Дата КАК Период,
				   |	TK_КоммерческоеПредложениеОтПоставщика.Организация,
				   |	TK_КоммерческоеПредложениеОтПоставщика.Партнер,
				   |	TK_КоммерческоеПредложениеОтПоставщика.Контрагент,
				   |	TK_КоммерческоеПредложениеОтПоставщика.ЗапросЦенПоставщикам,
				   |	TK_КоммерческоеПредложениеОтПоставщика.Валюта,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.ИдентификаторСтрокиЗапроса,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.Номенклатура,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.НоменклатураТекстом,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.Количество,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.Цена,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.Сумма,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.СтавкаНДС,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.СуммаНДС,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.ЦенаВключаетНДС,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.СуммаСНДС,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.ДатаДоставки,
				   |	TK_КоммерческоеПредложениеОтПоставщикаТовары.Пропущено,
				   |	TK_КоммерческоеПредложениеОтПоставщика.Идентификатор,
				   |	TK_КоммерческоеПредложениеОтПоставщика.ИдентификаторЗапроса,
				   |	TK_КоммерческоеПредложениеОтПоставщика.ИдентификаторВерсииЗапроса
				   |ИЗ
				   |	Документ.TK_КоммерческоеПредложениеОтПоставщика.Товары КАК TK_КоммерческоеПредложениеОтПоставщикаТовары
				   |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.TK_КоммерческоеПредложениеОтПоставщика КАК TK_КоммерческоеПредложениеОтПоставщика
				   |		ПО TK_КоммерческоеПредложениеОтПоставщикаТовары.Ссылка = TK_КоммерческоеПредложениеОтПоставщика.Ссылка
				   |ГДЕ
				   |	TK_КоммерческоеПредложениеОтПоставщика.Ссылка = &Ссылка";
	МассивЗапросов.Добавить(ТекстЗапроса);

	//@skip-check undefined-variable
	//@skip-check unknown-method-property
	ТекстЗапроса = СтрСоединить(МассивЗапросов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());

	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;

КонецФункции
#КонецОбласти