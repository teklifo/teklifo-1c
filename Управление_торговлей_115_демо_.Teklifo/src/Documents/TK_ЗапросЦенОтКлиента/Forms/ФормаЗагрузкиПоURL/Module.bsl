&НаСервере
Процедура УстановитьОтборОрганизаций()
	МассивОрганизаций = TK_ОбщегоНазначенияСервер.ПолучитьСписокДоступныхОрганизаций();

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивОрганизаций)));

	НовыйПараметр = Новый ФиксированныйМассив(МассивПараметров);

	Элементы.Организация.ПараметрыВыбора = НовыйПараметр;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьОтборОрганизаций();
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнить(Команда)
	Если ЗначениеЗаполнено(Организация) Тогда
		КомандаВыполнитьНаСервере();
	Иначе
		Сообщить("Заполните организацию!"); 	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КомандаВыполнитьНаСервере()
	
	Результат = TK_РаботаСWeb.ПолучитьРезультатПолученияЗапросаЦен(СсылкаНаЗаказКлиента,Организация);
	
КонецПроцедуры

