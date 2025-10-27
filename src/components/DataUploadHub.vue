<script lang="ts">
import {defineComponent, PropType} from 'vue'
import UploadCard from './UploadCard.vue'
import UploadPanel from './UploadPanel.vue'


export default defineComponent({
  name: "DataUploadHub",

  components: {
    UploadCard,
    UploadPanel
  },

  data() {
    return {
      activeTab: 'order', // 현재 활성화 탭
      currentDate: new Date().toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      }), // 일단 고정 값

      allCards: [
        {
          id: 1,
          category: 'order',
          title: '서열원본 업로드 (G/D)',
          description: '기본 서열 데이터를 업로드합니다.',
          fileType: 'CSV',
          apiUrl: '/api/v1/upload/plan'
        },
        {
          id: 2,
          category: 'order',
          title: '출고 조정값 업로드',
          description: '출고 관련 조정 데이터를 업로드합니다.',
          fileType: 'CSV',
          apiUrl: '/api/v1/upload/outbound/second'
        },
        {
          id: 3,
          category: 'order',
          title: '고객-국내 재고 업데이트',
          description: '재고 오류를 수정합니다.',
          fileType: 'CSV',
          apiUrl: '/api/v1/upload/line/customer/stock'
        },
        {
          id: 4,
          category: 'production',
          title: '운영계획 원본 업로드',
          description: '운영계획 원본 데이터를 업로드합니다.',
          fileType: 'CSV',
          apiUrl: '/api/v1/upload/operation/plan',
          theme: 'orange'
        },
      ],
      isPanelOpen: false,
      selectedCard: null as CardData | null
    };
  },

  computed: {
    filteredCards() {
      return this.allCards.filter(card => card.category === this.activeTab);
    }
  },

  methods: {
    openUploadPanel(card: CardData){
      this.isPanelOpen = true
      this.selectedCard = card
    },
    closeUploadPanel(){
      this.isPanelOpen = false
      this.selectedCard = null
    }
  }
})
</script>

<template>
  <div class="hub-container">
    <header class="hub-header">
      <div class="header-left">
        <span class="bi bi-cloud-arrow-up-fill logo-icon" aria-hidden="true"></span>
        <h2>세원전자 데이터 업로드 허브</h2>
      </div>
      <div class="header-right">
        <span>{{ currentDate }}</span>
      </div>
    </header>

    <div class="tabs">
      <button
          :class="{ active: activeTab === 'order' }"
          @click="activeTab = 'order'">  <!-- 참 일 때  active 클래스가 붙음, 클릭 시 activeTab 값 변경-->
        영업파트
      </button>
      <button
          :class="{ active: activeTab === 'production' }"
          @click="activeTab = 'production'">
        생산관리
      </button>
    </div>

    <main class="card-list-wrapper">
      <div class="card-list">
        <UploadCard
            v-for="card in filteredCards"
            :key="card.id"
            :card-data="card"
            @open-panel-request="openUploadPanel(card)"
        />
      </div>
    </main>

    <UploadPanel v-if="isPanelOpen"
                :card-data="selectedCard"
                @close="closeUploadPanel"
    />
  </div>
</template>

<style scoped>
/* 이 CSS는 이 파일(DataUploadHub.vue) 안에서만 적용됩니다. */
.hub-container {
  font-family: Arial, sans-serif;
  padding: 24px;
  background-color: #f4f7f6;
  max-width: 1200px;
  margin: 0 auto;
}

.hub-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-left .logo {
  font-size: 24px;
}

.header-left h2 {
  font-size: 20px;
  margin: 0;
  color: #222;
}

.header-left nav {
  color: #555;
  cursor: pointer;
}

.header-right {
  color: #888;
}

.tabs button {
  padding: 10px 20px;
  font-size: 16px;
  border: none;
  background-color: transparent;
  color: #888;
  cursor: pointer;
  border-bottom: 2px solid transparent;
}

.tabs button.active {
  color: #4a69ff;
  font-weight: bold;
  border-bottom: 2px solid #4a69ff;
}

.card-list-wrapper {
  position: relative;
  margin-top: 20px;
}

.card-list {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
  padding: 10px 0;
}

.logo-icon {
  font-size: 24px; /* 기존 이모지 크기와 맞춤 */
  color: #4a69ff; /* 버튼과 동일한 파란색 */
  vertical-align: middle; /* 텍스트와 세로 정렬 */
}
</style>