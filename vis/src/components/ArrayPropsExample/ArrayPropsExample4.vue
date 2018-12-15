<template>
  <p>Example4 {{computedMessage}}</p>
</template>

<script lang="ts">
// following the pattern from this egghead video
// https://egghead.io/lessons/vue-js-use-properties-in-vue-components-using-prop-decorator-with-typescript
// seems unnecessarily convoluted to me and breaks everything up.

import Vue from 'vue';
import Component from 'vue-class-component';

class ArrayProps extends Vue {
  test1: string;
  test2: string[];
}

@Component({
  props: {
   test1: {type: String, default: () => 'Default Prop'},
   test2: {type: Array, default: () => ['D', 'e', 'f', 'a', 'u', 'l', 't']}
  },
})
export default class ArrayPropsExample4 extends ArrayProps {
  get computedMessage() {
    return this.test1 + ' ' + this.test2;
  }
}
</script>
