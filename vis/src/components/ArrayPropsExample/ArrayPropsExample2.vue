<template>
  <p>Example2 {{computedMessage}}</p>
</template>

<script lang="ts">
import Vue from 'vue';
import Component from 'vue-class-component';
import { Prop } from 'vue-property-decorator';

@Component
// Using the vue-property decorator and the vue-class-component.
// seems to be the cleanest approach to me

export default class ArrayPropsExample2 extends Vue {
  @Prop({ default: 'Default Prop' })
  test1: string;

  @Prop({ default: () => ['D', 'e', 'f', 'a', 'u', 'l', 't']})
  test2: string[];

  get computedMessage() {
    return `${this.test1} ${this.test2} length=${this.test2.length}` ;
  }
}
</script>
