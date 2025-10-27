<template>
  <DataUploadHub />
</template>

<script lang="ts">
// <script> 부분은 기존 코드를 그대로 두시면 됩니다.
import { defineComponent } from 'vue';
import DataUploadHub from './components/DataUploadHub.vue';

export default defineComponent({
  name: 'App',
  components: {
    DataUploadHub
  }
});
</script>

<style>
</style>