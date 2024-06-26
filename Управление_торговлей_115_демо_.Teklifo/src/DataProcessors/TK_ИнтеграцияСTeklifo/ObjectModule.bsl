#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Авторизация 
 
// Выполняет запрос к сервису Teklifo для получения токена CSRF и Cookie, необходимых для последующих запросов.
Процедура ПолучитьCSRFТокен() Экспорт

	ТокенCSRF = "";
	Cookie = "";

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.АдресРесурса = "/api/auth/csrf";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат;
	КонецЕсли;

	ТелоJSON = HTTPОтвет.ПолучитьТелоКакСтроку();
	ДанныеОтвета = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(ТелоJSON);
	ДанныеОтвета.Свойство("csrfToken", ТокенCSRF);

	Cookie = HTTPОтвет.Заголовки.Получить("set-cookie");

КонецПроцедуры

// Выполянет поиск пользователя на Teklifo по адресу электронной почты.
// 
// Возвращаемое значение:
//  Структура, Неопределено - данные пользователя Teklifo 
Функция НайтиПользователяНаTeklifo() Экспорт

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.АдресРесурса = СтрШаблон("/api/user?&email=%1&page=1&limit=1", АдресЭлектроннойПочты);

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТелоJSON = HTTPОтвет.ПолучитьТелоКакСтроку();
	ДанныеОтвета = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(ТелоJSON);

	Если ДанныеОтвета.Свойство("result") И ДанныеОтвета.result.Количество() > 0 Тогда
		Возврат ДанныеОтвета.result[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

// Регистрация нового пользователя.
// 
// Возвращаемое значение:
//  Булево - результат регистрации нового пользователя
Функция ЗарегистрироватьНовогоПользователя() Экспорт

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();

	ПараметрыHTTPЗапроса.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");

	ПараметрыHTTPЗапроса.АдресРесурса = "/api/auth/signin/email";

	ПараметрыHTTPЗапроса.ТелоЗапроса = СтрШаблон("csrfToken=%1&email=%2&json=true&redirect=false", ТокенCSRF, СокрЛП(
		АдресЭлектроннойПочты));
		
	ПараметрыHTTPЗапроса.HTTPМетод = "POST";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Возврат HTTPОтвет <> Неопределено И HTTPОтвет.КодСостояния = 200;

КонецФункции

// Авторизация пользователя.
// 
// Возвращаемое значение:
//  Булево - Результат авторизации пользователя
Функция АвторизоватьПользователя() Экспорт

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();

	ПараметрыHTTPЗапроса.Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");

	ПараметрыHTTPЗапроса.АдресРесурса = "/api/auth/callback/credentials";

	ПараметрыHTTPЗапроса.ТелоЗапроса = СтрШаблон("csrfToken=%1&email=%2&password=%3&json=true&redirect=false",
		ТокенCSRF, СокрЛП(АдресЭлектроннойПочты), Пароль);

	ПараметрыHTTPЗапроса.HTTPМетод = "POST";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Ложь;
	КонецЕсли;

	Cookie = HTTPОтвет.Заголовки.Получить("set-cookie");
	Cookie = ИзвлечьТокенСессииИзCookie();

	Возврат ЗначениеЗаполнено(Cookie);

КонецФункции

// Сохраняет или обновляет учетную запись интеграции с Teklifo.
// 
// Возвращаемое значение:
//  СправочникСсылка.TK_УчетныеЗаписиTeklfio  
Функция СохранитьУчетнуюЗаписьИнтеграцииСTeklifo() Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_УчетныеЗаписиНаСайте.Ссылка КАК УчетнаяЗапись
						  |ИЗ
						  |	Справочник.TK_УчетныеЗаписиTeklfio КАК TK_УчетныеЗаписиНаСайте
						  |ГДЕ
						  |	TK_УчетныеЗаписиНаСайте.АдресЭлектроннойПочты = &АдресЭлектроннойПочты
						  |	И НЕ TK_УчетныеЗаписиНаСайте.ПометкаУдаления");
	Запрос.УстановитьПараметр("АдресЭлектроннойПочты", АдресЭлектроннойПочты);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		УчетнаяЗаписьОбъект = Выборка.УчетнаяЗапись.ПолучитьОбъект();
	Иначе
		УчетнаяЗаписьОбъект = Справочники.TK_УчетныеЗаписиTeklfio.СоздатьЭлемент();
		УчетнаяЗаписьОбъект.Наименование = АдресЭлектроннойПочты;
		УчетнаяЗаписьОбъект.АдресЭлектроннойПочты = АдресЭлектроннойПочты;
	КонецЕсли;

	УчетнаяЗаписьОбъект.Пароль = Пароль;
	УчетнаяЗаписьОбъект.Записать();

	Возврат УчетнаяЗаписьОбъект.Ссылка;

КонецФункции

#КонецОбласти

#Область Организации

// Возвращает таблицу организаций учетной записи.
//  
// Возвращаемое значение:
//  ТаблицаЗначений - см. НоваяТаблицаОрганизацийПользователя
Функция ТаблицаОрганизацийУчетнойЗаписи() Экспорт

	ТаблицаОрганизаций = НоваяТаблицаОрганизацийПользователя();

	ДанныеПользователяTeklifo = НайтиПользователяНаTeklifo();

	Если ДанныеПользователяTeklifo = Неопределено Тогда
		Возврат ТаблицаОрганизаций;
	КонецЕсли;

	Для Каждого ДанныеОрганизации Из ДанныеПользователяTeklifo.companies Цикл
		Если ДанныеОрганизации.companyRole.default И Не ДанныеОрганизации.company.deleted Тогда
			СтрокаТаблицы = ТаблицаОрганизаций.Добавить();
			СтрокаТаблицы.Идентификатор = ДанныеОрганизации.company.id;
			СтрокаТаблицы.Наименование = ДанныеОрганизации.company.name;
			СтрокаТаблицы.ИНН = ДанныеОрганизации.company.tin;
		КонецЕсли;
	КонецЦикла;

	Возврат ТаблицаСоответствияОрганизацийУчетнойЗаписи(ТаблицаОрганизаций);

КонецФункции

// Создать организацию на Teklifo.
// 
// Параметры:
//  ДанныеОрганизации - Структура - Данные создания организации
// 
// Возвращаемое значение:
//  Произвольный, Неопределено - данные новой организации на Teklifo
Функция СоздатьОрганизациюНаTeklifo(ДанныеОрганизации) Экспорт

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();

	ПараметрыHTTPЗапроса.Заголовки.Вставить("Content-Type", "application/json");

	ПараметрыHTTPЗапроса.АдресРесурса = "/api/company";

	ПараметрыHTTPЗапроса.ТелоЗапроса = TK_РаботаСJSONВызовСервера.СериализоватьJSON(ДанныеОрганизации);

	ПараметрыHTTPЗапроса.HTTPМетод = "POST";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТелоJSON = HTTPОтвет.ПолучитьТелоКакСтроку();

	Возврат TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(ТелоJSON);

КонецФункции

// Сохранить соответствие организаций.
// 
// Параметры:
//  ТаблицаОрганизаций - см. НоваяТаблицаОрганизацийПользователя
Процедура СохранитьСоответствиеОрганизаций(ТаблицаОрганизаций) Экспорт

	НаборЗаписей = РегистрыСведений.TK_СоответствиеОрганизацийTeklifo.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();

	Для Каждого СтрокаТаблицы Из ТаблицаОрганизаций Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
			СтрокаНабора = НаборЗаписей.Добавить();
			СтрокаНабора.Организация = СтрокаТаблицы.Организация;
			СтрокаНабора.ИдентификаторОрганизацииTeklifo = СтрокаТаблицы.Идентификатор;
			СтрокаНабора.УчетнаяЗапись = УчетнаяЗапись;
		КонецЕсли;
	КонецЦикла;

	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти

#Область Прочее

// Получить результат отправки номенклатуры.
// 
// Параметры:
//  МассивНоменклатуры - Массив Из СправочникСсылка.Номенклатура - Массив номенклатуры
//  ТокенСессии - Строка - Токен сессии
//  ИдентификаторОрганизацииTeklifo - Строка - Организация на сайте
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить результат отправки номенклатуры
Функция ПолучитьРезультатОтправкиНоменклатуры(МассивНоменклатуры, ТокенСессии = "", ОрганизацияНаСайте = "") Экспорт

	МассивДанных = Новый Массив;

	СоответствиеРеквизитовНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивНоменклатуры,
		"Наименование, Код, Марка, Марка.Код, ЕдиницаИзмерения, Описание");

	Для Каждого Номенклатура Из МассивНоменклатуры Цикл

		РеквизитыНоменклатуры = СоответствиеРеквизитовНоменклатуры[Номенклатура];

		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("externalId", Строка(Номенклатура.УникальныйИдентификатор()));
		СтруктураДанных.Вставить("name", РеквизитыНоменклатуры.Наименование);
		СтруктураДанных.Вставить("НомерДокумент", РеквизитыНоменклатуры.Код);
		СтруктураДанных.Вставить("brand", Строка(РеквизитыНоменклатуры.Марка));
		СтруктураДанных.Вставить("brandNumber", РеквизитыНоменклатуры.МаркаКод);
		СтруктураДанных.Вставить("unit", Строка(РеквизитыНоменклатуры.ЕдиницаИзмерения));
		СтруктураДанных.Вставить("description", РеквизитыНоменклатуры.Описание);
		СтруктураДанных.Вставить("archive", Ложь);

		МассивДанных.Добавить(СтруктураДанных);

	КонецЦикла;

	ТелоЗапроса = TK_РаботаСJSONВызовСервера.СериализоватьJSON(МассивДанных);
	СоединениеССервером = Соединение();

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", ТокенСессии);

	Ресурс = СтрШаблон("api/company/%1/product", ОрганизацияНаСайте);
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(Ответ);

	Возврат СтруктураДанных;

КонецФункции
 
// Получить результат отправки документа запрос цен поставщикам.
// 
// Параметры:
//  ДанныеОтправки - Структура - 
//  ТокенСессии - Строка - Токен сессии
//  ИдентификаторОрганизацииTeklifo - Строка - Организация на сайте
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить результат отправки документа запрос цен поставщикам
Функция ОпубликоватьЗапросЦенПоставщикамНаTeklifo(ДанныеОтправки, ТокенСессии = "",
	ОрганизацияНаСайте = "") Экспорт

	ТелоЗапроса = TK_РаботаСJSONВызовСервера.СериализоватьJSON(ДанныеОтправки);

	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте;

	СоединениеССервером = Соединение();

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = "api/rfq";
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("POST", HTTPЗапрос);
	Ответ = Результат.ПолучитьТелоКакСтроку();

	СтруктураДанных = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(Ответ);

	Возврат СтруктураДанных;

КонецФункции
 
// Получить результат отправки документа запрос цен поставщикам обновление.
// 
// Параметры:
//  ДанныеОтправки - Структура -
//  ИдентификаторДокумента - Строка - Идентификатор документа
//  ТокенСессии - Строка - Токен сессии
//  ИдентификаторОрганизацииTeklifo - Строка - Организация на сайте
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить результат отправки документа запрос цен поставщикам обновление
Функция ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам_Обновление(ДанныеОтправки, ИдентификаторДокумента = "",
	ТокенСессии = "", ОрганизацияНаСайте = "") Экспорт

	ТелоЗапроса = TK_РаботаСJSONВызовСервера.СериализоватьJSON(ДанныеОтправки);

	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте;

	СоединениеССервером = Соединение();

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = СтрШаблон("api/rfq/%1", ИдентификаторДокумента);
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	Результат = СоединениеССервером.ВызватьHTTPМетод("PUT", HTTPЗапрос);
	Ответ = Результат.ПолучитьТелоКакСтроку();

	Если Ответ = "" Тогда
		СтруктураДанных = Новый Структура;
	Иначе
		СтруктураДанных = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(Ответ);
	КонецЕсли;

	Возврат СтруктураДанных;

КонецФункции
 
// Получить результат документа запрос цен от клиента.
// 
// Параметры:
//  ИдентификаторДокумента - Строка - Идентификатор документа
//  ТокенСессии - Строка - Токен сессии
//  ИдентификаторОрганизацииTeklifo - Строка - Организация на сайте
// 
// Возвращаемое значение:
//  Структура, Произвольный - Получить результат документа запрос цен от клиента
Функция ПолучитьРезультатДокументаЗапросЦенОтКлиента(ИдентификаторДокумента = "", ТокенСессии = "",
	ОрганизацияНаСайте = "") Экспорт

	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте;

	СоединениеССервером = Соединение();

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = СтрШаблон("api/rfq/%1", ИдентификаторДокумента);
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	Результат = СоединениеССервером.ВызватьHTTPМетод("GET", HTTPЗапрос);
	Ответ = Результат.ПолучитьТелоКакСтроку();

	Если Ответ = "" Тогда
		СтруктураДанных = Новый Структура;
	Иначе
		СтруктураДанных = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(Ответ,
			"startDate,endDate,createdAt,updatedAt,deliveryDate");
	КонецЕсли;

	Возврат СтруктураДанных;

КонецФункции
 
// Получить результат подтверждения участия.
// 
// Параметры:
//  ИдентификаторДокумента - Строка - Идентификатор документа
//  ТокенСессии - Строка - Токен сессии
//  ИдентификаторОрганизацииTeklifo - Строка - Организация на сайте
// 
// Возвращаемое значение:
//  Структура - Получить результат подтверждения участия:
// * Подтвержден - Булево 
// * Сообщение - Строка  
Функция ПолучитьРезультатПодтвержденияУчастия(ИдентификаторДокумента = "", ТокенСессии = "", ОрганизацияНаСайте = "") Экспорт

	Cookie = ТокенСессии + ";user-company=" + ОрганизацияНаСайте;

	СоединениеССервером = Соединение();

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Cookie", Cookie);

	Ресурс = СтрШаблон("api/rfq/%1/participation", ИдентификаторДокумента);
	HTTPЗапрос = Новый HTTPЗапрос(Ресурс, Заголовки);
	Результат = СоединениеССервером.ВызватьHTTPМетод("PATCH", HTTPЗапрос);

	Подтвержден = Результат.КодСостояния = 200;

	СтруктураДанных = Новый Структура("Подтвержден,Сообщение", Подтвержден, ?(Подтвержден, "",
		"Не удалось выполнить подтверждение!"));
	Возврат СтруктураДанных;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Соединение()

	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();

	Возврат Новый HTTPСоединение("", , , , , , ЗащищенноеСоединение);

КонецФункции

#Область Авторизация

Функция ИзвлечьТокенСессииИзCookie()

	НачальныйСимвол = СтрНайти(Cookie, "__Secure-next-auth.session-token=");

	ПерваяЧастьСтроки = Сред(Cookie, НачальныйСимвол, СтрДлина(Cookie));

	КонечныйСимвол = СтрНайти(ПерваяЧастьСтроки, ";");

	ПолученнаяСтрока = Сред(ПерваяЧастьСтроки, 0, КонечныйСимвол - 1);

	Если НачальныйСимвол = 0 Тогда
		ПолученнаяСтрока = "";
	КонецЕсли;

	Возврат ПолученнаяСтрока;

КонецФункции

#КонецОбласти

#Область Организации

Функция НоваяТаблицаОрганизацийПользователя()

	ТаблицаОрганизаций = Новый ТаблицаЗначений;
	ТаблицаОрганизаций.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка", ,
		Новый КвалификаторыСтроки(100)));
	ТаблицаОрганизаций.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	ТаблицаОрганизаций.Колонки.Добавить("ИНН", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(10)));
	ТаблицаОрганизаций.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));

	Возврат ТаблицаОрганизаций;

КонецФункции

Функция ТаблицаСоответствияОрганизацийУчетнойЗаписи(ТаблицаОрганизаций)

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	ТаблицаОрганизаций.Идентификатор КАК Идентификатор,
						  |	ТаблицаОрганизаций.Наименование КАК Наименование,
						  |	ТаблицаОрганизаций.ИНН КАК ИНН
						  |ПОМЕСТИТЬ ВТ_Организации
						  |ИЗ
						  |	&ТаблицаОрганизаций КАК ТаблицаОрганизаций
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВТ_Организации.Идентификатор КАК Идентификатор,
						  |	ВТ_Организации.Наименование КАК Наименование,
						  |	ВТ_Организации.ИНН КАК ИНН,
						  |	МАКСИМУМ(ЕСТЬNULL(TK_СоответствияОрганизаций.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))) КАК
						  |		Организация
						  |ПОМЕСТИТЬ ВТ_Данные
						  |ИЗ
						  |	ВТ_Организации КАК ВТ_Организации
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_СоответствиеОрганизацийTeklifo КАК TK_СоответствияОрганизаций
						  |		ПО ВТ_Организации.Идентификатор = TK_СоответствияОрганизаций.ИдентификаторОрганизацииTeklifo
						  |		И TK_СоответствияОрганизаций.УчетнаяЗапись = &УчетнаяЗапись
						  |СГРУППИРОВАТЬ ПО
						  |	ВТ_Организации.Идентификатор,
						  |	ВТ_Организации.Наименование,
						  |	ВТ_Организации.ИНН
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВТ_Данные.Идентификатор КАК Идентификатор,
						  |	ВТ_Данные.Наименование КАК Наименование,
						  |	ВТ_Данные.ИНН КАК ИНН,
						  |	МАКСИМУМ(ВЫБОР
						  |		КОГДА ВТ_Данные.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
						  |			ТОГДА ВТ_Данные.Организация
						  |		ИНАЧЕ ЕСТЬNULL(Организации.Ссылка, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
						  |	КОНЕЦ) КАК Организация
						  |ИЗ
						  |	ВТ_Данные КАК ВТ_Данные
						  |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
						  |		ПО ВТ_Данные.ИНН = Организации.ИНН
						  |		И НЕ Организации.ПометкаУдаления
						  |СГРУППИРОВАТЬ ПО
						  |	ВТ_Данные.Идентификатор,
						  |	ВТ_Данные.Наименование,
						  |	ВТ_Данные.ИНН");
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Запрос.УстановитьПараметр("ТаблицаОрганизаций", ТаблицаОрганизаций);

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

#КонецОбласти

#Область HTTP

Функция ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса)

	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();

	HTTPСоединение = Новый HTTPСоединение("teklifo.com", , , , , , ЗащищенноеСоединение);

	ПараметрыHTTPЗапроса.Заголовки.Вставить("Accept-Language", "ru");
	ПараметрыHTTPЗапроса.Заголовки.Вставить("Cookie", "NEXT_LOCALE=ru;" + Cookie);

	HTTPЗапрос = Новый HTTPЗапрос(ПараметрыHTTPЗапроса.АдресРесурса, ПараметрыHTTPЗапроса.Заголовки);

	Если ЗначениеЗаполнено(ПараметрыHTTPЗапроса.ТелоЗапроса) Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(ПараметрыHTTPЗапроса.ТелоЗапроса);
	КонецЕсли;

	Попытка
		Возврат HTTPСоединение.ВызватьHTTPМетод(ПараметрыHTTPЗапроса.HTTPМетод, HTTPЗапрос);
	Исключение
		Возврат Неопределено;
	КонецПопытки;

КонецФункции

Функция НоваяСтруктураПараметровHTTPЗапроса()

	Структура = Новый Структура;
	Структура.Вставить("АдресРесурса", "");
	Структура.Вставить("HTTPМетод", "GET");
	Структура.Вставить("Заголовки", Новый Соответствие);
	Структура.Вставить("ТелоЗапроса", "");

	Возврат Структура;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли