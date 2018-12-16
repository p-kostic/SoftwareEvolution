// import * as $ from "jquery";
import * as d3 from "d3";
import {Location, CloneClass} from "./CloneClass";

let width = 960;
let height = 960;

let svg = d3.select("body").append("svg")
            .attr("width", "100%")
            .attr("height",960)
            .style('background',"LightGray")
            .append("g")
            .attr('transform','translate(1,1)'); // set to the center

var color = d3.scaleSequential(d3.interpolateMagma)
            .domain([-4, 4]);

var format = d3.format(",d");

const stratify = d3.stratify()
                   .id((d: any) => d['id'] )
                   .parentId((d: any) => {return d['parent']; });
var pack = d3.pack()
             .size([width - 2, height - 2])
             .padding(3);

// Get data from csv file and call functions from promise. 
// Can only be used in promise. Thus, it dictates program flow
d3.csv('./data.csv').then(data => {
    console.log(data);

    const root = stratify(data)
                 .sum((d: any) => d['CCId'])
                 .sort(function(a: any,b: any) { return b['CCId'] - a["CCId"]});
    
    const test = pack(root);

    var node = svg.selectAll("g")
    .data(root.descendants())
    .enter().append("g")
      .attr("transform", function(d: any) { console.log("TRANSFORM", d);return "translate(" + d.x + "," + d.y + ")"; })
      .attr("class", function(d) { return "node" + (!d.children ? " node--leaf" : d.depth ? "" : " node--root"); })
      .each(function(d: any) { d.node = this; })
      .on("mouseover", hovered(true))
      .on("mouseout", hovered(false));

      console.log("Node", node);
      console.log("root", root);
      console.log("packed root", test);
      console.log(root.descendants());

    node.append("circle")
        .attr("id", function(d: any) { return "node-" + d.id; })
        .attr("r", function(d: any) { return 100; })
        .style("fill", function(d: any) { return color(d.depth); });

    var leaf = node.filter(function(d) { return !d.children; });

    leaf.append("clipPath")
        .attr("id", function(d) { return "clip-" + d.id; })
    .append("use")
        .attr("xlink:href", function(d) { return "#node-" + d.id + ""; });

    leaf.append("text")
        .attr("clip-path", function(d) { return "url(#clip-" + d.id + ")"; })
    .selectAll("tspan")
    .data(function(d: any) { return d.id.substring(d.id.lastIndexOf(".") + 1).split(/(?=[A-Z][^A-Z])/g); })
    .enter().append("tspan")
        .attr("x", 0)
        .attr("y", function(d, i, nodes) { return 13 + (i - nodes.length / 2 - 0.5) * 10; })
        .text(function(d: any) { return d; });

    node.append("title")
        .text(function(d: any) { return d.id + "\n" + format(d["CCId"]); });
});

function hovered(hover: any) {
    return function(d: any) {
      d3.selectAll(d.ancestors().map(function(d: any) { return d.node; })).classed("node--hover", hover);
    };
  }