<script lang="ts">
import {defineComponent, type PropType } from 'vue'



// 뷰 컴포넌트 옵션 정의
export default defineComponent({
  name: "UploadCard",

  props: {
    cardData: {
      type: Object as PropType<CardData>,
      required: true
    },
    // 갱신 버튼 표시 여부를 결정하는 prop
    showRefresh: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onUploadClick(){
      this.$emit('open-panel-request')
    },

    onRefreshClick(){
      this.$emit('open-date-picker')
    }
  }
})
</script>

<template>
<div class="upload-card">
  <div class="card-header">
    <span class="file-icon bi bi-file-earmark-arrow-up-fill"></span>
    <div class="tags">
      <button
          v-if="showRefresh"
          class="refresh-icon-button"
          @click.stop="onRefreshClick"
          title="갱신하기"
      >
        <span class="bi bi-arrow-clockwise" aria-hidden="true"></span>
      </button>
      <span class="tag tag-csv">
        {{ cardData.fileType }}
      </span>
    </div>
  </div>

  <div class="card-body">
    <h3>{{ cardData.title }}</h3>
    <p>{{ cardData.description }}</p>
  </div>

  <button class="upload-button" @click="onUploadClick">
    <span class="bi bi-upload" aria-hidden="true"> 업로드</span>
  </button>
</div>
</template>

<style scoped>
/* 이 CSS는 '카드 1개'에만 적용됩니다. */
.upload-card {
  background-color: white;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
  padding: 20px;
  min-width: 280px; /* 카드의 최소 너비 */
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}
.file-icon {
  font-size: 24px;
  background-color: #eef2ff;
  color: #4a69ff;
  border-radius: 4px;
  padding: 4px 8px;
}
.tags { display: flex; gap: 8px; /* [변경] 아이콘과 태그 사이 간격 */
  align-items: center; /* [추가] 아이콘과 태그 세로 정렬 */ }
.tag { font-size: 12px; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
.tag-csv { background-color: #f0f0f0; color: #777; }
.card-body h3 { font-size: 18px; margin: 0 0 8px 0; color: #333; }
.card-body p { font-size: 14px; color: #666; margin: 0 0 20px 0; }
.upload-button {
  background-color: #4a69ff;
  color: white;
  border: none;
  border-radius: 6px;
  padding: 12px 0;
  width: 100%;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
}
.upload-button:hover { background-color: #3a5ae0; }

/* [추가] 상단 아이콘 버튼 스타일 */
.refresh-icon-button {
  background: none;
  border: none;
  padding: 0;
  margin: 0;
  cursor: pointer;
  color: #444; /* 아이콘 색상 (회색) */
  font-size: 20px; /* 아이콘 크기 */
  font-weight: 700; /* 굵게 */
  line-height: 1; /* 아이콘이 태그와 잘 정렬되도록 */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px; /* 모서리 살짝 둥글게 */
}
.refresh-icon-button:hover {
  color: #4a69ff; /* 호버 시 파란색 */
}
</style>