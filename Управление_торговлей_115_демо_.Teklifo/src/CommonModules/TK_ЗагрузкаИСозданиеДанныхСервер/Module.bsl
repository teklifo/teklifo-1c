
// Загрузить документ запрос цен от клиента.
// 
// Параметры:
//  ДанныеЗагрузки - Структура - Загрузить документ запрос цен от клиента:
// * versionId 
// * id 
// * externalId 
// * number 
// * companyId 
// * privateRequest 
// * userId 
// * title 
// * currency 
// * startDate 
// * endDate 
// * description 
// * deliveryAddress 
// * deliveryTerms 
// * paymentTerms 
// * createdAt 
// * latestVersion 
// * deleted 
// * company - Структура - :
// ** id 
// ** name 
// ** tin 
// ** description 
// ** descriptionRu 
// ** slogan 
// ** sloganRu 
// ** createdAt 
// ** updatedAt 
// ** deleted 
// * items - Массив из Структура - 
// * participants - Массив из Структура - Данные загрузки
//  Организация - СправочникСсылка.Организации - Организация
// 
// Возвращаемое значение:
//  Структура - Загрузить документ запрос цен от клиента:
// * ДокЗапроса - ДокументСсылка.TK_ЗапросЦенОтКлиента - 
// * id 
// * number 
// * latestVersion 
// * versionId
Функция ЗагрузитьДокументЗапросЦенОтКлиента(ДанныеЗагрузки,Организация) Экспорт
	
	ДанныеНайденногоДокумента = TK_ОбщегоНазначенияСервер.ПолучитьДанныеДокументаЗапросаЦенОтКлиентаПоВнешнемуID(ДанныеЗагрузки.versionId);
	
	ДокументЗапросЦен = ДанныеНайденногоДокумента.ДокументЗапроса;
	
	Если Не ЗначениеЗаполнено(ДокументЗапросЦен) Тогда
      ДокументЗапросЦенОбъект = Документы.TK_ЗапросЦенОтКлиента.СоздатьДокумент();	
	Иначе
      ДокументЗапросЦенОбъект = ДокументЗапросЦен.ПолучитьОбъект();		
	КонецЕсли;
	
	ДокументЗапросЦенОбъект.Дата = ДанныеЗагрузки.createdAt;
	ДокументЗапросЦенОбъект.Организация = Организация;
	ДокументЗапросЦенОбъект.Валюта      = Справочники.Валюты.НайтиПоНаименованию(ДанныеЗагрузки.currency, Истина);
	Если ДанныеЗагрузки.privateRequest Тогда
      ДокументЗапросЦенОбъект.ТипЗапроса = Перечисления.TK_ТипыЗапроса.Закрытый;
	Иначе
      ДокументЗапросЦенОбъект.ТипЗапроса = Перечисления.TK_ТипыЗапроса.Публичный;		  		
	КонецЕсли;
	
	ДокументЗапросЦенОбъект.НачальнаяДатаСбораПредложения = ДанныеЗагрузки.startDate;
	ДокументЗапросЦенОбъект.КонечнаяДатаСбораПредложения  = ДанныеЗагрузки.endDate;
	ДокументЗапросЦенОбъект.ТекстовоеОписание             = ДанныеЗагрузки.description;
	ДокументЗапросЦенОбъект.АдресДоставки                 = ДанныеЗагрузки.deliveryAddress;
	ДокументЗапросЦенОбъект.КомментарийКУсловиямДоставки  = ДанныеЗагрузки.deliveryTerms;
	ДокументЗапросЦенОбъект.КомментарийКУсловиямОплаты    = ДанныеЗагрузки.paymentTerms;
	
	ДокументЗапросЦенОбъект.Партнер = ПолучитьПартнера(ДанныеЗагрузки.company.tin,ДанныеЗагрузки.company.id ,
	ДанныеЗагрузки.company.name ,Ложь,Истина);
	
	ДокументЗапросЦенОбъект.Товары.Очистить();
	
	Для Каждого СтрокаТоваров Из ДанныеЗагрузки.items Цикл
		ДанныеПозиции = ПолучитьСтрокуПозиции(СтрокаТоваров);	
		
		Ном = ПолучитьНоменклатуруКонтрагента(ДанныеПозиции,ДокументЗапросЦенОбъект.Партнер);
		
		Если ЗначениеЗаполнено(Ном) Тогда
			СтрокаТЧ = ДокументЗапросЦенОбъект.Товары.Добавить();
			СтрокаТЧ.Номенклатура = Ном;
			СтрокаТЧ.Количество = ДанныеПозиции.quantity;
			СтрокаТЧ.ЖелаемаяЦена = ДанныеПозиции.price;
			СтрокаТЧ.ДатаПоставки = ДанныеПозиции.deliveryDate;
			СтрокаТЧ.Комментарий  = ДанныеПозиции.comment;
		КонецЕсли;
		
	КонецЦикла;
	
	
//	Для Каждого СтрокаУчастника Из ДанныеЗагрузки.participants Цикл
//		ДанныеУчастника = ПолучитьДанныеУчастника(СтрокаУчастника);	
//	КонецЦикла;
	
	ДокументЗапросЦенОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	
	
	СтруктураОтвета = Новый Структура("ДокЗапроса,id,number,latestVersion,versionId",ДокументЗапросЦенОбъект.Ссылка,ДанныеЗагрузки.id,
	ДанныеЗагрузки.number,ДанныеЗагрузки.latestVersion,ДанныеЗагрузки.versionId);
	
	
	Возврат СтруктураОтвета;
	
КонецФункции



// Получить номенклатуру контрагента.
// 
// Параметры:
//  ДанныеПозиции -  Структура - Данные позиции:
// * versionId 
// * id 
// * externalId 
// * requestForQuotationId 
// * productId 
// * comment 
// * quantity 
// * price 
// * deliveryDate 
// * product - Структура - :
// ** id 
// ** externalId 
// ** productId 
// ** characteristicId 
// ** name 
// ** number 
// ** brand 
// ** brandNumber 
// ** unit 
// ** description 
// ** archive 
// ** companyId 
// ** createdAt 
// ** updatedAt 
// ** deleted 
// 
// Владелец - СправочникСсылка.Партнеры
// Возвращаемое значение:
//  СправочникСсылка.НоменклатураКонтрагентов - Получить номенклатуру контрагента
Функция ПолучитьНоменклатуруКонтрагента(ДанныеПозиции,Владелец)
	
	Номенклатура = Справочники.НоменклатураКонтрагентов.НайтиПоРеквизиту("Идентификатор",СокрЛП(ДанныеПозиции.product.externalId));
	
	Если  ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Номенклатура;
	КонецЕсли;
	
	НоменклатураОбъект = Справочники.НоменклатураКонтрагентов.СоздатьЭлемент();
	НоменклатураОбъект.Наименование = СокрЛП(ДанныеПозиции.product.name);
	НоменклатураОбъект.НаименованиеПолное = СокрЛП(ДанныеПозиции.product.name);
	НоменклатураОбъект.Идентификатор = СокрЛП(ДанныеПозиции.product.externalId);
	НоменклатураОбъект.Артикул = СокрЛП(ДанныеПозиции.product.number);
	НоменклатураОбъект.ВладелецНоменклатуры = Владелец;
	НоменклатураОбъект.Владелец = Владелец;
	НоменклатураОбъект.НаименованиеУпаковки =  СокрЛП(ДанныеПозиции.product.unit);
	НоменклатураОбъект.НаименованиеБазовойЕдиницыИзмерения =  СокрЛП(ДанныеПозиции.product.unit);
	
	НоменклатураОбъект.Записать();
	
	
	Возврат НоменклатураОбъект.Ссылка;
	
КонецФункции





// Получить партнера.
// 
// Параметры:
//  ИНН - Строка - ИНН
//  id - Строка - Id
//  НаименованиеКонтрагента - Строка - Наименование контрагента
//  ЭтоПоставщик - Булево - Это поставщик
//  ЭтоКлиент - Булево - Это клиент
// 
// Возвращаемое значение:
//  СправочникСсылка.Партнеры - Получить партнера
Функция ПолучитьПартнера(ИНН = "",id = "", НаименованиеКонтрагента = "", ЭтоПоставщик = Ложь, ЭтоКлиент = Ложь)
    
    СсылкаПартнера = Справочники.Партнеры.НайтиПоРеквизиту("TK_IdПартнера", СокрЛП(id));
    
    Если ЗначениеЗаполнено(СсылкаПартнера) Тогда
    	Возврат СсылкаПартнера;
    КонецЕсли;
    
    ПартнерОбъект = Справочники.Партнеры.СоздатьЭлемент();
    ПартнерОбъект.Наименование = НаименованиеКонтрагента;
    ПартнерОбъект.НаименованиеПолное = НаименованиеКонтрагента;
    ПартнерОбъект.TK_IdПартнера = СокрЛП(id);
    ПартнерОбъект.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.Компания;
    ПартнерОбъект.Поставщик = ЭтоПоставщик;
    ПартнерОбъект.Клиент = ЭтоКлиент;
    ПартнерОбъект.Записать();
    СсылкаПартнера = ПартнерОбъект.Ссылка;
        
    КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент();
    КонтрагентОбъект.Наименование = НаименованиеКонтрагента;
    КонтрагентОбъект.НаименованиеПолное = НаименованиеКонтрагента;    
    КонтрагентОбъект.ИНН = ИНН;
    КонтрагентОбъект.Партнер = СсылкаПартнера;
    КонтрагентОбъект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
    КонтрагентОбъект.Записать();
    
    Возврат СсылкаПартнера;
    
КонецФункции



// Получить данные участника.
// 
// Параметры:
//  СтрокаУчастника - Структура - Строка участника
// 
// Возвращаемое значение:
//  Структура - Получить данные участника:
// * requestForQuotationId 
// * companyId 
Функция ПолучитьДанныеУчастника(СтрокаУчастника)
	Возврат СтрокаУчастника;
КонецФункции



// Получить строку позиции.
// 
// Параметры:
//  СтрокиТоваров - Структура - Строки товаров
// 
// Возвращаемое значение:
//  Структура - Получить строку позиций:
// * versionId 
// * id 
// * externalId 
// * requestForQuotationId 
// * productId 
// * comment 
// * quantity 
// * price 
// * deliveryDate 
// * product - Структура - :
// ** id 
// ** externalId 
// ** productId 
// ** characteristicId 
// ** name 
// ** number 
// ** brand 
// ** brandNumber 
// ** unit 
// ** description 
// ** archive 
// ** companyId 
// ** createdAt 
// ** updatedAt 
// ** deleted 
Функция ПолучитьСтрокуПозиции(СтрокиТоваров)
	Возврат СтрокиТоваров;
КонецФункции