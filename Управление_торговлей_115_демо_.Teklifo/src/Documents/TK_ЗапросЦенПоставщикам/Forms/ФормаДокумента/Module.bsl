#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыДляЗаписи Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    // СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

	УстановитьОтборПоДоступнымОрганизациям();

	ОтобразитьВнешнююСсылкуНаОпубликованныйДокумент();

	ОтобразитьТекущийСтатусПубликацииДокумета();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 	

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "TK_ОбновлениеСтатусаПубликации" И Параметр = Объект.Ссылка Тогда
		ОтобразитьВнешнююСсылкуНаОпубликованныйДокумент();
		ОтобразитьТекущийСтатусПубликацииДокумета();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ОтобразитьТекущийСтатусПубликацииДокумета();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	ПринудительноЗакрытьФорму = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВнешняяСсылкаНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ЗапуститьПриложение(ВнешняяСсылка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	Если Не ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторСтроки) Или НоваяСтрока Тогда
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ЗаполнитьНоменклатуруТекстомВСтрокеТабличнойЧасти(Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор());

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкопироватьСсылкуВБуфер(Команда)

	TK_ОбщегоНазначенияКлиент.СкопироватьТекстВБуферОбмена(Элементы.БуферОбмена, ВнешняяСсылка);

	ТекстСообщения = НСтр("ru = 'Внешняя ссылка на запрос цен скопирована в буфер обмена.'");
	ПоказатьОповещениеПользователя( , , ТекстСообщения, БиблиотекаКартинок.Успешно32);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)

	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)

	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)

	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект, Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ОбработатьЗаписьОбъекта()

	ОбщегоНазначенияУТКлиент.ОбработатьЗаписьОбъектаВФорме(ЭтотОбъект, ПараметрыДляЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОтобразитьВнешнююСсылкуНаОпубликованныйДокумент()

	ВнешняяСсылка = TK_ОбщегоНазначенияВызовСервера.ВнешняяСсылкаНаОпубликованныйЗапросЦенПоставщикам(
		Объект.Ссылка);

	Элементы.ГруппаСтраницыВнешнейСсылки.Видимость = ЗначениеЗаполнено(ВнешняяСсылка);

КонецПроцедуры

&НаСервере
Процедура ОтобразитьТекущийСтатусПубликацииДокумета()

	СтатусПубликации = TK_ОбщегоНазначенияВызовСервера.СтатусПубликацииЗапросаЦенПоставщикам(Объект.Ссылка);

	Если Не ЗначениеЗаполнено(СтатусПубликации) Тогда
		СтатусПубликации = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.НеОпубликован;
	КонецЕсли;
	Элементы.ГруппаОповещениеОбОбновленииДокумента.Видимость = СтатусПубликации
		= Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.ТребуетсяОбновление;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДоступнымОрганизациям()

	МассивОрганизаций = TK_ОбщегоНазначенияВызовСервера.организацииДоступныеКОбменуСTeklifo();

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивОрганизаций)));

	НовыйПараметр = Новый ФиксированныйМассив(МассивПараметров);

	Элементы.Организация.ПараметрыВыбора = НовыйПараметр;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуруТекстомВСтрокеТабличнойЧасти(ИдентификаторСтроки)

	СтрокаТабличнойЧасти = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	СтрокаТабличнойЧасти.НоменклатураТекстом = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		СтрокаТабличнойЧасти.Номенклатура, "НаименованиеПолное");

КонецПроцедуры

#КонецОбласти