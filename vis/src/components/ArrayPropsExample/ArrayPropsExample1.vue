<template>
  <p>Example1 {{computedMessage}}</p>
</template>

<script lang="ts">
// Attempting to follow the example here... https://github.com/vuejs/vue-class-component/blob/master/example/App.vue
// the test1 and test2 class members are required to prevent Lint errors
// the example uses the 'propVariable' name in the props and then 'variable' in the class member,
// so I have followed this example even though it looks stoopid to me

import Vue from 'vue';
import Component from 'vue-class-component';

const AppProps = Vue.extend({
  props: {
   propTest1: {type: String, default: () => 'Default Prop'},
   propTest2: {type: Array, default: () => ['D', 'e', 'f', 'a', 'u', 'l', 't']}
  },
});

@Component({})
export default class ArrayPropsExample1 extends AppProps {
  test1: string;
  test2: string[];

  get computedMessage() {
    return this.test1 + ' ' + this.test2;
  }
}
</script>
