storageEngine = function() {
	//ITEM 6 - Estrutura criada para tratar a base de dados IndexedDB.
	var db;
	var base = "exercicio2";
	var objectStore;
	return {
		//Funcao de inicializacao
		init : function(successCallback, errorCallback) {
			if (window.indexedDB) {
				var request = indexedDB.open(base);
				request.onsuccess = function(event) {
					db = request.result;
					successCallback(null);
				}
				request.onerror = function(event) {
					errorCallback('storage_not_initalized', 'It is not possible to initialized storage');
				}
			} else {
				errorCallback('storage_api_not_supported', 'The web storage api is not supported');
			}			
		},
		//Funcao de inicializacao
		initObjectStore  : function(type, successCallback, errorCallback) {
	    	if (!db) {
				errorCallback('storage_api_not_initialized', 'The storage engine has not been initialized');
			}
	    	var exists = false;
	    	$.each(db.objectStoreNames, function(i, v) {
	    		  if (v == type) {
	    			  exists = true;
	    		  }
	    	});
	    	if (exists) {
	    		successCallback(null);
	    	} else {
		    	var version = db.version+1;
		    	db.close();
		    	var request = indexedDB.open(base, version);
				request.onsuccess = function(event) {
					successCallback(null);
				}
				request.onerror = function(event) {
					errorCallback('storage_not_initalized', 'It is not possible to initialized storage');
				}
				request.onupgradeneeded = function(event) {
					db = event.target.result;
			    	objectStore = db.createObjectStore(type, { keyPath: "id", autoIncrement: true });
					successCallback(null);
				}
	    	}
	    },
	    //Funcao para salvar os registros na base de dados
	    save : function(type, obj, successCallback, errorCallback) { 
	    	if (!db) {
	    		errorCallback('storage_api_not_initialized', 'The storage engine has not been initialized');
	    	}
	    	if (!obj.id) {
	    		delete obj.id ;
	    	} else {
	    		obj.id = parseInt(obj.id)
	    	}
	    	var transaction = db.transaction([type], "readwrite");
	    	transaction.oncomplete = function(event) {
	    		successCallback(obj);
	    	};
	    	transaction.onerror = function(event) {
	    		errorCallback('transaction_error', 'It is not possible to store the object');
	    	};
	    	objectStore = transaction.objectStore(type);
	    	var request = objectStore.put(obj);
	    	request.onsuccess = function(event) {
	    		obj.id = event.target.result
	    	}
	    	request.onerror = function(event) {
	    		errorCallback('object_not_stored', 'It is not possible to store the object');
	    	};
	    },
	    //Funcao que buscar os registros na base de dados
	    findAll : function(type, successCallback, errorCallback) { 
	    	var	request = indexedDB.open(base);
			request.onsuccess = function(event) {
				database = request.result;
				var result = [];
		    	var objectStore = database.transaction(type).objectStore(type);
		    	objectStore.openCursor().onsuccess = function(event) {
		    		var cursor = event.target.result;
		    		if (cursor) {
		    			result.push(cursor.value);
		    			cursor.continue();
		    		} else {
		    			successCallback(result);
		    		}
		    	};				
			}

	    },
	    //Funcao para deletar o registro da base de dados
	    delete : function(type, id, successCallback, errorCallback) { 
	    	var obj = {};
	    	obj.id = id;
	    	var transaction = db.transaction([type], "readwrite");
	    	transaction.oncomplete = function(event) {
	    		successCallback(id);
	    	};
	    	transaction.onerror = function(event) {
	    		errorCallback('transaction_error', 'It is not possible to store the object');
	    	};
	    	objectStore = transaction.objectStore(type);				
	    	var request = objectStore.delete(id);
	    	request.onsuccess = function(event) {				
	    	}
	    	request.onerror = function(event) {
	    		errorCallback('object_not_stored', 'It is not possible to delete the object');
	    	};
	    },
	    //Funcao para buscar registro na base de dados
	    findByProperty : function(type, propertyName, propertyValue, successCallback, errorCallback) {
	    	if (!db) {
	    		errorCallback('storage_api_not_initialized', 'The storage engine has not been initialized');
	    	}
	    	var result = [];
	    	objectStore = db.transaction(type).objectStore(type);
	    	objectStore.openCursor().onsuccess = function(event) {
	    		var cursor = event.target.result;
	    		if (cursor) {
	    			if (cursor.value[propertyName] == propertyValue) {
	    				result.push(cursor.value);
	    			}
	    			cursor.continue();
	    		} else {
	    			successCallback(result);
	    		}
	    	};
	    },
	    //Funcao para buscar registro na base de dados a partir do seu id
		findById : function (type, id, successCallback, errorCallback)	{
			if (!db) {
				errorCallback('storage_api_not_initialized', 'The storage engine has not been initialized');
			}
			var tx = db.transaction([type]);
			objectStore = tx.objectStore(type);
			var request = objectStore.get(id);
				request.onsuccess = function(event) {
				successCallback(event.target.result);
			}
			request.onerror = function(event) {
				errorCallback('object_not_stored', 'It is not possible to locate the requested object');
			};				
		}
	}
}();