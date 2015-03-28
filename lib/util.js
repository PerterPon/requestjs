
"use strict";

module.exports = {
  isObject : function ( param ){
    return typeof 'object' === param;
  },
  isString : function ( param ) {
    return typeof 'string' === param;
  },
  isNullOrUndefined : function ( param ) {
    return null === param || undefined === param;
  },
  isNull : function ( param ) {
    return null === param;
  },
  isBoolean : function ( param ) {
    return 'boolean' === typeof param;
  },
  isNumber : function ( param ) {
    return 'number' === typeof param;
  },
  isArray : function ( param ) {
    return Array.isArray( param );
  } 
}
