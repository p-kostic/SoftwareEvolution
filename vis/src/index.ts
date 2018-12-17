// import * as $ from "jquery";
import * as d3 from "d3";
import { BehaviorSubject } from 'rxjs';
import * as marked from 'marked';
import * as highlight from 'highlight.js'

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

let root;
var r = 720,
    x = d3.scaleLinear().range([0,r]),
    y = d3.scaleLinear().range([0, r]);

// Get data from csv file and call functions from promise. 
// Can only be used in promise. Thus, it dictates program flow
d3.csv('./data.csv').then(data => {
    const codeViewer = d3.select("body").append("div").attr("id", "codeViewer");
    const htmlObject = document.getElementById("codeViewer");

    requestData().then(x => {     
        if(codeViewer != null){
            codeViewer.html(marked("```javascript \n" + x.lines + "```", {highlight: (c, lang) => { return highlight.highlightAuto(c).value; }}));//highlight.highlight("java", c).value }});
        }   
    });

    let classes: number[] = <any[]>data.map(x => x["CCid"]);
    
    var color = d3.scaleSequential(d3.interpolateBlues)
    .domain([0, 6]);

    root = stratify(data)
                 .sum((d: any) => d['order'])
                 .sort(function(a: any,b: any) { return b['order'] - a["order"]});
    
    const test = pack(root);

    var node = svg.selectAll("g")
    .data(root.descendants())
    .enter().append("g")
      .attr("transform", function(d: any) { return "translate(" + d.x + "," + d.y + ")"; })
      .attr("class", function(d: any) { return "node" + (!d.children ? " node--leaf" : d.depth ? "" : " node--root"); })
      .each(function(d: any) { d.node = (<any>this); })
      .on("mouseover", (x: any) => subject.next((<any>(x.data)).CCid))
      .on("mouseout", () => subject.next(-1));

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
    
    // d3.select(window).on("click", function() { zoom(root); });

    node.append("circle")
        .attr("id", function(d: any) { return "node-" + d.id; })
        .attr("r", function(d: any) { return d.r; })
        .style("fill", function(d: any) { return color(d.depth); })
        // .on("click", function(d: any) { return zoom(node == d ? root : d); });

    var leaf = node.filter(function(d:any) { return !d.children; });

    leaf.append("clipPath")
        .attr("id", function(d:any) { return "clip-" + d.id; })
        .append("use")
        .attr("xlink:href", function(d:any) { return "#node-" + d.id + ""; });

    leaf.append("text")
        .attr("clip-path", function(d:any) { return "url(#clip-" + d.id + ")"; })
        .selectAll("tspan")
        .data(function(d: any) { return d.id; })
        .enter().append("tspan")
        .text(function(d: any) { return d; });

    node.append("title")
        .text(function(d: any) { return d.id; });
});

function zoom(d: any) {
    var k = r / d.r / 2;
    x.domain([d.x - d.r, d.x + d.r]);
    y.domain([d.y - d.r, d.y + d.r]);
  
    var t = svg.transition()
        .duration(d3.event.altKey ? 7500 : 750);
  
    t.selectAll("circle")
        .attr("cx", function(d:any) { return x(d.x); })
        .attr("cy", function(d:any) { return y(d.y); })
        .attr("r", function(d:any) { return k * d.r; });

    t.selectAll("text")
        .attr("x", function(d: any) { return x(d.x); })
        .attr("y", function(d: any) { return y(d.y); })
        .style("opacity", function(d: any) { return k * d.r > 20 ? 1 : 0; });
  
    root = d;
    d3.event.stopPropagation();
  }

function hovered(hover: any) {
    return function(d: any) {
      d3.selectAll(d.ancestors().map(function(d: any) { return d.node; })).classed("node--hover", hover);
    };
  }


function requestData(): Promise<GithubFile>{
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.github.com/repos/p-kostic/SoftwareEvolution/contents/smallsql0.21_src/src/smallsql/junit/AllTests.java#L10-L20", true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = () => { 
            if(xhr.readyState == XMLHttpRequest.DONE){
                const response = JSON.parse(xhr.responseText);
                const f: GithubFile = { lines: atob(response.content) }
                resolve(f);
            }
        }

        xhr.onerror = e => reject(e);
        xhr.send();
    });
}

export interface GithubFile {
    lines:string;
}