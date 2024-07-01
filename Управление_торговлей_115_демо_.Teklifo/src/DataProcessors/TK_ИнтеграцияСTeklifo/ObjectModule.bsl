#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ИнициализацияОбработки

// Выполняет инициализацию параметров обмена с Teklifo по организации.
// Возвращаемое значение:
//  Булево - Результат инициализации параметров обмена
Функция ИнициализироватьПараметрыОбменаПоОрганизации() Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись КАК УчетнаяЗапись,
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись.АдресЭлектроннойПочты КАК АдресЭлектроннойПочты,
						  |	TK_СоответствияОрганизаций.ИдентификаторОрганизацииTeklifo КАК ИдентификаторОрганизацииTeklifo
						  |ИЗ
						  |	РегистрСведений.TK_СоответствиеОрганизацийTeklifo КАК TK_СоответствияОрганизаций
						  |ГДЕ
						  |	TK_СоответствияОрганизаций.Организация = &Организация
						  |СГРУППИРОВАТЬ ПО
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись,
						  |	TK_СоответствияОрганизаций.ИдентификаторОрганизацииTeklifo,
						  |	TK_СоответствияОрганизаций.УчетнаяЗапись.АдресЭлектроннойПочты");
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда

		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);

		Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗапись);

		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

#КонецОбласти

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
Процедура СохранитьУчетнуюЗаписьИнтеграцииСTeklifo() Экспорт

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

	НачатьТранзакцию();

	Попытка

		УчетнаяЗаписьОбъект.Записать();
		УчетнаяЗапись = УчетнаяЗаписьОбъект.Ссылка;

		УстановитьПривилегированныйРежим(Истина);

		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗапись, Пароль);

		ЗафиксироватьТранзакцию();

	Исключение

		ОтменитьТранзакцию();

		ОбщегоНазначения.СообщитьПользователю(НСтр(
			"ru = 'Не удалось сохранить учетную запись Teklifo. Смотрите подробности в журнале регистрации.'"));

		ЗаписьЖурналаРегистрации("Запись учетной записи Teklifo", УровеньЖурналаРегистрации.Ошибка, , ,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

	КонецПопытки;

	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

КонецПроцедуры

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

#Область Номенклатура

// Выгружает номенклатурные позиции на Teklifo.
// 
// Параметры:
//  МассивНоменклатуры - Массив Из СправочникСсылка.Номенклатура - Массив номенклатуры
// 
// Возвращаемое значение:
// Булево - результат выгрузки номенклатуры
Функция ВыгрузитьНоменклатуруНаTeklifo(МассивНоменклатуры) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	Номенклатура.Ссылка КАК Ссылка,
						  |	Номенклатура.Наименование КАК Наименование,
						  |	Номенклатура.Артикул КАК Артикул,
						  |	Номенклатура.Марка КАК Марка,
						  |	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
						  |	Номенклатура.Описание КАК Описание
						  |ИЗ
						  |	Справочник.Номенклатура КАК Номенклатура
						  |ГДЕ
						  |	Номенклатура.Ссылка В (&МассивНоменклатуры)");
	Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);

	Выборка = Запрос.Выполнить().Выбрать();

	МассивДанных = Новый Массив;

	Пока Выборка.Следующий() Цикл

		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("externalId", Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		СтруктураДанных.Вставить("name", Выборка.Наименование);
		СтруктураДанных.Вставить("number", Выборка.Артикул);
		СтруктураДанных.Вставить("brand", Строка(Выборка.Марка));
		СтруктураДанных.Вставить("brandNumber", "");
		СтруктураДанных.Вставить("unit", Строка(Выборка.ЕдиницаИзмерения));
		СтруктураДанных.Вставить("description", Выборка.Описание);
		СтруктураДанных.Вставить("archive", Ложь);

		МассивДанных.Добавить(СтруктураДанных);

	КонецЦикла;

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Заголовки.Вставить("Content-Type", "application/json");
	ПараметрыHTTPЗапроса.АдресРесурса = СтрШаблон("/api/company/%1/product", ИдентификаторОрганизацииTeklifo);
	ПараметрыHTTPЗапроса.ТелоЗапроса = TK_РаботаСJSONВызовСервера.СериализоватьJSON(МассивДанных);
	ПараметрыHTTPЗапроса.HTTPМетод = "POST";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Ложь;
	КонецЕсли;

	ДанныеНоменклатуры = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(HTTPОтвет.ПолучитьТелоКакСтроку());
	СохранитьСоответствиеНоменклатурыTeklifo(ДанныеНоменклатуры);

	Возврат Истина;

КонецФункции

#КонецОбласти

#Область ЗапросЦенПоставщикам

// Публикует запрос цен поставщикам на Teklifo.
// 
// Параметры:
//  ЗапросЦенПоставщикам - ДокументСсылка.TK_ЗапросЦенПоставщикам - Запрос цен поставщикам 
// 
// Возвращаемое значение:
//  Булево - результат публикации запроса цен поставщикам
Функция ОпубликоватьЗапросЦенПоставщикамНаTeklifo(ЗапросЦенПоставщикам) Экспорт

	ДанныеОпубликованногоДокумента = TK_ОбщегоНазначенияВызовСервера.ДанныеОпубликованногоЗапросаЦенПоставщикам(
		ЗапросЦенПоставщикам);
	ЭтоНовваяПубликация = ДанныеОпубликованногоДокумента.Идентификатор = "";

	ДанныеКПубликации = ДанныеКПубликацииЗапросаЦенПоставщикам(ЗапросЦенПоставщикам);
	ДанныеКПубликации.id = ДанныеОпубликованногоДокумента.Идентификатор;

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Заголовки.Вставить("Content-Type", "application/json");
	ПараметрыHTTPЗапроса.ТелоЗапроса = TK_РаботаСJSONВызовСервера.СериализоватьJSON(ДанныеКПубликации);
	ПараметрыHTTPЗапроса.АдресРесурса = ?(ЭтоНовваяПубликация, "/api/rfq", СтрШаблон("/api/rfq/%1",
		ДанныеОпубликованногоДокумента.Идентификатор));
	ПараметрыHTTPЗапроса.HTTPМетод = ?(ЭтоНовваяПубликация, "POST", "PUT");

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		СообщитьОВозможныхОшибкахИзHTTPОтвета(HTTPОтвет);
		Возврат Ложь;
	КонецЕсли;

	ДанныеОпубликованногоЗапроса = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(HTTPОтвет.ПолучитьТелоКакСтроку());

	СохранитьИдентификаторЗапросаЦенПоставщикамНаTeklifo(ЗапросЦенПоставщикам, ДанныеОпубликованногоЗапроса);
	СохранитьИдентификаторыСтрокЗапросаЦенПоставщикамНаTeklifo(ЗапросЦенПоставщикам, ДанныеОпубликованногоЗапроса.items);

	Возврат Истина;

КонецФункции

#КонецОбласти

#Область ЗапросЦенОтКлиента

// Проверяет наличие запроса цен по идентификатору. Актуально для закрытых запросов цен, информацию о которых нельзя получить из стандартного метода загрузки. 
// 
// Параметры:
//  ИдентификаторЗапросаЦен - Строка - Идентификатор запроса цен
// 
// Возвращаемое значение:
//  Булево - признак наличия запроса цен
Функция ПроверитьСуществованиеЗапросаЦенаПоИдентификатору(ИдентификаторЗапросаЦен) Экспорт

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.АдресРесурса = СтрШаблон("/api/rfq/%1/preview", ИдентификаторЗапросаЦен);
	ПараметрыHTTPЗапроса.HTTPМетод = "GET";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Возврат HTTPОтвет <> Неопределено И HTTPОтвет.КодСостояния = 200;

КонецФункции

// Подтверждает участие организации в запросе цен от клиента.
// 
// Параметры:
//  ИдентификаторЗапросаЦен - Строка - Идентификатор запроса цен
// 
// Возвращаемое значение:
//  Булево - результат подтверждения участия организации в запросе цен от клиента.  
Функция ПодтвердитьУчастиеОрганизацииВЗапросеЦенОтКлиента(ИдентификаторЗапросаЦен) Экспорт

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.АдресРесурса = СтрШаблон("/api/rfq/%1/participation", ИдентификаторЗапросаЦен);
	ПараметрыHTTPЗапроса.HTTPМетод = "PATCH";

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Результат = HTTPОтвет <> Неопределено И HTTPОтвет.КодСостояния = 200;

	Если Не Результат Тогда
		СообщитьОВозможныхОшибкахИзHTTPОтвета(HTTPОтвет);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Загружает запрос цен от клиента в систему.
// 
// Параметры:
//  ИдентификаторЗапросаЦен - Строка - Идентификатор запроса цен
// 
// Возвращаемое значение:
//  ДокументСсылка.TK_ЗапросЦенОтКлиента - Загрузить запрос цен от клиента
Функция ЗагрузитьЗапросЦенОтКлиента(ИдентификаторЗапросаЦен) Экспорт

	ЗапросЦенОтКлиента = Документы.TK_ЗапросЦенОтКлиента.ПустаяСсылка();

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.АдресРесурса = СтрШаблон("/api/rfq/%1", ИдентификаторЗапросаЦен);

	HTTPОтвет = ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса);

	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат ЗапросЦенОтКлиента;
	КонецЕсли;

	ДанныеЗапросаЦен = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(HTTPОтвет.ПолучитьТелоКакСтроку(),
		"startDate,endDate,createdAt,updatedAt,deliveryDate");

	НачатьТранзакцию();
	Попытка
		ЗапросЦенОтКлиента = СоздатьОбновитьЗапросЦенОтКлиента(ДанныеЗапросаЦен);
		СохранитьИдентификаторЗапросаЦенОтКлиентаНаTeklifo(ЗапросЦенОтКлиента, ДанныеЗапросаЦен);
		СохранитьИдентификаторыСтрокЗапросаЦенОтКлиентаНаTeklifo(ЗапросЦенОтКлиента, ДанныеЗапросаЦен.items);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(НСтр(
			"ru = 'Не удалось загрузить запрос цен от клиента. Смотрите подробности в журнале регистрации.'"));
		ЗаписьЖурналаРегистрации("Загрузка заказа клиента по URL", УровеньЖурналаРегистрации.Ошибка, , ,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

	КонецПопытки;

	Возврат ЗапросЦенОтКлиента;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Авторизация

Функция ИзвлечьТокенСессииИзCookie()

	НачальныйСимвол = СтрНайти(Cookie, "__Secure-next-auth.session-token=");

	ПерваяЧастьСтроки = Сред(Cookie, НачальныйСимвол, СтрДлина(Cookie));

	КонечныйСимвол = СтрНайти(ПерваяЧастьСтроки, ";");

	ТокенСессии = Сред(ПерваяЧастьСтроки, 0, КонечныйСимвол - 1);

	Если НачальныйСимвол = 0 Тогда
		ТокенСессии = "";
	КонецЕсли;

	Возврат ТокенСессии;

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

#Область Номенклатура

Процедура СохранитьСоответствиеНоменклатурыTeklifo(ДанныеНоменклатуры)

	Для Каждого Элемент Из ДанныеНоменклатуры Цикл

		Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Элемент.externalId));

		Если ЗначениеЗаполнено(Номенклатура) Тогда
			МенеджерЗаписи = РегистрыСведений.TK_СоответствиеНоменклатурыTeklifo.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Номенклатура = Номенклатура;
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.ВнешнийИдентификатор = Элемент.id;
			МенеджерЗаписи.Записать();
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ЗапросЦенПоставщикам

Функция ДанныеКПубликацииЗапросаЦенПоставщикам(ЗапросЦенПоставщикам)

	ВыборкаДокумент = ДанныеЗапросаЦенПоставщикам(ЗапросЦенПоставщикам).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ДанныеЗапросаПоставщикам = НоваяСтруктураДанныхЗапросаЦенПоставщикам();

	МассивСтрок = Новый Массив;

	Если ВыборкаДокумент.Следующий() Тогда

		ДанныеЗапросаПоставщикам.externalId = Строка(ВыборкаДокумент.Документ.УникальныйИдентификатор());
		ДанныеЗапросаПоставщикам.privateRequest = ВыборкаДокумент.ТипЗапроса = Перечисления.TK_ТипыЗапросовЦен.Закрытый;
		ДанныеЗапросаПоставщикам.title = ВыборкаДокумент.Заголовок;
		ДанныеЗапросаПоставщикам.date.from = Формат(ВыборкаДокумент.НачальнаяДатаСбораПредложений, "ДФ=yyyy-MM-dd;");
		ДанныеЗапросаПоставщикам.date.to = Формат(ВыборкаДокумент.КонечнаяДатаСбораПредложений, "ДФ=yyyy-MM-dd;");
		ДанныеЗапросаПоставщикам.currency = Строка(ВыборкаДокумент.Валюта);
		ДанныеЗапросаПоставщикам.description = ВыборкаДокумент.ТекстовоеОписание;
		ДанныеЗапросаПоставщикам.deliveryAddress = ВыборкаДокумент.АдресДоставки;
		ДанныеЗапросаПоставщикам.deliveryTerms = ВыборкаДокумент.КомментарийКУсловиямДоставки;
		ДанныеЗапросаПоставщикам.paymentTerms = ВыборкаДокумент.КомментарийКУсловиямОплаты;

		ВыборкаДетали = ВыборкаДокумент.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Пока ВыборкаДетали.Следующий() Цикл
			ПозицияЗапросаПоставщикам = НоваяСтруктураПозицииЗапросаЦенПоставщикам();

			ПозицияЗапросаПоставщикам.id = ВыборкаДетали.ВнешнийИдентификатор;
			ПозицияЗапросаПоставщикам.externalId = ВыборкаДетали.ИдентификаторСтроки;
			ПозицияЗапросаПоставщикам.productId = ВыборкаДетали.ВнешнийИдентификаторНоменклатуры;
			ПозицияЗапросаПоставщикам.productName = ВыборкаДетали.НоменклатураТекстом;
			ПозицияЗапросаПоставщикам.quantity = ВыборкаДетали.Количество;
			ПозицияЗапросаПоставщикам.price = ВыборкаДетали.МаксимальнаяЦена;
			ПозицияЗапросаПоставщикам.deliveryDate = Формат(ВыборкаДетали.ДатаДоставки, "ДФ=yyyy-MM-dd;");
			ПозицияЗапросаПоставщикам.comment = ВыборкаДетали.Комментарий;

			МассивСтрок.Добавить(ПозицияЗапросаПоставщикам);
		КонецЦикла;

	КонецЕсли;

	ДанныеЗапросаПоставщикам.items = МассивСтрок;

	Возврат ДанныеЗапросаПоставщикам;

КонецФункции

Функция ДанныеЗапросаЦенПоставщикам(ЗапросЦенПоставщикам)

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	Товары.Ссылка КАК Ссылка,
						  |	Товары.ИдентификаторСтроки КАК ИдентификаторСтроки,
						  |	Товары.Номенклатура КАК Номенклатура,
						  |	Товары.НоменклатураТекстом КАК НоменклатураТекстом,
						  |	Товары.Количество КАК Количество,
						  |	Товары.МаксимальнаяЦена КАК МаксимальнаяЦена,
						  |	Товары.ДатаДоставки КАК ДатаДоставки,
						  |	Товары.Комментарий КАК Комментарий
						  |ПОМЕСТИТЬ ВТ_Документ
						  |ИЗ
						  |	Документ.TK_ЗапросЦенПоставщикам.Товары КАК Товары
						  |ГДЕ
						  |	Товары.Ссылка = &ЗапросЦенПоставщикам
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВТ_Документ.Номенклатура КАК Номенклатура,
						  |	TK_СоответствияНоменклатуры.ВнешнийИдентификатор КАК ВнешнийИдентификатор
						  |ПОМЕСТИТЬ ВТ_Номенклатура
						  |ИЗ
						  |	ВТ_Документ КАК ВТ_Документ,
						  |	РегистрСведений.TK_СоответствиеНоменклатурыTeklifo КАК TK_СоответствияНоменклатуры
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВТ_Документ.Ссылка КАК Ссылка,
						  |	ВТ_Документ.ИдентификаторСтроки КАК ИдентификаторСтроки,
						  |	TK_ВнешниеИдентификаторыСтрокДокументов.ВнешнийИдентификатор КАК ВнешнийИдентификатор
						  |ПОМЕСТИТЬ ВТ_ИдентификаторыСтрок
						  |ИЗ
						  |	ВТ_Документ КАК ВТ_Документ
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TK_ИдентификаторыСтрокЗапросовЦенПоставщикамНаTeklifo КАК
						  |			TK_ВнешниеИдентификаторыСтрокДокументов
						  |		ПО ВТ_Документ.Ссылка = TK_ВнешниеИдентификаторыСтрокДокументов.Документ
						  |		И ВТ_Документ.ИдентификаторСтроки = TK_ВнешниеИдентификаторыСтрокДокументов.ИдентификаторСтроки
						  |ГДЕ
						  |	(TK_ВнешниеИдентификаторыСтрокДокументов.Документ, TK_ВнешниеИдентификаторыСтрокДокументов.ИдентификаторСтроки) В
						  |		(ВЫБРАТЬ
						  |			ВТ_Документ.Ссылка КАК Ссылка,
						  |			ВТ_Документ.ИдентификаторСтроки КАК ИдентификаторСтроки
						  |		ИЗ
						  |			ВТ_Документ КАК ВТ_Документ)
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВТ_Документ.Ссылка КАК Документ,
						  |	ВТ_Документ.Ссылка.Заголовок КАК Заголовок,
						  |	ВТ_Документ.Ссылка.Валюта КАК Валюта,
						  |	ВТ_Документ.Ссылка.НачальнаяДатаСбораПредложений КАК НачальнаяДатаСбораПредложений,
						  |	ВТ_Документ.Ссылка.КонечнаяДатаСбораПредложений КАК КонечнаяДатаСбораПредложений,
						  |	ВЫРАЗИТЬ(ВТ_Документ.Ссылка.ТекстовоеОписание КАК СТРОКА(1000)) КАК ТекстовоеОписание,
						  |	ВЫРАЗИТЬ(ВТ_Документ.Ссылка.АдресДоставки КАК СТРОКА(1000)) КАК АдресДоставки,
						  |	ВЫРАЗИТЬ(ВТ_Документ.Ссылка.КомментарийКУсловиямДоставки КАК СТРОКА(1000)) КАК КомментарийКУсловиямДоставки,
						  |	ВЫРАЗИТЬ(ВТ_Документ.Ссылка.КомментарийКУсловиямОплаты КАК СТРОКА(1000)) КАК КомментарийКУсловиямОплаты,
						  |	ВТ_Документ.Ссылка.ТипЗапроса КАК ТипЗапроса,
						  |	ВТ_Документ.Номенклатура КАК Номенклатура,
						  |	ВТ_Документ.НоменклатураТекстом КАК НоменклатураТекстом,
						  |	ВТ_Документ.Количество КАК Количество,
						  |	ВТ_Документ.МаксимальнаяЦена КАК МаксимальнаяЦена,
						  |	ВТ_Документ.ДатаДоставки КАК ДатаДоставки,
						  |	ВТ_Документ.Комментарий КАК Комментарий,
						  |	ВТ_Документ.ИдентификаторСтроки КАК ИдентификаторСтроки,
						  |	ВТ_Номенклатура.ВнешнийИдентификатор КАК ВнешнийИдентификаторНоменклатуры,
						  |	ЕСТЬNULL(ВТ_ИдентификаторыСтрок.ВнешнийИдентификатор, """") КАК ВнешнийИдентификатор
						  |ИЗ
						  |	ВТ_Документ КАК ВТ_Документ
						  |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыСтрок КАК ВТ_ИдентификаторыСтрок
						  |		ПО ВТ_Документ.Ссылка = ВТ_ИдентификаторыСтрок.Ссылка
						  |		И ВТ_Документ.ИдентификаторСтроки = ВТ_ИдентификаторыСтрок.ИдентификаторСтроки
						  |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Номенклатура КАК ВТ_Номенклатура
						  |		ПО ВТ_Документ.Номенклатура = ВТ_Номенклатура.Номенклатура
						  |ИТОГИ
						  |ПО
						  |	Документ");
	Запрос.УстановитьПараметр("ЗапросЦенПоставщикам", ЗапросЦенПоставщикам);

	Возврат Запрос.Выполнить();

КонецФункции

Функция НоваяСтруктураДанныхЗапросаЦенПоставщикам()

	ПериодСбораПредложений = Новый Структура("from, to", '00010101', '00010101');

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
	ПозицияЗапросаПоставщикам.Вставить("productName", "");
	ПозицияЗапросаПоставщикам.Вставить("quantity", 0);
	ПозицияЗапросаПоставщикам.Вставить("price", 0);
	ПозицияЗапросаПоставщикам.Вставить("deliveryDate", '00010101');
	ПозицияЗапросаПоставщикам.Вставить("comment", "");

	Возврат ПозицияЗапросаПоставщикам

КонецФункции

Процедура СохранитьИдентификаторЗапросаЦенПоставщикамНаTeklifo(Документ, ДанныеПубликации)

	МенеджерЗаписи = РегистрыСведений.TK_ИдентификаторыЗапросовЦенПоставщикамНаTeklifo.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Идентификатор = ДанныеПубликации.id;
	МенеджерЗаписи.НомерДокумента = ДанныеПубликации.number;
	МенеджерЗаписи.ИдентификаторВерсии = ДанныеПубликации.versionId;
	МенеджерЗаписи.ЭтоАктуальнаяВерсия = ДанныеПубликации.latestVersion;
	МенеджерЗаписи.Записать();

КонецПроцедуры

Процедура СохранитьИдентификаторыСтрокЗапросаЦенПоставщикамНаTeklifo(Документ, Строки)

	Для Каждого ДанныеСтроки Из Строки Цикл
		МенеджерЗаписи = РегистрыСведений.TK_ИдентификаторыСтрокЗапросовЦенПоставщикамНаTeklifo.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ = Документ;
		МенеджерЗаписи.ИдентификаторСтроки = ДанныеСтроки.externalId;
		МенеджерЗаписи.ВнешнийИдентификатор = ДанныеСтроки.id;
		МенеджерЗаписи.ИдентификаторВерсии = ДанныеСтроки.versionId;
		МенеджерЗаписи.Записать();
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ЗапросЦенОтКлиента

Функция СоздатьОбновитьЗапросЦенОтКлиента(ДанныеЗапросаЦен)

	ЗапросЦенОтКлиента = TK_ОбщегоНазначенияВызовСервера.ЗапросЦенОтКлиентаПоИдентификаторуВерсии(
		ДанныеЗапросаЦен.versionId);

	Если ЗначениеЗаполнено(ЗапросЦенОтКлиента) Тогда
		ЗапросЦенОтКлиентаОбъект = ЗапросЦенОтКлиента.ПолучитьОбъект();
	Иначе
		ЗапросЦенОтКлиентаОбъект = Документы.TK_ЗапросЦенОтКлиента.СоздатьДокумент();
		ЗапросЦенОтКлиентаОбъект.Дата = ДанныеЗапросаЦен.createdAt;
		ЗапросЦенОтКлиентаОбъект.УстановитьНовыйНомер();
	КонецЕсли;

	ЗапросЦенОтКлиентаОбъект.Организация = Организация;
	ЗапросЦенОтКлиентаОбъект.Заголовок = ДанныеЗапросаЦен.title;
	ЗапросЦенОтКлиентаОбъект.Валюта = ВалютаПоНаименованию(ДанныеЗапросаЦен.currency);
	ЗапросЦенОтКлиентаОбъект.ТипЗапроса = ?(ДанныеЗапросаЦен.privateRequest, Перечисления.TK_ТипыЗапросовЦен.Закрытый,
		Перечисления.TK_ТипыЗапросовЦен.Открытый);
	ЗапросЦенОтКлиентаОбъект.Партнер = ПолучитьПартнера(ДанныеЗапросаЦен.company, Ложь, Истина);
	ЗапросЦенОтКлиентаОбъект.НачальнаяДатаСбораПредложений = ДанныеЗапросаЦен.startDate;
	ЗапросЦенОтКлиентаОбъект.КонечнаяДатаСбораПредложений = ДанныеЗапросаЦен.endDate;
	ЗапросЦенОтКлиентаОбъект.ТекстовоеОписание = ДанныеЗапросаЦен.description;
	ЗапросЦенОтКлиентаОбъект.АдресДоставки = ДанныеЗапросаЦен.deliveryAddress;
	ЗапросЦенОтКлиентаОбъект.КомментарийКУсловиямДоставки = ДанныеЗапросаЦен.deliveryTerms;
	ЗапросЦенОтКлиентаОбъект.КомментарийКУсловиямОплаты = ДанныеЗапросаЦен.paymentTerms;

	ЗапросЦенОтКлиентаОбъект.Товары.Очистить();

	Для Каждого ДанныеПозиции Из ДанныеЗапросаЦен.items Цикл

		Номенклатура = ПолучитьНоменклатуруКонтрагента(ДанныеПозиции, ЗапросЦенОтКлиентаОбъект.Партнер);

		СтрокаТабличнойЧасти = ЗапросЦенОтКлиентаОбъект.Товары.Добавить();
		СтрокаТабличнойЧасти.Номенклатура = Номенклатура;
		СтрокаТабличнойЧасти.НоменклатураТекстом = ДанныеПозиции.productName;
		СтрокаТабличнойЧасти.Количество = ДанныеПозиции.quantity;
		СтрокаТабличнойЧасти.МаксимальнаяЦена = ДанныеПозиции.price;
		СтрокаТабличнойЧасти.ДатаДоставки = ДанныеПозиции.deliveryDate;
		СтрокаТабличнойЧасти.Комментарий  = ДанныеПозиции.comment;
		СтрокаТабличнойЧасти.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);

	КонецЦикла;

	ЗапросЦенОтКлиентаОбъект.Записать(РежимЗаписиДокумента.Проведение);

	Возврат ЗапросЦенОтКлиентаОбъект.Ссылка;

КонецФункции

Функция ПолучитьНоменклатуруКонтрагента(ДанныеПозиции, Владелец)

	Если Не ДанныеПозиции.Свойство("product") Или ДанныеПозиции.product = Неопределено Тогда
		Возврат Справочники.НоменклатураКонтрагентов.ПустаяСсылка();
	КонецЕсли;

	Номенклатура = Справочники.НоменклатураКонтрагентов.НайтиПоРеквизиту("Идентификатор", СокрЛП(
		ДанныеПозиции.product.externalId));

	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Номенклатура;
	КонецЕсли;

	НоменклатураОбъект = Справочники.НоменклатураКонтрагентов.СоздатьЭлемент();
	НоменклатураОбъект.Наименование = СокрЛП(ДанныеПозиции.product.name);
	НоменклатураОбъект.НаименованиеПолное = СокрЛП(ДанныеПозиции.product.name);
	НоменклатураОбъект.Идентификатор = СокрЛП(ДанныеПозиции.product.externalId);
	НоменклатураОбъект.Артикул = СокрЛП(ДанныеПозиции.product.number);
	НоменклатураОбъект.ВладелецНоменклатуры = Владелец;
	НоменклатураОбъект.Владелец = Владелец;
	НоменклатураОбъект.НаименованиеУпаковки = СокрЛП(ДанныеПозиции.product.unit);
	НоменклатураОбъект.НаименованиеБазовойЕдиницыИзмерения = СокрЛП(ДанныеПозиции.product.unit);

	НоменклатураОбъект.Записать();

	Возврат НоменклатураОбъект.Ссылка;

КонецФункции

Функция ПолучитьПартнера(ДанныеОрганизацииПартнера, ЭтоПоставщик = Ложь, ЭтоКлиент = Ложь)

	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
						  |	Контрагенты.Ссылка КАК Контрагент,
						  |	Контрагенты.Партнер КАК Партнер
						  |ИЗ
						  |	Справочник.Контрагенты КАК Контрагенты
						  |ГДЕ
						  |	TK_ИдентификаторTeklifo = &ИдентификаторTeklifo
						  |	ИЛИ Контрагенты.ИНН = &ИНН");
	Запрос.УстановитьПараметр("ИдентификаторTeklifo", ДанныеОрганизацииПартнера.id);
	Запрос.УстановитьПараметр("ИНН", ДанныеОрганизацииПартнера.tin);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПартнерОбъект = Выборка.Партнер.ПолучитьОбъект();
		КонтрагентОбъект = Выборка.Контрагент.ПолучитьОбъект();
	Иначе
		ПартнерОбъект = Справочники.Партнеры.СоздатьЭлемент();
		КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент();
	КонецЕсли;

	ПартнерОбъект.Наименование = ДанныеОрганизацииПартнера.name;
	ПартнерОбъект.НаименованиеПолное = ДанныеОрганизацииПартнера.name;
	ПартнерОбъект.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.Компания;
	ПартнерОбъект.Поставщик = ЭтоПоставщик;
	ПартнерОбъект.Клиент = ЭтоКлиент;
	ПартнерОбъект.Записать();
	Партнер = ПартнерОбъект.Ссылка;

	КонтрагентОбъект.TK_ИдентификаторTeklifo = ДанныеОрганизацииПартнера.id;
	КонтрагентОбъект.Наименование = ДанныеОрганизацииПартнера.name;
	КонтрагентОбъект.НаименованиеПолное = ДанныеОрганизацииПартнера.name;
	КонтрагентОбъект.ИНН = ДанныеОрганизацииПартнера.tin;
	КонтрагентОбъект.Партнер = Партнер;
	КонтрагентОбъект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
	КонтрагентОбъект.Записать();

	Возврат Партнер;

КонецФункции

Функция ВалютаПоНаименованию(НаименованиеВалюты)

	Валюта = Справочники.Валюты.НайтиПоНаименованию(НаименованиеВалюты, Истина);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		ВалютаОбъект = Справочники.Валюты.СоздатьЭлемент();
		ВалютаОбъект.Наименование = НаименованиеВалюты;
		ВалютаОбъект.НаименованиеПолное = НаименованиеВалюты;
		ВалютаОбъект.ОбменДанными.Загрузка = Истина;
		ВалютаОбъект.Записать();
		Валюта = ВалютаОбъект.Ссылка;
	КонецЕсли;

	Возврат Валюта;

КонецФункции

Процедура СохранитьИдентификаторЗапросаЦенОтКлиентаНаTeklifo(Документ, ДанныеПубликации)

	МенеджерЗаписи = РегистрыСведений.TK_ИдентификаторыЗапросовЦенОтКлиентовНаTeklifo.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Документ = Документ;
	МенеджерЗаписи.Идентификатор = ДанныеПубликации.id;
	МенеджерЗаписи.НомерДокумента = ДанныеПубликации.number;
	МенеджерЗаписи.ИдентификаторВерсии = ДанныеПубликации.versionId;
	МенеджерЗаписи.ЭтоАктуальнаяВерсия = ДанныеПубликации.latestVersion;
	МенеджерЗаписи.Записать();

КонецПроцедуры

Процедура СохранитьИдентификаторыСтрокЗапросаЦенОтКлиентаНаTeklifo(Документ, Строки)

	Для Каждого ДанныеСтроки Из Строки Цикл
		МенеджерЗаписи = РегистрыСведений.TK_ИдентификаторыСтрокЗапросовЦенОтКлиентовНаTeklifo.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ = Документ;
		МенеджерЗаписи.ИдентификаторСтроки = ДанныеСтроки.id;
		МенеджерЗаписи.ИдентификаторВерсии = ДанныеСтроки.versionId;
		МенеджерЗаписи.Записать();
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область HTTP

Функция ВыполнитьHTTPЗапросКTeklifo(ПараметрыHTTPЗапроса)

	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();

	HTTPСоединение = Новый HTTPСоединение("teklifo.com", , , , , , ЗащищенноеСоединение);

	ПараметрыHTTPЗапроса.Заголовки.Вставить("Accept-Language", "ru");
	ПараметрыHTTPЗапроса.Заголовки.Вставить("Cookie", СтрШаблон("NEXT_LOCALE=ru;user-company=%1;%2",
		ИдентификаторОрганизацииTeklifo, Cookie));

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

Процедура СообщитьОВозможныхОшибкахИзHTTPОтвета(HTTPОтвет)

	Если HTTPОтвет = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДанныеОтвета = TK_РаботаСJSONВызовСервера.ПолучитьДанныеИзJSON(HTTPОтвет.ПолучитьТелоКакСтроку());
	Если ТипЗнч(ДанныеОтвета) = Тип("Структура") И ДанныеОтвета.Свойство("errors") Тогда
		Для Каждого СтруктураОшибки Из ДанныеОтвета.errors Цикл
			ОбщегоНазначения.СообщитьПользователю(СтруктураОшибки.message);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли