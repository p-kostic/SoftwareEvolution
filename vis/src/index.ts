// import * as $ from "jquery";
import * as d3 from "d3";
import {Location, CloneClass} from "./CloneClass";
import { BehaviorSubject } from 'rxjs';

let width = 960;
let height = 960;

let svg = d3.select("body").append("svg")
            .attr("width", "100%")
            .attr("height",960)
            .style('background',"white")
            .append("g")
            .attr('transform','translate(1,1)'); // set to the center

var format = d3.format(",d");

const stratify = d3.stratify()
                   .id((d: any) => d['id'] )
                   .parentId((d: any) => {return d['parent']; });
var pack = d3.pack()
             .size([width - 2, height - 2])
             .padding(3);

const subject: BehaviorSubject<number> = new BehaviorSubject<number>(-1);

// Get data from csv file and call functions from promise. 
// Can only be used in promise. Thus, it dictates program flow
d3.csv('./data.csv').then(data => {
    console.log(data);
    
    let classes: number[] = <any[]>data.map(x => x["CCid"]);
    
    var color = d3.scaleSequential(d3.interpolateBlues)
    .domain([0, Math.max(...classes)]);

    console.log("color array", color(0));

    const root = stratify(data)
                 .sum((d: any) => d['order'])
                 .sort(function(a: any,b: any) { return b['order'] - a["order"]});
    
    const test = pack(root);

    var node = svg.selectAll("g")
    .data(root.descendants())
    .enter().append("g")
      .attr("transform", function(d: any) { console.log("TRANSFORM", d); return "translate(" + d.x + "," + d.y + ")"; })
      .attr("class", function(d) { return "node" + (!d.children ? " node--leaf" : d.depth ? "" : " node--root"); })
      .each(function(d: any) { d.node = this; })
      .on("mouseover", x => subject.next((<any>(x.data)).CCid))
      .on("mouseout", () => subject.next(-1));

      console.log("Node", node);
      console.log("root", root);
      console.log("packed root", test);
      console.log(root.descendants());

    // node.each(x => {
    //     let current = this;
    //     subject.subscribe(y => d3.select(current).style("fill", "black"));
    // });// (<any>x).node.classed("node--hover", true)));

    subject.subscribe(x => {
        if(x != -1){
            svg. selectAll("g").filter(y => ((<any>y).data).CCid == x).select("circle").style("stroke", "red");
        }
        svg.selectAll("g").filter(y => ((<any>y).data).CCid != x).select("circle").style("stroke", "");//function(d: any) { return color(d.depth); })
    });
    


    node.append("circle")
        .attr("id", function(d: any) { return "node-" + d.id; })
        .attr("r", function(d: any) { return d.r; })
        .style("fill", function(d: any) { return color(d.depth); });

    var leaf = node.filter(function(d) { return !d.children; });

    leaf.append("clipPath")
        .attr("id", function(d) { return "clip-" + d.id; })
    .append("use")
        .attr("xlink:href", function(d) { return "#node-" + d.id + ""; });

    leaf.append("text")
        .attr("clip-path", function(d) { return "url(#clip-" + d.id + ")"; })
    .selectAll("tspan")
    .data(function(d: any) { return d.id; })
    .enter().append("tspan")
        .text(function(d: any) { return d; });

    node.append("title")
        .text(function(d: any) { return d.id; });
});

function hovered(hover: any) {
    return function(d: any) {
      d3.selectAll(d.ancestors().map(function(d: any) { return d.node; })).classed("node--hover", hover);
    };
  }