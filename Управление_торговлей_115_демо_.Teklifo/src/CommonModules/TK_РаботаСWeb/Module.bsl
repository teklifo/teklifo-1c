
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
//  Булево - Получить результат отправки документа запрос цен поставщикам
Функция ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам(ДокЗапроса) Экспорт

    ТекСтатусДокумента = TK_ОбщегоНазначенияСервер.ПолучитьСтатусДокументаЗаказаЦенПоставщику(ДокЗапроса);

	Результат = Новый Структура;

	МассивНоменклатуры = ДокЗапроса.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура");

	ДанныеПоОрганизации = ПолучитьДанныеПоОрганизации(ДокЗапроса.Организация);

	ТокенСессии = ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ДанныеПоОрганизации);
	

	ОбработкаИнтеграции = Обработки.TK_ОбработкаИнтеграции.Создать();


    Если ТекСтатусДокумента = Перечисления.TK_СтатусыДокументаЗапросЦенПоставщикам.ТребуетОбновления Тогда
    	ВнешнийID = TK_ОбщегоНазначенияСервер.ПолучитьДанныеДокумента(ДокЗапроса).ВнешнийID;
        
        ДанныеОтправки = ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам_Обновление(ДокЗапроса,ВнешнийID);
        
        
        
        Результат = ОбработкаИнтеграции.ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам_Обновление(ВнешнийID,ДанныеОтправки, ТокенСессии,
		ДанныеПоОрганизации.ОрганизацияНаСайте);	
    Иначе
    	ДанныеОтправки = ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам(ДокЗапроса);
    	
    	Результат = ОбработкаИнтеграции.ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам(ДанныеОтправки, ТокенСессии,
		ДанныеПоОрганизации.ОрганизацияНаСайте);	
    КонецЕсли;

    ПубликацияПрошлаУспешно = Истина;//Временное решение
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("id") Тогда
		СинхронизоватьЗапросыЦенПоставщикам(ДокЗапроса, Результат.id,Результат.number);
		СинхронизоватьСтрокиДокументаЗапросценПоставщикам(ДокЗапроса, Результат);
	КонецЕсли;
	
	Возврат ПубликацияПрошлаУспешно;

КонецФункции




// Синхронизовать строки документа запросцен поставщикам.
// 
// Параметры:
//  ДокументЗапроса - ДокументСсылка.TK_ЗапросЦенПоставщикам - Документ запроса
//  Результат - Структура - Результат
Процедура СинхронизоватьСтрокиДокументаЗапросценПоставщикам(ДокументЗапроса, Результат)
	Для Каждого ДанныеСтроки Из Результат.items Цикл
		Если ЗначениеЗаполнено(ДанныеСтроки.id) Тогда
			МенеджерЗаписи = РегистрыСведений.TK_ВнешниеИдентификаторыСтрокДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ДокументЗапроса = ДокументЗапроса;
			МенеджерЗаписи.ИдентификаторСтроки = ДанныеСтроки.externalId;
			МенеджерЗаписи.ВнешнийID = ДанныеСтроки.id;
			МенеджерЗаписи.Записать();
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры




// Синхронизовать запросы цен поставщикам.
// 
// Параметры:
//  ДокументЗапроса - ДокументСсылка.TK_ЗапросЦенПоставщикам - Документ запроса
//  ВнешнийID - Строка - Внешний ID
//  number - Строка - Number
Процедура СинхронизоватьЗапросыЦенПоставщикам(ДокументЗапроса, ВнешнийID = "",number = "")
	Если ЗначениеЗаполнено(ВнешнийID) Тогда
		МенеджерЗаписи = РегистрыСведений.TK_СоответствияДокументовЗапросаЦенПоставщикам.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ДокументЗапроса = ДокументЗапроса;
		МенеджерЗаписи.ВнешнийID       = ВнешнийID;
		МенеджерЗаписи.number          = number;
		МенеджерЗаписи.Записать();
	КонецЕсли;
КонецПроцедуры







// Получить данные документа документа запрос цен поставщикам.
// 
// Параметры:
//  ДокЗапроса - ДокументСсылка.TK_ЗапросЦенПоставщикам
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - Получить данные документа документа запрос цен поставщикам
Функция ПолучитьДанныеДокументаДокументаЗапросЦенПоставщикам(ДокЗапроса)
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
	|	ТЗДок.Ссылка КАК Ссылка,
	|	ТЗДок.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	TK_ВнешниеИдентификаторыСтрокДокументов.ВнешнийID КАК ВнешнийIDСтроки
	|ПОМЕСТИТЬ ТЗДанныеИдентификаторовСтрок
	|ИЗ
	|	ТЗДок КАК ТЗДок
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_ВнешниеИдентификаторыСтрокДокументов КАК TK_ВнешниеИдентификаторыСтрокДокументов
	|		ПО ТЗДок.Ссылка = TK_ВнешниеИдентификаторыСтрокДокументов.ДокументЗапроса
	|		И ТЗДок.ИдентификаторСтроки = TK_ВнешниеИдентификаторыСтрокДокументов.ИдентификаторСтроки
	|ГДЕ
	|	(TK_ВнешниеИдентификаторыСтрокДокументов.ДокументЗапроса,
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
	|	ТЗНом.ВнешнийID КАК ВнешнийID,
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
	|	МАКСИМУМ(НачальнаяДатаСбораПредложения),
	|	МАКСИМУМ(КонечнаяДатаСбораПредложения),
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






// Получить данные для отправки документа запрос цен поставщикам обновление.
// 
// Параметры:
//  ДокЗапроса - ДокументСсылка.TK_ЗапросЦенПоставщикам
// 
// Возвращаемое значение:
//  Структура - Получить данные для отправки документа запрос цен поставщикам обновление:
// * publicRequest 
// * currency 
// * startDate 
// * endDate 
// * description 
// * deliveryAddress 
// * deliveryTerms 
// * paymentTerms 
// * products 
Функция ПолучитьДанныеДляОтправкиДокументаЗапросЦенПоставщикам_Обновление(ДокЗапроса,ВнешнийID = "")
	Выборка = ПолучитьДанныеДокументаДокументаЗапросЦенПоставщикам(ДокЗапроса);

	СтруктураДанных = Новый Структура("id,externalId,currency,title,date,description,deliveryAddress,
									  |deliveryTerms,paymentTerms,items");

	МассивСтрок = Новый Массив;

	Пока Выборка.Следующий() Цикл

        СтруктураДанных.externalId = Строка(Выборка.Ссылка.УникальныйИдентификатор());
        СтруктураДанных.id = ВнешнийID;
		СтруктураДанных.currency = Строка(Выборка.Валюта);
		
		СтруктураДанных.title = "RFQ # " + Строка(Выборка.Номер) + " от " + Формат(Выборка.Дата,"ДФ=dd.MM.yyyy;" );
		
		ОбъектПериода = Новый Структура("from,to", Формат(Выборка.НачальнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;"),
		Формат(Выборка.КонечнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;"));
		
		СтруктураДанных.date = ОбъектПериода;
		СтруктураДанных.description = Выборка.ТекстовоеОписание;
		СтруктураДанных.deliveryAddress = Выборка.АдресДоставки;
		СтруктураДанных.deliveryTerms   = Выборка.КомментарийКУсловиямДоставки;
		СтруктураДанных.paymentTerms    = Выборка.КомментарийКУсловиямОплаты;

		ВыборкаДетали = Выборка.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Пока ВыборкаДетали.Следующий() Цикл
			СтруктураСтроки = Новый Структура("externalId,id,productId,quantity,price,deliveryDate,comment");

            СтруктураСтроки.id         = ?(ЗначениеЗаполнено(ВыборкаДетали.ВнешнийIDСтроки),ВыборкаДетали.ВнешнийIDСтроки,"");
            СтруктураСтроки.externalId = ВыборкаДетали.ИдентификаторСтроки;
			СтруктураСтроки.productId  = ВыборкаДетали.ВнешнийID;
			СтруктураСтроки.quantity   = ВыборкаДетали.Количество;
			СтруктураСтроки.price      = ВыборкаДетали.ЖелаемаяЦена;
			СтруктураСтроки.deliveryDate = Формат(ВыборкаДетали.ДатаПоставки, "ДФ=yyyy-MM-dd;");
			СтруктураСтроки.comment      = ВыборкаДетали.Комментарий;

			МассивСтрок.Добавить(СтруктураСтроки);
		КонецЦикла;

	КонецЦикла;

	СтруктураДанных.items = МассивСтрок;
	Возврат СтруктураДанных;

КонецФункции





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
	Выборка = ПолучитьДанныеДокументаДокументаЗапросЦенПоставщикам(ДокЗапроса);

	СтруктураДанных = Новый Структура("publicRequest,externalId,title,date,currency,description,deliveryAddress,
									  |deliveryTerms,paymentTerms,items");

	МассивСтрок = Новый Массив;

	Пока Выборка.Следующий() Цикл

        СтруктураДанных.externalId = Строка(Выборка.Ссылка.УникальныйИдентификатор());
		СтруктураДанных.publicRequest = Выборка.ТипЗапроса = Перечисления.TK_ТипыЗапроса.Публичный;
		СтруктураДанных.title = "RFQ # " + Строка(Выборка.Номер) + " от " + Формат(Выборка.Дата,"ДФ=dd.MM.yyyy;" );
		
		ОбъектПериода = Новый Структура("from,to", Формат(Выборка.НачальнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;"),
		Формат(Выборка.КонечнаяДатаСбораПредложения, "ДФ=yyyy-MM-dd;"));
		
		СтруктураДанных.date = ОбъектПериода;
		СтруктураДанных.currency = Строка(Выборка.Валюта);
		СтруктураДанных.description = Выборка.ТекстовоеОписание;
		СтруктураДанных.deliveryAddress = Выборка.АдресДоставки;
		СтруктураДанных.deliveryTerms   = Выборка.КомментарийКУсловиямДоставки;
		СтруктураДанных.paymentTerms    = Выборка.КомментарийКУсловиямОплаты;

		ВыборкаДетали = Выборка.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Пока ВыборкаДетали.Следующий() Цикл
			СтруктураСтроки = Новый Структура("externalId,productId,quantity,price,deliveryDate,comment");

            СтруктураСтроки.externalId = ВыборкаДетали.ИдентификаторСтроки;
			СтруктураСтроки.productId  = ВыборкаДетали.ВнешнийID;
			СтруктураСтроки.quantity   = ВыборкаДетали.Количество;
			СтруктураСтроки.price      = ВыборкаДетали.ЖелаемаяЦена;
			СтруктураСтроки.deliveryDate = Формат(ВыборкаДетали.ДатаПоставки, "ДФ=yyyy-MM-dd;");
			СтруктураСтроки.comment      = ВыборкаДетали.Комментарий;

			МассивСтрок.Добавить(СтруктураСтроки);
		КонецЦикла;

	КонецЦикла;

	СтруктураДанных.items = МассивСтрок;
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