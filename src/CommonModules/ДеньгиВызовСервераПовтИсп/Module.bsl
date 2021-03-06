////////////////////////////////////////////////////////////////////////////////
// ДеньгиВызовСервераПовтИсп: Общий фунционал конфигурации 1С:Деньги
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает Истина, если используется интерфейс Такси
Функция ИспользуетсяВариантИнтерфейсаТакси() Экспорт

	Возврат КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси;
	
КонецФункции

Функция ВерсияПлатформы835() Экспорт

	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.5.0") > 0;

КонецФункции

Функция ПланыОбменаБСП() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("МобильноеПриложение");
	
	Возврат Результат;

КонецФункции

Функция РежимИспользованияПриложения() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// приложение работает в облаке
		
		Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			Возврат "Разделенный";
		Иначе
			Возврат "Неразделенный";
		КонецЕсли;
		
	Иначе
		
		ВыбранныйСпособ = Константы.ДеньгиВыбранныйСпособСинхронизации.Получить();
		Если ВыбранныйСпособ = Перечисления.СпособыСинхронизацииДанных.СинхронизацияССервисом Тогда 
			Возврат "КлиентОблака";
		
		ИначеЕсли ВыбранныйСпособ = Перечисления.СпособыСинхронизацииДанных.ОбменФайлами Тогда 
			Возврат "ЦентрМобильных"
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат "Независимый";
	
КонецФункции

Функция РежимСинхронизацииСЦБ() Экспорт
	
	Режим = РежимИспользованияПриложения();
	Возврат Режим = "Разделенный" Или режим = "КлиентОблака";
	
КонецФункции 

Функция ВалютаУчета() Экспорт
	Возврат ПараметрыСеанса.ВалютаУчета;
КонецФункции 

#КонецОбласти




 
