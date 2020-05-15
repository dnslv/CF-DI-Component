
component {

    variables.scopeList = "application,session,request,local";
    variables.scopeKey = "_DI";

    function init(scopeKey = "") {
        
        if (len(arguments.scopeKey)) {
            variables.scopePrefix = arguments.scopeKey;
        }

        //Get all properties of component (THIS scope)
        local.allProps = structFindKey(getMetadata(this), "properties", "all");

        for (local.prop in local.allProps) {

            local.propMetaData = local.prop.value;

            if (isArray(local.propMetaData) and local.propMetaData.len()) {
                
                for (local.currentProp in local.propMetaData) {

                    //Inject Dependency Component
                    if (isStruct(local.currentProp) and structKeyExists(local.currentProp, "di:component")) {
    
                        local.currentComponentInstance = getComponentInstance(local.currentProp["di:component"], local.currentProp["di:scope"]);
                        
                        if (local.currentProp["di:access"] eq "public") {
                            this[local.currentProp.name] = local.currentComponentInstance;
                        }
                        else {
                            variables[local.currentProp.name] = local.currentComponentInstance;
                        }

                    }
                } 
            }
       }

       return this;
    }

    private component function getComponentInstance(string componentName, string componentScope = "local") {
        
        // Validate passed scope
        if (not listFindNoCase(variables.scopeList, arguments.componentScope)) {
            throw (type="Application", message="Invalid scope name.", detail="Valid values APPLICATION, SESSION, REQUEST, LOCAL");
        } 
        
        // LOCAL - alway requires new component instance
        if (arguments.componentScope eq "local") {
           return createObject("component", arguments.componentName);
        }

        // Save component instance in requsted scope        
        if (arguments.componentScope eq "application") {
            if (isDefined("application['#variables.scopeKey#']['#arguments.componentName#']")){
                local.componentInstance = application[variables.scopeKey][arguments.componentName];
              
            }
            else {
                local.componentInstance = createObject("component", arguments.componentName);
                application[variables.scopeKey][arguments.componentName] = local.componentInstance;
            }
        }
        else if (arguments.componentScope eq "session") {
            if (isDefined("session['#variables.scopeKey#']['#arguments.componentName#']")){
                local.componentInstance = session[variables.scopeKey][arguments.componentName];
            }
            else {
                local.componentInstance = createObject("component", arguments.componentName);
                session[variables.scopeKey][arguments.componentName] = local.componentInstance;
            }
        }
        else if (arguments.componentScope eq "request") {
            if (isDefined("request['#variables.scopeKey#']['#arguments.componentName#']")){
                local.componentInstance = request[variables.scopeKey][arguments.componentName];
            }
            else {
                local.componentInstance = createObject("component", arguments.componentName);
                request[variables.scopeKey][arguments.componentName] = local.componentInstance;
            }
        }

        return local.componentInstance;
       
    }

    

}
