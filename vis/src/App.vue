<template>
  <div id="app">
    <img src="./assets/logo.png" class="logo-img">
    <img src="./assets/typescript.svg" class="logo-img">
    <img src="./assets/d3-black.png" class="logo-img">
    <HelloWorld msg="Vue.js + TypeScript + D3 Proof of concept"/>
    
    <h1>Typescript + vue-class-component + vue-property-decorator</h1>
    <responsive-area-chart
      @select="onSelect"
      :data="data"
      :ceil="80"
      class="area-chart"/>

    <h1>Canonical Vue.js + javascript</h1>
    <responsive-area-chart-no-class
      @select="onSelect"
      :data="data"
      :ceil="80"
      class="area-chart"/>
    <p>currentValue:{{currentValue}}</p>
    
    <hr/>
    <h1>Array Props Examples</h1>
    <h2>Both specified</h2>
    <ArrayPropsExample2 test1="Overrided Prop" :test2="['o', 'v', 'e']"/>
    
    <h2>Test1 (string) specified</h2>
    <ArrayPropsExample2 test1="Overrided Prop"/>
    
    <h2>Test2(Array) specified</h2>
    <ArrayPropsExample2 :test2="['o', 'v', 'e']"/>
    
    <h2>None specified</h2>
    <ArrayPropsExample2/>

    <h2>Violate the type contract (array of strings in Test2)</h2>
    <ArrayPropsExample2 :test2="[1, 2, 3]"/>
    
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import HelloWorld from './components/HelloWorld.vue';
import ResponsiveAreaChart from './components/ResponsiveAreaChart.vue';
import ResponsiveAreaChartNoClass from './components/ResponsiveAreaChartNoClass.vue';
import { Location, CloneClass } from './models/model';

@Component({
  components: {
    HelloWorld,
    ResponsiveAreaChart,
    ResponsiveAreaChartNoClass
  },
})
export default class App extends Vue {
  data: any = [];
  currentValue: number = 0;
  onSelect(value) {
    this.currentValue = value;
  }

  mounted() {
    setInterval(() => {
      this.data = {}; // generateData(50, 10, 80);
    }, 2000);
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

.logo-img {
  width: 200px;
  height: 200px;
}

.area-chart {
  height: 300px
}
</style>