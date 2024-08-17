#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ПараметрыДляЗаписи Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
    
    // СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

	УстановитьОтборПоДоступнымОрганизациям();

	ОтобразитьВнешнююСсылкуНаОпубликованныйДокумент();

	ОтобразитьТекущийСтатусПубликацииДокумета();

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

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
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПодтвержденоИзменениеОпубликованногоДокумента Тогда
		Возврат;
	КонецЕсли;

	ПроверитьИзменениеОпубликованногоДокумента(Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ПодтвержденоИзменениеОпубликованногоДокумента = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	ОтобразитьТекущийСтатусПубликацииДокумета();

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

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

&НаКлиенте
Процедура НалогообложениеПриИзменении(Элемент)

	НалогообложениеПриИзмененииСервер(КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ЦенаВключаетНДСПриИзменении(Элемент)

	ЦенаВключаетНДСПриИзмененииСервер(КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	УстановитьДоступностьРеквизитовСтрокиТаблицыТоваров(ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	Если НоваяСтрока Или Копирование Тогда
		ТекущиеДанные.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	Налогообложение = НалогооблажениеНДСДокумента();

	ПараметрыЗаполнитьСтавкуНДС = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект);
	ПараметрыЗаполнитьСтавкуНДС.НалогообложениеНДС = Налогообложение;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи",
		ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияЦеныВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ПараметрыЗаполнитьСтавкуНДС);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыВидЦеныПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи",
		ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияЦеныВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьЦенуПоСумме", "Количество");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаНДСПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПропуститьПриИзменении(Элемент)

	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;

	Если ТекущиеДанные.Пропустить Тогда
		ТекущиеДанные.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ТекущиеДанные.Характеристика =ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
		ТекущиеДанные.Количество = 0;
		ТекущиеДанные.Цена = 0;
		ТекущиеДанные.ВидЦены =ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка");
		ТекущиеДанные.Сумма = 0;
		ТекущиеДанные.СтавкаНДС = ПредопределенноеЗначение("Справочник.СтавкиНДС.ПустаяСсылка");
		ТекущиеДанные.СуммаНДС = 0;
		ТекущиеДанные.СуммаСНДС = 0;
		ТекущиеДанные.ДатаДоставки = '00010101';
	КонецЕсли;

	УстановитьДоступностьРеквизитовСтрокиТаблицыТоваров(ТекущиеДанные);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкопироватьСсылкуВБуфер(Команда)

	TK_ОбщегоНазначенияКлиент.СкопироватьТекстВБуферОбмена(Элементы.БуферОбмена, ВнешняяСсылка);

	ТекстСообщения = НСтр("ru = 'Внешняя ссылка на коммерческое предложение клиенту скопирована в буфер обмена.'");
	ПоказатьОповещениеПользователя( , , ТекстСообщения, БиблиотекаКартинок.Успешно32);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)

	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект, , Новый ОписаниеОповещения("ОтправитьДокументНаПубликацию",
		ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)

	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект, , Новый ОписаниеОповещения("ОтправитьДокументНаПубликацию",
		ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)

	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект, , Новый ОписаниеОповещения("ОтправитьДокументНаПубликацию",
		ЭтотОбъект));

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

	ВнешняяСсылка = TK_ОбщегоНазначенияВызовСервера.ВнешняяСсылкаНаОпубликованноеКоммерческоеПредложениеКлиенту(
		Объект.Ссылка);

	Элементы.ГруппаСтраницыВнешнейСсылки.Видимость = ЗначениеЗаполнено(ВнешняяСсылка);

КонецПроцедуры

&НаСервере
Процедура ОтобразитьТекущийСтатусПубликацииДокумета()

	СтатусПубликации = TK_ОбщегоНазначенияВызовСервера.СтатусПубликацииКоммерческогоПредложенияКлиенту(Объект.Ссылка);

	Если Не ЗначениеЗаполнено(СтатусПубликации) Тогда
		СтатусПубликации = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.НеОпубликован;
	КонецЕсли;

	Если СтатусПубликации = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.Опубликован Тогда
		Элементы.ДекорацияОповещение.Заголовок = НСтр("ru = 'Коммерческое предложение отправлено клиенту.'");
		Элементы.ДекорацияОповещение.ЦветТекста = ЦветаСтиля.ЦветАкцента;
	ИначеЕсли СтатусПубликации = Перечисления.TK_СтатусыПубликацииДокументовНаTeklifo.ТребуетсяОбновление Тогда
		Элементы.ДекорацияОповещение.Заголовок = НСтр(
			"ru = 'Коммерческое предложение было изменено с момента последней отправки клиенту. Рекомендуется повтроно отправить коммерческое предложение клиенту.'");
		Элементы.ДекорацияОповещение.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
	Иначе
		Элементы.ДекорацияОповещение.Заголовок = НСтр(
			"ru = 'Подготовьте коммерческое предложение, после чего нажмите на кнопку ""Отправить клиенту"".'");
		Элементы.ДекорацияОповещение.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДоступнымОрганизациям()

	МассивОрганизаций = TK_ОбщегоНазначенияВызовСервера.ОрганизацииДоступныеКОбменуСTeklifo();

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивОрганизаций)));

	НовыйПараметр = Новый ФиксированныйМассив(МассивПараметров);

	Элементы.Организация.ПараметрыВыбора = НовыйПараметр;

КонецПроцедуры

&НаСервере
Процедура ЦенаВключаетНДСПриИзмененииСервер(КэшированныеЗначения)

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.Товары, СтруктураДействий, КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура НалогообложениеПриИзмененииСервер(КэшированныеЗначения)

	КэшированныеЗначенияСлужебный = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС",
		ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));

	СтруктураДействий.СкорректироватьСтавкуНДС.НалогообложениеНДС = НалогооблажениеНДСДокумента();

	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.Товары, СтруктураДействий, КэшированныеЗначенияСлужебный);

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(КэшированныеЗначенияСлужебный.ОбработанныеСтроки, СтруктураДействий,
		КэшированныеЗначения);

	РассчитатьИтоговыеПоказателиКоммерческогоПредложения(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Функция НалогооблажениеНДСДокумента()

	Возврат ?(Объект.Налогообложение, ПредопределенноеЗначение(
		"Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС"), ПредопределенноеЗначение(
		"Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС"));

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиКоммерческогоПредложения(Форма)

	КоллекцияТовары = Форма.Объект.Товары;

	Форма.СуммаНДС = КоллекцияТовары.Итог("СуммаНДС");
	Форма.СуммаДокументаСНДС = КоллекцияТовары.Итог("СуммаСНДС");

	Если Форма.Объект.Налогообложение Тогда
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница = Форма.Элементы.СтраницаСНДС;
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоСНДС;
	Иначе
		Форма.Элементы.ГруппаСтраницыНДС.ТекущаяСтраница = Форма.Элементы.СтраницаБезНДС;
		Форма.Элементы.ГруппаСтраницыВсего.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоБезНДС;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьРеквизитовСтрокиТаблицыТоваров(СтрокаТабличнойЧасти)

	ТолькоПросмотрСтроки = СтрокаТабличнойЧасти.Пропустить;

	Элементы.ТоварыНоменклатура.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыХарактеристика.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыКоличество.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыВидЦены.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыЦена.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыСумма.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыСтавкаНДС.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыСуммаНДС.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыСуммаСНДС.ТолькоПросмотр = ТолькоПросмотрСтроки;
	Элементы.ТоварыДатаДоставки.ТолькоПросмотр = ТолькоПросмотрСтроки;

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИзменениеОпубликованногоДокумента(Отказ, ПараметрыЗаписи)

	Если СтатусПубликации = ПредопределенноеЗначение("Перечисление.TK_СтатусыПубликацииДокументовНаTeklifo.Опубликован")
		И ОбъектИзменен() Тогда

		Отказ = Истина;

		ПоказатьВопрос(Новый ОписаниеОповещения("ПодтверждениеИзмененийВОпубликованныйДокумент", ЭтотОбъект,
			ПараметрыЗаписи), НСтр(
			"ru = 'Коммерческое предложение уже было отправлено клиенту, поэтому после внесенных изменений его нужно будет отправить заново. Продолжить?'"),
			РежимДиалогаВопрос.ДаНет);

	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ОбъектИзменен()

	ЗначениеОбъекта = РеквизитФормыВЗначение("Объект");

	Возврат TK_ОбщегоНазначенияВызовСервера.КоммерческоеПредложениеКлиентуИзменено(ЗначениеОбъекта);

КонецФункции

&НаКлиенте
Процедура ПодтверждениеИзмененийВОпубликованныйДокумент(Результат, ПараметрыЗаписи) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	ПодтвержденоИзменениеОпубликованногоДокумента = Истина;

	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда

		ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект, , Новый ОписаниеОповещения("ОтправитьДокументНаПубликацию",
			ЭтотОбъект));

	ИначеЕсли ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда

		ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект, , Новый ОписаниеОповещения("ОтправитьДокументНаПубликацию",
			ЭтотОбъект));

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДокументНаПубликацию(Результат, ДополнительныеПараметры) Экспорт

	Если Не Результат Тогда
		Возврат;
	КонецЕсли;

	Если Объект.Проведен И СтатусПубликации <> ПредопределенноеЗначение(
		"Перечисление.TK_СтатусыПубликацииДокументовНаTeklifo.Опубликован") Тогда
		TK_ИнтеграцияСTeklifoКлиент.ОпубликоватьКоммерческоеПредложениеКлиентуНаTeklifo(Объект.Ссылка);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	//  

	Элемент = УсловноеОформление.Элементы.Добавить();

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Пропустить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ИсключаяПоля = Новый Массив;
	ИсключаяПоля.Добавить(Элементы.ТоварыПропустить.Имя);

	ОбщегоНазначенияУТ.ЗаполнитьРекурсивноПоляУсловногоОформления(Элемент.Поля, Элементы.Товары.ПодчиненныеЭлементы,
		ИсключаяПоля);

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);

	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСуммаНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСтавкаНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСуммаСНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Налогообложение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыЦена.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ВидЦены");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	ЦеныПредприятияЗаполнениеСервер.УстановитьУсловноеОформлениеЦенаВключаетНДС(ЭтотОбъект);
	
	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
	//

	ЦеныПредприятияЗаполнениеСервер.УстановитьУсловноеОформлениеВидовЦен(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	МенеджерПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура МенеджерПриИзмененииНаСервере()
	ЗначениеОбъекта = РеквизитФормыВЗначение("Объект");
	ЗначениеОбъекта.ЗаполнитьИмяКонтактногоЛица();
	ЗначениеВРеквизитФормы(ЗначениеОбъекта,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ЗначениеОбъекта = РеквизитФормыВЗначение("Объект");
	ЗначениеОбъекта.ЗаполнитьКонтактныеДанные();
	ЗначениеВРеквизитФормы(ЗначениеОбъекта,"Объект");
КонецПроцедуры



#КонецОбласти