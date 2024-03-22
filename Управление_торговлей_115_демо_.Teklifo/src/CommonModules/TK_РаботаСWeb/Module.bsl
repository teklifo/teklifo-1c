
// Получить данные из JSON.
// 
// Параметры:
//  ТелоЗапроса - Строка - Тело запроса
//  ПараметрыДата - Строка - Параметры дата
// 
// Возвращаемое значение:
//  Произвольный - Получить данные из JSON
Функция ПолучитьДанныеИзJSON(ТелоЗапроса = "", ПараметрыДата = "") Экспорт
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);

	Возврат ПрочитатьJSON(ЧтениеJSON, , ПараметрыДата);
КонецФункции



// Сериализовать JSON.
// 
// Параметры:
//  ДанныеСериализации - Структура - Данные сериализации:
// 
// Возвращаемое значение:
//  Строка - Сериализовать JSON
Функция СериализоватьJSON(ДанныеСериализации) Экспорт

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеСериализации);

	Возврат ЗаписьJSON.Закрыть();
КонецФункции


// Получить результат отправки номенклатуры.
// 
// Параметры:
//  МассивНоменклатуры - Массив из СправочникСсылка.Номенклатура
//  ДанныеПоОрганизации - Структура:
// * УчетнаяЗапись 
// * ОрганизацияНаСайте
// * Организация
// 
// Возвращаемое значение:
//  Структура, Неопределено, Произвольный - Получить результат отправки номенклатуры
Функция ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ДанныеПоОрганизации) Экспорт
	СтруктураТокенов = Новый Структура;// Структура 

	ОбработкаИнтеграции = Обработки.TK_ОбработкаИнтеграции.Создать();
	ОбработкаИнтеграции.Email = ДанныеПоОрганизации.УчетнаяЗапись.Email;
	ОбработкаИнтеграции.Пароль = ДанныеПоОрганизации.УчетнаяЗапись.Пароль;
	ОбработкаИнтеграции.ВыполнитьАвторизацию(СтруктураТокенов, Ложь);

	ТокенСессии = ОбработкаИнтеграции.ПолучитьТокенСессии(СтруктураТокенов);

	Результат = ОбработкаИнтеграции.ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ТокенСессии, СокрЛП(
		ДанныеПоОрганизации.ОрганизацияНаСайте));// Структура

	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		СинхронизоватьНоменклатуру(Результат, ДанныеПоОрганизации.Организация);
	КонецЕсли;

	Возврат ТокенСессии;

КонецФункции




// Получить результат отправки документа запрос цен поставщикам.
// 
// Параметры:
//  ДокЗапроса  - ДокументСсылка.TK_ЗапросЦенПоставщикам
// 
// Возвращаемое значение:
//  Структура - Получить результат отправки документа запрос цен поставщикам
Функция ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам(ДокЗапроса) Экспорт

	Результат = Новый Структура;

	МассивНоменклатуры = ДокЗапроса.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура");

	ДанныеПоОрганизации = ПолучитьДанныеПоОрганизации(ДокЗапроса.Организация);

	ТокенСессии = ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ДанныеПоОрганизации);
	ДанныеОтправки = ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам(ДокЗапроса);

	ОбработкаИнтеграции = Обработки.TK_ОбработкаИнтеграции.Создать();

	Результат = ОбработкаИнтеграции.ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам(ДанныеОтправки, ТокенСессии,
		ДанныеПоОрганизации.ОрганизацияНаСайте);

	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		СинхронизоватьЗапросыЦенПоставщикам(ДокЗапроса, Результат.id);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции




// Синхронизовать запросы цен поставщикам.
// 
// Параметры:
//  ДокументЗапроса  - ДокументСсылка.TK_ЗапросЦенПоставщикам
//  ВнешнийID - Строка - Внешний ID
Процедура СинхронизоватьЗапросыЦенПоставщикам(ДокументЗапроса, ВнешнийID = "")
	Если ЗначениеЗаполнено(ВнешнийID) Тогда
		МенеджерЗаписи = РегистрыСведений.TK_СоответствияДокументовЗапросаЦенПоставщикам.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ДокументЗапроса = ДокументЗапроса;
		МенеджерЗаписи.ВнешнийİD       = ВнешнийID;
		МенеджерЗаписи.Записать();
	КонецЕсли;
КонецПроцедуры



// Получить данные для отправки документа запрос цен поставщикам.
// 
// Параметры:
//  ДокЗапроса - ДокументСсылка.TK_ЗапросЦенПоставщикам
// 
// Возвращаемое значение:
//  Структура - Получить данные для отправки документа запрос цен поставщикам:
// * publicRequest 
// * currency 
// * startDate 
// * endDate 
// * description 
// * deliveryAddress 
// * deliveryTerms 
// * paymentTerms 
// * products 
Функция ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам(ДокЗапроса)
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	TK_ЗапросЦенПоставщикам.Дата КАК Дата,
	|	TK_ЗапросЦенПоставщикам.Номер КАК Номер,
	|	TK_ЗапросЦенПоставщикам.Ссылка КАК Ссылка,
	|	TK_ЗапросЦенПоставщикам.Организация КАК Организация,
	|	TK_ЗапросЦенПоставщикам.Валюта КАК Валюта,
	|	TK_ЗапросЦенПоставщикам.НачальнаяДатаСбораПредложения КАК НачальнаяДатаСбораПредложения,
	|	TK_ЗапросЦенПоставщикам.КонечнаяДатаСбораПредложения КАК КонечнаяДатаСбораПредложения,
	|	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.ТекстовоеОписание КАК СТРОКА(1000)) КАК ТекстовоеОписание,
	|	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.АдресДоставки КАК СТРОКА(1000)) КАК АдресДоставки,
	|	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.КомментарийКУсловиямДоставки КАК СТРОКА(1000)) КАК КомментарийКУсловиямДоставки,
	|	ВЫРАЗИТЬ(TK_ЗапросЦенПоставщикам.КомментарийКУсловиямОплаты КАК СТРОКА(1000)) КАК КомментарийКУсловиямОплаты,
	|	TK_ЗапросЦенПоставщикам.ТипЗапроса КАК ТипЗапроса,
	|	TK_ЗапросЦенПоставщикамТовары.Номенклатура КАК Номенклатура,
	|	TK_ЗапросЦенПоставщикамТовары.Количество КАК Количество,
	|	TK_ЗапросЦенПоставщикамТовары.ЖелаемаяЦена КАК ЖелаемаяЦена,
	|	TK_ЗапросЦенПоставщикамТовары.ДатаПоставки КАК ДатаПоставки,
	|	TK_ЗапросЦенПоставщикамТовары.Комментарий КАК Комментарий
	|ПОМЕСТИТЬ ТЗДок
	|ИЗ
	|	Документ.TK_ЗапросЦенПоставщикам.Товары КАК TK_ЗапросЦенПоставщикамТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.TK_ЗапросЦенПоставщикам КАК TK_ЗапросЦенПоставщикам
	|		ПО (TK_ЗапросЦенПоставщикамТовары.Ссылка = TK_ЗапросЦенПоставщикам.Ссылка)
	|ГДЕ
	|	TK_ЗапросЦенПоставщикамТовары.Ссылка = &ДокЗапроса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗДок.Номенклатура КАК Номенклатура,
	|	ТЗДок.Организация КАК Организация,
	|	TK_СоответствияНоменклатуры.ВнешнийID КАК ВнешнийID
	|ПОМЕСТИТЬ ТЗНом
	|ИЗ
	|	ТЗДок КАК ТЗДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_СоответствияНоменклатуры КАК TK_СоответствияНоменклатуры
	|		ПО ТЗДок.Номенклатура = TK_СоответствияНоменклатуры.Номенклатура
	|		И ТЗДок.Организация = TK_СоответствияНоменклатуры.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗДок.Дата КАК Дата,
	|	ТЗДок.Номер КАК Номер,
	|	ТЗДок.Ссылка КАК Ссылка,
	|	ТЗДок.Организация КАК Организация,
	|	ТЗДок.Валюта КАК Валюта,
	|	ТЗДок.НачальнаяДатаСбораПредложения КАК НачальнаяДатаСбораПредложения,
	|	ТЗДок.КонечнаяДатаСбораПредложения КАК КонечнаяДатаСбораПредложения,
	|	ТЗДок.ТекстовоеОписание КАК ТекстовоеОписание,
	|	ТЗДок.АдресДоставки КАК АдресДоставки,
	|	ТЗДок.КомментарийКУсловиямДоставки КАК КомментарийКУсловиямДоставки,
	|	ТЗДок.КомментарийКУсловиямОплаты КАК КомментарийКУсловиямОплаты,
	|	ТЗДок.ТипЗапроса КАК ТипЗапроса,
	|	ТЗДок.Номенклатура КАК Номенклатура,
	|	ТЗДок.Количество КАК Количество,
	|	ТЗДок.ЖелаемаяЦена КАК ЖелаемаяЦена,
	|	ТЗДок.ДатаПоставки КАК ДатаПоставки,
	|	ТЗДок.Комментарий КАК Комментарий,
	|	ТЗНом.ВнешнийID КАК ВнешнийID
	|ИЗ
	|	ТЗДок КАК ТЗДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗНом КАК ТЗНом
	|		ПО (ТЗДок.Организация = ТЗНом.Организация)
	|		И (ТЗДок.Номенклатура = ТЗНом.Номенклатура)
	|ИТОГИ
	|	МАКСИМУМ(Дата),
	|	МАКСИМУМ(Номер),
	|	МАКСИМУМ(Организация),
	|	МАКСИМУМ(Валюта),
	|	МАКСИМУМ(НачальнаяДатаСбораПредложения),
	|	МАКСИМУМ(КонечнаяДатаСбораПредложения),
	|	МАКСИМУМ(ТекстовоеОписание) КАК ТекстовоеОписание,
	|	МАКСИМУМ(АдресДоставки) КАК АдресДоставки,
	|	МАКСИМУМ(КомментарийКУсловиямДоставки) КАК КомментарийКУсловиямДоставки,
	|	МАКСИМУМ(КомментарийКУсловиямОплаты) КАК КомментарийКУсловиямОплаты,
	|	МАКСИМУМ(ТипЗапроса) КАК ТипЗапроса
	|ПО
	|	Ссылка");
	Запрос.УстановитьПараметр("ДокЗапроса", ДокЗапроса);

	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	СтруктураДанных = Новый Структура("publicRequest,currency,startDate,endDate,description,deliveryAddress,
									  |deliveryTerms,paymentTerms,products");

	МассивСтрок = Новый Массив;

	Пока Выборка.Следующий() Цикл

		СтруктураДанных.publicRequest = Выборка.ТипЗапроса = Перечисления.TK_ТипыЗапроса.Публичный;
		СтруктураДанных.currency = Строка(Выборка.Валюта);
		СтруктураДанных.startDate = Формат(Выборка.НачальнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;");
		СтруктураДанных.endDate = Формат(Выборка.КонечнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;");
		СтруктураДанных.description = Выборка.ТекстовоеОписание;
		СтруктураДанных.deliveryAddress = Выборка.АдресДоставки;
		СтруктураДанных.deliveryTerms   = Выборка.КомментарийКУсловиямДоставки;
		СтруктураДанных.paymentTerms    = Выборка.КомментарийКУсловиямОплаты;

		ВыборкаДетали = Выборка.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Пока ВыборкаДетали.Следующий() Цикл
			СтруктураСтроки = Новый Структура("productId,quantity,price,deliveryDate,comment");

			СтруктураСтроки.productId = ВыборкаДетали.ВнешнийID;
			СтруктураСтроки.quantity  = ВыборкаДетали.Количество;
			СтруктураСтроки.price     = ВыборкаДетали.ЖелаемаяЦена;
			СтруктураСтроки.deliveryDate = Формат(ВыборкаДетали.ДатаПоставки, "ДФ=yyyy-MM-dd;");
			СтруктураСтроки.comment      = ВыборкаДетали.Комментарий;

			МассивСтрок.Добавить(СтруктураСтроки);
		КонецЦикла;

	КонецЦикла;

	СтруктураДанных.products = МассивСтрок;
	Возврат СтруктураДанных;

КонецФункции






// Синхронизовать номенклатуру.
// 
// Параметры:
//  МассивДанных - Массив из Структура,
//  Организация - СправочникСсылка.Организации
Процедура СинхронизоватьНоменклатуру(МассивДанных, Организация)

	Для Каждого Элемент Из МассивДанных Цикл
		УникальныйИдентификаторВ1С = Элемент.externalId;
		ИДНаСайте = Элемент.id;

		Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(
			Новый УникальныйИдентификатор(УникальныйИдентификаторВ1С));

		Если ЗначениеЗаполнено(Номенклатура) Тогда
			МенеджерЗаписи = РегистрыСведений.TK_СоответствияНоменклатуры.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура = Номенклатура;
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.ВнешнийID = ИДНаСайте;
			МенеджерЗаписи.Записать();
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры




// Получить данные по организации.
// 
// Параметры:
// Организация - СправочникСсылка.Организации -
// 
// Возвращаемое значение:
//  Структура - Получить данные по организации:
// * УчетнаяЗапись 
// * ОрганизацияНаСайте
// * Организация 
Функция ПолучитьДанныеПоОрганизации(Организация)
	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись,
						  |	TK_СоответствияОрганизаций.ОрганизацияНаСайте,
						  |	TK_СоответствияОрганизаций.Организация
						  |ИЗ
						  |	РегистрСведений.TK_СоответствияОрганизаций КАК TK_СоответствияОрганизаций
						  |ГДЕ
						  |	TK_СоответствияОрганизаций.Организация = &Организация
						  |СГРУППИРОВАТЬ ПО
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись,
						  |	TK_СоответствияОрганизаций.ОрганизацияНаСайте,
						  |	TK_СоответствияОрганизаций.Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Структура = Новый Структура("УчетнаяЗапись,ОрганизацияНаСайте,Организация", Выборка.УчетнаяЗапись,
		Выборка.ОрганизацияНаСайте, Выборка.Организация);

	Возврат Структура;

КонецФункции