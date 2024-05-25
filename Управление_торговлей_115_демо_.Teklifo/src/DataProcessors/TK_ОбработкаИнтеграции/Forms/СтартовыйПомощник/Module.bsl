&НаКлиенте
Процедура КомандаАвторизовация(Команда)
	КомандаАвторизовацияНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаАвторизовацияНаСервере()
	Если Не ЗначениеЗаполнено(СокрЛП(Объект.Email)) Тогда
		Сообщить("Заполните Email!");
		Возврат;
	КонецЕсли;

	СтруктураТокенов = Новый Структура;
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.ВыполнитьАвторизацию(СтруктураТокенов, УжеЗарегистрирован);

	Если Не УжеЗарегистрирован Тогда
		ЗарегистрироватьПользователя();
	Иначе
		ДалееЗавершениеВходаНаСервере();
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура КомандаДалееЗавершениеВхода(Команда)
	ДалееЗавершениеВходаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДалееЗавершениеВходаНаСервере()
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.ГруппаПродолжениеАвторизации;
КонецПроцедуры
&НаСервере
Процедура ДалееИнформацияОбОтправленномПисьме()
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.ГруппаИнформацияОбОтправленномПисьме;
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗавершитьАвторизацию(Команда)
	КомандаЗавершитьАвторизациюНаСервере();

	Если ТокенСессии <> "" Тогда
		Сообщить("Авторизация прошла успешно!");
		ПолучитьДанныеПользователя();
		ПредложитьСоздатьОрганизацию();
		ДалееСтраницаОрганизации();
	Иначе
		Сообщить("Авторизация не выполнена!");
	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Асинх Процедура ПредложитьСоздатьОрганизацию()

	Если ТаблицаОрганизаций.Количество() = 0 Тогда

		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Да");
		СписокКнопок.Добавить(КодВозвратаДиалога.Пропустить, "Пропустить");

		обещание = ВопросАсинх("В списке организаций нет ни одной организации.
							   | Для дальнейшей работы рекомендуется создать организацию. Создать?", СписокКнопок, ,
			КодВозвратаДиалога.Да);
		Результат = Ждать обещание;
		Если Результат = КодВозвратаДиалога.Да Тогда
			ДобавитьНовуюОрганизацию();
		Иначе
			Закрыть();
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ПолучитьДанныеПользователя()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");

	УчетнаяЗапись = ОбъектОбработки.ПолучитьУчетнуюЗапись();
	ТЗОрганизаций = ОбъектОбработки.ПолучитьДанныеПользователя(УчетнаяЗапись);

	значениевреквизитформы(ТЗОрганизаций, "ТаблицаОрганизаций");

КонецПроцедуры
&НаКлиенте
Асинх Процедура ПредложитьСоздатьДокументЗапросценПоставщиков()

	Если ТаблицаОрганизаций.Количество() > 0 Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, "Да");
		СписокКнопок.Добавить(КодВозвратаДиалога.Пропустить, "Пропустить");

		обещание = ВопросАсинх("Создать документ " + ПолучитьПредставлениеДокументаЗапросаЦен() + " ?", СписокКнопок, ,
			КодВозвратаДиалога.Да);
		Результат = Ждать обещание;
		Если Результат = КодВозвратаДиалога.Да Тогда
			СоздатьДокументЗапросаЦен();
		Иначе
			Закрыть();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументЗапросаЦен()
	ОткрытьФорму("Документ.TK_ЗапросЦенПоставщикам.Форма.ФормаДокумента");
КонецПроцедуры
&НаСервере
Функция ПолучитьПредставлениеДокументаЗапросаЦен()
	Возврат Метаданные.Документы.TK_ЗапросЦенПоставщикам.Синоним;
КонецФункции
&НаКлиенте
Процедура КомандаСохранитьДанные(Команда)
	КомандаСохранитьДанныеНаСервере();
	ПредложитьСоздатьДокументЗапросценПоставщиков();
КонецПроцедуры

&НаСервере
Процедура КомандаСохранитьДанныеНаСервере()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");

	ТЗОрганизаций = РеквизитФормыВЗначение("ТаблицаОрганизаций");

	ОбъектОбработки.ВыполнитьСохранениеДанных(ТЗОрганизаций);
	Сообщить("Данные сохранены успешно!");
КонецПроцедуры
&НаКлиенте
Процедура КомандаСоздатьОрганизациюНаСайте(Команда)
	СоздатьОрганизациюНаСайте();
	ДалееСтраницаОрганизации();
КонецПроцедуры

&НаСервере
Процедура СоздатьОрганизациюНаСайте()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");

	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("id", ИдентификаторНовойОрганизации);
	СтруктураДанных.Вставить("name", НаименованиеНовойОрганизации);
	СтруктураДанных.Вставить("tin", ИНННовойОрганизации);
	СтруктураДанных.Вставить("description", ОписаниеАнгНовойОрганизации);
	СтруктураДанных.Вставить("descriptionRu", ОписаниеРуНовойОрганизации);
	СтруктураДанных.Вставить("slogan", СлоганАнгНовойОрганизации);
	СтруктураДанных.Вставить("sloganRu", СлоганРуНовойОрганизации); 

	РезультатСоздания = ОбъектОбработки.ПолучитьРезультатСозданияОрганизацииНаСайте(СтруктураДанных, ТокенСессии);//Структура
 
    Если РезультатСоздания.Свойство("errors") Тогда
        ВызватьИсключение РезультатСоздания.message
    иначе
       ПолучитьДанныеПользователя();
    КонецЕсли;
 
	

КонецПроцедуры
&НаСервере
Процедура ДалееНоваяОрганизация()
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.ГруппаНоваяОрганизация;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОрганизацийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	Отказ = Истина;
	ДобавитьНовуюОрганизацию();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНовуюОрганизацию()
	Перем ВыбЗнач;
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.Организации"));

	ОписаниеТипов = Новый ОписаниеТипов(Массив);
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЗначения", ЭтотОбъект);
	ПоказатьВводЗначения(Оповещение, ВыбЗнач, "Введите значение", ОписаниеТипов);
КонецПроцедуры
&НаКлиенте
Процедура КомандаОтобразитьСтраницуОрганизаций(Команда)
	ДалееСтраницаОрганизации();
КонецПроцедуры
&НаКлиенте
Процедура ПослеВводаЗначения(ВыбЗнач, Параметры) Экспорт
	Если ВыбЗнач <> Неопределено Тогда
		ВыбраннаяОрганизация1С = ВыбЗнач;
		ЗаполнитьДанныеНовойОрганизации();
		ДалееНоваяОрганизация();
	КонецЕсли;
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьДанныеНовойОрганизации()
	НаименованиеНовойОрганизации =  ВыбраннаяОрганизация1С.Наименование;
	ИНННовойОрганизации          = ВыбраннаяОрганизация1С.ИНН;
КонецПроцедуры
&НаКлиенте
Процедура ДалееСтраницаОрганизации()
	Элементы.ГруппаСтраниц.ТекущаяСтраница = Элементы.ГруппаОрганизации;
КонецПроцедуры
&НаСервере
Процедура КомандаЗавершитьАвторизациюНаСервере()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ТокенСессии = ОбъектОбработки.ПолучитьТокенСессии(СтруктураТокенов);
КонецПроцедуры
&НаСервере
Процедура ЗарегистрироватьПользователя()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.ЗарегистрироватьПользователя(СтруктураТокенов);
	ДалееИнформацияОбОтправленномПисьме();
КонецПроцедуры