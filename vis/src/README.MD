# Vue.js D3 Poc
### Creating D3 Visualisations with Vue.js.


## A Note on TSLint Rules

The following is required because one of the ArrayProps example files (ArrayPropsExample4.vue) uses a class extension method recommended by Egghead.io.  Not recommended setting
    
    "max-classes-per-file": [true, 2],

I have also disabled member ordering..

    "member-ordering": false

This is required because Typescript misinterprets the following instance *method* as an instance *field*.

    createArea = d3.area<Point>().x((d) => d.x).y0((d) => d.max).y1((d) => d.y);

I tried to force TS to recognise it was a method but ran into some issues with the @types/d3 incorrectly describing the d3.area method as returning an Area<Type> instead of a string (which it seems to return), specifically:-

    export function area<Datum>(): Area<Datum>;

This one just annoys me.

    "trailing-comma": [true, {"multiline": "ignore", "singleline": "ignore"}],