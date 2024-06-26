#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ДокументСсылка", Документ);

	ВнешняяСсылка = TK_ОбщегоНазначенияВызовСервера.ВнешняяСсылкаНаОпубликованныйДокумент(Документ);

	Если Не ЗначениеЗаполнено(ВнешняяСсылка) Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВнешняяСсылкаНажатие(Элемент, СтандартнаяОбработка)

	ЗапуститьПриложение(ВнешняяСсылка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкопироватьСсылкуВБуфер(Команда)

	TK_ОбщегоНазначенияКлиент.СкопироватьТекстВБуферОбмена(Элементы.БуферОбмена, ВнешняяСсылка);

КонецПроцедуры

#КонецОбласти