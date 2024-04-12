&НаКлиенте
Асинх Процедура КомандаОпубликовать(Команда)
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда
		обещание = ВопросАсинх("Документ не проведен. Провести?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		Результат = Ждать обещание;
		Если Результат = КодВозвратаДиалога.Да Тогда
			Отказ = Не Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если Не Отказ Тогда
		НачатьПубликацию();
	Иначе
		ВызватьИсключение "Не удалось провести документ";
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекДанные = Элементы.Товары.ТекущиеДанные;

	Если Не ЗначениеЗаполнено(ТекДанные.ИдентификаторСтроки) Или НоваяСтрока Тогда
		ТекДанные.ИдентификаторСтроки = TK_ОбщегоНазначенияСервер.ПолучитьНовыйИдентификатор();
	КонецЕсли;

КонецПроцедуры
&НаКлиенте
Асинх Процедура НачатьПубликацию()

	обещание = ВопросАсинх("Выполнить публикацию документа?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Результат = Ждать обещание;
	Если Результат = КодВозвратаДиалога.Да Тогда
		//В случае подтверждения выполняем отправку
		Результат = РезультатОтправкиДокумента();//Булево

		Если Результат Тогда
			ОткрытьФорму("Документ.TK_ЗапросЦенПоставщикам.Форма.ФормаРезультатаВыгрузки",
				Новый Структура("ДокументСсылка", Объект.Ссылка));
			TK_ОбщегоНазначенияСервер.УстановитьСтатусДокументаЗаказаЦенПоставщику(Объект.Ссылка,
				ПредопределенноеЗначение("Перечисление.TK_СтатусыДокументаЗапросЦенПоставщикам.Опубликован"));
		КонецЕсли;

		ВывестиСсылкуНаДокумент();

		ОтобразитьТекущийСтатусДокумета();

	КонецЕсли;
КонецПроцедуры
&НаКлиенте
Процедура КомандаСкопироватьСсылкуВБуфер(Команда)
	
	СсылкаДляЗапуска = TK_ОбщегоНазначенияСервер.ПолучитьСсылкуНаДокумент_ДляЗапуска(Объект.Ссылка);
	
	TK_ОбщегоНазначенияКлиент.УстановитьТекстВБуферОбмена(СсылкаДляЗапуска);
КонецПроцедуры
&НаСервере
Функция РезультатОтправкиДокумента()
	Возврат TK_РаботаСWeb.ПолучитьРезультатОтправкиДокументаЗапросЦенПоставщикам(Объект.Ссылка);
КонецФункции





// СтандартныеПодсистемы.Печать 
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
КонецПроцедуры 
// Конец СтандартныеПодсистемы.Печать 
// СтандартныеПодсистемы.ПодключаемыеКоманды 
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры 
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
КонецПроцедуры
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОтобразитьТекущийСтатусДокумета();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
     // СтандартныеПодсистемы.ПодключаемыеКоманды 
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект); 
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

	УстановитьОтборОрганизаций();

	ВывестиСсылкуНаДокумент();

	ОтобразитьТекущийСтатусДокумета();

КонецПроцедуры
&НаСервере
Процедура ВывестиСсылкуНаДокумент()

	СсылкаНаДокумент = TK_ОбщегоНазначенияСервер.ПолучитьВнешнююСсылкуНаДокументЗаказаЦенПоставщикам(Объект.Ссылка);

    Элементы.ГруппаСсылкаНаДокумент.Видимость =  ЗначениеЗаполнено(СсылкаНаДокумент);
КонецПроцедуры
&НаСервере
Процедура ОтобразитьТекущийСтатусДокумета()

	СтатусДокумента = TK_ОбщегоНазначенияСервер.ПолучитьСтатусДокументаЗаказаЦенПоставщику(Объект.Ссылка);
	
	Если Не ЗначениеЗаполнено(СтатусДокумента) Тогда
		СтатусДокумента = Перечисления.TK_СтатусыДокументаЗапросЦенПоставщикам.НеОпубликован;
	КонецЕсли;


    Элементы.ГруппаОповещениеОбОбновленииДокумента.Видимость = СтатусДокумента = Перечисления.TK_СтатусыДокументаЗапросЦенПоставщикам.ТребуетОбновления;

КонецПроцедуры
&НаКлиенте
Процедура СсылкаНаДокументНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если ЗначениеЗаполнено(СсылкаНаДокумент) Тогда
        TK_ОбщегоНазначенияКлиент.ОткрытьСсылкуНаКлиенте(Объект.Ссылка);		
	КонецЕсли;

КонецПроцедуры
&НаСервере
Процедура УстановитьОтборОрганизаций()
	МассивОрганизаций = TK_ОбщегоНазначенияСервер.ПолучитьСписокДоступныхОрганизаций();

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивОрганизаций)));

	НовыйПараметр = Новый ФиксированныйМассив(МассивПараметров);

	Элементы.Организация.ПараметрыВыбора = НовыйПараметр;
КонецПроцедуры