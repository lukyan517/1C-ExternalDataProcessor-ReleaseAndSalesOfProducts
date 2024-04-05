﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Обработка Выпуск и реализация продукции для БП 3.0
// Автор: Лукьяненко Станислав Юрьевич
// Публикация доступна по ссылке:
// https://infostart.ru/1c/tools/2027409/
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере_УстановитьНачальныеЗначенияРеквизитов();
	ПриСозданииНаСервере_УстановитьИнтерфейс();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	НастройкиКолонокПоУмолчанию = ОбработкаОбъект.НастройкиКолонокПоУмолчанию();
	НастройкиКолонок = ОбщегоНазначения.СкопироватьРекурсивно(НастройкиКолонокПоУмолчанию);
	ЗаполнитьЗначенияСвойств(НастройкиКолонок, Объект);
	
	Если Не ОбщегоНазначения.КоллекцииИдентичны(НастройкиКолонокПоУмолчанию, НастройкиКолонок) Тогда
		НастроитьПолеТабличногоДокумента(ОбработкаОбъект);
	КонецЕсли;
	
	УстановитьПанель(ЭтотОбъект);
	УстановитьОтборВСпискеДокументов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершитьРаботуСОбработкой Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Завершить работу с обработкой?", РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ОбщиеПараметры.КлючОбъекта, ОбщиеПараметры.КлючНастроек, Объект.КомпоновщикНастроек.ПользовательскиеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображаемаяПанельПриИзменении(Элемент)
	
	УстановитьПанель(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьОтборВСпискеДокументов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборВСпискеДокументов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_СписокДокументов

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличногоДокумента

&НаКлиенте
Процедура НоменлатураКонтрагентыТДВыбор(Элемент, Область, СтандартнаяОбработка)
	
	//Если Область.СодержитЗначение
	//	И (Область.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Номенклатура"))
	//		Или Область.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Контрагенты"))) Тогда
	//	//Область.ЭлементУправления.КнопкаОткрытия = Истина;
	//	//Область.ЭлементУправления.КнопкаВыбора = Истина;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменлатураКонтрагентыТДПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	ПересчитатьИтоги(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменлатураКонтрагентыТДПриАктивизации(Элемент)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОтчетПроизводствоЗаСмену(Команда)
	
	КоличествоДокументов = СформироватьДокументыНаСервере(ДоступныеДокументы[0].Значение);
	ОповещениеПользователяСозданоДокументов(КоличествоДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеализацияТоваровУслуг(Команда)
	
	КоличествоДокументов = СформироватьДокументыНаСервере(ДоступныеДокументы[1].Значение);
	ОповещениеПользователяСозданоДокументов(КоличествоДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНоменклатуруИКонтрагентов(Команда)
	
	ЗаполнитьНоменклатуруИКонтрагентовНаСервере();
	Объект.ОтображаемаяПанель = Элементы.ОтображаемаяПанель.СписокВыбора[0].Значение;
	УстановитьПанель(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуруИКонтрагентовНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ЭлементыСправочников = ОбработкаОбъект.ПолучитьСправочникиПоОтбору(Объект.КомпоновщикНастроек.ПолучитьНастройки(), АдресСКД);
	
	ЗаполнитьСправочники(ЭтотОбъект, ЭлементыСправочников.Номенклатура, Ложь);
	ЗаполнитьСправочники(ЭтотОбъект, ЭлементыСправочников.Контрагенты, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДокументы(Команда)
	
	СтраницаНоменклатура 	= Элементы.ОтображаемаяПанель.СписокВыбора[0].Значение;
	СтраницаДокументы 		= Элементы.ОтображаемаяПанель.СписокВыбора[1].Значение;
	
	Объект.ОтображаемаяПанель = ?(Объект.ОтображаемаяПанель = СтраницаДокументы, СтраницаНоменклатура, СтраницаДокументы);
	УстановитьПанель(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	Объект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТабличныйДокумент(Команда)
	НастроитьПолеТабличногоДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТабличныйДокументПоУмолчанию(Команда)
	НастроитьПолеТабличногоДокумента(, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриСозданииНаСервере

&НаСервере
Функция ПриСозданииНаСервере_УстановитьНачальныеЗначенияРеквизитов()
	
	ОбработкаОбъект 	= РеквизитФормыВЗначение("Объект");
	ОбщиеПараметры 		= ОбработкаОбъект.ОбщиеПараметрыФормы();
	ДоступныеДокументы 	= ОбработкаОбъект.ДоступныеВидыДокументов();
	ОбработкаОбъект.ИнициализироватьКомпоновщикНастроек(Объект.КомпоновщикНастроек, УникальныйИдентификатор, АдресСКД);
	
	СКД = ПолучитьИзВременногоХранилища(АдресСКД);
	НастройкиПоУмолчанию = СКД.НастройкиПоУмолчанию;
	
	ПользовательскиеНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ОбщиеПараметры.КлючОбъекта, ОбщиеПараметры.КлючНастроек);
	
	Если ПользовательскиеНастройки <> Неопределено Тогда
		Объект.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
	КонецЕсли;
	
	НастроитьПолеТабличногоДокумента(ОбработкаОбъект);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("СозданныеДокументы", Новый Массив);
	Объект.Дата = ТекущаяДата();
	Объект.СчетЗатрат = ПланыСчетов.Хозрасчетный.ОсновноеПроизводство;
	
КонецФункции

&НаСервере
Функция ПриСозданииНаСервере_УстановитьИнтерфейс()
	
	Заголовок = ОбщиеПараметры.ЗаголовокФормы;
	
	Объект.ОтображаемаяПанель = Элементы.ОтображаемаяПанель.СписокВыбора[0].Значение;
	УстановитьПанель(ЭтотОбъект);
	
	ЭлементыКоманднойПанели = Элементы.ГруппаКоманднаяПанель.ПодчиненныеЭлементы.СписокДокументовСоздать.ПодчиненныеЭлементы;
	ЭлементыКонтекстногоМеню = Элементы.СписокДокументов.КонтекстноеМеню.ПодчиненныеЭлементы.СписокДокументовКонтекстноеМенюСоздать.ПодчиненныеЭлементы;
	
	УстановитьДоступныеКоманды(ЭлементыКоманднойПанели);
	УстановитьДоступныеКоманды(ЭлементыКонтекстногоМеню);
	УстановитьОтборВСпискеДокументов(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанель;
	
	ТипыДокументов = Новый Массив;
	Для Каждого ДоступныйДокумент Из ДоступныеДокументы Цикл
		ТипыДокументов.Добавить(Тип(СтрШаблон("ДокументСсылка.%1", ДоступныйДокумент.Значение)));
	КонецЦикла;
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ТипыДокументов);
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецФункции

&НаСервере
Процедура УстановитьДоступныеКоманды(СписокЭлементов)
	
	Для Каждого Элемент Из СписокЭлементов Цикл
		
		ИмяКоманды = СтрЗаменить(Элемент.Имя, 	"СписокДокументовСоздатьПоПараметру", "");
		ИмяКоманды = СтрЗаменить(ИмяКоманды, 	"СписокДокументовКонтекстноеМенюСоздатьПоПараметру", "");
		
		Если ДоступныеДокументы.НайтиПоЗначению(ИмяКоманды) = Неопределено Тогда
			Элемент.Доступность = Ложь;
			Элемент.Видимость = Ложь;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбщегоНазначения

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПанель(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	Элементы.Страницы.ТекущаяСтраница = Элементы["Страница" + Форма.Объект.ОтображаемаяПанель];
	
	СтраницаДокументы = Элементы.ОтображаемаяПанель.СписокВыбора[1].Значение;
	
	Элементы.ПоказатьДокументы.Пометка = ?(Объект.ОтображаемаяПанель = СтраницаДокументы, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПользователя(ТекстСообщения = "", ТекстПояснения = "", УникальныйИдентификатор = Неопределено) Экспорт
	
	// Примеры
	// ТекстСообщения = "Некорректное значение.";
	// ТекстПояснения = "Недопустимые символы удалены.";
	ПоказатьОповещениеПользователя(
		ТекстСообщения,
		,
		ТекстПояснения,
		БиблиотекаКартинок.Информация32,
		СтатусОповещенияПользователя.Важное,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяСобытия(Окончание = "")

	Возврат "Обработка Выпуск и реализация продукции" + ?(Окончание = "", "", ". " + Окончание);

КонецФункции

#КонецОбласти

#Область ТабличныйДокумент

&НаСервере
Процедура НастроитьПолеТабличногоДокумента(Знач ОбработкаОбъект = Неопределено, ПоУмолчанию = Ложь)
	
	Если ОбработкаОбъект = Неопределено Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	Если ПоУмолчанию Тогда
		НастройкиКолонокПоУмолчанию = ОбработкаОбъект.НастройкиКолонокПоУмолчанию();
		ЗаполнитьЗначенияСвойств(ОбработкаОбъект, НастройкиКолонокПоУмолчанию);
	КонецЕсли;
	
	ОбработкаОбъект.НастроитьПолеТабличногоДокумента(НоменлатураКонтрагентыТД);
	
	СписокРеквизитов =
	"НомерПервойКолонки,
	|НомерПоследнейКолонки,
	|НомерПервойСтроки,
	|НомерПоследнейСтроки,
	|НомерСтрокиИтого,
	|ШиринаКолонки,
	|КоличествоКолонок,
	|КоличествоСтрок,
	|";
	
	Разделитель = ", " + Символы.ПС;
	
	ЗначенияРеквизитов = Новый Структура(СтрСоединить(СтрРазделить(СписокРеквизитов, Разделитель, Ложь), ","));
	ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ОбработкаОбъект);
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСправочники(Форма, МассивЭлементов, ЗаполнениеКонтрагентов = Ложь)
	
	ТабДокумент = Форма.НоменлатураКонтрагентыТД;
	
	Объект = Форма.Объект;
	
	Если ЗаполнениеКонтрагентов Тогда
		НомерПоследнейЯчейки = Мин(Объект.НомерПоследнейСтроки, ТабДокумент.ВысотаТаблицы);
		НомерПервойЯчейки = Объект.НомерПервойСтроки;
	Иначе
		НомерПоследнейЯчейки = Мин(Объект.НомерПоследнейКолонки, ТабДокумент.ШиринаТаблицы);
		НомерПервойЯчейки = Объект.НомерПервойКолонки;
	КонецЕсли;
	
	ИндексВМассиве = 0;
	
	Для НомерЯчейки = НомерПервойЯчейки По НомерПоследнейЯчейки Цикл
		
		Если ЗаполнениеКонтрагентов Тогда
			НомерСтроки = НомерЯчейки;
			НомерКолонки = 1;
		Иначе
			НомерСтроки = 1;
			НомерКолонки = НомерЯчейки;
		КонецЕсли;
		
		Область = ТабДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
		
		ЗначениеЯчейки = Неопределено;
		Если ТипЗнч(МассивЭлементов) = Тип("Массив") И (ИндексВМассиве <= МассивЭлементов.ВГраница()) Тогда
			ЗначениеЯчейки = МассивЭлементов[ИндексВМассиве];
		КонецЕсли;
		
		Область.Значение = ЗначениеЯчейки;
		ИндексВМассиве = ИндексВМассиве + 1;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗначениеЯчейки(ТабДокумент, НомерПервСтроки, НомерПервКолонки, НомерПоследСтроки, НомерПоследКолонки, Значение = Истина)
	
	Возврат ТабДокумент.Область(НомерПервСтроки, НомерПервКолонки, НомерПоследСтроки, НомерПоследКолонки)[?(Значение, "Значение", "Текст")];
	
КонецФункции

&НаКлиенте
Процедура ПересчитатьИтоги(Область = Неопределено) Экспорт
	
	ТабДокумент = НоменлатураКонтрагентыТД;
	
	ТекНомерПервойКолонки 		= Объект.НомерПервойКолонки;
	ТекНомерПоследнейКолонки 	= Мин(Объект.НомерПоследнейКолонки, ТабДокумент.ШиринаТаблицы);
	ТекНомерПоследнейСтроки 	= Мин(Объект.НомерПоследнейСтроки, ТабДокумент.ВысотаТаблицы);
	
	Если ТипЗнч(Область) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		
		Если Не (Область.Лево >= Объект.НомерПервойКолонки
			   И Область.Лево <= ТекНомерПоследнейКолонки
			   И Область.Верх >= Объект.НомерПервойСтроки
			   И Область.Верх <= ТекНомерПоследнейСтроки) Тогда
			   Возврат;
		КонецЕсли;
		
		ТекНомерПервойКолонки 			= Область.Лево;
		ТекНомерПоследнейКолонки 		= Область.Право;
		   
	КонецЕсли;
	
	Для НомерКолонки = ТекНомерПервойКолонки По ТекНомерПоследнейКолонки Цикл
		
		Количество = 0;
		
		Для НомерСтроки = Объект.НомерПервойСтроки По ТекНомерПоследнейСтроки Цикл
			
			ТекКоличество = ПолучитьЗначениеЯчейки(ТабДокумент, НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			ТекКоличество = ?(ТипЗнч(ТекКоличество) = Тип("Число"), ТекКоличество, 0);
			
			Количество = Количество + ТекКоличество;
			
		КонецЦикла;
		
		ЯчейкаИтого = ТабДокумент.Область(Объект.НомерСтрокиИтого, НомерКолонки, Объект.НомерСтрокиИтого, НомерКолонки);
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЯчейкаИтого, "Значение") Тогда
			ЯчейкаИтого.Значение = Количество;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СписокДокументов

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборВСпискеДокументов(Форма)
	
	КомпоновщикНастроек = Форма.СписокДокументов.КомпоновщикНастроек;
	СписокДокументов = Форма.СписокДокументов;
	ОбщиеПараметры = Форма.ОбщиеПараметры;
	Объект = Форма.объект;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов, "Комментарий", ОбщиеПараметры.Комментарий, ВидСравненияКомпоновкиДанных.Содержит,, Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов, "Организация", Объект.Организация, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ОтборДинамическогоСписка = СписокДокументов.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	
	УстановитьЭлементОтбораПоПредставлению(
		ОтборДинамическогоСписка, "Дата", НачалоДня(Объект.Дата), ВидСравненияКомпоновкиДанных.БольшеИлиРавно, "Начало периода", Истина);
		
	УстановитьЭлементОтбораПоПредставлению(
		ОтборДинамическогоСписка, "Дата", КонецДня(Объект.Дата), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, "Конец периода", Истина);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЭлементОтбораПоПредставлению(ОбластьПоискаДобавления,
								Знач ИмяПоля,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Представление,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено)
								
	МассивЭлементов = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ОбластьПоискаДобавления,, Представление);
	
	Если МассивЭлементов.Количество() Тогда
		
		ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(
			ОбластьПоискаДобавления,, Представление, ПравоеЗначение, ВидСравнения, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
		
	Иначе
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ОбластьПоискаДобавления, ИмяПоля, ВидСравнения, ПравоеЗначение, Представление, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
			
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаСервере
Функция СформироватьДокументыНаСервере(ВидыДокументов, ДополнительныеПараметрыДокументов = Неопределено)

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	МассивДокументов = ОбработкаОбъект.СоздатьДокументы(НоменлатураКонтрагентыТД, ВидыДокументов, ДополнительныеПараметрыДокументов);
	
	Если Не ЗначениеЗаполнено(МассивДокументов) Тогда
		Возврат 0;
	КонецЕсли;
		
	Объект.ОтображаемаяПанель = Элементы.ОтображаемаяПанель.СписокВыбора[1].Значение;
	УстановитьПанель(ЭтотОбъект);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("СозданныеДокументы", МассивДокументов);
	
	Возврат МассивДокументов.Количество();

КонецФункции

&НаКлиенте
Процедура СписокДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Параметр = Неопределено;
	
	Если Отказ Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьВыборИзМенюЗавершение", ЭтотОбъект, Неопределено);
		ПоказатьВыборИзМеню(ОписаниеОповещения, ДоступныеДокументы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВыборИзМенюЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(СтрШаблон("Документ.%1.Форма.ФормаДокумента", ВыбранныйЭлемент.Значение), ПараметрыФормы, Элементы.СписокДокументов);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокумент(ВидДокумента)

	

КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПользователяСозданоДокументов(КоличествоДокументов)

	ОповещениеПользователя(,СтрШаблон("Создано документов: %1", КоличествоДокументов));

КонецПроцедуры


#КонецОбласти

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокДокументов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокДокументов);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗавершитьРаботуСОбработкой = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
