Перем АдресСервера;

 
 // Получить результат отправки номенклатуры.
 // 
 // Параметры:
 //  МассивНоменклатуры - Массив из СправочникСсылка.Номенклатура
 //  ТокенСессии - Строка
 //  ОрганизацияНаСайте - Строка
 // Возвращаемое значение:
 //  Структура, Неопределено - Получить результат отправки номенклатуры
 Функция ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры,ТокенСессии = "",ОрганизацияНаСайте="") Экспорт
 	
 	МассивДанных = Новый Массив();
 	
 	Для Каждого Номенклатура Из МассивНоменклатуры Цикл
 		СтруктураДанных = Новый Структура;
 		СтруктураДанных.Вставить("externalId",Строка(Номенклатура.УникальныйИдентификатор()));
 		СтруктураДанных.Вставить("name",Номенклатура.Наименование);
 		СтруктураДанных.Вставить("number",Номенклатура.Код);
 		СтруктураДанных.Вставить("brand",Строка(Номенклатура.Марка));
 		СтруктураДанных.Вставить("brandNumber",Номенклатура.Марка.Код);
 		СтруктураДанных.Вставить("unit",Строка(Номенклатура.ЕдиницаИзмерения));
 		СтруктураДанных.Вставить("description",Номенклатура.Описание);
 		СтруктураДанных.Вставить("archive",Ложь);
 		МассивДанных.Добавить(СтруктураДанных);
 	КонецЦикла;
 	
 	ТелоЗапроса = TK_РаботаСWeb.СериализоватьJSON(МассивДанных);
 	
 	
 	
 	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", ТокенСессии);

	Ресурс = СтрШаблон("api/company/%1/product",ОрганизацияНаСайте);



	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура
 	
 	
 	
 	Возврат СтруктураДанных;
 	
 КонецФункции
 
 
 
 // Получить результат отправки документа запрос цен поставщикам.
 // 
 // Параметры:
 //  ДанныеОтправки - Структура - 
 //  ТокенСессии - Строка - Токен сессии
 //  ОрганизацияНаСайте - Строка - Организация на сайте
 // 
 // Возвращаемое значение:
 //  Структура, Произвольный - Получить результат отправки документа запрос цен поставщикам
   Функция ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам(ДанныеОтправки,ТокенСессии = "",ОрганизацияНаСайте = "") Экспорт
 	ТелоЗапроса = TK_РаботаСWeb.СериализоватьJSON(ДанныеОтправки);
 	
 	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте; 
 	
 	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = "api/rfq";



	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура
	
	Возврат СтруктураДанных;
 КонецФункции
 
 
 
 // Получить результат отправки документа запрос цен поставщикам обновление.
 // 
 // Параметры:
 //  ИдентификаторДокумента - Строка - Идентификатор документа
 //  ДанныеОтправки - Структура -
 //  ТокенСессии - Строка - Токен сессии
 //  ОрганизацияНаСайте - Строка - Организация на сайте
 // 
 // Возвращаемое значение:
 //  Структура, Произвольный - Получить результат отправки документа запрос цен поставщикам обновление
 Функция ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам_Обновление(ИдентификаторДокумента = "",ДанныеОтправки,ТокенСессии = "",ОрганизацияНаСайте = "") Экспорт
 	ТелоЗапроса = TK_РаботаСWeb.СериализоватьJSON(ДанныеОтправки);
 	
 	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте; 
 	
 	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = СтрШаблон("api/rfq/%1",ИдентификаторДокумента);



	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("PUT", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

    Если Ответ = "" Тогда
        СтруктураДанных = Новый Структура;
    Иначе
        СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура    		
    КонецЕсли;
	
	
	Возврат СтруктураДанных;
 КонецФункции
 
 
 
 
  // Получить результат документа запрос цен от клиента.
  // 
  // Параметры:
  //  ИдентификаторДокумента - Строка - Идентификатор документа
  //  ТокенСессии - Строка - Токен сессии
  //  ОрганизацияНаСайте - Строка - Организация на сайте
  // 
  // Возвращаемое значение:
  //  Структура, Произвольный - Получить результат документа запрос цен от клиента
  Функция ПолучитьРезультатДокументаЗапросЦенОтКлиента(ИдентификаторДокумента = "",ТокенСессии = "",ОрганизацияНаСайте = "") Экспорт
 
 	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте; 
 	
 	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = СтрШаблон("api/rfq/%1",ИдентификаторДокумента);



	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	Результат = СоединениеССервером.ВызватьHTTPМетод("GET", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

//    Ответ = Константы.TK_Константа_ВременнаяСтрока.Получить();

    Если Ответ = "" Тогда
        СтруктураДанных = Новый Структура;
    Иначе
        СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ,"startDate,endDate,createdAt,updatedAt,deliveryDate");//Структура    		
    КонецЕсли;
	
	
	Возврат СтруктураДанных;
 КонецФункции
 
 
 
 
  // Получить результат документа запрос цен от клиента проверка.
  // 
  // Параметры:
  //  ИдентификаторДокумента - Строка - Идентификатор документа
  //  ТокенСессии - Строка - Токен сессии
  //  ОрганизацияНаСайте - Строка - Организация на сайте
  // 
  // Возвращаемое значение:
  //  Структура, Произвольный - Получить результат документа запрос цен от клиента проверка
  Функция ПолучитьРезультатДокументаЗапросЦенОтКлиентаПроверка(ИдентификаторДокумента = "",ТокенСессии = "",ОрганизацияНаСайте = "") Экспорт
 
 	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте; 
 	
 	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = СтрШаблон("api/rfq/%1/preview",ИдентификаторДокумента);



	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	Результат = СоединениеССервером.ВызватьHTTPМетод("GET", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();


    Если Ответ = "" Тогда
        СтруктураДанных = Новый Структура;
    Иначе
        СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ,"startDate,endDate,createdAt,updatedAt,deliveryDate");//Структура    		
    КонецЕсли;
	
	
	Возврат СтруктураДанных;
 КонецФункции
 
 
 
 
 // Получить результат подтверждения участия.
 // 
 // Параметры:
 //  ИдентификаторДокумента - Строка - Идентификатор документа
 //  ТокенСессии - Строка - Токен сессии
 //  ОрганизацияНаСайте - Строка - Организация на сайте
 // 
 // Возвращаемое значение:
 //  Структура - Получить результат подтверждения участия:
 // * Подтвержден - Булево - 
 // * Сообщение - Строка -  
  Функция ПолучитьРезультатПодтвержденияУчастия(ИдентификаторДокумента = "",ТокенСессии = "",ОрганизацияНаСайте = "") Экспорт
 
// 	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте; 
// 	
// 	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение
//
//	Заголовки = Новый Соответствие;
//	Заголовки.Вставить("Content-Type", "application/json");
//	Заголовки.Вставить("Cookie", Cookie);
//
//	Ресурс = СтрШаблон("api/rfq/%1/participation",ИдентификаторДокумента);
//
//
//
//	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
//	Результат = СоединениеССервером.ВызватьHTTPМетод("PATCH", HTTPЗапрос);//HTTPОтвет
	
//	Подтвержден = Результат.КодСостояния = 200;

    Подтвержден = Истина;
	
    СтруктураДанных = Новый Структура("Подтвержден,Сообщение",Подтвержден,?(Подтвержден,"","Не удалось выполнить подтверждение!")); 
   
	
	Возврат СтруктураДанных;
 КонецФункции
 
 
 
 
 // Выполнить сохранение данных.
 // 
 // Параметры:
 //  ТаблицаОрганизаций -ТаблицаЗначений
Процедура ВыполнитьСохранениеДанных(ТаблицаОрганизаций) Экспорт
	УчетнаяЗапись = ПолучитьУчетнуюЗапись();
	СохранитьДанныеСоответствия(УчетнаяЗапись, ТаблицаОрганизаций);
КонецПроцедуры
 
 
 // Сохранить данные соответствия.
 // 
 // Параметры:
 //УчетнаяЗапись - СправочникСсылка.TK_УчетныеЗаписиНаСайте
 // ТаблицаОрганизаций -ТаблицаЗначений
Процедура СохранитьДанныеСоответствия(УчетнаяЗапись, ТаблицаОрганизаций)

	НаборЗаписей = РегистрыСведений.TK_СоответствияОрганизаций.СоздатьНаборЗаписей();
// 	НаборЗаписей.Отбор.УчетнаяЗапись.Установить(УчетнаяЗапись);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();

	ТаблицаДляЗагрузки = ПолучитьТаблицуДляЗагрузки(ТаблицаОрганизаций);

	Для Каждого ДанныеТаблицы Из ТаблицаДляЗагрузки Цикл
		СтрокаНабора = НаборЗаписей.Добавить();
		СтрокаНабора.УчетнаяЗапись = УчетнаяЗапись;
		СтрокаНабора.Организация = ДанныеТаблицы.ОрганизацияВ1С;
		СтрокаНабора.ОрганизацияНаСайте = ДанныеТаблицы.ИДОрганизации;
	КонецЦикла;

	НаборЗаписей.Записать();

КонецПроцедуры
 
 
 // Получить таблицу для загрузки.
 // 
 // Параметры:
  // ТаблицаОрганизаций -ТаблицаЗначений
 // 
 // Возвращаемое значение:
  // ТаблицаОрганизаций -ТаблицаЗначений  
Функция ПолучитьТаблицуДляЗагрузки(ТаблицаОрганизаций)

	МассивПустыхСтрок = ТаблицаОрганизаций.НайтиСтроки(Новый Структура("ОрганизацияВ1С",
		Справочники.Организации.ПустаяСсылка()));

	Для Каждого Элемент Из МассивПустыхСтрок Цикл
		ТаблицаОрганизаций.Удалить(Элемент);
	КонецЦикла;
	Возврат ТаблицаОрганизаций;

КонецФункции
 
 

 // Получить учетную запись.
 // 
 // Возвращаемое значение:
 //  СправочникСсылка.TK_УчетныеЗаписиНаСайте  
Функция ПолучитьУчетнуюЗапись() Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_УчетныеЗаписиНаСайте.Ссылка
						  |ИЗ
						  |	Справочник.TK_УчетныеЗаписиНаСайте КАК TK_УчетныеЗаписиНаСайте
						  |ГДЕ
						  |	TK_УчетныеЗаписиНаСайте.Email = &Email
						  |	И НЕ TK_УчетныеЗаписиНаСайте.ПометкаУдаления");
	Запрос.УстановитьПараметр("Email", Email);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если Выборка.Количество() > 0 Тогда
		Возврат ОбновитьПарольУчетнойЗаписи(Выборка.Ссылка); //  СправочникСсылка.TK_УчетныеЗаписиНаСайте
	КонецЕсли;

	УчетнаяЗапись = Справочники.TK_УчетныеЗаписиНаСайте.СоздатьЭлемент();
	УчетнаяЗапись.Наименование = Email;
	УчетнаяЗапись.Email = Email;
	УчетнаяЗапись.Пароль = Пароль;
	УчетнаяЗапись.Записать();
	Возврат УчетнаяЗапись.Ссылка;  //  СправочникСсылка.TK_УчетныеЗаписиНаСайте

КонецФункции
 

// Обновить пароль учетной записи.
// 
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.TK_УчетныеЗаписиНаСайте
// 
// Возвращаемое значение:
// УчетнаяЗапись - СправочникСсылка.TK_УчетныеЗаписиНаСайте 
Функция ОбновитьПарольУчетнойЗаписи(УчетнаяЗапись)

	Если УчетнаяЗапись.Пароль = Пароль Тогда
		Возврат УчетнаяЗапись;
	КонецЕсли;

	УчетнаяЗаписьОбъект = УчетнаяЗапись.ПолучитьОбъект();
	УчетнаяЗаписьОбъект.Пароль = Пароль;
	УчетнаяЗаписьОбъект.Записать();

	Возврат УчетнаяЗаписьОбъект.Ссылка;

КонецФункции




// Получить результат создания организации на сайте.
// 
// Параметры:
//  СтруктураПараметров Структура параметров
//  ТокенСессии - Строка - Токен сессии
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить результат создания организации на сайте
функция ПолучитьРезультатСозданияОрганизацииНаСайте(СтруктураПараметров, ТокенСессии = "") Экспорт

	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", ТокенСессии);

	Ресурс = "api/company";

	ТелоЗапроса = TK_РаботаСWeb.СериализоватьJSON(СтруктураПараметров);

	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура
	
	Возврат СтруктураДанных;
КонецФункции
 
 
 
 
 
 // Выполнить авторизацию.
 // 
 // Параметры:
//  СтруктураТокенов-Структура - Структура Токенов:
// * csrfToken 
// * ТокенИзCookie 
 //  УжеЗарегистрирован - Булево - Уже зарегистрирован
Процедура ВыполнитьАвторизацию(СтруктураТокенов, УжеЗарегистрирован = Ложь) Экспорт
	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	СтруктураТокенов =  ПолучитьТокены(СоединениеССервером);//Структура

	УжеЗарегистрирован =  ПользовательЗарегистрированВСистеме(СоединениеССервером);

КонецПроцедуры



// Зарегистрировать пользователя.
// 
// Параметры:
//  СтруктураТокенов-Структура - Структура Токенов:
// * csrfToken 
// * ТокенИзCookie 
Процедура ЗарегистрироватьПользователя(СтруктураТокенов) Экспорт
	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Заголовки.Вставить("Cookie", "NEXT_LOCALE=ru;" + СтруктураТокенов.ТокенИзCookie);

	Ресурс = "api/auth/signin/email";

	ТелоЗапроса = СтрШаблон("csrfToken=%1&email=%2&json=true&redirect=false&callbakUrl=http://%3",
		СтруктураТокенов.csrfToken, СокрЛП(Email), АдресСервера);

	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура
КонецПроцедуры



// Получить токен сессии.
// 
// Параметры:
//  СтруктураТокенов-Структура - Структура Токенов:
// * csrfToken 
// * ТокенИзCookie 
// 
// Возвращаемое значение:
//  Строка - Получить токен сессии
Функция ПолучитьТокенСессии(СтруктураТокенов) Экспорт

	СоединениеССервером = ПолучитьСоединение();//HTTPСоединение

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Заголовки.Вставить("Cookie", "NEXT_LOCALE=ru;" + СтруктураТокенов.ТокенИзCookie);

	Ресурс = "api/auth/callback/credentials";

	ТелоЗапроса = СтрШаблон("csrfToken=%1&email=%2&password=%3&json=true&redirect=false&callbakUrl=http://%4",
		СтруктураТокенов.csrfToken, СокрЛП(Email), СокрЛП(Пароль), АдресСервера);

	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтрокаКуки = Результат.Заголовки.Получить("set-cookie");

	НачальныйСимвол = СтрНайти(СтрокаКуки, "__Secure-next-auth.session-token=");

	ПерваяЧастьСтроки = Сред(СтрокаКуки, НачальныйСимвол, СтрДлина(СтрокаКуки));

	КонечныйСимвол = СтрНайти(ПерваяЧастьСтроки, ";");

	ПолученнаяСтрока = Сред(ПерваяЧастьСтроки, 0, КонечныйСимвол - 1);
	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура

	Если НачальныйСимвол = 0 Тогда
		ПолученнаяСтрока = "";
	КонецЕсли;
	Возврат ПолученнаяСтрока;

КонецФункции



// Пользователь зарегистрирован в системе.
// 
// Параметры:
//  СоединениеССервером - HTTPСоединение - Соединение с сервером
// 
// Возвращаемое значение:
//  Булево - Пользователь зарегистрирован в системе
Функция ПользовательЗарегистрированВСистеме(СоединениеССервером) Экспорт

	СтруктураДанных = ДанныеПроверкиПользователя(СоединениеССервером);

	Если СтруктураДанных.Свойство("result") И СтруктураДанных.result.Количество() > 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции




// Получить данные пользователя.
// 
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.TK_УчетныеЗаписиНаСайте
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить данные пользователя
Функция ПолучитьДанныеПользователя(УчетнаяЗапись) Экспорт

	КвалификаторСтроки = Новый КвалификаторыСтроки(256, ДопустимаяДлина.Фиксированная);

	СтруктураДанных = ДанныеПроверкиПользователя();

	ТаблицаОрганизаций = Новый ТаблицаЗначений;
//	ТаблицаОрганизаций.Колонки.Добавить("ДанныеОрганизации");
	ТаблицаОрганизаций.Колонки.Добавить("ИДОрганизации", Новый ОписаниеТипов("Строка", , КвалификаторСтроки));
	ТаблицаОрганизаций.Колонки.Добавить("НаименованиеОрганизации", Новый ОписаниеТипов("Строка", , КвалификаторСтроки));
	ТаблицаОрганизаций.Колонки.Добавить("ИННОрганизации", Новый ОписаниеТипов("Строка", , КвалификаторСтроки));
	ТаблицаОрганизаций.Колонки.Добавить("ОрганизацияВ1С");
	Если СтруктураДанных.Свойство("result") Тогда

		РезультатДанных = СтруктураДанных.result;//Массив
		Данные = ?(РезультатДанных.Количество() > 0, РезультатДанных.Получить(0), Неопределено);
		КомпанииНаСайте = Данные.companies;//Массив

		Для Каждого Орг Из КомпанииНаСайте Цикл
			Если Орг.companyRole.default Тогда
				СтрокаТЗ = ТаблицаОрганизаций.Добавить();
				СтрокаТЗ.ИДОрганизации = Орг.company.id;
				СтрокаТЗ.НаименованиеОрганизации = Орг.company.name;
				СтрокаТЗ.ИННОрганизации = Орг.company.tin;
//				СтрокаТЗ.ДанныеОрганизации = Орг.company;
				СтрокаТЗ.ОрганизацияВ1С = Справочники.Организации.НайтиПоРеквизиту("Инн", Орг.company.tin);
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;
	Возврат ПолучитьСоответствияОрганизаций(ТаблицаОрганизаций, УчетнаяЗапись);
КонецФункции


// Получить соответствия организаций.
// 
// Параметры:
//  ТаблицаОрганизаций - ТаблицаЗначений
//  УчетнаяЗапись - СправочникСсылка.TK_УчетныеЗаписиНаСайте
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Получить соответствия организаций
Функция ПолучитьСоответствияОрганизаций(ТаблицаОрганизаций, УчетнаяЗапись)

	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат ТаблицаОрганизаций;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ТаблицаОрганизаций.ИДОрганизации,
				   |	ТаблицаОрганизаций.НаименованиеОрганизации,
				   |	ТаблицаОрганизаций.ИННОрганизации
				   |ПОМЕСТИТЬ ВТ_Орг
				   |ИЗ
				   |	&ТаблицаОрганизаций КАК ТаблицаОрганизаций
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВТ_Орг.ИДОрганизации,
				   |	ВТ_Орг.НаименованиеОрганизации,
				   |	ВТ_Орг.ИННОрганизации,
				   |	TK_СоответствияОрганизаций.Организация КАК ОрганизацияВ1С
				   |ПОМЕСТИТЬ ТЗ
				   |ИЗ
				   |	ВТ_Орг КАК ВТ_Орг
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_СоответствияОрганизаций КАК TK_СоответствияОрганизаций
				   |		ПО ВТ_Орг.ИДОрганизации = TK_СоответствияОрганизаций.ОрганизацияНаСайте
				   |ГДЕ
				   |	TK_СоответствияОрганизаций.УчетнаяЗапись = &УчетнаяЗапись
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВТ_Орг.ИДОрганизации,
				   |	ВТ_Орг.НаименованиеОрганизации,
				   |	ВТ_Орг.ИННОрганизации,
				   |	ТЗ.ОрганизацияВ1С
				   |ИЗ
				   |	ВТ_Орг КАК ВТ_Орг
				   |		ЛЕВОЕ СОЕДИНЕНИЕ ТЗ КАК ТЗ
				   |		ПО ВТ_Орг.ИДОрганизации = ТЗ.ИДОрганизации";
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ТаблицаОрганизаций", ТаблицаОрганизаций);

	Выборка = Запрос.Выполнить().Выгрузить();
	Возврат Выборка;

КонецФункции


// Данные проверки пользователя.
// 
// Параметры:
//  СоединениеССервером - HTTPСоединение,Неопределено - Соединение с сервером
// 
// Возвращаемое значение:
//  Структура, Произвольный - Данные проверки пользователя
Функция ДанныеПроверкиПользователя(СоединениеССервером = Неопределено)

	Если СоединениеССервером = Неопределено Тогда
		СоединениеССервером = ПолучитьСоединение();//HTTPСоединение
	КонецЕсли;

	Заголовки = Новый Соответствие;

	Ресурс = "api/user";

	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.АдресРесурса = Ресурс + "?email=" + СокрЛП(Email) + "&page=1&limit=10";
	Результат = СоединениеССервером.Получить(HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура

	Возврат СтруктураДанных;

КонецФункции




//Получить Токены.
// 
// Параметры:
//  СоединениеССервером - HTTPСоединение - Соединение с сервером
// 
// Возвращаемое значение:
//  Структура - Получитьcsrf token:
// * csrfToken 
// * ТокенИзCookie 
Функция ПолучитьТокены(СоединениеССервером)
	csrfToken = "";

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("csrfToken");
	СтруктураВозврата.Вставить("ТокенИзCookie");

	Заголовки = Новый Соответствие;

	HTTPЗапрос = Новый HTTPЗапрос("api/auth/csrf", Заголовки);
	Результат = СоединениеССервером.Получить(HTTPЗапрос);//HTTPОтвет
	Ответ = Результат.ПолучитьТелоКакСтроку();

	ТокенИзCookie = Результат.Заголовки.Получить("set-cookie");

	СтруктураДанных = TK_РаботаСWeb.ПолучитьДанныеИзJSON(Ответ);//Структура

	Если СтруктураДанных.Свойство("csrfToken") Тогда
		csrfToken = СтруктураДанных.csrfToken;
	КонецЕсли;

	СтруктураВозврата.csrfToken =  csrfToken;
	СтруктураВозврата.ТокенИзCookie = ТокенИзCookie;

	Возврат СтруктураВозврата;
КонецФункции


// Получить соединение.
// 
// Возвращаемое значение:
//  HTTPСоединение - Получить соединение
Функция ПолучитьСоединение()
	Возврат Новый HTTPСоединение(АдресСервера, , , , , , Новый ЗащищенноеСоединениеOpenSSL);
КонецФункции


АдресСервера = "teklifo.com";