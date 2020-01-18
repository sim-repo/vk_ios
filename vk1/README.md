<H1>Описание</H1>

<H3>Модули и их подмодули:</H3> 
1. Новостной блок (News, Comment, Likes)
2. Список друзей (Friend, FriendWall)
3. Список групп (MyGroups, Groups)
4. Настройки (Profile)


<H3>Инициализация Presenters:</H3>
1. Отношение Presenter-View: 1-1  ( FriendPresenter, Friend_ViewController) \
2. Каждый Presenter может инициализироваться в любой точке приложения\
3. Порядок инциализации: сначала Presenter, потом возможно View\
4. создается как singleton  фабричным классом Services->Factory->PresenterFactory\
5. связи между view-presenter описывается типом enum: Services->Factory->ModuleEnum\



<H3>Поведение Presenters:</H3>
1. есть два базовых класса Presenter: PlainBasePresenter и SectionedBasePresenter, поддерживающие работу с TableView, CollectionView без секций и с секциями соотвественно\
2.  Базовые классы описывают:\
∙ инциализацию "naked initial" и вместе с view-контроллером + валидация\
∙ хранят  объект datasource, добавляют в нее данные + сортировка + валидация\
3. Модульные Presenters \
∙ наследуются от базового + ModelOwnerPresenterProtocol, который нужен для привязки презентера к модулю\
∙ переопределяют функцию enrichData, когда требуется специфичная мутация datasource\
∙ могут быть дочерними, тогда имплементируют протокол DetailPresenterProtocol (например, PostLikesPresenter)\
∙ могут поддерживать пагинацию, тогда имплементация на PaginationPresenterProtocol (пример, NewsPresenter)\


<H3>Протоколы Presenters:</H3>\
1. PullPlainPresenterProtocol - содержит методы, вызываемые из view\
2. SynchronizedPresenterProtocol - соответственно вызывается из синхронайзеров (Services->Synchronizers)\
3. PushPlainViewProtocol - описание view-методов, которые "дергает" презентер\

<H3>Синхронизаторы:</H3>\
1. прослойка, между презенторами и сетевым слоем, принимающая решение нужно ли создавать сетевой запрос или брать данные из локальной БД (пример, Services->Synchronizer->SyncModule->SyncNews)\
2. поддерживает обновление в background-режиме приложения (Services->Synchronizer->SyncModule->SyncMgt+Common метод scheduleNextSync)\

