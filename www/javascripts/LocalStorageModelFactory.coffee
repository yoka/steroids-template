angular.module("StorageFactories", []).factory "LocalStorageFactory", [
  "$q",
  ($q)->

    class LocalStorageFactory
      constructor: (@opts)->
        @modelName = @opts.model

        return {
          all: @getAll
          save: @save
          update: @update
          create: @create
          get: @getById
          destroy: @destroyById
        }

      generateGUID: ()=>
        "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c)->
          r = Math.random()*16|0
          v = if c is 'x' then r else (r&0x3|0x8)
          v.toString(16)

      setLocalStorage: (arr)->
        window.localStorage.setItem @modelName, JSON.stringify(arr)

      getLocalStorage: ()->
        raw = window.localStorage.getItem @modelName
        if raw? then JSON.parse(raw) else []

      getAll: ()=>
        deferred = $q.defer()
        deferred.resolve @getLocalStorage() || []
        deferred.promise

      getById: (id)=>
        deferred = $q.defer()
        @getAll().then (objects)->
          deferred.resolve o for o in objects when o.id is id
        deferred.promise

      destroyById: (id)=>
        deferred = $q.defer()
        @getAll().then (objects)=>
          allButOne = (o for o in objects when o.id isnt id)
          @setLocalStorage allButOne
          deferred.resolve allButOne
        deferred.promise

      create: (obj)=>
        deferred = $q.defer()
        obj.id = @generateGUID()
        @getAll().then (objects)=>
          objects.push obj
          @setLocalStorage objects
        deferred.resolve obj
        return deferred.promise

      update: (obj)=>
        deferred = $q.defer()
        @getAll().then (objects)=>
          updatedObjects = ((if o.id is obj.id then obj else o) for o in objects)
          @setLocalStorage updatedObjects
          deferred.resolve obj
        deferred.promise

      save: (obj)=>
        if obj.id? then @update(obj) else @create(obj)

    return LocalStorageFactory
]
