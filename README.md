# CF DI Component
 ColdFusion Direct Injection Compoonent Extender

## Installation

Just download the CFC file and add to you project.

## Usage

Use Injectable.cfc file as base class and extend your other classes from it.

```javascript

     component extends="Injectable" {

```

Then just use component property to define you dependency injection 

```javascript 

     property name="NAME_OF_PROPERTY" type="object" di:component="NAME_OF_INJECTED COMPONENT" di:scope=""  di:access="";

```

di:componet = Name of the injected component (use dot notation to provide path)

di:scope    = LOCAL / REQUEST / SESSION / APPLICATION - Where to save the created instance. Local scope always create new instance.

di:access   = PRIVATE / PUBLIC - defines whether the created object will be saved in VARIABLES (private) or THIS (public) scope.


### Don't forget to initilize the class
```javascript
     super.init();
```


## License
[MIT](https://choosealicense.com/licenses/mit/)
