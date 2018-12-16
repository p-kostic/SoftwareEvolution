// import * as $ from "jquery";
import * as d3 from "d3";
import {Location, CloneClass} from "./CloneClass";

let width = 300;
let height = 200;

// Create root SVG element
d3.select("body").append("div").text("Joren is Lelijk").attr("style", "color:red").classed("newclass", true);
d3.select("body").append("div").text("Deze meme is gemaakt door de Petar-bende, check ook ff die favicon lmao");

d3.select("body").append("svg")
         .attr("width", "100%")
         .attr("height",960)
         .style('background',"LightGray")
         .append("g")
         .attr('transform','translate(' + width / 2 + ',' + height / 2 + ')'); // set to the center


// Get data from csv file and call functions from promise. 
// Can only be used in promise. Thus, it dictates program flow
d3.csv('./data.csv').then(d => {
    parseData(d);
});

function parseData(data: any[]) {
    
    // Init CloneClass
    // TODO: check for same class in id of parameter
    const cc: CloneClass = {
        locations: []
    }
    
    for (const entry of data) {
        const loc: Location = {
            path: entry.path,
            startLocation: [+entry.beginLine, +entry.beginColumn],
            endLocation:[+entry.endLine, +entry.endColumn]
        }
        cc.locations.push(loc);
    }

    console.log("cc", cc);

    return cc; 
}