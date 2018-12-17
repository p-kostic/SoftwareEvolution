// import * as $ from "jquery";
import * as d3 from "d3";
import { BehaviorSubject } from 'rxjs';
import * as marked from 'marked';
import * as highlight from 'highlight.js';

let svg = d3.select("svg"),
          margin = 100,
          diameter = +svg.attr("width"),
          g = svg.append("g").attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");

var color = d3.scaleSequential(d3.interpolateBlues)
.domain([0, 4]);

const stratify = d3.stratify()
                   .id((d: any) => d['id'] )
                   .parentId((d: any) => {return d['parent']; });
var pack = d3.pack()
             .size([diameter - margin, diameter - margin])
             .padding(2);

const subject: BehaviorSubject<number> = new BehaviorSubject<number>(-1);

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
  
    const root = stratify(data)
                 .sum((d: any) => d['order'])
                 .sort(function(a: any,b: any) { return b['order'] - a["order"]});
    
    let focus = root, 
        nodes = pack(root).descendants(),
        view

    var circle = g.selectAll("circle")
                  .data(nodes)
                  .enter().append("circle")
                    .style("fill", function(d) { return color(d.depth) })
                    .attr("class", function(d) { return "node" + (!d.children ? " node--leaf" : d.depth ? "" : " node--root"); })
                    .on("mouseover", (x: any) => subject.next(x.data.CCid) )
                    .on("mouseout", () => subject.next(-1))
                    .on("click", function(d) { 
                        if (focus !== d && d.children) 
                          zoom(d),
                          d3.event.stopPropagation();
                        
                    });

    var text = g.selectAll("text")
    .data(nodes)
    .enter().append("text")
      .attr("class", "label")
      .style("fill-opacity", function(d: any) { return d.parent === root ? 1 : 0; })
      .style("display", function(d: any) { return d.parent === root ? "inline" : "none"; })
      .text(function(d: any) { return d.data.id; })
    
    var node = g.selectAll("circle,text");

    svg.style("background", color(-1));
       //.on("click", function() { zoom(root); });

    zoomTo([(<any>root).x, (<any>root).y, (<any>root).r * 2 + margin]);

    // CLONE STROKES
    subject.subscribe(x => {
      console.log(x);
      if(x != -1){
          svg. selectAll("circle").filter((y: any) => y.data.CCid == x).style("stroke", "red");
      }
      svg.selectAll("circle").filter((y: any) => y.data.CCid != x).style("stroke", "");
    });

    // ZOOMING
    function zoom(d) {
      var focus0 = focus; focus = d;
  
      var transition = d3.transition()
          .duration(d3.event.altKey ? 7500 : 750)
          .tween("zoom", function(d: any) {
            var i = d3.interpolateZoom(view, [(<any>focus).x, (<any>focus).y, (<any>focus).r * 2 + margin]);
            return function(t) { zoomTo(i(t)); };
          });
      
      transition.selectAll("text")
        .filter(function(d:any) { return d.parent === focus || (<any>this).style.display === "inline"; })
        .style("fill-opacity", function(d: any) { return d.parent === focus ? 1 : 0; })
        .on("start", function(d:any) { if (d.parent === focus) (<any>this).style.display = "inline"; })
        .on("end", function(d:any) { if (d.parent !== focus) (<any>this).style.display = "none"; });
    }
    
    function zoomTo(v: any) {
      var k = diameter / v[2]; view = v;
      node.attr("transform", function(d: any) { return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")"; });
      circle.attr("r", function(d: any) { return d.r * k; });
    }
});

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